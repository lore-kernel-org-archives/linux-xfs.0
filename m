Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E663529DF9
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 16:43:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7375304032
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 14:43:24 -0800 (PST)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172]) by cuda.sgi.com with ESMTP id
	Ew0DVuN8UWqAI1GP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 14:43:23 -0800 (PST)
Received: by mail-ob0-f172.google.com with SMTP id gq1so1068959obb.17
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 14:43:22 -0800 (PST)
Message-ID: <52894685.8080603@gmail.com>
Date: Sun, 17 Nov 2013 17:43:17 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/11] xfs: introduce the free inode btree
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 11/13/2013 09:36 AM, Brian Foster wrote:
> Hi all,
> 
> The free inode btree adds a new inode btree to XFS with the intent to
> track only inode chunks with at least one free inode. Patches 1-3 add
> the necessary support for the new XFS_BTNUM_FINOBT type and introduce a
> read-only v5 superblock flag. Patch 4 updates the transaction
> reservations for inode allocation operations to account for the finobt.
> Patches 5-9 add support to manage the finobt on inode chunk allocation,
> inode allocation, inode free (and chunk deletion) and growfs. Patch 10
> adds support to report finobt status in the fs geometry. Patch 11 adds
> the feature bit to the associated mask. Thoughts, reviews, flames
> appreciated.
> 
> Brian
> 
> v2:
> - Rebase to latest xfs tree (minor shifting around of some header bits).
> - Added "xfs: report finobt status in fs geometry" patch to series.

Very nice rebase!  There might have been a whitespace issue on patch #6 
for kernel and xfsprogs, but it was easy going after that.

I'm halfway through testing 4k finobt CRC filesystems on a 2.2-GB, 2-disk 
md RAID-0, x86 Pentium 4, 512 MB of RAM.  The current nasty setup is 
kernel 3.12.0+, less the 5 most recent AIO commits/merges, and me trying 
to get in the few not-merged Dave Chinner kernel/xfsprogs patches along 
with your patches.

I meant to be done with 4k by now, but generic/224 caused the kernel OOM 
killer to halt testing, much like it does in 256 MB RAM without finobt.  
No problem:  I'll thank Stan in advance for introducing me to the term 
O_PONIES.

The rest of this letter is random junk that hasn't been re-tested, to 
give a flavor of what might lie ahead.  I'm missing a stack trace to the 
effect of "Error 117: offline filesystem operation in progress" as 
something later than xfstests xfs/296 was running.  None of this letter 
needs a reply.

Good luck!

Michael

[NOISE FOLLOWS]

***** I don't know if this one is an xfstests issue or an xfsprogs 
issue.  Something like this also happened in a non-finobt 
`./check -g auto`...

