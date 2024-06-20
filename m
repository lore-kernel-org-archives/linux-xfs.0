Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6BA4778C
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 19:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913103; cv=none; b=uYzVKzvQIu6o4zv6OruUm0buBNQH1HgL4XGf/tI+u10I/k2vXiNQbWUnLMa9eW7fXKW4bu6TOJqeYnc+F92MSMizQvV8N07sUaSSXsVAgdRORVJP9p2wi5GRAyq7xDxgq5h7IWfvhv8PMII9/bU4Oh2khY+e0wpsip3VzUNWSxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913103; c=relaxed/simple;
	bh=I0J91rHQeh9NLSKXRcNvTVHg5UWt+YmLw8HLLbN1Dvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOdKoiJgj/Xw9cf9wBxBy69dHSTq8VAx0oRkYftZzZFF5WUyMs3mELD3t1Mb5OllUKZBdambRl2FNKnnsCRatJZQHHs6KtbnMBmQPHiwfsVcSj6T/TBNzAgM314IGcyjhhhuGNhbsOG0PeHDctL0KM479tvwcDltebOZDS/hfYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3pYXFAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3pYXFAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BDEC2BD10;
	Thu, 20 Jun 2024 19:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718913103;
	bh=I0J91rHQeh9NLSKXRcNvTVHg5UWt+YmLw8HLLbN1Dvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F3pYXFAro2p10tnLsoqZDO3kdzvGf6x7AlOHwGWXhc9yX/vCNhmYGQuCzw/LJ6GRS
	 49yMYWJFAHuzApjmYe9YQRSsoEPt8/rFOh4KgGWR1x2JKuXtCWAs4dsURwvo6+pQJ1
	 onurthwbhmpsCvXZYi9Mipuq3ABpVotiBPEFIyfj07rRqi1OsoBYHH2/AEUxQ+p21Y
	 SxBUyLBmKw+eCarqhEzn8e4dLCfHBa+5N6ZXG24qWOeU7ddmMZmgkG5wMdB449iqjq
	 1I+zhqGUMpYanSLrci0j4Q9Th+Cy9TUeVZw2o8PgXT+Ygvw/sLm3c0q6jeCNhcZkyd
	 sQPMW56GhVdDQ==
Date: Thu, 20 Jun 2024 12:51:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: skip flushing log items during push
Message-ID: <20240620195142.GG103034@frogsfrogsfrogs>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620072146.530267-12-hch@lst.de>

On Thu, Jun 20, 2024 at 09:21:28AM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AIL pushing code spends a huge amount of time skipping over
> items that are already marked as flushing. It is not uncommon to
> see hundreds of thousands of items skipped every second due to inode
> clustering marking all the inodes in a cluster as flushing when the
> first one is flushed.
> 
> However, to discover an item is already flushing and should be
> skipped we have to call the iop_push() method for it to try to flush
> the item. For inodes (where this matters most), we have to first
> check that inode is flushable first.
> 
> We can optimise this overhead away by tracking whether the log item
> is flushing internally. This allows xfsaild_push() to check the log
> item directly for flushing state and immediately skip the log item.
> Whilst this doesn't remove the CPU cache misses for loading the log
> item, it does avoid the overhead of an indirect function call
> and the cache misses involved in accessing inode and
> backing cluster buffer structures to determine flushing state. When
> trying to flush hundreds of thousands of inodes each second, this
> CPU overhead saving adds up quickly.
> 
> It's so noticeable that the biggest issue with pushing on the AIL on
> fast storage becomes the 10ms back-off wait when we hit enough
> pinned buffers to break out of the push loop but not enough for the
> AIL pushing to be considered stuck. This limits the xfsaild to about
> 70% total CPU usage, and on fast storage this isn't enough to keep
> the storage 100% busy.
> 
> The xfsaild will block on IO submission on slow storage and so is
> self throttling - it does not need a backoff in the case where we
> are really just breaking out of the walk to submit the IO we have
> gathered.
> 
> Further with no backoff we don't need to gather huge delwri lists to
> mitigate the impact of backoffs, so we can submit IO more frequently
> and reduce the time log items spend in flushing state by breaking
> out of the item push loop once we've gathered enough IO to batch
> submission effectively.

Is that what the new count > 1000 branch does?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c      | 1 +
>  fs/xfs/xfs_inode_item.c | 6 +++++-

Does it make sense to do this for buffer or dquot items too?

Modulo my questions, the rest of the changes in this series look sensible.

--D

>  fs/xfs/xfs_trans.h      | 4 +++-
>  fs/xfs/xfs_trans_ail.c  | 8 +++++++-
>  4 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 58fb7a5062e1e6..da611ec56f1be0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3713,6 +3713,7 @@ xfs_iflush(
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
> +	set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
>  	spin_unlock(&iip->ili_lock);
>  
>  	/*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f28d653300d124..ba49e56820f0a7 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -933,6 +933,7 @@ xfs_iflush_finish(
>  		}
>  		iip->ili_last_fields = 0;
>  		iip->ili_flush_lsn = 0;
> +		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
>  		spin_unlock(&iip->ili_lock);
>  		xfs_iflags_clear(iip->ili_inode, XFS_IFLUSHING);
>  		if (drop_buffer)
> @@ -991,8 +992,10 @@ xfs_buf_inode_io_fail(
>  {
>  	struct xfs_log_item	*lip;
>  
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>  		set_bit(XFS_LI_FAILED, &lip->li_flags);
> +		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
> +	}
>  }
>  
>  /*
> @@ -1011,6 +1014,7 @@ xfs_iflush_abort_clean(
>  	iip->ili_flush_lsn = 0;
>  	iip->ili_item.li_buf = NULL;
>  	list_del_init(&iip->ili_item.li_bio_list);
> +	clear_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 1636663707dc04..20eb6ea7ebaa04 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -58,13 +58,15 @@ struct xfs_log_item {
>  #define	XFS_LI_FAILED	2
>  #define	XFS_LI_DIRTY	3
>  #define	XFS_LI_WHITEOUT	4
> +#define	XFS_LI_FLUSHING	5
>  
>  #define XFS_LI_FLAGS \
>  	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
>  	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
>  	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
>  	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
> -	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
> +	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }, \
> +	{ (1u << XFS_LI_FLUSHING),	"FLUSHING" }
>  
>  struct xfs_item_ops {
>  	unsigned flags;
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 6a106a05fae017..0fafcc9f3dbe44 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -512,6 +512,9 @@ xfsaild_push(
>  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
>  		int	lock_result;
>  
> +		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
> +			goto next_item;
> +
>  		/*
>  		 * Note that iop_push may unlock and reacquire the AIL lock.  We
>  		 * rely on the AIL cursor implementation to be able to deal with
> @@ -581,9 +584,12 @@ xfsaild_push(
>  		if (stuck > 100)
>  			break;
>  
> +next_item:
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
>  		if (lip == NULL)
>  			break;
> +		if (lip->li_lsn != lsn && count > 1000)
> +			break;
>  		lsn = lip->li_lsn;
>  	}
>  
> @@ -620,7 +626,7 @@ xfsaild_push(
>  		/*
>  		 * Assume we have more work to do in a short while.
>  		 */
> -		tout = 10;
> +		tout = 0;
>  	}
>  
>  	return tout;
> -- 
> 2.43.0
> 
> 
