Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9024629DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 16:13:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DA4C304043
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 14:13:12 -0800 (PST)
Received: from nihrelayxway3.hub.nih.gov (nihrelayxway3.hub.nih.gov
	[128.231.90.108]) by cuda.sgi.com with ESMTP id
	Pv7XtzAvwnHpzcNO for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 14:13:08 -0800 (PST)
MIME-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: weird quota issue
From: "Weber, Charles (NIH/NIA/IRP) [C]" <weberc@grc.nia.nih.gov>
In-Reply-To: <20141222204857.GK24183@dastard>
Date: Mon, 22 Dec 2014 17:13:06 -0500
Message-ID: <6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7065980215911023220=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7065980215911023220==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_181BB050-F4D9-467D-852B-B91DF8DB60FA"

--Apple-Mail=_181BB050-F4D9-467D-852B-B91DF8DB60FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Thanks for replying. The project part is a red herring and I have =
abandoned it. The only reason project quotas even came up was the =
winbind/quota issue. UID is fine.
The more interesting part is the way the /proc/self/mounts and =
mtab/fstab are not coherent.

2 filesystems have identical (cut and paste) setting in fstab. Below =
results are after setting forcefsck and rebooting.

mount <enter>
/dev/mapper/irphome_vg-home_lv on /home type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)
/dev/mapper/irphome_vg-imap_lv on /mail type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)

cat /proc/self/mounts
/dev/mapper/irphome_vg-home_lv /home xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,noquota 0 0
/dev/mapper/irphome_vg-imap_lv /mail xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,usrquota,prjquota 0 0

cat /etc/mtab
/dev/mapper/irphome_vg-home_lv /home xfs =
rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota 0 0
/dev/mapper/irphome_vg-imap_lv /mail xfs =
rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota 0 0

List of details per wiki
#############
The most interesting thing in dmesg output was this:
XFS (dm-7): Failed to initialize disk quotas.  from /dev/disk/by-id dm-7 =
is my problem logical volume =3D> dm-name-irphome_vg-home_lv -> =
../../dm-7
#############

2.6.32-504.3.3.el6.x86_64

xfs_repair version 3.1.1

24 cpu using hyperthreading, so 12 real

mem
MemTotal:       49410148 kB
MemFree:          269628 kB
Buffers:          144256 kB
Cached:         47388884 kB
SwapCached:            0 kB
Active:           731016 kB
Inactive:       46871512 kB
Active(anon):       2976 kB
Inactive(anon):    71740 kB
Active(file):     728040 kB
Inactive(file): 46799772 kB
Unevictable:        5092 kB
Mlocked:            5092 kB
SwapTotal:      14331900 kB
SwapFree:       14331900 kB
Dirty:           3773708 kB
Writeback:             0 kB
AnonPages:         75696 kB
Mapped:           190092 kB
Shmem:               312 kB
Slab:            1012580 kB
SReclaimable:     875160 kB
SUnreclaim:       137420 kB
KernelStack:        5512 kB
PageTables:         9332 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    39036972 kB
Committed_AS:     293324 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      191424 kB
VmallocChunk:   34334431824 kB
HardwareCorrupted:     0 kB
AnonHugePages:      2048 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        6384 kB
DirectMap2M:     2080768 kB
DirectMap1G:    48234496 kB

/proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devtmpfs /dev devtmpfs =
rw,relatime,size=3D24689396k,nr_inodes=3D6172349,mode=3D755 0 0
devpts /dev/pts devpts rw,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/mapper/VolGroup-lv_root / ext4 rw,relatime,barrier=3D1,data=3Dordered=
 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
/dev/sda1 /boot ext4 rw,relatime,barrier=3D1,data=3Dordered 0 0
/dev/mapper/irphome_vg-home_lv /home xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,noquota 0 0
/dev/mapper/irphome_vg-imap_lv /mail xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,usrquota,prjquota 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
/dev/mapper/homesavelv-homesavelv /homesave xfs =
rw,relatime,attr2,delaylog,sunit=3D32,swidth=3D32768,noquota 0 0

 /proc/partitions
major minor  #blocks  name

   8        0  143338560 sda
   8        1     512000 sda1
   8        2  142825472 sda2
   8       32 17179869184 sdc
   8       96 17179869184 sdg
   8      128 17179869184 sdi
   8       48 17179869184 sdd
   8      112 17179869184 sdh
   8       64 17179869184 sde
 253        0   52428800 dm-0
 253        1   14331904 dm-1
   8      160 17179869184 sdk
   8      176 17179869184 sdl
   8      192 17179869184 sdm
   8      224 17179869184 sdo
   8      240 17179869184 sdp
  65        0 17179869184 sdq
 253        3 17179869184 dm-3
 253        4 17179869184 dm-4
 253        5 17179869184 dm-5
 253        6 5368709120 dm-6
 253        7 42949672960 dm-7
   8       16 2147483648 sdb
   8       80 2147483648 sdf
 253        2 2147483648 dm-2
   8      144 2147483648 sdj
   8      208 2147483648 sdn
 253        8 2147467264 dm-8
=20
 Raid layout
 3Par SAN  raid 6 12 4TB SAS disks (more or less, 3Par does some =
non-classic raid stuff)
=20
 mpathd (360002ac000000000000000080000bf12) dm-4 3PARdata,VV
size=3D16T features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 1:0:3:12 sdi 8:128 active ready running
  |- 2:0:0:12 sdm 8:192 active ready running
  |- 1:0:2:12 sde 8:64  active ready running
  `- 2:0:5:12 sdq 65:0  active ready running
mpathc (360002ac000000000000000070000bf12) dm-5 3PARdata,VV
size=3D16T features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 1:0:2:11 sdd 8:48  active ready running
  |- 2:0:0:11 sdl 8:176 active ready running
  |- 1:0:3:11 sdh 8:112 active ready running
  `- 2:0:5:11 sdp 8:240 active ready running
mpathb (360002ac000000000000000060000bf12) dm-3 3PARdata,VV
size=3D16T features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 1:0:2:10 sdc 8:32  active ready running
  |- 2:0:0:10 sdk 8:160 active ready running
  |- 1:0:3:10 sdg 8:96  active ready running
  `- 2:0:5:10 sdo 8:224 active ready running
mpathg (360002ac000000000000000110000bf12) dm-2 3PARdata,VV
size=3D2.0T features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 1:0:2:1  sdb 8:16  active ready running
  |- 2:0:5:1  sdj 8:144 active ready running
  |- 1:0:3:1  sdf 8:80  active ready running
  `- 2:0:0:1  sdn 8:208 active ready running

pvscan
  PV /dev/mapper/mpathd   VG irphome_vg   lvm2 [16.00 TiB / 3.00 TiB =
free]
  PV /dev/mapper/mpathb   VG irphome_vg   lvm2 [16.00 TiB / 0    free]
  PV /dev/mapper/mpathc   VG irphome_vg   lvm2 [16.00 TiB / 0    free]
  PV /dev/mapper/mpathg   VG homesavelv   lvm2 [2.00 TiB / 0    free]
  PV /dev/sda2            VG VolGroup     lvm2 [136.21 GiB / 72.54 GiB =
free]
  Total: 5 [50.13 TiB] / in use: 5 [50.13 TiB] / in no VG: 0 [0   ]
 vgscan
  Reading all physical volumes.  This may take a while...
  Found volume group "irphome_vg" using metadata type lvm2
  Found volume group "homesavelv" using metadata type lvm2
  Found volume group "VolGroup" using metadata type lvm2
 lvscan
  ACTIVE            '/dev/irphome_vg/imap_lv' [5.00 TiB] inherit
  ACTIVE            '/dev/irphome_vg/home_lv' [40.00 TiB] inherit
  ACTIVE            '/dev/homesavelv/homesavelv' [2.00 TiB] inherit
  ACTIVE            '/dev/VolGroup/lv_root' [50.00 GiB] inherit
  ACTIVE            '/dev/VolGroup/lv_swap' [13.67 GiB] inherit
 =20
  lvdisplay irphome_vg/home_lv
  --- Logical volume ---
  LV Path                /dev/irphome_vg/home_lv
  LV Name                home_lv
  VG Name                irphome_vg
  LV UUID                8wLM12-e43p-UhIh-YTXn-kMBx-RffN-yNz2V5
  LV Write Access        read/write
  LV Creation host, time nuhome.irp.nia.nih.gov =
