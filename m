Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFEBB7CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 09:37:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8DFBD304051
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 07:37:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 34TAy5KEpOtnIwO5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 07:37:11 -0700 (PDT)
Date: Thu, 25 Aug 2016 10:37:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: rewrite and optimize the delalloc write path
Message-ID: <20160825143708.GD25041@bfoster.bfoster>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471816273-28940-5-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 21, 2016 at 11:51:13PM +0200, Christoph Hellwig wrote:
> Currently xfs_iomap_write_delay does up to lookups in the inode extent
> tree, which is rather costly especially with the new iomap based
> write path and small write sizes.
> 
> But it turns out that the low-level xfs_bmap_search_extents gives us all
> the information we need in the regular delalloc buffered write path:
> 
>  - it will return us an extent covering the block we are looking up if
>    it exists.  In that case we can simply return that extent to the
>    caller and are done
>  - it will tell us if we are beyoned the last current allocated block
>    with an eof return parameter.  In that case we can create a delalloc
>    reservation and use the also returned information about the last
>    extent in the file as the hint to size our delalloc reservation.
>  - it can tell us that we are writing into a hole, but that there is
>    an extent beyoned this hole.  In this case we can create a delalloc
>    reservation that covers the requested size (possible capped to the
>    next existing allocation).
> 
> All that can be done in one single routine instead of bouncing up
> and down a few layers.  This reduced the CPU overhead of the block
> mapping routines and also simplified the code a lot.
> 

On just skimming over this so far, I feel like this should be at least
two patches, possibly 3:

- Kill xfs_bmapi_delay() and pull up associated bits to iomap().
- Possibly separate out the part that moves iteration from the (former)
  xfs_bmapi_delay() code up to the iomap code, if we can do so cleanly.
- Refactor/rework the preallocate logic.

With regard to the latter...

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |  89 +----------
>  fs/xfs/libxfs/xfs_bmap.h |  10 +-
>  fs/xfs/xfs_iomap.c       | 381 ++++++++++++++++++++---------------------------
>  fs/xfs/xfs_iomap.h       |   2 -
>  4 files changed, 169 insertions(+), 313 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 918511a..2b449f5 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
...
> @@ -587,120 +480,167 @@ xfs_iomap_prealloc_size(
...
> -int
> -xfs_iomap_write_delay(
> -	xfs_inode_t	*ip,
> -	xfs_off_t	offset,
> -	size_t		count,
> -	xfs_bmbt_irec_t *ret_imap)
> +static int
> +xfs_file_iomap_begin_delay(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	loff_t			count,
> +	unsigned		flags,
> +	struct iomap		*iomap)
>  {
...
> +	/*
> +	 * If we are doing a write at the end of the file and there are no
> +	 * allocations past this one, then extend the allocation out to the
> +	 * file system's write iosize.
> +	 *
> +	 * As an exception we don't do any preallocation at all if the file
> +	 * is smaller than the minimum preallocation and we are using the
> +	 * default dynamic preallocation scheme, as it is likely this is the
> +	 * only write to the file that is going to be done.
> +	 *
> +	 * We clean up any extra space left over when the file is closed in
> +	 * xfs_inactive().
> +	 */
> +	if (eof && offset + count > XFS_ISIZE(ip) &&
> +	    ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
> +	     XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, mp->m_writeio_blocks))) {
> +		xfs_fsblock_t		alloc_blocks;
> +		xfs_off_t		aligned_offset;
> +		xfs_extlen_t		align;
> +
> +		/*
> +		 * If an explicit allocsize is set, the file is small, or we
> +		 * are writing behind a hole, then use the minimum prealloc:
> +		 */
> +		if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
> +		    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> +		    idx == 0 ||
> +		    prev.br_startoff + prev.br_blockcount < offset_fsb)
> +			alloc_blocks = mp->m_writeio_blocks;
> +		else
> +			alloc_blocks =
> +				xfs_iomap_prealloc_size(ip, offset, &prev);
> +
> +		aligned_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
> +		end_fsb = XFS_B_TO_FSBT(mp, aligned_offset) + alloc_blocks;
> +
> +		align = xfs_eof_alignment(ip, 0);
> +		if (align)
> +			end_fsb = roundup_64(end_fsb, align);
>  
> -	ASSERT(last_fsb > offset_fsb);
> +		end_fsb = min(end_fsb, maxbytes_fsb);
> +		ASSERT(end_fsb > offset_fsb);
> +	}

