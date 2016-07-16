Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D9AD7CCB
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2016 02:34:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04FCCAC002
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2016 00:34:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id aNLC1IU6NJAhhBtc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Jul 2016 00:34:15 -0700 (PDT)
Date: Sat, 16 Jul 2016 00:34:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 042/119] xfs: log rmap intent items
Message-ID: <20160716073408.GD21529@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612654128.12839.11872963796909332527.stgit@birch.djwong.org>
	<20160715183346.GB55338@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160715183346.GB55338@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Fri, Jul 15, 2016 at 02:33:46PM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:22:21PM -0700, Darrick J. Wong wrote:
> > Provide a mechanism for higher levels to create RUI/RUD items, submit
> > them to the log, and a stub function to deal with recovered RUI items.
> > These parts will be connected to the rmapbt in a later patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> The commit log makes no mention of log recovery.. perhaps this should be
> split in two?
> 
> >  fs/xfs/Makefile          |    1 
> >  fs/xfs/xfs_log_recover.c |  344 +++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_trans.h       |   17 ++
> >  fs/xfs/xfs_trans_rmap.c  |  235 +++++++++++++++++++++++++++++++
> >  4 files changed, 589 insertions(+), 8 deletions(-)
> >  create mode 100644 fs/xfs/xfs_trans_rmap.c
> > 
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 8ae0a10..1980110 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -110,6 +110,7 @@ xfs-y				+= xfs_log.o \
> >  				   xfs_trans_buf.o \
> >  				   xfs_trans_extfree.o \
> >  				   xfs_trans_inode.o \
> > +				   xfs_trans_rmap.o \
> >  
> >  # optional features
> >  xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index b33187b..c9fe0c4 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -44,6 +44,7 @@
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_error.h"
> >  #include "xfs_dir2.h"
> > +#include "xfs_rmap_item.h"
> >  
> >  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
> >  
> > @@ -1912,6 +1913,8 @@ xlog_recover_reorder_trans(
> >  		case XFS_LI_QUOTAOFF:
> >  		case XFS_LI_EFD:
> >  		case XFS_LI_EFI:
> > +		case XFS_LI_RUI:
> > +		case XFS_LI_RUD:
> >  			trace_xfs_log_recover_item_reorder_tail(log,
> >  							trans, item, pass);
> >  			list_move_tail(&item->ri_list, &inode_list);
> > @@ -3416,6 +3419,101 @@ xlog_recover_efd_pass2(
> >  }
> >  
> >  /*
> > + * This routine is called to create an in-core extent rmap update
> > + * item from the rui format structure which was logged on disk.
> > + * It allocates an in-core rui, copies the extents from the format
> > + * structure into it, and adds the rui to the AIL with the given
> > + * LSN.
> > + */
> > +STATIC int
> > +xlog_recover_rui_pass2(
> > +	struct xlog			*log,
> > +	struct xlog_recover_item	*item,
> > +	xfs_lsn_t			lsn)
> > +{
> > +	int				error;
> > +	struct xfs_mount		*mp = log->l_mp;
> > +	struct xfs_rui_log_item		*ruip;
> > +	struct xfs_rui_log_format	*rui_formatp;
> > +
> > +	rui_formatp = item->ri_buf[0].i_addr;
> > +
> > +	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
> > +	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
> > +	if (error) {
> > +		xfs_rui_item_free(ruip);
> > +		return error;
> > +	}
> > +	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
> > +
> > +	spin_lock(&log->l_ailp->xa_lock);
> > +	/*
> > +	 * The RUI has two references. One for the RUD and one for RUI to ensure
> > +	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> > +	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> > +	 * AIL lock.
> > +	 */
> > +	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
> > +	xfs_rui_release(ruip);
> > +	return 0;
> > +}
> > +
> > +
> > +/*
> > + * This routine is called when an RUD format structure is found in a committed
> > + * transaction in the log. Its purpose is to cancel the corresponding RUI if it
> > + * was still in the log. To do this it searches the AIL for the RUI with an id
> > + * equal to that in the RUD format structure. If we find it we drop the RUD
> > + * reference, which removes the RUI from the AIL and frees it.
> > + */
> > +STATIC int
> > +xlog_recover_rud_pass2(
> > +	struct xlog			*log,
> > +	struct xlog_recover_item	*item)
> > +{
> > +	struct xfs_rud_log_format	*rud_formatp;
> > +	struct xfs_rui_log_item		*ruip = NULL;
> > +	struct xfs_log_item		*lip;
> > +	__uint64_t			rui_id;
> > +	struct xfs_ail_cursor		cur;
> > +	struct xfs_ail			*ailp = log->l_ailp;
> > +
> > +	rud_formatp = item->ri_buf[0].i_addr;
> > +	ASSERT(item->ri_buf[0].i_len == (sizeof(struct xfs_rud_log_format) +
> > +			((rud_formatp->rud_nextents - 1) *
> > +			sizeof(struct xfs_map_extent))));
> > +	rui_id = rud_formatp->rud_rui_id;
> > +
> > +	/*
> > +	 * Search for the RUI with the id in the RUD format structure in the
> > +	 * AIL.
> > +	 */
> > +	spin_lock(&ailp->xa_lock);
> > +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > +	while (lip != NULL) {
> > +		if (lip->li_type == XFS_LI_RUI) {
> > +			ruip = (struct xfs_rui_log_item *)lip;
> > +			if (ruip->rui_format.rui_id == rui_id) {
> > +				/*
> > +				 * Drop the RUD reference to the RUI. This
> > +				 * removes the RUI from the AIL and frees it.
> > +				 */
> > +				spin_unlock(&ailp->xa_lock);
> > +				xfs_rui_release(ruip);
> > +				spin_lock(&ailp->xa_lock);
> > +				break;
> > +			}
> > +		}
> > +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +	}
> > +
> > +	xfs_trans_ail_cursor_done(&cur);
> > +	spin_unlock(&ailp->xa_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> >   * This routine is called when an inode create format structure is found in a
> >   * committed transaction in the log.  It's purpose is to initialise the inodes
> >   * being allocated on disk. This requires us to get inode cluster buffers that
> > @@ -3640,6 +3738,8 @@ xlog_recover_ra_pass2(
> >  	case XFS_LI_EFI:
> >  	case XFS_LI_EFD:
> >  	case XFS_LI_QUOTAOFF:
> > +	case XFS_LI_RUI:
> > +	case XFS_LI_RUD:
> >  	default:
> >  		break;
> >  	}
> > @@ -3663,6 +3763,8 @@ xlog_recover_commit_pass1(
> >  	case XFS_LI_EFD:
> >  	case XFS_LI_DQUOT:
> >  	case XFS_LI_ICREATE:
> > +	case XFS_LI_RUI:
> > +	case XFS_LI_RUD:
> >  		/* nothing to do in pass 1 */
> >  		return 0;
> >  	default:
> > @@ -3693,6 +3795,10 @@ xlog_recover_commit_pass2(
> >  		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
> >  	case XFS_LI_EFD:
> >  		return xlog_recover_efd_pass2(log, item);
> > +	case XFS_LI_RUI:
> > +		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
> > +	case XFS_LI_RUD:
> > +		return xlog_recover_rud_pass2(log, item);
> >  	case XFS_LI_DQUOT:
> >  		return xlog_recover_dquot_pass2(log, buffer_list, item,
> >  						trans->r_lsn);
> > @@ -4165,6 +4271,18 @@ xlog_recover_process_data(
> >  	return 0;
> >  }
> >  
> > +/* Is this log item a deferred action intent? */
> > +static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
> > +{
> > +	switch (lip->li_type) {
> > +	case XFS_LI_EFI:
> > +	case XFS_LI_RUI:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> >  /*
> >   * Process an extent free intent item that was recovered from
> >   * the log.  We need to free the extents that it describes.
> > @@ -4265,17 +4383,23 @@ xlog_recover_process_efis(
> >  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> >  	while (lip != NULL) {
> >  		/*
> > -		 * We're done when we see something other than an EFI.
> > -		 * There should be no EFIs left in the AIL now.
> > +		 * We're done when we see something other than an intent.
> > +		 * There should be no intents left in the AIL now.
> >  		 */
> > -		if (lip->li_type != XFS_LI_EFI) {
> > +		if (!xlog_item_is_intent(lip)) {
> >  #ifdef DEBUG
> >  			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> > -				ASSERT(lip->li_type != XFS_LI_EFI);
> > +				ASSERT(!xlog_item_is_intent(lip));
> >  #endif
> >  			break;
> >  		}
> >  
> > +		/* Skip anything that isn't an EFI */
> > +		if (lip->li_type != XFS_LI_EFI) {
> > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			continue;
> > +		}
> > +
> 
> Hmm, so previously this function used the existence of any non-EFI item
> as an end of traversal marker, since the freeing operations add more
> items to the AIL. It's not immediately clear to me whether this is just
> an efficiency thing or a potential problem, but I wonder if we should
> grab the last item and use that or its lsn as an end of list marker.

FWIW I designed all this under the impression that it was safe to stop looking
for intent items once we found something that wasn't an intent item because all
the new items generated during log recovery came after, and therefore there was
no problem.

> At the very least we need to update the comment at the top of the
> function wrt to the current behavior.

Oops, missed that, yeah.

> >  		/*
> >  		 * Skip EFIs that we've already processed.
> >  		 */
> > @@ -4320,14 +4444,20 @@ xlog_recover_cancel_efis(
> >  		 * We're done when we see something other than an EFI.
> >  		 * There should be no EFIs left in the AIL now.
> >  		 */
> 
> Need to update this comment as for process_efis()...

Yep.

> > -		if (lip->li_type != XFS_LI_EFI) {
> > +		if (!xlog_item_is_intent(lip)) {
> >  #ifdef DEBUG
> >  			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> > -				ASSERT(lip->li_type != XFS_LI_EFI);
> > +				ASSERT(!xlog_item_is_intent(lip));
> >  #endif
> >  			break;
> >  		}
> >  
> > +		/* Skip anything that isn't an EFI */
> > +		if (lip->li_type != XFS_LI_EFI) {
> > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			continue;
> > +		}
> > +
> >  		efip = container_of(lip, struct xfs_efi_log_item, efi_item);
> >  
> >  		spin_unlock(&ailp->xa_lock);
> > @@ -4343,6 +4473,190 @@ xlog_recover_cancel_efis(
> >  }
> >  
> >  /*
> > + * Process an rmap update intent item that was recovered from the log.
> > + * We need to update the rmapbt.
> > + */
> > +STATIC int
> > +xlog_recover_process_rui(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_rui_log_item		*ruip)
> > +{
> > +	int				i;
> > +	int				error = 0;
> > +	struct xfs_map_extent		*rmap;
> > +	xfs_fsblock_t			startblock_fsb;
> > +	bool				op_ok;
> > +
> > +	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
> > +
> > +	/*
> > +	 * First check the validity of the extents described by the
> > +	 * RUI.  If any are bad, then assume that all are bad and
> > +	 * just toss the RUI.
> > +	 */
> > +	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
> > +		rmap = &(ruip->rui_format.rui_extents[i]);
> > +		startblock_fsb = XFS_BB_TO_FSB(mp,
> > +				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
> > +		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
> > +		case XFS_RMAP_EXTENT_MAP:
> > +		case XFS_RMAP_EXTENT_MAP_SHARED:
> > +		case XFS_RMAP_EXTENT_UNMAP:
> > +		case XFS_RMAP_EXTENT_UNMAP_SHARED:
> > +		case XFS_RMAP_EXTENT_CONVERT:
> > +		case XFS_RMAP_EXTENT_CONVERT_SHARED:
> > +		case XFS_RMAP_EXTENT_ALLOC:
> > +		case XFS_RMAP_EXTENT_FREE:
> > +			op_ok = true;
> > +			break;
> > +		default:
> > +			op_ok = false;
> > +			break;
> > +		}
> > +		if (!op_ok || (startblock_fsb == 0) ||
> > +		    (rmap->me_len == 0) ||
> > +		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
> > +		    (rmap->me_len >= mp->m_sb.sb_agblocks) ||
> > +		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)) {
> > +			/*
> > +			 * This will pull the RUI from the AIL and
> > +			 * free the memory associated with it.
> > +			 */
> > +			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
> > +			xfs_rui_release(ruip);
> > +			return -EIO;
> > +		}
> > +	}
> > +
> > +	/* XXX: do nothing for now */
> > +	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
> > +	xfs_rui_release(ruip);
> > +	return error;
> > +}
> > +
> > +/*
> > + * When this is called, all of the RUIs which did not have
> > + * corresponding RUDs should be in the AIL.  What we do now
> > + * is update the rmaps associated with each one.
> > + *
> > + * Since we process the RUIs in normal transactions, they
> > + * will be removed at some point after the commit.  This prevents
> > + * us from just walking down the list processing each one.
> > + * We'll use a flag in the RUI to skip those that we've already
> > + * processed and use the AIL iteration mechanism's generation
> > + * count to try to speed this up at least a bit.
> > + *
> > + * When we start, we know that the RUIs are the only things in
> > + * the AIL.  As we process them, however, other items are added
> > + * to the AIL.  Since everything added to the AIL must come after
> > + * everything already in the AIL, we stop processing as soon as
> > + * we see something other than an RUI in the AIL.
> > + */
> > +STATIC int
> > +xlog_recover_process_ruis(
> > +	struct xlog		*log)
> > +{
> > +	struct xfs_log_item	*lip;
> > +	struct xfs_rui_log_item	*ruip;
> > +	int			error = 0;
> > +	struct xfs_ail_cursor	cur;
> > +	struct xfs_ail		*ailp;
> > +
> > +	ailp = log->l_ailp;
> > +	spin_lock(&ailp->xa_lock);
> > +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > +	while (lip != NULL) {
> > +		/*
> > +		 * We're done when we see something other than an intent.
> > +		 * There should be no intents left in the AIL now.
> > +		 */
> > +		if (!xlog_item_is_intent(lip)) {
> > +#ifdef DEBUG
> > +			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> > +				ASSERT(!xlog_item_is_intent(lip));
> > +#endif
> > +			break;
> > +		}
> > +
> > +		/* Skip anything that isn't an RUI */
> > +		if (lip->li_type != XFS_LI_RUI) {
> > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			continue;
> > +		}
> > +
> > +		/*
> > +		 * Skip RUIs that we've already processed.
> > +		 */
> > +		ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
> > +		if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags)) {
> > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			continue;
> > +		}
> > +
> > +		spin_unlock(&ailp->xa_lock);
> > +		error = xlog_recover_process_rui(log->l_mp, ruip);
> > +		spin_lock(&ailp->xa_lock);
> > +		if (error)
> > +			goto out;
> > +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +	}
> > +out:
> > +	xfs_trans_ail_cursor_done(&cur);
> > +	spin_unlock(&ailp->xa_lock);
> > +	return error;
> > +}
> > +
> > +/*
> > + * A cancel occurs when the mount has failed and we're bailing out. Release all
> > + * pending RUIs so they don't pin the AIL.
> > + */
> > +STATIC int
> > +xlog_recover_cancel_ruis(
> > +	struct xlog		*log)
> > +{
> > +	struct xfs_log_item	*lip;
> > +	struct xfs_rui_log_item	*ruip;
> > +	int			error = 0;
> > +	struct xfs_ail_cursor	cur;
> > +	struct xfs_ail		*ailp;
> > +
> > +	ailp = log->l_ailp;
> > +	spin_lock(&ailp->xa_lock);
> > +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > +	while (lip != NULL) {
> > +		/*
> > +		 * We're done when we see something other than an RUI.
> > +		 * There should be no RUIs left in the AIL now.
> > +		 */
> > +		if (!xlog_item_is_intent(lip)) {
> > +#ifdef DEBUG
> > +			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> > +				ASSERT(!xlog_item_is_intent(lip));
> > +#endif
> > +			break;
> > +		}
> > +
> > +		/* Skip anything that isn't an RUI */
> > +		if (lip->li_type != XFS_LI_RUI) {
> > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			continue;
> > +		}
> > +
> > +		ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
> > +
> > +		spin_unlock(&ailp->xa_lock);
> > +		xfs_rui_release(ruip);
> > +		spin_lock(&ailp->xa_lock);
> > +
> > +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +	}
> > +
> > +	xfs_trans_ail_cursor_done(&cur);
> > +	spin_unlock(&ailp->xa_lock);
> > +	return error;
> > +}
> 
> How about we combine this and cancel_efis() into a cancel_intents()
> function so we only have to make one pass? It looks like the only
> difference is the item-specific release call.

Yeah, sounds like a good refactor.

> > +
> > +/*
> >   * This routine performs a transaction to null out a bad inode pointer
> >   * in an agi unlinked inode hash bucket.
> >   */
> > @@ -5144,11 +5458,19 @@ xlog_recover_finish(
> >  	 */
> >  	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> >  		int	error;
> > +
> > +		error = xlog_recover_process_ruis(log);
> > +		if (error) {
> > +			xfs_alert(log->l_mp, "Failed to recover RUIs");
> > +			return error;
> > +		}
> > +
> >  		error = xlog_recover_process_efis(log);
> >  		if (error) {
> >  			xfs_alert(log->l_mp, "Failed to recover EFIs");
> >  			return error;
> >  		}
> > +
> 
> Is the order important here in any way (e.g., RUIs before EFIs)? If so,
> it might be a good idea to call it out.

AFAIK the intent items within a particular type have to be replayed in
order, but between types, there isn't a problem with the current code.

That said, I'd also been wondering if it made more sense to iterate the
list of items /once/ and actually replay items in order.  Less iteration
and the order of replayed items matches the log order much more closely.

> >  		/*
> >  		 * Sync the log to get all the EFIs out of the AIL.
> >  		 * This isn't absolutely necessary, but it helps in
> > @@ -5176,9 +5498,15 @@ xlog_recover_cancel(
> >  	struct xlog	*log)
> >  {
> >  	int		error = 0;
> > +	int		err2;
> >  
> > -	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> > -		error = xlog_recover_cancel_efis(log);
> > +	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> > +		error = xlog_recover_cancel_ruis(log);
> > +
> > +		err2 = xlog_recover_cancel_efis(log);
> > +		if (err2 && !error)
> > +			error = err2;
> > +	}
> >  
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index f8d363f..c48be63 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -235,4 +235,21 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
> >  extern kmem_zone_t	*xfs_trans_zone;
> >  extern kmem_zone_t	*xfs_log_item_desc_zone;
> >  
> > +enum xfs_rmap_intent_type;
> > +
> > +struct xfs_rui_log_item *xfs_trans_get_rui(struct xfs_trans *tp, uint nextents);
> > +void xfs_trans_log_start_rmap_update(struct xfs_trans *tp,
> > +		struct xfs_rui_log_item *ruip, enum xfs_rmap_intent_type type,
> > +		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> > +		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> > +		xfs_exntst_t state);
> > +
> > +struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
> > +		struct xfs_rui_log_item *ruip, uint nextents);
> > +int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
> > +		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
> > +		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> > +		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> > +		xfs_exntst_t state);
> > +
> >  #endif	/* __XFS_TRANS_H__ */
> > diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> > new file mode 100644
> > index 0000000..b55a725
> > --- /dev/null
> > +++ b/fs/xfs/xfs_trans_rmap.c
> > @@ -0,0 +1,235 @@
> > +/*
> > + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_trans_priv.h"
> > +#include "xfs_rmap_item.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_rmap_btree.h"
> > +
> > +/*
> > + * This routine is called to allocate an "rmap update intent"
> > + * log item that will hold nextents worth of extents.  The
> > + * caller must use all nextents extents, because we are not
> > + * flexible about this at all.
> > + */
> > +struct xfs_rui_log_item *
> > +xfs_trans_get_rui(
> > +	struct xfs_trans		*tp,
> > +	uint				nextents)
> > +{
> > +	struct xfs_rui_log_item		*ruip;
> > +
> > +	ASSERT(tp != NULL);
> > +	ASSERT(nextents > 0);
> > +
> > +	ruip = xfs_rui_init(tp->t_mountp, nextents);
> > +	ASSERT(ruip != NULL);
> > +
> > +	/*
> > +	 * Get a log_item_desc to point at the new item.
> > +	 */
> > +	xfs_trans_add_item(tp, &ruip->rui_item);
> > +	return ruip;
> > +}
> > +
> > +/*
> > + * This routine is called to indicate that the described
> > + * extent is to be logged as needing to be freed.  It should
> > + * be called once for each extent to be freed.
> > + */
> 
> Stale comment.

<nod>

> > +void
> > +xfs_trans_log_start_rmap_update(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_rui_log_item		*ruip,
> > +	enum xfs_rmap_intent_type	type,
> > +	__uint64_t			owner,
> > +	int				whichfork,
> > +	xfs_fileoff_t			startoff,
> > +	xfs_fsblock_t			startblock,
> > +	xfs_filblks_t			blockcount,
> > +	xfs_exntst_t			state)
> > +{
> > +	uint				next_extent;
> > +	struct xfs_map_extent		*rmap;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	ruip->rui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > +
> > +	/*
> > +	 * atomic_inc_return gives us the value after the increment;
> > +	 * we want to use it as an array index so we need to subtract 1 from
> > +	 * it.
> > +	 */
> > +	next_extent = atomic_inc_return(&ruip->rui_next_extent) - 1;
> > +	ASSERT(next_extent < ruip->rui_format.rui_nextents);
> > +	rmap = &(ruip->rui_format.rui_extents[next_extent]);
> > +	rmap->me_owner = owner;
> > +	rmap->me_startblock = startblock;
> > +	rmap->me_startoff = startoff;
> > +	rmap->me_len = blockcount;
> > +	rmap->me_flags = 0;
> > +	if (state == XFS_EXT_UNWRITTEN)
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
> > +	switch (type) {
> > +	case XFS_RMAP_MAP:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
> > +		break;
> > +	case XFS_RMAP_MAP_SHARED:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
> > +		break;
> > +	case XFS_RMAP_UNMAP:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
> > +		break;
> > +	case XFS_RMAP_UNMAP_SHARED:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
> > +		break;
> > +	case XFS_RMAP_CONVERT:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
> > +		break;
> > +	case XFS_RMAP_CONVERT_SHARED:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
> > +		break;
> > +	case XFS_RMAP_ALLOC:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
> > +		break;
> > +	case XFS_RMAP_FREE:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_FREE;
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +	}
> 
> Between here and the finish function, it looks like we could use a
> helper to convert the state and whatnot to extent flags.

Ok.

> > +}
> > +
> > +
> > +/*
> > + * This routine is called to allocate an "extent free done"
> > + * log item that will hold nextents worth of extents.  The
> > + * caller must use all nextents extents, because we are not
> > + * flexible about this at all.
> > + */
> 
> Comment needs updating.

Ok.

> Brian
> 
> > +struct xfs_rud_log_item *
> > +xfs_trans_get_rud(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_rui_log_item		*ruip,
> > +	uint				nextents)
> > +{
> > +	struct xfs_rud_log_item		*rudp;
> > +
> > +	ASSERT(tp != NULL);
> > +	ASSERT(nextents > 0);
> > +
> > +	rudp = xfs_rud_init(tp->t_mountp, ruip, nextents);
> > +	ASSERT(rudp != NULL);
> > +
> > +	/*
> > +	 * Get a log_item_desc to point at the new item.
> > +	 */
> > +	xfs_trans_add_item(tp, &rudp->rud_item);
> > +	return rudp;
> > +}
> > +
> > +/*
> > + * Finish an rmap update and log it to the RUD. Note that the transaction is
> > + * marked dirty regardless of whether the rmap update succeeds or fails to
> > + * support the RUI/RUD lifecycle rules.
> > + */
> > +int
> > +xfs_trans_log_finish_rmap_update(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_rud_log_item		*rudp,
> > +	enum xfs_rmap_intent_type	type,
> > +	__uint64_t			owner,
> > +	int				whichfork,
> > +	xfs_fileoff_t			startoff,
> > +	xfs_fsblock_t			startblock,
> > +	xfs_filblks_t			blockcount,
> > +	xfs_exntst_t			state)
> > +{
> > +	uint				next_extent;
> > +	struct xfs_map_extent		*rmap;
> > +	int				error;
> > +
> > +	/* XXX: actually finish the rmap update here */
> > +	error = -EFSCORRUPTED;
> > +
> > +	/*
> > +	 * Mark the transaction dirty, even on error. This ensures the
> > +	 * transaction is aborted, which:
> > +	 *
> > +	 * 1.) releases the RUI and frees the RUD
> > +	 * 2.) shuts down the filesystem
> > +	 */
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	rudp->rud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > +
> > +	next_extent = rudp->rud_next_extent;
> > +	ASSERT(next_extent < rudp->rud_format.rud_nextents);
> > +	rmap = &(rudp->rud_format.rud_extents[next_extent]);
> > +	rmap->me_owner = owner;
> > +	rmap->me_startblock = startblock;
> > +	rmap->me_startoff = startoff;
> > +	rmap->me_len = blockcount;
> > +	rmap->me_flags = 0;
> > +	if (state == XFS_EXT_UNWRITTEN)
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
> > +	switch (type) {
> > +	case XFS_RMAP_MAP:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
> > +		break;
> > +	case XFS_RMAP_MAP_SHARED:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
> > +		break;
> > +	case XFS_RMAP_UNMAP:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
> > +		break;
> > +	case XFS_RMAP_UNMAP_SHARED:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
> > +		break;
> > +	case XFS_RMAP_CONVERT:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
> > +		break;
> > +	case XFS_RMAP_CONVERT_SHARED:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
> > +		break;
> > +	case XFS_RMAP_ALLOC:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
> > +		break;
> > +	case XFS_RMAP_FREE:
> > +		rmap->me_flags |= XFS_RMAP_EXTENT_FREE;
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +	}
> > +	rudp->rud_next_extent++;
> > +
> > +	return error;
> > +}
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
