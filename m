Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E03A7F58
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 20:58:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67A36304043
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 18:58:17 -0800 (PST)
Received: from BLU004-OMC3S32.hotmail.com (blu004-omc3s32.hotmail.com
	[65.55.116.107]) by cuda.sgi.com with ESMTP id hlMHHeFH3dYCnGAz
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Nov 2014 18:58:15 -0800 (PST)
Message-ID: <BLU172-W37035B2F04763AC56B7FA0C48D0@phx.gbl>
From: Robert Tench <robtench@hotmail.com>
Subject: RE: Mismatch UUID
Date: Sat, 15 Nov 2014 13:58:14 +1100
In-Reply-To: <546692DA.9040105@sandeen.net>
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
	<6AB68617-0884-486D-8B96-8FD22DBC76D1@colorremedies.com>,
	<546692DA.9040105@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2572881972324239321=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Chris Murphy <lists@colorremedies.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2572881972324239321==
Content-Type: multipart/alternative;
	boundary="_72263632-d409-4d1b-9981-ae412709ee08_"

--_72263632-d409-4d1b-9981-ae412709ee08_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi all=2C

So I used mount command mount -o ro /dev/md4 /xfs  (after having made the x=
fs directory)

Returned with saying 'Structure needs cleaning'

Here are parts of the dmesg relating to the raid array and the attempted mo=
unting
[   12.359728] EXT4-fs (sda7): mounting ext3 file system using the ext4 sub=
system
[   12.361314] EXT4-fs (sda7): mounted filesystem with ordered data mode. O=
pts: (null)
[   14.382337]  sde: sde1 sde2 sde3 sde4 sde5 sde6 sde7 sde8 sde9 sde10
[   14.388298] sd 4:0:0:0: [sde] No Caching mode page found
[   14.388303] sd 4:0:0:0: [sde] Assuming drive cache: write through
[   14.388308] sd 4:0:0:0: [sde] Attached SCSI disk
[   14.676543] md: bind<sde8>
[   14.681538] md: kicking non-fresh sdd8 from array!
[   14.681544] md: unbind<sdd8>
[   14.700028] md: export_rdev(sdd8)
[   14.700055] md: kicking non-fresh sdb8 from array!
[   14.700063] md: unbind<sdb8>
[   14.708021] md: export_rdev(sdb8)
[   14.709145] md/raid1:md1: active with 3 out of 5 mirrors
[   14.709165] md1: detected capacity change from 0 to 863567872
[   14.713570] md: bind<sde5>
[   14.713663]  md1: unknown partition table
[   14.715628] md: kicking non-fresh sdd5 from array!
[   14.715635] md: unbind<sdd5>
[   14.724074] md: export_rdev(sdd5)
[   14.724095] md: kicking non-fresh sdb5 from array!
[   14.724102] md: unbind<sdb5>
[   14.736021] md: export_rdev(sdb5)
[   14.737203] md/raid1:md3: active with 3 out of 5 mirrors
[   14.737222] md3: detected capacity change from 0 to 262078464
[   14.739508]  md3: unknown partition table
[   14.742037] md: bind<sde2>
[   14.748793] md: bind<sde9>
[   14.749250] md/raid:md4: device sde2 operational as raid disk 4
[   14.749252] md/raid:md4: device sdd2 operational as raid disk 3
[   14.749254] md/raid:md4: device sda2 operational as raid disk 0
[   14.749255] md/raid:md4: device sdb2 operational as raid disk 1
[   14.749257] md/raid:md4: device sdc2 operational as raid disk 2
[   14.749707] md/raid:md4: allocated 0kB
[   14.749814] md/raid:md4: raid level 5 active with 5 out of 5 devices=2C =
algorithm 2
[   14.749815] RAID conf printout:
[   14.749816]  --- level:5 rd:5 wd:5
[   14.749818]  disk 0=2C o:1=2C dev:sda2
[   14.749820]  disk 1=2C o:1=2C dev:sdb2
[   14.749821]  disk 2=2C o:1=2C dev:sdc2
[   14.749823]  disk 3=2C o:1=2C dev:sdd2
[   14.749824]  disk 4=2C o:1=2C dev:sde2
[   14.749846] md4: detected capacity change from 0 to 11994073661440
[   14.769544] md: kicking non-fresh sdd9 from array!
[   14.769553] md: unbind<sdd9>
[   14.770503]  md4: unknown partition table
[   14.784024] md: export_rdev(sdd9)
[   14.784040] md: kicking non-fresh sdb9 from array!
[   14.784045] md: unbind<sdb9>
[   14.796026] md: export_rdev(sdb9)
[   14.797259] md/raid1:md2: active with 3 out of 5 mirrors
[   14.797278] md2: detected capacity change from 0 to 896466944
[   14.804201]  md2: unknown partition table
[   15.536766] EXT4-fs (sdb8): mounting ext3 file system using the ext4 sub=
system
[   15.556508] EXT4-fs (sdb8): mounted filesystem with ordered data mode. O=
pts: (null)
[   15.575379] EXT4-fs (sdb9): mounting ext3 file system using the ext4 sub=
system
[   15.581829] EXT4-fs (sdb9): mounted filesystem with ordered data mode. O=
pts: (null)
[   16.044429] sd 5:0:0:0: [sdf] 60499968 512-byte logical blocks: (30.9 GB=
/28.8 GiB)
[   16.045044] sd 5:0:0:0: [sdf] Write Protect is off
[   16.045049] sd 5:0:0:0: [sdf] Mode Sense: 23 00 00 00
[   16.045669] sd 5:0:0:0: [sdf] No Caching mode page found
[   16.045673] sd 5:0:0:0: [sdf] Assuming drive cache: write through
[   16.049167] sd 5:0:0:0: [sdf] No Caching mode page found
[   16.049172] sd 5:0:0:0: [sdf] Assuming drive cache: write through
[   16.072442]  sdf: sdf1
[   16.075294] sd 5:0:0:0: [sdf] No Caching mode page found
[   16.075299] sd 5:0:0:0: [sdf] Assuming drive cache: write through
[   16.075303] sd 5:0:0:0: [sdf] Attached SCSI removable disk
[   38.533458] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   39.643476] FAT-fs (sdf1): Volume was not properly unmounted. Some data =
may be corrupt. Please run fsck.
[   40.485718] EXT4-fs (loop1): mounting ext2 file system using the ext4 su=
bsystem
[   40.489678] EXT4-fs (loop1): warning: mounting unchecked fs=2C running e=
2fsck is recommended
[   40.495984] EXT4-fs (loop1): mounted filesystem without journal. Opts: (=
null)
[   88.354507] Adding 255932k swap on /dev/sdb5.  Priority:-1 extents:1 acr=
oss:255932k FS
[   88.359216] Adding 255932k swap on /dev/sdd5.  Priority:-2 extents:1 acr=
oss:255932k FS


