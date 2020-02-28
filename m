Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6A0C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4F95246A8
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWTvp81Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgB1OCK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 09:02:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726752AbgB1OCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 09:02:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582898527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p/SHR1ycYPv77VhLe17NvOx+bkMk/m3nGWCN1K3t7pw=;
        b=UWTvp81YXxzw0bfSLtqCs/Phrkedzd8TEGU2R02tbL8c3G6vOdHRWBr/M2TMXyDbo9cX3b
        kkpyXE4GldgqMJSSA/J218c4XkR/AKqAnmZLDhOwi2cfpngYV5JFmrJoySjfymB/yRnJNO
        Ge8aq3MOOm6BmSH0nlHlqR87N+ZV624=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-EnPBQCwcMW6RzchW3U946g-1; Fri, 28 Feb 2020 09:02:05 -0500
X-MC-Unique: EnPBQCwcMW6RzchW3U946g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E8208017DF;
        Fri, 28 Feb 2020 14:02:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB2C41001B09;
        Fri, 28 Feb 2020 14:02:03 +0000 (UTC)
Date:   Fri, 28 Feb 2020 09:02:02 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
Message-ID: <20200228140202.GD2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-6-bfoster@redhat.com>
 <20200228001345.GS8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228001345.GS8045@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 04:13:45PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 27, 2020 at 08:43:17AM -0500, Brian Foster wrote:
> > Now that relog reservation is available and relog state tracking is
> > in place, all that remains to automatically relog items is the relog
> > mechanism itself. An item with relogging enabled is basically pinned
> > from writeback until relog is disabled. Instead of being written
> > back, the item must instead be periodically committed in a new
> > transaction to move it in the physical log. The purpose of moving
> > the item is to avoid long term tail pinning and thus avoid log
> > deadlocks for long running operations.
> > 
> > The ideal time to relog an item is in response to tail pushing
> > pressure. This accommodates the current workload at any given time
> > as opposed to a fixed time interval or log reservation heuristic,
> > which risks performance regression. This is essentially the same
> > heuristic that drives metadata writeback. XFS already implements
> > various log tail pushing heuristics that attempt to keep the log
> > progressing on an active fileystem under various workloads.
> > 
> > The act of relogging an item simply requires to add it to a
> > transaction and commit. This pushes the already dirty item into a
> > subsequent log checkpoint and frees up its previous location in the
> > on-disk log. Joining an item to a transaction of course requires
> > locking the item first, which means we have to be aware of
> > type-specific locks and lock ordering wherever the relog takes
> > place.
> > 
> > Fundamentally, this points to xfsaild as the ideal location to
> > process relog enabled items. xfsaild already processes log resident
> > items, is driven by log tail pushing pressure, processes arbitrary
> > log item types through callbacks, and is sensitive to type-specific
> > locking rules by design. The fact that automatic relogging
> > essentially diverts items between writeback or relog also suggests
> > xfsaild as an ideal location to process items one way or the other.
> > 
> > Of course, we don't want xfsaild to process transactions as it is a
> > critical component of the log subsystem for driving metadata
> > writeback and freeing up log space. Therefore, similar to how
> > xfsaild builds up a writeback queue of dirty items and queues writes
> > asynchronously, make xfsaild responsible only for directing pending
> > relog items into an appropriate queue and create an async
> > (workqueue) context for processing the queue. The workqueue context
> > utilizes the pre-reserved relog ticket to drain the queue by rolling
> > a permanent transaction.
> 
> Aha!  I bet that's that workqueue I was musing about earlier.
> 

:)

