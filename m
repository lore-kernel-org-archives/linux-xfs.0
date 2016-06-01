Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC4DB7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:50:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FACF304066
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:50:56 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id AbzU12jmyz7NptXz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:50:52 -0700 (PDT)
Subject: Re: Internal error xfs_trans_cancel
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
Date: Wed, 1 Jun 2016 15:50:45 +0200
MIME-Version: 1.0
In-Reply-To: <20160601071047.GJ12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com


On 06/01/2016 09:10 AM, Dave Chinner wrote:
> On Wed, Jun 01, 2016 at 07:52:31AM +0200, Daniel Wagner wrote:
>> I got the error message below while compiling a kernel 
>> on that system. I can't really say if I did something
>> which made the file system unhappy before the crash.
>>
>>
>> [Jun 1 07:41] XFS (sde1): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x453/0x960 [xfs]
> 
> Anything in the log before this?

Just the usual stuff, as I remember. Sorry, I haven't copied the whole log.
 
>> [  +0.000095] CPU: 22 PID: 8640 Comm: gcc Not tainted 4.7.0-rc1 #16
>> [  +0.000035] Hardware name: Dell Inc. PowerEdge R820/066N7P, BIOS 2.0.20 01/16/2014
>> [  +0.000048]  0000000000000286 00000000c8be6bc3 ffff885fa9473cb0 ffffffff813d146e
>> [  +0.000056]  ffff885fa9ac5ed0 0000000000000001 ffff885fa9473cc8 ffffffffa0213cdc
>> [  +0.000053]  ffffffffa02257b3 ffff885fa9473cf0 ffffffffa022eb36 ffff883faa502d00
>> [  +0.000053] Call Trace:
>> [  +0.000028]  [<ffffffff813d146e>] dump_stack+0x63/0x85
>> [  +0.000069]  [<ffffffffa0213cdc>] xfs_error_report+0x3c/0x40 [xfs]
>> [  +0.000065]  [<ffffffffa02257b3>] ? xfs_rename+0x453/0x960 [xfs]
>> [  +0.000064]  [<ffffffffa022eb36>] xfs_trans_cancel+0xb6/0xe0 [xfs]
>> [  +0.000065]  [<ffffffffa02257b3>] xfs_rename+0x453/0x960 [xfs]
>> [  +0.000062]  [<ffffffffa021fa63>] xfs_vn_rename+0xb3/0xf0 [xfs]
>> [  +0.000040]  [<ffffffff8124f92c>] vfs_rename+0x58c/0x8d0
>> [  +0.000032]  [<ffffffff81253fb1>] SyS_rename+0x371/0x390
>> [  +0.000036]  [<ffffffff817d2032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
>> [  +0.000040] XFS (sde1): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa022eb4f
>> [  +0.027680] XFS (sde1): Corruption of in-memory data detected.  Shutting down filesystem
>> [  +0.000057] XFS (sde1): Please umount the filesystem and rectify the problem(s)
>> [Jun 1 07:42] XFS (sde1): xfs_log_force: error -5 returned.
>> [ +30.081016] XFS (sde1): xfs_log_force: error -5 returned.
> 
> Doesn't normally happen, and there's not a lot to go on here.

Restarted the box and did a couple of kernel builds and
everything was fine.

> Can
> you provide the info listed in the link below so we have some idea
> of what configuration the error occurred on?

Sure, forgot that in the first post.

> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

# uname -r
4.7.0-rc1-00003-g1f55b0d                                                                                                                                                    

# xfs_repair -V
xfs_repair version 4.5.0 

# cat /proc/cpuinfo | grep CPU | wc -l
64

# cat /proc/meminfo 
MemTotal:       528344752 kB
MemFree:        526838036 kB
MemAvailable:   525265612 kB
Buffers:            2716 kB
Cached:           216896 kB
SwapCached:            0 kB
Active:           119924 kB
Inactive:         116552 kB
Active(anon):      17416 kB
Inactive(anon):     1108 kB
Active(file):     102508 kB
Inactive(file):   115444 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:         16972 kB
Mapped:            25288 kB
Shmem:              1616 kB
Slab:             184920 kB
SReclaimable:      60028 kB
SUnreclaim:       124892 kB
KernelStack:       13120 kB
PageTables:         2292 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    264172376 kB
Committed_AS:     270612 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      232256 kB
DirectMap2M:     7061504 kB
DirectMap1G:    531628032 kB

# cat /proc/mounts 
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,size=264153644k,nr_inodes=66038411,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/net_cls,net_prio cgroup rw,nosuid,nodev,noexec,relatime,net_cls,net_prio 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/pids cgroup rw,nosuid,nodev,noexec,relatime,pids 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/sda2 / xfs rw,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=27,pgrp=1,timeout=0,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
tmpfs /tmp tmpfs rw 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
/dev/sdc1 /mnt/sdc1 xfs rw,relatime,attr2,inode64,noquota 0 0
/dev/sda1 /boot ext4 rw,relatime,data=ordered 0 0
/dev/sde2 /mnt/yocto xfs rw,relatime,attr2,inode64,noquota 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
tmpfs /run/user/0 tmpfs rw,nosuid,nodev,relatime,size=52834476k,mode=700 0 0
/dev/sde1 /home xfs rw,relatime,attr2,inode64,noquota 0 0

# cat /proc/partitions 
major minor  #blocks  name

  11        0    1048575 sr0
   8       64  249430016 sde
   8       65  104857600 sde1
   8       66  144571375 sde2
   8       48  142737408 sdd
   8       16  142737408 sdb
   8       32  142737408 sdc
   8       33  142736367 sdc1
   8        0  142737408 sda
   8        1    5120000 sda1
   8        2  104857600 sda2

No RAID
No LVM

HDD (sda, sdb, sdc, sdd):

Manufacturer 	TOSHIBA
Product ID 	MK1401GRRB 

SSD (sde):

Manufacturer	Samsung
Product ID 	Samsung SSD 850
Revision 	1B6Q

# hdparm -I /dev/sde 

/dev/sde:
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0d 00 00 00 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

ATA device, with non-removable media
Standards:
        Likely used: 1
Configuration:
        Logical         max     current
        cylinders       0       0
        heads           0       0
        sectors/track   0       0
        --
        Logical/Physical Sector size:           512 bytes
        device size with M = 1024*1024:           0 MBytes
        device size with M = 1000*1000:           0 MBytes 
        cache/buffer size  = unknown
Capabilities:
        IORDY not likely
        Cannot perform double-word IO
        R/W multiple sector transfer: not supported
        DMA: not supported
        PIO: pio0 

# xfs_info /dev/sde1
meta-data=/dev/sde1              isize=256    agcount=4, agsize=6553600 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0




> You didn't run out of space or something unusual like that? 

It should have enough space for building the kernel. I haven't
expierenced any problems with that disk or partition in the
last half year. It's my test box, so it gets exposed to
many -rc kernels and test patches. I've never seen any
problems in xfs so far.

Filesystem      Size  Used Avail Use% Mounted on
/dev/sde1       100G   72G   29G  72% /home

> Does 'xfs_repair -n <dev>' report any errors?

# xfs_repair -n /dev/sde1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...                                                                                                                                                                                                                                          
        - scan (but don't clear) agi unlinked lists...                                                                                                                                                                                                            
        - process known inodes and perform inode discovery...                                                                                                                                                                                                     
        - agno = 0                                                                                                                                                                                                                                                
        - agno = 1                                                                                                                                                                                                                                                
        - agno = 2                                                                                                                                                                                                                                                
        - agno = 3                                                                                                                                                                                                                                                
        - process newly discovered inodes...                                                                                                                                                                                                                      
Phase 4 - check for duplicate blocks...                                                                                                                                                                                                                           
        - setting up duplicate extent list...                                                                                                                                                                                                                     
        - check for inodes claiming duplicate blocks...                                                                                                                                                                                                           
        - agno = 0                                                                                                                                                                                                                                                
        - agno = 3                                                                                                                                                                                                                                                
        - agno = 2                                                                                                                                                                                                                                                
        - agno = 1                                                                                                                                                                                                                                                
No modify flag set, skipping phase 5                                                                                                                                                                                                                              
Phase 6 - check inode connectivity...                                                                                                                                                                                                                             
        - traversing filesystem ...                                                                                                                                                                                                                               
        - traversal finished ...                                                                                                                                                                                                                                  
        - moving disconnected inodes to lost+found ...                                                                                                                                                                                                            
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

cheers,
daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
