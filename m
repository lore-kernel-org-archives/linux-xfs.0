Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B4737F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 17:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFE348F8059
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 15:40:03 -0700 (PDT)
Received: from DUB004-OMC4S9.hotmail.com (dub004-omc4s9.hotmail.com
	[157.55.2.84]) by cuda.sgi.com with ESMTP id 0VHR78dlPdUXAOgZ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 Oct 2014 15:40:00 -0700 (PDT)
Message-ID: <DUB113-W9BCC0D296AF7CD5D9D02FB6AF0@phx.gbl>
From: tom mason <tom_in_canada@hotmail.com>
Subject: RE: Mount: Structure needs cleaning
Date: Sun, 12 Oct 2014 22:39:58 +0000
In-Reply-To: <20141012142008.GB35667@bfoster.bfoster>
References: <1413103408756-35026.post@n7.nabble.com>,
	<20141012142008.GB35667@bfoster.bfoster>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8214073797920753609=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8214073797920753609==
Content-Type: multipart/alternative;
	boundary="_154c6de5-f12a-4026-88ac-c73ca38c4c54_"

--_154c6de5-f12a-4026-88ac-c73ca38c4c54_
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable



> Date: Sun=2C 12 Oct 2014 10:20:08 -0400
> From: bfoster@redhat.com
> To: tom_in_canada@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: Mount: Structure needs cleaning
>=20
> On Sun=2C Oct 12=2C 2014 at 01:43:28AM -0700=2C tommason wrote:
> > Hi=2C
> >=20
> > First up - my knowledge of linux is pretty sparse - I've used it a few =
times
> > before=2C so please be gentle!
> >=20
> > I've had a neil poulton network space for some time now - it freaked ou=
t a
> > while ago and I managed to rig it up to a Ubuntu liveCD via a SATA dock=
 and
> > rescue the files.
> >=20
> > This has now happened again - the drive would not get out of a cycle an=
d was
> > not spinning properly. Bring out the dock and liveCD (this time Knoppix=
).
> > All good. This time however as I eagerly copied files to another drive =
(a
> > USB powered lacie rugged thing) and left it overnight i woke up to an e=
rror.
> > I was copying around 500GB in a few diffferent chunks. The first error =
it
> > reported was I think error 15? mount structure needs cleaning...

> Logs? Kernel version? etc.


Hey Brian=2C
Apologies! I'm pretty new to all this so you'll have to walk me through it =
if possible - how do I check the logs?

- Linux ubuntu 3.13.0-32-generic #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 201=
4 x86_64 x86_64 x86_64 GNU/Linux
- xfs_repair version 3.1.9


>=20
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F
>=20
> > I then tried with a Ubuntu liveCD - same error. This is maybe where I m=
ade a
> > bit of an error of my own. In an attempt to shake it out of it's stupor=
 I
