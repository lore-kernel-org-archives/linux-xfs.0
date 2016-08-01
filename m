Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC0FE7D28
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 13:09:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD7AD304048
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 11:09:03 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id enPZrOricQZNj1uX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 11:09:00 -0700 (PDT)
Date: Mon, 1 Aug 2016 11:08:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 38/47] xfs: create rmap update intent log items
Message-ID: <20160801180819.GD8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907721624.25461.1280539951915485473.stgit@birch.djwong.org>
	<20160801071237.GO15590@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801071237.GO15590@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 12:12:37AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 20, 2016 at 10:00:16PM -0700, Darrick J. Wong wrote:
> > Create rmap update intent/done log items to record redo information in
> > the log.  Because we need to roll transactions between updating the
> > bmbt mapping and updating the reverse mapping, we also have to track
> > the status of the metadata updates that will be recorded in the
> > post-roll transactions, just in case we crash before committing the
> > final transaction.  This mechanism enables log recovery to finish what
> > was already started.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> There is absolutely no need to log the extent array in the rmap update
> done item.  We have always done this for the EFD, but if you look at it
> it's not actually needed there either.

I was aware that nothing ever used the extent array in the EFD and
I've long wondered why it's even there.

Fortunately it helps to have someone else say "nobody will ever use
this, so don't go adding it for new redo items". :)

I'll remove the extent arrays from the log update done items.

--D

