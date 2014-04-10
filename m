Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B27A27F8C
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 16:52:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A6E5AC002
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 14:52:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kPNeflqMyMrHuh6b for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 14:52:22 -0700 (PDT)
Date: Fri, 11 Apr 2014 07:52:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: unmount does not wait for shutdown during unmount
Message-ID: <20140410215218.GD27519@dastard>
References: <1397104955-7247-1-git-send-email-david@fromorbit.com>
	<53469C9C.8010604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53469C9C.8010604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: bob.mastors@solidfire.com, snitzer@redhat.com, xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 08:29:00AM -0500, Mark Tinguely wrote:
> On 04/09/14 23:42, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >And interesting situation can occur if a log IO error occurs during
> >the unmount of a filesystem. The cases reported have the same
> >signature - the update of the superblock counters fails due to a log
> >write IO error:
> >
> >XFS (dm-16): xfs_do_force_shutdown(0x2) called from line 1170 of file fs=
/xfs/xfs_log.c.  Return address =3D 0xffffffffa08a44a1
> >XFS (dm-16): Log I/O Error Detected.  Shutting down filesystem
> >XFS (dm-16): Unable to update superblock counters. Freespace may not be =
correct on next mount.
> >XFS (dm-16): xfs_log_force: error 5 returned.
> >XFS (=BF-=BF=BF=BF): Please umount the filesystem and rectify the proble=
m(s)
> >
> >It can be seen that the last line of output contains a corrupt
> >device name - this is because the log and xfs_mount structures have
> >already been freed by the time this message is printed. A kernel
> >oops closely follows.
> >
> >The issue is that the shutdown is occurring in a separate IO
> >completion thread to the unmount. Once the shutdown processing has
> >started and all the iclogs are marked with XLOG_STATE_IOERROR, the
> >log shutdown code wakes anyone waiting on a log force so they can
> >process the shutdown error. This wakes up the unmount code that
> >is doing a synchronous transaction to update the superblock
> >counters.
> >
> >The unmount path now sees all the iclogs are marked with
> >XLOG_STATE_IOERROR and so never waits on them again, knowing that if
> >it does, there will not be a wakeup trigger for it and we will hang
> >the unmount if we do. Hence the unmount runs through all the
> >remaining code and frees all the filesystem structures while the
> >xlog_iodone() is still processing the shutdown. When the log
> >shutdown processing completes, xfs_do_force_shutdown() emits the
> >"Please umount the filesystem and rectify the problem(s)" message,
> >and xlog_iodone() then aborts all the objects attached to the iclog.
> >An iclog that has already been freed....
> >
> >The real issue here is that there is no serialisation point between
> >the log IO and the unmount. We have serialisations points for log
> >writes, log forces, reservations, etc, but we don't actually have
> >any code that wakes for log IO to fully complete. We do that for all
> >other types of object, so why not iclogbufs?
> >
> >Well, it turns out that we can easily do this. We've got xfs_buf
> >handles, and that's what everyone else uses for IO serialisation.
> >i.e. bp->b_sema. So, lets hold iclogbufs locked over IO, and only
> >release the lock in xlog_iodone() when we are finished with the
> >buffer. That way before we tear down the iclog, we can lock and
> >unlock the buffer to ensure IO completion has finished completely
> >before we tear it down.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> =

> The wait queue "xc_commit_wait" is used for two purposes, first to
> start the next ic_log buffer completion and also to wake those
> waiting for a syncronous event. Shutdown does syncronous cil pushes
> but it does not wait for the IO to happen.

First of all, shutdown does not do a CIL push if the source of the
shutdown is a log error, as is this case.

Secondly, shutdown can't wait for log IO completion because it can
be run from log IO completion, as is this case.

Thirdly, xc_commit_wait does not guarantee that *other* iclogbufs
are not under IO, just that specific CIL push is complete. Indeed,
we could be writing the unmount record, which writes to the
iclogbufs and issues IO directly and hence cannot be waited on by a
xc_commit_wait.

If you want to wait on iclogbuf state machine transitions (i.e. when
it considers the iclogbuf to be clean and active), that's what the
iclog->ic_write_wait wait queue is for. But even that is not
sufficient for our purposes, because the IO completion code
references the iclog after it has woken waiters during state machine
transitions.

Finally, the issue is that the superblock counter update transaction
is blocked in _xfs_log_force_lsn() as it is a synchronous
transaction. This is after the CIL has been pushed and now we are
waiting on iclogbuf IO completion blocked on the the
iclog->ic_force_wait wait queue. The last thing
xfs_log_force_unmount() does in a shutdown - after the state
machines are moved to error states - is wake up any waiters on the
iclog->ic_force_wait wait queues. That's where the "xfs_log_force:
error 5" message comes from - the sync transaction failing the
transaction commit.

Again, this happens before the iclogbuf IO completion processing is
finished, and hence we cannot use any of the existing wait queue
mechanisms to wait for iclogbuf IO completion to be finished. Hence,
a new mechanism is required, and that's what the patch provides.

> Why not wait for the IO to happen or fail
> before waking out the sync waiters?

How? You can't wait for IO completion when it's IO completion that
has detected the error and is running the shutdown.

> If you want to keep the speedier completion of the next cil
> push add another wait queue. There only a few (typically 8) per
> filesystem.

I don't follow you. What does this have to do with ensuring
iclogbufs are not still in use when we free them?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
