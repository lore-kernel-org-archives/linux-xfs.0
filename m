Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A880C7F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 17:51:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 523C3AC005
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 15:51:55 -0700 (PDT)
Received: from DUB004-OMC4S10.hotmail.com (dub004-omc4s10.hotmail.com
	[157.55.2.85]) by cuda.sgi.com with ESMTP id 1OCpPfMn8H3YsExQ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 Oct 2014 15:51:51 -0700 (PDT)
Message-ID: <DUB113-W2303B0C5DFF6F30A385A83B6AF0@phx.gbl>
From: tom mason <tom_in_canada@hotmail.com>
Subject: RE: Mount: Structure needs cleaning
Date: Sun, 12 Oct 2014 22:51:49 +0000
In-Reply-To: <DUB113-W8015EC9E74D26138852F2FB6AF0@phx.gbl>
References: <1413103408756-35026.post@n7.nabble.com>,
	<20141012142008.GB35667@bfoster.bfoster>,
	<DUB113-W9BCC0D296AF7CD5D9D02FB6AF0@phx.gbl>,
	<DUB113-W8015EC9E74D26138852F2FB6AF0@phx.gbl>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0992010562802258848=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0992010562802258848==
Content-Type: multipart/alternative;
	boundary="_7109ffa0-b93c-4751-8a76-8b3511522604_"

--_7109ffa0-b93c-4751-8a76-8b3511522604_
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable

and now xfs_check:

root@ubuntu:~# xfs_check /dev/sdc2
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log=2C and unmount it befo=
re
re-running xfs_check.  If you are unable to mount the filesystem=2C then us=
e
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.


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

> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
 		 	   		   		 	   		   		 	   		  =

--_7109ffa0-b93c-4751-8a76-8b3511522604_
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
<body class=3D'hmmessage'><div dir=3D'ltr'><font style=3D"font-size: 10pt=
=3B" size=3D"2">and now xfs_check:</font><font style=3D"font-size: 10pt=3B"=
 size=3D"2"><br></font><font style=3D"font-size: 10pt=3B" size=3D"2"><br></=
font><div><font style=3D"font-size: 10pt=3B" size=3D"2">root@ubuntu:~# xfs_=
check /dev/sdc2</font><font style=3D"font-size: 10pt=3B" size=3D"2"><br></f=
ont><font style=3D"font-size: 10pt=3B" size=3D"2">ERROR: The filesystem has=
 valuable metadata changes in a log which needs to</font><font style=3D"fon=
t-size: 10pt=3B" size=3D"2"><br></font><font style=3D"font-size: 10pt=3B" s=
ize=3D"2">be replayed.&nbsp=3B Mount the filesystem to replay the log=2C an=
d unmount it before</font><font style=3D"font-size: 10pt=3B" size=3D"2"><br=
></font><font style=3D"font-size: 10pt=3B" size=3D"2">re-running xfs_check.=
&nbsp=3B If you are unable to mount the filesystem=2C then use</font><font =
style=3D"font-size: 10pt=3B" size=3D"2"><br></font><font style=3D"font-size=
: 10pt=3B" size=3D"2">the xfs_repair -L option to destroy the log and attem=
pt a repair.</font><font style=3D"font-size: 10pt=3B" size=3D"2"><br></font=
><font style=3D"font-size: 10pt=3B" size=3D"2">Note that destroying the log=
 may cause corruption -- please attempt a mount</font><font style=3D"font-s=
