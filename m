Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 756507F3F
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 22:08:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38DE9304032
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 20:08:12 -0700 (PDT)
Received: from mx0b-00153101.pphosted.com (mx0b-00153101.pphosted.com
	[208.86.201.240]) by cuda.sgi.com with ESMTP id
	B70f0SayetSz5Mvd (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 20:08:08 -0700 (PDT)
From: "Rhorer, Leslie" <Leslie.Rhorer@Level3.com>
Subject: RE: xfs_repair fails
Date: Fri, 15 May 2015 03:08:05 +0000
Message-ID: <D42CEF46A796364580AFE375880EF73F01AD63D1ED@SRVMSXMBDEN2.ad.twtelecom.com>
References: <D42CEF46A796364580AFE375880EF73F01AD63BE36@SRVMSXMBDEN2.ad.twtelecom.com>
	<20150514104341.GA15457@bfoster.bfoster>
In-Reply-To: <20150514104341.GA15457@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, "Rhorer, Leslie" <Leslie.Rhorer@Level3.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

kernel 3.16-2-amd64
xfs_repair  3.2.1
CPU cores 8

/proc/meminfo
MemTotal:        8095964 kB
MemFree:         6721580 kB
MemAvailable:    7482556 kB
Buffers:          265500 kB
Cached:           673888 kB
SwapCached:            0 kB
Active:           666416 kB
Inactive:         387348 kB
Active(anon):     162316 kB
Inactive(anon):    82208 kB
Active(file):     504100 kB
Inactive(file):   305140 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      12623740 kB
SwapFree:       12623740 kB
Dirty:               100 kB
Writeback:             0 kB
AnonPages:        114440 kB
Mapped:            91324 kB
Shmem:            130152 kB
Slab:             242268 kB
SReclaimable:     205152 kB
SUnreclaim:        37116 kB
KernelStack:        4224 kB
PageTables:         9840 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    16671720 kB
Committed_AS:     899516 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      338236 kB
VmallocChunk:   34359397372 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       78420 kB
DirectMap2M:     4014080 kB
DirectMap1G:     4194304 kB

/proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=1001629,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,relatime,size=1619196k,mode=755 0 0
/dev/disk/by-uuid/8ddef98a-550b-4d5c-a044-4aa4c7638b31 / ext4 rw,noatime,errors=remount-ro,data=ordered 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
tmpfs /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls,net_prio cgroup rw,nosuid,nodev,noexec,relatime,net_cls,net_prio 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=25,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
tmpfs /var/www/vidmgr/artwork tmpfs rw,relatime,size=16384k 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
tmpfs /run/user tmpfs rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
/dev/md1 /boot ext2 ro,relatime 0 0
rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
Backup:/Backup /Backup nfs rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,mountport=55068,mountproto=tcp,local_lock=none,addr=192.168.1.51 0 0
Backup:/var/www /var/www/backup nfs rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,mountport=55068,mountproto=tcp,local_lock=none,addr=192.168.1.51 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0

/proc/partitions
major minor  #blocks  name

   8       80  125034840 sdf
   8       81      96256 sdf1
   8       82  112305152 sdf2
   8       83   12632064 sdf3
   8       96  125034840 sdg
   8       97      96256 sdg1
   8       98  112305152 sdg2
   8       99   12632064 sdg3
   8      112 4883770584 sdh
   8        0 3907018584 sda
   8       16 4883770584 sdb
   8       32 3907018584 sdc
   8       48 3907018584 sdd
   8       64 3907018584 sde
   9        1      96192 md1
   9        3   12623744 md3
   9        2  112239488 md2
   9        0 23441319936 md0
  11        0    1048575 sr0

mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Fri Oct  3 20:06:55 2014
     Raid Level : raid6
     Array Size : 23441319936 (22355.39 GiB 24003.91 GB)
  Used Dev Size : 3906886656 (3725.90 GiB 4000.65 GB)
   Raid Devices : 8
  Total Devices : 6
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed May 13 22:29:10 2015
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 1024K

           Name : RAID-Server:0  (local to host RAID-Server)
           UUID : d26e92db:8bd207bb:db9bec69:4117ed57
         Events : 503477

    Number   Major   Minor   RaidDevice State
      10       8      112        0      active sync   /dev/sdh
       1       8        0        1      active sync   /dev/sda
       8       8       16        2      active sync   /dev/sdb
       6       0        0        6      removed
       8       0        0        8      removed
       5       8       32        5      active sync   /dev/sdc
       6       8       48        6      active sync   /dev/sdd
       7       8       64        7      active sync   /dev/sde

No LVM
8 x 4T SATA hard drives, various make and model

dmesg | grep -i xfs
[  396.231175] xfs_repair[1951]: segfault at d0 ip 00007f63b651d6c4 sp 00007f63b5991ca8 error 6 in libc-2.19.so[7f63b6498000+19f000]
[ 8444.084733] xfs_repair[9236]: segfault at d0 ip 00007fbe7c8356c4 sp 00007fbe79ca5ca8 error 6 in libc-2.19.so[7fbe7c7b0000+19f000]

Mount hangs if attempted

The XFS meta dump0 can be found at http://fletchergeek.com/images/metaxfs.gz

RAID-Server:/var/log# xfs_repair -v /dev/md0
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
        - block cache size set to 395032 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 8 tail block 8
... <after a few minutes>
        - scan filesystem freespace and inode maps...
agi unlinked bucket 38 is 163000358 in ag 31 (inode=133306986534)
zeroing unused portion of secondary superblock (AG #5)
Segmentation fault

-----Original Message-----
From: Brian Foster [mailto:bfoster@redhat.com]
Sent: Thursday, May 14, 2015 5:44 AM
To: Rhorer, Leslie
Cc: xfs@oss.sgi.com
Subject: Re: xfs_repair fails

On Thu, May 14, 2015 at 04:17:17AM +0000, Rhorer, Leslie wrote:
> I have an XFS filesystem built on a 24T RAID6 Array under Debian Jessie Linux.  The kernel is 3.16-2-amd64, and the xfs_repair version is 3.2.1.  The file system has some inconsistencies, but every time I try to run xfs_repair, it segfaults.  What should I do?
>

Include as much information as you can about the filesystem, storage and
problem:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

For a repair crash, the full output of the repair is a good start. Also, an xfs_metadump of the fs is probably the most effective tool to help us try and reproduce the problem, if you have somewhere you can post one.

Brian

>
>
> -------------
>
> The content contained in this electronic message is not intended to constitute formation of a contract binding Level3. Level3 will be contractually bound only upon execution, by an authorized officer, of a contract including agreed terms and conditions or by express application of its tariffs. This message is intended only for the use of the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, or the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message is strictly prohibited. If you have received this communication in error, please notify us immediately by replying to the sender of this E-Mail or by telephone.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-------------



The content contained in this electronic message is not intended to constitute formation of a contract binding Level3. Level3 will be contractually bound only upon execution, by an authorized officer, of a contract including agreed terms and conditions or by express application of its tariffs. This message is intended only for the use of the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, or the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message is strictly prohibited. If you have received this communication in error, please notify us immediately by replying to the sender of this E-Mail or by telephone.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