<http://nuhome.irp.nia.nih.gov/>, 2014-12-01 17:53:47 -0500
  LV Status              available
  # open                 1
  LV Size                40.00 TiB
  Current LE             10485760
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:7

Disks, write cache etc are controlled by 3Par SAN, I just define up to =
16TB blocks and export to host over FC or ISCSI.
In this case I am using FC.

 xfs_info /dev/irphome_vg/home_lv=20
meta-data=3D/dev/mapper/irphome_vg-home_lv isize=3D256    agcount=3D40, =
agsize=3D268435452 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
data     =3D                       bsize=3D4096   blocks=3D10737418080, =
imaxpct=3D5
         =3D                       sunit=3D4      swidth=3D4096 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D4 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

xfs_info /dev/irphome_vg/imap_lv=20
meta-data=3D/dev/mapper/irphome_vg-imap_lv isize=3D256    agcount=3D32, =
agsize=3D41943036 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
data     =3D                       bsize=3D4096   blocks=3D1342177152, =
imaxpct=3D5
         =3D                       sunit=3D4      swidth=3D4096 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D4 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

dmesg output
SGI XFS with ACLs, security attributes, large block/inode numbers, no =
debug enabled
SGI XFS Quota Management subsystem
XFS (dm-7): delaylog is the default now, option is deprecated.
XFS (dm-7): Mounting Filesystem
XFS (dm-7): Ending clean mount
XFS (dm-7): Failed to initialize disk quotas.
XFS (dm-6): delaylog is the default now, option is deprecated.
XFS (dm-6): Mounting Filesystem
XFS (dm-6): Ending clean mount


scsi 2:0:0:0: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
scsi 2:0:0:10: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:0:0: [sdj] 4194304 512-byte logical blocks: (2.14 GB/2.00 GiB)
scsi 2:0:0:11: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:0:10: [sdk] 34359738368 512-byte logical blocks: (17.5 TB/16.0 =
TiB)
sd 2:0:0:0: [sdj] Write Protect is off
sd 2:0:0:0: [sdj] Mode Sense: 8b 00 10 08
scsi 2:0:0:12: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:0:11: [sdl] 34359738368 512-byte logical blocks: (17.5 TB/16.0 =
TiB)
sd 2:0:0:0: [sdj] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
scsi 2:0:0:254: Enclosure         3PARdata SES              3210 PQ: 0 =
ANSI: 6
sd 2:0:0:12: [sdm] 34359738368 512-byte logical blocks: (17.5 TB/16.0 =
TiB)
scsi 2:0:1:0: RAID              HP       HSV400           0005 PQ: 0 =
ANSI: 5
scsi 2:0:2:0: RAID              HP       HSV400           0005 PQ: 0 =
ANSI: 5
 sdj:
sd 2:0:0:10: [sdk] Write Protect is off
sd 2:0:0:10: [sdk] Mode Sense: 8b 00 10 08
sd 2:0:0:11: [sdl] Write Protect is off
sd 2:0:0:11: [sdl] Mode Sense: 8b 00 10 08
scsi 2:0:3:0: RAID              HP       HSV400           0005 PQ: 0 =
ANSI: 5
 unknown partition table
sd 2:0:0:10: [sdk] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
sd 2:0:0:11: [sdl] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
scsi 2:0:4:0: RAID              HP       HSV400           0005 PQ: 0 =
ANSI: 5
sd 2:0:0:12: [sdm] Write Protect is off
sd 2:0:0:12: [sdm] Mode Sense: 8b 00 10 08
sd 2:0:0:12: [sdm] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
scsi 2:0:5:0: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:5:0: [sdn] 4194304 512-byte logical blocks: (2.14 GB/2.00 GiB)
scsi 2:0:5:10: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:0:0: [sdj] Attached SCSI disk
scsi 2:0:5:11: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:5:0: [sdn] Write Protect is off
sd 2:0:5:0: [sdn] Mode Sense: 8b 00 10 08
SGI XFS with ACLs, security attributes, large block/inode numbers, no =
debug enabled
SGI XFS Quota Management subsystem
XFS (dm-7): delaylog is the default now, option is deprecated.
XFS (dm-7): Mounting Filesystem
XFS (dm-7): Ending clean mount
XFS (dm-7): Failed to initialize disk quotas.
XFS (dm-6): delaylog is the default now, option is deprecated.
XFS (dm-6): Mounting Filesystem
XFS (dm-6): Ending clean mount
Adding 14331900k swap on /dev/mapper/VolGroup-lv_swap.  Priority:-1 =
extents:1 across:14331900k=20
device-mapper: table: 253:9: multipath: error getting device
device-mapper: ioctl: error adding target to table
pcc-cpufreq: (v1.00.00) driver loaded with frequency limits: 1600 MHz, =
2400 MHz
sd 1:0:2:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatic
ally remap LUN assignments.
sd 2:0:0:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatic
ally remap LUN assignments.
sd 1:0:3:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatic
ally remap LUN assignments.
sd 2:0:5:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatic
ally remap LUN assignments.
device-mapper: multipath: Failing path 8:80.
device-mapper: multipath: Failing path 8:208.
device-mapper: multipath: Failing path 8:144.
end_request: I/O error, dev dm-2, sector 4194176
Buffer I/O error on device dm-2, logical block 524272
end_request: I/O error, dev dm-2, sector 4194176
Buffer I/O error on device dm-2, logical block 524272
end_request: I/O error, dev dm-2, sector 4194288
Buffer I/O error on device dm-2, logical block 524286
end_request: I/O error, dev dm-2, sector 4194288
Buffer I/O error on device dm-2, logical block 524286
end_request: I/O error, dev dm-2, sector 0
Buffer I/O error on device dm-2, logical block 0
end_request: I/O error, dev dm-2, sector 0
Buffer I/O error on device dm-2, logical block 0
end_request: I/O error, dev dm-2, sector 8
Buffer I/O error on device dm-2, logical block 1
end_request: I/O error, dev dm-2, sector 4194296
Buffer I/O error on device dm-2, logical block 524287
end_request: I/O error, dev dm-2, sector 4194296
Buffer I/O error on device dm-2, logical block 524287
end_request: I/O error, dev dm-2, sector 4194296
device-mapper: table: 253:2: multipath: error getting device
device-mapper: ioctl: error adding target to table
device-mapper: table: 253:2: multipath: error getting device
device-mapper: ioctl: error adding target to table
sd 1:0:3:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
sd 1:0:2:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
sd 2:0:5:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
sd 2:0:0:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
scsi 1:0:2:1: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 1:0:2:1: Attached scsi generic sg4 type 0
sd 1:0:2:1: [sdb] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
scsi 1:0:3:1: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 1:0:3:1: Attached scsi generic sg9 type 0
sd 1:0:3:1: [sdf] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
sd 1:0:2:1: [sdb] Write Protect is off
sd 1:0:2:1: [sdb] Mode Sense: 8b 00 10 08
sd 1:0:2:1: [sdb] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
sd 1:0:3:1: [sdf] Write Protect is off
sd 1:0:3:1: [sdf] Mode Sense: 8b 00 10 08
sd 1:0:3:1: [sdf] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
 sdb: unknown partition table
 sdf: unknown partition table
