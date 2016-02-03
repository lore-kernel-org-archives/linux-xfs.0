Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E4727CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 10:11:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3818C8F8049
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 08:11:14 -0800 (PST)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	PnZKh6YRfwtEXEVV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 08:11:09 -0800 (PST)
Received: by mail-ob0-f169.google.com with SMTP id ba1so36005985obb.3
	for <xfs@oss.sgi.com>; Wed, 03 Feb 2016 08:11:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160203083016.GD459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
	<20160203083016.GD459@dastard>
From: Dilip Simha <nmdilipsimha@gmail.com>
Date: Wed, 3 Feb 2016 08:10:46 -0800
Message-ID: <CAFHL4X0rkBUdtLn04sqeAdUgUfqMcSAOtEjtwupNk5KKk=owpQ@mail.gmail.com>
Subject: Re: Request for information on bloated writes using Swift
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3136269101829112727=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============3136269101829112727==
Content-Type: multipart/alternative; boundary=089e0160c2b07dedfd052adfdd85

--089e0160c2b07dedfd052adfdd85
Content-Type: text/plain; charset=UTF-8

On Wed, Feb 3, 2016 at 12:30 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
> > Hi Dave,
> >
> > On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> > > > Hi Eric,
> > > >
> > > > Thank you for your quick reply.
> > > >
> > > > Using xfs_io as per your suggestion, I am able to reproduce the
> issue.
> > > > However, I need to falloc for 256K and write for 257K to see this
> issue.
> > > >
> > > > # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
> > > > # stat /srv/node/r1/t4.txt | grep Blocks
> > > >   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
> > >
> > > Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
> > >
> > > When you writing *past the preallocated area* and do delayed
> > > allocation, the speculative preallocation beyond EOF is double the
> > > size of the extent at EOF. i.e. 512k, leading to 768k being
> > > allocated to the file (1536 blocks, exactly).
> > >
> >
> > Thank you for the details.
> > This is exactly where I am a bit perplexed. Since the reclamation logic
> > skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
> > allocation logic allot more blocks on such an inode?
>
> To store the data you wrote outside the preallocated region, of
> course.
>
> > My understanding is that the fallocate caller only requested for 256K
> worth
> > of blocks to be available sequentially if possible.
>
> fallocate only guarantees the blocks are allocated - it does not
> guarantee anything about the layout of the blocks.
>
> > On any subsequent write beyond the EOF, the caller is completely
> > unaware of the underlying file-system storing that data adjacent
> > to the first 256K data.  Since XFS is speculatively allocating
> > additional space (512K) adjacent to the first 256K data, I would
> > expect XFS to either treat these two allocations distinctly and
> > NOT mark XFS_DIFLAG_PREALLOC on the additional 512K data(minus the
> > actually used additional data=1K), OR remove XFS_DIFLAG_PREALLOC
> > flag on the entire inode.
>
> Oh, if only it were that simple. It's way more complex than I have
> time to explain here.
>
> Fundamentally, XFS_DIFLAG_PREALLOC is used to indicate that
> persistent preallocation has been done on the file, and so if that
> has happened we need to turn off optimistic removal of blocks
> anywhere in the file because we can't tell what blocks had
> persistent preallocation done on them after the fact.  That's the
> way it's been since unwritten extents were added to XFS back in
> 1998, and I don't really see the need for it to change right now.
>

I completely understand the reasoning behind this reclamation logic and I
also agree to it.
But my question is with the allocation logic. I don't understand why XFS
allocates more than necessary blocks when this flag is set and when it
knows that its not going to clean up the additional space.

A simple example would be:
1: Open File in Write mode.
2: Fallocate 256K
3: Write 256K
4: Close File

Stat shows that XFS allocated 512 blocks as expected.

5: Open file in append mode.
6: Write 256 bytes.
7: Close file.

Expectation is that the number of blocks allocated is either 512+1 or 512+8
depending on the block size.
However, XFS uses speculative preallocation to allocate 512K (as per your
explanation) to write 256 bytes and hence the overall disk usage goes up to
1536 blocks.
Now, who is responsible for clearing up the additional allocated blocks?
Clearly the application has no idea about the over-allocation.

I agree that if an application uses fallocate and delayed allocation on the
same file in the same IO, then its a badly structured application. But in
this case we have two different IOs on the same file. The first IO did not
expect an append and hence issued an fallocate. So that looks good to me.

Your thoughts on this?

Regards,
Dilip


