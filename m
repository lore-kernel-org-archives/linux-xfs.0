Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA61B7F63
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2015 20:47:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 486DCAC001
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2015 18:47:02 -0700 (PDT)
Received: from mail1.bemta7.messagelabs.com (mail1.bemta7.messagelabs.com
	[216.82.254.111]) by cuda.sgi.com with ESMTP id
	b5lhE3CQIFv9ACaS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jul 2015 18:47:00 -0700 (PDT)
From: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>
Subject: XFS File system in trouble
Date: Sat, 18 Jul 2015 01:46:56 +0000
Message-ID: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "'lrhorer@mygrande.net'" <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

	I have a 24T XFS file system that is very sick, and seemingly getting sicker.  I believe it to be the file system itself.  I have replaced the RAID chassis, the OS, the cables, the drive controller, and most of the drives. Re-syncing the 
RAID array complete in a reasonable time, given the size of the array, and reports no mismatches.  Xfs_repair completes, usually with no errors found, or sometimes one or two errors.  Some commands, like a df, are now hanging.  Writes are often failing with I/O errors.  I haven't found any amount of obvious file corruption, but performing a CRC check using md5sum, md6sum, sha256sum, etc., come up with different values every time they are run on many large files.  What can I do to try to rectify this?

Kernel: 3.16.0-4-amd64
Xfsprogs: 3.2.3
8 CPUs
/proc/meminfo:
MemTotal:        8095952 kB
MemFree:         7005032 kB
MemAvailable:    7393072 kB
Buffers:          201804 kB
Cached:           310752 kB
SwapCached:            0 kB
Active:           637704 kB
Inactive:         132232 kB
Active(anon):     258320 kB
Inactive(anon):     3888 kB
Active(file):     379384 kB
Inactive(file):   128344 kB
Unevictable:           0 kB
Mlocked:               4 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                40 kB
Writeback:             0 kB
AnonPages:        257376 kB
Mapped:           121392 kB
Shmem:              4824 kB
Slab:             141708 kB
SReclaimable:      98512 kB
SUnreclaim:        43196 kB
KernelStack:        5072 kB
PageTables:        18832 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4047976 kB
Committed_AS:    1189596 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      366160 kB
VmallocChunk:   34359349248 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       88660 kB
DirectMap2M:     4003840 kB
DirectMap1G:     4194304 kB

/proc/mounts:
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=1001559,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=809596k,mode=755 0 0
/dev/sdd2 / ext4 rw,noatime,errors=remount-ro,data=ordered 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
pstore /sys/fs/pstore pstore rw,relatime 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=1619180k 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
/dev/sdd1 /boot ext2 rw,noatime 0 0
tmpfs /var/www/vidmgr/artwork tmpfs rw,relatime,size=16384k 0 0
/dev/md2 /OldDrive ext4 rw,relatime,data=ordered 0 0
rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
Backup:/var/www /var/www/backup nfs rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,mountport=49438,mountproto=tcp,local_lock=none,addr=192.168.1.51 0 0
cgroup /sys/fs/cgroup tmpfs rw,relatime,size=12k 0 0
cgmfs /run/cgmanager/fs tmpfs rw,relatime,size=100k,mode=755 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/x86_64-linux-gnu/systemd-shim-cgroup-release-agent,name=systemd 0 0
tmpfs /run/user/0 tmpfs rw,nosuid,nodev,relatime,size=809596k,mode=700 0 0
Backup:/Backup /Backup nfs rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,mountport=57420,mountproto=tcp,local_lock=none,addr=192.168.1.51 0 0
/dev/md0 /RAID xfs rw,relatime,attr2,inode64,sunit=2048,swidth=12288,noquota 0 0

/proc/partitions:
major minor  #blocks  name

   8        0  125034840 sda
   8        1      96256 sda1
   8        2  112305152 sda2
   8        3   12632064 sda3
   8       16  125034840 sdb
   8       17      96256 sdb1
   8       18  112305152 sdb2
   8       19   12632064 sdb3
   8       32 3907018584 sdc
   9        1      96128 md1
   9        3   12623872 md3
   9        2  112239616 md2
  11        0    1048575 sr0
   8       48  488386584 sdd
   8       49      96256 sdd1
   8       50  112305152 sdd2
   8       51   12632064 sdd3
   9        0 23441319936 md0
   8       64 4883770584 sde
   8       80 4883770584 sdf
   8       96 3907018584 sdg
   8      112 4883770584 sdh
   8      128 4883770584 sdi
   8      144 3907018584 sdj
   8      160 3907018584 sdk

mdadm -D /dev/md0:
/dev/md0:
        Version : 1.2
  Creation Time : Fri Oct  3 20:06:55 2014
     Raid Level : raid6
     Array Size : 23441319936 (22355.39 GiB 24003.91 GB)
  Used Dev Size : 3906886656 (3725.90 GiB 4000.65 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Jul 17 19:47:45 2015
          State : clean 
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 1024K

           Name : RAID-Server:0  (local to host RAID-Server)
           UUID : d26e92db:8bd207bb:db9bec69:4117ed57
         Events : 698300

    Number   Major   Minor   RaidDevice State
      10       8      128        0      active sync   /dev/sdi
      12       8      112        1      active sync   /dev/sdh
       8       8       80        2      active sync   /dev/sdf
       9       8       64        3      active sync   /dev/sde
      11       8       96        4      active sync   /dev/sdg
       5       8       32        5      active sync   /dev/sdc
       6       8      160        6      active sync   /dev/sdk
       7       8      144        7      active sync   /dev/sdj

No LVM

8 SATA disks, various ,manufacturers, 4 & 5T

dmesg is un markable prior to echo w > /proc/sysrq-trigger:
[112915.907065] md: md0: requested-resync done.
[134859.522323] XFS (md0): Mounting V4 Filesystem
[134860.767122] XFS (md0): Ending clean mount
[135019.548703] XFS (md0): Mounting V4 Filesystem
[135019.817854] XFS (md0): Ending clean mount

Xfs_info:
meta-data=/dev/md0               isize=256    agcount=32, agsize=183135488 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=5860329984, imaxpct=5
         =                       sunit=256    swidth=1536 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

After echo w > /proc/sysrq-trigger:
http://fletchergeek.com/images/dmesg.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
