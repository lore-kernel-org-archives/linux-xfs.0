Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2040A7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 17:53:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8172DAC001
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 15:52:57 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id PEExEuawF4fo1IYh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 15:52:54 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.hs.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r33MqpID007956 for <xfs@oss.sgi.com>; Wed, 3 Apr 2013 15:52:53 -0700
Message-ID: <515CB2C1.1050109@tlinx.org>
Date: Wed, 03 Apr 2013 15:52:49 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsdump having problems dumping attributes again (cannot allocate
	memory)
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
To: xfs-oss <xfs@oss.sgi.com>


Note -- I might have more attributes than some as the disks are shared via samba
w/windows
and samba stores ACL and xattr info from windows in xfs's attrs...


xfsdump: WARNING: could not get list of root attributes for nondir ino
3412893285: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of secure attributes for nondir ino
3412893285: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of non-root attributes for nondir ino
3412893290: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of root attributes for nondir ino
3412893290: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of secure attributes for nondir ino
3412893290: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of non-root attributes for nondir ino
3412894183: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of root attributes for nondir ino
3412894183: Cannot allocate memory (12)
....
Linux Ishtar 3.8.2-Isht-Van #3 SMP PREEMPT Fri Mar 22 21:15:14 PDT 2013 x86_64
x86_64 x86_64 GNU/Linux
xfs_repair version 3.1.10
12 cpus
> cat /proc/meminfo
MemTotal:       49489152 kB
MemFree:          409956 kB
Buffers:            1596 kB
Cached:         17932136 kB
SwapCached:        76204 kB
Active:         19338740 kB
Inactive:       19841616 kB
Active(anon):   18934044 kB
Inactive(anon):  2319988 kB
Active(file):     404696 kB
Inactive(file): 17521628 kB
Unevictable:       24968 kB
Mlocked:           24968 kB
SwapTotal:       8393924 kB
SwapFree:        8029584 kB
Dirty:                84 kB
Writeback:             0 kB
AnonPages:      21196344 kB
Mapped:            98256 kB
Shmem:              3940 kB
Slab:            7242232 kB
SReclaimable:    6662800 kB
SUnreclaim:       579432 kB
KernelStack:        7216 kB
PageTables:        78948 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    33138500 kB
Committed_AS:   23870772 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      425136 kB
VmallocChunk:   34334089480 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7652 kB
DirectMap2M:     2076672 kB
DirectMap1G:    48234496 kB