[ 1636.143467] systemd-hostnamed[20496]: Warning: nss-myhostname is not ins=
talled. Changing the local hostname might make it unresolveable. Please ins=
tall nss-myhostname!
[ 1918.676658] SGI XFS with ACLs=2C security attributes=2C realtime=2C larg=
e block/inode numbers=2C no debug enabled
[ 1925.660198] XFS (md4): Mounting Filesystem
[ 1925.824734] XFS (md4): log has mismatched uuid - can't recover
[ 1925.824748] XFS (md4): failed to find log head
[ 1925.824751] XFS (md4): log mount/recovery failed: error 117
[ 1925.824793] XFS (md4): log mount failed
[ 2049.523180] systemd-hostnamed[21362]: Warning: nss-myhostname is not ins=
talled. Changing the local hostname might make it unresolveable. Please ins=
tall nss-myhostname!
[20679.813021] XFS (md4): Mounting Filesystem
[20679.884528] XFS (md4): log has mismatched uuid - can't recover
[20679.884542] XFS (md4): failed to find log head
[20679.884545] XFS (md4): log mount/recovery failed: error 117
[20679.884590] XFS (md4): log mount failed
[21024.505390] XFS (md4): Mounting Filesystem
[21024.601886] XFS (md4): log has mismatched uuid - can't recover
[21024.601900] XFS (md4): failed to find log head
[21024.601903] XFS (md4): log mount/recovery failed: error 117
[21024.601946] XFS (md4): log mount failed
[21672.562447] XFS (md4): Mounting Filesystem
[21672.617195] XFS (md4): log has mismatched uuid - can't recover
[21672.617209] XFS (md4): failed to find log head
[21672.617212] XFS (md4): log mount/recovery failed: error 117
[21672.617246] XFS (md4): log mount failed

