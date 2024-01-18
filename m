Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16681EB37
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705618392; cv=none; b=egPgrN7sy1WC5lR+97SUXZJSTsIvAvS5T+CHm9q/5edrQJhgV+rJjQxnHrb63I9oNHoERg/jhUvDYmHuEaxB/pKB+9QSWiuPWR9ohQhgAujOT8PXGaQDYBrmqdQGgz59IgY9npUJqQaQclZfyV3pceJtixEI0aaT5Z3EDao+XC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705618392; c=relaxed/simple;
	bh=6bg+ixkTBewj7BqbHn96Uh/X2rEPQivWKZs1kH2CrdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEAfN6f9WvRWgFFzAjc+jvKsT9cC03zawLl4TtkEjnh74y2kj1jpC2e7x9lYwPb74QCCIcrg3t435t7I+RTLR6SvcrSjPdQ6CwOU0TRye6A+vOFff1mxrNphO9lEndrYvps4+ZvQ2edhh6qH4zWgFOEE9abn5+nZrex0RKnp6mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hR9KHIPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hR9KHIPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131DAC433C7;
	Thu, 18 Jan 2024 22:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705618392;
	bh=6bg+ixkTBewj7BqbHn96Uh/X2rEPQivWKZs1kH2CrdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hR9KHIPjnEgWL1anS0l5CLh0m+Rpy1O8OZ6d912EvDPkLsuqSy4jddt+hlutZPgYC
	 EyEz0S0kXAEhIYNAa2BLDZaHokSPFZSBrXi2j2P8SAVzT8zJKbNRujWYxIvSn5lgK3
	 i27FJb15YpFzm7Ut2FCBiPb6UbB9frCuIDAcPGiydoNXB7wAaA4wNUhwsmo+t9JJqo
	 nyqe8ll9cmdOCka+nTsULg6filn2OqvIwZ8xofd4Ziio5n65GDR44+AfsGbOR7+Trk
	 MWgFJMM1wTKnXBQJeXtzXB/B5M6x068C1/IURwpIwePmNIgRjW6CxcxNet+I1iYkiD
	 gkxAcAdBNWdYQ==
Date: Thu, 18 Jan 2024 14:53:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/12] xfs: convert kmem_free() for kvmalloc users to
 kvfree()
Message-ID: <20240118225311.GG674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-5-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:42AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Start getting rid of kmem_free() by converting all the cases where
> memory can come from vmalloc interfaces to calling kvfree()
> directly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine to me!