sd 1:0:2:1: [sdb] Attached SCSI disk
sd 1:0:3:1: [sdf] Attached SCSI disk
scsi 2:0:5:1: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:5:1: Attached scsi generic sg16 type 0
sd 2:0:5:1: [sdj] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
scsi 2:0:0:1: Direct-Access     3PARdata VV               3210 PQ: 0 =
ANSI: 6
sd 2:0:0:1: Attached scsi generic sg25 type 0
sd 2:0:0:1: [sdn] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
sd 2:0:5:1: [sdj] Write Protect is off
sd 2:0:5:1: [sdj] Mode Sense: 8b 00 10 08
sd 2:0:5:1: [sdj] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
sd 2:0:0:1: [sdn] Write Protect is off
sd 2:0:0:1: [sdn] Mode Sense: 8b 00 10 08
sd 2:0:0:1: [sdn] Write cache: disabled, read cache: enabled, supports =
DPO and FUA
 sdj: unknown partition table
 sdn: unknown partition table
sd 2:0:5:1: [sdj] Attached SCSI disk
sd 2:0:0:1: [sdn] Attached SCSI disk
XFS (dm-8): Mounting Filesystem
XFS (dm-8): Ending clean mount
sd 1:0:2:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
sd 1:0:3:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
sd 2:0:5:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
sd 2:0:0:10: Warning! Received an indication that the LUN assignments on =
this target have changed. The Linux SCSI layer does not automatically =
remap LUN assignments.
 rport-2:0-17: blocked FC remote port time out: removing rport
 rport-2:0-2: blocked FC remote port time out: removing rport

> On Dec 22, 2014, at 3:48 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Fri, Dec 19, 2014 at 09:26:12PM +0000, Weber, Charles (NIH/NIA/IRP) =
[E] wrote:
>> HI everyone, long time xfs/quota user with new server and problem
>> hardware is HP BL460 G7 blade, qlogic fiber channel and 3Par 7200 =
storage
>> 3 16TB vols exported from 3Par to server via FC. These are thin =
volumes, but plenty of available backing storage.
>>=20
>> Server runs current patched CentOS 6.6
>> kernel 2.6.32-504.3.3.el6.x86_64
>> xfsprogs 2.1.1-16.el6
>> Default mkfs.xfs options for volumes
>>=20
>> mount options for logical volumes  home_lv 39TB imap_lv 4.6TB
>> /dev/mapper/irphome_vg-home_lv on /home type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)
>> /dev/mapper/irphome_vg-imap_lv on /mail type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)
>>=20
>> Users are from large AD via winbind set to not enumerate. I saw
>> the bug with xfs_quota report not listing winbind defined user
>> names. Yes this happens to me.
>=20
> So just enumerate them by uid. (report -un)
>=20
>> I can assign project quota to smaller volume. xfs_quota will not
>> report it. I cannot assign a project quota to larger volume. I get
>> this error: xfs_quota: cannot set limits: Function not
>> implemented.
>=20
> You need to be more specific and document all your quota setup.
>=20
> =
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
>=20
>> xfs_quota -x -c 'report -uh' /mail
>> User quota on /mail (/dev/mapper/irphome_vg-imap_lv)
>>                        Blocks
>> User ID      Used   Soft   Hard Warn/Grace
>> ---------- ---------------------------------
>> root         2.2G      0      0  00 [------]
>>=20
>> [xfs_quota -x -c 'report -uh' /home
>>=20
>> nothing is returned
>>=20
>> I can set user and project quotas on /mail but cannot see them. I =
have not tested them yet.
>> I cannot set user or project quotas on /home.
>> At one time I could definitely set usr quotas on /home. I did so and =
verified it worked.
>>=20
>> Any ideas what is messed up on the /home volume?
>=20
> Not without knowing a bunch more about your project quota setup.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com


--Apple-Mail=_181BB050-F4D9-467D-852B-B91DF8DB60FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">Thanks for replying. The project part is a red herring and I =
have abandoned it.&nbsp;The only reason project quotas even came up was =
the winbind/quota issue. UID is fine.<div class=3D"">The more =
interesting part is the way the /proc/self/mounts and mtab/fstab are not =
coherent.</div><div class=3D""><br class=3D""></div><div class=3D"">2 =
filesystems have identical (cut and paste) setting in fstab. Below =
results are after setting forcefsck and rebooting.</div><div =
class=3D""><br class=3D""></div><div class=3D"">mount =
&lt;enter&gt;</div><div class=3D""><div =
class=3D"">/dev/mapper/irphome_vg-home_lv on /home type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)</div><div =
class=3D"">/dev/mapper/irphome_vg-imap_lv on /mail type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)</div></div=
><div class=3D""><br class=3D""></div><div class=3D""><div class=3D"">cat =
/proc/self/mounts</div><div class=3D"">/dev/mapper/irphome_vg-home_lv =
/home xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,noquota 0 0</div><div =
class=3D"">/dev/mapper/irphome_vg-imap_lv /mail xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,usrquota,prjquota 0 0</div></div><div class=3D""><br =
class=3D""></div><div class=3D"">cat /etc/mtab</div><div class=3D""><div =
class=3D"">/dev/mapper/irphome_vg-home_lv /home xfs =
rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota 0 =
0</div><div class=3D"">/dev/mapper/irphome_vg-imap_lv /mail xfs =
rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota 0 =
0</div><div class=3D""><br class=3D""></div><div class=3D"">List of =
details per wiki</div><div class=3D"">#############</div><div =
class=3D"">The most interesting thing in dmesg output was =
this:</div><div class=3D"">XFS (dm-7): Failed to initialize disk quotas. =
&nbsp;from /dev/disk/by-id dm-7 is my problem logical volume =
=3D&gt;&nbsp;<b class=3D"">dm-name-irphome_vg-home_lv</b> -&gt; <b =
class=3D"">../../dm-7</b></div><div class=3D""><div style=3D"margin: =
0px;" class=3D"">#############</div><div style=3D"margin: 0px;" =
class=3D""><br class=3D""></div><div style=3D"margin: 0px;" =
class=3D"">2.6.32-504.3.3.el6.x86_64</div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D""><br class=3D""></div><div style=3D"margin: =
0px;" class=3D"">xfs_repair version 3.1.1</div><div style=3D"margin: =
0px; min-height: 14px;" class=3D""><br class=3D""></div><div =
style=3D"margin: 0px;" class=3D"">24 cpu using hyperthreading, so 12 =
real</div><div style=3D"margin: 0px; min-height: 14px;" class=3D""><br =
class=3D""></div><div style=3D"margin: 0px;" class=3D"">mem</div><div =
style=3D"margin: 0px;" class=3D"">MemTotal: &nbsp; &nbsp; &nbsp; =
49410148 kB</div><div style=3D"margin: 0px;" class=3D"">MemFree:&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; 269628 kB</div><div style=3D"margin: 0px;" =
class=3D"">Buffers:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 144256 =
kB</div><div style=3D"margin: 0px;" class=3D"">Cached: &nbsp; &nbsp; =
&nbsp; &nbsp; 47388884 kB</div><div style=3D"margin: 0px;" =
class=3D"">SwapCached:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 =
kB</div><div style=3D"margin: 0px;" class=3D"">Active: &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; 731016 kB</div><div style=3D"margin: 0px;" =
class=3D"">Inactive: &nbsp; &nbsp; &nbsp; 46871512 kB</div><div =
style=3D"margin: 0px;" class=3D"">Active(anon): &nbsp; &nbsp; &nbsp; =
2976 kB</div><div style=3D"margin: 0px;" class=3D"">Inactive(anon):&nbsp; =
&nbsp; 71740 kB</div><div style=3D"margin: 0px;" class=3D"">Active(file): =
&nbsp; &nbsp; 728040 kB</div><div style=3D"margin: 0px;" =
class=3D"">Inactive(file): 46799772 kB</div><div style=3D"margin: 0px;" =
class=3D"">Unevictable:&nbsp; &nbsp; &nbsp; &nbsp; 5092 kB</div><div =
style=3D"margin: 0px;" class=3D"">Mlocked:&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; 5092 kB</div><div style=3D"margin: 0px;" =
class=3D"">SwapTotal:&nbsp; &nbsp; &nbsp; 14331900 kB</div><div =
style=3D"margin: 0px;" class=3D"">SwapFree: &nbsp; &nbsp; &nbsp; =
14331900 kB</div><div style=3D"margin: 0px;" class=3D"">Dirty: &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; 3773708 kB</div><div style=3D"margin: 0px;" =
class=3D"">Writeback: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 =
kB</div><div style=3D"margin: 0px;" class=3D"">AnonPages: &nbsp; &nbsp; =
&nbsp; &nbsp; 75696 kB</div><div style=3D"margin: 0px;" class=3D"">Mapped:=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 190092 kB</div><div style=3D"margin: =
0px;" class=3D"">Shmem: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
312 kB</div><div style=3D"margin: 0px;" class=3D"">Slab:&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; 1012580 kB</div><div style=3D"margin: 0px;" =
class=3D"">SReclaimable: &nbsp; &nbsp; 875160 kB</div><div =
style=3D"margin: 0px;" class=3D"">SUnreclaim: &nbsp; &nbsp; &nbsp; =
137420 kB</div><div style=3D"margin: 0px;" class=3D"">KernelStack:&nbsp; =
&nbsp; &nbsp; &nbsp; 5512 kB</div><div style=3D"margin: 0px;" =
class=3D"">PageTables: &nbsp; &nbsp; &nbsp; &nbsp; 9332 kB</div><div =
style=3D"margin: 0px;" class=3D"">NFS_Unstable:&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; 0 kB</div><div style=3D"margin: 0px;" =
class=3D"">Bounce:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; 0 kB</div><div style=3D"margin: 0px;" =
class=3D"">WritebackTmp:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 =
kB</div><div style=3D"margin: 0px;" class=3D"">CommitLimit:&nbsp; &nbsp; =
39036972 kB</div><div style=3D"margin: 0px;" class=3D"">Committed_AS: =
&nbsp; &nbsp; 293324 kB</div><div style=3D"margin: 0px;" =
class=3D"">VmallocTotal: &nbsp; 34359738367 kB</div><div style=3D"margin: =
0px;" class=3D"">VmallocUsed:&nbsp; &nbsp; &nbsp; 191424 kB</div><div =
style=3D"margin: 0px;" class=3D"">VmallocChunk: &nbsp; 34334431824 =
kB</div><div style=3D"margin: 0px;" class=3D"">HardwareCorrupted: &nbsp; =
&nbsp; 0 kB</div><div style=3D"margin: 0px;" =
class=3D"">AnonHugePages:&nbsp; &nbsp; &nbsp; 2048 kB</div><div =
style=3D"margin: 0px;" class=3D"">HugePages_Total: &nbsp; &nbsp; &nbsp; =
0</div><div style=3D"margin: 0px;" class=3D"">HugePages_Free:&nbsp; =
&nbsp; &nbsp; &nbsp; 0</div><div style=3D"margin: 0px;" =
class=3D"">HugePages_Rsvd:&nbsp; &nbsp; &nbsp; &nbsp; 0</div><div =
style=3D"margin: 0px;" class=3D"">HugePages_Surp:&nbsp; &nbsp; &nbsp; =
&nbsp; 0</div><div style=3D"margin: 0px;" class=3D"">Hugepagesize: =
&nbsp; &nbsp; &nbsp; 2048 kB</div><div style=3D"margin: 0px;" =
class=3D"">DirectMap4k:&nbsp; &nbsp; &nbsp; &nbsp; 6384 kB</div><div =
style=3D"margin: 0px;" class=3D"">DirectMap2M: &nbsp; &nbsp; 2080768 =
kB</div><div style=3D"margin: 0px;" class=3D"">DirectMap1G:&nbsp; &nbsp; =
48234496 kB</div><div style=3D"margin: 0px; min-height: 14px;" =
class=3D""><br class=3D""></div><div style=3D"margin: 0px;" =
class=3D"">/proc/mounts</div><div style=3D"margin: 0px;" class=3D"">rootfs=
 / rootfs rw 0 0</div><div style=3D"margin: 0px;" class=3D"">proc /proc =
