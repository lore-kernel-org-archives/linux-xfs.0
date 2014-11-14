Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8B1D7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 21:19:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C76448F8040
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 19:19:29 -0800 (PST)
Received: from BLU004-OMC4S33.hotmail.com (blu004-omc4s33.hotmail.com
	[65.55.111.172]) by cuda.sgi.com with ESMTP id oWHonOQCUN6HsrcK
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 13 Nov 2014 19:19:27 -0800 (PST)
Message-ID: <BLU172-W37BB23DD2CF1738963BC01C48C0@phx.gbl>
From: Robert Tench <robtench@hotmail.com>
Subject: Mismatch of UUIDS on raid 5
Date: Fri, 14 Nov 2014 14:19:27 +1100
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0092531451006343349=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0092531451006343349==
Content-Type: multipart/alternative;
	boundary="_d4f14021-1f03-4966-9573-1a848415de13_"

--_d4f14021-1f03-4966-9573-1a848415de13_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi there=2C

I am seeking some assistance with an XFS filesystem that will not mount. I =
have a Lacie NAS 5 Big Network 2 that has failed on me and basically I ende=
d up losing access to my Shares and files.

While I have backed up what I could using Ufsexplorer=2C I can see that man=
y folders are incomplete.

I have then set about removing the drives and connecting them to a Linux se=
tup. $ of the drives are connected to Sata ports and the 5th is connected v=
ia a sata to usb adaptor.

Have reassembled the raid array=2C but when I try to mount the raid I get a=
n error back stating that the 'structure needs cleaning.'

I performed xfs_repair -n /dev/md4 which fed back a huge amount of issues -=
 namely the mismatch of UUID between the superblock and log files.

I am trying to save the report of this and sendf to you put having issues a=
t the moment getting it to save the report correctly.

I am a complete Linux novice but would be interested to know if there is an=
yway to resolve this problem?

Regards=2C
Rob =20

Kernel Version: Linux ubuntu 3.13.0-32-generic #57-Ubuntu SMP Tue Jul 15 03=
:51:08 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux


xfsprogs version: xfs_repair version 3.1.9

Dual Core

Contents of /proc/mem/info: MemTotal:        4012768 kB
MemFree:         1745572 kB
Buffers:          206952 kB
Cached:          1240484 kB
SwapCached:            0 kB
Active:          1018332 kB
Inactive:        1064536 kB
Active(anon):     637004 kB
Inactive(anon):   181272 kB
Active(file):     381328 kB
Inactive(file):   883264 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        511864 kB
SwapFree:         511864 kB
Dirty:               384 kB
Writeback:             0 kB
AnonPages:        635468 kB
Mapped:           126116 kB
Shmem:            182856 kB
Slab:             109136 kB
SReclaimable:      83716 kB
SUnreclaim:        25420 kB
KernelStack:        3176 kB
PageTables:        25476 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2518248 kB
Committed_AS:    3101376 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      346400 kB
VmallocChunk:   34359384300 kB
HardwareCorrupted:     0 kB
AnonHugePages:    172032 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       44544 kB
DirectMap2M:     4114432 kB

contents of /proc/mounts:rootfs / rootfs rw=2Csize=3D1994836k=2Cnr_inodes=
=3D498709 0 0
sysfs /sys sysfs rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime 0 0
proc /proc proc rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime 0 0
udev /dev devtmpfs rw=2Crelatime=2Csize=3D1994852k=2Cnr_inodes=3D498713=2Cm=
ode=3D755 0 0
devpts /dev/pts devpts rw=2Cnosuid=2Cnoexec=2Crelatime=2Cgid=3D5=2Cmode=3D6=
20=2Cptmxmode=3D000 0 0
tmpfs /run tmpfs rw=2Cnosuid=2Cnoexec=2Crelatime=2Csize=3D401280k=2Cmode=3D=
755 0 0
/dev/sdf1 /cdrom vfat rw=2Crelatime=2Cfmask=3D0022=2Cdmask=3D0022=2Ccodepag=
e=3D437=2Ciocharset=3Diso8859-1=2Cshortname=3Dmixed=2Cerrors=3Dremount-ro 0=
 0
/dev/loop0 /rofs squashfs ro=2Cnoatime 0 0
/dev/loop1 /cow ext2 rw=2Cnoatime 0 0
/cow / overlayfs rw=2Crelatime=2Clowerdir=3D//filesystem.squashfs=2Cupperdi=
r=3D/cow 0 0
none /sys/fs/cgroup tmpfs rw=2Crelatime=2Csize=3D4k=2Cmode=3D755 0 0
none /sys/fs/fuse/connections fusectl rw=2Crelatime 0 0
none /sys/kernel/debug debugfs rw=2Crelatime 0 0
none /sys/kernel/security securityfs rw=2Crelatime 0 0
tmpfs /tmp tmpfs rw=2Cnosuid=2Cnodev=2Crelatime 0 0
none /run/lock tmpfs rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime=2Csize=3D5120k=
 0 0
