Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A309929DF5
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 21:42:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98053304039
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 19:42:28 -0800 (PST)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	ckbAgLFEMXcApfbI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 19:42:26 -0800 (PST)
Received: by mail-ob0-f175.google.com with SMTP id ba1so12611850obb.3
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2016 19:42:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
From: Dilip Simha <nmdilipsimha@gmail.com>
Date: Tue, 2 Feb 2016 19:42:06 -0800
Message-ID: <CAFHL4X3c2Rkj0G_C_tQp79j7kFow2cB-V_Pq5L0Scmh3iv4+ig@mail.gmail.com>
Subject: Re: Request for information on bloated writes using Swift
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0394349846090226295=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============0394349846090226295==
Content-Type: multipart/alternative; boundary=089e0160c2b00e69b9052ad568ee

--089e0160c2b00e69b9052ad568ee
Content-Type: text/plain; charset=UTF-8

Apologies:
Small correction:

The stat was taken on t1.txt but mistakenly printed it as t4.txt.

On Tue, Feb 2, 2016 at 7:40 PM, Dilip Simha <nmdilipsimha@gmail.com> wrote:

> Hi Eric,
>
> Thank you for your quick reply.
>
> Using xfs_io as per your suggestion, I am able to reproduce the issue.
> However, I need to falloc for 256K and write for 257K to see this issue.
>
> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
> # stat /srv/node/r1/t4.txt | grep Blocks
>   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
>
> # xfs_io -f -c "pwrite 0 257k" /srv/node/r1/t2.txt
> # stat  /srv/node/r1/t2.txt | grep Blocks
> Size: 263168    *Blocks*: 520        IO Block: 4096   regular file
>
> # xfs_info /srv/node/r1
> meta-data=/dev/mapper/35000cca05831283c-part2 isize=256    agcount=4,
> agsize=183141504 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=732566016, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=357698, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> # cat /proc/mounts | grep r1
>
> /dev/mapper/35000cca05831283c-part2 /srv/node/*r1* xfs
> rw,nosuid,nodev,noexec,noatime,nodiratime,attr2,inode64,logbufs=8,noquota 0
> 0
> I waited for around 15 mins before collecting the stat output to give the
> background reclamation logic a fair chance to do its job. I also tried
> changing the value of speculative_prealloc_lifetime from 300 to 10. But it
> was of no use.
>
> cat /proc/sys/fs/xfs/speculative_prealloc_lifetime
> 10
>
> Regards,
> Dilip
>
> On Tue, Feb 2, 2016 at 6:47 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>>
>>
>> On 2/2/16 4:32 PM, Dilip Simha wrote:
>> > Hi,
>> >
>> > I have a question regarding speculated preallocation in XFS, w.r.t
>> > kernel version: 3.16.0-46-generic. I am using Swift version: 1.0 and
>> > mkfs.xfs version 3.2.1
>> >
>> > When I write a 256KiB file to Swift, I see that the underlying XFS
>> > uses 3x the amount of space/blocks to write that data. Upon
>> > performing detailed experiments, I see that when Swift uses fallocate
>> > (default approach), XFS doesn't reclaim the preallocated blocks that
>> > XFS allocated. Swift fallocate doesn't exceed the body size(256
>> > KiB).
>> >
>> > Interestingly, when either allocsize=4k or when swift doesn't use
>> > fallocate, XFS doesn't consume additional space.
>> >
>> > Can you please let me know if this is a known bug and if its fixed in
>> > the later versions?
>>
>> Can you clarify the exact sequence of events?
>>
>> i.e. -
>>
>> xfs_io -f -c "fallocate 0 256k" -c "pwrite 0 256k" somefile
>>
>> leads to unreaclaimed preallocation, while
>>
>> xfs_io -f -c "pwrite 0 256k" somefile
>>
>> does not?  Or is it some other sequence?  I don't have a
>> 3.16 handy to test, but if you can describe it in more detail
>> that'd help.  Some of this is influenced by fs geometry, too
>> so xfs_info output would be good, along with any mount options
>> you might be using.
>>
>> Are you preallocating with or without KEEP_SIZE?
>>
>> -Eric
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>

--089e0160c2b00e69b9052ad568ee
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Apologies:<div>Small correction:<div><br></div><div>The st=
at was taken on t1.txt but mistakenly printed it as t4.txt.=C2=A0</div></di=
v></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, F=
eb 2, 2016 at 7:40 PM, Dilip Simha <span dir=3D"ltr">&lt;<a href=3D"mailto:=
nmdilipsimha@gmail.com" target=3D"_blank">nmdilipsimha@gmail.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hi Eric,<div=
><br></div><div>Thank you for your quick reply.<br></div><div><br></div><di=
v>Using xfs_io as per your suggestion, I am able to reproduce the issue. Ho=
wever, I need to falloc for 256K and write for 257K to see this issue.<br><=
/div><div><br></div><div><div># xfs_io -f -c &quot;falloc 0 256k&quot; -c &=
quot;pwrite 0 257k&quot; /srv/node/r1/t1.txt</div><div># stat /srv/node/r1/=
t4.txt | grep Blocks</div><div>=C2=A0 Size: 263168 =C2=A0 =C2=A0<span style=
=3D"white-space:pre-wrap">	</span>Blocks: 1536 =C2=A0 =C2=A0 =C2=A0 IO Bloc=
k: 4096 =C2=A0 regular file</div></div><div>







<p><span># xfs_io -f -c &quot;pwrite 0 257k&quot; /srv/node/r1/t2.txt</span=
></p><div># stat=C2=A0 /srv/node/r1/t2.txt | grep Blocks<br></div><div>Size=
: 263168=C2=A0 =C2=A0=C2=A0<b>Blocks</b>: 520=C2=A0 =C2=A0 =C2=A0 =C2=A0 IO=
 Block: 4096 =C2=A0 regular file</div></div><div><br></div><div><div># xfs_=
info /srv/node/r1</div><div>meta-data=3D/dev/mapper/35000cca05831283c-part2=
 isize=3D256 =C2=A0 =C2=A0agcount=3D4, agsize=3D183141504 blks</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2, pro=
jid32bit=3D1</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crc=3D0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0finobt=3D0</div><div>data =C2=A0 =C2=A0 =3D =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=
=3D4096 =C2=A0 blocks=3D732566016, imaxpct=3D5</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swidth=3D0 blks</div=
><div>naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0 ftype=3D0</div><div>log =C2=A0 =C2=
=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsiz=
e=3D4096 =C2=A0 blocks=3D357698, version=3D2</div><div>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blks, lazy-count=3D1</di=
v><div>realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0</div></div><div=
><br></div><div>







<p><span># cat /proc/mounts | grep r1</span></p><p><span>/dev/mapper/35000c=
ca05831283c-part2 /srv/node/</span><span><b>r1</b></span><span> xfs rw,nosu=
id,nodev,noexec,noatime,nodiratime,attr2,inode64,logbufs=3D8,noquota 0 0</s=
pan></p></div><div>I waited for around 15 mins before collecting the stat o=
utput to give the background reclamation logic a fair chance to do its job.=
 I also tried changing the value of speculative_prealloc_lifetime from 300 =
to 10. But it was of no use.</div><div>







<div><br></div><div>cat /proc/sys/fs/xfs/speculative_prealloc_lifetime<br><=
/div><div>10</div></div><div><br></div><div>Regards,</div><div>Dilip</div><=
div><div class=3D"h5"><div class=3D"gmail_extra"><br><div class=3D"gmail_qu=
ote">On Tue, Feb 2, 2016 at 6:47 PM, Eric Sandeen <span dir=3D"ltr">&lt;<a =
href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);b=
order-left-style:solid;padding-left:1ex"><span><br>
<br>
On 2/2/16 4:32 PM, Dilip Simha wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I have a question regarding speculated preallocation in XFS, w.r.t<br>
&gt; kernel version: 3.16.0-46-generic. I am using Swift version: 1.0 and<b=
r>
&gt; mkfs.xfs version 3.2.1<br>
&gt;<br>
&gt; When I write a 256KiB file to Swift, I see that the underlying XFS<br>
&gt; uses 3x the amount of space/blocks to write that data. Upon<br>
&gt; performing detailed experiments, I see that when Swift uses fallocate<=
br>
&gt; (default approach), XFS doesn&#39;t reclaim the preallocated blocks th=
at<br>
&gt; XFS allocated. Swift fallocate doesn&#39;t exceed the body size(256<br=
>
&gt; KiB).<br>
&gt;<br>
&gt; Interestingly, when either allocsize=3D4k or when swift doesn&#39;t us=
e<br>
&gt; fallocate, XFS doesn&#39;t consume additional space.<br>
&gt;<br>
&gt; Can you please let me know if this is a known bug and if its fixed in<=
br>
&gt; the later versions?<br>
<br>
</span>Can you clarify the exact sequence of events?<br>
<br>
i.e. -<br>
<br>
xfs_io -f -c &quot;fallocate 0 256k&quot; -c &quot;pwrite 0 256k&quot; some=
file<br>
<br>
leads to unreaclaimed preallocation, while<br>
<br>
xfs_io -f -c &quot;pwrite 0 256k&quot; somefile<br>
<br>
does not?=C2=A0 Or is it some other sequence?=C2=A0 I don&#39;t have a<br>
3.16 handy to test, but if you can describe it in more detail<br>
that&#39;d help.=C2=A0 Some of this is influenced by fs geometry, too<br>
so xfs_info output would be good, along with any mount options<br>
you might be using.<br>
<br>
Are you preallocating with or without KEEP_SIZE?<br>
<br>
-Eric<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br></div></div></div></div>
</blockquote></div><br></div>

--089e0160c2b00e69b9052ad568ee--


--===============0394349846090226295==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0394349846090226295==--