proc rw,relatime 0 0</div><div style=3D"margin: 0px;" class=3D"">sysfs =
/sys sysfs rw,relatime 0 0</div><div style=3D"margin: 0px;" =
class=3D"">devtmpfs /dev devtmpfs =
rw,relatime,size=3D24689396k,nr_inodes=3D6172349,mode=3D755 0 =
0</div><div style=3D"margin: 0px;" class=3D"">devpts /dev/pts devpts =
rw,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0</div><div =
style=3D"margin: 0px;" class=3D"">tmpfs /dev/shm tmpfs rw,relatime 0 =
0</div><div style=3D"margin: 0px;" class=3D"">/dev/mapper/VolGroup-lv_root=
 / ext4 rw,relatime,barrier=3D1,data=3Dordered 0 0</div><div =
style=3D"margin: 0px;" class=3D"">/proc/bus/usb /proc/bus/usb usbfs =
rw,relatime 0 0</div><div style=3D"margin: 0px;" class=3D"">/dev/sda1 =
/boot ext4 rw,relatime,barrier=3D1,data=3Dordered 0 0</div><div =
style=3D"margin: 0px;" class=3D"">/dev/mapper/irphome_vg-home_lv /home =
xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,noquota 0 0</div><div style=3D"margin: 0px;" =
class=3D"">/dev/mapper/irphome_vg-imap_lv /mail xfs =
rw,relatime,attr2,delaylog,nobarrier,inode64,logbsize=3D256k,sunit=3D32,sw=
idth=3D32768,usrquota,prjquota 0 0</div><div style=3D"margin: 0px;" =
class=3D"">none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 =
0</div><div style=3D"margin: 0px;" =
class=3D"">/dev/mapper/homesavelv-homesavelv /homesave xfs =
rw,relatime,attr2,delaylog,sunit=3D32,swidth=3D32768,noquota 0 =
0</div><div style=3D"margin: 0px; min-height: 14px;" class=3D""><br =
class=3D""></div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;/proc/partitions</div><div style=3D"margin: 0px;" =
class=3D"">major minor&nbsp; #blocks&nbsp; name</div><div style=3D"margin:=
 0px; min-height: 14px;" class=3D""><br class=3D""></div><div =
