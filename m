Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDCA029DF5
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 08:15:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1C02304053
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 06:15:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KyTFCA7jMbcboG6o (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 06:15:43 -0800 (PST)
Date: Tue, 12 Jan 2016 09:15:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: log mount failures don't wait for buffers to be
	released
Message-ID: <20160112141540.GD12156@bfoster.bfoster>
References: <1452562536-32145-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452562536-32145-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 12:35:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recently I've been seeing xfs/051 fail on 1k block size filesystems.
> Trying to trace the events during the test lead to the problem going
> away, indicating that it was a race condition that lead to this
> ASSERT failure:
> 
> XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/xfs_mount.c, line: 156
> .....
> [<ffffffff814e1257>] xfs_free_perag+0x87/0xb0
> [<ffffffff814e21b9>] xfs_mountfs+0x4d9/0x900
> [<ffffffff814e5dff>] xfs_fs_fill_super+0x3bf/0x4d0
> [<ffffffff811d8800>] mount_bdev+0x180/0x1b0
> [<ffffffff814e3ff5>] xfs_fs_mount+0x15/0x20
> [<ffffffff811d90a8>] mount_fs+0x38/0x170
> [<ffffffff811f4347>] vfs_kern_mount+0x67/0x120
> [<ffffffff811f7018>] do_mount+0x218/0xd60
> [<ffffffff811f7e5b>] SyS_mount+0x8b/0xd0
> 
> When I finally caught it with tracing enabled, I saw that AG 2 had
> an elevated reference count and a buffer was responsible for it. I
> tracked down the specific buffer, and found that it was missing the
> final reference count release that would put it back on the LRU and
> hence be found by xfs_wait_buftarg() calls in the log mount failure
> handling.
> 
> The last four traces for the buffer before the assert were (trimmed
> for relevance)
> 
> kworker/0:1-5259   xfs_buf_iodone:        hold 2  lock 0 flags ASYNC
> kworker/0:1-5259   xfs_buf_ioerror:       hold 2  lock 0 error -5
> mount-7163	   xfs_buf_lock_done:     hold 2  lock 0 flags ASYNC
> mount-7163	   xfs_buf_unlock:        hold 2  lock 1 flags ASYNC
> 
> This is an async write that is completing, so there's nobody waiting
> for it directly.  Hence we call xfs_buf_relse() once all the
> processing is complete. That does:
> 
> static inline void xfs_buf_relse(xfs_buf_t *bp)
> {
> 	xfs_buf_unlock(bp);
> 	xfs_buf_rele(bp);
> }
> 
> Now, it's clear that mount is waiting on the buffer lock, and that
> it has been released by xfs_buf_relse() and gained by mount. This is
> expected, because at this point the mount process is in
> xfs_buf_delwri_submit() waiting for all the IO it submitted to
> complete.
> 
> The mount process, however, is waiting on the lock for the buffer
> because it is in xfs_buf_delwri_submit(). This waits for IO
> completion, but it doesn't wait for the buffer reference owned by
> the IO to go away. The mount process collects all the completions,
> fails the log recovery, and the higher level code then calls
> xfs_wait_buftarg() to free all the remaining buffers in the
> filesystem.
> 
> The issue is that on unlocking the buffer, the scheduler has decided
> that the mount process has higher priority than the the kworker
> thread that is running the IO completion, and so immediately
> switched contexts to the mount process from the semaphore unlock
> code, hence preventing the kworker thread from finishing the IO
> completion and releasing the IO reference to the buffer.
> 
> Hence by the time that xfs_wait_buftarg() is run, the buffer still
> has an active reference and so isn't on the LRU list that the
> function walks to free the remaining buffers. Hence we miss that
> buffer and continue onwards to tear down the mount structures,
> at which time we get find a stray reference count on the perag
> structure. On a non-debug kernel, this will be ignored and the
> structure torn down and freed. Hence when the kworker thread is then
> rescheduled and the buffer released and freed, it will access a
> freed perag structure.
> 
> The problem here is that when the log mount fails, we still need to
> quiesce the log to ensure that the IO workqueues have returned to
> idle before we run xfs_wait_buftarg(). By synchronising the
> workqueues, we ensure that all IO completions are fully processed,
> not just to the point where buffers have been unlocked. This ensures
> we don't end up in the situation above.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 04d2bdd..08ad701 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1529,6 +1529,16 @@ xfs_wait_buftarg(
>  	LIST_HEAD(dispose);
>  	int loop = 0;
>  
> +	/*
> +	 * We need to flush the buffer workqueue to ensure that all IO
> +	 * completion processing is 100% done. Just waiting on buffer locks is
> +	 * not sufficient for async IO as the reference count held over IO is
> +	 * not released until after the buffer lock is dropped. Hence we need to
> +	 * ensure here that all reference counts have been dropped before we
> +	 * start walking the LRU list.
> +	 */
> +	drain_workqueue(btp->bt_mount->m_buf_workqueue);
> +
>  	/* loop until there is nothing left on the lru list. */
>  	while (list_lru_count(&btp->bt_lru)) {
>  		list_lru_walk(&btp->bt_lru, xfs_buftarg_wait_rele,
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
