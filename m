Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED71D199FAF
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233132; cv=none; b=aqu/tGOPYeYUmwAVAMNriyaJCun8R4xr1CpXBmELKyjWlAPed8X+X1U64Ik5ecUp92BngdSBaG7WaUe7EqVRbOcvj/MAYKu6I9DsWHHkco83cGuWDaJsmGNBf4bGzkRKE+9W5XC5qDVUCPq5EZ4R0dHd8g3saglDBBNzPmqA8Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233132; c=relaxed/simple;
	bh=Rkw/s4Yp53HYn31B5/qEPTUViAdPnPJEVfskPpOIP9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rs+/r7yXM6sw4pegAxjlocc3JVOK/c35wJ/CHR5IhnB66h2RCchE1eUQ2cgD+0faz42y23DqsUaIakNzq+9kMXc1nQyuk7QSviTuXo/nX565WVaLacK1mnYuC0x2kuqJE1bnK0ID8oQdeolCviHhqQsyRx2IgimCl/+m5W1Wv8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW6dNONf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW6dNONf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901CEC4CED6;
	Tue,  7 Jan 2025 06:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736233131;
	bh=Rkw/s4Yp53HYn31B5/qEPTUViAdPnPJEVfskPpOIP9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lW6dNONfuxa8i4ThMAoSwWit2J00l7jA30Xu7m7kqj4jTFRmk+8njd1wnudDLOPnr
	 QCT+pfeuGKHN1GPamCAq16U+Vk+tfkyp67pa+LWw72QBcLM253APkdMkUvici8aQZS
	 5msVEsPqoLorss+gY1mLxfhp8FJGIQNycIS5kd1oJuutIh1TjvREVYaHfrYJuGoKBc
	 YZLhg/SOA6tX6vF/cBa35UwqMjZTagSGtb+2Vi/kOJHUY4FqWm5+zMvNGvnzt//GcU
	 zu0FLHv3nJ1QAWX6vi8H42uJJnUY5qtMaithG/fet3V5MfoXXg6gaDCHUCugz27O06
	 XbGI25sR0PZrA==
Date: Mon, 6 Jan 2025 22:58:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: add a b_iodone callback to struct xfs_buf
Message-ID: <20250107065851.GG6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-16-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:52AM +0100, Christoph Hellwig wrote:
> Stop open coding the log item completions and instead add a callback
> into back into the submitter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, seems reasonable to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c        | 7 ++-----
>  fs/xfs/xfs_buf.h        | 5 +----
>  fs/xfs/xfs_dquot.c      | 2 +-
>  fs/xfs/xfs_inode_item.c | 2 +-
>  fs/xfs/xfs_trans_buf.c  | 8 ++++----
>  5 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1cf5d14d0d06..68a5148115e5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1394,11 +1394,8 @@ xfs_buf_ioend(
>  		if (bp->b_log_item)
>  			xfs_buf_item_done(bp);
>  
> -		if (bp->b_flags & _XBF_INODES)
> -			xfs_buf_inode_iodone(bp);
> -		else if (bp->b_flags & _XBF_DQUOTS)
> -			xfs_buf_dquot_iodone(bp);
> -
> +		if (bp->b_iodone)
> +			bp->b_iodone(bp);
>  	}
>  
>  	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index c53d27439ff2..10bf66e074a0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -34,8 +34,6 @@ struct xfs_buf;
>  #define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
>  
>  /* buffer type flags for write callbacks */
> -#define _XBF_INODES	 (1u << 16)/* inode buffer */
> -#define _XBF_DQUOTS	 (1u << 17)/* dquot buffer */
>  #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
> @@ -65,8 +63,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> -	{ _XBF_INODES,		"INODES" }, \
> -	{ _XBF_DQUOTS,		"DQUOTS" }, \
>  	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
> @@ -205,6 +201,7 @@ struct xfs_buf {
>  	unsigned int		b_offset;	/* page offset of b_addr,
>  						   only for _XBF_KMEM buffers */
>  	int			b_error;	/* error code on I/O */
> +	void			(*b_iodone)(struct xfs_buf *bp);
>  
>  	/*
>  	 * async write failure retry count. Initialised to zero on the first
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 78dde811ab16..e0a379729674 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1446,7 +1446,7 @@ xfs_qm_dqflush(
>  	 * Attach the dquot to the buffer so that we can remove this dquot from
>  	 * the AIL and release the flush lock once the dquot is synced to disk.
>  	 */
> -	bp->b_flags |= _XBF_DQUOTS;
> +	bp->b_iodone = xfs_buf_dquot_iodone;
>  	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
>  
>  	/*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4fb2e1a6ad26..e0990a8c4007 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -185,7 +185,7 @@ xfs_inode_item_precommit(
>  		xfs_buf_hold(bp);
>  		spin_lock(&iip->ili_lock);
>  		iip->ili_item.li_buf = bp;
> -		bp->b_flags |= _XBF_INODES;
> +		bp->b_iodone = xfs_buf_inode_iodone;
>  		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
>  		xfs_trans_brelse(tp, bp);
>  	}
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 8e886ecfd69a..53af546c0b23 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -659,7 +659,7 @@ xfs_trans_inode_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_INODE_BUF;
> -	bp->b_flags |= _XBF_INODES;
> +	bp->b_iodone = xfs_buf_inode_iodone;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -684,7 +684,7 @@ xfs_trans_stale_inode_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_STALE_INODE;
> -	bp->b_flags |= _XBF_INODES;
> +	bp->b_iodone = xfs_buf_inode_iodone;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -709,7 +709,7 @@ xfs_trans_inode_alloc_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
> -	bp->b_flags |= _XBF_INODES;
> +	bp->b_iodone = xfs_buf_inode_iodone;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -820,6 +820,6 @@ xfs_trans_dquot_buf(
>  		break;
>  	}
>  
> -	bp->b_flags |= _XBF_DQUOTS;
> +	bp->b_iodone = xfs_buf_dquot_iodone;
>  	xfs_trans_buf_set_type(tp, bp, type);
>  }
> -- 
> 2.45.2
> 
> 
