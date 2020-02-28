Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17DDC3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720682051A
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxlvZqVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgB1Nz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:55:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51177 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725892AbgB1Nzz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582898154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ZWtFwnYihqjpL/fjSaBPCu4PzuWukha6ukiK/6+k60=;
        b=fxlvZqVIk0j+F6gVc+SSiMn8QdA0fMVz9MkH19n+pq+GWvcyyETBwYlRbsumPUiL3J8/SL
        DHLnKvYbzyr8DEPIrMzpKho/YOwiumfbGQN+i39qmD2P5k1rW7OpHCoH3ZTyB4xUYFWsiq
        Z3glCkgLRHJoqkETBs5+FjJFK8VQPQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-medkoTH8P46p3lyH07mtVw-1; Fri, 28 Feb 2020 08:55:52 -0500
X-MC-Unique: medkoTH8P46p3lyH07mtVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFBD88017CC;
        Fri, 28 Feb 2020 13:55:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44AA71CB;
        Fri, 28 Feb 2020 13:55:50 +0000 (UTC)
Date:   Fri, 28 Feb 2020 08:55:48 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200228135548.GC2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200228000218.GR8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228000218.GR8045@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 04:02:18PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 27, 2020 at 08:43:15AM -0500, Brian Foster wrote:
> > Automatic item relogging will occur from xfsaild context. xfsaild
> > cannot acquire log reservation itself because it is also responsible
> > for writeback and thus making used log reservation available again.
> > Since there is no guarantee log reservation is available by the time
> > a relogged item reaches the AIL, this is prone to deadlock.
> > 
> > To guarantee log reservation for automatic relogging, implement a
> > reservation management scheme where a transaction that is capable of
> > enabling relogging of an item must contribute the necessary
> > reservation to the relog mechanism up front.
> 
> Ooooh, I had wondered where I was going to find that hook. :)
> 
> What does it mean to be capable of enabling relogging of an item?
> 

It's basically a requirement introduced by this patch that any
transaction that wants to enable relog on an item needs to check whether
the "central relog ticket" already exists, and if not, it needs to
contribute reservation to it as part of its normal transaction
allocation process.

> For the quotaoff example, does this mean that all the transactions that
> happen on behalf of a quotaoff operation must specify TRANS_RELOG?
> 

No, only the transaction that commits the quotaoff start intent.

> What if the relog thread grinds to a halt while other non-RELOG threads
> continue to push things into the log?  Can we starve and/or livelock
> waiting around?  Or should the log be able to kick some higher level
> thread to inject a TRANS_RELOG transaction to move things along?
> 

I hope not. :P At least I haven't seen such issues in my (fairly limited
and focused) testing so far.

> > Use reference counting
> > to associate the lifetime of pending relog reservation to the
> > lifetime of in-core log items with relogging enabled.
> 
> Ok, so we only have to pay the relog reservation while there are
> reloggable items floating around in the system.
> 

Yeah, I was back and forth on this because the relog reservation
tracking thing is a bit of complexity itself. It's much simpler to have
the AIL or something allocate a relog transaction up front and just keep
it around for the lifetime of the mount. My thinking was that relogs
could be quite rare (quotaoff, scrub), so it's probably an unfair use of
resources. I figured it best to try and provide some flexibility up
front and we can always back off to something more simplified later.

If we ended up with something like a reloggable "zero on recovery"
intent for writeback, that ties more into core fs functionality and the
simpler relog ticket implementation might be justified.

> > The basic log reservation sequence for a relog enabled transaction
> > is as follows:
> > 
> > - A transaction that uses relogging specifies XFS_TRANS_RELOG at
> >   allocation time.
> > - Once initialized, RELOG transactions check for the existence of
> >   the global relog log ticket. If it exists, grab a reference and
> >   return. If not, allocate an empty ticket and install into the relog
> >   subsystem. Seed the relog ticket from reservation of the current
> >   transaction. Roll the current transaction to replenish its
> >   reservation and return to the caller.
> 
> I guess we'd have to be careful that the transaction we're stealing from
> actually has enough reservation to re-log a pending item, but that
> shouldn't be difficult.
> 
> I worry that there might be some operation somewhere that Just Works
> because tr_logcount * tr_logres is enough space for it to run without
> having to get more reseration, but (tr_logcount - 1) * tr_logres isn't
> enough.  Though that might not be a big issue seeing how bloated the
> log reservations become when reflink and rmap are turned on. <cough>
> 

This ties in to the size calculation of the relog transaction and the
fact that the contributing transaction rolls before it carries on to
normal use. IOW, this approach adds zero extra reservation consumption
to existing transaction commits, so there should be no additional risk
of reservation overrun in that regard.

