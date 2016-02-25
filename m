Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 69CCD7F92
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 14:57:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F9908F8033
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 12:57:25 -0800 (PST)
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com
	[209.85.161.171]) by cuda.sgi.com with ESMTP id
	dle4fYuT2rj9R5cr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Feb 2016 12:57:22 -0800 (PST)
Received: by mail-yw0-f171.google.com with SMTP id h129so53225535ywb.1
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 12:57:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160224061258.GA19107@birch.djwong.org>
References: <CADUjHbXfFEVVk661XMEoAOUM+pQs0LdQh3xFVx6_5tsLZP+P2g@mail.gmail.com>
	<20160224061258.GA19107@birch.djwong.org>
Date: Thu, 25 Feb 2016 15:57:22 -0500
Message-ID: <CADUjHbUUYuHxuk-hcn1U2_vtBhU0fs_57cQXQ-iCdhr2GL3t0Q@mail.gmail.com>
Subject: Re: Accidental FS corruption: Mapping files to blocks
From: Paul Cannon <paul.cannon3128@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7602976909804083498=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7602976909804083498==
Content-Type: multipart/alternative; boundary=001a1141f788cb7d69052c9e6d85

--001a1141f788cb7d69052c9e6d85
Content-Type: text/plain; charset=UTF-8

Darrick,

A million thanks! The xfs_db commands you sent worked.

Here is the surgery I did. First rsync with -c was taking too long (more
than a day with no reports as the data is 30+ TBs) and also --ignore-times
did not give any information.

So I used the xfs_db commands you had mentioned. It gave me a list of files
in affected space. When I do a "diff -rq" with original data and the data
in the corrupted space -- BAM! I see files are indeed different! Now I am
going to delete the corrupted directory and copy from the old data archive.

Thanks!

Paul

On Wed, Feb 24, 2016 at 1:12 AM, Darrick J. Wong <darrick.wong@oracle.com>
wrote:

> On Tue, Feb 23, 2016 at 10:37:36PM -0500, Paul Cannon wrote:
> > I have accidentally damaged my XFS, and need help (and a little prayer).
> > The way it happened will provide your daily amusement dose (and
> hopefully a
> > lesson).
> >
> > * What happened?
> > I have two file systems xfsA (18 TBs on /dev/sdc1) and xfsB (36 TBs on
> > /dev/sdd1). They were mounted and working fine. I accidentally executed
> an
> > old script that effectively ran the following command:
> > >ddrescue /dev/sdc /dev/sdd sdc_sdd.log
> > For those unfamiliar with the ddrescue command, it claims to rescue/image
> > data from a drive A to B. It does multiple passes to rescue data with
> > maximum efficiency.
> >
> > * Why did I do it?
> > I am careless or dumb or may be a combination of both. But the fact that
> > drives got remapped (sdc/sdd became sde/sdf and otherway around) might
> also
> > be part of it.
> >
> > * What happened to XFS on sdd (xfsB)?
> > Luckily, the imaging started with an offset of about 2.7 TBs. Why?
> Because
> > this was a restart of ddrescue and it started from past point. IT WROTE a
> > total of 6.1 GBs of data on sdd/xfsB
> >
> > So I quickly stopped as I realized my mistake. I ran xfs_repair on xfsB.
> > Due to the offset of 2.7 TBs, metadata seemed fine. The xfs_repair shows
> > everything is fine. But if I extract out data using (dd skip=2.7TB) into
> a
> > file -- I can see things are different! I recognize the abrupt change in
> a
> > text file, exactly where the data overwritten.
> >
> > * Luckily I have old copy of the original data!
>
> Good for you!  Seriously. :D
>
> > So I did a rsync -rvn /olddata/ /xfsB
> > Nothing! No difference in any data files. I even tried mirrordir, same
> > thing -- nothing, no difference!
>
> rsync -c to force it to checksum the data blocks?
>
> By default I think it only compares file size and timestamps.
>
> > * Here is what I think is going on, and I need help.
> > I suspect that the access time of the file/files stored at this location
> > are perhaps in another location in inode (does this sound correct? I am a
> > newbie to XFS). But the data itself has changed at the location.
>
> Quite possible.
>
> > * QUESTION: How do I find what files were stored at the location? I have
> an
> > EXACT location of the range affected. Once I find the affected files, I
> can
> > perhaps do further surgery.
>
> Sounds like something that the reverse-mapping btree and associated
> GETFSMAP
> ioctl could help solve ... too bad it only exists as experimental patches
> to
> the on-disk format. :(
>
> In the meantime, I guess you could umount the filesystem and run xfs_db on
> it
> to find out what was in the areas that got overwritten, assuming rsync -c
> also
> shows no difference.  Something along the lines of:
>
> # xfs_db /dev/sdXX
> xfs_db> blockget -n
> xfs_db> fsblock <block number of where the overwritten area starts>
> xfs_db> blockuse -n -c <number of blocks you think got overwritten>
>
> Have a look at the xfs_db manpage for more info on what those commands do.
>
> --D
>
> >
> > Any help (and prayers) will be highly appreciated.
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--001a1141f788cb7d69052c9e6d85
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:16px">Darrick,=C2=A0</span><div s=
tyle=3D"font-size:16px"><br></div><div style=3D"font-size:16px">A million t=
hanks! The xfs_db commands you sent worked.</div><div style=3D"font-size:16=
px"><br></div><div style=3D"font-size:16px">Here is the surgery I did. Firs=
t rsync with -c was taking too long (more than a day with no reports as the=
 data is 30+ TBs) and also --ignore-times did not give any information.=C2=
=A0</div><div style=3D"font-size:16px"><br></div><div style=3D"font-size:16=
px">So I used the xfs_db commands you had mentioned. It gave me a list of f=
iles in affected space. When I do a &quot;diff -rq&quot; with original data=
 and the data in the corrupted space -- BAM! I see files are indeed differe=
nt! Now I am going to delete the corrupted directory and copy from the old =
data archive.</div><div style=3D"font-size:16px"><br></div><div style=3D"fo=
nt-size:16px">Thanks!</div><div style=3D"font-size:16px"><br></div><div sty=
le=3D"font-size:16px">Paul</div></div><div class=3D"gmail_extra"><br><div c=
lass=3D"gmail_quote">On Wed, Feb 24, 2016 at 1:12 AM, Darrick J. Wong <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:darrick.wong@oracle.com" target=3D"_blan=
k">darrick.wong@oracle.com</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Tue, Feb 23, 2016 at 10:=
37:36PM -0500, Paul Cannon wrote:<br>
&gt; I have accidentally damaged my XFS, and need help (and a little prayer=
).<br>
&gt; The way it happened will provide your daily amusement dose (and hopefu=
lly a<br>
&gt; lesson).<br>
&gt;<br>
&gt; * What happened?<br>
&gt; I have two file systems xfsA (18 TBs on /dev/sdc1) and xfsB (36 TBs on=
<br>
&gt; /dev/sdd1). They were mounted and working fine. I accidentally execute=
d an<br>
&gt; old script that effectively ran the following command:<br>
&gt; &gt;ddrescue /dev/sdc /dev/sdd sdc_sdd.log<br>
&gt; For those unfamiliar with the ddrescue command, it claims to rescue/im=
age<br>
&gt; data from a drive A to B. It does multiple passes to rescue data with<=
br>
&gt; maximum efficiency.<br>
&gt;<br>
&gt; * Why did I do it?<br>
&gt; I am careless or dumb or may be a combination of both. But the fact th=
at<br>
&gt; drives got remapped (sdc/sdd became sde/sdf and otherway around) might=
 also<br>
&gt; be part of it.<br>
&gt;<br>
&gt; * What happened to XFS on sdd (xfsB)?<br>
&gt; Luckily, the imaging started with an offset of about 2.7 TBs. Why? Bec=
ause<br>
&gt; this was a restart of ddrescue and it started from past point. IT WROT=
E a<br>
&gt; total of 6.1 GBs of data on sdd/xfsB<br>
&gt;<br>
&gt; So I quickly stopped as I realized my mistake. I ran xfs_repair on xfs=
B.<br>
&gt; Due to the offset of 2.7 TBs, metadata seemed fine. The xfs_repair sho=
ws<br>
&gt; everything is fine. But if I extract out data using (dd skip=3D2.7TB) =
into a<br>
&gt; file -- I can see things are different! I recognize the abrupt change =
in a<br>
&gt; text file, exactly where the data overwritten.<br>
&gt;<br>
&gt; * Luckily I have old copy of the original data!<br>
<br>
</div></div>Good for you!=C2=A0 Seriously. :D<br>
<span class=3D""><br>
&gt; So I did a rsync -rvn /olddata/ /xfsB<br>
&gt; Nothing! No difference in any data files. I even tried mirrordir, same=
<br>
&gt; thing -- nothing, no difference!<br>
<br>
</span>rsync -c to force it to checksum the data blocks?<br>
<br>
By default I think it only compares file size and timestamps.<br>
<span class=3D""><br>
&gt; * Here is what I think is going on, and I need help.<br>
&gt; I suspect that the access time of the file/files stored at this locati=
on<br>
&gt; are perhaps in another location in inode (does this sound correct? I a=
m a<br>
&gt; newbie to XFS). But the data itself has changed at the location.<br>
<br>
</span>Quite possible.<br>
<span class=3D""><br>
&gt; * QUESTION: How do I find what files were stored at the location? I ha=
ve an<br>
&gt; EXACT location of the range affected. Once I find the affected files, =
I can<br>
&gt; perhaps do further surgery.<br>
<br>
</span>Sounds like something that the reverse-mapping btree and associated =
GETFSMAP<br>
ioctl could help solve ... too bad it only exists as experimental patches t=
o<br>
the on-disk format. :(<br>
<br>
In the meantime, I guess you could umount the filesystem and run xfs_db on =
it<br>
to find out what was in the areas that got overwritten, assuming rsync -c a=
lso<br>
shows no difference.=C2=A0 Something along the lines of:<br>
<br>
# xfs_db /dev/sdXX<br>
xfs_db&gt; blockget -n<br>
xfs_db&gt; fsblock &lt;block number of where the overwritten area starts&gt=
;<br>
xfs_db&gt; blockuse -n -c &lt;number of blocks you think got overwritten&gt=
;<br>
<br>
Have a look at the xfs_db manpage for more info on what those commands do.<=
br>
<br>
--D<br>
<span class=3D""><br>
&gt;<br>
&gt; Any help (and prayers) will be highly appreciated.<br>
<br>
</span>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br></div>

--001a1141f788cb7d69052c9e6d85--


--===============7602976909804083498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7602976909804083498==--
