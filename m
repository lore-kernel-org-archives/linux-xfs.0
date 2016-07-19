Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A5CC7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 12:10:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F3358F8040
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 10:10:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MJIln8AHF4K87uxk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 10:10:13 -0700 (PDT)
Date: Tue, 19 Jul 2016 10:10:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 042/119] xfs: log rmap intent items
Message-ID: <20160719171007.GF12567@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612654128.12839.11872963796909332527.stgit@birch.djwong.org>
	<20160715183346.GB55338@bfoster.bfoster>
	<20160716073408.GD21529@birch.djwong.org>
	<20160718125459.GA27380@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160718125459.GA27380@bfoster.bfoster>
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

On Mon, Jul 18, 2016 at 08:55:02AM -0400, Brian Foster wrote:
> On Sat, Jul 16, 2016 at 12:34:09AM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 15, 2016 at 02:33:46PM -0400, Brian Foster wrote:
> > > On Thu, Jun 16, 2016 at 06:22:21PM -0700, Darrick J. Wong wrote:
> > > > Provide a mechanism for higher levels to create RUI/RUD items, submit
> > > > them to the log, and a stub function to deal with recovered RUI items.
> > > > These parts will be connected to the rmapbt in a later patch.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > The commit log makes no mention of log recovery.. perhaps this should be
> > > split in two?
> > > 
> > > >  fs/xfs/Makefile          |    1 
> > > >  fs/xfs/xfs_log_recover.c |  344 +++++++++++++++++++++++++++++++++++++++++++++-
> > > >  fs/xfs/xfs_trans.h       |   17 ++
> > > >  fs/xfs/xfs_trans_rmap.c  |  235 +++++++++++++++++++++++++++++++
> > > >  4 files changed, 589 insertions(+), 8 deletions(-)
> > > >  create mode 100644 fs/xfs/xfs_trans_rmap.c
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > > > index 8ae0a10..1980110 100644
> > > > --- a/fs/xfs/Makefile
> > > > +++ b/fs/xfs/Makefile
> > > > @@ -110,6 +110,7 @@ xfs-y				+= xfs_log.o \
> > > >  				   xfs_trans_buf.o \
> > > >  				   xfs_trans_extfree.o \
> > > >  				   xfs_trans_inode.o \
> > > > +				   xfs_trans_rmap.o \
> > > >  
> > > >  # optional features
> > > >  xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index b33187b..c9fe0c4 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> ...
> > > > @@ -4265,17 +4383,23 @@ xlog_recover_process_efis(
> > > >  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > > >  	while (lip != NULL) {
> > > >  		/*
> > > > -		 * We're done when we see something other than an EFI.
> > > > -		 * There should be no EFIs left in the AIL now.
> > > > +		 * We're done when we see something other than an intent.
> > > > +		 * There should be no intents left in the AIL now.
> > > >  		 */
> > > > -		if (lip->li_type != XFS_LI_EFI) {
> > > > +		if (!xlog_item_is_intent(lip)) {
> > > >  #ifdef DEBUG
> > > >  			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> > > > -				ASSERT(lip->li_type != XFS_LI_EFI);
> > > > +				ASSERT(!xlog_item_is_intent(lip));
> > > >  #endif
> > > >  			break;
> > > >  		}
> > > >  
> > > > +		/* Skip anything that isn't an EFI */
> > > > +		if (lip->li_type != XFS_LI_EFI) {
> > > > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > > > +			continue;
> > > > +		}
> > > > +
> > > 
> > > Hmm, so previously this function used the existence of any non-EFI item
> > > as an end of traversal marker, since the freeing operations add more
> > > items to the AIL. It's not immediately clear to me whether this is just
> > > an efficiency thing or a potential problem, but I wonder if we should
> > > grab the last item and use that or its lsn as an end of list marker.
> > 
> > FWIW I designed all this under the impression that it was safe to stop looking
> > for intent items once we found something that wasn't an intent item because all
> > the new items generated during log recovery came after, and therefore there was
> > no problem.
> > 
> 
> Ok. To be clear, are you saying that any new intents should follow
> non-intent items? If so, that sounds... reasonable (perhaps a little
> landmind-ish :P).

I've refactored the redo item processing into a single function
xlog_recover_process_intents, and will put in an assert to check that each redo
item's LSN is not larger than whatever LSN(curr_cycle, curr_block) is at the
start of intent processing.  That'll hopefully catch any case where we
accidentally stray into new intent items.

Looks like everything still passes with the review refactoring, so I'll start
integrating the last of those changes into the patchset proper.

--D

> > > At the very least we need to update the comment at the top of the
> > > function wrt to the current behavior.
> > 
> > Oops, missed that, yeah.
> > 
> > > >  		/*
> > > >  		 * Skip EFIs that we've already processed.
> > > >  		 */
> ...
> > > > @@ -5144,11 +5458,19 @@ xlog_recover_finish(
> > > >  	 */
> > > >  	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> > > >  		int	error;
> > > > +
> > > > +		error = xlog_recover_process_ruis(log);
> > > > +		if (error) {
> > > > +			xfs_alert(log->l_mp, "Failed to recover RUIs");
> > > > +			return error;
> > > > +		}
> > > > +
> > > >  		error = xlog_recover_process_efis(log);
> > > >  		if (error) {
> > > >  			xfs_alert(log->l_mp, "Failed to recover EFIs");
> > > >  			return error;
> > > >  		}
> > > > +
> > > 
> > > Is the order important here in any way (e.g., RUIs before EFIs)? If so,
> > > it might be a good idea to call it out.
> > 
> > AFAIK the intent items within a particular type have to be replayed in
> > order, but between types, there isn't a problem with the current code.
> > 
> > That said, I'd also been wondering if it made more sense to iterate the
> > list of items /once/ and actually replay items in order.  Less iteration
> > and the order of replayed items matches the log order much more closely.
> > 
> 
> That sounds like a nice idea to me. There might actually be some room
> for consolidation between the RUI/EFI recovered bits and whatnot, but
> only if it makes things more clean and simple.
> 
> Brian
> 
> > > >  		/*
> > > >  		 * Sync the log to get all the EFIs out of the AIL.
> > > >  		 * This isn't absolutely necessary, but it helps in
> > > > @@ -5176,9 +5498,15 @@ xlog_recover_cancel(
> > > >  	struct xlog	*log)
> > > >  {
> > > >  	int		error = 0;
> > > > +	int		err2;
> > > >  
> > > > -	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> > > > -		error = xlog_recover_cancel_efis(log);
> > > > +	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> > > > +		error = xlog_recover_cancel_ruis(log);
> > > > +
> > > > +		err2 = xlog_recover_cancel_efis(log);
> > > > +		if (err2 && !error)
> > > > +			error = err2;
> > > > +	}
> > > >  
> > > >  	return error;
> > > >  }
> > > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > > index f8d363f..c48be63 100644
> > > > --- a/fs/xfs/xfs_trans.h
> > > > +++ b/fs/xfs/xfs_trans.h
> > > > @@ -235,4 +235,21 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
> > > >  extern kmem_zone_t	*xfs_trans_zone;
> > > >  extern kmem_zone_t	*xfs_log_item_desc_zone;
> > > >  
> > > > +enum xfs_rmap_intent_type;
> > > > +
> > > > +struct xfs_rui_log_item *xfs_trans_get_rui(struct xfs_trans *tp, uint nextents);
> > > > +void xfs_trans_log_start_rmap_update(struct xfs_trans *tp,
> > > > +		struct xfs_rui_log_item *ruip, enum xfs_rmap_intent_type type,
> > > > +		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> > > > +		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> > > > +		xfs_exntst_t state);
> > > > +
> > > > +struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
> > > > +		struct xfs_rui_log_item *ruip, uint nextents);
> > > > +int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
> > > > +		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
> > > > +		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> > > > +		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> > > > +		xfs_exntst_t state);
> > > > +
> > > >  #endif	/* __XFS_TRANS_H__ */
> > > > diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> > > > new file mode 100644
> > > > index 0000000..b55a725
> > > > --- /dev/null
> > > > +++ b/fs/xfs/xfs_trans_rmap.c
> > > > @@ -0,0 +1,235 @@
> > > > +/*
> > > > + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> > > > + *
> > > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or
> > > > + * modify it under the terms of the GNU General Public License
> > > > + * as published by the Free Software Foundation; either version 2
> > > > + * of the License, or (at your option) any later version.
> > > > + *
> > > > + * This program is distributed in the hope that it would be useful,
> > > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > > + * GNU General Public License for more details.
> > > > + *
> > > > + * You should have received a copy of the GNU General Public License
> > > > + * along with this program; if not, write the Free Software Foundation,
> > > > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > > > + */
> > > > +#include "xfs.h"
> > > > +#include "xfs_fs.h"
> > > > +#include "xfs_shared.h"
> > > > +#include "xfs_format.h"
> > > > +#include "xfs_log_format.h"
> > > > +#include "xfs_trans_resv.h"
> > > > +#include "xfs_mount.h"
> > > > +#include "xfs_defer.h"
> > > > +#include "xfs_trans.h"
> > > > +#include "xfs_trans_priv.h"
> > > > +#include "xfs_rmap_item.h"
> > > > +#include "xfs_alloc.h"
> > > > +#include "xfs_rmap_btree.h"
> > > > +
> > > > +/*
> > > > + * This routine is called to allocate an "rmap update intent"
> > > > + * log item that will hold nextents worth of extents.  The
> > > > + * caller must use all nextents extents, because we are not
> > > > + * flexible about this at all.
> > > > + */
> > > > +struct xfs_rui_log_item *
> > > > +xfs_trans_get_rui(
> > > > +	struct xfs_trans		*tp,
> > > > +	uint				nextents)
> > > > +{
> > > > +	struct xfs_rui_log_item		*ruip;
> > > > +
> > > > +	ASSERT(tp != NULL);
> > > > +	ASSERT(nextents > 0);
> > > > +
> > > > +	ruip = xfs_rui_init(tp->t_mountp, nextents);
> > > > +	ASSERT(ruip != NULL);
> > > > +
> > > > +	/*
> > > > +	 * Get a log_item_desc to point at the new item.
> > > > +	 */
> > > > +	xfs_trans_add_item(tp, &ruip->rui_item);
> > > > +	return ruip;
> > > > +}
> > > > +
> > > > +/*
> > > > + * This routine is called to indicate that the described
> > > > + * extent is to be logged as needing to be freed.  It should
> > > > + * be called once for each extent to be freed.
> > > > + */
> > > 
> > > Stale comment.
> > 
> > <nod>
> > 
> > > > +void
> > > > +xfs_trans_log_start_rmap_update(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct xfs_rui_log_item		*ruip,
> > > > +	enum xfs_rmap_intent_type	type,
> > > > +	__uint64_t			owner,
> > > > +	int				whichfork,
> > > > +	xfs_fileoff_t			startoff,
> > > > +	xfs_fsblock_t			startblock,
> > > > +	xfs_filblks_t			blockcount,
> > > > +	xfs_exntst_t			state)
> > > > +{
> > > > +	uint				next_extent;
> > > > +	struct xfs_map_extent		*rmap;
> > > > +
> > > > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > > > +	ruip->rui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > > > +
> > > > +	/*
> > > > +	 * atomic_inc_return gives us the value after the increment;
> > > > +	 * we want to use it as an array index so we need to subtract 1 from
> > > > +	 * it.
> > > > +	 */
> > > > +	next_extent = atomic_inc_return(&ruip->rui_next_extent) - 1;
> > > > +	ASSERT(next_extent < ruip->rui_format.rui_nextents);
> > > > +	rmap = &(ruip->rui_format.rui_extents[next_extent]);
> > > > +	rmap->me_owner = owner;
> > > > +	rmap->me_startblock = startblock;
> > > > +	rmap->me_startoff = startoff;
> > > > +	rmap->me_len = blockcount;
> > > > +	rmap->me_flags = 0;
> > > > +	if (state == XFS_EXT_UNWRITTEN)
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
> > > > +	if (whichfork == XFS_ATTR_FORK)
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
> > > > +	switch (type) {
> > > > +	case XFS_RMAP_MAP:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
> > > > +		break;
> > > > +	case XFS_RMAP_MAP_SHARED:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
> > > > +		break;
> > > > +	case XFS_RMAP_UNMAP:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
> > > > +		break;
> > > > +	case XFS_RMAP_UNMAP_SHARED:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
> > > > +		break;
> > > > +	case XFS_RMAP_CONVERT:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
> > > > +		break;
> > > > +	case XFS_RMAP_CONVERT_SHARED:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
> > > > +		break;
> > > > +	case XFS_RMAP_ALLOC:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
> > > > +		break;
> > > > +	case XFS_RMAP_FREE:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_FREE;
> > > > +		break;
> > > > +	default:
> > > > +		ASSERT(0);
> > > > +	}
> > > 
> > > Between here and the finish function, it looks like we could use a
> > > helper to convert the state and whatnot to extent flags.
> > 
> > Ok.
> > 
> > > > +}
> > > > +
> > > > +
> > > > +/*
> > > > + * This routine is called to allocate an "extent free done"
> > > > + * log item that will hold nextents worth of extents.  The
> > > > + * caller must use all nextents extents, because we are not
> > > > + * flexible about this at all.
> > > > + */
> > > 
> > > Comment needs updating.
> > 
> > Ok.
> > 
> > > Brian
> > > 
> > > > +struct xfs_rud_log_item *
> > > > +xfs_trans_get_rud(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct xfs_rui_log_item		*ruip,
> > > > +	uint				nextents)
> > > > +{
> > > > +	struct xfs_rud_log_item		*rudp;
> > > > +
> > > > +	ASSERT(tp != NULL);
> > > > +	ASSERT(nextents > 0);
> > > > +
> > > > +	rudp = xfs_rud_init(tp->t_mountp, ruip, nextents);
> > > > +	ASSERT(rudp != NULL);
> > > > +
> > > > +	/*
> > > > +	 * Get a log_item_desc to point at the new item.
> > > > +	 */
> > > > +	xfs_trans_add_item(tp, &rudp->rud_item);
> > > > +	return rudp;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Finish an rmap update and log it to the RUD. Note that the transaction is
> > > > + * marked dirty regardless of whether the rmap update succeeds or fails to
> > > > + * support the RUI/RUD lifecycle rules.
> > > > + */
> > > > +int
> > > > +xfs_trans_log_finish_rmap_update(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct xfs_rud_log_item		*rudp,
> > > > +	enum xfs_rmap_intent_type	type,
> > > > +	__uint64_t			owner,
> > > > +	int				whichfork,
> > > > +	xfs_fileoff_t			startoff,
> > > > +	xfs_fsblock_t			startblock,
> > > > +	xfs_filblks_t			blockcount,
> > > > +	xfs_exntst_t			state)
> > > > +{
> > > > +	uint				next_extent;
> > > > +	struct xfs_map_extent		*rmap;
> > > > +	int				error;
> > > > +
> > > > +	/* XXX: actually finish the rmap update here */
> > > > +	error = -EFSCORRUPTED;
> > > > +
> > > > +	/*
> > > > +	 * Mark the transaction dirty, even on error. This ensures the
> > > > +	 * transaction is aborted, which:
> > > > +	 *
> > > > +	 * 1.) releases the RUI and frees the RUD
> > > > +	 * 2.) shuts down the filesystem
> > > > +	 */
> > > > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > > > +	rudp->rud_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > > > +
> > > > +	next_extent = rudp->rud_next_extent;
> > > > +	ASSERT(next_extent < rudp->rud_format.rud_nextents);
> > > > +	rmap = &(rudp->rud_format.rud_extents[next_extent]);
> > > > +	rmap->me_owner = owner;
> > > > +	rmap->me_startblock = startblock;
> > > > +	rmap->me_startoff = startoff;
> > > > +	rmap->me_len = blockcount;
> > > > +	rmap->me_flags = 0;
> > > > +	if (state == XFS_EXT_UNWRITTEN)
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
> > > > +	if (whichfork == XFS_ATTR_FORK)
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
> > > > +	switch (type) {
> > > > +	case XFS_RMAP_MAP:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
> > > > +		break;
> > > > +	case XFS_RMAP_MAP_SHARED:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
> > > > +		break;
> > > > +	case XFS_RMAP_UNMAP:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
> > > > +		break;
> > > > +	case XFS_RMAP_UNMAP_SHARED:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
> > > > +		break;
> > > > +	case XFS_RMAP_CONVERT:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
> > > > +		break;
> > > > +	case XFS_RMAP_CONVERT_SHARED:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
> > > > +		break;
> > > > +	case XFS_RMAP_ALLOC:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
> > > > +		break;
> > > > +	case XFS_RMAP_FREE:
> > > > +		rmap->me_flags |= XFS_RMAP_EXTENT_FREE;
> > > > +		break;
> > > > +	default:
> > > > +		ASSERT(0);
> > > > +	}
> > > > +	rudp->rud_next_extent++;
> > > > +
> > > > +	return error;
> > > > +}
> > > > 
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