style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; =
&nbsp; 0&nbsp; 143338560 sda</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; &nbsp; 1 &nbsp; &nbsp; =
512000 sda1</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; =
8&nbsp; &nbsp; &nbsp; &nbsp; 2&nbsp; 142825472 sda2</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8 &nbsp; &nbsp; &nbsp; 32 =
17179869184 sdc</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; =
8 &nbsp; &nbsp; &nbsp; 96 17179869184 sdg</div><div style=3D"margin: =
0px;" class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; 128 17179869184 =
sdi</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8 &nbsp; =
&nbsp; &nbsp; 48 17179869184 sdd</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; 112 17179869184 =
sdh</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8 &nbsp; =
&nbsp; &nbsp; 64 17179869184 sde</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;253&nbsp; &nbsp; &nbsp; &nbsp; 0 &nbsp; 52428800 =
dm-0</div><div style=3D"margin: 0px;" class=3D"">&nbsp;253&nbsp; &nbsp; =
&nbsp; &nbsp; 1 &nbsp; 14331904 dm-1</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; 160 17179869184 =
sdk</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8&nbsp; =
&nbsp; &nbsp; 176 17179869184 sdl</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; 192 17179869184 =
sdm</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8&nbsp; =
&nbsp; &nbsp; 224 17179869184 sdo</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; 240 17179869184 =
sdp</div><div style=3D"margin: 0px;" class=3D"">&nbsp; 65&nbsp; &nbsp; =
&nbsp; &nbsp; 0 17179869184 sdq</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;253&nbsp; &nbsp; &nbsp; &nbsp; 3 17179869184 =
dm-3</div><div style=3D"margin: 0px;" class=3D"">&nbsp;253&nbsp; &nbsp; =
&nbsp; &nbsp; 4 17179869184 dm-4</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;253&nbsp; &nbsp; &nbsp; &nbsp; 5 17179869184 =
dm-5</div><div style=3D"margin: 0px;" class=3D"">&nbsp;253&nbsp; &nbsp; =
&nbsp; &nbsp; 6 5368709120 dm-6</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;253&nbsp; &nbsp; &nbsp; &nbsp; 7 42949672960 =
dm-7</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8 &nbsp; =
&nbsp; &nbsp; 16 2147483648 sdb</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8 &nbsp; &nbsp; &nbsp; 80 2147483648 =
sdf</div><div style=3D"margin: 0px;" class=3D"">&nbsp;253&nbsp; &nbsp; =
&nbsp; &nbsp; 2 2147483648 dm-2</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;&nbsp; 8&nbsp; &nbsp; &nbsp; 144 2147483648 =
sdj</div><div style=3D"margin: 0px;" class=3D"">&nbsp;&nbsp; 8&nbsp; =
&nbsp; &nbsp; 208 2147483648 sdn</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;253&nbsp; &nbsp; &nbsp; &nbsp; 8 2147467264 =
dm-8</div><p style=3D"margin: 0px; min-height: 14px;" class=3D"">&nbsp;<br=
 class=3D"webkit-block-placeholder"></p><div style=3D"margin: 0px;" =
class=3D"">&nbsp;Raid layout</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;3Par SAN&nbsp; raid 6 12 4TB SAS disks (more or less, =
3Par does some non-classic raid stuff)</div><p style=3D"margin: 0px; =
min-height: 14px;" class=3D"">&nbsp;<br =
class=3D"webkit-block-placeholder"></p><div style=3D"margin: 0px;" =
class=3D"">&nbsp;<b class=3D"">mpathd =
(360002ac000000000000000080000bf12) dm-4 3PARdata,VV</b></div><div =
style=3D"margin: 0px;" class=3D"">size=3D16T features=3D'0' =
hwhandler=3D'0' wp=3Drw</div><div style=3D"margin: 0px;" class=3D"">`-+- =
policy=3D'round-robin 0' prio=3D1 status=3Dactive</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; |- 1:0:3:12 sdi 8:128 active =
ready running</div><div style=3D"margin: 0px;" class=3D"">&nbsp; |- =
2:0:0:12 sdm 8:192 active ready running</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; |- 1:0:2:12 sde 8:64&nbsp; active ready =
running</div><div style=3D"margin: 0px;" class=3D"">&nbsp; `- 2:0:5:12 =
sdq 65:0&nbsp; active ready running</div><div style=3D"margin: 0px;" =
class=3D""><b class=3D"">mpathc (360002ac000000000000000070000bf12) dm-5 =
3PARdata,VV</b></div><div style=3D"margin: 0px;" class=3D"">size=3D16T =
features=3D'0' hwhandler=3D'0' wp=3Drw</div><div style=3D"margin: 0px;" =
class=3D"">`-+- policy=3D'round-robin 0' prio=3D1 =
status=3Dactive</div><div style=3D"margin: 0px;" class=3D"">&nbsp; |- =
1:0:2:11 sdd 8:48&nbsp; active ready running</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; |- 2:0:0:11 sdl 8:176 active ready =
running</div><div style=3D"margin: 0px;" class=3D"">&nbsp; |- 1:0:3:11 =
sdh 8:112 active ready running</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; `- 2:0:5:11 sdp 8:240 active ready running</div><div =
style=3D"margin: 0px;" class=3D""><b class=3D"">mpathb =
(360002ac000000000000000060000bf12) dm-3 3PARdata,VV</b></div><div =
style=3D"margin: 0px;" class=3D"">size=3D16T features=3D'0' =
hwhandler=3D'0' wp=3Drw</div><div style=3D"margin: 0px;" class=3D"">`-+- =
policy=3D'round-robin 0' prio=3D1 status=3Dactive</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; |- 1:0:2:10 sdc 8:32&nbsp; =
active ready running</div><div style=3D"margin: 0px;" class=3D"">&nbsp; =
|- 2:0:0:10 sdk 8:160 active ready running</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; |- 1:0:3:10 sdg 8:96&nbsp; active ready =
running</div><div style=3D"margin: 0px;" class=3D"">&nbsp; `- 2:0:5:10 =
sdo 8:224 active ready running</div><div style=3D"margin: 0px;" =
class=3D""><b class=3D"">mpathg (360002ac000000000000000110000bf12) dm-2 =
3PARdata,VV</b></div><div style=3D"margin: 0px;" class=3D"">size=3D2.0T =
features=3D'0' hwhandler=3D'0' wp=3Drw</div><div style=3D"margin: 0px;" =
class=3D"">`-+- policy=3D'round-robin 0' prio=3D1 =
status=3Dactive</div><div style=3D"margin: 0px;" class=3D"">&nbsp; |- =
1:0:2:1&nbsp; sdb 8:16&nbsp; active ready running</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; |- 2:0:5:1&nbsp; sdj 8:144 =
active ready running</div><div style=3D"margin: 0px;" class=3D"">&nbsp; =
|- 1:0:3:1&nbsp; sdf 8:80&nbsp; active ready running</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; `- 2:0:0:1&nbsp; sdn 8:208 =
active ready running</div><div style=3D"margin: 0px; min-height: 14px;" =
class=3D""><br class=3D""></div><div style=3D"margin: 0px;" =
class=3D"">pvscan</div><div style=3D"margin: 0px;" class=3D"">&nbsp; PV =
/dev/mapper/mpathd &nbsp; VG irphome_vg &nbsp; lvm2 [16.00 TiB / 3.00 =
TiB free]</div><div style=3D"margin: 0px;" class=3D"">&nbsp; PV =
/dev/mapper/mpathb &nbsp; VG irphome_vg &nbsp; lvm2 [16.00 TiB / 0&nbsp; =
&nbsp; free]</div><div style=3D"margin: 0px;" class=3D"">&nbsp; PV =
/dev/mapper/mpathc &nbsp; VG irphome_vg &nbsp; lvm2 [16.00 TiB / 0&nbsp; =
&nbsp; free]</div><div style=3D"margin: 0px;" class=3D"">&nbsp; PV =
/dev/mapper/mpathg &nbsp; VG homesavelv &nbsp; lvm2 [2.00 TiB / 0&nbsp; =
&nbsp; free]</div><div style=3D"margin: 0px;" class=3D"">&nbsp; PV =
/dev/sda2&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; VG VolGroup &nbsp; =
&nbsp; lvm2 [136.21 GiB / 72.54 GiB free]</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; Total: 5 [50.13 TiB] / in use: 5 [50.13 TiB] / =
in no VG: 0 [0 &nbsp; ]</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp;vgscan</div><div style=3D"margin: 0px;" class=3D"">&nbsp;=
 Reading all physical volumes.&nbsp; This may take a while...</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; Found volume group "irphome_vg" =
using metadata type lvm2</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; Found volume group "homesavelv" using metadata type =
lvm2</div><div style=3D"margin: 0px;" class=3D"">&nbsp; Found volume =
group "VolGroup" using metadata type lvm2</div><div style=3D"margin: =
0px;" class=3D"">&nbsp;lvscan</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; ACTIVE&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
'/dev/irphome_vg/imap_lv' [5.00 TiB] inherit</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; ACTIVE&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
'/dev/irphome_vg/home_lv' [40.00 TiB] inherit</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; ACTIVE&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
'/dev/homesavelv/homesavelv' [2.00 TiB] inherit</div><div style=3D"margin:=
 0px;" class=3D"">&nbsp; ACTIVE&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
