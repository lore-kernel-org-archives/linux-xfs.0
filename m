Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B099E29DF7
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:25:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96DF88F8040
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:25:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5ZmLy8moR16XmmcV for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:25:25 -0700 (PDT)
Date: Thu, 10 Apr 2014 12:25:13 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: xfs: unmount does not wait for shutdown during unmount
Message-ID: <20140410162513.GA21960@redhat.com>
References: <1397104955-7247-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397104955-7247-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: bob.mastors@solidfire.com, xfs@oss.sgi.com

On Thu, Apr 10 2014 at 12:42am -0400,
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> =

> And interesting situation can occur if a log IO error occurs during
> the unmount of a filesystem. The cases reported have the same
> signature - the update of the superblock counters fails due to a log
> write IO error:
> =

> XFS (dm-16): xfs_do_force_shutdown(0x2) called from line 1170 of file fs/=
xfs/xfs_log.c.  Return address =3D 0xffffffffa08a44a1
> XFS (dm-16): Log I/O Error Detected.  Shutting down filesystem
> XFS (dm-16): Unable to update superblock counters. Freespace may not be c=
orrect on next mount.
> XFS (dm-16): xfs_log_force: error 5 returned.
> XFS (=BF-=BF=BF=BF): Please umount the filesystem and rectify the problem=
(s)
> =

> It can be seen that the last line of output contains a corrupt
> device name - this is because the log and xfs_mount structures have
> already been freed by the time this message is printed. A kernel
> oops closely follows.
> =

> The issue is that the shutdown is occurring in a separate IO
> completion thread to the unmount. Once the shutdown processing has
> started and all the iclogs are marked with XLOG_STATE_IOERROR, the
> log shutdown code wakes anyone waiting on a log force so they can
> process the shutdown error. This wakes up the unmount code that
> is doing a synchronous transaction to update the superblock
> counters.
> =

> The unmount path now sees all the iclogs are marked with
> XLOG_STATE_IOERROR and so never waits on them again, knowing that if
> it does, there will not be a wakeup trigger for it and we will hang
> the unmount if we do. Hence the unmount runs through all the
> remaining code and frees all the filesystem structures while the
> xlog_iodone() is still processing the shutdown. When the log
> shutdown processing completes, xfs_do_force_shutdown() emits the
> "Please umount the filesystem and rectify the problem(s)" message,
> and xlog_iodone() then aborts all the objects attached to the iclog.
> An iclog that has already been freed....
> =

> The real issue here is that there is no serialisation point between
> the log IO and the unmount. We have serialisations points for log
> writes, log forces, reservations, etc, but we don't actually have
> any code that wakes for log IO to fully complete. We do that for all
> other types of object, so why not iclogbufs?
> =

> Well, it turns out that we can easily do this. We've got xfs_buf
> handles, and that's what everyone else uses for IO serialisation.
> i.e. bp->b_sema. So, lets hold iclogbufs locked over IO, and only
> release the lock in xlog_iodone() when we are finished with the
> buffer. That way before we tear down the iclog, we can lock and
> unlock the buffer to ensure IO completion has finished completely
> before we tear it down.
> =

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Works for the dm-thinp test-case that was failing, thanks Dave!

Tested-by: Mike Snitzer <snitzer@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