Rob

> Date: Fri=2C 14 Nov 2014 17:40:10 -0600
> From: sandeen@sandeen.net
> To: lists@colorremedies.com=3B robtench@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: Mismatch UUID
>=20
> On 11/14/14 4:31 PM=2C Chris Murphy wrote:
>=20
> > It=92s very good to ask instead of haphazardly trying things. Trying to
> > normally mount the file system should be safe=3B and then use dmesg to
> > check for kernel messages. The xfs kernel code is responsible for log
> > replay and making most kinds of repairs=2C anything it can=92t deal wit=
h
> > will be reported as a kernel message. If mount fails=2C report kernel
> > xfs related messages=2C and also the results from xfs_check -n.
>=20
> xfs_repair -n
>=20
> xfs_check is deprecated and has no -n option =3B)
>=20
> -Eric


 		 	   		  =

--_72263632-d409-4d1b-9981-ae412709ee08_
Content-Type: text/html; charset="Windows-1252"
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
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi all=2C<br><br>So I used mount=
 command mount -o ro /dev/md4 /xfs&nbsp=3B (after having made the xfs direc=
tory)<br><br>Returned with saying 'Structure needs cleaning'<br><br>Here ar=
e parts of the dmesg relating to the raid array and the attempted mounting<=
br>[&nbsp=3B&nbsp=3B 12.359728] EXT4-fs (sda7): mounting ext3 file system u=
sing the ext4 subsystem<br>[&nbsp=3B&nbsp=3B 12.361314] EXT4-fs (sda7): mou=
nted filesystem with ordered data mode. Opts: (null)<br>[&nbsp=3B&nbsp=3B 1=
4.382337]&nbsp=3B sde: sde1 sde2 sde3 sde4 sde5 sde6 sde7 sde8 sde9 sde10<b=
r>[&nbsp=3B&nbsp=3B 14.388298] sd 4:0:0:0: [sde] No Caching mode page found=
<br>[&nbsp=3B&nbsp=3B 14.388303] sd 4:0:0:0: [sde] Assuming drive cache: wr=
ite through<br>[&nbsp=3B&nbsp=3B 14.388308] sd 4:0:0:0: [sde] Attached SCSI=
 disk<br>[&nbsp=3B&nbsp=3B 14.676543] md: bind&lt=3Bsde8&gt=3B<br>[&nbsp=3B=
&nbsp=3B 14.681538] md: kicking non-fresh sdd8 from array!<br>[&nbsp=3B&nbs=
p=3B 14.681544] md: unbind&lt=3Bsdd8&gt=3B<br>[&nbsp=3B&nbsp=3B 14.700028] =
md: export_rdev(sdd8)<br>[&nbsp=3B&nbsp=3B 14.700055] md: kicking non-fresh=
 sdb8 from array!<br>[&nbsp=3B&nbsp=3B 14.700063] md: unbind&lt=3Bsdb8&gt=
