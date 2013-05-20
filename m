Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D49DD7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:07:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E674AC004
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:07:20 -0700 (PDT)
Received: from mail-ee0-f43.google.com (mail-ee0-f43.google.com
	[74.125.83.43]) by cuda.sgi.com with ESMTP id VREhnkyypW7g6Gkl
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 10:07:15 -0700 (PDT)
Received: by mail-ee0-f43.google.com with SMTP id d41so3915226eek.16
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:07:14 -0700 (PDT)
Date: Mon, 20 May 2013 19:07:10 +0200
From: Paolo Pisati <p.pisati@gmail.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130520170710.GA2591@luxor.wired.org>
References: <20130517104529.GA12490@luxor.wired.org>
	<20130519011354.GE6495@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130519011354.GE6495@dastard>
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
Cc: xfs@oss.sgi.com, Paolo Pisati <p.pisati@gmail.com>

On Sun, May 19, 2013 at 11:13:54AM +1000, Dave Chinner wrote:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1176977
> 
> which contains information that everyone looking at the problem
> should know. Also, any progress on testing the backported fix
> mentioned in the bug?

the problem with the 'fix' is that it prevents xfs from erroring out, but
swift-test fails regardless after ~25% of fs usage and i think having a bold
'xfs error' and a stack trace is more useful.
 
> You're testing swift benchmark which is probably a small file
> workload with large attributes attached.  It's a good chance that
> the workload is fragmenting free space because swift is doing bad
> things to allocation patterns.  It's almost certainly exacerbated by
> the tiny filesystem you are using (1.5GB), but you can probably work
> around this problem for now with allocsize=4096.

ok, i repartitioned my disk but i can still reprodue it fairly easily:

df -h:
/dev/sda6       216G  573M  215G   1% /mnt/sdb1

df -i:
/dev/sda6      56451072 235458 56215614    1% /mnt/sdb1

dmesg:
...
[  363.130877] XFS (sda6): Mounting Filesystem
[  363.146708] XFS (sda6): Ending clean mount
[ 3055.520769] alloc_vmap_area: 18 callbacks suppressed
[ 3055.520783] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
[ 3055.520817] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
[ 3055.520845] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
[ 3055.520861] XFS (sda6): xfs_buf_get: failed to map pages
[ 3055.520861]
[ 3055.520882] XFS (sda6): Internal error xfs_trans_cancel at line 1466 of file /build/buildd/linux-3.5.0/fs/xfs/xfs_trans.c.  Caller 0xbf0235e0
[ 3055.520882]
[ 3055.535135] [<c00164cc>] (unwind_backtrace+0x0/0x104) from [<c04ed624>] (dump_stack+0x20/0x24)
[ 3055.535345] [<c04ed624>] (dump_stack+0x20/0x24) from [<bf01091c>] (xfs_error_report+0x60/0x6c [xfs])
[ 3055.535687] [<bf01091c>] (xfs_error_report+0x60/0x6c [xfs]) from [<bf0633f8>] (xfs_trans_cancel+0xfc/0x11c [xfs])
[ 3055.536023] [<bf0633f8>] (xfs_trans_cancel+0xfc/0x11c [xfs]) from [<bf0235e0>] (xfs_create+0x228/0x558 [xfs])
[ 3055.536314] [<bf0235e0>] (xfs_create+0x228/0x558 [xfs]) from [<bf01a7cc>] (xfs_vn_mknod+0x9c/0x180 [xfs])
[ 3055.536589] [<bf01a7cc>] (xfs_vn_mknod+0x9c/0x180 [xfs]) from [<bf01a8f0>] (xfs_vn_create+0x1c/0x20 [xfs])
[ 3055.536741] [<bf01a8f0>] (xfs_vn_create+0x1c/0x20 [xfs]) from [<c01359d4>] (vfs_create+0xb4/0x120)
[ 3055.536760] [<c01359d4>] (vfs_create+0xb4/0x120) from [<c0137c3c>] (do_last+0x860/0x9bc)
[ 3055.536775] [<c0137c3c>] (do_last+0x860/0x9bc) from [<c0137fdc>] (path_openat+0xcc/0x428)
[ 3055.536787] [<c0137fdc>] (path_openat+0xcc/0x428) from [<c0138458>] (do_filp_open+0x3c/0x90)
[ 3055.536805] [<c0138458>] (do_filp_open+0x3c/0x90) from [<c0128248>] (do_sys_open+0xfc/0x1d0)
[ 3055.536817] [<c0128248>] (do_sys_open+0xfc/0x1d0) from [<c0128348>] (sys_open+0x2c/0x30)
[ 3055.536832] [<c0128348>] (sys_open+0x2c/0x30) from [<c000e320>] (ret_fast_syscall+0x0/0x30)
[ 3055.536848] XFS (sda6): xfs_do_force_shutdown(0x8) called from line 1467 of file /build/buildd/linux-3.5.0/fs/xfs/xfs_trans.c.  Return address = 0xbf06340c
[ 3055.537327] XFS (sda6): Corruption of in-memory data detected.  Shutting down filesystem
[ 3055.545439] XFS (sda6): Please umount the filesystem and rectify the problem(s)
[ 3070.301048] XFS (sda6): xfs_log_force: error 5 returned.
[ 3100.381068] XFS (sda6): xfs_log_force: error 5 returned.
[ 3130.461041] XFS (sda6): xfs_log_force: error 5 returned.
[ 3160.541042] XFS (sda6): xfs_log_force: error 5 returned.
[ 3190.621042] XFS (sda6): xfs_log_force: error 5 returned.
[ 3220.701040] XFS (sda6): xfs_log_force: error 5 returned.
[ 3250.781039] XFS (sda6): xfs_log_force: error 5 returned.
[ 3280.861036] XFS (sda6): xfs_log_force: error 5 returned.
[ 3310.941047] XFS (sda6): xfs_log_force: error 5 returned.
[ 3341.021044] XFS (sda6): xfs_log_force: error 5 returned.
[ 3371.101044] XFS (sda6): xfs_log_force: error 5 returned.
[ 3401.181036] XFS (sda6): xfs_log_force: error 5 returned.
[ 3431.261036] XFS (sda6): xfs_log_force: error 5 returned.
[ 3461.341038] XFS (sda6): xfs_log_force: error 5 returned.
[ 3491.421038] XFS (sda6): xfs_log_force: error 5 returned.
[ 3521.501051] XFS (sda6): xfs_log_force: error 5 returned.
[ 3551.581037] XFS (sda6): xfs_log_force: error 5 returned.
[ 3581.661041] XFS (sda6): xfs_log_force: error 5 returned.