none /run/shm tmpfs rw=2Cnosuid=2Cnodev=2Crelatime 0 0
none /run/user tmpfs rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime=2Csize=3D10240=
0k=2Cmode=3D755 0 0
none /sys/fs/pstore pstore rw=2Crelatime 0 0
systemd /sys/fs/cgroup/systemd cgroup rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelati=
me=2Cname=3Dsystemd 0 0
gvfsd-fuse /run/user/999/gvfs fuse.gvfsd-fuse rw=2Cnosuid=2Cnodev=2Crelatim=
e=2Cuser_id=3D999=2Cgroup_id=3D999 0 0


Contents of /proc/partitions: major minor  #blocks  name

   7        0     961232 loop0
   7        1    4147200 loop1
   8       16 2930266584 sdb
   8       17       1024 sdb1
   8       18 2928240776 sdb2
   8       19        934 sdb3
   8       20       1024 sdb4
   8       21     256000 sdb5
   8       22       8033 sdb6
   8       23      16065 sdb7
   8       24     843413 sdb8
   8       25     875543 sdb9
   8       26       8033 sdb10
   8       48 2930266584 sdd
   8       49       1024 sdd1
   8       50 2928240776 sdd2
   8       51        934 sdd3
   8       52       1024 sdd4
   8       53     256000 sdd5
   8       54       8033 sdd6
   8       55      16065 sdd7
   8       56     843413 sdd8
   8       57     875543 sdd9
   8       58       8033 sdd10
   8        0 2930266584 sda
   8        1       1024 sda1
   8        2 2928240776 sda2
   8        3        934 sda3
   8        4       1024 sda4
   8        5     256000 sda5
   8        6       8033 sda6
   8        7      16065 sda7
   8        8     843413 sda8
   8        9     875543 sda9
   8       10       8033 sda10
   8       32 2930266584 sdc
   8       33       1024 sdc1
   8       34 2928240776 sdc2
   8       35        934 sdc3
   8       36       1024 sdc4
   8       37     256000 sdc5
   8       38       8033 sdc6
   8       39      16065 sdc7
   8       40     843413 sdc8
   8       41     875543 sdc9
   8       42       8033 sdc10
   9        3     255936 md3
   9        4 11712962560 md4
   9        1     843328 md1
   9        2     875456 md2
   9        0      16000 md0
   8       64 2930266584 sde
   8       65       1024 sde1
   8       66 2928240776 sde2
   8       67        934 sde3
   8       68       1024 sde4
   8       69     256000 sde5
   8       70       8033 sde6
   8       71      16065 sde7
   8       72     843413 sde8
   8       73     875543 sde9
   8       74       8033 sde10
   8       80   30249984 sdf
   8       81   30247936 sdf1

Raid Configuration - Hardware Raid from a Lacie NAS 5Big Network 2 (Raid 5)

Types of Disks: Seagate Barracuda 3000gb X 5


 		 	   		  =

--_d4f14021-1f03-4966-9573-1a848415de13_
Content-Type: text/html; charset="iso-8859-1"
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
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi there=2C<br><br>I am seeking =
some assistance with an XFS filesystem that will not mount. I have a Lacie =
NAS 5 Big Network 2 that has failed on me and basically I ended up losing a=
ccess to my Shares and files.<br><br>While I have backed up what I could us=
ing Ufsexplorer=2C I can see that many folders are incomplete.<br><br>I hav=
e then set about removing the drives and connecting them to a Linux setup. =
$ of the drives are connected to Sata ports and the 5th is connected via a =
sata to usb adaptor.<br><br>Have reassembled the raid array=2C but when I t=
ry to mount the raid I get an error back stating that the 'structure needs =
cleaning.'<br><br>I performed xfs_repair -n /dev/md4 which fed back a huge =
amount of issues - namely the mismatch of UUID between the superblock and l=
og files.<br><br>I am trying to save the report of this and sendf to you pu=
t having issues at the moment getting it to save the report correctly.<br><=
br>I am a complete Linux novice but would be interested to know if there is=
 anyway to resolve this problem?<br><br>Regards=2C<br>Rob&nbsp=3B <br><br>K=