=3B<br>[&nbsp=3B&nbsp=3B 14.708021] md: export_rdev(sdb8)<br>[&nbsp=3B&nbsp=
=3B 14.709145] md/raid1:md1: active with 3 out of 5 mirrors<br>[&nbsp=3B&nb=
sp=3B 14.709165] md1: detected capacity change from 0 to 863567872<br>[&nbs=
p=3B&nbsp=3B 14.713570] md: bind&lt=3Bsde5&gt=3B<br>[&nbsp=3B&nbsp=3B 14.71=
3663]&nbsp=3B md1: unknown partition table<br>[&nbsp=3B&nbsp=3B 14.715628] =
md: kicking non-fresh sdd5 from array!<br>[&nbsp=3B&nbsp=3B 14.715635] md: =
unbind&lt=3Bsdd5&gt=3B<br>[&nbsp=3B&nbsp=3B 14.724074] md: export_rdev(sdd5=
)<br>[&nbsp=3B&nbsp=3B 14.724095] md: kicking non-fresh sdb5 from array!<br=
>[&nbsp=3B&nbsp=3B 14.724102] md: unbind&lt=3Bsdb5&gt=3B<br>[&nbsp=3B&nbsp=
=3B 14.736021] md: export_rdev(sdb5)<br>[&nbsp=3B&nbsp=3B 14.737203] md/rai=
d1:md3: active with 3 out of 5 mirrors<br>[&nbsp=3B&nbsp=3B 14.737222] md3:=
 detected capacity change from 0 to 262078464<br>[&nbsp=3B&nbsp=3B 14.73950=
8]&nbsp=3B md3: unknown partition table<br>[&nbsp=3B&nbsp=3B 14.742037] md:=
 bind&lt=3Bsde2&gt=3B<br>[&nbsp=3B&nbsp=3B 14.748793] md: bind&lt=3Bsde9&gt=
=3B<br>[&nbsp=3B&nbsp=3B 14.749250] md/raid:md4: device sde2 operational as=
 raid disk 4<br>[&nbsp=3B&nbsp=3B 14.749252] md/raid:md4: device sdd2 opera=
tional as raid disk 3<br>[&nbsp=3B&nbsp=3B 14.749254] md/raid:md4: device s=
da2 operational as raid disk 0<br>[&nbsp=3B&nbsp=3B 14.749255] md/raid:md4:=
 device sdb2 operational as raid disk 1<br>[&nbsp=3B&nbsp=3B 14.749257] md/=
raid:md4: device sdc2 operational as raid disk 2<br>[&nbsp=3B&nbsp=3B 14.74=
9707] md/raid:md4: allocated 0kB<br>[&nbsp=3B&nbsp=3B 14.749814] md/raid:md=
4: raid level 5 active with 5 out of 5 devices=2C algorithm 2<br>[&nbsp=3B&=
nbsp=3B 14.749815] RAID conf printout:<br>[&nbsp=3B&nbsp=3B 14.749816]&nbsp=
=3B --- level:5 rd:5 wd:5<br>[&nbsp=3B&nbsp=3B 14.749818]&nbsp=3B disk 0=2C=
 o:1=2C dev:sda2<br>[&nbsp=3B&nbsp=3B 14.749820]&nbsp=3B disk 1=2C o:1=2C d=
ev:sdb2<br>[&nbsp=3B&nbsp=3B 14.749821]&nbsp=3B disk 2=2C o:1=2C dev:sdc2<b=
r>[&nbsp=3B&nbsp=3B 14.749823]&nbsp=3B disk 3=2C o:1=2C dev:sdd2<br>[&nbsp=
=3B&nbsp=3B 14.749824]&nbsp=3B disk 4=2C o:1=2C dev:sde2<br>[&nbsp=3B&nbsp=
=3B 14.749846] md4: detected capacity change from 0 to 11994073661440<br>[&=
nbsp=3B&nbsp=3B 14.769544] md: kicking non-fresh sdd9 from array!<br>[&nbsp=
=3B&nbsp=3B 14.769553] md: unbind&lt=3Bsdd9&gt=3B<br>[&nbsp=3B&nbsp=3B 14.7=
70503]&nbsp=3B md4: unknown partition table<br>[&nbsp=3B&nbsp=3B 14.784024]=
 md: export_rdev(sdd9)<br>[&nbsp=3B&nbsp=3B 14.784040] md: kicking non-fres=
