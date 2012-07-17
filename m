Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HLHSgb112175 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 16:17:28 -0500
Received: from mx0b-000fd501.pphosted.com (mx0b-000fd501.pphosted.com
	[67.231.152.235]) by cuda.sgi.com with ESMTP id
	YGkkPHQyzGBPNOyM for <xfs@oss.sgi.com>;
	Tue, 17 Jul 2012 14:17:23 -0700 (PDT)
Message-ID: <5005D661.8030200@dolby.com>
Date: Tue, 17 Jul 2012 14:17:21 -0700
From: Benedict Singer <bzsing@dolby.com>
MIME-Version: 1.0
Subject: xfs/md filesystem hang on drive pull under IO with 2.6.35.13
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-raid@vger.kernel.org

Hi XFS and MD experts,

I'm experiencing a problem with a setup running XFS on top of an MD 
raid. The test I'm running is physically pulling a drive while the 
system is running, to simulate hardware failure. When the system is 
idle, this works fine; the md subsystem detects the missing drive and 
degrades the arrays, and everything keeps running fine. If I pull a 
drive while heavy IO activity (mostly if not completely reading) is 
happening on the XFS filesystem, then very often the filesystem seems to 
"hang" - both processes that were accessing the filesystem at the time 
hang, as well as any new ones like 'ls'. Luckily, the kernel noticed the 
hung processes and spit a bunch of useful information to syslog. The 
relevant snippets are reproduced below, including the messages 
indicating that the drive was pulled, along with other XFS/MD raid 
information from the system. The filesystem in question is on 
/dev/md126, mounted on /var/showstore, and the disk pulled was /dev/sda. 
Note that at the time this information was collected, the disk had been 
re-inserted and a rebuild was proceeding.

Is this a bug (seems like a race condition leading to a deadlock?), 
and/or is there something to change in the way the system is set up to 
mitigate or workaround this?

Thanks in advance!
Benedict

