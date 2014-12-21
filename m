Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 510B07F4E
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 15:30:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 314C4304039
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 13:30:31 -0800 (PST)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
	[209.85.215.49]) by cuda.sgi.com with ESMTP id PCgb9DgTknagVxxg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Dec 2014 13:30:26 -0800 (PST)
Received: by mail-la0-f49.google.com with SMTP id hs14so3173069lab.36
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 13:30:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54972FD0.5010601@gmail.com>
References: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
	<54972FD0.5010601@gmail.com>
Date: Sun, 21 Dec 2014 22:30:24 +0100
Message-ID: <CAHJqNbzvuD8qW2xZ4ArhxTHD-ZfgNkUH=_ioy4gf0KQm66Dyng@mail.gmail.com>
Subject: Re: finobt option for end user
From: Alphazo <alphazo@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1166373140708693629=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

--===============1166373140708693629==
Content-Type: multipart/alternative; boundary=001a1134930e5f3467050ac0a650

--001a1134930e5f3467050ac0a650
Content-Type: text/plain; charset=UTF-8

Thanks for the detailed answer.
Regarding your last comment on mounting my volume read-only it might not be
possible since I update the metadatas of my pictures quite often and thus
even on older pictures. Part of my backup strategy, besides my unRAID NAS,
that BTW has recently officially switched from ReiserFS to XFS, is a
dedicated drive storing backup created by "bup" with the optional PAR2
checksum activated so I get incrementa and de-duplicated backup as well as
protection against bit-rot.

PS: I was so excited about the new XFS metadata checksum that I went ahead
and added a section about it to the ArchLinux official wiki. Now I'm trying
to figure out if the finobt bit should be added as well under the
performance section.
https://wiki.archlinux.org/index.php/XFS#Integrity


On Sun, Dec 21, 2014 at 9:38 PM, Michael L. Semon <mlsemon35@gmail.com>
wrote:

> On 12/20/14 17:52, Alphazo wrote:
> > Hello,
> >
> > I'm pretty new to XFS. I'm considering moving away from ext4 to XFS
> because
> > of the new self-describing option, performance and reliability
> improvements
> > that XFS went through over the past year. Now I'm puzzled with the new
> free
> > inode btree option (finobt). I tried to find some documentation about it
> > but couldn't find the pros or cons. So from an end-user perspective with
> a
> > couple of TB worth of photos:
> > - Does it improve overall reliability?
> > - Does it provide faster fsck/repair?
> > - Does it improve any read or write operation?
> > - Is it safe to use and does it recover as well as with finobt=0?
> > - What is the typical case for enabling it and would you recommend using
> it
> > for any new fs creation?
> >
> > Thank you in advance for your pointers.
> > Alphazo
>
> As a user...
>
> You could try it out and see:
>
> mkfs.xfs -m crc=1,finobt=1 <block_device_to_format>
>
> Here, on old junk hardware, finobt aids greatly in multitasking on
> small-file creation.  It may not have the same effect on your hardware.
>
> finobt has given very, very little trouble since it was accepted into the
> kernel code and xfsprogs.
>
> Recovery and reliability have become roughly equal between old XFS, new
> XFS, and new XFS with finobt.  They just approach the problem in different
> ways.  With old XFS, I rely heavily on xfs_repair and xfsdump to show
> filesystem issues.  With new XFS, the kernel code is more likely to
> complain
> as the issues are happening.
>
> finobt introduces the slightest bit of overhead that might be noticed at
> the
> point of resource exhaustion.  Otherwise, its overhead might be hard to
> spot.
>
> As for safety and reliability, I'm working with kernel 3.18 with the
> drives'
> write caches shut off and using the latest xfsprogs.  It works great.  The
> new v5-superblock XFS progresses at a fast pace, and it helps greatly to
> keep up with it.  kernel 3.18 seems to be a better kernel, period.  YMMV.
>
> Try a test filesystem first and test to your liking first.  If something
> goes wrong, you should find that out in two weeks of testing the file
> system.
>
> Just curious, though, with that volume of images, is there a possibility of
> making a read-only filesystem?  That would take a lot of the safety and
> recovery issues out of the equation, even if you stick with ext4.  It would
> make your main concern to sha256sum the files so that you can check them
> later for bit-rot.
>
> Good luck!
>
> Michael
>
>

