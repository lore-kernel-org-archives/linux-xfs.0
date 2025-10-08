Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874FA26A1A4
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759955953; cv=none; b=jGLbBGHuFb3TEdDQLu9dIKEpTDkVc3BuLjNyLTdyd6VaZiy4q3mf9BOHQTW5r6Bi23VH7BrRv1r/5LIx3y/TAL/9rZRSjvjYOMjMHKHV0nxiJDx4tBbuf0IXE+XoVKradtVODKlRQVjtDicG9sbulpo8PH4nrLxVUuQJz/nnOuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759955953; c=relaxed/simple;
	bh=FY6ush2B7fwoQRonZkvWlRNZlnc2GB4tcTKkbnjmglw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfvJUXaQ7Wnc+RnxU+Vximj30hQ4Yg/LxMZ8pgdDey7MhZrEMUZnqoI1yF/zNqPHSO//nGKeAYy+MQQM4LALKRxkm88KrVPny0HmA2JCqIujntiNDVjtma6rtRPM5zZ9RdpHbS5OKd6LntY52YfZQGSFppd2XJ5zGg/yTjabaU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RM8y+nxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RM8y+nxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04662C4CEE7;
	Wed,  8 Oct 2025 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759955953;
	bh=FY6ush2B7fwoQRonZkvWlRNZlnc2GB4tcTKkbnjmglw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RM8y+nxzF+YFXhFz1GP1FqhMoS0TCMY5V8/rE3CLjuBOWcydfwc/bTLU7EKuAnLh1
	 J/X+EqaqQBQZSDkS2THEPI9ZmCuIJumboPOuduEDdxQhMX3Ay5eTp1fwPrDYD4H6Lt
	 5869n9gRpQlHTofcNFlI1UmipceF+xxlediQusyZ0w6hISX5XS2LgrVHJx4fhihFrm
	 mv5WobWYcVH5reW9kbUs9WpX4aUNOjGOnWLk2mIAuTN45qu2ZZ/n2Kj0t5deolezJq
	 MAeEBTmQ72ML7Dl+kbXn3v/KPH6Qqustwu2J+T1Ff8csgRPi1zdlAPBz/jpxm7TH0R
	 d32p65gaHDxCw==
Date: Wed, 8 Oct 2025 13:39:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, cmaiolino@redhat.com,
	hch@lst.de, pchelkin@ispras.ru, pranav.tyagi03@gmail.com,
	sandeen@redhat.com
Subject: Re: [PATCH 0/12] xfsprogs: libxfs sync v6.17
Message-ID: <20251008203912.GB6188@frogsfrogsfrogs>
References: <cover.1759941416.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759941416.patch-series@thinky>

On Wed, Oct 08, 2025 at 06:41:17PM +0200, Andrey Albershteyn wrote:
> Hey all,
> 
> This is libxfs sync with v6.17.
> 
> Manual modifications diff in attachment.

For everything except patches 3-4,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> -- 
> - Andrey