'/dev/VolGroup/lv_root' [50.00 GiB] inherit</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; ACTIVE&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
'/dev/VolGroup/lv_swap' [13.67 GiB] inherit</div><p style=3D"margin: =
0px; min-height: 14px;" class=3D"">&nbsp;&nbsp;<br =
class=3D"webkit-block-placeholder"></p><div style=3D"margin: 0px;" =
class=3D"">&nbsp; lvdisplay irphome_vg/home_lv</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; --- Logical volume ---</div><div style=3D"margin: =
0px;" class=3D"">&nbsp; LV Path&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; /dev/irphome_vg/home_lv</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; LV Name&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; home_lv</div><div style=3D"margin: 0px;" class=3D"">&nbsp; =
VG Name&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
irphome_vg</div><div style=3D"margin: 0px;" class=3D"">&nbsp; LV =
UUID&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
8wLM12-e43p-UhIh-YTXn-kMBx-RffN-yNz2V5</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; LV Write Access&nbsp; &nbsp; &nbsp; &nbsp; =
read/write</div><div style=3D"margin: 0px;" class=3D"">&nbsp; LV =
Creation host, time <a href=3D"http://nuhome.irp.nia.nih.gov" =
class=3D"">nuhome.irp.nia.nih.gov</a>, 2014-12-01 17:53:47 =
-0500</div><div style=3D"margin: 0px;" class=3D"">&nbsp; LV Status&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; available</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; # open &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; LV Size&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; 40.00 TiB</div><div style=3D"margin: 0px;" class=3D"">&nbsp;=
 Current LE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 10485760</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; Segments &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; 3</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; Allocation &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
inherit</div><div style=3D"margin: 0px;" class=3D"">&nbsp; Read ahead =
sectors &nbsp; &nbsp; auto</div><div style=3D"margin: 0px;" =
class=3D"">&nbsp; - currently set to &nbsp; &nbsp; 256</div><div =
style=3D"margin: 0px;" class=3D"">&nbsp; Block device &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; 253:7</div><div style=3D"margin: 0px; min-height: =
14px;" class=3D""><br class=3D""></div></div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D"">Disks, write cache etc are controlled by =
3Par SAN, I just define up to 16TB blocks and export to host over FC or =
ISCSI.</div><div style=3D"margin: 0px; min-height: 14px;" class=3D"">In =
this case I am using FC.</div><div style=3D"margin: 0px; min-height: =
14px;" class=3D""><br class=3D""></div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D""><div style=3D"margin: 0px; min-height: =
14px;" class=3D"">&nbsp;xfs_info /dev/irphome_vg/home_lv&nbsp;</div><div =
style=3D"margin: 0px; min-height: 14px;" =
class=3D"">meta-data=3D/dev/mapper/irphome_vg-home_lv isize=3D256 &nbsp; =
&nbsp;agcount=3D40, agsize=3D268435452 blks</div><div style=3D"margin: =
0px; min-height: 14px;" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; sectsz=3D512 &nbsp; attr=3D2, projid32bit=3D1</div><div =
style=3D"margin: 0px; min-height: 14px;" class=3D"">data &nbsp; &nbsp; =3D=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; bsize=3D4096 &nbsp; blocks=3D10737418080, imaxpct=3D5</div><div =
style=3D"margin: 0px; min-height: 14px;" class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; sunit=3D4 &nbsp; &nbsp; &nbsp;swidth=3D4096 =
blks</div><div style=3D"margin: 0px; min-height: 14px;" class=3D"">naming =
&nbsp; =3Dversion 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;bsize=3D4096 &nbsp; ascii-ci=3D0</div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D"">log &nbsp; &nbsp; &nbsp;=3Dinternal &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; =
blocks=3D521728, version=3D2</div><div style=3D"margin: 0px; min-height: =
14px;" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
sectsz=3D512 &nbsp; sunit=3D4 blks, lazy-count=3D1</div><div =
style=3D"margin: 0px; min-height: 14px;" class=3D"">realtime =3Dnone =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
extsz=3D4096 &nbsp; blocks=3D0, rtextents=3D0</div><div style=3D"margin: =
0px; min-height: 14px;" class=3D""><br class=3D""></div><div =
style=3D"margin: 0px; min-height: 14px;" class=3D"">xfs_info =
/dev/irphome_vg/imap_lv&nbsp;</div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D"">meta-data=3D/dev/mapper/irphome_vg-imap_lv =
isize=3D256 &nbsp; &nbsp;agcount=3D32, agsize=3D41943036 blks</div><div =
style=3D"margin: 0px; min-height: 14px;" class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; sectsz=3D512 &nbsp; attr=3D2, =
projid32bit=3D1</div><div style=3D"margin: 0px; min-height: 14px;" =
class=3D"">data &nbsp; &nbsp; =3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; =
blocks=3D1342177152, imaxpct=3D5</div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; sunit=3D4 &nbsp; &nbsp; &nbsp;swidth=3D4096 blks</div><div =
style=3D"margin: 0px; min-height: 14px;" class=3D"">naming &nbsp; =
=3Dversion 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bsize=3D4096 =
&nbsp; ascii-ci=3D0</div><div style=3D"margin: 0px; min-height: 14px;" =
class=3D"">log &nbsp; &nbsp; &nbsp;=3Dinternal &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; blocks=3D521728, =
version=3D2</div><div style=3D"margin: 0px; min-height: 14px;" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 =
&nbsp; sunit=3D4 blks, lazy-count=3D1</div><div style=3D"margin: 0px; =
min-height: 14px;" class=3D"">realtime =3Dnone &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; extsz=3D4096 &nbsp; blocks=3D0, =
rtextents=3D0</div><div class=3D""><br class=3D""></div><div =
class=3D"">dmesg output</div><div class=3D""><div class=3D"">SGI XFS =
with ACLs, security attributes, large block/inode numbers, no debug =
enabled</div><div class=3D"">SGI XFS Quota Management =
subsystem</div><div class=3D"">XFS (dm-7): delaylog is the default now, =
option is deprecated.</div><div class=3D"">XFS (dm-7): Mounting =
Filesystem</div><div class=3D"">XFS (dm-7): Ending clean mount</div><div =
class=3D"">XFS (dm-7): Failed to initialize disk quotas.</div><div =
class=3D"">XFS (dm-6): delaylog is the default now, option is =
deprecated.</div><div class=3D"">XFS (dm-6): Mounting =
Filesystem</div><div class=3D"">XFS (dm-6): Ending clean mount</div><div =
class=3D""><br class=3D""></div><div class=3D""><br class=3D""></div><div =
class=3D"">scsi 2:0:0:0: Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div =
class=3D"">scsi 2:0:0:10: Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div =
class=3D"">sd 2:0:0:0: [sdj] 4194304 512-byte logical blocks: (2.14 =
GB/2.00 GiB)</div><div class=3D"">scsi 2:0:0:11: Direct-Access &nbsp; =
&nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3210 =
PQ: 0 ANSI: 6</div><div class=3D"">sd 2:0:0:10: [sdk] 34359738368 =
512-byte logical blocks: (17.5 TB/16.0 TiB)</div><div class=3D"">sd =
2:0:0:0: [sdj] Write Protect is off</div><div class=3D"">sd 2:0:0:0: =
[sdj] Mode Sense: 8b 00 10 08</div><div class=3D"">scsi 2:0:0:12: =
Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div class=3D"">sd =
2:0:0:11: [sdl] 34359738368 512-byte logical blocks: (17.5 TB/16.0 =
TiB)</div><div class=3D"">sd 2:0:0:0: [sdj] Write cache: disabled, read =
cache: enabled, supports DPO and FUA</div><div class=3D"">scsi =
2:0:0:254: Enclosure &nbsp; &nbsp; &nbsp; &nbsp; 3PARdata SES &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;3210 PQ: 0 ANSI: 6</div><div =
class=3D"">sd 2:0:0:12: [sdm] 34359738368 512-byte logical blocks: (17.5 =
TB/16.0 TiB)</div><div class=3D"">scsi 2:0:1:0: RAID &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;HP &nbsp; &nbsp; &nbsp; HSV400 &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; 0005 PQ: 0 ANSI: 5</div><div class=3D"">scsi =
2:0:2:0: RAID &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;HP &nbsp; =
&nbsp; &nbsp; HSV400 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0005 PQ: 0 ANSI: =
5</div><div class=3D"">&nbsp;sdj:</div><div class=3D"">sd 2:0:0:10: =
[sdk] Write Protect is off</div><div class=3D"">sd 2:0:0:10: [sdk] Mode =
Sense: 8b 00 10 08</div><div class=3D"">sd 2:0:0:11: [sdl] Write Protect =
is off</div><div class=3D"">sd 2:0:0:11: [sdl] Mode Sense: 8b 00 10 =
08</div><div class=3D"">scsi 2:0:3:0: RAID &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;HP &nbsp; &nbsp; &nbsp; HSV400 &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; 0005 PQ: 0 ANSI: 5</div><div class=3D"">&nbsp;unknown =
partition table</div><div class=3D"">sd 2:0:0:10: [sdk] Write cache: =
disabled, read cache: enabled, supports DPO and FUA</div><div =
class=3D"">sd 2:0:0:11: [sdl] Write cache: disabled, read cache: =
enabled, supports DPO and FUA</div><div class=3D"">scsi 2:0:4:0: RAID =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;HP &nbsp; &nbsp; &nbsp; =
HSV400 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0005 PQ: 0 ANSI: 5</div><div =
class=3D"">sd 2:0:0:12: [sdm] Write Protect is off</div><div class=3D"">sd=
 2:0:0:12: [sdm] Mode Sense: 8b 00 10 08</div><div class=3D"">sd =