> > 'stupidly' plugged it into windows and opened up the disk utility (sorr=
y I'm
> > generally mac based) and deleted in total 5 partitions (3x8mb=2C 1x250o=
dd mb &
> > 1x600mbish partition) This left the partition that I assumed contained =
all
> > my files: a 920GB partition. Tried to look at it again on Linux & (both
> > Knoppix & Ubuntu) and the error message had changed slightly. It now re=
ads:
> > "Error mounting /dev/sdc2 at
> > /media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd: Command-line `mount=
 -t
> > "xfs" -o "uhelper=3Dudisks2=2Cnodev=2Cnosuid" "/dev/sdc2"
> > "/media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd"' exited with non-z=
ero
> > exit status 32: mount: Structure needs cleaning"


> To be clear=2C you've deleted partitions other than the partition of
> interest? I suppose that shouldn't effect things either way=2C but I'm no=
t
> really sure what the disk utility might do. It might be worth checking
> whether 'file -s <device>' still identifies the partition as an XFS
> filesystem..?


Yes it's a NAS drive and so I assume had some kind of proprietary OS on the=
 other partitions (this is where i might have messed up by deleting?!) I'm =
pretty sure that the drive in bold below (sdc2) is the one I'm after which =
is xfs...

ubuntu@ubuntu:~$ sudo lsblk -o NAME=2CFSTYPE=2CSIZE=2CMOUNTPOINT=2CLABEL
NAME   FSTYPE     SIZE MOUNTPOINT LABEL
sda             596.2G           =20
=86=80sda1 vfat       200M            EFI
=86=80sda2 hfsplus  491.8G            Macintosh HD
=86=80sda3 hfsplus  619.9M            Recovery HD
=84=80sda4 ntfs     103.6G           =20
sdc             931.5G           =20
=86=80sdc1              1K           =20
=84=80sdc2 xfs      930.6G           =20
sr0    iso9660    981M /cdrom     Ubuntu 14.04.1 LTS amd64
loop0  squashfs 938.7M /rofs

& This:

ubuntu@ubuntu:~$ sudo fdisk -l

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk =
doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 640.1 GB=2C 640135028736 bytes
255 heads=2C 63 sectors/track=2C 77825 cylinders=2C total 1250263728 sector=
s
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x34873486

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      409639      204819+  ee  GPT
/dev/sda2          409640  1031659623   515624992   af  HFS / HFS+
/dev/sda3      1031659624  1032929167      634772   ab  Darwin boot
/dev/sda4   *  1032929280  1250263039   108666880    7  HPFS/NTFS/exFAT

Disk /dev/sdb: 500.1 GB=2C 500107862016 bytes
255 heads=2C 63 sectors/track=2C 60801 cylinders=2C total 976773168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x1734c26c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               2   976773167   488386583    b  W95 FAT32

Disk /dev/sdc: 1000.2 GB=2C 1000204886016 bytes
255 heads=2C 63 sectors/track=2C 121601 cylinders=2C total 1953525168 secto=
rs
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xb06a2add

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1              63     2008124     1004031    5  Extended
/dev/sdc2         2008125  1953520064   975755970   83  Linux


>=20
> Beyond that=2C I'd suggest to capture and post the logs of the failed
> mount and perhaps the output of 'xfs_repair -n <dev>.' This will attempt
> a dry-run (e.g.=2C no modifications) check and repair of the filesystem.

Apologies again but you'd have to walk me through the process of exactly wh=
at to type in - as I say I'm really not very experienced with Linux/ubuntu =
& terminal!
Cheers!
Tom

> Brian
>=20
> > This drive has all my audio and video stored on it! Any help to move me
> > toward a solution would be much appreciated!
> >=20
> > Thanks for your time...
> >=20
> > Tom=20
> >=20
> >=20
> >=20
> > --
> > View this message in context: http://xfs.9218.n7.nabble.com/Mount-Struc=
ture-needs-cleaning-tp35026.html
> > Sent from the Xfs - General mailing list archive at Nabble.com.
> >=20
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
 		 	   		  =

--_154c6de5-f12a-4026-88ac-c73ca38c4c54_
Content-Type: text/html; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'><br><br><div><font style=3D"font=
-size: 8pt=3B" size=3D"1">&gt=3B Date: Sun=2C 12 Oct 2014 10:20:08 -0400</f=
ont><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"=
font-size: 8pt=3B" size=3D"1">&gt=3B From: bfoster@redhat.com</font><font s=
tyle=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: =
8pt=3B" size=3D"1">&gt=3B To: tom_in_canada@hotmail.com</font><font style=
=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B CC: xfs@oss.sgi.com</font><font style=3D"font-size: =
8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">=
&gt=3B Subject: Re: Mount: Structure needs cleaning</font><font style=3D"fo=
nt-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" si=
ze=3D"1">&gt=3B </font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></f=
ont><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B On Sun=2C Oct 12=2C=
 2014 at 01:43:28AM -0700=2C tommason wrote:</font><font style=3D"font-size=
: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1=
">&gt=3B &gt=3B Hi=2C</font><font style=3D"font-size: 8pt=3B" size=3D"1"><b=
r></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B </font>=
<font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font=
-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B First up - my knowledge of linux is=
 pretty sparse - I've used it a few times</font><font style=3D"font-size: 8=
pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&=
gt=3B &gt=3B before=2C so please be gentle!</font><font style=3D"font-size:=
 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1"=
>&gt=3B &gt=3B </font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></fo=
nt><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B I've had a ne=
il poulton network space for some time now - it freaked out a</font><font s=
tyle=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: =
8pt=3B" size=3D"1">&gt=3B &gt=3B while ago and I managed to rig it up to a =
Ubuntu liveCD via a SATA dock and</font><font style=3D"font-size: 8pt=3B" s=
ize=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &g=
t=3B rescue the files.</font><font style=3D"font-size: 8pt=3B" size=3D"1"><=
br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B </font=
><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"fon=
t-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B This has now happened again - the =
drive would not get out of a cycle and was</font><font style=3D"font-size: =
8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">=
&gt=3B &gt=3B not spinning properly. Bring out the dock and liveCD (this ti=
me Knoppix).</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font>=
<font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B All good. This t=
ime however as I eagerly copied files to another drive (a</font><font style=
=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B &gt=3B USB powered lacie rugged thing) and left it o=
vernight i woke up to an error.</font><font style=3D"font-size: 8pt=3B" siz=
e=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=
=3B I was copying around 500GB in a few diffferent chunks. The first error =
it</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font styl=
e=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B reported was I think error=
 15? mount structure needs cleaning...</font><font style=3D"font-size: 8pt=
=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1"><br=
></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B Logs? Kernel ve=
rsion? etc.</font><br><br><br><font style=3D"font-size: 10pt=3B" size=3D"2"=
>Hey Brian=2C<br></font><font style=3D"font-size: 10pt=3B" size=3D"2">Apolo=
gies!</font><font style=3D"font-size: 10pt=3B" size=3D"2"> </font><font sty=
le=3D"font-size: 10pt=3B" size=3D"2">I'm pretty new to all this so you'll h=
ave to walk me through it if possible - how do I check the logs?<br><br></f=
ont><font style=3D"font-size: 10pt=3B" size=3D"2">- Linux ubuntu 3.13.0-32-=
generic #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 2014 x86_64 x86_64 x86_64 GN=
U/Linux</font><font style=3D"font-size: 10pt=3B" size=3D"2"><br></font><fon=
t style=3D"font-size: 10pt=3B" size=3D"2">- xfs_repair version </font><font=
 style=3D"font-size: 10pt=3B" size=3D"2">3.1.9</font><br><br><br><font styl=
e=3D"font-size: 8pt=3B" size=3D"1">&gt=3B </font><font style=3D"font-size: =
8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">=
&gt=3B http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_includ=
e_when_reporting_a_problem.3F</font><font style=3D"font-size: 8pt=3B" size=
=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B </fon=
t><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"fo=
nt-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B I then tried with a Ubuntu liveCD=
 - same error. This is maybe where I made a</font><font style=3D"font-size:=
 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1"=
>&gt=3B &gt=3B bit of an error of my own. In an attempt to shake it out of =
it's stupor I</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font=
><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B 'stupidly' plug=
ged it into windows and opened up the disk utility (sorry I'm</font><font s=
tyle=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: =
8pt=3B" size=3D"1">&gt=3B &gt=3B generally mac based) and deleted in total =
5 partitions (3x8mb=2C 1x250odd mb &amp=3B</font><font style=3D"font-size: =
8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">=
&gt=3B &gt=3B 1x600mbish partition) This left the partition that I assumed =
contained all</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font=
><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B my files: a 920=
GB partition. Tried to look at it again on Linux &amp=3B (both</font><font =
style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size:=
 8pt=3B" size=3D"1">&gt=3B &gt=3B Knoppix &amp=3B Ubuntu) and the error mes=
sage had changed slightly. It now reads:</font><font style=3D"font-size: 8p=
t=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&g=
t=3B &gt=3B "Error mounting /dev/sdc2 at</font><font style=3D"font-size: 8p=
t=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&g=
t=3B &gt=3B /media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd: Command-lin=
e `mount -t</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><=
font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B "xfs" -o "uhelper=
=3Dudisks2=2Cnodev=2Cnosuid" "/dev/sdc2"</font><font style=3D"font-size: 8p=
t=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&g=
t=3B &gt=3B "/media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd"' exited wi=
th non-zero</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><=
font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B exit status 32: m=
ount: Structure needs cleaning"</font><font style=3D"font-size: 8pt=3B" siz=
e=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1"><br><br></f=
ont><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B To be clear=2C you'=
ve deleted partitions other than the partition of</font><font style=3D"font=
-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=
=3D"1">&gt=3B interest? I suppose that shouldn't effect things either way=
=2C but I'm not</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></fo=
nt><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B really sure what the=
 disk utility might do. It might be worth checking</font><font style=3D"fon=
