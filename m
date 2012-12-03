Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3GlVAD212440 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 10:47:31 -0600
Received: from relay01.pair.com (relay01.pair.com [209.68.5.15]) by
	cuda.sgi.com with SMTP id UlZJ6Wg3uU2O2Ll6 for
	<xfs@oss.sgi.com>; Mon, 03 Dec 2012 08:49:49 -0800 (PST)
Date: Mon, 03 Dec 2012 11:49:46 -0500
Subject: Re: xfsdump INTERRUPT issue
From: "J. Ellis" <jellis@dhnet.us>
Message-ID: <CCE2425A.B0475%jellis@dhnet.us>
In-Reply-To: <50BAB19F.1010808@hardwarefreak.com>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com, Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thank you to Stan and Dave for helping me through this.

Ok, here's the file, printed below.

Basically, I'm running the following commands under Ubuntu 12.10:

Type mkdir /mnt/fp
Type mkdir /mnt/hr20
Type mount -t xfs -o rtdev=3D/dev/sda3 /dev/sda2 /mnt/fp
Type mount -t xfs -o rtdev=3D/dev/sdb3 /dev/sdb2 /mnt/hr20
Type xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fp

When run, I get this as my output:

xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)
xfsdump: ending media file
xfsdump: media file size 18874368 bytes
xfsdump: dump size (non-dir files) : 13698056 bytes
xfsdump: NOTE: dump interrupted: 16 seconds elapsed
xfsdump: Dump Status: INTERRUPT

This happens each time. In the forum where this copy procedure was
suggested, they've been reporting that the latest xfsprogs is creating these
errors, which didn't happen under at least somewhat earlier versions.

The version of xfsprogs should be in the file, but it was just downloaded a
few days ago using git.

Best,
Jeffrey



xfs requested data file:


kernel version: Linux jeffrey 3.5.0-18-generic #29-Ubuntu SMP Fri Oct 19
10:27:31 UTC 2012 i686 i686 i686 GNU/Linux

xfsprogs version: xfs_repair version 3.1.8

number of CPU's: 8

contents of /proc/meminfo:
MemTotal:        6184324 kB
MemFree:         4986560 kB
Buffers:           32036 kB
Cached:           446368 kB
SwapCached:            0 kB
Active:           680296 kB
Inactive:         402548 kB
Active(anon):     612444 kB
Inactive(anon):      368 kB
Active(file):      67852 kB
Inactive(file):   402180 kB
Unevictable:       32596 kB
Mlocked:           32596 kB
HighTotal:       5365768 kB
HighFree:        4264648 kB
LowTotal:         818556 kB
LowFree:          721912 kB
SwapTotal:       1023996 kB
SwapFree:        1023996 kB
Dirty:              1484 kB
Writeback:             0 kB
AnonPages:        637224 kB
Mapped:           148540 kB
Shmem:              1284 kB
Slab:              36908 kB
SReclaimable:      16864 kB
SUnreclaim:        20044 kB
KernelStack:        3664 kB
PageTables:         8296 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4116156 kB
Committed_AS:    3172256 kB
VmallocTotal:     122880 kB
VmallocUsed:       13156 kB
VmallocChunk:     104244 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8184 kB
DirectMap2M:      905216 kB

contents of /proc/mounts:
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=3D3084428k,nr_inodes=3D200772,mode=3D75=
5 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000
0 0 =

tmpfs /run tmpfs rw,nosuid,relatime,size=3D1236868k,mode=3D755 0 0
/dev/disk/by-uuid/e33b147d-faaa-4e55-8f3b-2fb2d3168053 / ext4
rw,relatime,errors=3Dremount-ro,data=3Dordered 0 0
none /sys/fs/fuse/connections fusectl rw,relatime 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0
none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
none /run/user tmpfs rw,nosuid,nodev,noexec,relatime,size=3D102400k,mode=3D=
755 0
0 =

