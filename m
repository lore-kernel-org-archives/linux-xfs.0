Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Feb 2007 04:24:40 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l12COWqw007203
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 04:24:33 -0800
Date: Fri, 2 Feb 2007 11:46:23 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: freezing sometimes leaves the log dirty
Message-ID: <20070202114623.GA23187@infradead.org>
References: <20070130220326.GM33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130220326.GM33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Wed, Jan 31, 2007 at 09:03:26AM +1100, David Chinner wrote:
> -	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE))
> -		flags = SYNC_QUIESCE;
> -	else
> +	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
> +		/*
> +		 * First stage of freeze - no more writers will make progress
> +		 * now we are here, so we flush delwri and delalloc buffers
> +		 * here, then wait for all I/O to complete.  Data is frozen at
> +		 * that point. Metadata is not frozen, transactions can still
> +		 * occur here so don't bother flushing the buftarg (i.e
> +		 * SYNC_QUIESCE) because it'll just get dirty again.
> +		 */
> +		flags = SYNC_FSDATA | SYNC_DELWRI | SYNC_WAIT | SYNC_DIO_WAIT;
> +	} else

You remove all uses of SYNC_QUIESCE in this patch, so please kill the
definition aswell.

> + *	SYNC_DIO_WAIT - The caller wants us to wait for all direct I/Os
> + *		       as well to ensure all data I/O completes before we
> + *		       return. Forms the drain side of the write barrier needed
> + *		       to safely quiesce the filesystem.
>   *
>   */
>  /*ARGSUSED*/
> @@ -892,10 +896,7 @@ xfs_sync(
>  {
>  	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
>  
> -	if (unlikely(flags == SYNC_QUIESCE))
> -		return xfs_quiesce_fs(mp);
> -	else
> -		return xfs_syncsub(mp, flags, NULL);
> +	return xfs_syncsub(mp, flags, NULL);
>  }
>  
>  /*
> @@ -1181,6 +1182,12 @@ xfs_sync_inodes(
>  			}
>  
>  		}
> +		/*
> +		 * When freezing, we need to wait ensure direct I/O is complete
> +		 * as well to ensure all data modification is complete here
> +		 */
> +		if (flags & SYNC_DIO_WAIT)
> +			vn_iowait(vp);

vn_iowait waits for v_iocount decrementing to zero.  We use v_iocount
for tracking ioend structures that are used both for buffered and direct
I/O.  Because of that the flag should probably be SYNC_IOWAIT and the comment
updated to reflect this.

> +/*
> + * Second stage of a freeze. The data is already frozen, now we have to take
> + * care of the metadata. New transactions are already blocked, so we need to
> + * wait for any remaining transactions to drain out before proceding.
> + */
>  STATIC void
>  xfs_freeze(
>  	bhv_desc_t	*bdp)
>  {
>  	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
>  
> +	/* wait for all modifications to complete */
>  	while (atomic_read(&mp->m_active_trans) > 0)
>  		delay(100);
>  
> +	/* flush inodes and push all remaining buffers out to disk */
> +	xfs_quiesce_fs(mp);
> +
> +	BUG_ON(atomic_read(&mp->m_active_trans) > 0);
> +

xfs_vfsops.c is considered common code, so you should probably use
ASSERT here, not BUG_ON.
