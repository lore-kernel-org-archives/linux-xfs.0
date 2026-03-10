Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12192175A7D;
	Tue, 10 Mar 2026 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773105668; cv=none; b=cyiKEODVoZs6N63SwyQmQh4WB21m+nuHFwHtC66yfnsY4xlj0ukxAcrunZBIRHBFoFX2QlcK3rdnMT0TaZwMO/MeZQtnVu0/a5m1As6SLurGU0qiQ8q3CvaYF5PolqrMi+YmzquiRHIt0Fbtw8fr+VXsFpi+ThaybYZHjXnL6/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773105668; c=relaxed/simple;
	bh=oA3hK8MkgazMf9tD9rTUUnpBrKcDiBaGBl2eU5JNzeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfk1ONVUMMEgSPRGuUBy1SR/8W+3RBav0LQgYjEC0yKWx1BqfHvySOBrTTQVMaxOKiPfuTpP2jLL1w6Krx6lSywKpBCP0YOPtzl/1E8vG4poyfoAu23m5BqWLzDJ2GhWMWuJdfY3N7VtJvgQcLRfN8/vpPl2KhMIvwuNWJOYXug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asENmNkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asENmNkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E068C4CEF7;
	Tue, 10 Mar 2026 01:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773105667;
	bh=oA3hK8MkgazMf9tD9rTUUnpBrKcDiBaGBl2eU5JNzeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=asENmNkriGpocEWNYAgWuB6DQpx8xLvAGRSfYVvjG0mQMp+SaRM+WrgOTQX1O/tx4
	 0m2ZhZ2HCLJzi7+dENZ/PfAuQ0purdd3bdWpeFa6jT2tM5Z9oVSKsNhwKX7YUgM+GS
	 tq1VOmC/nXWCpK8GpYlCm5ZvrGCiAVQ+6yXc1wYSCCftGv8XBvJxBRZott4rZEVmVy
	 jfwD3e/b479yj0hoxGb9o2gZomxcDQ927PlBzy7ybcV0iJnAn9LcY1dbPkCMin6yNY
	 Rf7wpuS+Jl/OVs9aCLKLOKQxvJ6HjUA3+YCffePiMZ/6xRtlMpAE+MbNcONU7it8zJ
	 ku4E8vFro6ahg==
Date: Mon, 9 Mar 2026 18:21:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 17/25] xfs: use read ioend for fsverity data
 verification
Message-ID: <20260310012105.GE1105363@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-18-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-18-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:32PM +0100, Andrey Albershteyn wrote:
> Use read ioends for fsverity verification. Do not issues fsverity
> metadata I/O through the same workqueue due to risk of a deadlock by a
> filled workqueue.
> 
> Pass fsverity_info from iomap context down to the ioend as hashtable
> lookups are expensive.
> 
> Add a simple helper to check that this is not fsverity metadata but file
> data that needs verification.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/xfs_aops.c     | 32 ++++++++++++++++++++++++--------
>  fs/xfs/xfs_fsverity.c | 11 +++++++++++
>  fs/xfs/xfs_fsverity.h |  6 ++++++
>  3 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9503252a0fa4..4e3dcc4a321d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -24,6 +24,7 @@
>  #include "xfs_rtgroup.h"
>  #include "xfs_fsverity.h"
>  #include <linux/bio-integrity.h>
> +#include <linux/fsverity.h>
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -204,11 +205,15 @@ xfs_end_io(
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
>  		iomap_ioend_try_merge(ioend, &tmp);
> -		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> +		if (bio_op(&ioend->io_bio) == REQ_OP_READ) {
> +			if (xfs_fsverity_is_file_data(ip, ioend->io_offset))
> +				fsverity_verify_bio(ioend->io_vi,
> +						    &ioend->io_bio);
>  			iomap_finish_ioends(ioend,
>  				blk_status_to_errno(ioend->io_bio.bi_status));
> -		else
> +		} else {
>  			xfs_end_ioend_write(ioend);
> +		}
>  		cond_resched();
>  	}
>  }
> @@ -232,9 +237,14 @@ xfs_end_bio(
>  	}
>  
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> -	if (list_empty(&ip->i_ioend_list))
> -		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
> +	if (list_empty(&ip->i_ioend_list)) {
> +		if (IS_ENABLED(CONFIG_FS_VERITY) && ioend->io_vi &&
> +		    ioend->io_offset < xfs_fsverity_metadata_offset(ip))
> +			fsverity_enqueue_verify_work(&ip->i_ioend_work);

I think the fsverity metadata (merkle tree & descriptor) don't need any
(read) ioend completion work since all we're doing is reading that into
the pagecache and eventually fsverity will go look at those contents
when it wants to verify some actual file data, right?

If the answer is 'yes' then I've understood this well enough to say
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		else
> +			WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
>  					 &ip->i_ioend_work));
> +	}
>  	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
>  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
>  }
> @@ -764,9 +774,12 @@ xfs_bio_submit_read(
>  	struct iomap_read_folio_ctx	*ctx)
>  {
>  	struct bio			*bio = ctx->read_ctx;
> +	struct iomap_ioend		*ioend;
>  
>  	/* defer read completions to the ioend workqueue */
> -	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
> +	ioend = iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
> +	ioend->io_vi = ctx->vi;
> +
>  	bio->bi_end_io = xfs_end_bio;
>  	submit_bio(bio);
>  }
> @@ -779,12 +792,15 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
>  
>  static inline const struct iomap_read_ops *
>  xfs_get_iomap_read_ops(
> -	const struct address_space	*mapping)
> +	const struct address_space	*mapping,
> +	loff_t				position)
>  {
>  	struct xfs_inode		*ip = XFS_I(mapping->host);
>  
>  	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
>  		return &xfs_iomap_read_ops;
> +	if (xfs_fsverity_is_file_data(ip, position))
> +		return &xfs_iomap_read_ops;
>  	return &iomap_bio_read_ops;
>  }
>  
> @@ -795,7 +811,7 @@ xfs_vm_read_folio(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
> +	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
>  	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
>  	return 0;
>  }
> @@ -806,7 +822,7 @@ xfs_vm_readahead(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .rac = rac };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
> +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
>  	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
>  }
>  
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index bc6020cc6e41..dc66ffb7d132 100644
> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -32,3 +32,14 @@ xfs_fsverity_metadata_offset(
>  {
>  	return round_up(i_size_read(VFS_IC(ip)), 65536);
>  }
> +
> +bool
> +xfs_fsverity_is_file_data(
> +	const struct xfs_inode	*ip,
> +	loff_t			offset)
> +{
> +	const struct inode	*inode = VFS_IC(ip);
> +
> +	return fsverity_active(inode) &&
> +	       offset < xfs_fsverity_metadata_offset(ip);
> +}
> diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
> index 5771db2cd797..ec77ba571106 100644
> --- a/fs/xfs/xfs_fsverity.h
> +++ b/fs/xfs/xfs_fsverity.h
> @@ -9,12 +9,18 @@
>  
>  #ifdef CONFIG_FS_VERITY
>  loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
> +bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
>  #else
>  static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
>  {
>  	WARN_ON_ONCE(1);
>  	return ULLONG_MAX;
>  }
> +static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
> +					    loff_t offset)
> +{
> +	return false;
> +}
>  #endif	/* CONFIG_FS_VERITY */
>  
>  #endif	/* __XFS_FSVERITY_H__ */
> -- 
> 2.51.2
> 
> 
