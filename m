Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE04C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 21:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BBBB24670
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 21:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfLEVCR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 16:02:17 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35258 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730321AbfLEVCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 16:02:17 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 98EED3A1A53;
        Fri,  6 Dec 2019 08:02:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1icyGJ-0005xz-7y; Fri, 06 Dec 2019 08:02:11 +1100
Date:   Fri, 6 Dec 2019 08:02:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v4 1/2] xfs: automatic log item relog mechanism
Message-ID: <20191205210211.GP2695@dread.disaster.area>
References: <20191205175037.52529-1-bfoster@redhat.com>
 <20191205175037.52529-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205175037.52529-2-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=2ix46YxvEj6hAd8jCOUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 05, 2019 at 12:50:36PM -0500, Brian Foster wrote:
> This is an AIL based mechanism to enable automatic relogging of
> selected log items. The use case is for particular operations that
> commit an item known to pin the tail of the log for a potentially
> long period of time and otherwise cannot use a rolling transaction.
> While this does not provide the deadlock avoidance guarantees of a
> rolling transaction, it ties the relog transaction into AIL pushing
> pressure such that we should expect the transaction to reserve the
> necessary log space long before deadlock becomes a problem.
> 
> To enable relogging, a bit is set on the log item before it is first
> committed to the log subsystem. Once the item commits to the on-disk
> log and inserts to the AIL, AIL pushing dictates when the item is
> ready for a relog. When that occurs, the item relogs in an
> independent transaction to ensure the log tail keeps moving without
> intervention from the original committer.  To disable relogging, the
> original committer clears the log item bit and optionally waits on
> relogging activity to cease if it needs to reuse the item before the
> operation completes.
> 
> While the current use case for automatic relogging is limited, the
> mechanism is AIL based because it 1.) provides existing callbacks
> into all possible log item types for future support and 2.) has
> applicable context to determine when to relog particular items (such
> as when an item pins the log tail). This provides enough flexibility
> to support various log item types and future workloads without
> introducing complexity up front for currently unknown use cases.
> Further complexity, such as preallocated or regranted relog
> transaction reservation or custom relog handlers can be considered
> as the need arises.

....

> +/*
> + * Relog log items on the AIL relog queue.
> + */
> +static void
> +xfs_ail_relog(
> +	struct work_struct	*work)
> +{
> +	struct xfs_ail		*ailp = container_of(work, struct xfs_ail,
> +						     ail_relog_work);
> +	struct xfs_mount	*mp = ailp->ail_mount;
> +	struct xfs_trans	*tp;
> +	struct xfs_log_item	*lip, *lipp;
> +	int			error;

Probably need PF_MEMALLOC here - this will need to make progress in
low memory situations, just like the xfsaild.

> +	/* XXX: define a ->tr_relog reservation */
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> +	if (error)
> +		return;

Also needs memalloc_nofs_save() around this whole function, because
we most definitely don't want this recursing into the filesystem and
running transactions when we are trying to ensure we don't pin the
tail of the log...

> +
> +	spin_lock(&ailp->ail_lock);
> +	list_for_each_entry_safe(lip, lipp, &ailp->ail_relog_list, li_trans) {
> +		list_del_init(&lip->li_trans);
> +		xfs_trans_add_item(tp, lip);
> +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +		tp->t_flags |= XFS_TRANS_DIRTY;
> +	}
> +	spin_unlock(&ailp->ail_lock);
> +
> +	error = xfs_trans_commit(tp);
> +	ASSERT(!error);
> +}

Simple, but I see several issues here regarding how generic this
approach is.

1. Memory reclaim deadlock. Needs to be run under
memalloc_nofs_save() context (and possibly PF_MEMALLOC) because
transaction allocation can trigger reclaim and that can run
filesystem transactions and can block waiting for log space. If we
already pin the tail of the log, then we deadlock in memory
reclaim...

2. Transaction reservation deadlock. If the item being relogged is
already at the tail of the log, or if the item that pins the tail
preventing further log reservations from finding space is in the
relog list, we will effectively deadlock the filesystem here.

3. it's going to require a log reservation for every item on the
relog list, in total. That cannot be known ahead of time as the
reservation is dependent on the dirty size of the items being added
to the transaction. Hence, if this is a generic mechanism, the
required reservation could be quite large... If it's too large, see
#1.

4. xfs_trans_commit() requires objects being logged to be locked
against concurrent modification.  Locking in the AIL context is
non-blocking, so the item needs to be locked against modification
before it is added to the ail_relog_list, and won't get unlocked
until it it committed again.

5. Locking random items in random order into the ail_relog_list
opens us up to ABBA deadlocks with locking in ongoing modifications.

6. If the item is already dirty in a transaction (i.e. currently
locked and joined to another transaction - being relogged) then then
xfs_trans_add_item() is either going to fire asserts because
XFS_LI_DIRTY is already set or it's going to corrupt the item list
of that already running transaction.

Given this, I'm skeptical this can be made into a useful, reliable
generic async relogging mechanism.

>  /*
>   * The cursor keeps track of where our current traversal is up to by tracking
>   * the next item in the list for us. However, for this to be safe, removing an
> @@ -363,7 +395,7 @@ static long
>  xfsaild_push(
>  	struct xfs_ail		*ailp)
>  {
> -	xfs_mount_t		*mp = ailp->ail_mount;
> +	struct xfs_mount	*mp = ailp->ail_mount;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	xfs_lsn_t		lsn;
> @@ -425,6 +457,13 @@ xfsaild_push(
>  			ailp->ail_last_pushed_lsn = lsn;
>  			break;
>  
> +		case XFS_ITEM_RELOG:
> +			trace_xfs_ail_relog(lip);
> +			ASSERT(list_empty(&lip->li_trans));
> +			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
> +			set_bit(XFS_LI_RELOGGED, &lip->li_flags);
> +			break;
> +
>  		case XFS_ITEM_FLUSHING:
>  			/*
>  			 * The item or its backing buffer is already being
> @@ -491,6 +530,9 @@ xfsaild_push(
>  	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
>  		ailp->ail_log_flush++;
>  
> +	if (!list_empty(&ailp->ail_relog_list))
> +		queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
> +

Hmmm. Nothing here appears to guarantee forwards progress of the
relogged items? We just queue the items and move on? What if we scan
the ail and trip over the item again before it's been processed by
the relog worker function?

>  	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
>  out_done:
>  		/*
> @@ -834,15 +876,24 @@ xfs_trans_ail_init(
>  	spin_lock_init(&ailp->ail_lock);
>  	INIT_LIST_HEAD(&ailp->ail_buf_list);
>  	init_waitqueue_head(&ailp->ail_empty);
> +	INIT_LIST_HEAD(&ailp->ail_relog_list);
> +	INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
> +
> +	ailp->ail_relog_wq = alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE, 0,
> +					     mp->m_super->s_id);

It'll need WQ_MEMRECLAIM so it has a rescuer thread (relogging has
to work when we are low on memory), and possibly WQ_HIPRI so that it
doesn't get stuck behind other workqueues that run transactions and
run the log out of space before we try to reserve log space for the
relogging....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
