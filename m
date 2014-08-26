Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C028C7F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 02:54:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC65D304032
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 00:54:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PofId8CP0LHWYhqS for <xfs@oss.sgi.com>;
	Tue, 26 Aug 2014 00:53:51 -0700 (PDT)
Date: Tue, 26 Aug 2014 17:53:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140826075345.GJ20518@dastard>
References: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 26, 2014 at 01:18:50AM -0500, Stan Hoeppner wrote:
> Had some controller issues but believe we had those ironed out before this
> recent breakage.  I had reformatted both 48TB LUNs on this test box with -f
> and defaults, and fired up the test app again.  Throughput was fantastic
> with no dropped application buffers for ~30 minutes, and IO times were 1.x
> ms max, suggesting all the writes were acked by controller cache.  The app
> was running perfectly.  Then it hanged and spit out an internal error msg: 
> 
> 
> Failed to reopen file /mnt/VOL1/sg-04/str-0015/f-0000000005
> 
> I have many call traces in dmesg, most are XFS, pasted below.  I found no
> SCSI I/O errors in dmesg.  Application is submitting writes via libaio and
> using O_DIRECT, writing to preallocated files.  I don't see any errors in
> the storage controller log and everything seems to check out there.  Using
> noop elevator, mpt2sas, no multipathing.  The application process is hung
> in d state and kill -9 won't get rid of it.  I can't unmount the hosed up
> filesystem.  Any ideas?
> 
> # ls -la /mnt/VOL1
> ls: cannot access /mnt/VOL1: Input/output error
> 
> # dd if=/mnt/VOL1 of=/dev/null bs=1M count=16
> dd: opening `/mnt/VOL1': Input/output error
> 
> # dd if=/dev/sdd of=/dev/null bs=1M count=16
> 16+0 records in
> 16+0 records out
> 16777216 bytes (17 MB) copied, 1.10989 s, 15.1 MB/s
> 
> # ls -la /mnt/
> ls: cannot access /mnt/VOL1: Input/output error
> total 8
> drwxrwxrwt  6 root root  120 Aug 25 17:59 .
> drwxr-xr-x 21 root root 4096 Jul 15 09:39 ..
> drwxrwxrwt  3 root root   80 Aug 25 16:52 initramfs
> drwxr-xr-x  3 root root 4096 Apr 24 04:57 scratch
> drwxrwxrwx  5 root root   58 Aug 25 22:06 VOL0
> d?????????  ? ?    ?       ?            ? VOL1

That's an inode we failed to stat() - most likely because of the IO
error. Has the filesystem shut down? the IO error shoul dhave had
some kind of output in dmesg associated with it from XFS....

> [22635.102013] INFO: task kworker/7:0:45 blocked for more than 120
> seconds.
> [22635.102016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [22635.102018] kworker/7:0     D ffff8840666c0b08     0    45      2
> 0x00000000
> [22635.102021]  ffff8840666e7bd0 0000000000000046 ffff883f7c02d000
> ffff8840666f5180
> [22635.102026]  ffff8840666e7b80 0000000000000206 00000000000122c0
> 00000000000122c0
> [22635.102030]  ffff8840666e7fd8 ffff8840666e6000 00000000000122c0
> ffff8840666e6000
> [22635.102033] Call Trace:
> [22635.102041]  [<ffffffff814f5fd7>] schedule+0x64/0x66
> [22635.102044]  [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [22635.102047]  [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [22635.102051]  [<ffffffff81261913>]
> call_rwsem_down_write_failed+0x13/0x20
> [22635.102055]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102058]  [<ffffffff814f5458>] ? down_write+0x25/0x27
> [22635.102070]  [<ffffffffa01b35e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [22635.102077]  [<ffffffffa01b5ab0>] xfs_iomap_write_unwritten+0x1b3/0x32e
> [xfs]
> [22635.102080]  [<ffffffff814f6a92>] ?
> _raw_spin_unlock_irqrestore+0x30/0x3d
> [22635.102084]  [<ffffffffa01ab3d2>] ? xfs_setfilesize+0x128/0x128 [xfs]
> [22635.102088]  [<ffffffff810bc602>] ? mempool_free+0x73/0x78
> [22635.102093]  [<ffffffffa01ab3d2>] ? xfs_setfilesize+0x128/0x128 [xfs]
> [22635.102098]  [<ffffffffa01ab45b>] xfs_end_io+0x89/0xb4 [xfs]
> [22635.102102]  [<ffffffff81047321>] process_one_work+0x204/0x327
> [22635.102105]  [<ffffffff8104757f>] worker_thread+0x13b/0x25a
> [22635.102108]  [<ffffffff81047444>] ? process_one_work+0x327/0x327
> [22635.102111]  [<ffffffff8104af6f>] kthread+0x89/0x91
> [22635.102115]  [<ffffffff814fdbd4>] kernel_thread_helper+0x4/0x10
> [22635.102118]  [<ffffffff8104aee6>] ? __init_kthread_worker+0x3c/0x3c
> [22635.102120]  [<ffffffff814fdbd0>] ? gs_change+0xb/0xb

That's stuck on a an inode lock. That reminds of a problem we had in
RHEL6 with highly concurrent direct IO. The rwsems were buggy, and
XFS was tripping over the bug and hanging just like this. If the
filesystem is not shutting down and causing that IO error due to a
shutdown state, then it's entirely possible we've got another rwsem
issue.  Now I've just got to go find the RHEL 6 problem again. Ah:

91af708 rwsem: Test for no active locks in __rwsem_do_wake undo code

But that was fixed in 2.6.34 (rhel 6 was based on 2.6.32), so I
doubt that is your problem. However, it smells almost exactly the
same - it took about an hour of highly concurrent direct IO to SSDs
to trigger, and Lachlan ended up finding the right incantation of
lock debug code inside the xfs mrlock implementation to prove that
it was an rwsem bug and not an XFS locking issue.

Are you able to take crash dumps from this machine so you can dig
around inside the XFS inode and rwsem states when the system locks
up like this?

One thing in the RH bug that was suggested as a simply test to
determine if there's a problem with the rwsems is to edit the kernel
configin arch/x86/Kconfig:

Change:

	config RWSEM_GENERIC_SPINLOCK
		def_bool !X86_ADD

	config RWSEM_XCHGADD_ALGORITHM
		def_bool X86_ADD

to:

	config RWSEM_GENERIC_SPINLOCK
		def_bool y

	config RWSEM_XCHGADD_ALGORITHM
		def_bool n

I haven't cheked if this still works on a 3.4 kernel, but it will
change the rwsem implementation to the generic, spinlock based
implementation rather than the super-special, highly optimised
x86 specific implementation. If that makes the problem go away,
then we've got another rwsem bug on our hands. If it doesn't, then I
can probably get you the mrlock debug code lachlan wrote and we can
see if XFS is doing something wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