h sdb9 from array!<br>[&nbsp=3B&nbsp=3B 14.784045] md: unbind&lt=3Bsdb9&gt=
=3B<br>[&nbsp=3B&nbsp=3B 14.796026] md: export_rdev(sdb9)<br>[&nbsp=3B&nbsp=
=3B 14.797259] md/raid1:md2: active with 3 out of 5 mirrors<br>[&nbsp=3B&nb=
sp=3B 14.797278] md2: detected capacity change from 0 to 896466944<br>[&nbs=
p=3B&nbsp=3B 14.804201]&nbsp=3B md2: unknown partition table<br>[&nbsp=3B&n=
bsp=3B 15.536766] EXT4-fs (sdb8): mounting ext3 file system using the ext4 =
subsystem<br>[&nbsp=3B&nbsp=3B 15.556508] EXT4-fs (sdb8): mounted filesyste=
m with ordered data mode. Opts: (null)<br>[&nbsp=3B&nbsp=3B 15.575379] EXT4=
-fs (sdb9): mounting ext3 file system using the ext4 subsystem<br>[&nbsp=3B=
&nbsp=3B 15.581829] EXT4-fs (sdb9): mounted filesystem with ordered data mo=
de. Opts: (null)<br>[&nbsp=3B&nbsp=3B 16.044429] sd 5:0:0:0: [sdf] 60499968=
 512-byte logical blocks: (30.9 GB/28.8 GiB)<br>[&nbsp=3B&nbsp=3B 16.045044=
] sd 5:0:0:0: [sdf] Write Protect is off<br>[&nbsp=3B&nbsp=3B 16.045049] sd=
 5:0:0:0: [sdf] Mode Sense: 23 00 00 00<br>[&nbsp=3B&nbsp=3B 16.045669] sd =
5:0:0:0: [sdf] No Caching mode page found<br>[&nbsp=3B&nbsp=3B 16.045673] s=
d 5:0:0:0: [sdf] Assuming drive cache: write through<br>[&nbsp=3B&nbsp=3B 1=
6.049167] sd 5:0:0:0: [sdf] No Caching mode page found<br>[&nbsp=3B&nbsp=3B=
 16.049172] sd 5:0:0:0: [sdf] Assuming drive cache: write through<br>[&nbsp=
=3B&nbsp=3B 16.072442]&nbsp=3B sdf: sdf1<br>[&nbsp=3B&nbsp=3B 16.075294] sd=
 5:0:0:0: [sdf] No Caching mode page found<br>[&nbsp=3B&nbsp=3B 16.075299] =
