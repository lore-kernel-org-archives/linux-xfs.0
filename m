Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D9277F50
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:13:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 798C28F8054
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:13:48 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id SvcGQwoZg67WfuBk for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 18:13:46 -0700 (PDT)
Message-ID: <540FA586.9090308@mygrande.net>
Date: Tue, 09 Sep 2014 20:12:38 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
In-Reply-To: <20140909220645.GH20518@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/9/2014 5:06 PM, Dave Chinner wrote:
> Fristly, more infomration is required, namely versions and actual
> error messages:

	Indubitably:

RAID-Server:/# xfs_repair -V
xfs_repair version 3.1.7
RAID-Server:/# uname -r
3.2.0-4-amd64

4.0 GHz FX-8350 eight core processor

RAID-Server:/# cat /proc/meminfo /proc/mounts /proc/partitions
MemTotal:        8099916 kB
MemFree:         5786420 kB
Buffers:          112684 kB
Cached:           457020 kB
SwapCached:            0 kB
Active:           521800 kB
Inactive:         457268 kB
Active(anon):     276648 kB
Inactive(anon):   140180 kB
Active(file):     245152 kB
Inactive(file):   317088 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      12623740 kB
SwapFree:       12623740 kB
Dirty:                20 kB
Writeback:             0 kB
AnonPages:        409488 kB
Mapped:            47576 kB
Shmem:              7464 kB
Slab:             197100 kB
SReclaimable:     112644 kB
SUnreclaim:        84456 kB
KernelStack:        2560 kB
PageTables:         8468 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    16673696 kB
Committed_AS:    1010172 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      339140 kB
VmallocChunk:   34359395308 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       65532 kB
DirectMap2M:     5120000 kB
DirectMap1G:     3145728 kB
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=1002653,mode=755 0 0
devpts /dev/pts devpts 
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=809992k,mode=755 0 0
/dev/disk/by-uuid/fa5c404a-bfcb-43de-87ed-e671fda1ba99 / ext4 
rw,relatime,errors=remount-ro,user_xattr,barrier=1,data=ordered 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=4144720k 0 0
/dev/md1 /boot ext2 rw,relatime,errors=continue 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
Backup:/Backup /Backup nfs 
rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,mountport=39597,mountproto=tcp,local_lock=none,addr=192.168.1.51 
0 0
Backup:/var/www /var/www/backup nfs 
rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,mountport=39597,mountproto=tcp,local_lock=none,addr=192.168.1.51 
0 0
/dev/md0 /RAID xfs 
rw,relatime,attr2,delaylog,sunit=2048,swidth=12288,noquota 0 0
major minor  #blocks  name

    8        0  125034840 sda
    8        1      96256 sda1
    8        2  112305152 sda2
    8        3   12632064 sda3
    8       16  125034840 sdb
    8       17      96256 sdb1
    8       18  112305152 sdb2
    8       19   12632064 sdb3
    8       48 3907018584 sdd
    8       32 3907018584 sdc
    8       64 1465138584 sde
    8       80 1465138584 sdf
    8       96 1465138584 sdg
    8      112 3907018584 sdh
    8      128 3907018584 sdi
    8      144 3907018584 sdj
    8      160 3907018584 sdk
    9        1      96192 md1
    9        2  112239488 md2
    9        3   12623744 md3
    9        0 23441319936 md0
    9       10 4395021312 md10

RAID-Server:/# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
md10 : active raid0 sdf[0] sde[2] sdg[1]
       4395021312 blocks super 1.2 512k chunks

md0 : active raid6 md10[12] sdc[13] sdk[10] sdj[11] sdi[15] sdh[8] sdd[9]
       23441319936 blocks super 1.2 level 6, 1024k chunk, algorithm 2 
[8/7] [UUU_UUUU]
       bitmap: 29/30 pages [116KB], 65536KB chunk