xfs/033	 [failed, exit status 1] - output mismatch (see /var/lib/xfstests/results//xfs/033.out.bad)
    --- tests/xfs/033.out	2013-11-11 13:46:22.367412935 -0500
    +++ /var/lib/xfstests/results//xfs/033.out.bad	2013-11-17 12:57:28.010382465 -0500
    @@ -17,9 +17,10 @@
             - process known inodes and perform inode discovery...
     bad magic number 0x0 on inode INO
     bad version number 0x0 on inode INO
    +inode identifier 0 mismatch on inode INO
     bad magic number 0x0 on inode INO, resetting magic number
     bad version number 0x0 on inode INO, resetting version number
    -imap claims a free inode INO is in use, correcting imap and clearing inode
     ...
     (Run 'diff -u tests/xfs/033.out /var/lib/xfstests/results//xfs/033.out.bad' to see the entire diff)

***** The diff for xfs/033:

19a20
> inode identifier 0 mismatch on inode INO
22c23
< imap claims a free inode INO is in use, correcting imap and clearing inode
---
> inode identifier 0 mismatch on inode INO
33,194c34,37
<         - resetting contents of realtime bitmap and summary inodes
<         - traversing filesystem ...
<         - traversal finished ...
<         - moving disconnected inodes to lost+found ...
< Phase 7 - verify and correct link counts...
< resetting inode INO nlinks from 1 to 2
< done
< Corrupting rt bitmap inode - setting bits to 0
< Wrote X.XXKb (value 0x0)
< Phase 1 - find and verify superblock...
< Phase 2 - using <TYPEOF> log
<         - zero log...
<         - scan filesystem freespace and inode maps...
<         - found root inode chunk
< Phase 3 - for each AG...
<         - scan and clear agi unlinked lists...
<         - process known inodes and perform inode discovery...
< bad magic number 0x0 on inode INO
< bad version number 0x0 on inode INO
< bad magic number 0x0 on inode INO, resetting magic number
< bad version number 0x0 on inode INO, resetting version number
< imap claims a free inode INO is in use, correcting imap and clearing inode
< cleared realtime bitmap inode INO
<         - process newly discovered inodes...
< Phase 4 - check for duplicate blocks...
<         - setting up duplicate extent list...
<         - check for inodes claiming duplicate blocks...
< Phase 5 - rebuild AG headers and trees...
<         - reset superblock...
< Phase 6 - check inode connectivity...
< reinitializing realtime bitmap inode
<         - resetting contents of realtime bitmap and summary inodes
<         - traversing filesystem ...
<         - traversal finished ...
<         - moving disconnected inodes to lost+found ...
< Phase 7 - verify and correct link counts...
< done
< Corrupting rt summary inode - setting bits to 0
< Wrote X.XXKb (value 0x0)
< Phase 1 - find and verify superblock...
< Phase 2 - using <TYPEOF> log
<         - zero log...
<         - scan filesystem freespace and inode maps...
<         - found root inode chunk
< Phase 3 - for each AG...
<         - scan and clear agi unlinked lists...
<         - process known inodes and perform inode discovery...
< bad magic number 0x0 on inode INO
< bad version number 0x0 on inode INO
< bad magic number 0x0 on inode INO, resetting magic number
< bad version number 0x0 on inode INO, resetting version number
< imap claims a free inode INO is in use, correcting imap and clearing inode
< cleared realtime summary inode INO
<         - process newly discovered inodes...
< Phase 4 - check for duplicate blocks...
<         - setting up duplicate extent list...
<         - check for inodes claiming duplicate blocks...
< Phase 5 - rebuild AG headers and trees...
<         - reset superblock...
< Phase 6 - check inode connectivity...
< reinitializing realtime summary inode
<         - resetting contents of realtime bitmap and summary inodes
<         - traversing filesystem ...
<         - traversal finished ...
<         - moving disconnected inodes to lost+found ...
< Phase 7 - verify and correct link counts...
< done
< Corrupting root inode - setting bits to -1
< Wrote X.XXKb (value 0xffffffff)
< Phase 1 - find and verify superblock...
< Phase 2 - using <TYPEOF> log
<         - zero log...
<         - scan filesystem freespace and inode maps...
<         - found root inode chunk
< Phase 3 - for each AG...
<         - scan and clear agi unlinked lists...
<         - process known inodes and perform inode discovery...
< bad magic number 0xffff on inode INO
< bad version number 0xffffffff on inode INO
< bad (negative) size -1 on inode INO
< bad magic number 0xffff on inode INO, resetting magic number
< bad version number 0xffffffff on inode INO, resetting version number
< bad (negative) size -1 on inode INO
< cleared root inode INO
<         - process newly discovered inodes...
< Phase 4 - check for duplicate blocks...
<         - setting up duplicate extent list...
< root inode lost
<         - check for inodes claiming duplicate blocks...
< Phase 5 - rebuild AG headers and trees...
<         - reset superblock...
< Phase 6 - check inode connectivity...
< reinitializing root directory
<         - resetting contents of realtime bitmap and summary inodes
<         - traversing filesystem ...
<         - traversal finished ...
<         - moving disconnected inodes to lost+found ...
< Phase 7 - verify and correct link counts...
< resetting inode INO nlinks from 1 to 2
< done
< Corrupting rt bitmap inode - setting bits to -1
< Wrote X.XXKb (value 0xffffffff)
< Phase 1 - find and verify superblock...
< Phase 2 - using <TYPEOF> log
<         - zero log...
<         - scan filesystem freespace and inode maps...
<         - found root inode chunk
< Phase 3 - for each AG...
<         - scan and clear agi unlinked lists...
<         - process known inodes and perform inode discovery...
< bad magic number 0xffff on inode INO
< bad version number 0xffffffff on inode INO
< bad (negative) size -1 on inode INO
< bad magic number 0xffff on inode INO, resetting magic number
< bad version number 0xffffffff on inode INO, resetting version number
< bad (negative) size -1 on inode INO
< cleared realtime bitmap inode INO
<         - process newly discovered inodes...
< Phase 4 - check for duplicate blocks...
<         - setting up duplicate extent list...
<         - check for inodes claiming duplicate blocks...
< Phase 5 - rebuild AG headers and trees...
<         - reset superblock...
< Phase 6 - check inode connectivity...
< reinitializing realtime bitmap inode
<         - resetting contents of realtime bitmap and summary inodes
<         - traversing filesystem ...
<         - traversal finished ...
<         - moving disconnected inodes to lost+found ...
< Phase 7 - verify and correct link counts...
< done
< Corrupting rt summary inode - setting bits to -1
< Wrote X.XXKb (value 0xffffffff)
< Phase 1 - find and verify superblock...
< Phase 2 - using <TYPEOF> log
<         - zero log...
<         - scan filesystem freespace and inode maps...
<         - found root inode chunk
< Phase 3 - for each AG...
<         - scan and clear agi unlinked lists...
<         - process known inodes and perform inode discovery...
< bad magic number 0xffff on inode INO
< bad version number 0xffffffff on inode INO
< bad (negative) size -1 on inode INO
< bad magic number 0xffff on inode INO, resetting magic number
< bad version number 0xffffffff on inode INO, resetting version number
< bad (negative) size -1 on inode INO
< cleared realtime summary inode INO
<         - process newly discovered inodes...
< Phase 4 - check for duplicate blocks...
<         - setting up duplicate extent list...
<         - check for inodes claiming duplicate blocks...
< Phase 5 - rebuild AG headers and trees...
<         - reset superblock...
< Phase 6 - check inode connectivity...
< reinitializing realtime summary inode
<         - resetting contents of realtime bitmap and summary inodes
<         - traversing filesystem ...
<         - traversal finished ...
<         - moving disconnected inodes to lost+found ...
< Phase 7 - verify and correct link counts...
< done
---
> xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
> 
> fatal error -- could not iget root inode -- error - 117
> _check_xfs_filesystem: filesystem on /dev/md126 is inconsistent (r) (see /var/lib/xfstests/results//xfs/033.full)

***** This is the lone segfault so far:

xfs/291	[12832.846621] XFS (md126): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[12832.846621] Use of these features in this kernel is at your own risk!
[12832.872608] XFS (md126): Mounting Filesystem
[12833.063779] XFS (md126): Ending clean mount
[13153.675046] XFS (md126): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[13153.675046] Use of these features in this kernel is at your own risk!
[13153.694128] XFS (md126): Mounting Filesystem
[13154.105167] XFS (md126): Ending clean mount
[13201.470358] xfs_db[17902]: segfault at 9c157f8 ip 0809b6b0 sp bfe97950 error 4 in xfs_db[8048000+90000]
 [failed, exit status 1] - output mismatch (see /var/lib/xfstests/results//xfs/291.out.bad)
    --- tests/xfs/291.out	2013-11-11 13:46:26.652264785 -0500
    +++ /var/lib/xfstests/results//xfs/291.out.bad	2013-11-17 16:28:05.133832908 -0500
    @@ -1 +1,11 @@
     QA output created by 291
    +xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
    +xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
    +xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
    +xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
    +xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
    +__read_verify: XFS_CORRUPTION_ERROR
     ...
     (Run 'diff -u tests/xfs/291.out /var/lib/xfstests/results//xfs/291.out.bad' to see the entire diff)
[13202.293470] XFS (md127): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[13202.293470] Use of these features in this kernel is at your own risk!
[13202.309944] XFS (md127): Mounting Filesystem
[13202.587663] XFS (md127): Ending clean mount

***** I might not have seen this lockdep splat yet, but this 
is a new merge window.  This splat is repeatable and may be 
independent of finobt.

xfs/078	[87803.635893] 
======================================================
[ INFO: possible circular locking dependency detected ]
3.12.0+ #2 Not tainted
-------------------------------------------------------
xfs_repair/12944 is trying to acquire lock:
 (timekeeper_seq){------}, at: [<c104f843>] __hrtimer_start_range_ns+0xc7/0x35d

but task is already holding lock:
 (hrtimer_bases.lock){-.-.-.}, at: [<c104f7a4>] __hrtimer_start_range_ns+0x28/0x35d

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (hrtimer_bases.lock){-.-.-.}:
       [<c106577c>] lock_acquire+0x7f/0x15e
       [<c162d072>] _raw_spin_lock_irqsave+0x4a/0x7a
       [<c104f7a4>] __hrtimer_start_range_ns+0x28/0x35d
       [<c1055b01>] start_bandwidth_timer+0x60/0x6f
       [<c105b1c2>] enqueue_task_rt+0xd3/0xfd
       [<c10546aa>] enqueue_task+0x45/0x60
       [<c1055813>] __sched_setscheduler+0x243/0x372
       [<c1056a21>] sched_setscheduler+0x17/0x19
       [<c108ae53>] watchdog_enable+0x69/0x7d
       [<c1053063>] smpboot_thread_fn+0x93/0x130
       [<c104c4ab>] kthread+0xb3/0xc7
       [<c162e4b7>] ret_from_kernel_thread+0x1b/0x28

-> #4 (&rt_b->rt_runtime_lock){-.-.-.}:
       [<c106577c>] lock_acquire+0x7f/0x15e
       [<c162cffb>] _raw_spin_lock+0x41/0x6e
       [<c105b1ac>] enqueue_task_rt+0xbd/0xfd
       [<c10546aa>] enqueue_task+0x45/0x60
       [<c1055813>] __sched_setscheduler+0x243/0x372
       [<c1056a21>] sched_setscheduler+0x17/0x19
       [<c108ae53>] watchdog_enable+0x69/0x7d
       [<c1053063>] smpboot_thread_fn+0x93/0x130
       [<c104c4ab>] kthread+0xb3/0xc7
       [<c162e4b7>] ret_from_kernel_thread+0x1b/0x28

-> #3 (&rq->lock){-.-.-.}:
       [<c106577c>] lock_acquire+0x7f/0x15e
       [<c162cffb>] _raw_spin_lock+0x41/0x6e
       [<c10561da>] wake_up_new_task+0x3b/0x147
       [<c102d132>] do_fork+0x116/0x305
       [<c102d34e>] kernel_thread+0x2d/0x33
       [<c161f0b2>] rest_init+0x22/0x128
       [<c19f39da>] start_kernel+0x2df/0x2e5
       [<c19f3378>] i386_start_kernel+0x12e/0x131

-> #2 (&p->pi_lock){-.-.-.}:
       [<c106577c>] lock_acquire+0x7f/0x15e
       [<c162d072>] _raw_spin_lock_irqsave+0x4a/0x7a
       [<c1055e1a>] try_to_wake_up+0x23/0x138
       [<c1055f60>] wake_up_process+0x1f/0x33
       [<c104411c>] start_worker+0x25/0x28
       [<c10451cc>] create_and_start_worker+0x37/0x5d
       [<c1a03b34>] init_workqueues+0xd4/0x2c4
       [<c19f3a99>] do_one_initcall+0xb9/0x153
       [<c19f3b7e>] kernel_init_freeable+0x4b/0x17d
       [<c161f1c8>] kernel_init+0x10/0xf2
       [<c162e4b7>] ret_from_kernel_thread+0x1b/0x28

-> #1 (&(&pool->lock)->rlock){-.-.-.}:
       [<c106577c>] lock_acquire+0x7f/0x15e
       [<c162cffb>] _raw_spin_lock+0x41/0x6e
       [<c104575a>] __queue_work+0x12b/0x393
       [<c1045c26>] queue_work_on+0x2f/0x6a
       [<c104f4b6>] clock_was_set_delayed+0x1d/0x1f
       [<c1075a67>] do_adjtimex+0xf4/0x145
       [<c1030ce0>] SYSC_adjtimex+0x30/0x62
       [<c1030f67>] SyS_adjtimex+0x10/0x12
       [<c162e53f>] sysenter_do_call+0x12/0x36

-> #0 (timekeeper_seq){------}:
       [<c10648b9>] __lock_acquire+0x13a4/0x17ac
       [<c106577c>] lock_acquire+0x7f/0x15e
       [<c1073688>] ktime_get+0x4f/0x169
       [<c104f843>] __hrtimer_start_range_ns+0xc7/0x35d
       [<c104faff>] hrtimer_start_range_ns+0x26/0x2c
       [<c104b17f>] common_timer_set+0xf5/0x164
       [<c104bd58>] SyS_timer_settime+0xbe/0x183
       [<c162dcc8>] syscall_call+0x7/0xb

other info that might help us debug this:

Chain exists of:
  timekeeper_seq --> &rt_b->rt_runtime_lock --> hrtimer_bases.lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(hrtimer_bases.lock);
                               lock(&rt_b->rt_runtime_lock);
                               lock(hrtimer_bases.lock);
  lock(timekeeper_seq);

 *** DEADLOCK ***

2 locks held by xfs_repair/12944:
 #0:  (&(&new_timer->it_lock)->rlock){......}, at: [<c104b292>] __lock_timer+0xa4/0x1af
 #1:  (hrtimer_bases.lock){-.-.-.}, at: [<c104f7a4>] __hrtimer_start_range_ns+0x28/0x35d

stack backtrace:
CPU: 0 PID: 12944 Comm: xfs_repair Not tainted 3.12.0+ #2
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
 c1cb2e70 c1cb2e70 deb01dd8 c162748d deb01df8 c162303c c17a3306 deb01e3c
 deaad0c0 deaad550 deaad550 00000002 deb01e6c c10648b9 deaad528 0000006f
 c106269b deb01e20 c1c8bd08 00000003 00000000 0000000e 00000002 00000001
Call Trace:
 [<c162748d>] dump_stack+0x16/0x18
 [<c162303c>] print_circular_bug+0x1b8/0x1c2
 [<c10648b9>] __lock_acquire+0x13a4/0x17ac
 [<c106269b>] ? trace_hardirqs_off+0xb/0xd
 [<c106577c>] lock_acquire+0x7f/0x15e
 [<c104f843>] ? __hrtimer_start_range_ns+0xc7/0x35d
 [<c1073688>] ktime_get+0x4f/0x169
 [<c104f843>] ? __hrtimer_start_range_ns+0xc7/0x35d
 [<c162d098>] ? _raw_spin_lock_irqsave+0x70/0x7a
 [<c104f7a4>] ? __hrtimer_start_range_ns+0x28/0x35d
 [<c104f843>] __hrtimer_start_range_ns+0xc7/0x35d
 [<c104faff>] hrtimer_start_range_ns+0x26/0x2c
 [<c104b17f>] common_timer_set+0xf5/0x164
 [<c104b08a>] ? __posix_timers_find+0xa7/0xa7
 [<c104bd58>] SyS_timer_settime+0xbe/0x183
 [<c162dcc8>] syscall_call+0x7/0xb



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