--001a1134930e5f3467050ac0a650
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the detailed answer.<div>Regarding your last co=
mment on mounting my volume read-only it might not be possible since I upda=
te the metadatas of my pictures quite often and thus even on older pictures=
. Part of my backup strategy, besides my unRAID NAS, that BTW has recently =
officially switched from ReiserFS to XFS, is a dedicated drive storing back=
up created by &quot;bup&quot; with the optional PAR2 checksum activated so =
I get incrementa and de-duplicated backup as well as protection against bit=
-rot.</div><div><br></div><div>PS: I was so excited about the new XFS metad=
ata checksum that I went ahead and added a section about it to the ArchLinu=
x official wiki. Now I&#39;m trying to figure out if the finobt bit should =
be added as well under the performance section.</div><div><a href=3D"https:=
//wiki.archlinux.org/index.php/XFS#Integrity">https://wiki.archlinux.org/in=
dex.php/XFS#Integrity</a></div><div><br></div><div><div class=3D"gmail_extr=
a"><br><div class=3D"gmail_quote">On Sun, Dec 21, 2014 at 9:38 PM, Michael =
L. Semon <span dir=3D"ltr">&lt;<a href=3D"mailto:mlsemon35@gmail.com" targe=
t=3D"_blank">mlsemon35@gmail.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">=
<div class=3D""><div class=3D"h5">On 12/20/14 17:52, Alphazo wrote:<br>
&gt; Hello,<br>
&gt;<br>
&gt; I&#39;m pretty new to XFS. I&#39;m considering moving away from ext4 t=
o XFS because<br>
&gt; of the new self-describing option, performance and reliability improve=
ments<br>
&gt; that XFS went through over the past year. Now I&#39;m puzzled with the=
 new free<br>
&gt; inode btree option (finobt). I tried to find some documentation about =
it<br>
&gt; but couldn&#39;t find the pros or cons. So from an end-user perspectiv=
e with a<br>
&gt; couple of TB worth of photos:<br>
&gt; - Does it improve overall reliability?<br>
&gt; - Does it provide faster fsck/repair?<br>
&gt; - Does it improve any read or write operation?<br>
&gt; - Is it safe to use and does it recover as well as with finobt=3D0?<br=
>
&gt; - What is the typical case for enabling it and would you recommend usi=
ng it<br>
&gt; for any new fs creation?<br>
&gt;<br>
&gt; Thank you in advance for your pointers.<br>
&gt; Alphazo<br>
<br>
</div></div>As a user...<br>
<br>
You could try it out and see:<br>
<br>
mkfs.xfs -m crc=3D1,finobt=3D1 &lt;block_device_to_format&gt;<br>
<br>
Here, on old junk hardware, finobt aids greatly in multitasking on<br>
small-file creation.=C2=A0 It may not have the same effect on your hardware=
.<br>
<br>
finobt has given very, very little trouble since it was accepted into the<b=
r>
kernel code and xfsprogs.<br>
<br>
Recovery and reliability have become roughly equal between old XFS, new<br>
XFS, and new XFS with finobt.=C2=A0 They just approach the problem in diffe=
rent<br>
ways.=C2=A0 With old XFS, I rely heavily on xfs_repair and xfsdump to show<=
br>
filesystem issues.=C2=A0 With new XFS, the kernel code is more likely to co=
mplain<br>
as the issues are happening.<br>
<br>
finobt introduces the slightest bit of overhead that might be noticed at th=
e<br>
point of resource exhaustion.=C2=A0 Otherwise, its overhead might be hard t=
o spot.<br>
<br>
As for safety and reliability, I&#39;m working with kernel 3.18 with the dr=
ives&#39;<br>
write caches shut off and using the latest xfsprogs.=C2=A0 It works great.=
=C2=A0 The<br>
new v5-superblock XFS progresses at a fast pace, and it helps greatly to<br=
>
keep up with it.=C2=A0 kernel 3.18 seems to be a better kernel, period.=C2=
=A0 YMMV.<br>
<br>
Try a test filesystem first and test to your liking first.=C2=A0 If somethi=
ng<br>
goes wrong, you should find that out in two weeks of testing the file<br>
system.<br>
<br>
Just curious, though, with that volume of images, is there a possibility of=
<br>
making a read-only filesystem?=C2=A0 That would take a lot of the safety an=
d<br>
recovery issues out of the equation, even if you stick with ext4.=C2=A0 It =
would<br>
make your main concern to sha256sum the files so that you can check them<br=
>
later for bit-rot.<br>
<br>
Good luck!<br>
<span class=3D""><font color=3D"#888888"><br>
Michael<br>
<br>
</font></span></blockquote></div><br></div></div></div>

--001a1134930e5f3467050ac0a650--


--===============1166373140708693629==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1166373140708693629==--
