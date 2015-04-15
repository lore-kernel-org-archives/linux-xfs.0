Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6B307F51
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 06:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AE99304039
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 04:11:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bwu6CERlAokhduPJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Apr 2015 04:11:05 -0700 (PDT)
Date: Wed, 15 Apr 2015 07:11:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/9] xfs: handle DIO overwrite EOF update completion
	correctly
Message-ID: <20150415111100.GC42829@bfoster.bfoster>
References: <1429073512-20035-1-git-send-email-david@fromorbit.com>
	<1429073512-20035-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429073512-20035-5-git-send-email-david@fromorbit.com>
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

On Wed, Apr 15, 2015 at 02:51:47PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently a DIO overwrite that extends the EOF (e.g sub-block IO or
> write into allocated blocks beyond EOF) requires a transaction for
> the EOF update. Thi is done in IO completion context, but we aren't
> explicitly handling this situation properly and so it can run in
> interrupt context. Ensure that we defer IO that spans EOF correctly
> to the DIO completion workqueue, and now that we have an ioend in IO
> completion we can use the common ioend completion path to do all the
> work.
> 
> Note: we do not preallocate the append transaction as we can have
> multiple mapping and allocation calls per direct IO. hence
> preallocating can still leave us with nested transactions by
> attempting to map and allocate more blocks after we've preallocated
> an append transaction.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c  | 61 +++++++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_trace.h |  1 +
>  2 files changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 60d6466..a59443d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1293,7 +1293,7 @@ xfs_map_direct(
>  					   imap);
>  	}
>  
> -	if (ioend->io_type == XFS_IO_UNWRITTEN)
> +	if (ioend->io_type == XFS_IO_UNWRITTEN || xfs_ioend_is_append(ioend))
>  		set_buffer_defer_completion(bh_result);
>  }
>  
> @@ -1535,8 +1535,10 @@ xfs_end_io_direct_write(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ioend	*ioend = private;
>  
> +	trace_xfs_gbmap_direct_endio(ip, offset, size, ioend->io_type, NULL);
> +
>  	if (XFS_FORCED_SHUTDOWN(mp))
> -		goto out_destroy_ioend;
> +		goto out_end_io;
>  
>  	/*
>  	 * dio completion end_io functions are only called on writes if more
> @@ -1557,40 +1559,37 @@ xfs_end_io_direct_write(
>  	ioend->io_offset = offset;
>  
>  	/*
> -	 * While the generic direct I/O code updates the inode size, it does
> -	 * so only after the end_io handler is called, which means our
> -	 * end_io handler thinks the on-disk size is outside the in-core
> -	 * size.  To prevent this just update it a little bit earlier here.
> +	 * The ioend tells us whether we are doing unwritten extent conversion
> +	 * or an append transaction that updates the on-disk file size. These
> +	 * cases are the only cases where we should *potentially* be needing
> +	 * to update the VFS inode size. When the ioend indicates this, we
> +	 * are *guaranteed* to be running in non-interrupt context.
> +	 *
> +	 * We need to update the in-core inode size here so that we don't end up
> +	 * with the on-disk inode size being outside the in-core inode size.
> +	 * While we can do this in the process context after the IO has
> +	 * completed, this does not work for AIO and hence we always update
> +	 * the in-core inode size here if necessary.
>  	 */
> -	if (offset + size > i_size_read(inode))
> -		i_size_write(inode, offset + size);
> +	if (ioend->io_type == XFS_IO_UNWRITTEN || xfs_ioend_is_append(ioend)) {
> +		if (offset + size > i_size_read(inode))
> +			i_size_write(inode, offset + size);
> +	} else
> +		ASSERT(offset + size <= i_size_read(inode));
>  
>  	/*
> -	 * For direct I/O we do not know if we need to allocate blocks or not,
> -	 * so we can't preallocate an append transaction, as that results in
> -	 * nested reservations and log space deadlocks. Hence allocate the
> -	 * transaction here. While this is sub-optimal and can block IO
> -	 * completion for some time, we're stuck with doing it this way until
> -	 * we can pass the ioend to the direct IO allocation callbacks and
> -	 * avoid nesting that way.
> +	 * If we are doing an append IO that needs to update the EOF on disk,
> +	 * do the transaction reserve now so we can use common end io
> +	 * processing. Stashing the error (if there is one) in the ioend will
> +	 * result in the ioend processing passing on the error if it is
> +	 * possible as we can't return it from here.
>  	 */
> -	if (ioend->io_type == XFS_IO_UNWRITTEN) {
> -		xfs_iomap_write_unwritten(ip, offset, size);
> -	} else if (offset + size > ip->i_d.di_size) {
> -		struct xfs_trans	*tp;
> -		int			error;
> -
> -		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> -		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
> -		if (error) {
> -			xfs_trans_cancel(tp, 0);
> -			goto out_destroy_ioend;
> -		}
> +	if (ioend->io_type == XFS_IO_OVERWRITE && xfs_ioend_is_append(ioend))
> +		ioend->io_error = xfs_setfilesize_trans_alloc(ioend);
>  
> -		xfs_setfilesize(ip, tp, offset, size);
> -	}
> -out_destroy_ioend:
> -	xfs_destroy_ioend(ioend);
> +out_end_io:
> +	xfs_end_io(&ioend->io_work);
> +	return;
>  }
>  
>  STATIC ssize_t
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index e78b64e..967993b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1224,6 +1224,7 @@ DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
>  DEFINE_IOMAP_EVENT(xfs_gbmap_direct);
>  DEFINE_IOMAP_EVENT(xfs_gbmap_direct_new);
>  DEFINE_IOMAP_EVENT(xfs_gbmap_direct_update);
> +DEFINE_IOMAP_EVENT(xfs_gbmap_direct_endio);
>  
>  DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