I'm not necessarily against cleaning up/reworking the prealloc bits, but
I'm not a huge fan of open coding all of this here in the iomap
function. If nothing else, the indentation starts to make my eyes
cross... could we retain one level of abstraction here for this hunk of
logic that updates end_fsb?

Brian

>  
> -	nimaps = XFS_WRITE_IMAPS;
> -	error = xfs_bmapi_delay(ip, offset_fsb, last_fsb - offset_fsb,
> -				imap, &nimaps, XFS_BMAPI_ENTIRE);
> +retry:
> +	error = xfs_bmapi_reserve_delalloc(ip, offset_fsb,
> +			end_fsb - offset_fsb, &got,
> +			&prev, &idx, eof);
>  	switch (error) {
>  	case 0:
> +		break;
>  	case -ENOSPC:
>  	case -EDQUOT:
> -		break;
> -	default:
> -		return error;
> -	}
> -
> -	/*
> -	 * If bmapi returned us nothing, we got either ENOSPC or EDQUOT. Retry
> -	 * without EOF preallocation.
> -	 */
> -	if (nimaps == 0) {
> +		/* retry without any preallocation */
>  		trace_xfs_delalloc_enospc(ip, offset, count);
> -		if (prealloc) {
> -			prealloc = 0;
> -			error = 0;
> +		if (end_fsb != orig_end_fsb) {
> +			end_fsb = orig_end_fsb;
>  			goto retry;
>  		}
> -		return error ? error : -ENOSPC;
> +		/*FALLTHRU*/
> +	default:
> +		goto out_unlock;
>  	}
>  
> -	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
> -		return xfs_alert_fsblock_zero(ip, &imap[0]);
> -
>  	/*
>  	 * Tag the inode as speculatively preallocated so we can reclaim this
>  	 * space on demand, if necessary.
>  	 */
> -	if (prealloc)
> +	if (end_fsb != orig_end_fsb)
>  		xfs_inode_set_eofblocks_tag(ip);
>  
> -	*ret_imap = imap[0];
> -	return 0;
> +	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
> +done:
> +	if (isnullstartblock(got.br_startblock))
> +		got.br_startblock = DELAYSTARTBLOCK;
> +
> +	if (!got.br_startblock) {
> +		error = xfs_alert_fsblock_zero(ip, &got);
> +		if (error)
> +			goto out_unlock;
> +	}
> +
> +	xfs_bmbt_to_iomap(ip, iomap, &got);
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
>  }
>  
>  /*
> @@ -1008,6 +948,11 @@ xfs_file_iomap_begin(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	if ((flags & IOMAP_WRITE) && !xfs_get_extsz_hint(ip)) {
> +		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
> +				iomap);
> +	}
> +
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
>  	ASSERT(offset <= mp->m_super->s_maxbytes);
> @@ -1035,19 +980,13 @@ xfs_file_iomap_begin(
>  		 * the lower level functions are updated.
>  		 */
>  		length = min_t(loff_t, length, 1024 * PAGE_SIZE);
> -		if (xfs_get_extsz_hint(ip)) {
> -			/*
> -			 * xfs_iomap_write_direct() expects the shared lock. It
> -			 * is unlocked on return.
> -			 */
> -			xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
> -			error = xfs_iomap_write_direct(ip, offset, length, &imap,
> -					nimaps);
> -		} else {
> -			error = xfs_iomap_write_delay(ip, offset, length, &imap);
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		}
> -
> +		/*
> +		 * xfs_iomap_write_direct() expects the shared lock. It
> +		 * is unlocked on return.
> +		 */
> +		xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
> +		error = xfs_iomap_write_direct(ip, offset, length, &imap,
> +				nimaps);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index fb8aca3..6498be4 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -25,8 +25,6 @@ struct xfs_bmbt_irec;
>  
>  int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  			struct xfs_bmbt_irec *, int);
> -int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
> -			struct xfs_bmbt_irec *);
>  int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
>  			struct xfs_bmbt_irec *);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