ize: 10pt=3B" size=3D"2"><br></font><font style=3D"font-size: 10pt=3B" size=
=3D"2">of the filesystem before doing this.</font><br><br><div dir=3D"ltr">=
<div><div dir=3D"ltr"><br><div><font style=3D"font-size:8pt=3B" size=3D"1">=
&gt=3B Date: Sun=2C 12 Oct 2014 10:20:08 -0400</font><font style=3D"font-si=
ze:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1=
">&gt=3B From: bfoster@redhat.com</font><font style=3D"font-size:8pt=3B" si=
ze=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B To: =
tom_in_canada@hotmail.com</font><font style=3D"font-size:8pt=3B" size=3D"1"=
><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B CC: xfs@oss.=
sgi.com</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font =
style=3D"font-size:8pt=3B" size=3D"1">&gt=3B Subject: Re: Mount: Structure =
needs cleaning</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font=
><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B </font><font style=3D"f=
ont-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" siz=
e=3D"1">&gt=3B On Sun=2C Oct 12=2C 2014 at 01:43:28AM -0700=2C tommason wro=
te:</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font styl=
e=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B Hi=2C</font><font style=3D"=
font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" si=
ze=3D"1">&gt=3B &gt=3B </font><font style=3D"font-size:8pt=3B" size=3D"1"><=
br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B First u=
p - my knowledge of linux is pretty sparse - I've used it a few times</font=
><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font=
-size:8pt=3B" size=3D"1">&gt=3B &gt=3B before=2C so please be gentle!</font=
><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font=
-size:8pt=3B" size=3D"1">&gt=3B &gt=3B </font><font style=3D"font-size:8pt=
=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=
=3B &gt=3B I've had a neil poulton network space for some time now - it fre=
aked out a</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><fo=
nt style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B while ago and I mana=
ged to rig it up to a Ubuntu liveCD via a SATA dock and</font><font style=
=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B=
" size=3D"1">&gt=3B &gt=3B rescue the files.</font><font style=3D"font-size=
:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">=
&gt=3B &gt=3B </font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font=
><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B This has now hap=
pened again - the drive would not get out of a cycle and was</font><font st=
yle=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=
=3B" size=3D"1">&gt=3B &gt=3B not spinning properly. Bring out the dock and=
 liveCD (this time Knoppix).</font><font style=3D"font-size:8pt=3B" size=3D=
