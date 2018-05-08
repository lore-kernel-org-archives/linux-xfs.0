Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932344AbeEHOSg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 10:18:36 -0400
Date: Tue, 8 May 2018 10:18:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/9] xfs: get rid of the log item descriptor
Message-ID: <20180508141835.GJ4764@bfoster.bfoster>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508034202.10136-10-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 01:42:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's just a connector between a transaction and a log item. There's
> a 1:1 relationship between a log item descriptor and a log item,
> and a 1:1 relationship between a log item descriptor and a
> transaction. Both relationships are created and terminated at the
> same time, so why do we even have the descriptor?
> 
> Replace it with a specific list_head in the log item and a new
> log item dirtied flag to replace the XFS_LID_DIRTY flag.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c    |  8 ++---
>  fs/xfs/libxfs/xfs_shared.h  | 15 ----------
>  fs/xfs/xfs_buf_item.c       |  2 +-
>  fs/xfs/xfs_icreate_item.c   |  2 +-
>  fs/xfs/xfs_log.c            | 10 +++----
>  fs/xfs/xfs_log_cil.c        | 21 ++++++--------
>  fs/xfs/xfs_super.c          | 10 +------
>  fs/xfs/xfs_trace.h          |  5 +---
>  fs/xfs/xfs_trans.c          | 58 ++++++++++---------------------------
>  fs/xfs/xfs_trans.h          |  8 ++---
>  fs/xfs/xfs_trans_bmap.c     |  4 +--
>  fs/xfs/xfs_trans_buf.c      | 22 ++++++--------
>  fs/xfs/xfs_trans_dquot.c    |  4 +--
>  fs/xfs/xfs_trans_extfree.c  |  4 +--
>  fs/xfs/xfs_trans_inode.c    |  3 +-
>  fs/xfs/xfs_trans_priv.h     |  1 -
>  fs/xfs/xfs_trans_refcount.c |  4 +--
>  fs/xfs/xfs_trans_rmap.c     |  4 +--
>  18 files changed, 62 insertions(+), 123 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 040eeda8426f..ab90998c1867 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -246,7 +246,7 @@ xfs_bmap_get_bp(
>  	struct xfs_btree_cur	*cur,
>  	xfs_fsblock_t		bno)
>  {
> -	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_item	*lip;
>  	int			i;
>  
>  	if (!cur)
> @@ -260,9 +260,9 @@ xfs_bmap_get_bp(
>  	}
>  
>  	/* Chase down all the log items to see if the bp is there */
> -	list_for_each_entry(lidp, &cur->bc_tp->t_items, lid_trans) {
> -		struct xfs_buf_log_item	*bip;
> -		bip = (struct xfs_buf_log_item *)lidp->lid_item;
> +	list_for_each_entry(lip, &cur->bc_tp->t_items, li_trans) {
> +		struct xfs_buf_log_item	*bip = (struct xfs_buf_log_item *)lip;
> +
>  		if (bip->bli_item.li_type == XFS_LI_BUF &&
>  		    XFS_BUF_ADDR(bip->bli_buf) == bno)
>  			return bip->bli_buf;
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index d0b84da0cb1e..8efc06e62b13 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -57,21 +57,6 @@ extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
>  extern const struct xfs_buf_ops xfs_rtbuf_ops;
>  
> -/*
> - * This structure is used to track log items associated with
> - * a transaction.  It points to the log item and keeps some
> - * flags to track the state of the log item.  It also tracks
> - * the amount of space needed to log the item it describes
> - * once we get to commit processing (see xfs_trans_commit()).
> - */
> -struct xfs_log_item_desc {
> -	struct xfs_log_item	*lid_item;
> -	struct list_head	lid_trans;
> -	unsigned char		lid_flags;
> -};
> -
> -#define XFS_LID_DIRTY		0x1
> -
>  /* log size calculation functions */
>  int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
>  int	xfs_log_calc_minimum_size(struct xfs_mount *);
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8d6ed045b643..c2311379d1c3 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -438,7 +438,7 @@ xfs_buf_item_unpin(
>  			 * xfs_trans_uncommit() will try to reference the
>  			 * buffer which we no longer have a hold on.
>  			 */
> -			if (lip->li_desc)
> +			if (!list_empty(&lip->li_trans))
>  				xfs_trans_del_item(lip);
>  
>  			/*
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index a99a0f8aa528..5da9599156ed 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -184,5 +184,5 @@ xfs_icreate_log(
>  
>  	xfs_trans_add_item(tp, &icp->ic_item);
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	icp->ic_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
>  }
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e427864434c1..c21039f27e39 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1047,6 +1047,7 @@ xfs_log_item_init(
>  	INIT_LIST_HEAD(&item->li_ail);
>  	INIT_LIST_HEAD(&item->li_cil);
>  	INIT_LIST_HEAD(&item->li_bio_list);
> +	INIT_LIST_HEAD(&item->li_trans);
>  }
>  
>  /*
> @@ -2110,10 +2111,10 @@ xlog_print_tic_res(
>   */
>  void
>  xlog_print_trans(
> -	struct xfs_trans		*tp)
> +	struct xfs_trans	*tp)
>  {
> -	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_log_item_desc	*lidp;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_log_item	*lip;
>  
>  	/* dump core transaction and ticket info */
>  	xfs_warn(mp, "transaction summary:");
> @@ -2124,8 +2125,7 @@ xlog_print_trans(
>  	xlog_print_tic_res(mp, tp->t_ticket);
>  
>  	/* dump each log item */
> -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> -		struct xfs_log_item	*lip = lidp->lid_item;
> +	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec	*lv = lip->li_lv;
>  		struct xfs_log_iovec	*vec;
>  		int			i;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index a8675c631438..c15687724728 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -141,10 +141,9 @@ xlog_cil_alloc_shadow_bufs(
>  	struct xlog		*log,
>  	struct xfs_trans	*tp)
>  {
> -	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_item	*lip;
>  
> -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> -		struct xfs_log_item *lip = lidp->lid_item;
> +	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec *lv;
>  		int	niovecs = 0;
>  		int	nbytes = 0;
> @@ -152,7 +151,7 @@ xlog_cil_alloc_shadow_bufs(
>  		bool	ordered = false;
>  
>  		/* Skip items which aren't dirty in this transaction. */
> -		if (!(lidp->lid_flags & XFS_LID_DIRTY))
> +		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
>  			continue;
>  
>  		/* get number of vecs and size of data to be stored */
> @@ -317,7 +316,7 @@ xlog_cil_insert_format_items(
>  	int			*diff_len,
>  	int			*diff_iovecs)
>  {
> -	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_item	*lip;
>  
>  
>  	/* Bail out if we didn't find a log item.  */
> @@ -326,15 +325,14 @@ xlog_cil_insert_format_items(
>  		return;
>  	}
>  
> -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> -		struct xfs_log_item *lip = lidp->lid_item;
> +	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec *lv;
>  		struct xfs_log_vec *old_lv = NULL;
>  		struct xfs_log_vec *shadow;
>  		bool	ordered = false;
>  
>  		/* Skip items which aren't dirty in this transaction. */
> -		if (!(lidp->lid_flags & XFS_LID_DIRTY))
> +		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
>  			continue;
>  
>  		/*
> @@ -406,7 +404,7 @@ xlog_cil_insert_items(
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
> -	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_item	*lip;
>  	int			len = 0;
>  	int			diff_iovecs = 0;
>  	int			iclog_space;
> @@ -479,11 +477,10 @@ xlog_cil_insert_items(
>  	 * We do this here so we only need to take the CIL lock once during
>  	 * the transaction commit.
>  	 */
> -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> -		struct xfs_log_item	*lip = lidp->lid_item;
> +	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  
>  		/* Skip items which aren't dirty in this transaction. */
> -		if (!(lidp->lid_flags & XFS_LID_DIRTY))
> +		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
>  			continue;
>  
>  		/*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d71424052917..5726ef496980 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1880,11 +1880,6 @@ xfs_init_zones(void)
>  	if (!xfs_trans_zone)
>  		goto out_destroy_ifork_zone;
>  
> -	xfs_log_item_desc_zone =
> -		kmem_zone_init(sizeof(struct xfs_log_item_desc),
> -			       "xfs_log_item_desc");
> -	if (!xfs_log_item_desc_zone)
> -		goto out_destroy_trans_zone;
>  
>  	/*
>  	 * The size of the zone allocated buf log item is the maximum
> @@ -1894,7 +1889,7 @@ xfs_init_zones(void)
>  	xfs_buf_item_zone = kmem_zone_init(sizeof(struct xfs_buf_log_item),
>  					   "xfs_buf_item");
>  	if (!xfs_buf_item_zone)
> -		goto out_destroy_log_item_desc_zone;
> +		goto out_destroy_trans_zone;
>  
>  	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
>  			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
> @@ -1982,8 +1977,6 @@ xfs_init_zones(void)
>  	kmem_zone_destroy(xfs_efd_zone);
>   out_destroy_buf_item_zone:
>  	kmem_zone_destroy(xfs_buf_item_zone);
> - out_destroy_log_item_desc_zone:
> -	kmem_zone_destroy(xfs_log_item_desc_zone);
>   out_destroy_trans_zone:
>  	kmem_zone_destroy(xfs_trans_zone);
>   out_destroy_ifork_zone:
> @@ -2022,7 +2015,6 @@ xfs_destroy_zones(void)
>  	kmem_zone_destroy(xfs_efi_zone);
>  	kmem_zone_destroy(xfs_efd_zone);
>  	kmem_zone_destroy(xfs_buf_item_zone);
> -	kmem_zone_destroy(xfs_log_item_desc_zone);
>  	kmem_zone_destroy(xfs_trans_zone);
>  	kmem_zone_destroy(xfs_ifork_zone);
>  	kmem_zone_destroy(xfs_da_state_zone);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 947ab6e32c18..28a5b3f876ad 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -441,7 +441,6 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__field(unsigned, bli_recur)
>  		__field(int, bli_refcount)
>  		__field(unsigned, bli_flags)
> -		__field(void *, li_desc)
>  		__field(unsigned long, li_flags)
>  	),
>  	TP_fast_assign(
> @@ -455,12 +454,11 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
>  		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
>  		__entry->buf_lockval = bip->bli_buf->b_sema.count;
> -		__entry->li_desc = bip->bli_item.li_desc;
>  		__entry->li_flags = bip->bli_item.li_flags;
>  	),
>  	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
>  		  "lock %d flags %s recur %d refcount %d bliflags %s "
> -		  "lidesc %p liflags %s",
> +		  "liflags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->buf_bno,
>  		  __entry->buf_len,
> @@ -471,7 +469,6 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		  __entry->bli_recur,
>  		  __entry->bli_refcount,
>  		  __print_flags(__entry->bli_flags, "|", XFS_BLI_FLAGS),
> -		  __entry->li_desc,
>  		  __print_flags(__entry->li_flags, "|", XFS_LI_FLAGS))
>  )
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 24744915357b..477c12412d31 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -33,7 +33,6 @@
>  #include "xfs_error.h"
>  
>  kmem_zone_t	*xfs_trans_zone;
> -kmem_zone_t	*xfs_log_item_desc_zone;
>  
>  #if defined(CONFIG_TRACEPOINTS)
>  static void
> @@ -732,77 +731,52 @@ xfs_trans_unreserve_and_mod_sb(
>  	return;
>  }
>  
> -/*
> - * Add the given log item to the transaction's list of log items.
> - *
> - * The log item will now point to its new descriptor with its li_desc field.
> - */
> +/* Add the given log item to the transaction's list of log items. */
>  void
>  xfs_trans_add_item(
>  	struct xfs_trans	*tp,
>  	struct xfs_log_item	*lip)
>  {
> -	struct xfs_log_item_desc *lidp;
> -
>  	ASSERT(lip->li_mountp == tp->t_mountp);
>  	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
> +	ASSERT(list_empty(&lip->li_trans));
> +	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
>  
> -	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
> -
> -	lidp->lid_item = lip;
> -	lidp->lid_flags = 0;
> -	list_add_tail(&lidp->lid_trans, &tp->t_items);
> -
> -	lip->li_desc = lidp;
> -
> +	list_add_tail(&lip->li_trans, &tp->t_items);
>  	trace_xfs_trans_add_item(tp, _RET_IP_);
>  }
>  
> -STATIC void
> -xfs_trans_free_item_desc(
> -	struct xfs_log_item_desc *lidp)
> -{
> -	list_del_init(&lidp->lid_trans);
> -	kmem_zone_free(xfs_log_item_desc_zone, lidp);
> -}
> -
>  /*
> - * Unlink and free the given descriptor.
> + * Unlink the log item from the transaction. the log item is no longer
> + * considered dirty in this transaction, as the linked transaction has
> + * finished, either by abort or commit completion.
>   */
>  void
>  xfs_trans_del_item(
>  	struct xfs_log_item	*lip)
>  {
> -	xfs_trans_free_item_desc(lip->li_desc);
> -	lip->li_desc = NULL;
> +	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
> +	list_del_init(&lip->li_trans);
>  }
>  
> -/*
> - * Unlock all of the items of a transaction and free all the descriptors
> - * of that transaction.
> - */
> +/* Detach and unlock all of the items in a transaction */
>  void
>  xfs_trans_free_items(
>  	struct xfs_trans	*tp,
>  	xfs_lsn_t		commit_lsn,
>  	bool			abort)
>  {
> -	struct xfs_log_item_desc *lidp, *next;
> +	struct xfs_log_item	*lip, *next;
>  
>  	trace_xfs_trans_free_items(tp, _RET_IP_);
>  
> -	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
> -		struct xfs_log_item	*lip = lidp->lid_item;
> -
> -		lip->li_desc = NULL;
> -
> +	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
> +		xfs_trans_del_item(lip);
>  		if (commit_lsn != NULLCOMMITLSN)
>  			lip->li_ops->iop_committing(lip, commit_lsn);
>  		if (abort)
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		lip->li_ops->iop_unlock(lip);
> -
> -		xfs_trans_free_item_desc(lidp);
>  	}
>  }
>  
> @@ -1047,10 +1021,10 @@ xfs_trans_cancel(
>  	}
>  #ifdef DEBUG
>  	if (!dirty && !XFS_FORCED_SHUTDOWN(mp)) {
> -		struct xfs_log_item_desc *lidp;
> +		struct xfs_log_item *lip;
>  
> -		list_for_each_entry(lidp, &tp->t_items, lid_trans)
> -			ASSERT(!(lidp->lid_item->li_type == XFS_LI_EFD));
> +		list_for_each_entry(lip, &tp->t_items, li_trans)
> +			ASSERT(!(lip->li_type == XFS_LI_EFD));
>  	}
>  #endif
>  	xfs_trans_unreserve_and_mod_sb(tp);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 51145ddf7e5b..a32da7d7ea97 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -27,7 +27,6 @@ struct xfs_efi_log_item;
>  struct xfs_inode;
>  struct xfs_item_ops;
>  struct xfs_log_iovec;
> -struct xfs_log_item_desc;
>  struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_trans_res;
> @@ -43,8 +42,8 @@ struct xfs_bud_log_item;
>  
>  typedef struct xfs_log_item {
>  	struct list_head		li_ail;		/* AIL pointers */
> +	struct list_head		li_trans;	/* transaction list */
>  	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
> -	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
>  	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
>  	struct xfs_ail			*li_ailp;	/* ptr to AIL */
>  	uint				li_type;	/* item type */
> @@ -72,11 +71,13 @@ typedef struct xfs_log_item {
>  #define	XFS_LI_IN_AIL	0
>  #define	XFS_LI_ABORTED	1
>  #define	XFS_LI_FAILED	2
> +#define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
>  
>  #define XFS_LI_FLAGS \
>  	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
>  	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
> -	{ (1 << XFS_LI_FAILED),		"FAILED" }
> +	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> +	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
>  
>  struct xfs_item_ops {
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> @@ -247,7 +248,6 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
>  					struct xfs_buf *src_bp);
>  
>  extern kmem_zone_t	*xfs_trans_zone;
> -extern kmem_zone_t	*xfs_log_item_desc_zone;
>  
>  /* rmap updates */
>  enum xfs_rmap_intent_type;
> diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
> index 14543d93cd4b..230a21df4b12 100644
> --- a/fs/xfs/xfs_trans_bmap.c
> +++ b/fs/xfs/xfs_trans_bmap.c
> @@ -79,7 +79,7 @@ xfs_trans_log_finish_bmap_update(
>  	 * 2.) shuts down the filesystem
>  	 */
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	budp->bud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
>  
>  	return error;
>  }
> @@ -158,7 +158,7 @@ xfs_bmap_update_log_item(
>  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	buip->bui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
>  
>  	/*
>  	 * atomic_inc_return gives us the value after the increment;
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 0081e9b3decf..a8ddb4eed279 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -40,7 +40,7 @@ xfs_trans_buf_item_match(
>  	struct xfs_buf_map	*map,
>  	int			nmaps)
>  {
> -	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_item	*lip;
>  	struct xfs_buf_log_item	*blip;
>  	int			len = 0;
>  	int			i;
> @@ -48,8 +48,8 @@ xfs_trans_buf_item_match(
>  	for (i = 0; i < nmaps; i++)
>  		len += map[i].bm_len;
>  
> -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> -		blip = (struct xfs_buf_log_item *)lidp->lid_item;
> +	list_for_each_entry(lip, &tp->t_items, li_trans) {
> +		blip = (struct xfs_buf_log_item *)lip;
>  		if (blip->bli_item.li_type == XFS_LI_BUF &&
>  		    blip->bli_buf->b_target == target &&
>  		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
> @@ -100,14 +100,10 @@ _xfs_trans_bjoin(
>  	atomic_inc(&bip->bli_refcount);
>  
>  	/*
> -	 * Get a log_item_desc to point at the new item.
> +	 * Attach the item to the transaction so we can find it in
> +	 * xfs_trans_get_buf() and friends.
>  	 */
>  	xfs_trans_add_item(tp, &bip->bli_item);
> -
> -	/*
> -	 * Initialize b_fsprivate2 so we can find it with incore_match()
> -	 * in xfs_trans_get_buf() and friends above.
> -	 */
>  	bp->b_transp = tp;
>  
>  }
> @@ -391,7 +387,7 @@ xfs_trans_brelse(
>  	 * If the buffer is dirty within this transaction, we can't
>  	 * release it until we commit.
>  	 */
> -	if (bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY)
> +	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
>  		return;
>  
>  	/*
> @@ -542,7 +538,7 @@ xfs_trans_dirty_buf(
>  	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
>  }
>  
>  /*
> @@ -626,7 +622,7 @@ xfs_trans_binval(
>  		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_INODE_BUF));
>  		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLFT_MASK));
>  		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> -		ASSERT(bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY);
> +		ASSERT(test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags));
>  		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
>  		return;
>  	}
> @@ -642,7 +638,7 @@ xfs_trans_binval(
>  		memset(bip->bli_formats[i].blf_data_map, 0,
>  		       (bip->bli_formats[i].blf_map_size * sizeof(uint)));
>  	}
> -	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  }
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c3d547211d16..c381c02cca45 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -77,7 +77,7 @@ xfs_trans_log_dquot(
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	dqp->q_logitem.qli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &dqp->q_logitem.qli_item.li_flags);
>  }
>  
>  /*
> @@ -879,7 +879,7 @@ xfs_trans_log_quotaoff_item(
>  	xfs_qoff_logitem_t	*qlp)
>  {
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	qlp->qql_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
>  }
>  
>  STATIC void
> diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> index ab438647592a..fb631081d829 100644
> --- a/fs/xfs/xfs_trans_extfree.c
> +++ b/fs/xfs/xfs_trans_extfree.c
> @@ -90,7 +90,7 @@ xfs_trans_free_extent(
>  	 * 2.) shuts down the filesystem
>  	 */
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>  
>  	next_extent = efdp->efd_next_extent;
>  	ASSERT(next_extent < efdp->efd_format.efd_nextents);
> @@ -155,7 +155,7 @@ xfs_extent_free_log_item(
>  	free = container_of(item, struct xfs_extent_free_item, xefi_list);
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	efip->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
>  
>  	/*
>  	 * atomic_inc_return gives us the value after the increment;
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 07cea592dc01..f7bd7960a90f 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -133,14 +133,13 @@ xfs_trans_log_inode(
>  	 * set however, then go ahead and bump the i_version counter
>  	 * unconditionally.
>  	 */
> -	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
> +	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
>  	    IS_I_VERSION(VFS_I(ip))) {
>  		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
>  			flags |= XFS_ILOG_CORE;
>  	}
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
>  
>  	/*
>  	 * Always OR in the bits from the ili_last_fields field.
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 43f773297b9d..9717ae74b36d 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -19,7 +19,6 @@
>  #define	__XFS_TRANS_PRIV_H__
>  
>  struct xfs_log_item;
> -struct xfs_log_item_desc;
>  struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_ail;
> diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
> index 94c1877af834..c7f8e82f5bda 100644
> --- a/fs/xfs/xfs_trans_refcount.c
> +++ b/fs/xfs/xfs_trans_refcount.c
> @@ -77,7 +77,7 @@ xfs_trans_log_finish_refcount_update(
>  	 * 2.) shuts down the filesystem
>  	 */
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	cudp->cud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
>  
>  	return error;
>  }
> @@ -154,7 +154,7 @@ xfs_refcount_update_log_item(
>  	refc = container_of(item, struct xfs_refcount_intent, ri_list);
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	cuip->cui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
>  
>  	/*
>  	 * atomic_inc_return gives us the value after the increment;
> diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> index 9b577beb43d7..5831ca0c270b 100644
> --- a/fs/xfs/xfs_trans_rmap.c
> +++ b/fs/xfs/xfs_trans_rmap.c
> @@ -117,7 +117,7 @@ xfs_trans_log_finish_rmap_update(
>  	 * 2.) shuts down the filesystem
>  	 */
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	rudp->rud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
>  
>  	return error;
>  }
> @@ -175,7 +175,7 @@ xfs_rmap_update_log_item(
>  	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> -	ruip->rui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
>  
>  	/*
>  	 * atomic_inc_return gives us the value after the increment;
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