t-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" siz=
e=3D"1">&gt=3B whether 'file -s &lt=3Bdevice&gt=3B' still identifies the pa=
rtition as an XFS</font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></=
font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B filesystem..?</fon=
t><font style=3D"font-size: 8pt=3B" size=3D"1"><br><br><br><font style=3D"f=
ont-size: 10pt=3B" size=3D"2">Yes it's a NAS drive and so I assume had some=
 kind of proprietary OS on the other partitions (this is where i </font><fo=
nt style=3D"font-size: 10pt=3B" size=3D"2">might have messed up by deleting=
?!) I'm pretty sure that the drive in bold below (sdc2) is the one I'm afte=
r which is xfs...<br><font style=3D"font-size: 8pt=3B" size=3D"1"><br></fon=
t></font><font style=3D"font-size: 10pt=3B">ubuntu@ubuntu:~$ sudo lsblk -o =
NAME=2CFSTYPE=2CSIZE=2CMOUNTPOINT=2CLABEL</font><font style=3D"font-size: 1=
0pt=3B"><br></font><font style=3D"font-size: 10pt=3B">NAME&nbsp=3B&nbsp=3B =
FSTYPE&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B SIZE MOUNTPOINT LABEL</font><font st=
yle=3D"font-size: 10pt=3B"><br></font><font style=3D"font-size: 10pt=3B">sd=
a&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B 596.2G&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font><font style=3D"font-size=
: 10pt=3B"><br></font><font style=3D"font-size: 10pt=3B">=86=80sda1 vfat&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 200M&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B EFI</font><=
font style=3D"font-size: 10pt=3B"><br></font><font style=3D"font-size: 10pt=
=3B">=86=80sda2 hfsplus&nbsp=3B 491.8G&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Macintosh HD</font><fon=
t style=3D"font-size: 10pt=3B"><br></font><font style=3D"font-size: 10pt=3B=
">=86=80sda3 hfsplus&nbsp=3B 619.9M&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Recovery HD</font><font st=
yle=3D"font-size: 10pt=3B"><br></font><font style=3D"font-size: 10pt=3B">=
=84=80sda4 ntfs&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 103.6G&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font>=
<font style=3D"font-size: 10pt=3B"><br></font><font style=3D"font-size: 10p=
t=3B">sdc&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 931.5G&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font><font style=3D"f=
ont-size: 10pt=3B"><br></font><font style=3D"font-size: 10pt=3B">=86=80sdc1=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1K&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font><font style=3D"font-si=
ze: 10pt=3B"><br></font><font style=3D"font-size: 10pt=3B"><b>=84=80sdc2 xf=
s&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 930.6G&nbsp=3B&nbsp=3B&nbsp=3B</b=
></font><font style=3D"font-size: 10pt=3B">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font><font style=3D"font-size: 10pt=3B">=
<br></font><font style=3D"font-size: 10pt=3B">sr0&nbsp=3B&nbsp=3B&nbsp=3B i=
so9660&nbsp=3B&nbsp=3B&nbsp=3B 981M /cdrom&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Ubuntu 14.04.1 LTS amd64</font><font style=3D"font-size: 10pt=3B"><br></fon=
t><font style=3D"font-size: 10pt=3B">loop0&nbsp=3B squashfs 938.7M /rofs<br=
><br></font><font style=3D"font-size: 10pt=3B"></font>&amp=3B This:<br><br>=
ubuntu@ubuntu:~$ sudo fdisk -l<br><br>WARNING: GPT (GUID Partition Table) d=
etected on '/dev/sda'! The util fdisk doesn't support GPT. Use GNU Parted.<=
br><br><br>Disk /dev/sda: 640.1 GB=2C 640135028736 bytes<br>255 heads=2C 63=
 sectors/track=2C 77825 cylinders=2C total 1250263728 sectors<br>Units =3D =