> I've got a fix that I'm testing for the underlying cause of the
> problem I'm aware of with this workload, but I'll need more
> information about your storage/filesystem config to confirm it is
> the same root cause first. Can you include the info from here:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

flag@c13:~$ uname -a
Linux c13 3.5.0-30-highbank #51-Ubuntu SMP Tue May 14 22:57:15 UTC 2013 armv7l armv7l armv7l GNU/Linux

lag@c13:~$ xfs_repair -V
xfs_repair version 3.1.7

armhf highbank node, 4 cores, 4GB mem

flag@c13:~$ cat /proc/meminfo
MemTotal:        4137004 kB
MemFree:         2719752 kB
Buffers:           39688 kB
Cached:           580508 kB
SwapCached:            0 kB
Active:           631136 kB
Inactive:         204552 kB
Active(anon):     215520 kB
Inactive(anon):      232 kB
Active(file):     415616 kB
Inactive(file):   204320 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       3408896 kB
HighFree:        2606516 kB
LowTotal:         728108 kB
LowFree:          113236 kB
SwapTotal:       8378364 kB
SwapFree:        8378364 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:        215516 kB
Mapped:             8676 kB
Shmem:               264 kB
Slab:             317000 kB
SReclaimable:     230392 kB
SUnreclaim:        86608 kB
KernelStack:        2192 kB
PageTables:         2284 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    10446864 kB
Committed_AS:    1049624 kB
VmallocTotal:     245760 kB
VmallocUsed:        2360 kB
VmallocChunk:     241428 kB

flag@c13:~$ cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=2059248k,nr_inodes=177400,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,relatime,size=827404k,mode=755 0 0
/dev/disk/by-uuid/6594b183-3198-4dec-a97d-a3f834b98011 / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
none /sys/fs/fuse/connections fusectl rw,relatime 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
none /run/user tmpfs rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
/dev/sda1 /boot ext2 rw,relatime,errors=continue 0 0
/dev/sda6 /mnt/sdb1 xfs rw,noatime,nodiratime,attr2,nobarrier,logbufs=8,noquota 0 0

flag@c13:~$ cat /proc/partitions
major minor  #blocks  name

   8        0  250059096 sda
   8        1     248832 sda1
   8        2   15625000 sda2
   8        3          1 sda3
   8        5    8378369 sda5
   8        6  225804288 sda6

no RAID, no LVM

common sata disk

write cache on (unknown size)

no BBWC AFAIK

flag@c13:~$ xfs_info /mnt/sdb1/
meta-data=/dev/sda6              isize=1024   agcount=4, agsize=14112768 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=56451072, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=27564, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

> 
> As well the freespace info that Jeff asked for?

flag@c13:~$ sudo xfs_db -r "-c freesp -s" /dev/sda6 
   from      to extents  blocks    pct
      1       1     423     423   0.00
      2       3     897    2615   0.01
      4       7     136     915   0.00
      8      15   24833  365797   0.86
8388608 14112768       3 41928421  99.13
total free extents 26292
total free blocks 42298171
average free extent size 1608.78

-- 
bye,
p.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