sd 5:0:0:0: [sdf] Assuming drive cache: write through<br>[&nbsp=3B&nbsp=3B =
16.075303] sd 5:0:0:0: [sdf] Attached SCSI removable disk<br>[&nbsp=3B&nbsp=
=3B 38.533458] squashfs: version 4.0 (2009/01/31) Phillip Lougher<br>[&nbsp=
=3B&nbsp=3B 39.643476] FAT-fs (sdf1): Volume was not properly unmounted. So=
me data may be corrupt. Please run fsck.<br>[&nbsp=3B&nbsp=3B 40.485718] EX=
T4-fs (loop1): mounting ext2 file system using the ext4 subsystem<br>[&nbsp=
=3B&nbsp=3B 40.489678] EXT4-fs (loop1): warning: mounting unchecked fs=2C r=
unning e2fsck is recommended<br>[&nbsp=3B&nbsp=3B 40.495984] EXT4-fs (loop1=
): mounted filesystem without journal. Opts: (null)<br>[&nbsp=3B&nbsp=3B 88=
.354507] Adding 255932k swap on /dev/sdb5.&nbsp=3B Priority:-1 extents:1 ac=
ross:255932k FS<br>[&nbsp=3B&nbsp=3B 88.359216] Adding 255932k swap on /dev=
/sdd5.&nbsp=3B Priority:-2 extents:1 across:255932k FS<br><br><br>[ 1636.14=
3467] systemd-hostnamed[20496]: Warning: nss-myhostname is not installed. C=
hanging the local hostname might make it unresolveable. Please install nss-=
myhostname!<br>[ 1918.676658] SGI XFS with ACLs=2C security attributes=2C r=
ealtime=2C large block/inode numbers=2C no debug enabled<br>[ 1925.660198] =
XFS (md4): Mounting Filesystem<br>[ 1925.824734] XFS (md4): log has mismatc=
hed uuid - can't recover<br>[ 1925.824748] XFS (md4): failed to find log he=
ad<br>[ 1925.824751] XFS (md4): log mount/recovery failed: error 117<br>[ 1=
925.824793] XFS (md4): log mount failed<br>[ 2049.523180] systemd-hostnamed=
[21362]: Warning: nss-myhostname is not installed. Changing the local hostn=
ame might make it unresolveable. Please install nss-myhostname!<br>[20679.8=
13021] XFS (md4): Mounting Filesystem<br>[20679.884528] XFS (md4): log has =
mismatched uuid - can't recover<br>[20679.884542] XFS (md4): failed to find=
 log head<br>[20679.884545] XFS (md4): log mount/recovery failed: error 117=
<br>[20679.884590] XFS (md4): log mount failed<br>[21024.505390] XFS (md4):=
 Mounting Filesystem<br>[21024.601886] XFS (md4): log has mismatched uuid -=
 can't recover<br>[21024.601900] XFS (md4): failed to find log head<br>[210=
24.601903] XFS (md4): log mount/recovery failed: error 117<br>[21024.601946=
] XFS (md4): log mount failed<br>[21672.562447] XFS (md4): Mounting Filesys=
tem<br>[21672.617195] XFS (md4): log has mismatched uuid - can't recover<br=
>[21672.617209] XFS (md4): failed to find log head<br>[21672.617212] XFS (m=
d4): log mount/recovery failed: error 117<br>[21672.617246] XFS (md4): log =
mount failed<br><br>Rob<br><br><div>&gt=3B Date: Fri=2C 14 Nov 2014 17:40:1=
0 -0600<br>&gt=3B From: sandeen@sandeen.net<br>&gt=3B To: lists@colorremedi=
es.com=3B robtench@hotmail.com<br>&gt=3B CC: xfs@oss.sgi.com<br>&gt=3B Subj=
ect: Re: Mismatch UUID<br>&gt=3B <br>&gt=3B On 11/14/14 4:31 PM=2C Chris Mu=
rphy wrote:<br>&gt=3B <br>&gt=3B &gt=3B It=92s very good to ask instead of =
haphazardly trying things. Trying to<br>&gt=3B &gt=3B normally mount the fi=
le system should be safe=3B and then use dmesg to<br>&gt=3B &gt=3B check fo=
r kernel messages. The xfs kernel code is responsible for log<br>&gt=3B &gt=
=3B replay and making most kinds of repairs=2C anything it can=92t deal wit=
h<br>&gt=3B &gt=3B will be reported as a kernel message. If mount fails=2C =
report kernel<br>&gt=3B &gt=3B xfs related messages=2C and also the results=
 from xfs_check -n.<br>&gt=3B <br>&gt=3B xfs_repair -n<br>&gt=3B <br>&gt=3B=
 xfs_check is deprecated and has no -n option =3B)<br>&gt=3B <br>&gt=3B -Er=
ic<br><br><br></div> 		 	   		  </div></body>
</html>=

--_72263632-d409-4d1b-9981-ae412709ee08_--


--===============2572881972324239321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2572881972324239321==--
