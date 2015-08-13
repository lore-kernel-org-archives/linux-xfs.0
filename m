Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F9807F54
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 19:44:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0DE78F804B
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 17:44:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0MsQAQpMuFITDVKB for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 17:44:43 -0700 (PDT)
Date: Thu, 13 Aug 2015 10:44:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/04[89] fail on XFS due to change in writeback code
	[4.2-rc1 regression]
Message-ID: <20150813004435.GN3902@dastard>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: tj@kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

[cc linux-fsdevel because it looks like a sync regression in the
generic writeback code.  Also, not trimming away original email so
people can read it in full. ]

On Wed, Aug 12, 2015 at 06:12:04PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I've been seeing generic/04[89] fails on XFS since 4.2-rc1 from time to
> time, but the failure isn't reproduced on every test host. Recently I
> finally got a host that could reproduce the failure reliably.
> 
> It's a regression since 4.1 kernel based on my tests, 4.1 kernel passed
> the tests and the failures showed up starting from 4.2-rc1.

I've seen this failure twice on one of my 1p/1GB RAM VMs in the past
couple of weeks running 4.2-rc4 and 4.2-rc6, but I haven't been able
to reproduce it reliably (2 failures in ~50 runs on the VM) so
haven't been able to track down the cause.  I even thought yesterday
I should ask and see if anyone else is seeing this test fail
occasionally, but then shit happened around here....

It might be a couple of days before I really get a chance to dig
into this, so it might be best if Tejun can look into it first.

Cheers,

Dave.

