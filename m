Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73FE34D926
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236982; cv=none; b=TFhAF1j/HJrn6XWZKw4RF6v8TFie/ym6CNsTdrNI9sDRA5ckHjwQQJpl6kE0qYJ1vq3UK5E+NVowngGW5OnwZ3IRVazita/ObqxaBj7djD3OLvXEdXr2jm9y1bmVNW8HKDICwa1z3ytvdC4HLEVlUmffqyfBxpRdC0AjQ5TD0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236982; c=relaxed/simple;
	bh=UGM9dd/U1Bw66Z/GL2qAwM8/9I9NdngQxef9cWQ85H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOpPrTYHvkG34sM8+KF0PZyMGXnyOhtfDmIFQabLdL2DQffMS+WvU+dR/s8KZ0BOXo8uk4uvaXzV0Rxtx9gefGF0k8rlkhvN7cE6TVXIuJPc3z67khtoyRa4Vmxx/W5TVLClOTQSkJOTJqB9wRkSF/g0EBWMiP3jYEtkNYCsVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7Lh+zD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7Lh+zD+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2EBB11F000FF;
	Mon,  5 Oct 2026 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236980;
	bh=8s0GJUO3BuuVM4eRC1LGkmsfDRc8wvrv4dRR32GWS08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F7Lh+zD+ELJsb5hRikbNAjwsTnuR2AbHbarexl+DitsI3TwiRn8PBMc9QNcA1KaxQ
	 1vaEuiFjZnG6l8DHEtXKQP+YaZsG4FWFA+YBrcIdFL8LBVROHH77KlnC74BclldvP9
	 j/yz9dc3VpCiIhY/e43EH1EB7C90ivYkPze31jWMiQ52K7uYAZq01Q/ptx8Y0EQESm
	 lgg38eMnlBvkbboDkD7d5c6FbGYxuaL7ccj6c2KEC/ln0NHrEB0bFzTz4/Ql6xeCBZ
	 l2l2I2IutEZ6rdW8iV7XMH7eP1YnjlBTG8FZHWmvIgGsXCubo1vxq7VSrGF2sNk+em
	 esUXCAZ+0UXzg==
