Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3AEB7F37
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 14:28:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51885AC003
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 12:28:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0yI5r5w4Hn9GyOKN for
	<xfs@oss.sgi.com>; Mon, 14 Apr 2014 12:28:35 -0700 (PDT)
Date: Mon, 14 Apr 2014 15:28:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: unmount does not wait for shutdown during unmount
Message-ID: <20140414192824.GC62307@bfoster.bfoster>
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
Cc: bob.mastors@solidfire.com, snitzer@redhat.com, xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 02:42:35PM +1000, Dave Chinner wrote:
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


Thanks for the write up...

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 53 ++++++++++++++++++++++++++++++++++++++++++++------=
---
>  1 file changed, 44 insertions(+), 9 deletions(-)
> =

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8497a00..08624dc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1181,11 +1181,14 @@ xlog_iodone(xfs_buf_t *bp)
>  	/* log I/O is always issued ASYNC */
>  	ASSERT(XFS_BUF_ISASYNC(bp));
>  	xlog_state_done_syncing(iclog, aborted);
> +
>  	/*
> -	 * do not reference the buffer (bp) here as we could race
> -	 * with it being freed after writing the unmount record to the
> -	 * log.
> +	 * drop the buffer lock now that we are done. Nothing references
> +	 * the buffer after this, so an unmount waiting on this lock can now
> +	 * tear it down safely. As such, it is unsafe to reference the buffer
> +	 * (bp) after the unlock as we could race with it being freed.
>  	 */
> +	xfs_buf_unlock(bp);
>  }
>  =

>  /*
> @@ -1368,8 +1371,16 @@ xlog_alloc_log(
>  	bp =3D xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0=
);
>  	if (!bp)
>  		goto out_free_log;
> -	bp->b_iodone =3D xlog_iodone;
> +
> +	/*
> +	 * The iclogbuf buffer locks are held over IO but we are not going to do
> +	 * IO yet.  Hence unlock the buffer so that the log IO path can grab it
> +	 * when appropriately.
> +	 */
>  	ASSERT(xfs_buf_islocked(bp));
> +	xfs_buf_unlock(bp);
> +
> +	bp->b_iodone =3D xlog_iodone;
>  	log->l_xbuf =3D bp;
>  =

>  	spin_lock_init(&log->l_icloglock);
> @@ -1398,6 +1409,9 @@ xlog_alloc_log(
>  		if (!bp)
>  			goto out_free_iclog;
>  =

> +		ASSERT(xfs_buf_islocked(bp));
> +		xfs_buf_unlock(bp);
> +
>  		bp->b_iodone =3D xlog_iodone;
>  		iclog->ic_bp =3D bp;
>  		iclog->ic_data =3D bp->b_addr;
> @@ -1422,7 +1436,6 @@ xlog_alloc_log(
>  		iclog->ic_callback_tail =3D &(iclog->ic_callback);
>  		iclog->ic_datap =3D (char *)iclog->ic_data + log->l_iclog_hsize;
>  =

> -		ASSERT(xfs_buf_islocked(iclog->ic_bp));
>  		init_waitqueue_head(&iclog->ic_force_wait);
>  		init_waitqueue_head(&iclog->ic_write_wait);
>  =

> @@ -1631,6 +1644,12 @@ xlog_cksum(
>   * we transition the iclogs to IOERROR state *after* flushing all existi=
ng
>   * iclogs to disk. This is because we don't want anymore new transaction=
s to be
>   * started or completed afterwards.
> + *
> + * We lock the iclogbufs here so that we can serialise against IO comple=
tion
> + * during unmount. We might be processing a shutdown triggered during un=
mount,
> + * and that can occur asynchronously to the unmount thread, and hence we=
 need to
> + * ensure that completes before tearing down the iclogbufs. Hence we nee=
d to
> + * hold the buffer lock across the log IO to acheive that.
>   */
>  STATIC int
>  xlog_bdstrat(
> @@ -1638,6 +1657,7 @@ xlog_bdstrat(
>  {
>  	struct xlog_in_core	*iclog =3D bp->b_fspriv;
>  =

> +	xfs_buf_lock(bp);
>  	if (iclog->ic_state & XLOG_STATE_IOERROR) {
>  		xfs_buf_ioerror(bp, EIO);
>  		xfs_buf_stale(bp);
> @@ -1645,7 +1665,8 @@ xlog_bdstrat(
>  		/*
>  		 * It would seem logical to return EIO here, but we rely on
>  		 * the log state machine to propagate I/O errors instead of
> -		 * doing it here.
> +		 * doing it here. Similarly, IO completion will unlock the
> +		 * buffer, so we don't do it here.
>  		 */
>  		return 0;
>  	}
> @@ -1847,14 +1868,28 @@ xlog_dealloc_log(
>  	xlog_cil_destroy(log);
>  =

>  	/*
> -	 * always need to ensure that the extra buffer does not point to memory
> -	 * owned by another log buffer before we free it.
> +	 * Cycle all the iclogbuf locks to make sure all log IO completion
> +	 * is done before we tear down these buffers.
>  	 */
> +	iclog =3D log->l_iclog;
> +	for (i =3D 0; i < log->l_iclog_bufs; i++) {
> +		xfs_buf_lock(iclog->ic_bp);
> +		xfs_buf_unlock(iclog->ic_bp);
> +		iclog =3D iclog->ic_next;
> +	}
> +
> +	/*
> +	 * Always need to ensure that the extra buffer does not point to memory
> +	 * owned by another log buffer before we free it. Also, cycle the lock
> +	 * first to ensure we've completed IO on it.
> +	 */
> +	xfs_buf_lock(log->l_xbuf);
> +	xfs_buf_unlock(log->l_xbuf);
>  	xfs_buf_set_empty(log->l_xbuf, BTOBB(log->l_iclog_size));
>  	xfs_buf_free(log->l_xbuf);
>  =

>  	iclog =3D log->l_iclog;
> -	for (i=3D0; i<log->l_iclog_bufs; i++) {
> +	for (i =3D 0; i < log->l_iclog_bufs; i++) {
>  		xfs_buf_free(iclog->ic_bp);
>  		next_iclog =3D iclog->ic_next;
>  		kmem_free(iclog);

On reading the code, my initial thought was that the source of this is
the xlog_state_do_callback() call down in the shutdown path, when
invoked from the log I/O completion handler. I think you pointed out in
your previous reply that even if we were to make that call selective
(e.g., based on whether the shutdown is due to a log error and thus we
can expect xlog_state_do_callback() to be invoked), we still access
relevant data structures after the ic_force_wait wait_queue is woken.
Therefore, there would still be a race even if we bypassed the call from
within the shutdown path in this particular case.

The logic seems sane to me. I don't notice any issues. But my only
question is why the use of locking, as opposed to wiring up use of
b_iowait or something into the log I/O handler? I ask because it looks
just a _bit_ funny to see the lock/unlock cycles used purely as a
serialization mechanism. Do we use this kind of pattern in other places?
I guess on the other hand you could argue it protects the I/O in
progress, and yet another wait_queue in this codepath might be overkill
(so I like the use of an existing mechanism from that standpoint).

Brian

> -- =

> 1.9.0
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