> diff --git a/db/attrset.c b/db/attrset.c
> index e3ffb75aa4..273c202956 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -823,11 +823,7 @@
>  		return 0;
>  	}
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error) {
> -		dbprintf(_("failed to allocate empty transaction\n"));
> -		return 0;
> -	}
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
>  	if (error) {
> diff --git a/db/dquot.c b/db/dquot.c
> index d2c76fd70b..c028d50e4c 100644
> --- a/db/dquot.c
> +++ b/db/dquot.c
> @@ -92,9 +92,7 @@
>  	xfs_ino_t		ret = NULLFSINO;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		return NULLFSINO;
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	if (xfs_has_metadir(mp)) {
>  		error = -libxfs_dqinode_load_parent(tp, &dp);
> diff --git a/db/fsmap.c b/db/fsmap.c
> index ddbe4e6a3d..a59a4d1230 100644
> --- a/db/fsmap.c
> +++ b/db/fsmap.c
> @@ -133,13 +133,7 @@
>  	struct xfs_btree_cur	*bt_cur;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error) {
> -		dbprintf(
> - _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
> -				rtg_rgno(rtg));
> -		return error;
> -	}
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = -libxfs_rtginode_load_parent(tp);
>  	if (error) {
> diff --git a/db/info.c b/db/info.c
> index 6ad3e23832..9c233c9c0e 100644
> --- a/db/info.c
> +++ b/db/info.c
> @@ -174,13 +174,7 @@
>  	xfs_filblks_t		used = 0;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error) {
> -		dbprintf(
> - _("Cannot alloc transaction to look up rtgroup %u rmap inode\n"),
> -				rtg_rgno(rtg));
> -		return;
> -	}
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = -libxfs_rtginode_load_parent(tp);
>  	if (error) {
> diff --git a/db/metadump.c b/db/metadump.c
> index 34f2d61700..24eb99da17 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2989,7 +2989,7 @@
>  		if (metadump.obfuscate) {
>  			struct xfs_sb *sb = iocur_top->data;
>  			memset(sb->sb_fname, 'L',
> -			       min(strlen(sb->sb_fname), sizeof(sb->sb_fname)));
> +			       strnlen(sb->sb_fname, sizeof(sb->sb_fname)));
>  			iocur_top->need_crc = 1;
>  		}
>  		if (write_buf(iocur_top))
> diff --git a/db/namei.c b/db/namei.c
> index 1d9581c323..0a50ec87df 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -94,9 +94,7 @@
>  	unsigned int		i;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		return error;
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = -libxfs_iget(mp, tp, ino, 0, &dp);
>  	if (error)
> diff --git a/db/rdump.c b/db/rdump.c
> index a50df4b8c7..599d0727e7 100644
> --- a/db/rdump.c
> +++ b/db/rdump.c
> @@ -926,15 +926,10 @@
>  		set_cur_inode(mp->m_sb.sb_rootino);
>  	}
>  
> -	ret = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (ret) {
> -		dbprintf(_("allocating state: %s\n"), strerror(ret));
> -		goto out_pbuf;
> -	}
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	ret = rdump_file(tp, iocur_top->ino, destdir, pbuf);
>  	libxfs_trans_cancel(tp);
> -out_pbuf:
>  	free(pbuf);
>  	return ret;
>  }
> diff --git a/include/platform_defs.h b/include/platform_defs.h
> index 74a00583eb..da966490b0 100644
> --- a/include/platform_defs.h
> +++ b/include/platform_defs.h
> @@ -294,4 +294,17 @@
>  	__a > __b ? (__a - __b) : (__b - __a);	\
>  })
>  
> +#define cmp_int(l, r)		((l > r) - (l < r))
> +
> +#if __has_attribute(__nonstring__)
> +# define __nonstring                    __attribute__((__nonstring__))
> +#else
> +# define __nonstring
> +#endif
> +
> +struct kvec {
> +	void *iov_base;
> +	size_t iov_len;
> +};
> +
>  #endif	/* __XFS_PLATFORM_DEFS_H__ */
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index 248064019a..4f4bfff350 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -98,7 +98,7 @@
>  			struct xfs_trans **tpp, int *nospace_error);
>  int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
>  				    struct xfs_trans **tpp);
> -int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
> +struct xfs_trans *libxfs_trans_alloc_empty(struct xfs_mount *mp);
>  int	libxfs_trans_commit(struct xfs_trans *);
>  void	libxfs_trans_cancel(struct xfs_trans *);
>  int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
> diff --git a/libxfs/inode.c b/libxfs/inode.c
> index 0598a70ff5..1ce159fcc9 100644
> --- a/libxfs/inode.c
> +++ b/libxfs/inode.c
> @@ -258,9 +258,7 @@
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> -	error = libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		return error;
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = libxfs_trans_metafile_iget(tp, ino, metafile_type, ipp);
>  	libxfs_trans_cancel(tp);
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 5c896ba166..64457d1710 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -247,18 +247,12 @@
>  	return error;
>  }
>  
> -int
> -libxfs_trans_alloc(
> +static inline struct xfs_trans *
> +__libxfs_trans_alloc(
>  	struct xfs_mount	*mp,
> -	struct xfs_trans_res	*resp,
> -	unsigned int		blocks,
> -	unsigned int		rtextents,
> -	unsigned int		flags,
> -	struct xfs_trans	**tpp)
> -
> +	uint			flags)
>  {
>  	struct xfs_trans	*tp;
> -	int			error;
>  
>  	tp = kmem_cache_zalloc(xfs_trans_cache, 0);
>  	tp->t_mountp = mp;
> @@ -266,6 +260,22 @@
>  	INIT_LIST_HEAD(&tp->t_dfops);
>  	tp->t_highest_agno = NULLAGNUMBER;
>  
> +	return tp;
> +}
> +
> +int
> +libxfs_trans_alloc(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_res	*resp,
> +	unsigned int		blocks,
> +	unsigned int		rtextents,
> +	unsigned int		flags,
> +	struct xfs_trans	**tpp)
> +
> +{
> +	struct xfs_trans	*tp = __libxfs_trans_alloc(mp, flags);
> +	int			error;
> +
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>  	if (error) {
>  		xfs_trans_cancel(tp);
> @@ -290,14 +300,11 @@
>   * Note the zero-length reservation; this transaction MUST be cancelled
>   * without any dirty data.
>   */
> -int
> +struct xfs_trans *
>  libxfs_trans_alloc_empty(
> -	struct xfs_mount		*mp,
> -	struct xfs_trans		**tpp)
> +	struct xfs_mount		*mp)
>  {
> -	struct xfs_trans_res		resv = {0};
> -
> -	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
> +	return __libxfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
>  }
>  
>  /*
> diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> index 275593a3ac..7ef43956e9 100644
> --- a/libxlog/xfs_log_recover.c
> +++ b/libxlog/xfs_log_recover.c
> @@ -1034,13 +1034,13 @@
>  	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
>  			  ri_list);
>  
> -	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
> -	old_len = item->ri_buf[item->ri_cnt-1].i_len;
> +	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
> +	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
>  
>  	ptr = krealloc(old_ptr, len+old_len, 0);
>  	memcpy(&ptr[old_len], dp, len); /* d, s, l */
> -	item->ri_buf[item->ri_cnt-1].i_len += len;
> -	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> +	item->ri_buf[item->ri_cnt-1].iov_len += len;
> +	item->ri_buf[item->ri_cnt-1].iov_base = ptr;
>  	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
>  	return 0;
>  }
> @@ -1117,8 +1117,8 @@
>  	}
>  	ASSERT(item->ri_total > item->ri_cnt);
>  	/* Description region is ri_buf[0] */
> -	item->ri_buf[item->ri_cnt].i_addr = ptr;
> -	item->ri_buf[item->ri_cnt].i_len  = len;
> +	item->ri_buf[item->ri_cnt].iov_base = ptr;
> +	item->ri_buf[item->ri_cnt].iov_len  = len;
>  	item->ri_cnt++;
>  	trace_xfs_log_recover_item_add(log, trans, item, 0);
>  	return 0;
> @@ -1140,7 +1140,7 @@
>  		/* Free the regions in the item. */
>  		list_del(&item->ri_list);
>  		for (i = 0; i < item->ri_cnt; i++)
> -			kfree(item->ri_buf[i].i_addr);
> +			kfree(item->ri_buf[i].iov_base);
>  		/* Free the item itself */
>  		kfree(item->ri_buf);
>  		kfree(item);
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index 1498ef9724..39946f32d4 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -78,7 +78,7 @@
>  	xfs_daddr_t		blkno;
>  	struct xfs_disk_dquot	*ddq;
>  
> -	f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
> +	f = (xfs_buf_log_format_t *)item->ri_buf[0].iov_base;
>  	printf("	");
>  	ASSERT(f->blf_type == XFS_LI_BUF);
>  	printf(_("BUF:  #regs:%d   start blkno:0x%llx   len:%d   bmap size:%d   flags:0x%x\n"),
> @@ -87,8 +87,8 @@
>  	num = f->blf_size-1;
>  	i = 1;
>  	while (num-- > 0) {
> -		p = item->ri_buf[i].i_addr;
> -		len = item->ri_buf[i].i_len;
> +		p = item->ri_buf[i].iov_base;
> +		len = item->ri_buf[i].iov_len;
>  		i++;
>  		if (blkno == 0) { /* super block */
>  			struct xfs_dsb  *dsb = (struct xfs_dsb *)p;
> @@ -185,7 +185,7 @@
>  {
>  	xfs_qoff_logformat_t	*qoff_f;
>  
> -	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].i_addr;
> +	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].iov_base;
>  
>  	ASSERT(qoff_f);
>  	printf(_("\tQUOTAOFF: #regs:%d   type:"), qoff_f->qf_size);
> @@ -205,10 +205,10 @@
>  	xfs_dq_logformat_t	*f;
>  	struct xfs_disk_dquot	*d;
>  
> -	f = (xfs_dq_logformat_t *)item->ri_buf[0].i_addr;
> +	f = (xfs_dq_logformat_t *)item->ri_buf[0].iov_base;
>  	ASSERT(f);
>  	ASSERT(f->qlf_len == 1);
> -	d = (struct xfs_disk_dquot *)item->ri_buf[1].i_addr;
> +	d = (struct xfs_disk_dquot *)item->ri_buf[1].iov_base;
>  	printf(_("\tDQUOT: #regs:%d  blkno:%lld  boffset:%u id: %d\n"),
>  	       f->qlf_size, (long long)f->qlf_blkno, f->qlf_boffset, f->qlf_id);
>  	if (!print_quota)
> @@ -288,21 +288,22 @@
>  	int			hasdata;
>  	int			hasattr;
>  
> -	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format_32) ||
> -	       item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format));
> -	f = xfs_inode_item_format_convert(item->ri_buf[0].i_addr, item->ri_buf[0].i_len, &f_buf);
> +	ASSERT(item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format_32) ||
> +		item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format));
> +	f = xfs_inode_item_format_convert(item->ri_buf[0].iov_base,
> +					  item->ri_buf[0].iov_len, &f_buf);
>  
>  	printf(_("	INODE: #regs:%d   ino:0x%llx  flags:0x%x   dsize:%d\n"),
> -	       f->ilf_size, (unsigned long long)f->ilf_ino, f->ilf_fields,
> -	       f->ilf_dsize);
> +		f->ilf_size, (unsigned long long)f->ilf_ino, f->ilf_fields,
> +		f->ilf_dsize);
>  
>  	/* core inode comes 2nd */
>  	/* ASSERT len vs xfs_log_dinode_size() for V3 or V2 inodes */
> -	ASSERT(item->ri_buf[1].i_len ==
> +	ASSERT(item->ri_buf[1].iov_len ==
>  			offsetof(struct xfs_log_dinode, di_next_unlinked) ||
> -	       item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode));
> +	       item->ri_buf[1].iov_len == sizeof(struct xfs_log_dinode));
>  	xlog_recover_print_inode_core((struct xfs_log_dinode *)
> -				      item->ri_buf[1].i_addr);
> +				      item->ri_buf[1].iov_base);
>  
>  	hasdata = (f->ilf_fields & XFS_ILOG_DFORK) != 0;
>  	hasattr = (f->ilf_fields & XFS_ILOG_AFORK) != 0;
> @@ -312,22 +313,22 @@
>  		ASSERT(f->ilf_size == 3 + hasattr);
>  		printf(_("		DATA FORK EXTENTS inode data:\n"));
>  		if (print_inode && print_data)
> -			xlog_recover_print_data(item->ri_buf[2].i_addr,
> -						item->ri_buf[2].i_len);
> +			xlog_recover_print_data(item->ri_buf[2].iov_base,
> +						item->ri_buf[2].iov_len);
>  		break;
>  	case XFS_ILOG_DBROOT:
>  		ASSERT(f->ilf_size == 3 + hasattr);
>  		printf(_("		DATA FORK BTREE inode data:\n"));
>  		if (print_inode && print_data)
> -			xlog_recover_print_data(item->ri_buf[2].i_addr,
> -						item->ri_buf[2].i_len);
> +			xlog_recover_print_data(item->ri_buf[2].iov_base,
> +						item->ri_buf[2].iov_len);
>  		break;
>  	case XFS_ILOG_DDATA:
>  		ASSERT(f->ilf_size == 3 + hasattr);
>  		printf(_("		DATA FORK LOCAL inode data:\n"));
>  		if (print_inode && print_data)
> -			xlog_recover_print_data(item->ri_buf[2].i_addr,
> -						item->ri_buf[2].i_len);
> +			xlog_recover_print_data(item->ri_buf[2].iov_base,
> +						item->ri_buf[2].iov_len);
>  		break;
>  	case XFS_ILOG_DEV:
>  		ASSERT(f->ilf_size == 2 + hasattr);
> @@ -353,24 +354,24 @@
>  			printf(_("		ATTR FORK EXTENTS inode data:\n"));
>  			if (print_inode && print_data)
>  				xlog_recover_print_data(
> -					item->ri_buf[attr_index].i_addr,
> -					item->ri_buf[attr_index].i_len);
> +					item->ri_buf[attr_index].iov_base,
> +					item->ri_buf[attr_index].iov_len);
>  			break;
>  		case XFS_ILOG_ABROOT:
>  			ASSERT(f->ilf_size == 3 + hasdata);
>  			printf(_("		ATTR FORK BTREE inode data:\n"));
>  			if (print_inode && print_data)
>  				xlog_recover_print_data(
> -					item->ri_buf[attr_index].i_addr,
> -					item->ri_buf[attr_index].i_len);
> +					item->ri_buf[attr_index].iov_base,
> +					item->ri_buf[attr_index].iov_len);
>  			break;
>  		case XFS_ILOG_ADATA:
>  			ASSERT(f->ilf_size == 3 + hasdata);
>  			printf(_("		ATTR FORK LOCAL inode data:\n"));
>  			if (print_inode && print_data)
>  				xlog_recover_print_data(
> -					item->ri_buf[attr_index].i_addr,
> -					item->ri_buf[attr_index].i_len);
> +					item->ri_buf[attr_index].iov_base,
> +					item->ri_buf[attr_index].iov_len);
>  			break;
>  		default:
>  			xlog_panic("%s: illegal inode log flag", __FUNCTION__);
> @@ -385,7 +386,7 @@
>  {
>  	struct xfs_icreate_log	*icl;
>  
> -	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
> +	icl = (struct xfs_icreate_log *)item->ri_buf[0].iov_base;
>  
>  	printf(_("	ICR:  #ag: %d  agbno: 0x%x  len: %d\n"
>  		 "	      cnt: %d  isize: %d    gen: 0x%x\n"),
> @@ -549,8 +550,8 @@
>  */
>  	printf(_(": cnt:%d total:%d "), item->ri_cnt, item->ri_total);
>  	for (i=0; i<item->ri_cnt; i++) {
> -		printf(_("a:0x%lx len:%d "),
> -		       (long)item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
> +		printf(_("a:0x%lx len:%zu "),
> +		       (long)item->ri_buf[i].iov_base, item->ri_buf[i].iov_len);
>  	}
>  	printf("\n");
>  	xlog_recover_print_logitem(item);
> diff --git a/logprint/log_redo.c b/logprint/log_redo.c
> index 89d7448342..f5bac21d35 100644
> --- a/logprint/log_redo.c
> +++ b/logprint/log_redo.c
> @@ -143,8 +143,8 @@
>  	int			i;
>  	uint			src_len, dst_len;
>  
> -	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].i_addr;
> -	src_len = item->ri_buf[0].i_len;
> +	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].iov_base;
> +	src_len = item->ri_buf[0].iov_len;
>  	/*
>  	 * An xfs_efi_log_format structure contains a variable length array
>  	 * as the last field.
> @@ -229,7 +229,7 @@
>  	const char		*item_name = "EFD?";
>  	xfs_efd_log_format_t	*f;
>  
> -	f = (xfs_efd_log_format_t *)item->ri_buf[0].i_addr;
> +	f = (xfs_efd_log_format_t *)item->ri_buf[0].iov_base;
>  
>  	switch (f->efd_type) {
>  	case XFS_LI_EFD:	item_name = "EFD"; break;
> @@ -355,8 +355,8 @@
>  	char				*src_f;
>  	uint				src_len;
>  
> -	src_f = item->ri_buf[0].i_addr;
> -	src_len = item->ri_buf[0].i_len;
> +	src_f = item->ri_buf[0].iov_base;
> +	src_len = item->ri_buf[0].iov_len;
>  
>  	xlog_print_trans_rui(&src_f, src_len, 0);
>  }
> @@ -406,7 +406,7 @@
>  {
>  	char				*f;
>  
> -	f = item->ri_buf[0].i_addr;
> +	f = item->ri_buf[0].iov_base;
>  	xlog_print_trans_rud(&f, sizeof(struct xfs_rud_log_format));
>  }
>  
> @@ -516,8 +516,8 @@
>  	char				*src_f;
>  	uint				src_len;
>  
> -	src_f = item->ri_buf[0].i_addr;
> -	src_len = item->ri_buf[0].i_len;
> +	src_f = item->ri_buf[0].iov_base;
> +	src_len = item->ri_buf[0].iov_len;
>  
>  	xlog_print_trans_cui(&src_f, src_len, 0);
>  }
> @@ -563,7 +563,7 @@
>  {
>  	char				*f;
>  
> -	f = item->ri_buf[0].i_addr;
> +	f = item->ri_buf[0].iov_base;
>  	xlog_print_trans_cud(&f, sizeof(struct xfs_cud_log_format));
>  }
>  
> @@ -667,8 +667,8 @@
>  	char				*src_f;
>  	uint				src_len;
>  
> -	src_f = item->ri_buf[0].i_addr;
> -	src_len = item->ri_buf[0].i_len;
> +	src_f = item->ri_buf[0].iov_base;
> +	src_len = item->ri_buf[0].iov_len;
>  
>  	xlog_print_trans_bui(&src_f, src_len, 0);
>  }
> @@ -707,7 +707,7 @@
>  {
>  	char				*f;
>  
> -	f = item->ri_buf[0].i_addr;
> +	f = item->ri_buf[0].iov_base;
>  	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
>  }
>  
> @@ -954,8 +954,8 @@
>  	unsigned int			new_value_len = 0;
>  	int				region = 0;
>  
> -	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
> -	src_len = item->ri_buf[region].i_len;
> +	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].iov_base;
> +	src_len = item->ri_buf[region].iov_len;
>  
>  	/*
>  	 * An xfs_attri_log_format structure contains a attribute name and
> @@ -996,17 +996,17 @@
>  	if (name_len > 0) {
>  		region++;
>  		printf(_("ATTRI:  name len:%u\n"), name_len);
> -		print_or_dump((char *)item->ri_buf[region].i_addr,
> +		print_or_dump((char *)item->ri_buf[region].iov_base,
>  			       name_len);
> -		name_ptr = item->ri_buf[region].i_addr;
> +		name_ptr = item->ri_buf[region].iov_base;
>  	}
>  
>  	if (new_name_len > 0) {
>  		region++;
>  		printf(_("ATTRI:  newname len:%u\n"), new_name_len);
> -		print_or_dump((char *)item->ri_buf[region].i_addr,
> +		print_or_dump((char *)item->ri_buf[region].iov_base,
>  			       new_name_len);
> -		new_name_ptr = item->ri_buf[region].i_addr;
> +		new_name_ptr = item->ri_buf[region].iov_base;
>  	}
>  
>  	if (value_len > 0) {
> @@ -1014,8 +1014,8 @@
>  
>  		region++;
>  		printf(_("ATTRI:  value len:%u\n"), value_len);
> -		print_or_dump((char *)item->ri_buf[region].i_addr, len);
> -		value_ptr = item->ri_buf[region].i_addr;
> +		print_or_dump((char *)item->ri_buf[region].iov_base, len);
> +		value_ptr = item->ri_buf[region].iov_base;
>  	}
>  
>  	if (new_value_len > 0) {
> @@ -1023,8 +1023,8 @@
>  
>  		region++;
>  		printf(_("ATTRI:  newvalue len:%u\n"), new_value_len);
> -		print_or_dump((char *)item->ri_buf[region].i_addr, len);
> -		new_value_ptr = item->ri_buf[region].i_addr;
> +		print_or_dump((char *)item->ri_buf[region].iov_base, len);
> +		new_value_ptr = item->ri_buf[region].iov_base;
>  	}
>  
>  	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT)
> @@ -1065,7 +1065,7 @@
>  {
>  	struct xfs_attrd_log_format	*f;
>  
> -	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
> +	f = (struct xfs_attrd_log_format *)item->ri_buf[0].iov_base;
>  
>  	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
>  		f->alfd_size,
> @@ -1156,8 +1156,8 @@
>  	char				*src_f;
>  	uint				src_len;
>  
> -	src_f = item->ri_buf[0].i_addr;
> -	src_len = item->ri_buf[0].i_len;
> +	src_f = item->ri_buf[0].iov_base;
> +	src_len = item->ri_buf[0].iov_len;
>  
>  	xlog_print_trans_xmi(&src_f, src_len, 0);
>  }
> @@ -1196,6 +1196,6 @@
>  {
>  	char				*f;
>  
> -	f = item->ri_buf[0].i_addr;
> +	f = item->ri_buf[0].iov_base;
>  	xlog_print_trans_xmd(&f, sizeof(struct xfs_xmd_log_format));
>  }
> diff --git a/repair/phase2.c b/repair/phase2.c
> index e249980527..fc96f9c422 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -296,11 +296,7 @@
>  		 * there while we try to make a per-AG reservation with the new
>  		 * geometry.
>  		 */
> -		error = -libxfs_trans_alloc_empty(mp, &tp);
> -		if (error)
> -			do_error(
> -	_("Cannot reserve resources for upgrade check, err=%d.\n"),
> -					error);
> +		tp = libxfs_trans_alloc_empty(mp);
>  
>  		error = -libxfs_ialloc_read_agi(pag, tp, 0, &agi_bp);
>  		if (error)
> diff --git a/repair/pptr.c b/repair/pptr.c
> index ac0a9c618b..6a9e072b36 100644
> --- a/repair/pptr.c
> +++ b/repair/pptr.c
> @@ -1217,7 +1217,7 @@
>  	fscan->have_garbage = false;
>  	fscan->nr_file_pptrs = 0;
>  
> -	libxfs_trans_alloc_empty(ip->i_mount, &tp);
> +	tp = libxfs_trans_alloc_empty(ip->i_mount);
>  	error = xattr_walk(tp, ip, examine_xattr, fscan);
>  	if (tp)
>  		libxfs_trans_cancel(tp);
> @@ -1417,7 +1417,7 @@
>  		do_error("init garbage pptr names failed: %s\n",
>  				strerror(error));
>  
> -	libxfs_trans_alloc_empty(ip->i_mount, &tp);
> +	tp = libxfs_trans_alloc_empty(ip->i_mount);
>  	error = xattr_walk(tp, ip, erase_pptrs, &fscan);
>  	if (tp)
>  		libxfs_trans_cancel(tp);
> diff --git a/repair/quotacheck.c b/repair/quotacheck.c
> index df6cde2d58..f4c0314177 100644
> --- a/repair/quotacheck.c
> +++ b/repair/quotacheck.c
> @@ -437,9 +437,7 @@
>  	if (!dquots || !chkd_flags)
>  		return;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		do_error(_("could not alloc transaction to open quota file\n"));
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	ino = get_quota_inode(type);
>  	error = -libxfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
> @@ -679,9 +677,7 @@
>  	struct xfs_inode	*dp = NULL;
>  	int			error, err2;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		goto out;
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = -libxfs_dqinode_load_parent(tp, &dp);
>  	if (error)
> @@ -698,7 +694,6 @@
>  	libxfs_irele(dp);
>  out_cancel:
>  	libxfs_trans_cancel(tp);
> -out:
>  	if (error) {
>  		switch (error) {
>  		case EFSCORRUPTED:
> diff --git a/repair/rcbag.c b/repair/rcbag.c
> index 21732b65c6..d7addbf58e 100644
> --- a/repair/rcbag.c
> +++ b/repair/rcbag.c
> @@ -95,9 +95,7 @@
>  	int				has;
>  	int				error;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		do_error(_("allocating tx for refcount bag update\n"));
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
>  	error = rcbagbt_lookup_eq(cur, rmap, &has);
> @@ -217,9 +215,7 @@
>  	int			has;
>  	int			error;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		do_error(_("allocating tx for refcount bag update\n"));
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	/* go to the right edge of the tree */
>  	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
> diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
> index bed7c7a8f6..fc5f69c4d2 100644
> --- a/repair/rcbag_btree.c
> +++ b/repair/rcbag_btree.c
> @@ -46,8 +46,8 @@
>  	bag_rec->rbg_refcount = bag_irec->rbg_refcount;
>  }
>  
> -STATIC int64_t
> -rcbagbt_key_diff(
> +STATIC int
> +rcbagbt_cmp_key_with_cur(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*key)
>  {
> @@ -72,8 +72,8 @@
>  	return 0;
>  }
>  
> -STATIC int64_t
> -rcbagbt_diff_two_keys(
> +STATIC int
> +rcbagbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
>  	const union xfs_btree_key	*k2,
> @@ -220,9 +220,9 @@
>  	.init_key_from_rec	= rcbagbt_init_key_from_rec,
>  	.init_rec_from_cur	= rcbagbt_init_rec_from_cur,
>  	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
> -	.key_diff		= rcbagbt_key_diff,
> +	.cmp_key_with_cur	= rcbagbt_cmp_key_with_cur,
>  	.buf_ops		= &rcbagbt_mem_buf_ops,
> -	.diff_two_keys		= rcbagbt_diff_two_keys,
> +	.cmp_two_keys		= rcbagbt_cmp_two_keys,
>  	.keys_inorder		= rcbagbt_keys_inorder,
>  	.recs_inorder		= rcbagbt_recs_inorder,
>  };
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 97510dd875..e89bd32d63 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -323,9 +323,7 @@
>  	int			error;
>  
>  	xfbt = &rmaps_for_group(isrt, agno)->ar_xfbtree;
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		do_error(_("allocating tx for in-memory rmap update\n"));
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = rmap_init_mem_cursor(mp, tp, isrt, agno, &rmcur);
>  	if (error)
> diff --git a/repair/rt.c b/repair/rt.c
> index 1ac2bf6fc4..781d896844 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -301,10 +301,7 @@
>  	if (rtg->rtg_inodes[type])
>  		goto out_rtg;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		goto out_rtg;
> -
> +	tp = libxfs_trans_alloc_empty(mp);
>  
>  	error = -libxfs_rtginode_load(rtg, type, tp);
>  	if (error)
> @@ -497,9 +494,7 @@
>  	int			error, err2;
>  	int			i;
>  
> -	error = -libxfs_trans_alloc_empty(mp, &tp);
> -	if (error)
> -		goto out;
> +	tp = libxfs_trans_alloc_empty(mp);
>  	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
>  		error = -libxfs_rtginode_load_parent(tp);
>  		if (error)
> @@ -516,7 +511,6 @@
>  
>  out_cancel:
>  	libxfs_trans_cancel(tp);
> -out:
>  	if (xfs_has_rtgroups(mp) && error) {
>  		/*
>  		 * Old xfs_repair didn't complain if rtbitmaps didn't load
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 2f3c87be79..4ed7cd9963 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -197,8 +197,6 @@
>  	return seen_mask;
>  }
>  
> -#define cmp_int(l, r)		((l > r) - (l < r))
> -
>  /* Compare two bulkstat records by inumber. */
>  static int
>  compare_bstat(