Date: Mon, 5 Oct 2026 14:49:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
Message-ID: <20261005214939.GR2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-13-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:22PM +0200, Christoph Hellwig wrote:
> Replace the the existing xfs_trans.h with a copy of the kernel versions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer to have the same header, though I wonder if we ought some day
to move the kernel xfs_trans.h into libxfs/ ?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/Makefile          |   4 +-
>  libxfs/libxfs_api_defs.h |   1 +
>  libxfs/stubs/xfs_trans.h | 132 ------------------
>  libxfs/trans.c           |  22 +++
>  libxfs/xfs_platform.h    |  12 --
>  libxfs/xfs_trans.h       | 283 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 308 insertions(+), 146 deletions(-)
>  delete mode 100644 libxfs/stubs/xfs_trans.h
>  create mode 100644 libxfs/xfs_trans.h
> 
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index f64dd596b645..ac7ddac5acec 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -47,6 +47,7 @@ HFILES = \
>  	xfs_cksum.h \
>  	xfs_da_btree.h \
>  	xfs_dir2.h \
> +	xfs_dir2_priv.h \
>  	xfs_errortag.h \
>  	xfs_exchmaps.h \
>  	xfs_group.h \
> @@ -73,7 +74,7 @@ HFILES = \
>  	xfs_shared.h \
>  	xfs_trans_resv.h \
>  	xfs_trans_space.h \
> -	xfs_dir2_priv.h \
> +	xfs_trans.h \
>  	xfs_zones.h \
>  	stubs/xfs_buf_mem.h \
>  	stubs/xfs_error.h \
> @@ -83,7 +84,6 @@ HFILES = \
>  	stubs/xfs_mount.h \
>  	stubs/xfs_quota.h \
>  	stubs/xfs_trace.h \
> -	stubs/xfs_trans.h \
>  	stubs/xfs_trans_priv.h
>  
>  CFILES = buf_mem.c \
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 4f542ae7267e..300135fcac8b 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -391,6 +391,7 @@
>  #define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
>  #define xfs_trans_read_buf		libxfs_trans_read_buf
>  #define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
> +#define xfs_trans_reserve_more		libxfs_trans_reserve_more
>  #define xfs_trans_resv_calc		libxfs_trans_resv_calc
>  #define xfs_trans_roll_inode		libxfs_trans_roll_inode
>  #define xfs_trans_roll			libxfs_trans_roll
> diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
> deleted file mode 100644
> index 2619347df923..000000000000
> --- a/libxfs/stubs/xfs_trans.h
> +++ /dev/null
> @@ -1,132 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -
> -#ifndef __XFS_TRANS_H__
> -#define __XFS_TRANS_H__
> -
> -struct xfs_mount;
> -struct xfs_buftarg;
> -struct xfs_buf;
> -struct xfs_buf_map;
> -
> -/*
> - * Userspace Transaction interface
> - */
> -
> -struct xfs_item_ops {
> -	uint64_t (*iop_sort)(struct xfs_log_item *lip);
> -	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
> -};
> -
> -struct xfs_log_item {
> -	struct list_head		li_trans;	/* transaction list */
> -	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
> -	uint				li_type;	/* item type */
> -	unsigned long			li_flags;	/* misc flags */
> -	struct xfs_buf			*li_buf;	/* real buffer pointer */
> -	struct list_head		li_bio_list;	/* buffer item list */
> -	const struct xfs_item_ops	*li_ops;	/* function list */
> -};
> -
> -#define XFS_LI_DIRTY	3	/* log item dirty in transaction */
> -
> -typedef struct xfs_trans {
> -	unsigned int		t_log_res;	/* amt of log space resvd */
> -	unsigned int		t_log_count;	/* count for perm log res */
> -	unsigned int		t_blk_res;	/* # of blocks resvd */
> -	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
> -	unsigned int		t_rtx_res;	/* # of rt extents resvd */
> -	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
> -	unsigned int		t_flags;	/* misc flags */
> -	xfs_agnumber_t		t_highest_agno;	/* highest AGF locked */
> -	struct xfs_mount 	*t_mountp;	/* ptr to fs mount struct */
> -	struct xfs_dquot_acct	*t_dqinfo;	/* acctg info for dquots */
> -	long			t_icount_delta;	/* superblock icount change */
> -	long			t_ifree_delta;	/* superblock ifree change */
> -	long			t_fdblocks_delta;/* superblock fdblocks chg */
> -	long			t_frextents_delta;/* superblock freextents chg*/
> -	struct list_head	t_items;	/* log item descriptors */
> -	struct list_head	t_dfops;	/* deferred operations */
> -} xfs_trans_t;
> -
> -int	xfs_trans_roll(struct xfs_trans **);
> -
> -int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
> -			   uint blocks, uint rtextents, uint flags,
> -			   struct xfs_trans **tpp);
> -int	libxfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
> -			unsigned int dblocks, unsigned int rblocks, bool force,
> -			struct xfs_trans **tpp);
> -int	libxfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
> -			struct xfs_inode *ip, unsigned int *dblocks,
> -			struct xfs_trans **tpp, int *nospace_error);
> -struct xfs_trans *libxfs_trans_alloc_empty(struct xfs_mount *mp);
> -int	libxfs_trans_commit(struct xfs_trans *);
> -void	libxfs_trans_cancel(struct xfs_trans *);
> -int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
> -			uint rtextents);
> -
> -/* cancel dfops associated with a transaction */
> -void xfs_defer_cancel(struct xfs_trans *);
> -
> -struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *);
> -struct xfs_buf *libxfs_trans_getrtsb(struct xfs_trans *tp);
> -
> -void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> -void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
> -				uint);
> -int	libxfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
> -
> -void	libxfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
> -void	libxfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_bhold_release(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
> -				uint, uint);
> -bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
> -
> -int	libxfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *btp,
> -		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
> -		struct xfs_buf **bpp);
> -
> -int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
> -				  struct xfs_buftarg *btp,
> -				  struct xfs_buf_map *map, int nmaps,
> -				  xfs_buf_flags_t flags, struct xfs_buf **bpp,
> -				  const struct xfs_buf_ops *ops);
> -static inline int
> -libxfs_trans_get_buf(
> -	struct xfs_trans	*tp,
> -	struct xfs_buftarg	*btp,
> -	xfs_daddr_t		blkno,
> -	int			numblks,
> -	uint			flags,
> -	struct xfs_buf		**bpp)
> -{
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -
> -	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags, bpp);
> -}
> -
> -static inline int
> -libxfs_trans_read_buf(
> -	struct xfs_mount	*mp,
> -	struct xfs_trans	*tp,
> -	struct xfs_buftarg	*btp,
> -	xfs_daddr_t		blkno,
> -	int			numblks,
> -	xfs_buf_flags_t		flags,
> -	struct xfs_buf		**bpp,
> -	const struct xfs_buf_ops *ops)
> -{
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
> -}
> -
> -#endif	/* __XFS_TRANS_H__ */
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 77a2a574809e..25015ad2795c 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -353,6 +353,21 @@ xfs_buf_item_put(
>  
>  /* from xfs_trans_buf.c */
>  
> +void
> +xfs_trans_buf_set_type(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp,
> +	enum xfs_blft		type)
> +{
> +}
> +
> +void
> +xfs_trans_buf_copy_type(
> +	struct xfs_buf		*dst_bp,
> +	struct xfs_buf		*src_bp)
> +{
> +}
> +
>  /*
>   * Add the locked buffer to the transaction.
>   *
> @@ -765,6 +780,13 @@ libxfs_trans_binval(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  }
>  
> +void
> +xfs_trans_inode_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +}
> +
>  /*
>   * Mark the buffer as being one which contains newly allocated
>   * inodes.  We need to make sure that even if this buffer is
> diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
> index 4a899dcc6461..4b0069fd70d7 100644
> --- a/libxfs/xfs_platform.h
> +++ b/libxfs/xfs_platform.h
> @@ -314,16 +314,6 @@ xfs_buf_incore(
>  void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
>  #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
>  
> -/* mount stuff */
> -#define xfs_trans_set_sync(tp)		((void) 0)
> -#define xfs_trans_buf_set_type(tp, bp, t)	({	\
> -	int __t = (t);					\
> -	__t = __t; /* no set-but-unused warning */	\
> -	tp = tp;  /* no set-but-unused warning */	\
> -})
> -
> -#define xfs_trans_buf_copy_type(dbp, sbp)
> -
>  static inline void
>  xfs_buf_readahead(
>  	struct xfs_buftarg	*target,
> @@ -357,8 +347,6 @@ xfs_buf_readahead(
>  #define xfs_filestream_new_ag(ip,ag)		(0)
>  #define xfs_filestream_select_ag(...)		(-ENOSYS)
>  
> -#define xfs_trans_inode_buf(tp, bp)		((void) 0)
> -
>  #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
>  #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
>  
> diff --git a/libxfs/xfs_trans.h b/libxfs/xfs_trans.h
> new file mode 100644
> index 000000000000..eb83c5dac032
> --- /dev/null
> +++ b/libxfs/xfs_trans.h
> @@ -0,0 +1,283 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef	__XFS_TRANS_H__
> +#define	__XFS_TRANS_H__
> +
> +/* kernel only transaction subsystem defines */
> +
> +struct xlog;
> +struct xlog_format_buf;
> +struct xfs_buf;
> +struct xfs_buftarg;
> +struct xfs_efd_log_item;
> +struct xfs_efi_log_item;
> +struct xfs_inode;
> +struct xfs_item_ops;
> +struct xfs_mount;
> +struct xfs_trans;
> +struct xfs_trans_res;
> +struct xfs_dquot_acct;
> +struct xfs_rud_log_item;
> +struct xfs_rui_log_item;
> +struct xfs_btree_cur;
> +struct xfs_cui_log_item;
> +struct xfs_cud_log_item;
> +struct xfs_bui_log_item;
> +struct xfs_bud_log_item;
> +
> +struct xfs_log_item {
> +	struct list_head		li_ail;		/* AIL pointers */
> +	struct list_head		li_trans;	/* transaction list */
> +	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
> +	struct xlog			*li_log;
> +	struct xfs_ail			*li_ailp;	/* ptr to AIL */
> +	uint				li_type;	/* item type */
> +	unsigned long			li_flags;	/* misc flags */
> +	struct xfs_buf			*li_buf;	/* real buffer pointer */
> +	struct list_head		li_bio_list;	/* buffer item list */
> +	const struct xfs_item_ops	*li_ops;	/* function list */
> +
> +	/* delayed logging */
> +	struct list_head		li_cil;		/* CIL pointers */
> +	struct xfs_log_vec		*li_lv;		/* active log vector */
> +	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
> +	xfs_csn_t			li_seq;		/* CIL commit seq */
> +	uint32_t			li_order_id;	/* CIL commit order */
> +};
> +
> +/*
> + * li_flags use the (set/test/clear)_bit atomic interfaces because updates can
> + * race with each other and we don't want to have to use the AIL lock to
> + * serialise all updates.
> + */
> +#define	XFS_LI_IN_AIL	0
> +#define	XFS_LI_ABORTED	1
> +#define	XFS_LI_FAILED	2
> +#define	XFS_LI_DIRTY	3
> +#define	XFS_LI_WHITEOUT	4
> +#define	XFS_LI_FLUSHING	5
> +
> +#define XFS_LI_FLAGS \
> +	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
> +	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
> +	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
> +	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
> +	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }, \
> +	{ (1u << XFS_LI_FLUSHING),	"FLUSHING" }
> +
> +struct xfs_item_ops {
> +	unsigned flags;
> +	void (*iop_size)(struct xfs_log_item *, int *, int *);
> +	void (*iop_format)(struct xfs_log_item *lip,
> +			struct xlog_format_buf *lfb);
> +	void (*iop_pin)(struct xfs_log_item *);
> +	void (*iop_unpin)(struct xfs_log_item *, int remove);
> +	uint64_t (*iop_sort)(struct xfs_log_item *lip);
> +	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
> +	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
> +	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
> +	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> +	void (*iop_release)(struct xfs_log_item *);
> +	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
> +	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
> +};
> +
> +/*
> + * Log item ops flags
> + */
> +/*
> + * Release the log item when the journal commits instead of inserting into the
> + * AIL for writeback tracking and/or log tail pinning.
> + */
> +#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> +#define XFS_ITEM_INTENT			(1 << 1)
> +#define XFS_ITEM_INTENT_DONE		(1 << 2)
> +
> +static inline bool
> +xlog_item_is_intent(struct xfs_log_item *lip)
> +{
> +	return lip->li_ops->flags & XFS_ITEM_INTENT;
> +}
> +
> +static inline bool
> +xlog_item_is_intent_done(struct xfs_log_item *lip)
> +{
> +	return lip->li_ops->flags & XFS_ITEM_INTENT_DONE;
> +}
> +
> +void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> +			  int type, const struct xfs_item_ops *ops);
> +
> +/*
> + * Return values for the iop_push() routines.
> + */
> +#define XFS_ITEM_SUCCESS	0
> +#define XFS_ITEM_PINNED		1
> +#define XFS_ITEM_LOCKED		2
> +#define XFS_ITEM_FLUSHING	3
> +
> +/*
> + * This is the structure maintained for every active transaction.
> + */
> +typedef struct xfs_trans {
> +	unsigned int		t_log_res;	/* amt of log space resvd */
> +	unsigned int		t_log_count;	/* count for perm log res */
> +	unsigned int		t_blk_res;	/* # of blocks resvd */
> +	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
> +	unsigned int		t_rtx_res;	/* # of rt extents resvd */
> +	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
> +	unsigned int		t_flags;	/* misc flags */
> +	xfs_agnumber_t		t_highest_agno;	/* highest AGF locked */
> +	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
> +	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
> +	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
> +	int64_t			t_icount_delta;	/* superblock icount change */
> +	int64_t			t_ifree_delta;	/* superblock ifree change */
> +	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
> +	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
> +	int64_t			t_frextents_delta;/* superblock freextents chg*/
> +	int64_t			t_res_frextents_delta; /* on-disk only chg */
> +	int64_t			t_dblocks_delta;/* superblock dblocks change */
> +	int64_t			t_agcount_delta;/* superblock agcount change */
> +	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
> +	int64_t			t_rextsize_delta;/* superblock rextsize chg */
> +	int64_t			t_rbmblocks_delta;/* superblock rbmblocks chg */
> +	int64_t			t_rblocks_delta;/* superblock rblocks change */
> +	int64_t			t_rextents_delta;/* superblocks rextents chg */
> +	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
> +	int64_t			t_rgcount_delta; /* realtime group count */
> +	struct list_head	t_items;	/* log item descriptors */
> +	struct list_head	t_busy;		/* list of busy extents */
> +	struct list_head	t_dfops;	/* deferred operations */
> +	unsigned long		t_pflags;	/* saved process flags state */
> +} xfs_trans_t;
> +
> +/*
> + * XFS transaction mechanism exported interfaces that are
> + * actually macros.
> + */
> +#define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
> +
> +/*
> + * XFS transaction mechanism exported interfaces.
> + */
> +int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
> +			uint blocks, uint rtextents, uint flags,
> +			struct xfs_trans **tpp);
> +int		xfs_trans_reserve_more(struct xfs_trans *tp,
> +			unsigned int blocks, unsigned int rtextents);
> +struct xfs_trans *xfs_trans_alloc_empty(struct xfs_mount *mp);
> +void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
> +
> +int xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *target,
> +		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
> +		struct xfs_buf **bpp);
> +
> +static inline int
> +xfs_trans_get_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	int			numblks,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp)
> +{
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	return xfs_trans_get_buf_map(tp, target, &map, 1, flags, bpp);
> +}
> +
> +int		xfs_trans_read_buf_map(struct xfs_mount *mp,
> +				       struct xfs_trans *tp,
> +				       struct xfs_buftarg *target,
> +				       struct xfs_buf_map *map, int nmaps,
> +				       xfs_buf_flags_t flags,
> +				       struct xfs_buf **bpp,
> +				       const struct xfs_buf_ops *ops);
> +
> +static inline int
> +xfs_trans_read_buf(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	int			numblks,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	return xfs_trans_read_buf_map(mp, tp, target, &map, 1,
> +				      flags, bpp, ops);
> +}
> +
> +struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
> +struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
> +
> +void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
> +void		xfs_trans_bhold(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
> +bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
> +void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
> +void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> +void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
> +				  uint);
> +void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> +bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
> +void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> +
> +int		xfs_trans_commit(struct xfs_trans *);
> +int		xfs_trans_roll(struct xfs_trans **);
> +int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> +void		xfs_trans_cancel(xfs_trans_t *);
> +int		xfs_trans_ail_init(struct xfs_mount *);
> +void		xfs_trans_ail_destroy(struct xfs_mount *);
> +
> +void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
> +				       enum xfs_blft);
> +void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
> +					struct xfs_buf *src_bp);
> +
> +extern struct kmem_cache	*xfs_trans_cache;
> +
> +struct xfs_dquot;
> +
> +int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
> +		unsigned int dblocks, unsigned int rblocks, bool force,
> +		struct xfs_trans **tpp);
> +int xfs_trans_reserve_more_inode(struct xfs_trans *tp, struct xfs_inode *ip,
> +		unsigned int dblocks, unsigned int rblocks, bool force_quota);
> +int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
> +		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> +		struct xfs_dquot *pdqp, unsigned int dblocks,
> +		struct xfs_trans **tpp);
> +int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
> +		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
> +		struct xfs_trans **tpp);
> +int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
> +		struct xfs_inode *ip, unsigned int *dblocks,
> +		struct xfs_trans **tpp, int *nospace_error);
> +
> +static inline void
> +xfs_trans_set_context(
> +	struct xfs_trans	*tp)
> +{
> +	tp->t_pflags = memalloc_nofs_save();
> +}
> +
> +static inline void
> +xfs_trans_clear_context(
> +	struct xfs_trans	*tp)
> +{
> +	memalloc_nofs_restore(tp->t_pflags);
> +}
> +
> +#endif	/* __XFS_TRANS_H__ */
> -- 
> 2.53.0
> 
> 
