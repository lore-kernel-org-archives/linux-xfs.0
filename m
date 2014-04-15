Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E33BE7F37
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 21:16:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BEF0AC002
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 19:16:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Unk5U2NBL1lvmAeE for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 19:16:06 -0700 (PDT)
Date: Tue, 15 Apr 2014 12:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: unmount does not wait for shutdown during unmount
Message-ID: <20140415021546.GD31578@dastard>
References: <1397104955-7247-1-git-send-email-david@fromorbit.com>
	<20140414192824.GC62307@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414192824.GC62307@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: bob.mastors@solidfire.com, snitzer@redhat.com, xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 03:28:24PM -0400, Brian Foster wrote:
> On Thu, Apr 10, 2014 at 02:42:35PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > =

> > And interesting situation can occur if a log IO error occurs during
> > the unmount of a filesystem. The cases reported have the same
> > signature - the update of the superblock counters fails due to a log
> > write IO error:
> > =

> > XFS (dm-16): xfs_do_force_shutdown(0x2) called from line 1170 of file f=
s/xfs/xfs_log.c.  Return address =3D 0xffffffffa08a44a1
> > XFS (dm-16): Log I/O Error Detected.  Shutting down filesystem
> > XFS (dm-16): Unable to update superblock counters. Freespace may not be=
 correct on next mount.
> > XFS (dm-16): xfs_log_force: error 5 returned.
> > XFS (=BF-=BF=BF=BF): Please umount the filesystem and rectify the probl=
em(s)
> > =

> > It can be seen that the last line of output contains a corrupt
> > device name - this is because the log and xfs_mount structures have
> > already been freed by the time this message is printed. A kernel
> > oops closely follows.
> > =

> > The issue is that the shutdown is occurring in a separate IO
> > completion thread to the unmount. Once the shutdown processing has
> > started and all the iclogs are marked with XLOG_STATE_IOERROR, the
> > log shutdown code wakes anyone waiting on a log force so they can
> > process the shutdown error. This wakes up the unmount code that
> > is doing a synchronous transaction to update the superblock
> > counters.
> > =

> > The unmount path now sees all the iclogs are marked with
> > XLOG_STATE_IOERROR and so never waits on them again, knowing that if
> > it does, there will not be a wakeup trigger for it and we will hang
> > the unmount if we do. Hence the unmount runs through all the
> > remaining code and frees all the filesystem structures while the
> > xlog_iodone() is still processing the shutdown. When the log
> > shutdown processing completes, xfs_do_force_shutdown() emits the
> > "Please umount the filesystem and rectify the problem(s)" message,
> > and xlog_iodone() then aborts all the objects attached to the iclog.
> > An iclog that has already been freed....
> > =

> > The real issue here is that there is no serialisation point between
> > the log IO and the unmount. We have serialisations points for log
> > writes, log forces, reservations, etc, but we don't actually have
> > any code that wakes for log IO to fully complete. We do that for all
> > other types of object, so why not iclogbufs?
> > =

> > Well, it turns out that we can easily do this. We've got xfs_buf
> > handles, and that's what everyone else uses for IO serialisation.
> > i.e. bp->b_sema. So, lets hold iclogbufs locked over IO, and only
> > release the lock in xlog_iodone() when we are finished with the
> > buffer. That way before we tear down the iclog, we can lock and
> > unlock the buffer to ensure IO completion has finished completely
> > before we tear it down.
> > =

> =

> Thanks for the write up...
.....
> On reading the code, my initial thought was that the source of this is
> the xlog_state_do_callback() call down in the shutdown path, when
> invoked from the log I/O completion handler. I think you pointed out in
> your previous reply that even if we were to make that call selective
> (e.g., based on whether the shutdown is due to a log error and thus we
> can expect xlog_state_do_callback() to be invoked), we still access
> relevant data structures after the ic_force_wait wait_queue is woken.
> Therefore, there would still be a race even if we bypassed the call from
> within the shutdown path in this particular case.
> =

> The logic seems sane to me. I don't notice any issues. But my only
> question is why the use of locking, as opposed to wiring up use of
> b_iowait or something into the log I/O handler?

Log IO is issued B_ASYNC, so the buffer IO completion handlers do
not issue wakeups to b_iowait waiters. And the iclogbufs are
uncached buffers, so we can't use the buffer cache waiting
mechanisms to wait for them, either.

> I ask because it looks
> just a _bit_ funny to see the lock/unlock cycles used purely as a
> serialization mechanism. Do we use this kind of pattern in other places?

Yes, in xfs_log_quiesce(), to wait on the superblock buffer IO
because:

        /*
         * The superblock buffer is uncached and while xfs_ail_push_all_syn=
c()
         * will push it, xfs_wait_buftarg() will not wait for it. Further,
         * xfs_buf_iowait() cannot be used because it was pushed with the
         * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait=
 for
         * the IO to complete.
         */

Which is exactly the same situation as the iclogbufs - uncached
buffers, B_ASYNC IO....

> I guess on the other hand you could argue it protects the I/O in
> progress, and yet another wait_queue in this codepath might be overkill
> (so I like the use of an existing mechanism from that standpoint).

Mostly I figured that we already have the same IO wait mechanism in
the log shutdown path for other buffers, so it seemed silly to add
waitqueues and other infrastructure for something that could be
handled very easily. It also makes the iclogs look like every other
buffer in the filesystem in that the buffer lock is held over IO.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
