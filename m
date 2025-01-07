Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DDC18B46C
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232948; cv=none; b=ZIGx2WhkaweCz6W81WcNeLGGct/z/szERlgqWNwH9P18TD0vYLGsuMIiAwjME1ITWhF3Wx1TYQmpC9s/VWmaIQfD/W+o2lMIhgE1Opq05RJoqN5uUlgWFz5xeCA9SwPz1+44d7NWukmjski8oz5FFC5983TGwa1ZJHtRvdQBUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232948; c=relaxed/simple;
	bh=y8VF7B6WbAaszX5HVP1iRCaaau63KBxFM6r7sxe3sZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvaXMzQkb8R1inw41+gMGWAlY6F47GlWT71AzKmhWlrmT23zrSpw9lNc7eY0pKYpcgEyexvPPgFeTRJgLSLCMO5gxMm4iXK3ykYvKXqEloSDN8DvS9EqDHvMgNUEVJWmnPH5LHFSo6IoZxi0sVAz9eHioa5Ckg+uhaArBfCewRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cw+LevFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cw+LevFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F5C4CED6;
	Tue,  7 Jan 2025 06:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736232948;
	bh=y8VF7B6WbAaszX5HVP1iRCaaau63KBxFM6r7sxe3sZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cw+LevFM6BxtrgszanJW6Whj0+g+caNM9w8cnZIZy4lOmHfLzl+aBP5xVQpv0V7lt
	 mhebZE9TpPB8NS87r4wkZoHpnhk6RD2R99AoEXisVi1d/tcEP6gbSo6m+dQWLBcgsq
	 ZJSu3ZFFt7LT4C/BC9Rl8H5p/BLdNQHPRanmUpkDp+vjuRM85eyb9MngKEepcL3zeg
	 KfA5h7LDAtuBdtjIVNgykUo2pAz14PaiAnHQIm/c2TX2BqzxXF3oi7OhqBW3T5jKF3
	 MXoRaoSFGRX2vsVE0ba9FYNt4S5cbwXLnrvg+BLjoLz6q2V8m5BIF3MCZorAX9QLnv
	 I9wZMLchPvJDQ==
Date: Mon, 6 Jan 2025 22:55:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: move b_li_list based retry handling to common
 code
Message-ID: <20250107065547.GE6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-15-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:51AM +0100, Christoph Hellwig wrote:
> The dquot and inode version are very similar, which is expected given the
> overall b_li_list logic.  The differences are that the inode version also
> clears the XFS_LI_FLUSHING which is defined in common but only ever set
> by the inode item, and that the dquot version takes the ail_lock over
> the list iteration.  While this seems sensible given that additions and
> removals from b_li_list are protected by the ail_lock, log items are
> only added before buffer submission, and are only removed when completing
> the buffer, so nothing can change the list when retrying a buffer.

Heh, I think that's not quite true -- I think xfs_dquot_detach_buf
actually has a bug where it needs to take the buffer lock before
detaching the dquot from the b_li_list.  And I think kfence just whacked
me for that on tonight's fstests run.

But that's neither here nor there.  Moving along...

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c        | 12 ++++++------
>  fs/xfs/xfs_buf_item.h   |  5 -----
>  fs/xfs/xfs_dquot.c      | 12 ------------
>  fs/xfs/xfs_inode_item.c | 12 ------------
>  4 files changed, 6 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0ad3cacfdba1..1cf5d14d0d06 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1288,6 +1288,7 @@ xfs_buf_ioend_handle_error(
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_error_cfg	*cfg;
> +	struct xfs_log_item	*lip;
>  
>  	/*
>  	 * If we've already shutdown the journal because of I/O errors, there's
> @@ -1335,12 +1336,11 @@ xfs_buf_ioend_handle_error(
>  	}
>  
>  	/* Still considered a transient error. Caller will schedule retries. */
> -	if (bp->b_flags & _XBF_INODES)
> -		xfs_buf_inode_io_fail(bp);
> -	else if (bp->b_flags & _XBF_DQUOTS)
> -		xfs_buf_dquot_io_fail(bp);
> -	else
> -		ASSERT(list_empty(&bp->b_li_list));
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> +		set_bit(XFS_LI_FAILED, &lip->li_flags);
> +		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);

Should dquot log items be setting XFS_LI_FLUSHING?

--D

> +	}
> +
>  	xfs_buf_ioerror(bp, 0);
>  	xfs_buf_relse(bp);
>  	return true;
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 4d8a6aece995..8cde85259a58 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -54,17 +54,12 @@ bool	xfs_buf_item_put(struct xfs_buf_log_item *);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
> -void	xfs_buf_inode_io_fail(struct xfs_buf *bp);
>  #ifdef CONFIG_XFS_QUOTA
>  void	xfs_buf_dquot_iodone(struct xfs_buf *);
> -void	xfs_buf_dquot_io_fail(struct xfs_buf *bp);
>  #else
>  static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
>  {
>  }
> -static inline void xfs_buf_dquot_io_fail(struct xfs_buf *bp)
> -{
> -}
>  #endif /* CONFIG_XFS_QUOTA */
>  void	xfs_buf_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index f11d475898f2..78dde811ab16 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1229,18 +1229,6 @@ xfs_buf_dquot_iodone(
>  	}
>  }
>  
> -void
> -xfs_buf_dquot_io_fail(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_log_item	*lip;
> -
> -	spin_lock(&bp->b_mount->m_ail->ail_lock);
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> -		set_bit(XFS_LI_FAILED, &lip->li_flags);
> -	spin_unlock(&bp->b_mount->m_ail->ail_lock);
> -}
> -
>  /* Check incore dquot for errors before we flush. */
>  static xfs_failaddr_t
>  xfs_qm_dqflush_check(
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 912f0b1bc3cb..4fb2e1a6ad26 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -1023,18 +1023,6 @@ xfs_buf_inode_iodone(
>  		list_splice_tail(&flushed_inodes, &bp->b_li_list);
>  }
>  
> -void
> -xfs_buf_inode_io_fail(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_log_item	*lip;
> -
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> -		set_bit(XFS_LI_FAILED, &lip->li_flags);
> -		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
> -	}
> -}
> -
>  /*
>   * Clear the inode logging fields so no more flushes are attempted.  If we are
>   * on a buffer list, it is now safe to remove it because the buffer is
> -- 
> 2.45.2
> 
> 