gvfsd-fuse /run/user/jeffrey/gvfs fuse.gvfsd-fuse
rw,nosuid,nodev,relatime,user_id=3D1000,group_id=3D1000 0 0

contents of /proc/partitions:
major minor  #blocks  name

  11        0    1048575 sr0
   8        0 1953514584 sda
   8        1     530113 sda1
   8        2   15735664 sda2
   8        3 1937246216 sda3
   8       16  488386584 sdb
   8       17     530113 sdb1
   8       18   15735664 sdb2
   8       19  472118216 sdb3
   8       32 1953514584 sdc
   8       33    1024000 sdc1
   8       34 1952489258 sdc2
  11        1    1048575 sr1

RAID Layout: no Raid

LVM Configuration: Sorry, I didn't have the education to get this
information.

Type of discs: 2 3.5=B2 SATA drives, 1 half-height SATA.

hdparm results:

/dev/sda: =


ATA device, with non-removable media
    Model Number:       Hitachi HDS723020BLA642
    Serial Number:      MN1240FA04NWHD
    Firmware Revision:  MN6OA800
    Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions,
SATA Rev 2.5, SATA Rev 2.6; Revision: ATA8-AST T13 Project D1697 Revision 0b
Standards: =

    Used: unknown (minor revision code 0x0029)
    Supported: 8 7 6 5
    Likely used: 8 =

Configuration: =

    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    -- =

    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 3907029168
    Logical  Sector size:                   512 bytes
    Physical Sector size:                   512 bytes
    device size with M =3D 1024*1024:     1907729 MBytes
    device size with M =3D 1000*1000:     2000398 MBytes (2000 GB)
    cache/buffer size  =3D unknown
    Form Factor: 3.5 inch
    Nominal Media Rotation Rate: 7200
