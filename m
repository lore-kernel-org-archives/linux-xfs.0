Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751062AbdFTHPS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 03:15:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF5D123E6C8
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2017 07:15:17 +0000 (UTC)
Date: Tue, 20 Jun 2017 09:15:14 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2 V4] xfs: Add infrastructure needed for error
 propagation during buffer IO failure
Message-ID: <20170620071514.ufcfecs6sfhcq3ht@eorzea.usersys.redhat.com>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-2-cmaiolino@redhat.com>
 <20170619134834.GB25516@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170619134834.GB25516@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> Looks mostly Ok to me, just a few nits...
> 
> >  fs/xfs/xfs_buf_item.c | 23 ++++++++++++++++++++++-
> >  fs/xfs/xfs_trans.h    |  7 +++++--
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 0306168..4fa68c9 100644
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
> > @@ -1051,6 +1052,22 @@ xfs_buf_do_callbacks(
> >  	}
> >  }
> >  
> > +STATIC void
> > +xfs_buf_do_callbacks_fail(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_log_item	*tli, *lip, *next;
> > +
> > +	tli = bp->b_fspriv;
> 
> We can just define a local pointer to the xfs_ail rather than maintain a
> log item pointer purely for the purpose of the lock. E.g.:
> 
> 	struct xfs_log_item	*lip = bp->b_fspriv;
> 	struct xfs_ail		*ailp = lip->li_ailp;
> 
> 	spin_lock(&ailp->xa_lock);
> 	for (; lip; lip = next) {
> 		...
> 	}
> 	...
> 
> It also couldn't hurt to ASSERT(bp->b_error) somewhere in here.

Sounds fair, I'll change these things
> 
> > +	spin_lock(&tli->li_ailp->xa_lock);
> > +	for (lip = bp->b_fspriv; lip; lip = next) {
> > +		next = lip->li_bio_list;
> > +		if (lip->li_ops->iop_error)
> > +			lip->li_ops->iop_error(lip, bp);
> > +	}
> > +	spin_unlock(&tli->li_ailp->xa_lock);
> > +}
> > +
> >  static bool
> >  xfs_buf_iodone_callback_error(
> >  	struct xfs_buf		*bp)
> > @@ -1120,7 +1137,11 @@ xfs_buf_iodone_callback_error(
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
> > index a07acbf..50df5367 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -64,11 +64,13 @@ typedef struct xfs_log_item {
> >  } xfs_log_item_t;
> >  
> >  #define	XFS_LI_IN_AIL	0x1
> > -#define XFS_LI_ABORTED	0x2
> > +#define	XFS_LI_ABORTED	0x2
> > +#define	XFS_LI_FAILED	0x4
> 
> Weren't you planning to change these to (1 << N) format?
> 

Yeah, I just forgot to add it to my 'todo' for this patchset and it went to
/dev/null during all the other changes :)

I'll add it to the next one.
 
> Brian
> 
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
