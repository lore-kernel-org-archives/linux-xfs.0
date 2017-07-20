Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934876AbdGTMB3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 08:01:29 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DB7B7CBB4
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 12:01:29 +0000 (UTC)
Date: Thu, 20 Jul 2017 14:01:10 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2 V5] xfs: Add infrastructure needed for error
 propagation during buffer IO failure
Message-ID: <20170720120106.goudga72xuju47wy@eorzea.usersys.redhat.com>
References: <20170718145415.21230-1-cmaiolino@redhat.com>
 <20170718145415.21230-2-cmaiolino@redhat.com>
 <20170719120102.GB53744@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719120102.GB53744@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 19, 2017 at 08:01:04AM -0400, Brian Foster wrote:
> On Tue, Jul 18, 2017 at 04:54:14PM +0200, Carlos Maiolino wrote:
> > With the current code, XFS never re-submit a failed buffer for IO,
> > because the failed item in the buffer is kept in the flush locked state
> > forever.
> > 
> > To be able to resubmit an log item for IO, we need a way to mark an item
> > as failed, if, for any reason the buffer which the item belonged to
> > failed during writeback.
> > 
> > Add a new log item callback to be used after an IO completion failure
> > and make the needed clean ups.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> 
> I think a comment would be nice for _do_callbacks_fail() (see below for
> an example), but otherwise the code looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > 
> > V2:
> > 	- Update commit log to include a better description of why this
> > 	  patch is needed and fix spelling mistakes
> > 	- Move xfs_buf_do_callbacks_fail() call into
> > 	  xfs_buf_iodone_callback_error, so the callbacks can be executed
> > 	  before the buffer is released, and only after it has been
> > 	  retried once
> > 
> > V3:
> > 	- fix some loops according to hch suggestion
> > 	- whitespace cleanup
> > 
> > V4:
> > 	- Invoke failure callbacks before reset the I/O error
> > 	- Remove bflags field from iop_error callback
> > 	- move spin_lock/unlock xa_lock up in the stack, handling all
> > 	  log items in the same buffer into a single lock
> > 
> > V5:
> > 	- Reorganize variable declarations
> > 	  in fxs_buf_do_callbacks_fail
> > 
> >  fs/xfs/xfs_buf_item.c | 24 +++++++++++++++++++++++-
> >  fs/xfs/xfs_trans.h    |  7 +++++--
> >  2 files changed, 28 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index f6a8422..d6ca7d6 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -29,6 +29,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_log.h"
> > +#include "xfs_inode.h"
> >  
> >  
> >  kmem_zone_t	*xfs_buf_item_zone;
> > @@ -1054,6 +1055,23 @@ xfs_buf_do_callbacks(
> >  	}
> >  }
> >  
> 
> /*
>  * Invoke the error state callback for each log item affected by the failed I/O.
>  *
>  * If a metadata buffer write fails with a non-permanent error, the buffer is
>  * eventually resubmitted and so the completion callbacks are not run. The error
>  * state may need to be propagated to the log items attached to the buffer,
>  * however, so the next AIL push of the item knows how to handle it correctly.
>  */

ok, I have no objection in detailing more it. this comment looks fine, I'll add
it up to the V6 and keep your review tag if it's ok.

cheers
> 
> > +STATIC void
> > +xfs_buf_do_callbacks_fail(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_log_item	*next;
> > +	struct xfs_log_item	*lip = bp->b_fspriv;
> > +	struct xfs_ail		*ailp = lip->li_ailp;
> > +
> > +	spin_lock(&ailp->xa_lock);
> > +	for (; lip; lip = next) {
> > +		next = lip->li_bio_list;
> > +		if (lip->li_ops->iop_error)
> > +			lip->li_ops->iop_error(lip, bp);
> > +	}
> > +	spin_unlock(&ailp->xa_lock);
> > +}
> > +
> >  static bool
> >  xfs_buf_iodone_callback_error(
> >  	struct xfs_buf		*bp)
> > @@ -1123,7 +1141,11 @@ xfs_buf_iodone_callback_error(
> >  	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> >  		goto permanent_error;
> >  
> > -	/* still a transient error, higher layers will retry */
> > +	/*
> > +	 * Still a transient error, run IO completion failure callbacks and let
> > +	 * the higher layers retry the buffer.
> > +	 */
> > +	xfs_buf_do_callbacks_fail(bp);
> >  	xfs_buf_ioerror(bp, 0);
> >  	xfs_buf_relse(bp);
> >  	return true;
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 6bdad6f..442d679 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -64,11 +64,13 @@ typedef struct xfs_log_item {
> >  } xfs_log_item_t;
> >  
> >  #define	XFS_LI_IN_AIL	0x1
> > -#define XFS_LI_ABORTED	0x2
> > +#define	XFS_LI_ABORTED	0x2
> > +#define	XFS_LI_FAILED	0x4
> >  
> >  #define XFS_LI_FLAGS \
> >  	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
> > -	{ XFS_LI_ABORTED,	"ABORTED" }
> > +	{ XFS_LI_ABORTED,	"ABORTED" }, \
> > +	{ XFS_LI_FAILED,	"FAILED" }
> >  
> >  struct xfs_item_ops {
> >  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> > @@ -79,6 +81,7 @@ struct xfs_item_ops {
> >  	void (*iop_unlock)(xfs_log_item_t *);
> >  	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
> >  	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
> > +	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
> >  };
> >  
> >  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