> > Update the AIL pushing infrastructure to support a new RELOG item
> > state. If a log item push returns the relog state, queue the item
> > for relog instead of writeback. On completion of a push cycle,
> > schedule the relog task at the same point metadata buffer I/O is
> > submitted. This allows items to be relogged automatically under the
> > same locking rules and pressure heuristics that govern metadata
> > writeback.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_trace.h      |   1 +
> >  fs/xfs/xfs_trans.h      |   1 +
> >  fs/xfs/xfs_trans_ail.c  | 103 +++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_trans_priv.h |   3 ++
> >  4 files changed, 106 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index a066617ec54d..df0114ec66f1 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1063,6 +1063,7 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> > +DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
> >  DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
> >  DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
> >  
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index fc4c25b6eee4..1637df32c64c 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -99,6 +99,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> >  #define XFS_ITEM_PINNED		1
> >  #define XFS_ITEM_LOCKED		2
> >  #define XFS_ITEM_FLUSHING	3
> > +#define XFS_ITEM_RELOG		4
> >  
> >  /*
> >   * Deferred operation item relogging limits.
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index a3fb64275baa..71a47faeaae8 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -144,6 +144,75 @@ xfs_ail_max_lsn(
> >  	return lsn;
> >  }
> >  
> > +/*
> > + * Relog log items on the AIL relog queue.
> > + */
> > +static void
> > +xfs_ail_relog(
> > +	struct work_struct	*work)
> > +{
> > +	struct xfs_ail		*ailp = container_of(work, struct xfs_ail,
> > +						     ail_relog_work);
> > +	struct xfs_mount	*mp = ailp->ail_mount;
> > +	struct xfs_trans_res	tres = {};
> > +	struct xfs_trans	*tp;
> > +	struct xfs_log_item	*lip;
> > +	int			error;
> > +
> > +	/*
> > +	 * The first transaction to submit a relog item contributed relog
> > +	 * reservation to the relog ticket before committing. Create an empty
> > +	 * transaction and manually associate the relog ticket.
> > +	 */
> > +	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
> 
> Ah, and I see that the work item actually does create its own
> transaction to relog the items...
> 

Yeah, bit of a hack to allocate a shell transaction and attach the relog
ticket managed by the earlier patch, but it ended up cleaner than having
the transaction allocated and passed into this context.

> > +	ASSERT(!error);
> > +	if (error)
> > +		return;
> > +	tp->t_log_res = M_RES(mp)->tr_relog.tr_logres;
> > +	tp->t_log_count = M_RES(mp)->tr_relog.tr_logcount;
> > +	tp->t_flags |= M_RES(mp)->tr_relog.tr_logflags;
> > +	tp->t_ticket = xfs_log_ticket_get(ailp->ail_relog_tic);
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
> > +					       struct xfs_log_item,
> > +					       li_trans)) != NULL) {
> 
> ...but this part really cranks up my curiosity about what happens when
> there are more items to relog than there is actual reservation in this
> transaction?  I think most transactions types reserve enough space that
> we could attach hundreds of relogged intent items.
> 

See my earlier comment around batching. Right now we only relog one item
at a time and the relog reservation is intended to be the max possible
reloggable item in the fs. This needs to increase to support some kind
of batching here, but I think the prospective reloggable items right now
(i.e. 2 or 3 different intent types) allows a fixed calculation size to
work well enough for our needs.

Note that I think there's a whole separate ball of complexity we could
delve into if we wanted to support something like arbitrary, per-item
(set) relog tickets with different reservation values as opposed to one
global, fixed size ticket. That would require some association between
log items and tickets and perhaps other items covered by the same
ticket, etc., but would provide a much more generic mechanism. As it is,
I think that's hugely overkill for the current use cases, but maybe we
find a reason to evolve this into something like that down the road..

> > +		/*
> > +		 * Drop the AIL processing ticket reference once the relog list
> > +		 * is emptied. At this point it's possible for our transaction
> > +		 * to hold the only reference.
> > +		 */
> > +		list_del_init(&lip->li_trans);
> > +		if (list_empty(&ailp->ail_relog_list))
> > +			xfs_log_ticket_put(ailp->ail_relog_tic);
> > +		spin_unlock(&ailp->ail_lock);
> > +
> > +		xfs_trans_add_item(tp, lip);
> > +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > +		tp->t_flags |= XFS_TRANS_DIRTY;
> > +		/* XXX: include ticket owner task fix */
> 
> XXX?
> 

Oops, this refers to patch 1. I added the patch but forgot to remove the
comment, so this can go away..

Brian

> --D
> 
> > +		error = xfs_trans_roll(&tp);
> > +		ASSERT(!error);
> > +		if (error)
> > +			goto out;
> > +		spin_lock(&ailp->ail_lock);
> > +	}
> > +	spin_unlock(&ailp->ail_lock);
> > +
> > +out:
> > +	/* XXX: handle shutdown scenario */
> > +	/*
> > +	 * Drop the relog reference owned by the transaction separately because
> > +	 * we don't want the cancel to release reservation if this isn't the
> > +	 * final reference. The relog ticket and associated reservation needs
> > +	 * to persist so long as relog items are active in the log subsystem.
> > +	 */
> > +	xfs_trans_ail_relog_put(mp);
> > +
> > +	tp->t_ticket = NULL;
> > +	xfs_trans_cancel(tp);
> > +}
> > +
> >  /*
> >   * The cursor keeps track of where our current traversal is up to by tracking
> >   * the next item in the list for us. However, for this to be safe, removing an
> > @@ -364,7 +433,7 @@ static long
> >  xfsaild_push(
> >  	struct xfs_ail		*ailp)
> >  {
> > -	xfs_mount_t		*mp = ailp->ail_mount;
> > +	struct xfs_mount	*mp = ailp->ail_mount;
> >  	struct xfs_ail_cursor	cur;
> >  	struct xfs_log_item	*lip;
> >  	xfs_lsn_t		lsn;
> > @@ -426,6 +495,23 @@ xfsaild_push(
> >  			ailp->ail_last_pushed_lsn = lsn;
> >  			break;
> >  
> > +		case XFS_ITEM_RELOG:
> > +			/*
> > +			 * The item requires a relog. Add to the pending relog
> > +			 * list and set the relogged bit to prevent further
> > +			 * relog requests. The relog bit and ticket reference
> > +			 * can be dropped from the item at any point, so hold a
> > +			 * relog ticket reference for the pending relog list to
> > +			 * ensure the ticket stays around.
> > +			 */
> > +			trace_xfs_ail_relog(lip);
> > +			ASSERT(list_empty(&lip->li_trans));
> > +			if (list_empty(&ailp->ail_relog_list))
> > +				xfs_log_ticket_get(ailp->ail_relog_tic);
> > +			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
> > +			set_bit(XFS_LI_RELOGGED, &lip->li_flags);
> > +			break;
> > +
> >  		case XFS_ITEM_FLUSHING:
> >  			/*
> >  			 * The item or its backing buffer is already being
> > @@ -492,6 +578,9 @@ xfsaild_push(
> >  	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
> >  		ailp->ail_log_flush++;
> >  
> > +	if (!list_empty(&ailp->ail_relog_list))
> > +		queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
> > +
> >  	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
> >  out_done:
> >  		/*
> > @@ -922,15 +1011,24 @@ xfs_trans_ail_init(
> >  	spin_lock_init(&ailp->ail_lock);
> >  	INIT_LIST_HEAD(&ailp->ail_buf_list);
> >  	init_waitqueue_head(&ailp->ail_empty);
> > +	INIT_LIST_HEAD(&ailp->ail_relog_list);
> > +	INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
> > +
> > +	ailp->ail_relog_wq = alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE, 0,
> > +					     mp->m_super->s_id);
> > +	if (!ailp->ail_relog_wq)
> > +		goto out_free_ailp;
> >  
> >  	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
> >  			ailp->ail_mount->m_super->s_id);
> >  	if (IS_ERR(ailp->ail_task))
> > -		goto out_free_ailp;
> > +		goto out_destroy_wq;
> >  
> >  	mp->m_ail = ailp;
> >  	return 0;
> >  
> > +out_destroy_wq:
> > +	destroy_workqueue(ailp->ail_relog_wq);
> >  out_free_ailp:
> >  	kmem_free(ailp);
> >  	return -ENOMEM;
> > @@ -944,5 +1042,6 @@ xfs_trans_ail_destroy(
> >  
> >  	ASSERT(ailp->ail_relog_tic == NULL);
> >  	kthread_stop(ailp->ail_task);
> > +	destroy_workqueue(ailp->ail_relog_wq);
> >  	kmem_free(ailp);
> >  }
> > diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> > index d1edec1cb8ad..33a724534869 100644
> > --- a/fs/xfs/xfs_trans_priv.h
> > +++ b/fs/xfs/xfs_trans_priv.h
> > @@ -63,6 +63,9 @@ struct xfs_ail {
> >  	int			ail_log_flush;
> >  	struct list_head	ail_buf_list;
> >  	wait_queue_head_t	ail_empty;
> > +	struct work_struct	ail_relog_work;
> > +	struct list_head	ail_relog_list;
> > +	struct workqueue_struct	*ail_relog_wq;
> >  	struct xlog_ticket	*ail_relog_tic;
> >  };
> >  
> > -- 
> > 2.21.1
> > 
> 