> > - The transaction is used as normal. If an item is relogged in the
> >   transaction, that item acquires a reference on the global relog
> >   ticket currently held open by the transaction. The item's reference
> >   persists until relogging is disabled on the item.
> > - The RELOG transaction commits and releases its reference to the
> >   global relog ticket. The global relog ticket is released once its
> >   reference count drops to zero.
> > 
> > This provides a central relog log ticket that guarantees reservation
> > availability for relogged items, avoids log reservation deadlocks
> > and is allocated and released on demand.
> 
> Sounds cool.  /me jumps in.
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_shared.h |  1 +
> >  fs/xfs/xfs_trans.c         | 37 +++++++++++++---
> >  fs/xfs/xfs_trans.h         |  3 ++
> >  fs/xfs/xfs_trans_ail.c     | 89 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_trans_priv.h    |  1 +
> >  5 files changed, 126 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index c45acbd3add9..0a10ca0853ab 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -77,6 +77,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> >   * made then this algorithm will eventually find all the space it needs.
> >   */
> >  #define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
> > +#define XFS_TRANS_RELOG		0x200	/* enable automatic relogging */
> >  
> >  /*
> >   * Field values for xfs_trans_mod_sb.
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 3b208f9a865c..8ac05ed8deda 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -107,9 +107,14 @@ xfs_trans_dup(
> >  
> >  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
> >  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> > -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> > -	/* We gave our writer reference to the new transaction */
> > +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> > +		       (tp->t_flags & XFS_TRANS_RELOG);
> > +	/*
> > +	 * The writer reference and relog reference transfer to the new
> > +	 * transaction.
> > +	 */
> >  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
> > +	tp->t_flags &= ~XFS_TRANS_RELOG;
> >  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> >  
> >  	ASSERT(tp->t_blk_res >= tp->t_blk_res_used);
> > @@ -284,15 +289,25 @@ xfs_trans_alloc(
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > -	if (error) {
> > -		xfs_trans_cancel(tp);
> > -		return error;
> > +	if (error)
> > +		goto error;
> > +
> > +	if (flags & XFS_TRANS_RELOG) {
> > +		error = xfs_trans_ail_relog_reserve(&tp);
> > +		if (error)
> > +			goto error;
> >  	}
> >  
> >  	trace_xfs_trans_alloc(tp, _RET_IP_);
> >  
> >  	*tpp = tp;
> >  	return 0;
> > +
> > +error:
> > +	/* clear relog flag if we haven't acquired a ref */
> > +	tp->t_flags &= ~XFS_TRANS_RELOG;
> > +	xfs_trans_cancel(tp);
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -973,6 +988,10 @@ __xfs_trans_commit(
> >  
> >  	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
> >  
> > +	/* release the relog ticket reference if this transaction holds one */
> > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > +		xfs_trans_ail_relog_put(mp);
> > +
> >  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> >  	xfs_trans_free(tp);
> >  
> > @@ -1004,6 +1023,10 @@ __xfs_trans_commit(
> >  			error = -EIO;
> >  		tp->t_ticket = NULL;
> >  	}
> > +	/* release the relog ticket reference if this transaction holds one */
> > +	/* XXX: handle RELOG items on transaction abort */
> 
> "Handle"?  Hm.  Do the reloggable items end up attached in some way to
> this new transaction, or are we purely stealing the reservation so that
> the ail can use it to relog the items on its own?  If it's the second,
> then I wonder what handling do we need to do?
> 

More the latter...

> Or maybe you meant handling the relog items that the caller attached to
> this relog transaction?  Won't those get cancelled the same way they do
> now?
> 

This comment was more of a note to self that when putting this together
I hadn't thought through the abort/shutdown path and whether the code is
correct (i.e., should the transaction cancel relog state? I still need
to test an abort of a relog commit, etc.). That's still something I need
to work through, but I wouldn't read more into the comment than that.

Brian

> Mechanically this looks reasonable.
> 
> --D
> 
> > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > +		xfs_trans_ail_relog_put(mp);
> >  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> >  	xfs_trans_free_items(tp, !!error);
> >  	xfs_trans_free(tp);
> > @@ -1064,6 +1087,10 @@ xfs_trans_cancel(
> >  		tp->t_ticket = NULL;
> >  	}
> >  
> > +	/* release the relog ticket reference if this transaction holds one */
> > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > +		xfs_trans_ail_relog_put(mp);
> > +
> >  	/* mark this thread as no longer being in a transaction */
> >  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> >  
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 752c7fef9de7..a032989943bd 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -236,6 +236,9 @@ int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> >  void		xfs_trans_cancel(xfs_trans_t *);
> >  int		xfs_trans_ail_init(struct xfs_mount *);
> >  void		xfs_trans_ail_destroy(struct xfs_mount *);
> > +int		xfs_trans_ail_relog_reserve(struct xfs_trans **);
> > +bool		xfs_trans_ail_relog_get(struct xfs_mount *);
> > +int		xfs_trans_ail_relog_put(struct xfs_mount *);
> >  
> >  void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
> >  				       enum xfs_blft);
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 00cc5b8734be..a3fb64275baa 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -17,6 +17,7 @@
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> >  #include "xfs_log.h"
> > +#include "xfs_log_priv.h"
> >  
> >  #ifdef DEBUG
> >  /*
> > @@ -818,6 +819,93 @@ xfs_trans_ail_delete(
> >  		xfs_log_space_wake(ailp->ail_mount);
> >  }
> >  
> > +bool
> > +xfs_trans_ail_relog_get(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_ail		*ailp = mp->m_ail;
> > +	bool			ret = false;
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	if (ailp->ail_relog_tic) {
> > +		xfs_log_ticket_get(ailp->ail_relog_tic);
> > +		ret = true;
> > +	}
> > +	spin_unlock(&ailp->ail_lock);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Reserve log space for the automatic relogging ->tr_relog ticket. This
> > + * requires a clean, permanent transaction from the caller. Pull reservation
> > + * for the relog ticket and roll the caller's transaction back to its fully
> > + * reserved state. If the AIL relog ticket is already initialized, grab a
> > + * reference and return.
> > + */
> > +int
> > +xfs_trans_ail_relog_reserve(
> > +	struct xfs_trans	**tpp)
> > +{
> > +	struct xfs_trans	*tp = *tpp;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_ail		*ailp = mp->m_ail;
> > +	struct xlog_ticket	*tic;
> > +	uint32_t		logres = M_RES(mp)->tr_relog.tr_logres;
> > +
> > +	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> > +
> > +	if (xfs_trans_ail_relog_get(mp))
> > +		return 0;
> > +
> > +	/* no active ticket, fall into slow path to allocate one.. */
> > +	tic = xlog_ticket_alloc(mp->m_log, logres, 1, XFS_TRANSACTION, true, 0);
> > +	if (!tic)
> > +		return -ENOMEM;
> > +	ASSERT(tp->t_ticket->t_curr_res >= tic->t_curr_res);
> > +
> > +	/* check again since we dropped the lock for the allocation */
> > +	spin_lock(&ailp->ail_lock);
> > +	if (ailp->ail_relog_tic) {
> > +		xfs_log_ticket_get(ailp->ail_relog_tic);
> > +		spin_unlock(&ailp->ail_lock);
> > +		xfs_log_ticket_put(tic);
> > +		return 0;
> > +	}
> > +
> > +	/* attach and reserve space for the ->tr_relog ticket */
> > +	ailp->ail_relog_tic = tic;
> > +	tp->t_ticket->t_curr_res -= tic->t_curr_res;
> > +	spin_unlock(&ailp->ail_lock);
> > +
> > +	return xfs_trans_roll(tpp);
> > +}
> > +
> > +/*
> > + * Release a reference to the relog ticket.
> > + */
> > +int
> > +xfs_trans_ail_relog_put(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_ail		*ailp = mp->m_ail;
> > +	struct xlog_ticket	*tic;
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	if (atomic_add_unless(&ailp->ail_relog_tic->t_ref, -1, 1)) {
> > +		spin_unlock(&ailp->ail_lock);
> > +		return 0;
> > +	}
> > +
> > +	ASSERT(atomic_read(&ailp->ail_relog_tic->t_ref) == 1);
> > +	tic = ailp->ail_relog_tic;
> > +	ailp->ail_relog_tic = NULL;
> > +	spin_unlock(&ailp->ail_lock);
> > +
> > +	xfs_log_done(mp, tic, NULL, false);
> > +	return 0;
> > +}
> > +
> >  int
> >  xfs_trans_ail_init(
> >  	xfs_mount_t	*mp)
> > @@ -854,6 +942,7 @@ xfs_trans_ail_destroy(
> >  {
> >  	struct xfs_ail	*ailp = mp->m_ail;
> >  
> > +	ASSERT(ailp->ail_relog_tic == NULL);
> >  	kthread_stop(ailp->ail_task);
> >  	kmem_free(ailp);
> >  }
> > diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> > index 2e073c1c4614..839df6559b9f 100644
> > --- a/fs/xfs/xfs_trans_priv.h
> > +++ b/fs/xfs/xfs_trans_priv.h
> > @@ -61,6 +61,7 @@ struct xfs_ail {
> >  	int			ail_log_flush;
> >  	struct list_head	ail_buf_list;
> >  	wait_queue_head_t	ail_empty;
> > +	struct xlog_ticket	*ail_relog_tic;
> >  };
> >  
> >  /*
> > -- 
> > 2.21.1
> > 
> 