Jul 16 17:48:05 bzsing-dss220 kernel: ata1.00: exception Emask 0x50 SAct 
0x0 SErr 0x4890800 action 0xe frozen
Jul 16 17:48:05 bzsing-dss220 kernel: ata1.00: irq_stat 0x04400040, 
connection status changed
Jul 16 17:48:05 bzsing-dss220 kernel: ata1: SError: { HostInt PHYRdyChg 
10B8B LinkSeq DevExch }
Jul 16 17:48:05 bzsing-dss220 kernel: ata1.00: failed command: FLUSH 
CACHE EXT
Jul 16 17:48:05 bzsing-dss220 kernel: ata1.00: cmd 
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Jul 16 17:48:05 bzsing-dss220 kernel:         res 
50/00:00:00:00:00/00:00:00:00:00/00 Emask 0x50 (ATA bus error)
Jul 16 17:48:05 bzsing-dss220 kernel: ata1.00: status: { DRDY }
Jul 16 17:48:11 bzsing-dss220 kernel: ata1: limiting SATA link speed to 
1.5 Gbps
Jul 16 17:48:17 bzsing-dss220 kernel: ata1.00: disabled
Jul 16 17:48:17 bzsing-dss220 kernel: ata1.00: device reported invalid 
CHS sector 0
Jul 16 17:48:17 bzsing-dss220 kernel: end_request: I/O error, dev sda, 
sector 0
Jul 16 17:48:17 bzsing-dss220 kernel: sd 0:0:0:0: rejecting I/O to 
offline device
Jul 16 17:48:17 bzsing-dss220 kernel: last message repeated 14 times
Jul 16 17:48:17 bzsing-dss220 kernel: end_request: I/O error, dev sda, 
sector 8392712
Jul 16 17:48:17 bzsing-dss220 kernel: md: super_written gets error=-5, 
uptodate=0
Jul 16 17:48:17 bzsing-dss220 kernel: md/raid:md127: Disk failure on 
sda2, disabling device.
Jul 16 17:48:17 bzsing-dss220 kernel: <1>md/raid:md127: Operation 
continuing on 2 devices.
Jul 16 17:48:17 bzsing-dss220 kernel: sd 0:0:0:0: [sda] START_STOP FAILED
Jul 16 17:48:17 bzsing-dss220 kernel: md/raid:md1: Disk failure on sda1, 
disabling device.
Jul 16 17:48:17 bzsing-dss220 kernel: <1>md/raid:md1: Operation 
continuing on 2 devices.
Jul 16 17:48:17 bzsing-dss220 mdadm[5098]: Rebuild41 event detected on 
md device /dev/md/content
Jul 16 17:48:17 bzsing-dss220 kernel: scsi 0:0:0:0: rejecting I/O to 
dead device
Jul 16 17:48:17 bzsing-dss220 kernel: scsi 0:0:0:0: rejecting I/O to 
dead device
Jul 16 17:48:17 bzsing-dss220 kernel: end_request: I/O error, dev sda, 
sector 8
Jul 16 17:48:17 bzsing-dss220 kernel: md: super_written gets error=-5, 
uptodate=0
Jul 16 17:48:17 bzsing-dss220 kernel: md/raid:md126: Disk failure on 
sda3, disabling device.
Jul 16 17:48:17 bzsing-dss220 kernel: <1>md/raid:md126: Operation 
continuing on 2 devices.
Jul 16 17:48:17 bzsing-dss220 mdadm[5098]: Fail event detected on md 
device /dev/md/status
Jul 16 17:48:17 bzsing-dss220 mdadm[5098]: FailSpare event detected on 
md device /dev/md/status, component device /dev/sda2
Jul 16 17:48:17 bzsing-dss220 mdadm[5098]: Fail event detected on md 
device /dev/md1, component device /dev/sda1
Jul 16 17:48:17 bzsing-dss220 mdadm[5098]: FailSpare event detected on 
md device /dev/md/content, component device /dev/sda3
Jul 16 17:48:45 bzsing-dss220 kernel: ata1: exception Emask 0x10 SAct 
0x0 SErr 0x4040000 action 0xe frozen
Jul 16 17:48:45 bzsing-dss220 kernel: ata1: irq_stat 0x00000040, 
connection status changed
Jul 16 17:48:45 bzsing-dss220 kernel: ata1: SError: { CommWake DevExch }
Jul 16 17:48:51 bzsing-dss220 kernel: ata1: link is slow to respond, 
please be patient (ready=0)
Jul 16 17:48:55 bzsing-dss220 kernel: ata1: COMRESET failed (errno=-16)
Jul 16 17:50:38 bzsing-dss220 kernel: INFO: task sync:25175 blocked for 
more than 120 seconds.
Jul 16 17:50:38 bzsing-dss220 kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 16 17:50:38 bzsing-dss220 kernel: db5b1c98 00000082 00000002 
db5b1c88 db5b1c58 f6974a20 f6973cb8 c178d000
Jul 16 17:50:38 bzsing-dss220 kernel: dbf4e8b0 dbf4ea24 00000003 
00274316 00000001 00000086 db5b1c8c c1026c10
Jul 16 17:50:38 bzsing-dss220 kernel: f536be40 00000000 00000246 
db5b1c98 c1045d85 00000001 f6447de0 db5b1ca4
Jul 16 17:50:38 bzsing-dss220 kernel: Call Trace:
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1026c10>] ? __wake_up+0x40/0x50
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1045d85>] ? 
prepare_to_wait+0x45/0x70
Jul 16 17:50:38 bzsing-dss220 kernel: [<c141fc4d>] md_write_start+0x9d/0x190
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1045b30>] ? 
autoremove_wake_function+0x0/0x50
Jul 16 17:50:38 bzsing-dss220 kernel: [<c14192cd>] make_request+0x2d/0x860
Jul 16 17:50:38 bzsing-dss220 kernel: [<c102cebd>] ? 
load_balance+0xa0d/0x1320
Jul 16 17:50:38 bzsing-dss220 kernel: [<c102cebd>] ? 
load_balance+0xa0d/0x1320
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1252b97>] ? 
generic_make_request+0x257/0x430
Jul 16 17:50:38 bzsing-dss220 kernel: [<c142048d>] 
md_make_request+0xad/0x1d0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c103b7d2>] ? 
run_timer_softirq+0x32/0x1e0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1252b97>] 
generic_make_request+0x257/0x430
Jul 16 17:50:38 bzsing-dss220 kernel: [<c103669d>] ? irq_exit+0x2d/0x40
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1018b26>] ? 
smp_apic_timer_interrupt+0x56/0x90
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1515222>] ? 
apic_timer_interrupt+0x2a/0x30
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1252db8>] submit_bio+0x48/0xc0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c140fb00>] ? 
raid5_mergeable_bvec+0x0/0xb0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c10b950a>] ? bio_add_page+0x3a/0x50
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1229df8>] 
_xfs_buf_ioapply+0x118/0x2c0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c122ae13>] 
xfs_buf_iorequest+0x23/0x60
Jul 16 17:50:38 bzsing-dss220 kernel: [<c122b3a7>] xfs_bdstrat_cb+0x37/0x70
Jul 16 17:50:38 bzsing-dss220 kernel: [<c122b14e>] xfs_bwrite+0x3e/0xb0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1233053>] xfs_sync_fsdata+0x33/0x40
Jul 16 17:50:38 bzsing-dss220 kernel: [<c12336ff>] 
xfs_quiesce_data+0x2f/0x90
Jul 16 17:50:38 bzsing-dss220 kernel: [<c123096f>] xfs_fs_sync_fs+0x2f/0xc0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c10b36da>] 
__sync_filesystem+0x5a/0xa0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c10b373a>] sync_one_sb+0x1a/0x20
Jul 16 17:50:38 bzsing-dss220 kernel: [<c10959d4>] iterate_supers+0x64/0xa0
Jul 16 17:50:38 bzsing-dss220 kernel: [<c10b3720>] ? sync_one_sb+0x0/0x20
Jul 16 17:50:38 bzsing-dss220 kernel: [<c10b3777>] sys_sync+0x37/0x60
Jul 16 17:50:38 bzsing-dss220 kernel: [<c1514e35>] syscall_call+0x7/0xb
Jul 16 17:52:38 bzsing-dss220 kernel: INFO: task java:6675 blocked for 
more than 120 seconds.
Jul 16 17:52:38 bzsing-dss220 kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 16 17:52:38 bzsing-dss220 kernel: dc213ae4 00200082 00000002 
dc213ad4 c1b6e400 00000000 f6c266ac c178d000
Jul 16 17:52:38 bzsing-dss220 kernel: f71d5bb0 f71d5d24 00000000 
0028e2dd dc27dc08 56f2a410 00000000 00000000
Jul 16 17:52:38 bzsing-dss220 kernel: f66e4580 00000000 00000000 
dc27dbc0 00000000 00000001 f64f3504 7fffffff
Jul 16 17:52:38 bzsing-dss220 kernel: Call Trace:
Jul 16 17:52:38 bzsing-dss220 kernel: [<c15134cd>] 
schedule_timeout+0x12d/0x190
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1512a9a>] 
wait_for_common+0xba/0x120
Jul 16 17:52:38 bzsing-dss220 kernel: [<c102e470>] ? 
default_wake_function+0x0/0x10
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1512ba2>] 
wait_for_completion+0x12/0x20
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1229be4>] xfs_buf_iowait+0x34/0x40
Jul 16 17:52:38 bzsing-dss220 kernel: [<c122b237>] _xfs_buf_read+0x47/0x60
Jul 16 17:52:38 bzsing-dss220 kernel: [<c122b75b>] xfs_buf_read+0x6b/0xa0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c12218cd>] 
xfs_trans_read_buf+0x19d/0x2d0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1204f73>] xfs_read_agi+0x93/0x120
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1205020>] 
xfs_ialloc_read_agi+0x20/0x90
Jul 16 17:52:38 bzsing-dss220 kernel: [<c121c9cf>] ? xfs_perag_get+0x2f/0x60
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1205391>] 
xfs_ialloc_ag_select+0x1c1/0x260
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1206bfe>] xfs_dialloc+0x3de/0x8d0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c108f244>] ? 
cache_alloc_refill+0x74/0x4e0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c100177c>] ? __switch_to+0x13c/0x1b0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c126076f>] ? 
cpumask_next_and+0x1f/0x40
Jul 16 17:52:38 bzsing-dss220 kernel: [<c120ae8c>] xfs_ialloc+0x5c/0x650
Jul 16 17:52:38 bzsing-dss220 kernel: [<c12226cf>] xfs_dir_ialloc+0x6f/0x2a0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1220683>] ? 
xfs_trans_reserve+0x73/0x1f0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c12248b4>] xfs_create+0x2a4/0x4c0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c122f7e6>] xfs_vn_mknod+0x76/0x110
Jul 16 17:52:38 bzsing-dss220 kernel: [<c122f8b2>] xfs_vn_create+0x12/0x20
Jul 16 17:52:38 bzsing-dss220 kernel: [<c109c9ac>] vfs_create+0x8c/0xc0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c122f8a0>] ? xfs_vn_create+0x0/0x20
Jul 16 17:52:38 bzsing-dss220 kernel: [<c109d85c>] do_last+0x4ec/0x650
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1094cbe>] ? 
get_empty_filp+0x6e/0x140
Jul 16 17:52:38 bzsing-dss220 kernel: [<c109f575>] do_filp_open+0x1a5/0x4f0
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1092095>] do_sys_open+0x65/0x100
Jul 16 17:52:38 bzsing-dss220 kernel: [<c126a0a2>] ? copy_to_user+0x42/0x130
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1092199>] sys_open+0x29/0x40
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1514e35>] syscall_call+0x7/0xb
Jul 16 17:52:38 bzsing-dss220 kernel: [<c1510000>] ? 
vt8231_pci_probe+0x170/0x240

