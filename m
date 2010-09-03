Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o83KBpvx005089 for <xfs@oss.sgi.com>; Fri, 3 Sep 2010 15:11:51 -0500
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E3361D806AE
	for <xfs@oss.sgi.com>; Fri,  3 Sep 2010 13:12:32 -0700 (PDT)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 7GrvHe1sxhoL6a8E
	for <xfs@oss.sgi.com>; Fri, 03 Sep 2010 13:12:32 -0700 (PDT)
Received: by ywf7 with SMTP id 7so1009303ywf.26
	for <xfs@oss.sgi.com>; Fri, 03 Sep 2010 13:12:31 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 13:12:30 -0700
Message-ID: <AANLkTi=NhOdoX0VU7fyvYpgM+mbN8b3vC7QrkKrcnDk=@mail.gmail.com>
Subject: Possible to preallocate files that always begin/end on stripe
	unit/width?
From: Green Guy <greentech3000@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0128466749971103608=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0128466749971103608==
Content-Type: multipart/alternative; boundary=0016e64ec8fce9a5a9048f608c49

--0016e64ec8fce9a5a9048f608c49
Content-Type: text/plain; charset=ISO-8859-1

I am working on an app that will write to preallocated files. I can control
how big the files are (as long as they are between 4-6GB) and the amount of
data sent with each write() call.
I have a 3.2TB virtual drive that I need to use as much of as possible but
performance is the number one concern.

The system is an 8 disk RAID5 with a 256k stripe. Based on this, I am using:

mkfs.xfs -b size=4096 -l version=2,sunit=512 -d su=256k,sw=7 -f /dev/sdb
meta-data=/dev/sdb               isize=256    agcount=32, agsize=26679232
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=853735424, imaxpct=25
         =                       sunit=64     swidth=
 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

and
mount -t xfs -o sunit=512,swidth=3584,inode64,nobarrier,logbufs=8  /dev/sdb
/mnt

Based on what I have read, it appears then my "most optimal" write/read size
would be 1835008 bytes (3584 *512).

So based on that, I want to preallocate files somewhere between 4-6GB each
that will always begin and end on the stripe unit and stripe width and be a
multiple of 1835008.

I know that XFS metadata such as the log, AG info, etc also need to be
accounted for, but I am not sure the best way to determine how much space
they will take.

I assume that the fact that, once I set the number of files on the disk,
they will not change/expand must be an advantage, but I am unsure how to
leverage it.

I have tried file sizes in several different multiples of 1835008, but for
all of them, bmap -vp has flags 00011.

How can I determine the correct file size and preallocate them in a way
where they always begin/end on stripe unit/width taking the filesystem
overhead into account?
Note: the log needs to stay on the same fs.

Thanks
g3k

--0016e64ec8fce9a5a9048f608c49
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div>I am working on an app that will write to preallocated files. I ca=
n control how big the files are (as long as they are between 4-6GB) and the=
 amount of data sent with each write() call.</div><div>I have a 3.2TB virtu=
al drive that I need to use as much of as possible but performance is the n=
umber one concern.</div>

<div><br></div><div>The system is an 8 disk RAID5 with a 256k stripe. Based=
 on this, I am using:</div><div><br></div><div>mkfs.xfs -b size=3D4096 -l v=
ersion=3D2,sunit=3D512 -d su=3D256k,sw=3D7 -f /dev/sdb</div><div><div>meta-=
data=3D/dev/sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 isize=3D256 =A0 =A0agcount=3D32=
, agsize=3D26679232 blks</div>

<div>=A0=A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec=
tsz=3D512 =A0 attr=3D0</div><div>data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=3D853735424, imaxpct=3D25</div>=
<div>=A0=A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sun=
it=3D64 =A0 =A0 swidth=3D</div><div>=A0blks, unwritten=3D1</div>

<div>naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0</d=
iv><div>log =A0 =A0 =A0=3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0=
 blocks=3D32768, version=3D2</div><div>=A0=A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0 sunit=3D64 blks, lazy-coun=
t=3D1</div>
<div>
realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 block=
s=3D0, rtextents=3D0</div><div><br></div></div><div>and</div><div>mount -t =
xfs -o sunit=3D512,swidth=3D3584,inode64,nobarrier,logbufs=3D8 =A0/dev/sdb =
/mnt</div><div><br></div><div>Based on what I have read, it appears then my=
 &quot;most optimal&quot; write/read size would be=A0<span style=3D"font-fa=
mily:Helvetica;font-size:12px">1835008 bytes (3584 *512).</span></div>

<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br=
></span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=
=3D"font-size:12px">So based on that, I want to preallocate files somewhere=
 between 4-6GB each that will always begin and end on the stripe unit and s=
tripe width and be a multiple of 1835008.</span></font></div>

<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br=
></span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=
=3D"font-size:12px">I know that XFS metadata such as the log, AG info, etc =
also need to be accounted for, but I am not sure the best way to determine =
how much space they will take.</span></font></div>

<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br=
></span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=
=3D"font-size:12px">I assume that the fact that, once I set the number of f=
iles on the disk, they will not change/expand must be an advantage, but I a=
m unsure how to leverage it.</span></font></div>

<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br=
></span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=
=3D"font-size:12px">I have tried file sizes in several different multiples =
of 1835008, but for all of them, bmap -vp has flags 00011.</span></font></d=
iv>

<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br=
></span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=
=3D"font-size:12px">How can I determine the correct file size and prealloca=
te them in a way where they always begin/end on stripe unit/width taking th=
e filesystem overhead into account?</span></font></div>

<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px">Not=
e: the log needs to stay on the same fs.</span></font></div><div><font face=
=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br>
</span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=3D=
"font-size:12px">Thanks</span></font></div><div><span style=3D"font-family:=
Helvetica;font-size:12px">g3k</span></div>
<div><font face=3D"Helvetica" size=3D"3"><span style=3D"font-size:12px"><br=
></span></font></div><div><font face=3D"Helvetica" size=3D"3"><span style=
=3D"font-size:12px"><br>
</span></font></div><div><br></div>

--0016e64ec8fce9a5a9048f608c49--


--===============0128466749971103608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0128466749971103608==--
