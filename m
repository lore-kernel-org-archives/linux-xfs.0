Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADBDD7F50
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 20:31:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 578AEAC001
	for <xfs@oss.sgi.com>; Sun, 20 Oct 2013 18:31:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZaTdWyDTLYtBqBwq for <xfs@oss.sgi.com>;
	Sun, 20 Oct 2013 18:31:50 -0700 (PDT)
Date: Mon, 21 Oct 2013 12:31:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A review of dm-writeboost
Message-ID: <20131021013143.GC4446@dastard>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
	<52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
	<alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
	<20131016060750.GE4446@dastard> <525E6BBE.40004@gmail.com>
	<20131016110146.GH4446@dastard> <525E83E4.9090803@gmail.com>
	<20131016214200.GI4446@dastard> <5262662B.9010807@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5262662B.9010807@gmail.com>
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
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com

On Sat, Oct 19, 2013 at 07:59:55PM +0900, Akira Hayakawa wrote:
> Dave,
> 
> # -EIO retuned corrupts XFS
> I turned up
> lockdep, frame pointer, xfs debug
> and also changed to 3.12.0-rc5 from rc1.
> 
> What's changed is that
> the problem we discussed in previous mails
> *never* reproduce.
> 
> However, if I turn off the lockdep only
> it hangs up by setting blockup to 1 and then to 0 after that.

Which indicates that the corruption is likely to be caused by a race
condition, and that adding lockdep slows things down enough to
change the timing and hence not hit the race condition...

e.g. the use after free that causes the memory corruption now occurs
after the critical point where XFS can get stuck on it.

> The underlying device once became dead revives
> may confuse the filesystem but
> this looks not related to locking things.
> This problem may be producible using dm-flakey.

I use dm-flakey quite a bit, and I haven't seen this....

> This behavior is not reproducible with ext4.
> 
> --------------------------------------------
> root@Lyle:/home/akira# virsh console Hercules
> Connected to domain Hercules
> Escape character is ^]
> [  143.042980] device-mapper: writeboost: info@modulator_proc() reactivated after blockup
> [  143.042999] device-mapper: writeboost: info@dm_safe_io_internal() reactivated after blockup
> [  143.043006] device-mapper: writeboost: info@migrate_proc() reactivated after blockup
> [  143.045328] XFS: metadata I/O error: block 0x300d0f ("xlog_iodone") error 5 numblks 64
> [  143.045333] XFS: xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0430f9c
> [  143.045335] XFS: Log I/O Error Detected.  Shutting down filesystem
> [  143.045335] XFS: Please umount the filesystem and rectify the problem(s)
> [  143.045338] XFS: Assertion failed: atomic_read(&iclog->ic_refcnt) == 0, file: fs/xfs/xfs_log.c, line: 2751
.....
> [  143.045465] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
.....
> [  143.045558]  [<ffffffffa0430ed1>] xlog_state_done_syncing+0x6d/0xe4 [xfs]
> [  143.045590]  [<ffffffffa0431018>] xlog_iodone+0xd0/0xd9 [xfs]
> [  143.045609]  [<ffffffffa03d834f>] xfs_buf_iodone_work+0x57/0xa2 [xfs]
> [  143.045627]  [<ffffffff8104f21a>] process_one_work+0x18b/0x297
> [  143.045631]  [<ffffffff8104f6e6>] worker_thread+0x12e/0x1fb
> [  143.045634]  [<ffffffff8104f5b8>] ? rescuer_thread+0x268/0x268
> [  143.045638]  [<ffffffff81054507>] kthread+0x88/0x90
> [  143.045641]  [<ffffffff8105447f>] ? __kthread_parkme+0x60/0x60

So that has got through xlog_iodone() and has found that the
reference count of the iclog was not zero when it went to run the
log IO completion callbacks.

We asserted that the reference count was zero before issuing the IO,
and we only ever increment the reference count when the iclog is in
an active state. We cannot increment the reference count while the
log is under IO because the state of the iclog is "syncing", not
"active".

Once the log is shut down, the iclog state goes to
XLOG_STATE_IOERROR and never goes out of that state. The assert just
prior to the one that tripped above indicates that we are either in
an ACTIVE state or IOERROR:

        ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
               iclog->ic_state == XLOG_STATE_IOERROR);
>>>>>>  ASSERT(atomic_read(&iclog->ic_refcnt) == 0);