uname -a:
Linux bzsing-dss220 2.6.35.13 #1 SMP Wed Jul 11 19:35:18 UTC 2012 i686 
GNU/Linux

xfsprogs version:
xfs_repair version 2.9.8

CPUs:
1 CPU, 4 logical processors

/proc/meminfo:
MemTotal:        3103400 kB
MemFree:           92320 kB
Buffers:            2264 kB
Cached:          1583880 kB
SwapCached:            0 kB
Active:          1561084 kB
Inactive:         992460 kB
Active(anon):     810160 kB
Inactive(anon):   211708 kB
Active(file):     750924 kB
Inactive(file):   780752 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       2227784 kB
HighFree:           4432 kB
LowTotal:         875616 kB
LowFree:           87888 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                24 kB
Writeback:             0 kB
AnonPages:        967400 kB
Mapped:            43548 kB
Shmem:             54468 kB
Slab:              42148 kB
SReclaimable:      12704 kB
SUnreclaim:        29444 kB
KernelStack:        6104 kB
PageTables:         4412 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1551700 kB
Committed_AS:    2060196 kB
VmallocTotal:     122880 kB
VmallocUsed:        3900 kB
VmallocChunk:     117876 kB
DirectMap4k:        8184 kB
DirectMap4M:      901120 kB