md3 : active (auto-read-only) raid1 sda3[0] sdb3[1]
       12623744 blocks super 1.2 [3/2] [UU_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md2 : active raid1 sda2[0] sdb2[1]
       112239488 blocks super 1.2 [3/2] [UU_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md1 : active raid1 sda1[0] sdb1[1]
       96192 blocks [3/2] [UU_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

	Six of the drives are 4T spindles (a mixture of makes and models).  The 
three drives comprising MD10 are WD 1.5T green drives.  These are in 
place to take over the function of one of the kicked 4T drives.  Md1, 2, 
and 3 are not data drives and are not suffering any issue.

	I'm not sure what is meant by "write cache status" in this context. 
The machine has been rebooted more than once during recovery and the FS 
has been umounted and xfs_repair run several times.

	I don't know for what the acronym BBWC stands.

RAID-Server:/# xfs_info /dev/md0
meta-data=/dev/md0               isize=256    agcount=43, 
agsize=137356288 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5860329984, imaxpct=5
          =                       sunit=256    swidth=1536 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

	The system performs just fine, other than the aforementioned, with 
loads in excess of 3Gbps.  That is internal only.  The LAN link is ony 
1Gbps, so no external request exceeds about 950Mbps.

> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> dmesg, in particular, should tell use what the corruption being
> encountered is when stat fails.

RAID-Server:/# ls "/RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.VOB"
ls: cannot access /RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.VOB: 
Structure needs cleaning
RAID-Server:/# dmesg | tail -n 30
...
[192173.363981] XFS (md0): corrupt dinode 41006, extent total = 1, 
nblocks = 0.
[192173.363988] ffff8802338b8e00: 49 4e 81 b6 02 02 00 00 00 00 03 e8 00 
00 03 e8  IN..............
[192173.363996] XFS (md0): Internal error xfs_iformat(1) at line 319 of 
file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_inode.c.  Caller 
0xffffffffa0509318
[192173.363999]
[192173.364062] Pid: 10813, comm: ls Not tainted 3.2.0-4-amd64 #1 Debian 
3.2.60-1+deb7u3
[192173.364065] Call Trace:
[192173.364097]  [<ffffffffa04d3731>] ? xfs_corruption_error+0x54/0x6f [xfs]
[192173.364134]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
[192173.364170]  [<ffffffffa0508efa>] ? xfs_iformat+0xe3/0x462 [xfs]
[192173.364204]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
[192173.364240]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
[192173.364268]  [<ffffffffa04d6ebe>] ? xfs_iget+0x37c/0x56c [xfs]
[192173.364300]  [<ffffffffa04e13b4>] ? xfs_lookup+0xa4/0xd3 [xfs]
[192173.364328]  [<ffffffffa04d9e5a>] ? xfs_vn_lookup+0x3f/0x7e [xfs]
[192173.364344]  [<ffffffff81102de9>] ? d_alloc_and_lookup+0x3a/0x60
[192173.364357]  [<ffffffff8110388d>] ? walk_component+0x219/0x406
[192173.364370]  [<ffffffff81104721>] ? path_lookupat+0x7c/0x2bd
[192173.364383]  [<ffffffff81036628>] ? should_resched+0x5/0x23
[192173.364396]  [<ffffffff8134f144>] ? _cond_resched+0x7/0x1c
[192173.364408]  [<ffffffff8110497e>] ? do_path_lookup+0x1c/0x87
[192173.364420]  [<ffffffff81106407>] ? user_path_at_empty+0x47/0x7b
[192173.364434]  [<ffffffff813533d8>] ? do_page_fault+0x30a/0x345
[192173.364448]  [<ffffffff810d6a04>] ? mmap_region+0x353/0x44a
[192173.364460]  [<ffffffff810fe45a>] ? vfs_fstatat+0x32/0x60
[192173.364471]  [<ffffffff810fe590>] ? sys_newstat+0x12/0x2b
[192173.364483]  [<ffffffff813509f5>] ? page_fault+0x25/0x30
[192173.364495]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
[192173.364503] XFS (md0): Corruption detected. Unmount and run xfs_repair

	That last line, by the way, is why I ran umount and xfs_repair.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