2:0:0:12: [sdm] Write cache: disabled, read cache: enabled, supports DPO =
and FUA</div><div class=3D"">scsi 2:0:5:0: Direct-Access &nbsp; &nbsp; =
3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3210 PQ: 0 =
ANSI: 6</div><div class=3D"">sd 2:0:5:0: [sdn] 4194304 512-byte logical =
blocks: (2.14 GB/2.00 GiB)</div><div class=3D"">scsi 2:0:5:10: =
Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div class=3D"">sd 2:0:0:0: =
[sdj] Attached SCSI disk</div><div class=3D"">scsi 2:0:5:11: =
Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div class=3D"">sd 2:0:5:0: =
[sdn] Write Protect is off</div><div class=3D"">sd 2:0:5:0: [sdn] Mode =
Sense: 8b 00 10 08</div><div class=3D"">SGI XFS with ACLs, security =
attributes, large block/inode numbers, no debug enabled</div><div =
class=3D"">SGI XFS Quota Management subsystem</div><div class=3D"">XFS =
(dm-7): delaylog is the default now, option is deprecated.</div><div =
class=3D"">XFS (dm-7): Mounting Filesystem</div><div class=3D"">XFS =
(dm-7): Ending clean mount</div><div class=3D"">XFS (dm-7): Failed to =
initialize disk quotas.</div><div class=3D"">XFS (dm-6): delaylog is the =
default now, option is deprecated.</div><div class=3D"">XFS (dm-6): =
Mounting Filesystem</div><div class=3D"">XFS (dm-6): Ending clean =
mount</div><div class=3D"">Adding 14331900k swap on =
/dev/mapper/VolGroup-lv_swap. &nbsp;Priority:-1 extents:1 =
across:14331900k&nbsp;</div><div class=3D"">device-mapper: table: 253:9: =
multipath: error getting device</div><div class=3D"">device-mapper: =
ioctl: error adding target to table</div><div class=3D"">pcc-cpufreq: =
(v1.00.00) driver loaded with frequency limits: 1600 MHz, 2400 =
MHz</div><div class=3D"">sd 1:0:2:10: Warning! Received an indication =
that the LUN assignments on this target have changed. The Linux SCSI =
layer does not automatic</div><div class=3D"">ally remap LUN =
assignments.</div><div class=3D"">sd 2:0:0:10: Warning! Received an =
indication that the LUN assignments on this target have changed. The =
Linux SCSI layer does not automatic</div><div class=3D"">ally remap LUN =
assignments.</div><div class=3D"">sd 1:0:3:10: Warning! Received an =
indication that the LUN assignments on this target have changed. The =
Linux SCSI layer does not automatic</div><div class=3D"">ally remap LUN =
assignments.</div><div class=3D"">sd 2:0:5:10: Warning! Received an =
indication that the LUN assignments on this target have changed. The =
Linux SCSI layer does not automatic</div><div class=3D"">ally remap LUN =
assignments.</div><div class=3D"">device-mapper: multipath: Failing path =
8:80.</div><div class=3D"">device-mapper: multipath: Failing path =
8:208.</div><div class=3D"">device-mapper: multipath: Failing path =
8:144.</div><div class=3D"">end_request: I/O error, dev dm-2, sector =
4194176</div><div class=3D"">Buffer I/O error on device dm-2, logical =
block 524272</div><div class=3D"">end_request: I/O error, dev dm-2, =
sector 4194176</div><div class=3D"">Buffer I/O error on device dm-2, =
logical block 524272</div><div class=3D"">end_request: I/O error, dev =
dm-2, sector 4194288</div><div class=3D"">Buffer I/O error on device =
dm-2, logical block 524286</div><div class=3D"">end_request: I/O error, =
dev dm-2, sector 4194288</div><div class=3D"">Buffer I/O error on device =
dm-2, logical block 524286</div><div class=3D"">end_request: I/O error, =
dev dm-2, sector 0</div><div class=3D"">Buffer I/O error on device dm-2, =
logical block 0</div><div class=3D"">end_request: I/O error, dev dm-2, =
sector 0</div><div class=3D"">Buffer I/O error on device dm-2, logical =
block 0</div><div class=3D"">end_request: I/O error, dev dm-2, sector =
8</div><div class=3D"">Buffer I/O error on device dm-2, logical block =
1</div><div class=3D"">end_request: I/O error, dev dm-2, sector =
4194296</div><div class=3D"">Buffer I/O error on device dm-2, logical =
block 524287</div><div class=3D"">end_request: I/O error, dev dm-2, =
sector 4194296</div><div class=3D"">Buffer I/O error on device dm-2, =
logical block 524287</div><div class=3D"">end_request: I/O error, dev =
dm-2, sector 4194296</div><div class=3D"">device-mapper: table: 253:2: =
multipath: error getting device</div><div class=3D"">device-mapper: =
ioctl: error adding target to table</div><div class=3D"">device-mapper: =
table: 253:2: multipath: error getting device</div><div =
class=3D"">device-mapper: ioctl: error adding target to table</div><div =
class=3D"">sd 1:0:3:10: Warning! Received an indication that the LUN =
assignments on this target have changed. The Linux SCSI layer does not =
automatically remap LUN assignments.</div><div class=3D"">sd 1:0:2:10: =
Warning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN =
assignments.</div><div class=3D"">sd 2:0:5:10: Warning! Received an =
indication that the LUN assignments on this target have changed. The =
Linux SCSI layer does not automatically remap LUN assignments.</div><div =
class=3D"">sd 2:0:0:10: Warning! Received an indication that the LUN =
assignments on this target have changed. The Linux SCSI layer does not =
automatically remap LUN assignments.</div><div class=3D"">scsi 1:0:2:1: =
Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div class=3D"">sd 1:0:2:1: =
Attached scsi generic sg4 type 0</div><div class=3D"">sd 1:0:2:1: [sdb] =
4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)</div><div =
class=3D"">scsi 1:0:3:1: Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div =
class=3D"">sd 1:0:3:1: Attached scsi generic sg9 type 0</div><div =
class=3D"">sd 1:0:3:1: [sdf] 4294967296 512-byte logical blocks: (2.19 =
TB/2.00 TiB)</div><div class=3D"">sd 1:0:2:1: [sdb] Write Protect is =
off</div><div class=3D"">sd 1:0:2:1: [sdb] Mode Sense: 8b 00 10 =
08</div><div class=3D"">sd 1:0:2:1: [sdb] Write cache: disabled, read =
cache: enabled, supports DPO and FUA</div><div class=3D"">sd 1:0:3:1: =
[sdf] Write Protect is off</div><div class=3D"">sd 1:0:3:1: [sdf] Mode =
Sense: 8b 00 10 08</div><div class=3D"">sd 1:0:3:1: [sdf] Write cache: =
disabled, read cache: enabled, supports DPO and FUA</div><div =
class=3D"">&nbsp;sdb: unknown partition table</div><div =
class=3D"">&nbsp;sdf: unknown partition table</div><div class=3D"">sd =
1:0:2:1: [sdb] Attached SCSI disk</div><div class=3D"">sd 1:0:3:1: [sdf] =
Attached SCSI disk</div><div class=3D"">scsi 2:0:5:1: Direct-Access =
&nbsp; &nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; 3210 PQ: 0 ANSI: 6</div><div class=3D"">sd 2:0:5:1: Attached scsi =
generic sg16 type 0</div><div class=3D"">sd 2:0:5:1: [sdj] 4294967296 =
512-byte logical blocks: (2.19 TB/2.00 TiB)</div><div class=3D"">scsi =
2:0:0:1: Direct-Access &nbsp; &nbsp; 3PARdata VV &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; 3210 PQ: 0 ANSI: 6</div><div class=3D"">sd =
2:0:0:1: Attached scsi generic sg25 type 0</div><div class=3D"">sd =
2:0:0:1: [sdn] 4294967296 512-byte logical blocks: (2.19 TB/2.00 =
TiB)</div><div class=3D"">sd 2:0:5:1: [sdj] Write Protect is =
off</div><div class=3D"">sd 2:0:5:1: [sdj] Mode Sense: 8b 00 10 =
08</div><div class=3D"">sd 2:0:5:1: [sdj] Write cache: disabled, read =
cache: enabled, supports DPO and FUA</div><div class=3D"">sd 2:0:0:1: =
[sdn] Write Protect is off</div><div class=3D"">sd 2:0:0:1: [sdn] Mode =
Sense: 8b 00 10 08</div><div class=3D"">sd 2:0:0:1: [sdn] Write cache: =
disabled, read cache: enabled, supports DPO and FUA</div><div =
class=3D"">&nbsp;sdj: unknown partition table</div><div =
class=3D"">&nbsp;sdn: unknown partition table</div><div class=3D"">sd =
2:0:5:1: [sdj] Attached SCSI disk</div><div class=3D"">sd 2:0:0:1: [sdn] =
Attached SCSI disk</div><div class=3D"">XFS (dm-8): Mounting =
Filesystem</div><div class=3D"">XFS (dm-8): Ending clean mount</div><div =
class=3D"">sd 1:0:2:10: Warning! Received an indication that the LUN =
assignments on this target have changed. The Linux SCSI layer does not =
automatically remap LUN assignments.</div><div class=3D"">sd 1:0:3:10: =
Warning! Received an indication that the LUN assignments on this target =
have changed. The Linux SCSI layer does not automatically remap LUN =
assignments.</div><div class=3D"">sd 2:0:5:10: Warning! Received an =
indication that the LUN assignments on this target have changed. The =
Linux SCSI layer does not automatically remap LUN assignments.</div><div =
class=3D"">sd 2:0:0:10: Warning! Received an indication that the LUN =
assignments on this target have changed. The Linux SCSI layer does not =
automatically remap LUN assignments.</div><div =
class=3D"">&nbsp;rport-2:0-17: blocked FC remote port time out: removing =
rport</div><div class=3D"">&nbsp;rport-2:0-2: blocked FC remote port =
time out: removing rport</div></div></div><div class=3D""><br =
class=3D""><div><blockquote type=3D"cite" class=3D""><div class=3D"">On =
Dec 22, 2014, at 3:48 PM, Dave Chinner &lt;<a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D"">On =
Fri, Dec 19, 2014 at 09:26:12PM +0000, Weber, Charles (NIH/NIA/IRP) [E] =
wrote:<br class=3D""><blockquote type=3D"cite" class=3D"">HI everyone, =
long time xfs/quota user with new server and problem<br =
class=3D"">hardware is HP BL460 G7 blade, qlogic fiber channel and 3Par =
7200 storage<br class=3D"">3 16TB vols exported from 3Par to server via =
FC. These are thin volumes, but plenty of available backing storage.<br =
class=3D""><br class=3D"">Server runs current patched CentOS 6.6<br =
class=3D"">kernel 2.6.32-504.3.3.el6.x86_64<br class=3D"">xfsprogs =
2.1.1-16.el6<br class=3D"">Default mkfs.xfs options for volumes<br =
class=3D""><br class=3D"">mount options for logical volumes =
&nbsp;home_lv 39TB imap_lv 4.6TB<br =
class=3D"">/dev/mapper/irphome_vg-home_lv on /home type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)<br =
class=3D"">/dev/mapper/irphome_vg-imap_lv on /mail type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)<br =
class=3D""><br class=3D"">Users are from large AD via winbind set to not =
enumerate. I saw<br class=3D"">the bug with xfs_quota report not listing =
winbind defined user<br class=3D"">names. Yes this happens to me.<br =
class=3D""></blockquote><br class=3D"">So just enumerate them by uid. =
(report -un)<br class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">I can assign project quota to smaller volume. xfs_quota will =
not<br class=3D"">report it. I cannot assign a project quota to larger =
volume. I get<br class=3D"">this error: xfs_quota: cannot set limits: =
Function not<br class=3D"">implemented.<br class=3D""></blockquote><br =
class=3D"">You need to be more specific and document all your quota =
setup.<br class=3D""><br class=3D""><a =
href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_incl=
ude_when_reporting_a_problem.3F" =
class=3D"">http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_i=
nclude_when_reporting_a_problem.3F</a><br class=3D""><br =
class=3D""><blockquote type=3D"cite" class=3D"">xfs_quota -x -c 'report =
-uh' /mail<br class=3D"">User quota on /mail =
(/dev/mapper/irphome_vg-imap_lv)<br class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Blocks<br =
class=3D"">User ID &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Used &nbsp;&nbsp;Soft =
&nbsp;&nbsp;Hard Warn/Grace<br class=3D"">---------- =
---------------------------------<br class=3D"">root =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2G =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;00 =
[------]<br class=3D""><br class=3D"">[xfs_quota -x -c 'report -uh' =
/home<br class=3D""><br class=3D"">nothing is returned<br class=3D""><br =
class=3D"">I can set user and project quotas on /mail but cannot see =
them. I have not tested them yet.<br class=3D"">I cannot set user or =
project quotas on /home.<br class=3D"">At one time I could definitely =
set usr quotas on /home. I did so and verified it worked.<br =
class=3D""><br class=3D"">Any ideas what is messed up on the /home =
volume?<br class=3D""></blockquote><br class=3D"">Not without knowing a =
bunch more about your project quota setup.<br class=3D""><br =
class=3D"">Cheers,<br class=3D""><br class=3D"">Dave.<br class=3D"">-- =
<br class=3D"">Dave Chinner<br class=3D"">david@fromorbit.com<br =
class=3D""></div></blockquote></div><br =
class=3D""></div></div></body></html>=

--Apple-Mail=_181BB050-F4D9-467D-852B-B91DF8DB60FA--


--===============7065980215911023220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7065980215911023220==--