> If an application wants to mix fallocate and delayed allocatin
> writes to the same file in the same IO, then that's an application
> bug. It's going to cause bad IO patterns and file fragmentation and
> have other side effects (as you've noticed), and there's nothing the
> filesystem can do about it. fallocate() requires expertise to use in
> a beneficial manner - most developers do not have the required
> expertise (and don't have enough expertise to realise this) and so
> usually make things worse rather than better by using fallocate.
>
> > Also, is there any way I can check for this flag?
> > The FLAGS, as observed from xfs_bmap doesn't show any flags set to it.
> Am I
> > not looking at the right flags?
>
> xfs_io -c stat <file>
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--089e0160c2b07dedfd052adfdd85
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On W=
ed, Feb 3, 2016 at 12:30 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"=
mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</=
span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, Feb=
 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:<br>
&gt; Hi Dave,<br>
&gt;<br>
&gt; On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:<br>
&gt; &gt; &gt; Hi Eric,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Thank you for your quick reply.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Using xfs_io as per your suggestion, I am able to reproduce =
the issue.<br>
&gt; &gt; &gt; However, I need to falloc for 256K and write for 257K to see=
 this issue.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; # xfs_io -f -c &quot;falloc 0 256k&quot; -c &quot;pwrite 0 2=
57k&quot; /srv/node/r1/t1.txt<br>
&gt; &gt; &gt; # stat /srv/node/r1/t4.txt | grep Blocks<br>
&gt; &gt; &gt;=C2=A0 =C2=A0Size: 263168=C2=A0 =C2=A0 =C2=A0Blocks: 1536=C2=
=A0 =C2=A0 =C2=A0 =C2=A0IO Block: 4096=C2=A0 =C2=A0regular file<br>
&gt; &gt;<br>
&gt; &gt; Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.<br>
&gt; &gt;<br>
&gt; &gt; When you writing *past the preallocated area* and do delayed<br>
&gt; &gt; allocation, the speculative preallocation beyond EOF is double th=
e<br>
&gt; &gt; size of the extent at EOF. i.e. 512k, leading to 768k being<br>
&gt; &gt; allocated to the file (1536 blocks, exactly).<br>
&gt; &gt;<br>
&gt;<br>
&gt; Thank you for the details.<br>
&gt; This is exactly where I am a bit perplexed. Since the reclamation logi=
c<br>
&gt; skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the<b=
r>
&gt; allocation logic allot more blocks on such an inode?<br>
<br>
</span>To store the data you wrote outside the preallocated region, of<br>
course.<br>
<span class=3D""><br>
&gt; My understanding is that the fallocate caller only requested for 256K =
worth<br>
&gt; of blocks to be available sequentially if possible.<br>
<br>
</span>fallocate only guarantees the blocks are allocated - it does not<br>
guarantee anything about the layout of the blocks.<br>
<span class=3D""><br>
&gt; On any subsequent write beyond the EOF, the caller is completely<br>
&gt; unaware of the underlying file-system storing that data adjacent<br>
&gt; to the first 256K data.=C2=A0 Since XFS is speculatively allocating<br=
>
&gt; additional space (512K) adjacent to the first 256K data, I would<br>
&gt; expect XFS to either treat these two allocations distinctly and<br>
&gt; NOT mark XFS_DIFLAG_PREALLOC on the additional 512K data(minus the<br>
&gt; actually used additional data=3D1K), OR remove XFS_DIFLAG_PREALLOC<br>
&gt; flag on the entire inode.<br>
<br>
</span>Oh, if only it were that simple. It&#39;s way more complex than I ha=
ve<br>
time to explain here.<br>
<br>
Fundamentally, XFS_DIFLAG_PREALLOC is used to indicate that<br>
persistent preallocation has been done on the file, and so if that<br>
has happened we need to turn off optimistic removal of blocks<br>
anywhere in the file because we can&#39;t tell what blocks had<br>
persistent preallocation done on them after the fact.=C2=A0 That&#39;s the<=
br>
way it&#39;s been since unwritten extents were added to XFS back in<br>
1998, and I don&#39;t really see the need for it to change right now.<br></=
blockquote><div><br></div><div>I completely understand the reasoning behind=
 this reclamation logic and I also agree to it.</div><div>But my question i=
s with the allocation logic. I don&#39;t understand why XFS allocates more =
than necessary blocks when this flag is set and when it knows that its not =
going to clean up the additional space.</div><div><br></div><div>A simple e=
xample would be:</div><div>1: Open File in Write mode.</div><div>2: Falloca=
te 256K</div><div>3: Write 256K</div><div>4: Close File</div><div><br></div=
><div>Stat shows that XFS allocated 512 blocks as expected.</div><div><br><=
/div><div>5: Open file in append mode.</div><div>6: Write 256 bytes.</div><=
div>7: Close file.</div><div><br></div><div>Expectation is that the number =
of blocks allocated is either 512+1 or 512+8 depending on the block size.</=
div><div>However, XFS uses speculative preallocation to allocate 512K (as p=
er your explanation) to write 256 bytes and hence the overall disk usage go=
es up to 1536 blocks.</div><div>Now, who is responsible for clearing up the=
 additional allocated blocks? Clearly the application has no idea about the=
 over-allocation.</div><div><br></div><div>I agree that if an application u=
ses fallocate and delayed allocation on the same file in the same IO, then =
its a badly structured application. But in this case we have two different =
IOs on the same file. The first IO did not expect an append and hence issue=
d an fallocate. So that looks good to me.</div><div><br></div><div>Your tho=
ughts on this?</div><div><br></div><div>Regards,</div><div>Dilip</div><div>=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">
<br>
If an application wants to mix fallocate and delayed allocatin<br>
writes to the same file in the same IO, then that&#39;s an application<br>
bug. It&#39;s going to cause bad IO patterns and file fragmentation and<br>
have other side effects (as you&#39;ve noticed), and there&#39;s nothing th=
e<br>
filesystem can do about it. fallocate() requires expertise to use in<br>
a beneficial manner - most developers do not have the required<br>
expertise (and don&#39;t have enough expertise to realise this) and so<br>
usually make things worse rather than better by using fallocate.<br>
<span class=3D""><br>
&gt; Also, is there any way I can check for this flag?<br>
&gt; The FLAGS, as observed from xfs_bmap doesn&#39;t show any flags set to=
 it. Am I<br>
&gt; not looking at the right flags?<br>
<br>
</span>xfs_io -c stat &lt;file&gt;<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--089e0160c2b07dedfd052adfdd85--


--===============3136269101829112727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3136269101829112727==--