/proc/mounts:
rootfs / rootfs rw 0 0
none /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
none /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev tmpfs rw,relatime,size=10240k,mode=755 0 0
/dev/md1 /ro ext2 ro,relatime,errors=continue 0 0
root.rw /rw tmpfs rw,relatime 0 0
unionfs / unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
usbfs /proc/bus/usb usbfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
/dev/md127 /status xfs rw,relatime,attr2,sunit=512,swidth=1024,noquota 0 0
shm /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
/dev/md126 /var/showstore xfs 
rw,relatime,attr2,sunit=512,swidth=1024,noquota 0 0
unionfs /adminchroot/home/ext unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
/dev/md127 /adminchroot/status/log xfs 
rw,relatime,attr2,sunit=512,swidth=1024,noquota 0 0
unionfs /adminchroot/usr/lib/java unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/usr/share/java unionfs 
rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/usr/share/jython unionfs 
rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/usr/share/perl unionfs 
rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/etc/java-6-sun unionfs 
rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/usr/lib/jni unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/etc/pam.d unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/lib/security unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
unionfs /adminchroot/lib/terminfo unionfs rw,relatime,dirs=/rw=rw:/ro=ro 0 0
proc /adminchroot/proc proc rw,relatime 0 0
ramfs /adminchroot/tmp ramfs rw,relatime 0 0

/proc/partitions:
major minor  #blocks  name

    8       16 1953514584 sdb
    8       17    3145728 sdb1
    8       18    4194304 sdb2
    8       19 1944992838 sdb3
    8       20    1048576 sdb4
    8       21       2031 sdb5
    8       32 1953514584 sdc
    8       33    3145728 sdc1
    8       34    4194304 sdc2
    8       35 1944992838 sdc3
    8       36    1048576 sdc4
    8       37       2031 sdc5
    9        1    6290944 md1
    9      127    8386048 md127
    9      126 3889982976 md126
    9        4    2096640 md4
    8       48 1953514584 sdd
    8       49    3145728 sdd1
    8       50    4194304 sdd2
    8       51 1944992838 sdd3
    8       52    1048576 sdd4
    8       53       2031 sdd5

RAID info: MD raid, 4 arrays
/proc/mdstat:
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md4 : active raid5 sda4[3](F) sdc4[2] sdb4[1]
       2096640 blocks level 5, 256k chunk, algorithm 2 [3/2] [_UU]

md126 : active raid5 sda3[3](F) sdc3[2] sdb3[1]
       3889982976 blocks super 1.2 level 5, 256k chunk, algorithm 2 
[3/2] [_UU]
       [========>............]  recovery = 41.4% (805249156/1944991488) 
finish=36804179.4min speed=0K/sec

md127 : active raid5 sda2[3](F) sdc2[2] sdb2[1]
       8386048 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/2] [_UU]

md1 : active raid5 sda1[3](F) sdc1[2] sdb1[1]
       6290944 blocks level 5, 256k chunk, algorithm 2 [3/2] [_UU]

unused devices: <none>:

LVM: not used
Drives: Hitachi 2TB
Drive write cache: on

xfs_info for /dev/md126:
meta-data=/dev/md126             isize=256    agcount=32, 
agsize=30390464 blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=972494848, imaxpct=5
          =                       sunit=64     swidth=128 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=524288 blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
