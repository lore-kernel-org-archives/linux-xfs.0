Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5FA227F52
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:56:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D61FAC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:56:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wL1CDtZytsZJpzGB for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:56:31 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:40:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] repair: ensure prefetched buffers have CRCs validated
Message-ID: <20140415194000.GB3470@laptop.bfoster>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-4-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:24:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prefetch currently does not do CRC validation when the IO completes
> due to the optimisation it performs and the fact that it does not
> know what the type of metadata into the buffer is supposed to be.
> Hence, mark all prefetched buffers as "suspect" so that when the
> end user tries to read it with a supplied validation function the
> validation is run even though the buffer was already in the cache.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/libxfs.h  |  1 +
>  libxfs/rdwr.c     | 36 +++++++++++++++++++++++++++++++-----
>  repair/prefetch.c |  3 +++
>  3 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 6bc6c94..6b1e276 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -333,6 +333,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
>  	LIBXFS_B_STALE		= 0x0004,	/* buffer marked as invalid */
>  	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
>  	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
> +	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */

This is used in the first couple patches, so it should probably be
defined earlier (or shuffle those patches appropriately).

>  };
>  
>  #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7208a2f..a8f06aa 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -718,12 +718,25 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
>  	bp = libxfs_getbuf(btp, blkno, len);
>  	if (!bp)
>  		return NULL;
> -	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
> +
> +	/*
> +	 * if the buffer was prefetched, it is likely that it was not
> +	 * validated. Hence if we are supplied an ops function and the
> +	 * buffer is marked as unchecked, we need to validate it now.
> +	 */
> +	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
> +		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
> +			bp->b_error = 0;
> +			bp->b_ops = ops;
> +			bp->b_ops->verify_read(bp);
> +			bp->b_flags &= ~LIBXFS_B_UNCHECKED;

Should we always expect an unchecked buffer to be read with an ops
vector before being written? Even if so, this might look cleaner if we
didn't encode the possibility of running a read verifier on a dirty
buffer. I presume that would always fail as the crc is updated in the
write verifier.

> +		}
>  		return bp;
> +	}
>  
>  	/*
> -	 * only set the ops on a cache miss (i.e. first physical read) as the
> -	 * verifier may change the ops to match the typ eof buffer it contains.
> +	 * Set the ops on a cache miss (i.e. first physical read) as the
> +	 * verifier may change the ops to match the type of buffer it contains.
>  	 * A cache hit might reset the verifier to the original type if we set
>  	 * it again, but it won't get called again and set to match the buffer
>  	 * contents. *cough* xfs_da_node_buf_ops *cough*.
> @@ -733,8 +746,10 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
>  	error = libxfs_readbufr(btp, blkno, bp, len, flags);
>  	if (error)
>  		bp->b_error = error;
> -	else if (bp->b_ops)
> +	else if (bp->b_ops) {
>  		bp->b_ops->verify_read(bp);
> +		bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> +	}
>  	return bp;
>  }
>  
> @@ -786,6 +801,14 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
>  		return NULL;
>  
>  	bp->b_error = 0;
> +	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
> +		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
> +			bp->b_ops = ops;
> +			bp->b_ops->verify_read(bp);
> +			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> +		}

Same comment here.

Brian

> +		return bp;
> +	}
>  	bp->b_ops = ops;
>  	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
>  		return bp;
> @@ -793,8 +816,10 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
>  	error = libxfs_readbufr_map(btp, bp, flags);
>  	if (!error) {
>  		bp->b_flags |= LIBXFS_B_UPTODATE;
> -		if (bp->b_ops)
> +		if (bp->b_ops) {
>  			bp->b_ops->verify_read(bp);
> +			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> +		}
>  	}
>  #ifdef IO_DEBUG
>  	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
> @@ -889,6 +914,7 @@ libxfs_writebufr(xfs_buf_t *bp)
>  	if (!error) {
>  		bp->b_flags |= LIBXFS_B_UPTODATE;
>  		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT);
> +		bp->b_flags &= ~LIBXFS_B_UNCHECKED;
>  	}
>  	return error;
>  }
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 6d6d344..d794ba3 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -389,6 +389,7 @@ pf_read_inode_dirs(
>  
>  	bp->b_ops = &xfs_inode_buf_ops;
>  	bp->b_ops->verify_read(bp);
> +	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
>  	if (bp->b_error)
>  		return;
>  
> @@ -460,6 +461,7 @@ pf_read_discontig(
>  
>  	pthread_mutex_unlock(&args->lock);
>  	libxfs_readbufr_map(mp->m_ddev_targp, bp, 0);
> +	bp->b_flags |= LIBXFS_B_UNCHECKED;
>  	libxfs_putbuf(bp);
>  	pthread_mutex_lock(&args->lock);
>  }
> @@ -583,6 +585,7 @@ pf_batch_read(
>  					break;
>  				memcpy(XFS_BUF_PTR(bplist[i]), pbuf, size);
>  				bplist[i]->b_flags |= LIBXFS_B_UPTODATE;
> +				bplist[i]->b_flags |= LIBXFS_B_UNCHECKED;
>  				len -= size;
>  				if (B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])))
>  					pf_read_inode_dirs(args, bplist[i]);
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