sectors of 1 * 512 =3D 512 bytes<br>Sector size (logical/physical): 512 byt=
es / 512 bytes<br>I/O size (minimum/optimal): 512 bytes / 512 bytes<br>Disk=
 identifier: 0x34873486<br><br>&nbsp=3B&nbsp=3B Device Boot&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B Start&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B End&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Blocks&nbsp=
=3B&nbsp=3B Id&nbsp=3B System<br>/dev/sda1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B 1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 409639&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B 204819+&nbsp=3B ee&nbsp=3B GPT<br>/dev/sda2&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 409640&nbsp=3B=
 1031659623&nbsp=3B&nbsp=3B 515624992&nbsp=3B&nbsp=3B af&nbsp=3B HFS / HFS+=
<br>/dev/sda3&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1031659624&nbsp=3B 10=
32929167&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 634772&nbsp=3B&nbsp=3B ab&=
nbsp=3B Darwin boot<br>/dev/sda4&nbsp=3B&nbsp=3B *&nbsp=3B 1032929280&nbsp=
=3B 1250263039&nbsp=3B&nbsp=3B 108666880&nbsp=3B&nbsp=3B&nbsp=3B 7&nbsp=3B =
HPFS/NTFS/exFAT<br><br>Disk /dev/sdb: 500.1 GB=2C 500107862016 bytes<br>255=
 heads=2C 63 sectors/track=2C 60801 cylinders=2C total 976773168 sectors<br=