Ishtar:tools/xfs/git/xfsdump> cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / xfs rw,noatime,nodiratime,attr2,inode64,noquota 0 0
devtmpfs /dev devtmpfs rw,relatime,size=24708844k,nr_inodes=6177211,mode=755 0 0
/dev/sdc6 /usr xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=64k,logbsize=256k,noquota
0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
tmpfs /run tmpfs rw,relatime,mode=755 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
tmpfs /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,relatime,mode=755 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/debug cgroup rw,nosuid,nodev,noexec,relatime,debug 0 0
cgroup /sys/fs/cgroup/cpu cgroup rw,nosuid,nodev,noexec,relatime,cpu 0 0
cgroup /sys/fs/cgroup/cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/net_prio cgroup rw,nosuid,nodev,noexec,relatime,net_prio 0 0
securityfs /sys/kernel/security securityfs rw,relatime 0 0
/dev/sdc2 /var xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,noquota
0 0
/dev/sdc3 /boot xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=2048k,noquota 0 0
/dev/sdc2 /tmp xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,noquota
0 0
/dev/mapper/HnS-Sys /root2 xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=64k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/HnS-Sysvar /root2/var xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/HnS-Sysboot /root2/boot xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=2048k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/HnS-Home /home xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/HnS-Share /Share xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=1024k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/HnS-Home.diff /home.diff xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/Media-Media /Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=32768k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
/dev/mapper/HnS-Squid_Cache /var/cache/squid xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=64k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
/dev/mapper/Backups-Backups /backups xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=131072k,logbsize=256k,sunit=128,swidth=768,noquota
0 0
/dev/mapper/HnS-Media_Back /backups/Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=131072k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
/dev/mapper/HnS-Home /usr/share xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/Media-Media /Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=32768k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
tmpfs /var/lock tmpfs rw,relatime,mode=755 0 0
tmpfs /var/run tmpfs rw,relatime,mode=755 0 0
tmpfs /media tmpfs rw,nosuid,nodev,relatime,mode=755 0 0
/dev/sdc2 /tmp xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,noquota
0 0
/dev/mapper/HnS-Home /usr/share xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/Media-Media /Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=32768k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
proc /var/lib/named/proc proc ro,nosuid,nodev,noexec,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
/etc/auto.misc /misc autofs
rw,relatime,fd=6,pgrp=11123,timeout=600,minproto=5,maxproto=5,indirect 0 0
/etc/auto.smb /smb autofs
rw,relatime,fd=12,pgrp=11123,timeout=600,minproto=5,maxproto=5,indirect 0 0
/etc/auto.net /net autofs
rw,relatime,fd=18,pgrp=11123,timeout=600,minproto=5,maxproto=5,indirect 0 0
/etc/auto.homes /homes autofs
rw,relatime,fd=24,pgrp=11123,timeout=600,minproto=5,maxproto=5,indirect 0 0
/dev/HnS/Home-2013.03.05-05.07.02 /home/.snapdir/@GMT-2013.03.05-05.07.02 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.13-01.20.33 /home/.snapdir/@GMT-2013.03.13-01.20.33 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.17-05.07.02 /home/.snapdir/@GMT-2013.03.17-05.07.02 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.19-05.07.02 /home/.snapdir/@GMT-2013.03.19-05.07.02 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.21-05.07.03 /home/.snapdir/@GMT-2013.03.21-05.07.03 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
proc /var/empty/dev proc rw,relatime 0 0
gvfs-fuse-daemon /home/law/.gvfs fuse.gvfs-fuse-daemon
rw,nosuid,nodev,relatime,user_id=5013,group_id=201 0 0
/dev/sdc2 /tmp xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,noquota
0 0
/dev/mapper/HnS-Home /usr/share xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/Media-Media /Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=32768k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
gvfs-fuse-daemon /root/.gvfs fuse.gvfs-fuse-daemon
rw,nosuid,nodev,relatime,user_id=0,group_id=0 0 0
/dev/sdc2 /tmp xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,noquota
0 0
/dev/mapper/HnS-Home /usr/share xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/Media-Media /Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=32768k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
/dev/sdc2 /tmp xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=128k,logbsize=256k,noquota
0 0
/dev/mapper/HnS-Home /usr/share xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,allocsize=128k,logbsize=256k,sunit=128,swidth=1536,noquota
0 0
/dev/mapper/Media-Media /Media xfs
rw,noatime,nodiratime,swalloc,attr2,largeio,inode64,allocsize=32768k,logbsize=256k,sunit=128,swidth=1280,noquota
0 0
/dev/HnS/Home-2013.03.25-05.07.06 /home/.snapdir/@GMT-2013.03.25-05.07.06 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.26-05.07.03 /home/.snapdir/@GMT-2013.03.26-05.07.03 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.27-05.07.18 /home/.snapdir/@GMT-2013.03.27-05.07.18 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.29-21.00.11 /home/.snapdir/@GMT-2013.03.29-21.00.11 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.03.31-05.07.03 /home/.snapdir/@GMT-2013.03.31-05.07.03 xfs
ro,relatime,nouuid,norecovery,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota
0 0
/dev/HnS/Home-2013.03.30-05.07.04 /home/.snapdir/@GMT-2013.03.30-05.07.04 xfs
rw,relatime,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota 0 0
/dev/HnS/Home-2013.04.03-14.41.10 /home/.snapdir/@GMT-2013.04.03-14.41.10 xfs
ro,relatime,nouuid,norecovery,attr2,inode64,logbsize=64k,sunit=128,swidth=1536,noquota
0 0
> cat /proc/partitions
major minor  #blocks  name

   8       16 11717836800 sdb
   8       17 11717836766 sdb1
   8        0 23435673600 sda
   8        1 23435673566 sda1
   8       32  142344192 sdc
   8       33   12699351 sdc1
   8       34    8305605 sdc2
   8       35    1060290 sdc3
   8       36          1 sdc4
   8       37    8393931 sdc5
   8       38   15735636 sdc6
   8       39   10490413 sdc7
   8       40   83883366 sdc8
   8       48 7811891200 sdd
   8       49 7811891166 sdd1
 254        0 7811887104 dm-0
 254        1 11717832704 dm-1
 254        2 1073741824 dm-2
 254        3 1073741824 dm-3
 254        6 8589934592 dm-6
 254        7  134217728 dm-7
 254        8 1610612736 dm-8
 254        9  536870912 dm-9
 254       12   12984320 dm-12
 254       14    4194304 dm-14
 254       15   29360128 dm-15
 254       16  100663296 dm-16
 254       19   38985728 dm-19
 254       23    3158016 dm-23
 254       25    2555904 dm-25
 254       27    2097152 dm-27
 254        5    1601536 dm-5
 254       11    6733824 dm-11
 254       22    3207168 dm-22
 254       17    1519616 dm-17
 254        4 1073741824 dm-4
 254       18 1073741824 dm-18
 254       10    1241088 dm-10
 254       13 1073741824 dm-13
 254       20 1073741824 dm-20

 sudo xfs_info /Share