> Something like the patch below (relative to your whole tree) will fix
> this up and reduce the amount of data logged:
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index a8d794d..a6eed43 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -658,9 +658,8 @@ struct xfs_rui_log_format {
>  struct xfs_rud_log_format {
>  	__uint16_t		rud_type;	/* rud log item type */
>  	__uint16_t		rud_size;	/* size of this item */
> -	__uint32_t		rud_nextents;	/* # of extents freed */
> +	__uint32_t		__pad;
>  	__uint64_t		rud_rui_id;	/* id of corresponding rui */
> -	struct xfs_map_extent	rud_extents[1];	/* array of extents rmapped */
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e51fd2b..e8638fd 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3482,9 +3482,7 @@ xlog_recover_rud_pass2(
>  	struct xfs_ail			*ailp = log->l_ailp;
>  
>  	rud_formatp = item->ri_buf[0].i_addr;
> -	ASSERT(item->ri_buf[0].i_len == (sizeof(struct xfs_rud_log_format) +
> -			((rud_formatp->rud_nextents - 1) *
> -			sizeof(struct xfs_map_extent))));
> +	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
>  	rui_id = rud_formatp->rud_rui_id;
>  
>  	/*
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 6d6cc3b..7e47432 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -273,36 +273,13 @@ static inline struct xfs_rud_log_item *RUD_ITEM(struct xfs_log_item *lip)
>  }
>  
>  STATIC void
> -xfs_rud_item_free(struct xfs_rud_log_item *rudp)
> -{
> -	if (rudp->rud_format.rud_nextents > XFS_RUD_MAX_FAST_EXTENTS)
> -		kmem_free(rudp);
> -	else
> -		kmem_zone_free(xfs_rud_zone, rudp);
> -}
> -
> -/*
> - * This returns the number of iovecs needed to log the given rud item.
> - * We only need 1 iovec for an rud item.  It just logs the rud_log_format
> - * structure.
> - */
> -static inline int
> -xfs_rud_item_sizeof(
> -	struct xfs_rud_log_item	*rudp)
> -{
> -	return sizeof(struct xfs_rud_log_format) +
> -			(rudp->rud_format.rud_nextents - 1) *
> -			sizeof(struct xfs_map_extent);
> -}
> -
> -STATIC void
>  xfs_rud_item_size(
>  	struct xfs_log_item	*lip,
>  	int			*nvecs,
>  	int			*nbytes)
>  {
>  	*nvecs += 1;
> -	*nbytes += xfs_rud_item_sizeof(RUD_ITEM(lip));
> +	*nbytes += sizeof(struct xfs_rud_log_format);
>  }
>  
>  /*
> @@ -320,13 +297,11 @@ xfs_rud_item_format(
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  	struct xfs_log_iovec	*vecp = NULL;
>  
> -	ASSERT(rudp->rud_next_extent == rudp->rud_format.rud_nextents);
> -
>  	rudp->rud_format.rud_type = XFS_LI_RUD;
>  	rudp->rud_format.rud_size = 1;
>  
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
> -			xfs_rud_item_sizeof(rudp));
> +			sizeof(struct xfs_rud_log_format));
>  }
>  
>  /*
> @@ -374,7 +349,7 @@ xfs_rud_item_unlock(
>  
>  	if (lip->li_flags & XFS_LI_ABORTED) {
>  		xfs_rui_release(rudp->rud_ruip);
> -		xfs_rud_item_free(rudp);
> +		kmem_zone_free(xfs_rud_zone, rudp);
>  	}
>  }
>  
> @@ -398,7 +373,7 @@ xfs_rud_item_committed(
>  	 * aborted due to log I/O error).
>  	 */
>  	xfs_rui_release(rudp->rud_ruip);
> -	xfs_rud_item_free(rudp);
> +	kmem_zone_free(xfs_rud_zone, rudp);
>  
>  	return (xfs_lsn_t)-1;
>  }
> @@ -437,25 +412,14 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
>  struct xfs_rud_log_item *
>  xfs_rud_init(
>  	struct xfs_mount		*mp,
> -	struct xfs_rui_log_item		*ruip,
> -	uint				nextents)
> +	struct xfs_rui_log_item		*ruip)
>  
>  {
>  	struct xfs_rud_log_item	*rudp;
> -	uint			size;
> -
> -	ASSERT(nextents > 0);
> -	if (nextents > XFS_RUD_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(struct xfs_rud_log_item) +
> -			((nextents - 1) * sizeof(struct xfs_map_extent)));
> -		rudp = kmem_zalloc(size, KM_SLEEP);
> -	} else {
> -		rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
> -	}
>  
> +	rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
>  	xfs_log_item_init(mp, &rudp->rud_item, XFS_LI_RUD, &xfs_rud_item_ops);
>  	rudp->rud_ruip = ruip;
> -	rudp->rud_format.rud_nextents = nextents;
>  	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
>  
>  	return rudp;
> @@ -523,7 +487,7 @@ xfs_rui_recover(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
> -	rudp = xfs_trans_get_rud(tp, ruip, ruip->rui_format.rui_nextents);
> +	rudp = xfs_trans_get_rud(tp, ruip);
>  
>  	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
>  		rmap = &(ruip->rui_format.rui_extents[i]);
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 59ef3ec..aefcc3a 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -77,21 +77,15 @@ struct xfs_rui_log_item {
>  struct xfs_rud_log_item {
>  	struct xfs_log_item		rud_item;
>  	struct xfs_rui_log_item		*rud_ruip;
> -	uint				rud_next_extent;
>  	struct xfs_rud_log_format	rud_format;
>  };
>  
> -/*
> - * Max number of extents in fast allocation path.
> - */
> -#define	XFS_RUD_MAX_FAST_EXTENTS	16
> -
>  extern struct kmem_zone	*xfs_rui_zone;
>  extern struct kmem_zone	*xfs_rud_zone;
>  
>  struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
>  struct xfs_rud_log_item *xfs_rud_init(struct xfs_mount *,
> -		struct xfs_rui_log_item *, uint);
> +		struct xfs_rui_log_item *);
>  int xfs_rui_copy_format(struct xfs_log_iovec *buf,
>  		struct xfs_rui_log_format *dst_rui_fmt);
>  void xfs_rui_item_free(struct xfs_rui_log_item *);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 45773df..24ef83e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1770,9 +1770,7 @@ xfs_init_zones(void)
>  	if (!xfs_icreate_zone)
>  		goto out_destroy_ili_zone;
>  
> -	xfs_rud_zone = kmem_zone_init((sizeof(struct xfs_rud_log_item) +
> -			((XFS_RUD_MAX_FAST_EXTENTS - 1) *
> -				 sizeof(struct xfs_map_extent))),
> +	xfs_rud_zone = kmem_zone_init(sizeof(struct xfs_rud_log_item),
>  			"xfs_rud_item");
>  	if (!xfs_rud_zone)
>  		goto out_destroy_icreate_zone;
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index bb4b84f..e2bf86a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -241,7 +241,7 @@ enum xfs_rmap_intent_type;
>  
>  void xfs_rmap_update_init_defer_op(void);
>  struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
> -		struct xfs_rui_log_item *ruip, uint nextents);
> +		struct xfs_rui_log_item *ruip);
>  int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
>  		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
>  		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> index 8341476..35650d6 100644
> --- a/fs/xfs/xfs_trans_rmap.c
> +++ b/fs/xfs/xfs_trans_rmap.c
> @@ -129,29 +129,14 @@ xfs_trans_log_start_rmap_update(
>  	xfs_trans_set_rmap_flags(rmap, type, whichfork, state);
>  }
>  
> -/*
> - * This routine is called to allocate an "rmap update done"
> - * log item that will hold nextents worth of extents.  The
> - * caller must use all nextents extents, because we are not
> - * flexible about this at all.
> - */
>  struct xfs_rud_log_item *
>  xfs_trans_get_rud(
>  	struct xfs_trans		*tp,
> -	struct xfs_rui_log_item		*ruip,
> -	uint				nextents)
> +	struct xfs_rui_log_item		*ruip)
>  {
>  	struct xfs_rud_log_item		*rudp;
>  
> -	ASSERT(tp != NULL);
> -	ASSERT(nextents > 0);
> -
> -	rudp = xfs_rud_init(tp->t_mountp, ruip, nextents);
> -	ASSERT(rudp != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> +	rudp = xfs_rud_init(tp->t_mountp, ruip);
>  	xfs_trans_add_item(tp, &rudp->rud_item);
>  	return rudp;
>  }
> @@ -174,8 +159,6 @@ xfs_trans_log_finish_rmap_update(
>  	xfs_exntst_t			state,
>  	struct xfs_btree_cur		**pcur)
>  {
> -	uint				next_extent;
> -	struct xfs_map_extent		*rmap;
>  	int				error;
>  
>  	error = xfs_rmap_finish_one(tp, type, owner, whichfork, startoff,
> @@ -191,16 +174,6 @@ xfs_trans_log_finish_rmap_update(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	rudp->rud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
>  
> -	next_extent = rudp->rud_next_extent;
> -	ASSERT(next_extent < rudp->rud_format.rud_nextents);
> -	rmap = &(rudp->rud_format.rud_extents[next_extent]);
> -	rmap->me_owner = owner;
> -	rmap->me_startblock = startblock;
> -	rmap->me_startoff = startoff;
> -	rmap->me_len = blockcount;
> -	xfs_trans_set_rmap_flags(rmap, type, whichfork, state);
> -	rudp->rud_next_extent++;
> -
>  	return error;
>  }
>  
> @@ -255,7 +228,7 @@ xfs_rmap_update_create_done(
>  	void				*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_rud(tp, intent, count);
> +	return xfs_trans_get_rud(tp, intent);
>  }
>  
>  /* Process a deferred rmap update. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