Just as a warning there's some dumb bot out there that will flag
"unnecessary" use of kvfree where kfree could be used.  I choose to
ignore that bot because who gives a f*** but that's the state of things
now. :(

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_acl.c           |  4 ++--
>  fs/xfs/xfs_attr_item.c     |  4 ++--
>  fs/xfs/xfs_bmap_item.c     |  4 ++--
>  fs/xfs/xfs_buf_item.c      |  2 +-
>  fs/xfs/xfs_dquot.c         |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  4 ++--
>  fs/xfs/xfs_icreate_item.c  |  2 +-
>  fs/xfs/xfs_inode_item.c    |  2 +-
>  fs/xfs/xfs_ioctl.c         |  2 +-
>  fs/xfs/xfs_log.c           |  4 ++--
>  fs/xfs/xfs_log_cil.c       |  2 +-
>  fs/xfs/xfs_log_recover.c   | 42 +++++++++++++++++++-------------------
>  fs/xfs/xfs_refcount_item.c |  4 ++--
>  fs/xfs/xfs_rmap_item.c     |  4 ++--
>  fs/xfs/xfs_rtalloc.c       |  6 +++---
>  15 files changed, 44 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 6b840301817a..4bf69c9c088e 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -167,7 +167,7 @@ xfs_get_acl(struct inode *inode, int type, bool rcu)
>  		acl = ERR_PTR(error);
>  	}
>  
> -	kmem_free(args.value);
> +	kvfree(args.value);
>  	return acl;
>  }
>  
> @@ -204,7 +204,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	}
>  
>  	error = xfs_attr_change(&args);
> -	kmem_free(args.value);
> +	kvfree(args.value);
>  
>  	/*
>  	 * If the attribute didn't exist to start with that's fine.
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 2e454a0d6f19..f7ba80d575d4 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -108,7 +108,7 @@ STATIC void
>  xfs_attri_item_free(
>  	struct xfs_attri_log_item	*attrip)
>  {
> -	kmem_free(attrip->attri_item.li_lv_shadow);
> +	kvfree(attrip->attri_item.li_lv_shadow);
>  	xfs_attri_log_nameval_put(attrip->attri_nameval);
>  	kmem_cache_free(xfs_attri_cache, attrip);
>  }
> @@ -251,7 +251,7 @@ static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
>  STATIC void
>  xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>  {
> -	kmem_free(attrdp->attrd_item.li_lv_shadow);
> +	kvfree(attrdp->attrd_item.li_lv_shadow);
>  	kmem_cache_free(xfs_attrd_cache, attrdp);
>  }
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 52fb8a148b7d..029a6a8d0efd 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -40,7 +40,7 @@ STATIC void
>  xfs_bui_item_free(
>  	struct xfs_bui_log_item	*buip)
>  {
> -	kmem_free(buip->bui_item.li_lv_shadow);
> +	kvfree(buip->bui_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bui_cache, buip);
>  }
>  
> @@ -201,7 +201,7 @@ xfs_bud_item_release(
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
>  	xfs_bui_release(budp->bud_buip);
> -	kmem_free(budp->bud_item.li_lv_shadow);
> +	kvfree(budp->bud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bud_cache, budp);
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index ec93d34188c8..545040c6ae87 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1044,7 +1044,7 @@ xfs_buf_item_free(
>  	struct xfs_buf_log_item	*bip)
>  {
>  	xfs_buf_item_free_format(bip);
> -	kmem_free(bip->bli_item.li_lv_shadow);
> +	kvfree(bip->bli_item.li_lv_shadow);
>  	kmem_cache_free(xfs_buf_item_cache, bip);
>  }
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a93ad76f23c5..17c82f5e783c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -53,7 +53,7 @@ xfs_qm_dqdestroy(
>  {
>  	ASSERT(list_empty(&dqp->q_lru));
>  
> -	kmem_free(dqp->q_logitem.qli_item.li_lv_shadow);
> +	kvfree(dqp->q_logitem.qli_item.li_lv_shadow);
>  	mutex_destroy(&dqp->q_qlock);
>  
>  	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 1d1185fca6a5..6062703a2723 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -40,7 +40,7 @@ STATIC void
>  xfs_efi_item_free(
>  	struct xfs_efi_log_item	*efip)
>  {
> -	kmem_free(efip->efi_item.li_lv_shadow);
> +	kvfree(efip->efi_item.li_lv_shadow);
>  	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
>  		kmem_free(efip);
>  	else
> @@ -229,7 +229,7 @@ static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
>  STATIC void
>  xfs_efd_item_free(struct xfs_efd_log_item *efdp)
>  {
> -	kmem_free(efdp->efd_item.li_lv_shadow);
> +	kvfree(efdp->efd_item.li_lv_shadow);
>  	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
>  		kmem_free(efdp);
>  	else
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index b05314d48176..4345db501714 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -63,7 +63,7 @@ STATIC void
>  xfs_icreate_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	kmem_free(ICR_ITEM(lip)->ic_item.li_lv_shadow);
> +	kvfree(ICR_ITEM(lip)->ic_item.li_lv_shadow);
>  	kmem_cache_free(xfs_icreate_cache, ICR_ITEM(lip));
>  }
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0aee97ba0be8..bfbeafc8e120 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -856,7 +856,7 @@ xfs_inode_item_destroy(
>  	ASSERT(iip->ili_item.li_buf == NULL);
>  
>  	ip->i_itemp = NULL;
> -	kmem_free(iip->ili_item.li_lv_shadow);
> +	kvfree(iip->ili_item.li_lv_shadow);
>  	kmem_cache_free(xfs_ili_cache, iip);
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f02b6e558af5..45fb169bd819 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -493,7 +493,7 @@ xfs_attrmulti_attr_get(
>  		error = -EFAULT;
>  
>  out_kfree:
> -	kmem_free(args.value);
> +	kvfree(args.value);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d38cfaadc726..0009ffbec932 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1662,7 +1662,7 @@ xlog_alloc_log(
>  out_free_iclog:
>  	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
>  		prev_iclog = iclog->ic_next;
> -		kmem_free(iclog->ic_data);
> +		kvfree(iclog->ic_data);
>  		kmem_free(iclog);
>  		if (prev_iclog == log->l_iclog)
>  			break;
> @@ -2119,7 +2119,7 @@ xlog_dealloc_log(
>  	iclog = log->l_iclog;
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
>  		next_iclog = iclog->ic_next;
> -		kmem_free(iclog->ic_data);
> +		kvfree(iclog->ic_data);
>  		kmem_free(iclog);
>  		iclog = next_iclog;
>  	}
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3c705f22b0ab..2c0512916cc9 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -339,7 +339,7 @@ xlog_cil_alloc_shadow_bufs(
>  			 * the buffer, only the log vector header and the iovec
>  			 * storage.
>  			 */
> -			kmem_free(lip->li_lv_shadow);
> +			kvfree(lip->li_lv_shadow);
>  			lv = xlog_kvmalloc(buf_size);
>  
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e3bd503edcab..295306ef6959 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -361,7 +361,7 @@ xlog_find_verify_cycle(
>  	*new_blk = -1;
>  
>  out:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -477,7 +477,7 @@ xlog_find_verify_log_record(
>  		*last_blk = i;
>  
>  out:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -731,7 +731,7 @@ xlog_find_head(
>  			goto out_free_buffer;
>  	}
>  
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	if (head_blk == log_bbnum)
>  		*return_head_blk = 0;
>  	else
> @@ -745,7 +745,7 @@ xlog_find_head(
>  	return 0;
>  
>  out_free_buffer:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	if (error)
>  		xfs_warn(log->l_mp, "failed to find log head");
>  	return error;
> @@ -999,7 +999,7 @@ xlog_verify_tail(
>  		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
>  			 orig_tail, *tail_blk);
>  out:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -1046,7 +1046,7 @@ xlog_verify_head(
>  	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
>  				      XLOG_MAX_ICLOGS, tmp_buffer,
>  				      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
> -	kmem_free(tmp_buffer);
> +	kvfree(tmp_buffer);
>  	if (error < 0)
>  		return error;
>  
> @@ -1365,7 +1365,7 @@ xlog_find_tail(
>  		error = xlog_clear_stale_blocks(log, tail_lsn);
>  
>  done:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  
>  	if (error)
>  		xfs_warn(log->l_mp, "failed to locate log tail");
> @@ -1399,6 +1399,7 @@ xlog_find_zeroed(
>  	xfs_daddr_t	new_blk, last_blk, start_blk;
>  	xfs_daddr_t     num_scan_bblks;
>  	int	        error, log_bbnum = log->l_logBBsize;
> +	int		ret = 1;
>  
>  	*blk_no = 0;
>  
> @@ -1413,8 +1414,7 @@ xlog_find_zeroed(
>  	first_cycle = xlog_get_cycle(offset);
>  	if (first_cycle == 0) {		/* completely zeroed log */
>  		*blk_no = 0;
> -		kmem_free(buffer);
> -		return 1;
> +		goto out_free_buffer;
>  	}
>  
>  	/* check partially zeroed log */
> @@ -1424,8 +1424,8 @@ xlog_find_zeroed(
>  
>  	last_cycle = xlog_get_cycle(offset);
>  	if (last_cycle != 0) {		/* log completely written to */
> -		kmem_free(buffer);
> -		return 0;
> +		ret = 0;
> +		goto out_free_buffer;
>  	}
>  
>  	/* we have a partially zeroed log */
> @@ -1471,10 +1471,10 @@ xlog_find_zeroed(
>  
>  	*blk_no = last_blk;
>  out_free_buffer:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	if (error)
>  		return error;
> -	return 1;
> +	return ret;
>  }
>  
>  /*
> @@ -1583,7 +1583,7 @@ xlog_write_log_records(
>  	}
>  
>  out_free_buffer:
> -	kmem_free(buffer);
> +	kvfree(buffer);
>  	return error;
>  }
>  
> @@ -2183,7 +2183,7 @@ xlog_recover_add_to_trans(
>  		"bad number of regions (%d) in inode log format",
>  				  in_f->ilf_size);
>  			ASSERT(0);
> -			kmem_free(ptr);
> +			kvfree(ptr);
>  			return -EFSCORRUPTED;
>  		}
>  
> @@ -2197,7 +2197,7 @@ xlog_recover_add_to_trans(
>  	"log item region count (%d) overflowed size (%d)",
>  				item->ri_cnt, item->ri_total);
>  		ASSERT(0);
> -		kmem_free(ptr);
> +		kvfree(ptr);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -2227,7 +2227,7 @@ xlog_recover_free_trans(
>  		/* Free the regions in the item. */
>  		list_del(&item->ri_list);
>  		for (i = 0; i < item->ri_cnt; i++)
> -			kmem_free(item->ri_buf[i].i_addr);
> +			kvfree(item->ri_buf[i].i_addr);
>  		/* Free the item itself */
>  		kmem_free(item->ri_buf);
>  		kmem_free(item);
> @@ -3024,7 +3024,7 @@ xlog_do_recovery_pass(
>  
>  		hblks = xlog_logrec_hblks(log, rhead);
>  		if (hblks != 1) {
> -			kmem_free(hbp);
> +			kvfree(hbp);
>  			hbp = xlog_alloc_buffer(log, hblks);
>  		}
>  	} else {
> @@ -3038,7 +3038,7 @@ xlog_do_recovery_pass(
>  		return -ENOMEM;
>  	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
>  	if (!dbp) {
> -		kmem_free(hbp);
> +		kvfree(hbp);
>  		return -ENOMEM;
>  	}
>  
> @@ -3199,9 +3199,9 @@ xlog_do_recovery_pass(
>  	}
>  
>   bread_err2:
> -	kmem_free(dbp);
> +	kvfree(dbp);
>   bread_err1:
> -	kmem_free(hbp);
> +	kvfree(hbp);
>  
>  	/*
>  	 * Submit buffers that have been added from the last record processed,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 78d0cda60abf..a9b322e23cfb 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -36,7 +36,7 @@ STATIC void
>  xfs_cui_item_free(
>  	struct xfs_cui_log_item	*cuip)
>  {
> -	kmem_free(cuip->cui_item.li_lv_shadow);
> +	kvfree(cuip->cui_item.li_lv_shadow);
>  	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
>  		kmem_free(cuip);
>  	else
> @@ -207,7 +207,7 @@ xfs_cud_item_release(
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
>  	xfs_cui_release(cudp->cud_cuip);
> -	kmem_free(cudp->cud_item.li_lv_shadow);
> +	kvfree(cudp->cud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_cud_cache, cudp);
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 31a921fc34b2..489ca8c0e1dc 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -36,7 +36,7 @@ STATIC void
>  xfs_rui_item_free(
>  	struct xfs_rui_log_item	*ruip)
>  {
> -	kmem_free(ruip->rui_item.li_lv_shadow);
> +	kvfree(ruip->rui_item.li_lv_shadow);
>  	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
>  		kmem_free(ruip);
>  	else
> @@ -206,7 +206,7 @@ xfs_rud_item_release(
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
>  	xfs_rui_release(rudp->rud_ruip);
> -	kmem_free(rudp->rud_item.li_lv_shadow);
> +	kvfree(rudp->rud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_rud_cache, rudp);
>  }
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 8a8d6197203e..57ed9baaf156 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1059,10 +1059,10 @@ xfs_growfs_rt(
>  	 */
>  	if (rsum_cache != mp->m_rsum_cache) {
>  		if (error) {
> -			kmem_free(mp->m_rsum_cache);
> +			kvfree(mp->m_rsum_cache);
>  			mp->m_rsum_cache = rsum_cache;
>  		} else {
> -			kmem_free(rsum_cache);
> +			kvfree(rsum_cache);
>  		}
>  	}
>  
> @@ -1233,7 +1233,7 @@ void
>  xfs_rtunmount_inodes(
>  	struct xfs_mount	*mp)
>  {
> -	kmem_free(mp->m_rsum_cache);
> +	kvfree(mp->m_rsum_cache);
>  	if (mp->m_rbmip)
>  		xfs_irele(mp->m_rbmip);
>  	if (mp->m_rsumip)
> -- 
> 2.43.0
> 
> 