meta-data=/dev/mapper/HnS-Share  isize=256    agcount=4, agsize=100663280 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=402653120, imaxpct=5
         =                       sunit=16     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

lvm config?  How do I include that?

[1007383.689492] xfsdump: page allocation failure: order:4, mode:0x10c0d0
[1007383.689496] Pid: 29968, comm: xfsdump Not tainted 3.8.2-Isht-Van #3
[1007383.689499] Call Trace:
[1007383.689508]  [<ffffffff810fc937>] warn_alloc_failed+0xe7/0x130
[1007383.689514]  [<ffffffff8109e302>] ? on_each_cpu_mask+0x42/0xb0
[1007383.689518]  [<ffffffff81100805>] __alloc_pages_nodemask+0x7f5/0xb10
[1007383.689524]  [<ffffffff8113c293>] alloc_pages_current+0xb3/0x180
[1007383.689527]  [<ffffffff810fbea9>] __get_free_pages+0x9/0x40
tive_anon:617752kB inactive_anon:285044kB active_file:8660kB inactive_file:20299
48kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3325868kB man
aged:3354316kB mlocked:0kB dirty:0kB writeback:0kB mapped:632kB shmem:12kB slab_
reclaimable:164284kB slab_unreclaimable:6852kB kernel_stack:328kB pagetables:157
2kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_u
nreclaimable? no
[1007383.493008] lowmem_reserve[]: 0 0 20916 20916
[1007383.493013] Node 1 Normal free:216420kB min:38964kB low:48704kB high:58444k
B active_anon:3633180kB inactive_anon:1037492kB active_file:130260kB inactive_fi
le:11115920kB unevictable:12220kB isolated(anon):0kB isolated(file):0kB present:
21417984kB managed:21352576kB mlocked:12220kB dirty:104kB writeback:0kB mapped:2
2788kB shmem:1568kB slab_reclaimable:4324888kB slab_unreclaimable:277036kB kerne
l_stack:2968kB pagetables:27504kB unstable:0kB bounce:0kB free_cma:0kB writeback
_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1007383.493022] lowmem_reserve[]: 0 0 0 0
[1007383.493027] Node 0 Normal: 33494*4kB (UEM) 5724*8kB (UEM) 1114*16kB (UEM) 3
[1007383.689531]  [<ffffffff81143a54>] kmalloc_order_trace+0x34/0xe0
[1007383.689534]  [<ffffffff81146546>] __kmalloc+0x186/0x190
[1007383.689541]  [<ffffffff8124263c>] xfs_attrlist_by_handle+0x8c/0x110
[1007383.689544]  [<ffffffff81243487>] xfs_file_ioctl+0x437/0xb60
[1007383.689550]  [<ffffffff810792ef>] ? local_clock+0x4f/0x60
[1007383.689554]  [<ffffffff81094314>] ? lock_release_holdtime.part.21+0x124/0x170
[1007383.689558]  [<ffffffff8106d78e>] ? lg_local_unlock+0x1e/0x60
[1007383.689563]  [<ffffffff81174315>] ? mntput_no_expire+0x45/0x160
[1007383.689567]  [<ffffffff81166ed1>] do_vfs_ioctl+0x91/0x530
[1007383.689571]  [<ffffffff811568f9>] ? ____fput+0x9/0x10
[1007383.689574]  [<ffffffff81167401>] sys_ioctl+0x91/0xb0
[1007383.689579]  [<ffffffff81303afe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[1007383.689584]  [<ffffffff8162c692>] system_call_fastpath+0x16/0x1b

[1007383.689585] Mem-Info:
[1007383.689587] Node 0 Normal per-cpu:
[1007383.689590] CPU    0: hi:  186, btch:  31 usd:   0
[1007383.689592] CPU    1: hi:  186, btch:  31 usd:   0
[1007383.689594] CPU    2: hi:  186, btch:  31 usd:   0
[1007383.689596] CPU    3: hi:  186, btch:  31 usd:   0
[1007383.689597] CPU    4: hi:  186, btch:  31 usd:   0
[1007383.689599] CPU    5: hi:  186, btch:  31 usd:   0
[1007383.689601] CPU    6: hi:  186, btch:  31 usd:   0
[1007383.689603] CPU    7: hi:  186, btch:  31 usd:   0
[1007383.689605] CPU    8: hi:  186, btch:  31 usd:   0
[1007383.689606] CPU    9: hi:  186, btch:  31 usd:   0
[1007383.689608] CPU   10: hi:  186, btch:  31 usd:   0
[1007383.689610] CPU   11: hi:  186, btch:  31 usd:   0
[1007383.689611] Node 1 DMA per-cpu:
[1007383.689613] CPU    0: hi:    0, btch:   1 usd:   0
[1007383.689615] CPU    1: hi:    0, btch:   1 usd:   0
[1007383.689617] CPU    2: hi:    0, btch:   1 usd:   0
[1007383.689618] CPU    3: hi:    0, btch:   1 usd:   0
[1007383.689620] CPU    4: hi:    0, btch:   1 usd:   0
[1007383.689622] CPU    5: hi:    0, btch:   1 usd:   0
[1007383.689624] CPU    6: hi:    0, btch:   1 usd:   0
[1007383.689625] CPU    7: hi:    0, btch:   1 usd:   0
[1007383.689627] CPU    8: hi:    0, btch:   1 usd:   0
[1007383.689629] CPU    9: hi:    0, btch:   1 usd:   0
[1007383.689631] CPU   10: hi:    0, btch:   1 usd:   0
[1007383.689632] CPU   11: hi:    0, btch:   1 usd:   0
[1007383.689633] Node 1 DMA32 per-cpu:
[1007383.689636] CPU    0: hi:  186, btch:  31 usd:   0
[1007383.689638] CPU    1: hi:  186, btch:  31 usd:   0
[1007383.689639] CPU    2: hi:  186, btch:  31 usd:   0
[1007383.689641] CPU    3: hi:  186, btch:  31 usd:   0
[1007383.689643] CPU    4: hi:  186, btch:  31 usd:   0
[1007383.689645] CPU    5: hi:  186, btch:  31 usd:   0
[1007383.689647] CPU    6: hi:  186, btch:  31 usd:   0
[1007383.689648] CPU    7: hi:  186, btch:  31 usd:   0
[1007383.689650] CPU    8: hi:  186, btch:  31 usd:   0
[1007383.689652] CPU    9: hi:  186, btch:  31 usd:   0
[1007383.689653] CPU   10: hi:  186, btch:  31 usd:   0
[1007383.689655] CPU   11: hi:  186, btch:  31 usd:   0
[1007383.689656] Node 1 Normal per-cpu:
[1007383.689659] CPU    0: hi:  186, btch:  31 usd:   0
[1007383.689660] CPU    1: hi:  186, btch:  31 usd:   0
[1007383.689662] CPU    2: hi:  186, btch:  31 usd:   0
[1007383.689664] CPU    3: hi:  186, btch:  31 usd:   0
[1007383.689666] CPU    4: hi:  186, btch:  31 usd:   0
[1007383.689667] CPU    5: hi:  186, btch:  31 usd:   0
[1007383.689669] CPU    6: hi:  186, btch:  31 usd:   0
[1007383.689671] CPU    7: hi:  186, btch:  31 usd:   0
[1007383.689673] CPU    8: hi:  186, btch:  31 usd:   0
[1007383.689674] CPU    9: hi:  186, btch:  31 usd:   0
[1007383.689676] CPU   10: hi:  186, btch:  31 usd:   0
[1007383.689678] CPU   11: hi:  186, btch:  31 usd:   0
[1007383.689682] active_anon:4733571 inactive_anon:579997 isolated_anon:0
[1007383.689682]  active_file:101211 inactive_file:4310054 isolated_file:0
[1007383.689682]  unevictable:6242 dirty:33 writeback:0 unstable:0
[1007383.689682]  free:170040 slab_reclaimable:1674771 slab_unreclaimable:144935
[1007383.689682]  mapped:24541 shmem:985 pagetables:19737 bounce:0
[1007383.689682]  free_cma:0
[1007383.689685] Node 0 Normal free:206820kB min:45064kB low:56328kB
high:67596kB active_anon:14683352kB inactive_anon:997452kB active_file:265924kB
inactive_file:4103448kB unevictable:12748kB isolated(anon):0kB
isolated(file):0kB present:24772608kB managed:24760764kB mlocked:12748kB
dirty:28kB writeback:0kB mapped:74744kB shmem:2360kB slab_reclaimable:2209408kB
slab_unreclaimable:295852kB kernel_stack:3920kB pagetables:49872kB unstable:0kB
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1007383.689692] lowmem_reserve[]: 0 0 0 0
[1007383.689695] Node 1 DMA free:15964kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB
managed:15964kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[1007383.689700] lowmem_reserve[]: 0 3247 24163 24163
[1007383.689703] Node 1 DMA32 free:234416kB min:6048kB low:7560kB high:9072kB
active_anon:617752kB inactive_anon:285044kB active_file:8660kB
inactive_file:2028580kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
present:3325868kB managed:3354316kB mlocked:0kB dirty:0kB writeback:0kB
mapped:632kB shmem:12kB slab_reclaimable:164284kB slab_unreclaimable:6852kB
kernel_stack:328kB pagetables:1572kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1007383.689708] lowmem_reserve[]: 0 0 20916 20916
[1007383.689712] Node 1 Normal free:222960kB min:38964kB low:48704kB
high:58444kB active_anon:3633180kB inactive_anon:1037492kB active_file:130260kB
inactive_file:11108188kB unevictable:12220kB isolated(anon):0kB
isolated(file):0kB present:21417984kB managed:21352576kB mlocked:12220kB
dirty:104kB writeback:0kB mapped:22788kB shmem:1568kB slab_reclaimable:4325392kB
slab_unreclaimable:277036kB kernel_stack:2968kB pagetables:27504kB unstable:0kB
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1007383.689717] lowmem_reserve[]: 0 0 0 0
[1007383.689720] Node 0 Normal: 34182*4kB (UEM) 5980*8kB (UEM) 1121*16kB (UEM)
41*32kB (UEM) 8*64kB (EMR) 1*128kB (R) 0*256kB 1*512kB (R) 1*1024kB (R) 1*2048kB
(R) 0*4096kB = 208040kB
[1007383.689735] Node 1 DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 2*32kB (U) 2*64kB
(U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15964kB
[1007383.689748] Node 1 DMA32: 37794*4kB (UEM) 7663*8kB (UEM) 1333*16kB (UEMR)
21*32kB (M) 0*64kB 1*128kB (R) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 234608kB
[1007383.689759] Node 1 Normal: 15967*4kB (UEM) 3493*8kB (UEM) 7899*16kB (UEM)
73*32kB (UMR) 6*64kB (MR) 3*128kB (MR) 1*256kB (R) 1*512kB (R) 1*1024kB (R)
0*2048kB 0*4096kB = 223092kB
[1007383.689773] 4432031 total pagecache pages
[1007383.689775] 19051 pages in swap cache
[1007383.689777] Swap cache stats: add 100742, delete 81691, find 7476793/7477983
[1007383.689778] Free swap  = 8029584kB
[1007383.689780] Total swap = 8393924kB
[1007383.831121] 12582911 pages RAM
[1007383.831125] 210623 pages reserved
[1007383.831127] 3059864 pages shared
[1007383.831128] 9542960 pages non-shared






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