ernel Version: Linux ubuntu 3.13.0-32-generic #57-Ubuntu SMP Tue Jul 15 03:=
51:08 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux<br><br><br>xfsprogs version: =
xfs_repair version 3.1.9<br><br>Dual Core<br><br>Contents of /proc/mem/info=
: MemTotal:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 4012768=
 kB<br>MemFree:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B 1745572 kB<br>Buffers:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B 206952 kB<br>Cached:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1240484 kB<br>SwapCached:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B 0 kB<br>Active:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B 1018332 kB<br>Inactive:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 1064536 kB<br>Active(anon):&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B 637004 kB<br>Inactive(anon):&nbsp=3B&nbsp=3B 181272 kB<br>Acti=
ve(file):&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 381328 kB<br>Inactive(file):&nbsp=
=3B&nbsp=3B 883264 kB<br>Unevictable:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0 kB<br>Mlocked:&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B 0 kB<br>SwapTotal:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B 511864 kB<br>SwapFree:&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 511864 kB<br>Dirty:&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B 384 kB<br>Writeback:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0 kB<br>AnonP=
ages:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 635468 kB<br>=
Mapped:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B 126116 kB<br>Shmem:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 182856 kB<br>Slab:&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B 109136 kB<br>SReclaimable:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 83716 kB<br>SUnreclaim:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B 25420 kB<br>KernelStack:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B 3176 kB<br>PageTables:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B 25476 kB<br>NFS_Unstable:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0 kB<br>Bounce:&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0 kB<br>WritebackTmp:&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0 kB<br>CommitLimit:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 2518248 kB<br>Committed_AS:&nbsp=3B&nbsp=3B&nbs=
p=3B 3101376 kB<br>VmallocTotal:&nbsp=3B&nbsp=3B 34359738367 kB<br>VmallocU=
sed:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 346400 kB<br>VmallocChunk:&nbs=
p=3B&nbsp=3B 34359384300 kB<br>HardwareCorrupted:&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B 0 kB<br>AnonHugePages:&nbsp=3B&nbsp=3B&nbsp=3B 172032 kB<br>HugePage=
s_Total:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0<br>HugePages_Fre=
e:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0<br>HugePages_R=
svd:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0<br>HugePages=
_Surp:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0<br>Hugepag=
esize:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 2048 kB<br>DirectMap=
4k:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 44544 kB<br>DirectMap2M=
:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 4114432 kB<br><br>contents of /proc/mount=
s:rootfs / rootfs rw=2Csize=3D1994836k=2Cnr_inodes=3D498709 0 0<br>sysfs /s=
ys sysfs rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime 0 0<br>proc /proc proc rw=
=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime 0 0<br>udev /dev devtmpfs rw=2Crelati=
me=2Csize=3D1994852k=2Cnr_inodes=3D498713=2Cmode=3D755 0 0<br>devpts /dev/p=
ts devpts rw=2Cnosuid=2Cnoexec=2Crelatime=2Cgid=3D5=2Cmode=3D620=2Cptmxmode=
=3D000 0 0<br>tmpfs /run tmpfs rw=2Cnosuid=2Cnoexec=2Crelatime=2Csize=3D401=
280k=2Cmode=3D755 0 0<br>/dev/sdf1 /cdrom vfat rw=2Crelatime=2Cfmask=3D0022=
=2Cdmask=3D0022=2Ccodepage=3D437=2Ciocharset=3Diso8859-1=2Cshortname=3Dmixe=
d=2Cerrors=3Dremount-ro 0 0<br>/dev/loop0 /rofs squashfs ro=2Cnoatime 0 0<b=
r>/dev/loop1 /cow ext2 rw=2Cnoatime 0 0<br>/cow / overlayfs rw=2Crelatime=
=2Clowerdir=3D//filesystem.squashfs=2Cupperdir=3D/cow 0 0<br>none /sys/fs/c=
group tmpfs rw=2Crelatime=2Csize=3D4k=2Cmode=3D755 0 0<br>none /sys/fs/fuse=
/connections fusectl rw=2Crelatime 0 0<br>none /sys/kernel/debug debugfs rw=
=2Crelatime 0 0<br>none /sys/kernel/security securityfs rw=2Crelatime 0 0<b=
r>tmpfs /tmp tmpfs rw=2Cnosuid=2Cnodev=2Crelatime 0 0<br>none /run/lock tmp=
fs rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime=2Csize=3D5120k 0 0<br>none /run/=
shm tmpfs rw=2Cnosuid=2Cnodev=2Crelatime 0 0<br>none /run/user tmpfs rw=2Cn=
osuid=2Cnodev=2Cnoexec=2Crelatime=2Csize=3D102400k=2Cmode=3D755 0 0<br>none=
 /sys/fs/pstore pstore rw=2Crelatime 0 0<br>systemd /sys/fs/cgroup/systemd =