> What xfstests generic/04[89] test is
> 
> [root@dhcp-66-86-11 xfstests]# ./lsqa.pl tests/generic/04[89]
> FSQA Test No. 048
> 
> Test for NULL files problem
> test inode size is on disk after sync
> 
> --------------------------------------------------
> FSQA Test No. 049
> 
> Test for NULL files problem
> test inode size is on disk after sync - expose log replay bug
> 
> --------------------------------------------------
> 
> And the failure is like (test files have zero size)
> 
> root@dhcp-66-86-11 xfstests]# ./check generic/048
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.2.0-rc5
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda6
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda6 /mnt/testarea/scratch
> 
> generic/048 28s ... - output mismatch (see /root/xfstests/results//generic/048.out.bad)
>     --- tests/generic/048.out   2015-07-16 17:28:15.800000000 +0800
>     +++ /root/xfstests/results//generic/048.out.bad     2015-08-12 18:04:52.923000000 +0800
>     @@ -1 +1,32 @@
>      QA output created by 048
>     +file /mnt/testarea/scratch/969 has incorrect size - sync failed
>     +file /mnt/testarea/scratch/970 has incorrect size - sync failed
>     +file /mnt/testarea/scratch/971 has incorrect size - sync failed
>     +file /mnt/testarea/scratch/972 has incorrect size - sync failed
>     +file /mnt/testarea/scratch/973 has incorrect size - sync failed
>     +file /mnt/testarea/scratch/974 has incorrect size - sync failed
>     ...
> 
> 
> And I bisected to the following commit
> 
> commit e79729123f6392b36450113c6c52074b7d389c85
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri May 22 17:13:48 2015 -0400
> 
>     writeback: don't issue wb_writeback_work if clean
>     
>     There are several places in fs/fs-writeback.c which queues
>     wb_writeback_work without checking whether the target wb
>     (bdi_writeback) has dirty inodes or not.  The only thing
>     wb_writeback_work does is writing back the dirty inodes for the target
>     wb and queueing a work item for a clean wb is essentially noop.  There
>     are some side effects such as bandwidth stats being updated and
>     triggering tracepoints but these don't affect the operation in any
>     meaningful way.
>     
>     This patch makes all writeback_inodes_sb_nr() and sync_inodes_sb()
>     skip wb_queue_work() if the target bdi is clean.  Also, it moves
>     dirtiness check from wakeup_flusher_threads() to
>     __wb_start_writeback() so that all its callers benefit from the check.
>     
>     While the overhead incurred by scheduling a noop work isn't currently
>     significant, the overhead may be higher with cgroup writeback support
>     as we may end up issuing noop work items to a lot of clean wb's.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Jens Axboe <axboe@kernel.dk>
>     Cc: Jan Kara <jack@suse.cz>
>     Signed-off-by: Jens Axboe <axboe@fb.com>
> 
> 
> Attachments are my xfstests config file and host info requested by
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> If you need more info please let me know.
> 
> Thanks,
> Eryu

> It's a RHEL7 kvm guest running on RHEL6.6 with 8G mem and 4 vcpus.
> 
> The disk configuration in guest xml is
> 
> <disk type='file' device='disk'>
>       <driver name='qemu' type='qcow2' cache='none'/>
>       <source file='/home/osimage/rhel7.img'/>
>       <target dev='hda' bus='ide'/>
>       <alias name='ide0-0-0'/>
>       <address type='drive' controller='0' bus='0' target='0' unit='0'/>
> </disk>
> 
> [root@dhcp-66-86-11 ~]# grep -c proc /proc/cpuinfo
> 4
> [root@dhcp-66-86-11 ~]# cat /proc/meminfo
> MemTotal:        7912932 kB
> MemFree:         7547480 kB
> MemAvailable:    7599440 kB
> Buffers:             944 kB
> Cached:           219292 kB
> SwapCached:            0 kB
> Active:           170072 kB
> Inactive:         106352 kB
> Active(anon):      56476 kB
> Inactive(anon):     8384 kB
> Active(file):     113596 kB
> Inactive(file):    97968 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       8257532 kB
> SwapFree:        8257532 kB
> Dirty:             42556 kB
> Writeback:             0 kB
> AnonPages:         56020 kB
> Mapped:            33008 kB
> Shmem:              8552 kB
> Slab:              42520 kB
> SReclaimable:      18648 kB
> SUnreclaim:        23872 kB
> KernelStack:        2336 kB
> PageTables:         3280 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    12213996 kB
> Committed_AS:     260636 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:       26336 kB
> VmallocChunk:   34359623680 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:     12288 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:       69620 kB
> DirectMap2M:     8318976 kB
> [root@dhcp-66-86-11 ~]# cat /proc/mounts
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
> devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=3943408k,nr_inodes=985852,mode=755 0 0
> securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
> tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
> devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
> tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
> tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
> cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
> pstore /sys/fs/pstore pstore rw,seclabel,nosuid,nodev,noexec,relatime 0 0
> cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
> cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
> cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
> cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
> cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
> cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
> cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
> cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
> cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
> configfs /sys/kernel/config configfs rw,relatime 0 0
> /dev/sda3 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
> systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=34,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
> debugfs /sys/kernel/debug debugfs rw,seclabel,relatime 0 0
> hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
> mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
> /dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> /dev/sda6 /mnt/testarea/scratch xfs rw,context=system_u:object_r:nfs_t:s0,relatime,attr2,inode64,noquota 0 0
> /dev/sda5 /mnt/testarea/test xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> [root@dhcp-66-86-11 ~]# cat /proc/partitions
> major minor  #blocks  name
> 
>    8        0  314572800 sda
>    8        1     512000 sda1
>    8        2    8257536 sda2
>    8        3   52428800 sda3
>    8        4          1 sda4
>    8        5   15728640 sda5
>    8        6   15728640 sda6
>    8        7   15728640 sda7
>    8        8   15728640 sda8
>    8        9   15728640 sda9
>    8       10   15728640 sda10
>    8       11   15728640 sda11
>    8       16  104857600 sdb
>    8       17  104856576 sdb1
> [root@dhcp-66-86-11 ~]# lvs
> [root@dhcp-66-86-11 ~]#

> TEST_DEV=/dev/sda5
> TEST_DIR=/mnt/testarea/test				# mount point of TEST PARTITION
> SCRATCH_MNT=/mnt/testarea/scratch			# mount point for SCRATCH PARTITION
> SCRATCH_DEV=/dev/sda6

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