Capabilities: =

    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, no device specific minimum
    R/W multiple sector transfer: Max =3D 16    Current =3D 0
    Advanced power management level: disabled
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=3D120ns recommended=3D120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features: =

    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Advanced Power Management feature set
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
       *    SET_MAX security extension
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
            Media Card Pass-Through
       *    General Purpose Logging feature set
       *    WRITE_{DMA|MULTIPLE}_FUA_EXT
       *    64-bit World wide name
       *    URG for READ_STREAM[_DMA]_EXT
       *    URG for WRITE_STREAM[_DMA]_EXT
       *    WRITE_UNCORRECTABLE_EXT command
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
            unknown 119[7]
       *    Gen1 signaling speed (1.5Gb/s)
       *    Gen2 signaling speed (3.0Gb/s)
       *    Gen3 signaling speed (6.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
       *    NCQ priority information
            Non-Zero buffer offsets in DMA Setup FIS
            DMA Setup Auto-Activate optimization
            Device-initiated interface power management
            In-order data delivery
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
Security: =

    Master password revision code =3D 65534
        supported =

    not    enabled =

    not    locked =

        frozen =

    not    expired: security count
    not    supported: enhanced erase
    420min for SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000cca36ac21fe4
    NAA        : 5 =

    IEEE OUI    : 000cca
    Unique ID    : 36ac21fe4
Checksum: correct =



/dev/sdb: =


ATA device, with non-removable media
    Model Number:       ST3500312CS
    Serial Number:      6VV60HXR
    Firmware Revision:  SC13
    Transport:          Serial
Standards: =

    Used: unknown (minor revision code 0x0029)
    Supported: 8 7 6 5
    Likely used: 8 =

Configuration: =

    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    -- =

    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors:  976773168
    Logical/Physical Sector size:           512 bytes
    device size with M =3D 1024*1024:      476940 MBytes
    device size with M =3D 1000*1000:      500107 MBytes (500 GB)
    cache/buffer size  =3D 8192 KBytes
    Nominal Media Rotation Rate: 5900
Capabilities: =

    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, no device specific minimum
    R/W multiple sector transfer: Max =3D 16    Current =3D ?
    Advanced power management level: 254
    Recommended acoustic management value: 254, current value: 0
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=3D120ns recommended=3D120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features: =

    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    DOWNLOAD_MICROCODE
       *    Advanced Power Management feature set
            Power-Up In Standby feature set
            SET_FEATURES required to spinup after power up
       *    SET_MAX security extension
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    Media Card Pass-Through
       *    General Purpose Logging feature set
       *    64-bit World wide name
            Write-Read-Verify feature set
       *    WRITE_UNCORRECTABLE_EXT command
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    Gen1 signaling speed (1.5Gb/s)
       *    Gen2 signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Phy event counters
            Device-initiated interface power management
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
Security: =

    Master password revision code =3D 65534
        supported =

    not    enabled =

    not    locked =

        frozen =

    not    expired: security count
        supported: enhanced erase
    100min for SECURITY ERASE UNIT. 100min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000c500307c5d66
    NAA        : 5 =

    IEEE OUI    : 000c50
    Unique ID    : 0307c5d66
Checksum: correct =



/dev/sdc: =


ATA device, with non-removable media
    Model Number:       Hitachi HDS723020BLA642
    Serial Number:      MN3220F32KR53E
    Firmware Revision:  MN6OA800
    Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions,
SATA Rev 2.5, SATA Rev 2.6; Revision: ATA8-AST T13 Project D1697 Revision 0b
Standards: =

    Used: unknown (minor revision code 0x0029)
    Supported: 8 7 6 5
    Likely used: 8 =

Configuration: =

    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    -- =

    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 3907029168
    Logical  Sector size:                   512 bytes
    Physical Sector size:                   512 bytes
    device size with M =3D 1024*1024:     1907729 MBytes
    device size with M =3D 1000*1000:     2000398 MBytes (2000 GB)
    cache/buffer size  =3D unknown
    Form Factor: 3.5 inch
    Nominal Media Rotation Rate: 7200
Capabilities: =

    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, no device specific minimum
    R/W multiple sector transfer: Max =3D 16    Current =3D 0
    Advanced power management level: disabled
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=3D120ns recommended=3D120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features: =

    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Advanced Power Management feature set
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
       *    SET_MAX security extension
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
            Media Card Pass-Through
       *    General Purpose Logging feature set
       *    WRITE_{DMA|MULTIPLE}_FUA_EXT
       *    64-bit World wide name
       *    URG for READ_STREAM[_DMA]_EXT
       *    URG for WRITE_STREAM[_DMA]_EXT
       *    WRITE_UNCORRECTABLE_EXT command
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
            unknown 119[7]
       *    Gen1 signaling speed (1.5Gb/s)
       *    Gen2 signaling speed (3.0Gb/s)
       *    Gen3 signaling speed (6.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
       *    NCQ priority information
            Non-Zero buffer offsets in DMA Setup FIS
            DMA Setup Auto-Activate optimization
            Device-initiated interface power management
            In-order data delivery
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
Security: =

    Master password revision code =3D 65534
        supported =

    not    enabled =

    not    locked =

        frozen =

    not    expired: security count
    not    supported: enhanced erase
    456min for SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000cca369e43c85
    NAA        : 5 =

    IEEE OUI    : 000cca
    Unique ID    : 369e43c85
Checksum: correct =


Size of BBWC and Mode: Again, sorry, I couldn't find how to get this.

xfs_info:

root@jeffrey:~# xfs_info /mnt/fp
meta-data=3D/dev/sda2              isize=3D256    agcount=3D16, agsize=3D24=
5869 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D3933904, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D2560, version=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dexternal               extsz=3D1048576 blocks=3D484311554,
rtextents=3D1891842


root@jeffrey:~# xfs_info /mnt/hr20
meta-data=3D/dev/sdb2              isize=3D256    agcount=3D16, agsize=3D24=
5869 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D3933904, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D2560, version=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dexternal               extsz=3D1048576 blocks=3D118029554,
rtextents=3D461052







_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
