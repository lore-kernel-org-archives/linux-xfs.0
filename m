Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F3919D89E;
	Tue, 31 Mar 2026 23:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775000054; cv=none; b=XZiyl5ZYB0cBtX3KTy3sicshHASBOCMPBY0QcuNJo7T8R96nycGu9JGAWsrT+4KjWO1/JskWTA2kvFK9BJnkzcUvCaDZe5ACJRX4jI1PLkvyL7rnsil1HgQPTEW6tC23OjUy0UKPa+Iuzj3TgkrzUhYNgSQFLIpYm54HVN6ExcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775000054; c=relaxed/simple;
	bh=PdO42lqMcVPHLZHuXll3GmvVEJQHveKUtKE07QAD2zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZNyGYEa2ZwauzabEhLnEuqqSmFXqdeqZIOvkEP0eVWjhtcjrGjtI/bsCU/D3lJRJZQh6GDRkhSawC9R5PwIPDMtmFtBTZ/75yqF6TtdNRaX8k3hrREQCMivapZUDd2POf4WL61DKldxwGdH+OB7IkWtM/9+RsvnyVR6trgZPaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QF4+JPaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QF4+JPaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E22BC19423;
	Tue, 31 Mar 2026 23:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775000054;
	bh=PdO42lqMcVPHLZHuXll3GmvVEJQHveKUtKE07QAD2zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QF4+JPaWIRu7yGXcv99CyGAiX3a4odDvzg4PN6vuvN23D80RC6gL6vdyoyTgZ23LB
	 NY2EoUrDi6QLYPxNWOIX0SC9Q48wdTlA8ldUY6LVRc32kMilkpjrVxNVNw63T9v/Ur
	 5PsmafoPCqGJzhIjsAjW5byD3Q7jThDDz7oKYpUu836HD5N2jAaLR7e/XQ/cRWtNQt
	 hdycufQvZo8fCP6IwdlXUtNUJYIImGPZAOL/tiwgkc8V9Ab3mm8qihuD6y1u+E/VcA
	 IvA4nPFu6cNH2lHzzJv3PT2vqQwp6azKduerQ462LzN5FZor+JmYY7qm/9iy1WI1nN
	 A9zYwhu/Gh4XQ==
Date: Tue, 31 Mar 2026 16:34:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 14/22] xfs: use read ioend for fsverity data
 verification
Message-ID: <20260331233413.GH6223@frogsfrogsfrogs>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-15-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-15-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:15PM +0200, Andrey Albershteyn wrote:
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks fine to me still,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c     | 46 ++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_fsverity.c |  9 +++++++++
>  fs/xfs/xfs_fsverity.h |  6 ++++++
>  3 files changed, 52 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9503252a0fa4..ecb07f250956 100644
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
> @@ -171,6 +172,23 @@ xfs_end_ioend_write(
>  	memalloc_nofs_restore(nofs_flag);
>  }
>  
> +/*
> + * IO read completion.
> + */
> +static void
> +xfs_end_ioend_read(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +
> +	if (!ioend->io_bio.bi_status &&
> +			xfs_fsverity_is_file_data(ip, ioend->io_offset))
> +		fsverity_verify_bio(ioend->io_vi,
> +				    &ioend->io_bio);
> +	iomap_finish_ioends(ioend,
> +		blk_status_to_errno(ioend->io_bio.bi_status));
> +}
> +
>  /*
>   * Finish all pending IO completions that require transactional modifications.
>   *
> @@ -205,8 +223,7 @@ xfs_end_io(
>  		list_del_init(&ioend->io_list);
>  		iomap_ioend_try_merge(ioend, &tmp);
>  		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> -			iomap_finish_ioends(ioend,
> -				blk_status_to_errno(ioend->io_bio.bi_status));
> +			xfs_end_ioend_read(ioend);
>  		else
>  			xfs_end_ioend_write(ioend);
>  		cond_resched();
> @@ -232,9 +249,14 @@ xfs_end_bio(
>  	}
>  
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> -	if (list_empty(&ip->i_ioend_list))
> -		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
> +	if (list_empty(&ip->i_ioend_list)) {
> +		if (IS_ENABLED(CONFIG_FS_VERITY) && ioend->io_vi &&
> +		    ioend->io_offset < xfs_fsverity_metadata_offset(ip))
> +			fsverity_enqueue_verify_work(&ip->i_ioend_work);
> +		else
> +			WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
>  					 &ip->i_ioend_work));
> +	}
>  	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
>  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
>  }
> @@ -764,9 +786,13 @@ xfs_bio_submit_read(
>  	struct iomap_read_folio_ctx	*ctx)
>  {
>  	struct bio			*bio = ctx->read_ctx;
> +	struct iomap_ioend		*ioend;
>  
>  	/* defer read completions to the ioend workqueue */
> -	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
> +	ioend = iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
> +			0);
> +	ioend->io_vi = ctx->vi;
> +
>  	bio->bi_end_io = xfs_end_bio;
>  	submit_bio(bio);
>  }
> @@ -779,11 +805,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
>  
>  static inline const struct iomap_read_ops *
>  xfs_get_iomap_read_ops(
> -	const struct address_space	*mapping)
> +	const struct address_space	*mapping,
> +	loff_t				position)
>  {
>  	struct xfs_inode		*ip = XFS_I(mapping->host);
>  
> -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
> +			xfs_fsverity_is_file_data(ip, position))
>  		return &xfs_iomap_read_ops;
>  	return &iomap_bio_read_ops;
>  }
> @@ -795,7 +823,7 @@ xfs_vm_read_folio(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
> +	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
>  	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
>  	return 0;
>  }
> @@ -806,7 +834,7 @@ xfs_vm_readahead(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .rac = rac };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
> +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
>  	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
>  }
>  
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 6e6a8636a577..b983e20bb5e1 100644
> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -19,3 +19,12 @@ xfs_fsverity_metadata_offset(
>  {
>  	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
>  }
> +
> +bool
> +xfs_fsverity_is_file_data(
> +	const struct xfs_inode	*ip,
> +	loff_t			offset)
> +{
> +	return fsverity_active(VFS_IC(ip)) &&
> +			offset < xfs_fsverity_metadata_offset(ip);
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