It was the second assert that failed, and hence it's clear that
in either state the reference count cannot be incremented until the
IO is fully completed and it transitioned back the active state.

> [  143.045333] XFS: xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0430f9c

This indicates that the shutdown was called from xlog_iodone() as a
result of an IO error on the iclog buffer, and the call to
xlog_state_done_syncing() happens 5 lines of code later, which
immediately assert fails with a corrupt iclog state.

Because we shutdown with SHUTDOWN_LOG_IO_ERROR set, we call into
xfs_log_force_umount() with logerror = true. This first call ends up
setting the log flag XLOG_IO_ERROR, then calling
xlog_state_ioerror() which sets ic_state on all iclogs to
XLOG_STATE_IOERROR.

The shutdown then runs xlog_state_do_callback() which aborts the
completions on all the iclogs that have callbacks attached, and
wakes anyone waiting on log space or log forces so they can get
errors returned to them.

We now return to xlog_iodone() in a shutdown state, with all the
iclog buffers in with ic_state = XLOG_STATE_IOERROR. So, there is
absolutely no opportunity for anyone to take a new reference to the
iclog in the 10 *microseconds* between the IO error being detected,
the shutdown being processed and the call to
xlog_state_done_syncing() where the assert fails. At this point, I
cannot see how this can occur in the XFS code.

Indeed, I can trigger this error path easily under heavy load just
using the godown utility in xfstests:

[1044535.986040] XFS (vdc): Mounting Filesystem
[1044536.040630] XFS (vdc): Ending clean mount
[1044536.059299] XFS: Clearing xfsstats
# src/xfstests-dev/src/godown -v /mnt/scratch
Opening "/mnt/scratch"
Calling XFS_IOC_GOINGDOWN
[1044553.342767] XFS (vdc): metadata I/O error: block 0x19000c2e98 ("xlog_iodone") error 5 numblks 512
[1044553.345993] XFS (vdc): xfs_do_force_shutdown(0x2) called from line 1171 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff814e61ad
#[1044554.136965] XFS (vdc): xfs_log_force: error 5 returned.
[1044554.154892] XFS: Clearing xfsstats
[1044566.108484] XFS (vdc): xfs_log_force: error 5 returned.
[1044596.188515] XFS (vdc): xfs_log_force: error 5 returned.
[1044626.268166] XFS (vdc): xfs_log_force: error 5 returned.
[1044656.348146] XFS (vdc): xfs_log_force: error 5 returned.

IOWs, this looks like something is corrupting the state of the log
*before* the xlog_iodone() callback is being run. i.e. it is in a
valid state before IO dispatch and it's in a corrupt state on IO
completion despite XFS having *never touched that state* during the
IO.

Indeed, this is a different issue to the one you posted
earlier, which was the AIL lock (which is in a different XFS
structure) had not been released. Again, I couldn't see how that
could occur, and we're now seeing a pattern of random structures
being corrupted. Hmmm, looking at pahole:

atomic_t                   ic_refcnt;            /*   192     4 */

spinlock_t                 xa_lock;              /*    64     2 */

Both the items that were corrupted are on the first word of a
cacheline. That further points to memory corruption of some kind...

IOWs, the more I look, the more this looks like memory corruption is
the cause of the problems. The only unusual thing that is happening
is an error handling path in a brand new block device driver is
being run immediately before the memory corruption causes problems,
and that tends to indicate that this corruption is not caused by
XFS...

> My Idea:
> - If something problematic happens in underlying devices
>   writeboost device returns -EIO on any requests and
>   stop all the daemons
....
> - I will not remove `blockup`.
>   Yes. If the problem is in hardware it is very difficult
>   to recover.
>   However, leaving a chance for recovering the device is
>   at least better than just shutdown the device
>   if it doesn't pollute the code so much.
>   So, I will leave this option.

It doesn't matter whether the underlying hardware might be able to
recover - once you've send EIOs during IO completion that
data/metadata is considered *unrecoverable* and so the filesystem
will end up inconsistent or the *user will lose data* as a result.

IOWs, your idea is flawed, will not work and will result in
data/filesystem loss when used. You cannot call this a "recovery
mechanism" because it simply isn't.

> BTW, what do you mean by the word "fatal"?

"He suffered a fatal gunshot wound to the head."

i.e. the person is *dead* and life is *unrecoverable*.

That's what you are doing here - returning EIOs to IOs in progress
is effectively shooting the fileystem (and user data) in the
head.....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
