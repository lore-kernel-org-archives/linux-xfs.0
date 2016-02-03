Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E46C87CA4
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 01:09:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA9AE304053
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 23:09:37 -0800 (PST)
Received: from mail-ob0-f171.google.com (mail-ob0-f171.google.com
	[209.85.214.171]) by cuda.sgi.com with ESMTP id
	EwtmP0RCKBaZMYQ1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 23:09:35 -0800 (PST)
Received: by mail-ob0-f171.google.com with SMTP id xk3so17691964obc.2
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2016 23:09:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160203063705.GB459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
From: Dilip Simha <nmdilipsimha@gmail.com>
Date: Tue, 2 Feb 2016 23:09:15 -0800
Message-ID: <CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
Subject: Re: Request for information on bloated writes using Swift
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1114282533237038906=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============1114282533237038906==
Content-Type: multipart/alternative; boundary=001a11c301dce56573052ad84c24

--001a11c301dce56573052ad84c24
Content-Type: text/plain; charset=UTF-8

Hi Dave,

On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> > Hi Eric,
> >
> > Thank you for your quick reply.
> >
> > Using xfs_io as per your suggestion, I am able to reproduce the issue.
> > However, I need to falloc for 256K and write for 257K to see this issue.
> >
> > # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
> > # stat /srv/node/r1/t4.txt | grep Blocks
> >   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
>
> Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
>
> When you writing *past the preallocated area* and do delayed
> allocation, the speculative preallocation beyond EOF is double the
> size of the extent at EOF. i.e. 512k, leading to 768k being
> allocated to the file (1536 blocks, exactly).
>

Thank you for the details.
This is exactly where I am a bit perplexed. Since the reclamation logic
skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
allocation logic allot more blocks on such an inode?
My understanding is that the fallocate caller only requested for 256K worth
of blocks to be available sequentially if possible. On any subsequent write
beyond the EOF, the caller is completely unaware of the underlying
file-system storing that data adjacent to the first 256K data. Since XFS is
speculatively allocating additional space (512K) adjacent to the first 256K
data, I would expect XFS to either treat these two allocations distinctly
and NOT mark XFS_DIFLAG_PREALLOC on the additional 512K data(minus the
actually used additional data=1K), OR remove XFS_DIFLAG_PREALLOC flag on
the entire inode.

Also, is there any way I can check for this flag?
The FLAGS, as observed from xfs_bmap doesn't show any flags set to it. Am I
not looking at the right flags?

# xfs_bmap -lpv
/srv/node/r16/objects/10/ff3/55517cd029bee36151a5098ce7cdeff3/1453771923.11401.data
/srv/node/r16/objects/10/ff3/55517cd029bee36151a5098ce7cdeff3/1453771923.11401.data:
EXT: FILE-OFFSET BLOCK-RANGE AG AG-OFFSET TOTAL FLAGS
0: [0..1535]: 1465876416..1465877951 1 (744384..745919) 1536 00000

Thanks & Regards,
Dilip