cgroup rw=2Cnosuid=2Cnodev=2Cnoexec=2Crelatime=2Cname=3Dsystemd 0 0<br>gvfs=
d-fuse /run/user/999/gvfs fuse.gvfsd-fuse rw=2Cnosuid=2Cnodev=2Crelatime=2C=
user_id=3D999=2Cgroup_id=3D999 0 0<br><br><br>Contents of /proc/partitions:=
 major minor&nbsp=3B #blocks&nbsp=3B name<br><br>&nbsp=3B&nbsp=3B 7&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B 961232 loop0<br>&nbsp=3B&nbsp=3B 7&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B 1&nbsp=3B&nbsp=3B&nbsp=3B 4147200 loop1<br>&nbsp=3B=
&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 16 2930266584 sd=
b<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 17&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1024 sdb1<br>&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 18 2928240776 sdb2<br=
>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 19&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 934 sdb3<br>&nbsp=3B&nb=
sp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 20&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1024 sdb4<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 21&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 256=
000 sdb5<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 22&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8033 sdb6<br>&nbsp=
=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 23&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B 16065 sdb7<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 24&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8434=
13 sdb8<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 25&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 875543 sdb9<br>&nbsp=3B&nbsp=3B 8&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 26&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B 8033 sdb10<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 48 2930266584 sdd<br>&nbsp=3B&nbsp=3B 8&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 49&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B 1024 sdd1<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B 50 2928240776 sdd2<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 51&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B 934 sdd3<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B 52&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
1024 sdd4<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B 53&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 256000 sdd5<br>&nbsp=3B&nbsp=3B 8&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 54&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B 8033 sdd6<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 55&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1606=
5 sdd7<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 56&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 843413 sdd8<br>&nbsp=3B&nbsp=3B 8&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 57&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B 875543 sdd9<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B 58&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8033 sdd10<=
br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 0 2930266584 sda<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B 1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1=
024 sda1<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B 2 2928240776 sda2<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 3&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B 934 sda3<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 4&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 1024 sda4<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B 5&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 256000 sda5<br>&nbsp=3B&=
nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 6&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8033 sda6<br>&nbsp=3B&nbsp=3B 8&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 7&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B 16065 sda7<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 84341=
3 sda8<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B 9&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 875543 sda9<br>&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 10&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8033 sda10<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 32 2930266584 sdc<br>&nbsp=3B&nbsp=3B 8=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 33&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B 1024 sdc1<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B 34 2928240776 sdc2<br>&nbsp=3B&nbsp=3B 8&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 35&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 934 sdc3<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 36&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B 1024 sdc4<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B 37&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 256000 sdc5<br>&nbsp=3B&nbs=
p=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 38&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8033 sdc6<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 39&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 16065 sdc7<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B 40&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 843413 sdc8<br>&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 41&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B 875543 sdc9<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B 42&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 803=
3 sdc10<br>&nbsp=3B&nbsp=3B 9&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B 3&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 255936 md3<br>&nbsp=3B&nbsp=
=3B 9&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 4 11712962560=
 md4<br>&nbsp=3B&nbsp=3B 9&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B 1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 843328 md1<br>&nbsp=3B&nbsp=3B 9&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 2&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B 875456 md2<br>&nbsp=3B&nbsp=3B 9&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B 0&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1600=
0 md0<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
 64 2930266584 sde<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B 65&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1024 sde1<=
br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 66 29=
28240776 sde2<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B 67&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 934 sde=
3<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 68&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1024 sde4<br>&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 69&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B 256000 sde5<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B 70&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 803=
3 sde6<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 71&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 16065 sde7<br>&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 72&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B 843413 sde8<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B 73&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 875543 sde9<br>&nbs=
p=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 74&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8033 sde10<br>&nbsp=3B&nbsp=3B 8&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 80&nbsp=3B&nbsp=3B 30249984 sd=
f<br>&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 81&=
nbsp=3B&nbsp=3B 30247936 sdf1<br><br>Raid Configuration - Hardware Raid fro=
m a Lacie NAS 5Big Network 2 (Raid 5)<br><br>Types of Disks: Seagate Barrac=
uda 3000gb X 5<br><br><br> 		 	   		  </div></body>
</html>=

--_d4f14021-1f03-4966-9573-1a848415de13_--


--===============0092531451006343349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0092531451006343349==--
