Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1431D69F
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705618510; cv=none; b=pFgcyXCjTUIc8yh8tprIRNqoo3GXuKMqxHEt17ybTs0TvztYOm0J2JmcEGppKYnm/29fe+bGZT+T0yOum3Q3Kr7v+L+Ef57W7wYZoM5IdNmIJrtB1MlrV6bzmPC3YWT1LA3GTV/Wd4yO5TsiH3Srsbio8QXSjvV98TCbXzRkpZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705618510; c=relaxed/simple;
	bh=6Xc+hJEOHcGZNL60PrMUfAVBgiMTqZn8i1oGmkQOc+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKcu9zaeXqD6yvxE155Qj/klw/y4BSZlIU5mgcDUtcU7iusH0awbXo/nfvoN0uTiQOiQTJ5PlY2RQxCYcxnxoxNuGQPdu7IDnHoVS7D9/iQjc9g9a98tG2YfU1nwcgPQyOfrLqIsARTpdNjLmq+vrpXurFmyPT0sTvvMT82EaM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmO/y/jY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmO/y/jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7291FC433C7;
	Thu, 18 Jan 2024 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705618509;
	bh=6Xc+hJEOHcGZNL60PrMUfAVBgiMTqZn8i1oGmkQOc+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tmO/y/jY9e4gzstbCXFK/w0BjT0CPzWa5hDJ90qZ5MUhvj11JkyEbnn/WTqsgPM6M
	 yEIT2ghSHHzO4k3dIXio42BtBzBX9OyA1fwpNRHjfan+sYGoTOzNdENviVcRx+GdGo
	 G3FgLfhgE5qXqnTqyw4mXeT8nyI/xFJSyzquo55YcOefjmyRKTq3t39LVybwrfUDf3
	 IWGD+/sLdnUuLX69e7q0cYw3tXKfdMkvjmHTbmMba3mWwH1wlIKlPgjV9FBK1Na5id
	 XYFXXV6g6mPcO6qgWB4U+jD9g5u2Ga76hMDn1t10FlFZTBmdgIrWMTFSptoTXw0zvp
	 V3JTudBg4p58w==
Date: Thu, 18 Jan 2024 14:55:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/12] xfs: use an empty transaction for fstrim
Message-ID: <20240118225508.GI674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-7-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-7-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:44AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently use a btree walk in the fstrim code. This requires a
> btree cursor and btree cursors are only used inside transactions
> except for the fstrim code. This means that all the btree operations
> that allocate memory operate in both GFP_KERNEL and GFP_NOFS
> contexts.
> 
> This causes problems with lockdep being unable to determine the
> difference between objects that are safe to lock both above and
> below memory reclaim. Free space btree buffers are definitely locked
> both above and below reclaim and that means we have to mark all
> btree infrastructure allocations with GFP_NOFS to avoid potential
> lockdep false positives.
> 
> If we wrap this btree walk in an empty cursor, all btree walks are
> now done under transaction context and so all allocations inherit
> GFP_NOFS context from the tranaction. This enables us to move all
> the btree allocations to GFP_KERNEL context and hence help remove
> the explicit use of GFP_NOFS in XFS.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

LOL I just wrote this exact patch to shut up lockdep.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 8539f5c9a774..299b8f907292 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -8,6 +8,7 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> +#include "xfs_trans.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_alloc_btree.h"
> @@ -120,7 +121,7 @@ xfs_discard_extents(
>  		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
>  				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
>  				XFS_FSB_TO_BB(mp, busyp->length),
> -				GFP_NOFS, &bio);
> +				GFP_KERNEL, &bio);
>  		if (error && error != -EOPNOTSUPP) {
>  			xfs_info(mp,
>  	 "discard failed for extent [0x%llx,%u], error %d",
> @@ -155,6 +156,7 @@ xfs_trim_gather_extents(
>  	uint64_t		*blocks_trimmed)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_trans	*tp;
>  	struct xfs_btree_cur	*cur;
>  	struct xfs_buf		*agbp;
>  	int			error;
> @@ -168,11 +170,15 @@ xfs_trim_gather_extents(
>  	 */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
> +	error = xfs_trans_alloc_empty(mp, &tp);
>  	if (error)
>  		return error;
>  
> -	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
> +	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
> +	if (error)
> +		goto out_trans_cancel;
> +
> +	cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_CNT);
>  
>  	/*
>  	 * Look up the extent length requested in the AGF and start with it.
> @@ -279,7 +285,8 @@ xfs_trim_gather_extents(
>  		xfs_extent_busy_clear(mp, &extents->extent_list, false);
>  out_del_cursor:
>  	xfs_btree_del_cursor(cur, error);
> -	xfs_buf_relse(agbp);
> +out_trans_cancel:
> +	xfs_trans_cancel(tp);
>  	return error;
>  }
>  
> -- 
> 2.43.0
> 
> 