>Units =3D sectors of 1 * 512 =3D 512 bytes<br>Sector size (logical/physica=
l): 512 bytes / 512 bytes<br>I/O size (minimum/optimal): 512 bytes / 512 by=
tes<br>Disk identifier: 0x1734c26c<br><br>&nbsp=3B&nbsp=3B Device Boot&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Start&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B End&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Blocks&nbsp=3B&nbsp=3B Id&nbsp=3B System<br>/dev/sdb1&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B 2&nbsp=3B&nbsp=3B 976773167&nbsp=3B&nbsp=3B 488386583&nbsp=
=3B&nbsp=3B&nbsp=3B b&nbsp=3B W95 FAT32<br><br>Disk /dev/sdc: 1000.2 GB=2C =
1000204886016 bytes<br>255 heads=2C 63 sectors/track=2C 121601 cylinders=2C=
 total 1953525168 sectors<br>Units =3D sectors of 1 * 512 =3D 512 bytes<br>=
Sector size (logical/physical): 512 bytes / 512 bytes<br>I/O size (minimum/=
optimal): 512 bytes / 512 bytes<br>Disk identifier: 0xb06a2add<br><br>&nbsp=
=3B&nbsp=3B Device Boot&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Start&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B End&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B Blocks&nbsp=3B&nbsp=3B Id&nbsp=3B System<br>/d=
ev/sdc1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 63&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 200=
8124&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1004031&nbsp=3B&nbsp=3B&nbsp=3B 5&nbsp=
=3B Extended<br>/dev/sdc2&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B 2008125&nbsp=3B 1953520064&nbsp=3B&nbsp=3B 975755970&nbsp=3B=
&nbsp=3B 83&nbsp=3B Linux<br><br><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B </font><font style=3D"font-size: 8pt=3B" size=3D"1">=
<br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B Beyond that=
=2C I'd suggest to capture and post the logs of the failed</font><font styl=
e=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B mount and perhaps the output of 'xfs_repair -n &lt=
=3Bdev&gt=3B.' This will attempt</font><font style=3D"font-size: 8pt=3B" si=
ze=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B a d=
ry-run (e.g.=2C no modifications) check and repair of the filesystem.</font=
><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><br><font style=3D=
"font-size: 10pt=3B" size=3D"2">Apologies again but you'd have to walk me t=
hrough the process of exactly what to type in - as I say I'm really not ver=
y experienced with Linux/ubuntu &amp=3B terminal</font>!<br><font style=3D"=
font-size: 10pt=3B" size=3D"2">Cheers!</font><font style=3D"font-size: 10pt=
=3B" size=3D"2"><br></font><font style=3D"font-size: 10pt=3B" size=3D"2">To=
m</font><br><br><font style=3D"font-size: 8pt=3B" size=3D"1"></font><font s=
tyle=3D"font-size: 8pt=3B" size=3D"1">&gt=3B Brian</font><font style=3D"fon=
t-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" siz=
e=3D"1">&gt=3B </font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></fo=
nt><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B This drive ha=
s all my audio and video stored on it! Any help to move me</font><font styl=
e=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B &gt=3B toward a solution would be much appreciated!<=
/font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=
=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B </font><font style=3D"font-=
size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=
=3D"1">&gt=3B &gt=3B Thanks for your time...</font><font style=3D"font-size=
: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1=
">&gt=3B &gt=3B </font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></f=
ont><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B Tom </font><=
font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-=
size: 8pt=3B" size=3D"1">&gt=3B &gt=3B </font><font style=3D"font-size: 8pt=
=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=
=3B &gt=3B </font><font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><=
font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=3B </font><font styl=
e=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B &gt=3B --</font><font style=3D"font-size: 8pt=3B" si=
ze=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=
=3B View this message in context: http://xfs.9218.n7.nabble.com/Mount-Struc=
ture-needs-cleaning-tp35026.html</font><font style=3D"font-size: 8pt=3B" si=
ze=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &gt=
=3B Sent from the Xfs - General mailing list archive at Nabble.com.</font><=
font style=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-=
size: 8pt=3B" size=3D"1">&gt=3B &gt=3B </font><font style=3D"font-size: 8pt=
=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=
=3B &gt=3B _______________________________________________</font><font styl=
e=3D"font-size: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=
=3B" size=3D"1">&gt=3B &gt=3B xfs mailing list</font><font style=3D"font-si=
ze: 8pt=3B" size=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D=
"1">&gt=3B &gt=3B xfs@oss.sgi.com</font><font style=3D"font-size: 8pt=3B" s=
ize=3D"1"><br></font><font style=3D"font-size: 8pt=3B" size=3D"1">&gt=3B &g=
t=3B http://oss.sgi.com/mailman/listinfo/xfs</font><br></div> 		 	   		  </=
div></body>
</html>=

--_154c6de5-f12a-4026-88ac-c73ca38c4c54_--


--===============8214073797920753609==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8214073797920753609==--
