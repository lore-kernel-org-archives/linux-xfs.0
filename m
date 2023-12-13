Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669683173D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8RQG/6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DE4C433C8;
	Wed, 13 Dec 2023 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702491332;
	bh=RLG7IM+Icsysloj6ShJaVOBZ8m7NZN7r7PV17ZOn1oY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O8RQG/6I6kXlUh6aBcpi6ArxmT9mPsE0tvmHU8IRkolMFiJ8xdY/iGJXz1Vvr4IvU
	 xZmDb8TDFhje8bXa4vnBeZWAuNvfnC61x8mZsqCqMskGkwZqhrcI3WTEKE7ZnD0/2M
	 G2r9QC2VsQWWez3cEW6CezD0XRiv4MDTBO5YW8QHkoKesiKVZEAsCqp2evXsQuKtp+
	 FtKtBSO+lxJtfGBBxXCc2UycwYOE6ibOSICTsHxUKWOY4wjVvPM6KtA7yS5bttNuYG
	 g9UTxSe/J/bCCfVmxh2tDG0CkBILUzgFrdmEUCljnuHHpeQ9o+JlQH2FdZMGahR9t6
	 iTP3b8YzYvJqA==
Date: Wed, 13 Dec 2023 10:15:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/5] xfs: pass the defer ops instead of type to
 xfs_defer_start_recovery
Message-ID: <20231213181532.GG361584@frogsfrogsfrogs>
References: <20231213090633.231707-1-hch@lst.de>
 <20231213090633.231707-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213090633.231707-5-hch@lst.de>

On Wed, Dec 13, 2023 at 10:06:32AM +0100, Christoph Hellwig wrote:
> xfs_defer_start_recovery is only called from xlog_recover_intent_item,
> and the callers of that all have the actual xfs_defer_ops_type operation
> vector at hand.  Pass that directly instead of looking it up from the
> defer_op_types table.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_defer.c       | 6 +++---
>  fs/xfs/libxfs/xfs_defer.h       | 2 +-
>  fs/xfs/libxfs/xfs_log_recover.h | 3 ++-
>  fs/xfs/xfs_attr_item.c          | 2 +-
>  fs/xfs/xfs_bmap_item.c          | 2 +-
>  fs/xfs/xfs_extfree_item.c       | 2 +-
>  fs/xfs/xfs_log_recover.c        | 4 ++--
>  fs/xfs/xfs_refcount_item.c      | 2 +-
>  fs/xfs/xfs_rmap_item.c          | 2 +-
>  9 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index e70881ae5cc597..6a6444ffe5544b 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -894,14 +894,14 @@ xfs_defer_add_barrier(
>  void
>  xfs_defer_start_recovery(
>  	struct xfs_log_item		*lip,
> -	enum xfs_defer_ops_type		dfp_type,
> -	struct list_head		*r_dfops)
> +	struct list_head		*r_dfops,
> +	const struct xfs_defer_op_type *ops)

Nit: tab before the parameter name    ^

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  {
>  	struct xfs_defer_pending	*dfp;
>  
>  	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
>  			GFP_NOFS | __GFP_NOFAIL);
> -	dfp->dfp_ops = defer_op_types[dfp_type];
> +	dfp->dfp_ops = ops;
>  	dfp->dfp_intent = lip;
>  	INIT_LIST_HEAD(&dfp->dfp_work);
>  	list_add_tail(&dfp->dfp_list, r_dfops);
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 957a06278e880d..60de91b6639225 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -147,7 +147,7 @@ void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
>  void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
>  
>  void xfs_defer_start_recovery(struct xfs_log_item *lip,
> -		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
> +		struct list_head *r_dfops, const struct xfs_defer_op_type *ops);
>  void xfs_defer_cancel_recovery(struct xfs_mount *mp,
>  		struct xfs_defer_pending *dfp);
>  int xfs_defer_finish_recovery(struct xfs_mount *mp,
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index c8e5d912895bcd..9fe7a9564bca96 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -11,6 +11,7 @@
>   * define how recovery should work for that type of log item.
>   */
>  struct xlog_recover_item;
> +struct xfs_defer_op_type;
>  
>  /* Sorting hat for log items as they're read in. */
>  enum xlog_recover_reorder {
> @@ -156,7 +157,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
>  struct xfs_defer_pending;
>  
>  void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
> -		xfs_lsn_t lsn, unsigned int dfp_type);
> +		xfs_lsn_t lsn, const struct xfs_defer_op_type *ops);
>  int xlog_recover_finish_intent(struct xfs_trans *tp,
>  		struct xfs_defer_pending *dfp);
>  
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index beae2de824507b..9e02111bd89010 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -759,7 +759,7 @@ xlog_recover_attri_commit_pass2(
>  	memcpy(&attrip->attri_format, attri_formatp, len);
>  
>  	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
> -			XFS_DEFER_OPS_TYPE_ATTR);
> +			&xfs_attr_defer_type);
>  	xfs_attri_log_nameval_put(nv);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index f43abf0b648641..52fb8a148b7dcb 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -650,7 +650,7 @@ xlog_recover_bui_commit_pass2(
>  	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
>  
>  	xlog_recover_intent_item(log, &buip->bui_item, lsn,
> -			XFS_DEFER_OPS_TYPE_BMAP);
> +			&xfs_bmap_update_defer_type);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index e67907a379c8e8..1d1185fca6a58e 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -747,7 +747,7 @@ xlog_recover_efi_commit_pass2(
>  	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
>  
>  	xlog_recover_intent_item(log, &efip->efi_item, lsn,
> -			XFS_DEFER_OPS_TYPE_FREE);
> +			&xfs_extent_free_defer_type);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c18692af2c651c..1251c81e55f982 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1942,11 +1942,11 @@ xlog_recover_intent_item(
>  	struct xlog			*log,
>  	struct xfs_log_item		*lip,
>  	xfs_lsn_t			lsn,
> -	unsigned int			dfp_type)
> +	const struct xfs_defer_op_type	*ops)
>  {
>  	ASSERT(xlog_item_is_intent(lip));
>  
> -	xfs_defer_start_recovery(lip, dfp_type, &log->r_dfops);
> +	xfs_defer_start_recovery(lip, &log->r_dfops, ops);
>  
>  	/*
>  	 * Insert the intent into the AIL directly and drop one reference so
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index b08839550f34a3..20ad8086da60be 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -605,7 +605,7 @@ xlog_recover_cui_commit_pass2(
>  	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
>  
>  	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
> -			XFS_DEFER_OPS_TYPE_REFCOUNT);
> +			&xfs_refcount_update_defer_type);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 65b432eb5d025d..79ad0087aecaf5 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -658,7 +658,7 @@ xlog_recover_rui_commit_pass2(
>  	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
>  
>  	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
> -			XFS_DEFER_OPS_TYPE_RMAP);
> +			&xfs_rmap_update_defer_type);
>  	return 0;
>  }
>  
> -- 
> 2.39.2
> 
> 