> This is expected behaviour.
>
> > # xfs_io -f -c "pwrite 0 257k" /srv/node/r1/t2.txt
> > # stat  /srv/node/r1/t2.txt | grep Blocks
> > Size: 263168    *Blocks*: 520        IO Block: 4096   regular file
>
> So pure delayed allocation, specualtive preallocation starts at 64k
> file size, so it would have been (((64k + 64K) + 128K) + 256k) =
> 768k.
>
>
> > I waited for around 15 mins before collecting the stat output to give the
> > background reclamation logic a fair chance to do its job. I also tried
> > changing the value of speculative_prealloc_lifetime from 300 to 10. But
> it
> > was of no use.
>
> The prealloc cleaner skips inodes with XFS_DIFLAG_PREALLOC set on
> them.
>
> Because the XFS_DIFLAG_PREALLOC flag is not set on the delayed
> allocation inode, the EOF blocks cleaner runs truncates it to EOF,
> and 260k (520 blocks) remains allocated to the file.
>
> i.e. you are seeing behaviour exactly as designed and intended.
>
> The way swift is using fallocate is actively harmful. You do not
> want preallocation for write once files - this is exactly the
> workload that delayed allocation was designed to be optimal for as
> delayed allocation sequentialises the IO from multiple files.
>
> Using preallocation means writeback of the data cannot be optimised
> across files as the preallocation location will not be sequential to
> the IO that was just issued, hence writeback will seek the disks
> back and forth instead of seeing a nice sequential IO stream.
>
> <sigh>
>
> Yet another way that the swift storage back end tries to be smart
> but ends up just making things go slow....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c301dce56573052ad84c24
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <span dir=3D"ltr">&lt=
;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.c=
om</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,20=
4);border-left-style:solid;padding-left:1ex"><span class=3D"">On Tue, Feb 0=
2, 2016 at 07:40:34PM -0800, Dilip Simha wrote:<br>
&gt; Hi Eric,<br>
&gt;<br>
&gt; Thank you for your quick reply.<br>
&gt;<br>
&gt; Using xfs_io as per your suggestion, I am able to reproduce the issue.=
<br>
&gt; However, I need to falloc for 256K and write for 257K to see this issu=
e.<br>
&gt;<br>
&gt; # xfs_io -f -c &quot;falloc 0 256k&quot; -c &quot;pwrite 0 257k&quot; =
/srv/node/r1/t1.txt<br>
&gt; # stat /srv/node/r1/t4.txt | grep Blocks<br>
&gt;=C2=A0 =C2=A0Size: 263168=C2=A0 =C2=A0 =C2=A0Blocks: 1536=C2=A0 =C2=A0 =
=C2=A0 =C2=A0IO Block: 4096=C2=A0 =C2=A0regular file<br>
<br>
</span>Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.<br>
<br>
When you writing *past the preallocated area* and do delayed<br>
allocation, the speculative preallocation beyond EOF is double the<br>
size of the extent at EOF. i.e. 512k, leading to 768k being<br>
allocated to the file (1536 blocks, exactly).<br></blockquote><div><br></di=
v><div>Thank you for the details.<br></div><div>This is exactly where I am =
a bit perplexed. Since the reclamation logic skips inodes that have the XFS=
_DIFLAG_PREALLOC flag set, why did the allocation logic allot more blocks o=
n such an inode?</div><div>My understanding is that the fallocate caller on=
ly requested for 256K worth of blocks to be available sequentially if possi=
ble. On any subsequent write beyond the EOF, the caller is completely unawa=
re of the underlying file-system storing that data adjacent to the first 25=
6K data. Since XFS is speculatively allocating additional space (512K) adja=
cent to the first 256K data, I would expect XFS to either treat these two a=
llocations distinctly and NOT mark XFS_DIFLAG_PREALLOC on the additional 51=
2K data(minus the actually used additional data=3D1K), OR remove XFS_DIFLAG=
_PREALLOC flag on the entire inode.</div><div><br></div><div>Also, is there=
 any way I can check for this flag?</div><div>The FLAGS, as observed from x=
fs_bmap doesn&#39;t show any flags set to it. Am I not looking at the right=
 flags?=C2=A0</div><div><br></div><div><div># xfs_bmap -lpv /srv/node/r16/o=
bjects/10/ff3/55517cd029bee36151a5098ce7cdeff3/1453771923.11401.data</div><=
div>/srv/node/r16/objects/10/ff3/55517cd029bee36151a5098ce7cdeff3/145377192=
3.11401.data:</div><div>EXT: FILE-OFFSET BLOCK-RANGE AG AG-OFFSET TOTAL FLA=
GS</div><div>0: [0..1535]: 1465876416..1465877951 1 (744384..745919) 1536 0=
0000</div><div><br></div></div><div>Thanks &amp; Regards,</div><div>Dilip</=
div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex">
<br>
This is expected behaviour.<br>
<span class=3D""><br>
&gt; # xfs_io -f -c &quot;pwrite 0 257k&quot; /srv/node/r1/t2.txt<br>
&gt; # stat=C2=A0 /srv/node/r1/t2.txt | grep Blocks<br>
</span>&gt; Size: 263168=C2=A0 =C2=A0 *Blocks*: 520=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 IO Block: 4096=C2=A0 =C2=A0regular file<br>
<br>
So pure delayed allocation, specualtive preallocation starts at 64k<br>
file size, so it would have been (((64k + 64K) + 128K) + 256k) =3D<br>
768k.<br>
<span class=3D""><br>
<br>
&gt; I waited for around 15 mins before collecting the stat output to give =
the<br>
&gt; background reclamation logic a fair chance to do its job. I also tried=
<br>
&gt; changing the value of speculative_prealloc_lifetime from 300 to 10. Bu=
t it<br>
&gt; was of no use.<br>
<br>
</span>The prealloc cleaner skips inodes with XFS_DIFLAG_PREALLOC set on<br=
>
them.<br>
<br>
Because the XFS_DIFLAG_PREALLOC flag is not set on the delayed<br>
allocation inode, the EOF blocks cleaner runs truncates it to EOF,<br>
and 260k (520 blocks) remains allocated to the file.<br>
<br>
i.e. you are seeing behaviour exactly as designed and intended.<br>
<br>
The way swift is using fallocate is actively harmful. You do not<br>
want preallocation for write once files - this is exactly the<br>
workload that delayed allocation was designed to be optimal for as<br>
delayed allocation sequentialises the IO from multiple files.<br>
<br>
Using preallocation means writeback of the data cannot be optimised<br>
across files as the preallocation location will not be sequential to<br>
the IO that was just issued, hence writeback will seek the disks<br>
back and forth instead of seeing a nice sequential IO stream.<br>
<br>
&lt;sigh&gt;<br>
<br>
Yet another way that the swift storage back end tries to be smart<br>
but ends up just making things go slow....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D""><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div></div>

--001a11c301dce56573052ad84c24--


--===============1114282533237038906==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1114282533237038906==--
