Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BB2C636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 23:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjBAXQz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 18:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBAXQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 18:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000CF6F209
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 15:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F246BB821C8
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 23:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9843EC433EF;
        Wed,  1 Feb 2023 23:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675293315;
        bh=+CKybYLjRT9R3sjgSBk+HnqEaDE0iw3voslPe8wpckw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k4K5vreTJcjmkoZnll+Aub7NPNXhG8BgfRG+hI4ua0yJz7xj+bkIilP8xuJcfrSP9
         mXcQOdNocT/5QCzYYhw47DDkfYRiySUzCA4gPBRDB9othaDNaXnpJOIo95IUVBclMO
         YnNHU85ZUtKLjDLjqo8UcC+uxLECp0yWMzZboIaAyPQYq3c5W8IHXW8/V1nrDdk0K7
         1j1q56618M3ZaFVcW9+JkThKrWYCXAmThT0zRKhiREErJaf9DlrdQ9KSOEZZ6G4Vgz
         +GhzHmYKXzki8NR+9IEIbPSOsnPsWDQPmJ8YqIzObdqfW3NgSnogZIu/xYOcQHcFz+
         NRUkL04ccRogg==
Date:   Wed, 1 Feb 2023 15:15:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/42] xfs: convert trim to use for_each_perag_range
Message-ID: <Y9ryg5lY702fdLXL@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-30-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-30-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:52AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To convert it to using active perag references and hence make it
> shrink safe.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c | 50 ++++++++++++++++++++------------------------
>  1 file changed, 23 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index bfc829c07f03..afc4c78b9eed 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -21,23 +21,20 @@
>  
>  STATIC int
>  xfs_trim_extents(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_daddr_t		start,
>  	xfs_daddr_t		end,
>  	xfs_daddr_t		minlen,
>  	uint64_t		*blocks_trimmed)
>  {
> +	struct xfs_mount	*mp = pag->pag_mount;
>  	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
>  	struct xfs_btree_cur	*cur;
>  	struct xfs_buf		*agbp;
>  	struct xfs_agf		*agf;
> -	struct xfs_perag	*pag;
>  	int			error;
>  	int			i;
>  
> -	pag = xfs_perag_get(mp, agno);
> -
>  	/*
>  	 * Force out the log.  This means any transactions that might have freed

This is a tangent, but one thing I've wondered is if it's really
necessary to force the log for *every* AG that we want to trim?  Even if
we've just come from trimming the previous AG?

Looks good otherwise,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	 * space before we take the AGF buffer lock are now on disk, and the
> @@ -47,7 +44,7 @@ xfs_trim_extents(
>  
>  	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
>  	if (error)
> -		goto out_put_perag;
> +		return error;
>  	agf = agbp->b_addr;
>  
>  	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
> @@ -71,10 +68,10 @@ xfs_trim_extents(
>  
>  		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
>  		if (error)
> -			goto out_del_cursor;
> +			break;
>  		if (XFS_IS_CORRUPT(mp, i != 1)) {
>  			error = -EFSCORRUPTED;
> -			goto out_del_cursor;
> +			break;
>  		}
>  		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
>  
> @@ -83,15 +80,15 @@ xfs_trim_extents(
>  		 * the format the range/len variables are supplied in by
>  		 * userspace.
>  		 */
> -		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
> +		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
>  		dlen = XFS_FSB_TO_BB(mp, flen);
>  
>  		/*
>  		 * Too small?  Give up.
>  		 */
>  		if (dlen < minlen) {
> -			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
> -			goto out_del_cursor;
> +			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
> +			break;
>  		}
>  
>  		/*
> @@ -100,7 +97,7 @@ xfs_trim_extents(
>  		 * down partially overlapping ranges for now.
>  		 */
>  		if (dbno + dlen < start || dbno > end) {
> -			trace_xfs_discard_exclude(mp, agno, fbno, flen);
> +			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
>  			goto next_extent;
>  		}
>  
> @@ -109,32 +106,30 @@ xfs_trim_extents(
>  		 * discard and try again the next time.
>  		 */
>  		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
> -			trace_xfs_discard_busy(mp, agno, fbno, flen);
> +			trace_xfs_discard_busy(mp, pag->pag_agno, fbno, flen);
>  			goto next_extent;
>  		}
>  
> -		trace_xfs_discard_extent(mp, agno, fbno, flen);
> +		trace_xfs_discard_extent(mp, pag->pag_agno, fbno, flen);
>  		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
>  		if (error)
> -			goto out_del_cursor;
> +			break;
>  		*blocks_trimmed += flen;
>  
>  next_extent:
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
> -			goto out_del_cursor;
> +			break;
>  
>  		if (fatal_signal_pending(current)) {
>  			error = -ERESTARTSYS;
> -			goto out_del_cursor;
> +			break;
>  		}
>  	}
>  
>  out_del_cursor:
>  	xfs_btree_del_cursor(cur, error);
>  	xfs_buf_relse(agbp);
> -out_put_perag:
> -	xfs_perag_put(pag);
>  	return error;
>  }
>  
> @@ -152,11 +147,12 @@ xfs_ioc_trim(
>  	struct xfs_mount		*mp,
>  	struct fstrim_range __user	*urange)
>  {
> +	struct xfs_perag	*pag;
>  	unsigned int		granularity =
>  		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
>  	struct fstrim_range	range;
>  	xfs_daddr_t		start, end, minlen;
> -	xfs_agnumber_t		start_agno, end_agno, agno;
> +	xfs_agnumber_t		agno;
>  	uint64_t		blocks_trimmed = 0;
>  	int			error, last_error = 0;
>  
> @@ -193,18 +189,18 @@ xfs_ioc_trim(
>  	end = start + BTOBBT(range.len) - 1;
>  
>  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> -		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
> -
> -	start_agno = xfs_daddr_to_agno(mp, start);
> -	end_agno = xfs_daddr_to_agno(mp, end);
> +		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
>  
> -	for (agno = start_agno; agno <= end_agno; agno++) {
> -		error = xfs_trim_extents(mp, agno, start, end, minlen,
> +	agno = xfs_daddr_to_agno(mp, start);
> +	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
> +		error = xfs_trim_extents(pag, start, end, minlen,
>  					  &blocks_trimmed);
>  		if (error) {
>  			last_error = error;
> -			if (error == -ERESTARTSYS)
> +			if (error == -ERESTARTSYS) {
> +				xfs_perag_rele(pag);
>  				break;
> +			}
>  		}
>  	}
>  
> -- 
> 2.39.0
> 
