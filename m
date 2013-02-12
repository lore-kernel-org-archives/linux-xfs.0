Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A52CB7F82
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 00:20:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D44BAC003
	for <linux-xfs@oss.sgi.com>; Mon, 11 Feb 2013 22:19:56 -0800 (PST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id nj2OePVdwNpkhp6i (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 11 Feb 2013 22:19:54 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1U59Do-0006hC-HP
	for linux-xfs@oss.sgi.com; Tue, 12 Feb 2013 07:20:04 +0100
Received: from c-76-103-146-43.hsd1.ca.comcast.net ([76.103.146.43])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 07:20:04 +0100
Received: from norman.cheung by c-76-103-146-43.hsd1.ca.comcast.net with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 07:20:04 +0100
From: Norman Cheung <norman.cheung@kla-tencor.com>
Subject: Hung in D state during fclose
Date: Tue, 12 Feb 2013 06:17:04 +0000 (UTC)
Message-ID: <loom.20130212T071115-446@post.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

I am not sure if this forum is the same as xfs@oss.sgi.com, if so, my apology 
for double posting.  I appreciate in sight or work around on this.

Every 3 - 4 days, my application will hang in D state at file close.  And 
shortly after that flush (from a different partition) is locked in D state 
also.  

My application runs continuously, 5 threads are writing data at a rate of 
1.5M/sec to 5 different XFS partitions.  Each of these partitions is a 2 disk 
RAID 0. In addition, I have other threads consuming 100% CPU at all time, and 
most of these threads are tied to its own CPU.

There are 5 data writing threads are also set to run in specific CPU (one CPU  
per  thread), with priority set to high (-2).  The data writing pattern is: 
each disk writing thread will write a file  1.5 Gig. Then the thread will 
pause for about 3 minutes. Hence we have 5 files of 1.5Gig each after one 
processing cycle.  And we keep 5 sets and delete the older ones.

After about 300 - 800 cycle, one or two of these disk writing threads will go 
into D state.  And within a second flush of another partition will show up in 
D state.  then after 15 minutes of no activities, the parent task will lower 
the priority of all threads (to noraml 20) and abort the threads.  In all 
cases, lowering the priority will get threads out of D states.  I have also 
tried running the disk writing threads with normal priority (20).  Same 
hangs.  Also the fclose of all 5 files to 5 different partitions happens 
around the same time.

Thanks in advance,

Norman 


Below is the sysrq for the 2 offending threads.

1. the disk writing thread hung in fclose


Tigris_IMC.exe  D 0000000000000000     0  4197   4100 0x00000000
ffff881f3db921c0 0000000000000086 0000000000000000 ffff881f42eb8b80
ffff880861419fd8 ffff880861419fd8 ffff880861419fd8 ffff881f3db921c0
0000000000080000 0000000000000000 00000000000401e0 00000000061805c1 Call Trace:
[<ffffffff810d89ed>] ? zone_statistics+0x9d/0xa0 [<ffffffffa0402682>] ? 
xfs_iomap_write_delay+0x172/0x2b0 [xfs] [<ffffffff813c7e35>] ? 
rwsem_down_failed_common+0xc5/0x150
[<ffffffff811f32a3>] ? call_rwsem_down_write_failed+0x13/0x20
[<ffffffff813c74ec>] ? down_write+0x1c/0x1d [<ffffffffa03fba8e>] ? 
xfs_ilock+0x7e/0xa0 [xfs] [<ffffffffa041b64b>] ? __xfs_get_blocks+0x1db/0x3d0 
[xfs] [<ffffffff81103340>] ? kmem_cache_alloc+0x100/0x130 
[<ffffffff8113fa2e>] ? alloc_page_buffers+0x6e/0xe0 [<ffffffff81141cdf>] ? 
__block_write_begin+0x1cf/0x4d0 [<ffffffffa041b850>] ? 
xfs_get_blocks_direct+0x10/0x10 [xfs] [<ffffffffa041b850>] ? 
xfs_get_blocks_direct+0x10/0x10 [xfs] [<ffffffff8114226b>] ? 
block_write_begin+0x4b/0xa0 [<ffffffffa041b8fb>] ? 
xfs_vm_write_begin+0x3b/0x70 [xfs] [<ffffffff810c0258>] ? 
generic_file_buffered_write+0xf8/0x250
[<ffffffffa04207b5>] ? xfs_file_buffered_aio_write+0xc5/0x130 [xfs] 
[<ffffffffa042099c>] ? xfs_file_aio_write+0x17c/0x2a0 [xfs] 
[<ffffffff81115b28>] ? do_sync_write+0xb8/0xf0 [<ffffffff8119daa4>] ? 
security_file_permission+0x24/0xc0
[<ffffffff8111630a>] ? vfs_write+0xaa/0x190 [<ffffffff81116657>] ? 
sys_write+0x47/0x90 [<ffffffff813ce412>] ? system_call_fastpath+0x16/0x1b

2. flush from another partition

flush-8:48      D 0000000000000000     0  4217      2 0x00000000
ffff883fc053f580 0000000000000046 ffff881f40f348f0 ffff881f40e2aa80
ffff883fabb83fd8 ffff883fabb83fd8 ffff883fabb83fd8 ffff883fc053f580
ffff883fc27654c0 ffff881f40dfc040 0000000000000001 ffffffff810656f9 Call Trace:
[<ffffffff810656f9>] ? __queue_work+0xc9/0x390 [<ffffffff811e3e3f>] ? 
cfq_insert_request+0xaf/0x4f0 [<ffffffff81065a06>] ? queue_work_on+0x16/0x20 
[<ffffffff813c69cd>] ? schedule_timeout+0x1dd/0x240 [<ffffffffa041a762>] ? 
kmem_zone_zalloc+0x32/0x50 [xfs] [<ffffffff813c7559>] ? __down+0x6c/0x99 
[<ffffffff81070377>] ? down+0x37/0x40 [<ffffffffa041d59d>] ? 
xfs_buf_lock+0x1d/0x40 [xfs] [<ffffffffa041d6a3>] ? _xfs_buf_find+0xe3/0x210 
[xfs] [<ffffffffa041dcb4>] ? xfs_buf_get+0x64/0x150 [xfs] 
[<ffffffffa041dfb2>] ? xfs_buf_read+0x12/0xa0 [xfs] [<ffffffffa04151af>] ? 
xfs_trans_read_buf+0x1bf/0x2f0 [xfs] [<ffffffffa03d06c0>] ? 
xfs_read_agf+0x60/0x1b0 [xfs] [<ffffffffa03cf3b7>] ? 
xfs_alloc_update+0x17/0x20 [xfs] [<ffffffffa03d0841>] ? 
xfs_alloc_read_agf+0x31/0xd0 [xfs] [<ffffffffa03d2083>] ? 
xfs_alloc_fix_freelist+0x433/0x4a0 [xfs] [<ffffffff810d89ed>] ? 
zone_statistics+0x9d/0xa0 [<ffffffffa03d23a4>] ? xfs_alloc_vextent+0x184/0x4a0 
[xfs] [<ffffffffa03dc348>] ? xfs_bmap_btalloc+0x2d8/0x6d0 [xfs] 
[<ffffffffa03e0efd>] ? xfs_bmapi+0x9bd/0x11a0 [xfs] [<ffffffffa03d9bbc>] ? 
xfs_bmap_search_multi_extents+0xac/0x120 [xfs] [<ffffffffa040293c>] ? 
xfs_iomap_write_allocate+0x17c/0x330 [xfs] [<ffffffffa041b20f>] ? 
xfs_map_blocks+0x19f/0x1b0 [xfs] [<ffffffffa041c20e>] ? 
xfs_vm_writepage+0x19e/0x470 [xfs] [<ffffffff810c97ba>] ? __writepage+0xa/0x30 
[<ffffffff810c9c4d>] ? write_cache_pages+0x1cd/0x3d0 [<ffffffff810c97b0>] ? 
bdi_set_max_ratio+0x90/0x90 [<ffffffff810c9e93>] ? 
generic_writepages+0x43/0x70 [<ffffffff81139330>] ? 
writeback_single_inode+0x160/0x300
[<ffffffff811397d4>] ? writeback_sb_inodes+0x104/0x1a0 [<ffffffff81139cfd>] ? 
writeback_inodes_wb+0x8d/0x140 [<ffffffff8113a05b>] ? wb_writeback+0x2ab/0x310 
[<ffffffff813cedee>] ? apic_timer_interrupt+0xe/0x20 [<ffffffff8113a10e>] ? 
wb_check_old_data_flush+0x4e/0xa0 [<ffffffff8113a28b>] ? 
wb_do_writeback+0x12b/0x160 [<ffffffff8113a332>] ? 
bdi_writeback_thread+0x72/0x150 [<ffffffff8113a2c0>] ? 
wb_do_writeback+0x160/0x160 [<ffffffff8106b06e>] ? kthread+0x7e/0x90 
[<ffffffff813cf544>] ? kernel_thread_helper+0x4/0x10 [<ffffffff8106aff0>] ? 
kthread_worker_fn+0x1a0/0x1a0 [<ffffffff813cf540>] ? gs_change+0x13/0x13


kernel version 3.0.13-0.27
    
xfsprogs version xfs_repair version 3.1.6

number of CPUs  32

 xfs_info /fastraid2
meta-data=/dev/sdd1              isize=256    agcount=4, agsize=17822144 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=71288576, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=34808, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


    contents of /proc/meminfo
cat /proc/meminfo
MemTotal:       262429860 kB
MemFree:        146893200 kB
Buffers:           38600 kB
Cached:           336388 kB
SwapCached:            0 kB
Active:          4601364 kB
Inactive:         277852 kB
Active(anon):    4504236 kB
Inactive(anon):     9524 kB
Active(file):      97128 kB
Inactive(file):   268328 kB
Unevictable:    107520004 kB
Mlocked:          212048 kB
SwapTotal:       1051644 kB
SwapFree:        1051644 kB
Dirty:               140 kB
Writeback:             0 kB
AnonPages:      112024272 kB
Mapped:          2031420 kB
Shmem:              9528 kB
Slab:             123444 kB
SReclaimable:      24088 kB
SUnreclaim:        99356 kB
KernelStack:        3728 kB
PageTables:       229284 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    260857204 kB
Committed_AS:   112752960 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      712612 kB
VmallocChunk:   34224802044 kB
HardwareCorrupted:     0 kB
AnonHugePages:  111861760 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      133788 kB
DirectMap2M:     7178240 kB
DirectMap1G:    261095424 kB


    contents of /proc/mounts

cat /proc/mounts
rootfs / rootfs rw 0 0
udev /dev tmpfs rw,relatime,nr_inodes=0,mode=755 0 0 tmpfs /dev/shm tmpfs 
rw,relatime 0 0
/dev/sde3 / reiserfs rw,relatime,acl,user_xattr 0 0 proc /proc proc 
rw,relatime 0 0 sysfs /sys sysfs rw,relatime 0 0 devpts /dev/pts devpts 
rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
/dev/sde1 /boot reiserfs rw,relatime,acl,user_xattr 0 0 
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0 
debugfs /sys/kernel/debug debugfs rw,relatime 0 0 nfsd /proc/fs/nfsd nfsd 
rw,relatime 0 0 rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 
0 //10.34.3.247/IMCRootFolder /home/klac/mount_path_Tool cifs 
rw,relatime,sec=ntlm,unc=\\10.34.3.247
\IMCRootFolder,username=KTMfg,uid=1000,forceuid,gid=100,forcegid,addr=10.34.3.2
47,file_mode=0755,dir_mode=0755,nounix,rsize=16384,wsize=131007,actimeo=1 0 0
/dev/sda1 /edge xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0
/dev/sdb1 /fastraid0 xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0
/dev/sdc1 /fastraid1 xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0
/dev/sdd1 /fastraid2 xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0
/dev/sdf1 /fastraid3 xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0
/dev/sdg1 /fastraid4 xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0
/dev/sdh1 /fastraid5 xfs 
rw,noatime,nodiratime,attr2,delaylog,largeio,nobarrier,logbufs=8,logbsize=256k,
noquota 0 0


    contents of /proc/partitions
 cat /proc/partitions
major minor  #blocks  name

   8       16  285155328 sdb
   8       17  285154304 sdb1
   8       32  285155328 sdc
   8       33  285154304 sdc1
   8       48  285155328 sdd
   8       49  285154304 sdd1
   8       80  285671424 sdf
   8       81  285659136 sdf1
   8       64  124485632 sde
   8       65    1051648 sde1
   8       66    1051648 sde2
   8       67  122381312 sde3
   8       96  285671424 sdg
   8       97  285659136 sdg1
   8      112  285671424 sdh
   8      113  285659136 sdh1
   8        0  142577664 sda
   8        1  142576640 sda1


    RAID layout (hardware and/or software) Hardware RAID 0 , 2 disks per 
RAID.  
    LVM configuration

fdisk -l

Disk /dev/sdb: 292.0 GB, 291999055872 bytes
255 heads, 63 sectors/track, 35500 cylinders, total 570310656 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x00073b0b

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048   570310655   285154304   83  Linux

Disk /dev/sdc: 292.0 GB, 291999055872 bytes
255 heads, 63 sectors/track, 35500 cylinders, total 570310656 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x000d3eba

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048   570310655   285154304   83  Linux

Disk /dev/sdd: 292.0 GB, 291999055872 bytes
255 heads, 63 sectors/track, 35500 cylinders, total 570310656 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x0003e548

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048   570310655   285154304   83  Linux

Disk /dev/sdf: 292.5 GB, 292527538176 bytes
255 heads, 63 sectors/track, 35564 cylinders, total 571342848 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x0009caf0

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1            2048   571320319   285659136   83  Linux

Disk /dev/sde: 127.5 GB, 127473287168 bytes
255 heads, 63 sectors/track, 15497 cylinders, total 248971264 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x674cfaee

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1   *        2048     2105343     1051648   83  Linux
/dev/sde2         2105344     4208639     1051648   82  Linux swap / Solaris
/dev/sde3         4208640   248971263   122381312   83  Linux

Disk /dev/sdg: 292.5 GB, 292527538176 bytes
255 heads, 63 sectors/track, 35564 cylinders, total 571342848 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x0000a1d4

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1            2048   571320319   285659136   83  Linux

Disk /dev/sdh: 292.5 GB, 292527538176 bytes
255 heads, 63 sectors/track, 35564 cylinders, total 571342848 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x0006b7ff

   Device Boot      Start         End      Blocks   Id  System
/dev/sdh1            2048   571320319   285659136   83  Linux

Disk /dev/sda: 146.0 GB, 145999527936 bytes
255 heads, 63 sectors/track, 17750 cylinders, total 285155328 sectors Units = 
sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512 bytes / 512 
bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk identifier: 
0x000f1568

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048   285155327   142576640   83  Linux

 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
