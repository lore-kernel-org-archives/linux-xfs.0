Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 18:47:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA11lVP1001312
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 18:47:34 -0700
Message-ID: <4729304A.2010202@sgi.com>
Date: Thu, 01 Nov 2007 12:47:54 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] fix transaction overrun during writeback
References: <20071029234010.GU995458@sgi.com>
In-Reply-To: <20071029234010.GU995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

Looks good Dave.  Since this is a writeback path is there some way
we can tell xfs_bmapi() that it should not convert anything but
delayed allocs and have it assert/error out if it tries to - not
that it will now with this change but just as defensive measure?

David Chinner wrote:
> Prevent transaction overrun in xfs_iomap_write_allocate() if we
> rce with a truncate that overlaps the delalloc range we were
> planning to allocate.
> 
> If we race, we may allocate into a hole and that requires block
> allocation. At this point in time we don't have a reservation for
> block allocation (apart from metadata blocks) and so allocating
> into a hole rather than a delalloc region results in overflowing
> the transaction block reservation.
> 
> Fix it by only allowing a single extent to be allocated at a
> time.
> 
> Signed-Off-By: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_iomap.c |   75 +++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 50 insertions(+), 25 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_iomap.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_iomap.c	2007-10-30 10:18:58.777772241 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_iomap.c	2007-10-30 10:19:30.365685668 +1100
> @@ -702,6 +702,9 @@ retry:
>   * the originating callers request.
>   *
>   * Called without a lock on the inode.
> + *
> + * We no longer bother to look at the incoming map - all we have to
> + * guarantee is that whatever we allocate fills the required range.
>   */
>  int
>  xfs_iomap_write_allocate(
> @@ -717,9 +720,9 @@ xfs_iomap_write_allocate(
>  	xfs_fsblock_t	first_block;
>  	xfs_bmap_free_t	free_list;
>  	xfs_filblks_t	count_fsb;
> -	xfs_bmbt_irec_t	imap[XFS_STRAT_WRITE_IMAPS];
> +	xfs_bmbt_irec_t	imap;
>  	xfs_trans_t	*tp;
> -	int		i, nimaps, committed;
> +	int		nimaps, committed;
>  	int		error = 0;
>  	int		nres;
>  
> @@ -766,13 +769,38 @@ xfs_iomap_write_allocate(
>  
>  			XFS_BMAP_INIT(&free_list, &first_block);
>  
> -			nimaps = XFS_STRAT_WRITE_IMAPS;
>  			/*
> -			 * Ensure we don't go beyond eof - it is possible
> -			 * the extents changed since we did the read call,
> -			 * we dropped the ilock in the interim.
> +			 * it is possible that the extents have changed since
> +			 * we did the read call as we dropped the ilock for a
> +			 * while. We have to be careful about truncates or hole
> +			 * punchs here - we are not allowed to allocate
> +			 * non-delalloc blocks here.
> +			 *
> +			 * The only protection against truncation is the pages
> +			 * for the range we are being asked to convert are
> +			 * locked and hence a truncate will block on them
> +			 * first.
> +			 *
> +			 * As a result, if we go beyond the range we really
> +			 * need and hit an delalloc extent boundary followed by
> +			 * a hole while we have excess blocks in the map, we
> +			 * will fill the hole incorrectly and overrun the
> +			 * transaction reservation.
> +			 *
> +			 * Using a single map prevents this as we are forced to
> +			 * check each map we look for overlap with the desired
> +			 * range and abort as soon as we find it. Also, given
> +			 * that we only return a single map, having one beyond
> +			 * what we can return is probably a bit silly.
> +			 *
> +			 * We also need to check that we don't go beyond EOF;
> +			 * this is a truncate optimisation as a truncate sets
> +			 * the new file size before block on the pages we
> +			 * currently have locked under writeback. Because they
> +			 * are about to be tossed, we don't need to write them
> +			 * back....
>  			 */
> -
> +			nimaps = 1;
>  			end_fsb = XFS_B_TO_FSB(mp, ip->i_size);
>  			xfs_bmap_last_offset(NULL, ip, &last_block,
>  				XFS_DATA_FORK);
> @@ -788,7 +816,7 @@ xfs_iomap_write_allocate(
>  			/* Go get the actual blocks */
>  			error = xfs_bmapi(tp, ip, map_start_fsb, count_fsb,
>  					XFS_BMAPI_WRITE, &first_block, 1,
> -					imap, &nimaps, &free_list, NULL);
> +					&imap, &nimaps, &free_list, NULL);
>  			if (error)
>  				goto trans_cancel;
>  
> @@ -807,27 +835,24 @@ xfs_iomap_write_allocate(
>  		 * See if we were able to allocate an extent that
>  		 * covers at least part of the callers request
>  		 */
> -		for (i = 0; i < nimaps; i++) {
> -			if (unlikely(!imap[i].br_startblock &&
> -				     !(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)))
> -				return xfs_cmn_err_fsblock_zero(ip, &imap[i]);
> -			if ((offset_fsb >= imap[i].br_startoff) &&
> -			    (offset_fsb < (imap[i].br_startoff +
> -					   imap[i].br_blockcount))) {
> -				*map = imap[i];
> -				*retmap = 1;
> -				XFS_STATS_INC(xs_xstrat_quick);
> -				return 0;
> -			}
> -			count_fsb -= imap[i].br_blockcount;
> +		if (unlikely(!imap.br_startblock &&
> +			     XFS_IS_REALTIME_INODE(ip)))
> +			return xfs_cmn_err_fsblock_zero(ip, &imap);
> +		if ((offset_fsb >= imap.br_startoff) &&
> +		    (offset_fsb < (imap.br_startoff +
> +				   imap.br_blockcount))) {
> +			*map = imap;
> +			*retmap = 1;
> +			XFS_STATS_INC(xs_xstrat_quick);
> +			return 0;
>  		}
>  
> -		/* So far we have not mapped the requested part of the
> +		/*
> +		 * So far we have not mapped the requested part of the
>  		 * file, just surrounding data, try again.
>  		 */
> -		nimaps--;
> -		map_start_fsb = imap[nimaps].br_startoff +
> -				imap[nimaps].br_blockcount;
> +		count_fsb -= imap.br_blockcount;
> +		map_start_fsb = imap.br_startoff + imap.br_blockcount;
>  	}
>  
>  trans_cancel:
> 