"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B Al=
l good. This time however as I eagerly copied files to another drive (a</fo=
nt><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"fo=
nt-size:8pt=3B" size=3D"1">&gt=3B &gt=3B USB powered lacie rugged thing) an=
d left it overnight i woke up to an error.</font><font style=3D"font-size:8=
pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&g=
t=3B &gt=3B I was copying around 500GB in a few diffferent chunks. The firs=
t error it</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><fo=
nt style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B reported was I think=
 error 15? mount structure needs cleaning...</font><font style=3D"font-size=
:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">=
<br><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B Logs? Ker=
nel version? etc.</font><br><br><font style=3D"font-size:10pt=3B" size=3D"2=
">Hey Brian=2C<br></font><font style=3D"font-size:10pt=3B" size=3D"2">Apolo=
gies!</font><font style=3D"font-size:10pt=3B" size=3D"2"> </font><font styl=
e=3D"font-size:10pt=3B" size=3D"2">I'm pretty new to all this so you'll hav=
e to walk me through it if possible - how do I check the logs?<br><br></fon=
t><font style=3D"font-size:10pt=3B" size=3D"2">- Linux ubuntu 3.13.0-32-gen=
eric #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 2014 x86_64 x86_64 x86_64 GNU/L=
inux</font><font style=3D"font-size:10pt=3B" size=3D"2"><br></font><font st=
yle=3D"font-size:10pt=3B" size=3D"2">- xfs_repair version </font><font styl=
e=3D"font-size:10pt=3B" size=3D"2">3.1.9</font><br><br><br><font style=3D"f=
ont-size:8pt=3B" size=3D"1">&gt=3B </font><font style=3D"font-size:8pt=3B" =
size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B ht=
tp://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_re=
porting_a_problem.3F</font><font style=3D"font-size:8pt=3B" size=3D"1"><br>=
</font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B </font><font styl=
e=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=
=3B" size=3D"1">&gt=3B &gt=3B I then tried with a Ubuntu liveCD - same erro=
r. This is maybe where I made a</font><font style=3D"font-size:8pt=3B" size=
=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B=
 bit of an error of my own. In an attempt to shake it out of it's stupor I<=
/font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D=
"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B 'stupidly' plugged it into wind=
ows and opened up the disk utility (sorry I'm</font><font style=3D"font-siz=
e:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1"=
>&gt=3B &gt=3B generally mac based) and deleted in total 5 partitions (3x8m=
b=2C 1x250odd mb &amp=3B</font><font style=3D"font-size:8pt=3B" size=3D"1">=
<br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B 1x600m=
bish partition) This left the partition that I assumed contained all</font>=
<font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-=
size:8pt=3B" size=3D"1">&gt=3B &gt=3B my files: a 920GB partition. Tried to=
 look at it again on Linux &amp=3B (both</font><font style=3D"font-size:8pt=
=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=
=3B &gt=3B Knoppix &amp=3B Ubuntu) and the error message had changed slight=
ly. It now reads:</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></f=
ont><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B "Error mounti=
ng /dev/sdc2 at</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></fon=
t><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B /media/ubuntu/e=
8b90eb2-8718-4964-939d-8a2b899b68bd: Command-line `mount -t</font><font sty=
le=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=
=3B" size=3D"1">&gt=3B &gt=3B "xfs" -o "uhelper=3Dudisks2=2Cnodev=2Cnosuid"=
 "/dev/sdc2"</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><=
font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B "/media/ubuntu/e8b=
90eb2-8718-4964-939d-8a2b899b68bd"' exited with non-zero</font><font style=
=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B=
" size=3D"1">&gt=3B &gt=3B exit status 32: mount: Structure needs cleaning"=
</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=
=3D"font-size:8pt=3B" size=3D"1"><br><br></font><font style=3D"font-size:8p=
t=3B" size=3D"1">&gt=3B To be clear=2C you've deleted partitions other than=
 the partition of</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></f=
ont><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B interest? I suppose =
that shouldn't effect things either way=2C but I'm not</font><font style=3D=
"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" s=
ize=3D"1">&gt=3B really sure what the disk utility might do. It might be wo=
rth checking</font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><=
font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B whether 'file -s &lt=3Bde=
vice&gt=3B' still identifies the partition as an XFS</font><font style=3D"f=
ont-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" siz=
e=3D"1">&gt=3B filesystem..?</font><font style=3D"font-size:8pt=3B" size=3D=
"1"><br><br><br><font style=3D"font-size:10pt=3B" size=3D"2">Yes it's a NAS=
 drive and so I assume had some kind of proprietary OS on the other partiti=
ons (this is where i </font><font style=3D"font-size:10pt=3B" size=3D"2">mi=
ght have messed up by deleting?!) I'm pretty sure that the drive in bold be=
low (sdc2) is the one I'm after which is xfs...<br><font style=3D"font-size=
:8pt=3B" size=3D"1"><br></font></font><font style=3D"font-size:10pt=3B">ubu=
ntu@ubuntu:~$ sudo lsblk -o NAME=2CFSTYPE=2CSIZE=2CMOUNTPOINT=2CLABEL</font=
><font style=3D"font-size:10pt=3B"><br></font><font style=3D"font-size:10pt=
=3B">NAME&nbsp=3B&nbsp=3B FSTYPE&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B SIZE MOUNT=
POINT LABEL</font><font style=3D"font-size:10pt=3B"><br></font><font style=
=3D"font-size:10pt=3B">sda&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 596.2G&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font>=
<font style=3D"font-size:10pt=3B"><br></font><font style=3D"font-size:10pt=
=3B">=86=80sda1 vfat&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 200M&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B EFI</font><font style=3D"font-size:10pt=3B"><br></font><font st=
yle=3D"font-size:10pt=3B">=86=80sda2 hfsplus&nbsp=3B 491.8G&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Ma=
cintosh HD</font><font style=3D"font-size:10pt=3B"><br></font><font style=
=3D"font-size:10pt=3B">=86=80sda3 hfsplus&nbsp=3B 619.9M&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Recov=
ery HD</font><font style=3D"font-size:10pt=3B"><br></font><font style=3D"fo=
nt-size:10pt=3B">=84=80sda4 ntfs&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 103.6G&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B </font><font style=3D"font-size:10pt=3B"><br></font><font style=
=3D"font-size:10pt=3B">sdc&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 931.5G&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font>=
<font style=3D"font-size:10pt=3B"><br></font><font style=3D"font-size:10pt=
=3B">=86=80sdc1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1K&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font><font s=
tyle=3D"font-size:10pt=3B"><br></font><font style=3D"font-size:10pt=3B"><b>=
=84=80sdc2 xfs&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 930.6G&nbsp=3B&nbsp=
=3B&nbsp=3B</b></font><font style=3D"font-size:10pt=3B">&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </font><font style=3D"font-si=
ze:10pt=3B"><br></font><font style=3D"font-size:10pt=3B">sr0&nbsp=3B&nbsp=
=3B&nbsp=3B iso9660&nbsp=3B&nbsp=3B&nbsp=3B 981M /cdrom&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B Ubuntu 14.04.1 LTS amd64</font><font style=3D"font-size:10pt=
=3B"><br></font><font style=3D"font-size:10pt=3B">loop0&nbsp=3B squashfs 93=
8.7M /rofs<br><br></font><font style=3D"font-size:10pt=3B"></font>&amp=3B T=
his:<br><br>ubuntu@ubuntu:~$ sudo fdisk -l<br><br>WARNING: GPT (GUID Partit=
ion Table) detected on '/dev/sda'! The util fdisk doesn't support GPT. Use =
GNU Parted.<br><br><br>Disk /dev/sda: 640.1 GB=2C 640135028736 bytes<br>255=
 heads=2C 63 sectors/track=2C 77825 cylinders=2C total 1250263728 sectors<b=
r>Units =3D sectors of 1 * 512 =3D 512 bytes<br>Sector size (logical/physic=
al): 512 bytes / 512 bytes<br>I/O size (minimum/optimal): 512 bytes / 512 b=
ytes<br>Disk identifier: 0x34873486<br><br>&nbsp=3B&nbsp=3B Device Boot&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Start&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B End&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
 Blocks&nbsp=3B&nbsp=3B Id&nbsp=3B System<br>/dev/sda1&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B 1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 409639&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 204819+&nbsp=3B ee&nbsp=3B GPT<br>/dev/sda2&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 409=
640&nbsp=3B 1031659623&nbsp=3B&nbsp=3B 515624992&nbsp=3B&nbsp=3B af&nbsp=3B=
 HFS / HFS+<br>/dev/sda3&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1031659624=
&nbsp=3B 1032929167&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 634772&nbsp=3B&=
nbsp=3B ab&nbsp=3B Darwin boot<br>/dev/sda4&nbsp=3B&nbsp=3B *&nbsp=3B 10329=
29280&nbsp=3B 1250263039&nbsp=3B&nbsp=3B 108666880&nbsp=3B&nbsp=3B&nbsp=3B =
7&nbsp=3B HPFS/NTFS/exFAT<br><br>Disk /dev/sdb: 500.1 GB=2C 500107862016 by=
tes<br>255 heads=2C 63 sectors/track=2C 60801 cylinders=2C total 976773168 =
sectors<br>Units =3D sectors of 1 * 512 =3D 512 bytes<br>Sector size (logic=
al/physical): 512 bytes / 512 bytes<br>I/O size (minimum/optimal): 512 byte=
s / 512 bytes<br>Disk identifier: 0x1734c26c<br><br>&nbsp=3B&nbsp=3B Device=
 Boot&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Start&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B End&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Blocks&nbsp=3B&nbsp=3B Id&nbsp=3B System<br>/dev/sdb1&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 2&nbsp=3B&nbsp=3B 976773167&nbsp=3B&nbsp=3B 488=
386583&nbsp=3B&nbsp=3B&nbsp=3B b&nbsp=3B W95 FAT32<br><br>Disk /dev/sdc: 10=
00.2 GB=2C 1000204886016 bytes<br>255 heads=2C 63 sectors/track=2C 121601 c=
ylinders=2C total 1953525168 sectors<br>Units =3D sectors of 1 * 512 =3D 51=
2 bytes<br>Sector size (logical/physical): 512 bytes / 512 bytes<br>I/O siz=
e (minimum/optimal): 512 bytes / 512 bytes<br>Disk identifier: 0xb06a2add<b=
r><br>&nbsp=3B&nbsp=3B Device Boot&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Start&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B End&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Blocks&nbsp=3B&nbsp=3B Id&nbsp=3B Sy=
stem<br>/dev/sdc1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 63&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B 2008124&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1004031&nbsp=3B&nbsp=3B&nbsp=
=3B 5&nbsp=3B Extended<br>/dev/sdc2&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B 2008125&nbsp=3B 1953520064&nbsp=3B&nbsp=3B 9757559=
70&nbsp=3B&nbsp=3B 83&nbsp=3B Linux<br><br><br></font><font style=3D"font-s=
ize:8pt=3B" size=3D"1">&gt=3B </font><font style=3D"font-size:8pt=3B" size=
=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B Beyond=
 that=2C I'd suggest to capture and post the logs of the failed</font><font=
 style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:=
8pt=3B" size=3D"1">&gt=3B mount and perhaps the output of 'xfs_repair -n &l=
t=3Bdev&gt=3B.' This will attempt</font><font style=3D"font-size:8pt=3B" si=
ze=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B a dr=
y-run (e.g.=2C no modifications) check and repair of the filesystem.</font>=
<font style=3D"font-size:8pt=3B" size=3D"1"><br></font><br><font style=3D"f=
ont-size:10pt=3B" size=3D"2">Apologies again but you'd have to walk me thro=
ugh the process of exactly what to type in - as I say I'm really not very e=
xperienced with Linux/ubuntu &amp=3B terminal</font>!<br><font style=3D"fon=
t-size:10pt=3B" size=3D"2">Cheers!</font><font style=3D"font-size:10pt=3B" =
size=3D"2"><br></font><font style=3D"font-size:10pt=3B" size=3D"2">Tom</fon=
t><br><br><font style=3D"font-size:8pt=3B" size=3D"1"></font><font style=3D=
"font-size:8pt=3B" size=3D"1">&gt=3B Brian</font><font style=3D"font-size:8=
pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&g=
t=3B </font><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font st=
yle=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B This drive has all my aud=
io and video stored on it! Any help to move me</font><font style=3D"font-si=
ze:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1=
">&gt=3B &gt=3B toward a solution would be much appreciated!</font><font st=
yle=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=
=3B" size=3D"1">&gt=3B &gt=3B </font><font style=3D"font-size:8pt=3B" size=
=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B=
 Thanks for your time...</font><font style=3D"font-size:8pt=3B" size=3D"1">=
<br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &gt=3B </font=
><font style=3D"font-size:8pt=3B" size=3D"1"><br></font><font style=3D"font=
-size:8pt=3B" size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=
=3D"1">&gt=3B &gt=3B xfs@oss.sgi.com</font><font style=3D"font-size:8pt=3B"=
 size=3D"1"><br></font><font style=3D"font-size:8pt=3B" size=3D"1">&gt=3B &=
gt=3B http://oss.sgi.com/mailman/listinfo/xfs</font><br></div> 		 	   		  <=
/div></div> 		 	   		  </div></div> 		 	   		  </div></body>
</html>=

--_7109ffa0-b93c-4751-8a76-8b3511522604_--


--===============0992010562802258848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0992010562802258848==--
