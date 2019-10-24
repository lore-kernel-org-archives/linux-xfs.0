Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EC6CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 22:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C42B21BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 22:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfJXWnO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 18:43:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42595 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbfJXWnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 18:43:14 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EBAEF363A6C;
        Fri, 25 Oct 2019 09:43:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iNloy-0006kF-F8; Fri, 25 Oct 2019 09:43:08 +1100
Date:   Fri, 25 Oct 2019 09:43:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: automatic log item relogging experiment
Message-ID: <20191024224308.GD4614@dread.disaster.area>
References: <20191024172850.7698-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024172850.7698-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=eJfxgxciAAAA:8 a=7-415B0cAAAA:8
        a=oA2jwj3hEAKrBop-0WYA:9 a=jqgrwSNKIsSY4bJC:21 a=PvKXyZcw2UeU4OcH:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xM9caqqi1sUkTy8OJ5Uh:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 01:28:50PM -0400, Brian Foster wrote:
> An experimental mechanism to automatically relog specified log
> items.  This is useful for long running operations, like quotaoff,
> that otherwise risk deadlocking on log space usage.
> 
> Not-signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This is an experiment that came out of a discussion with Darrick[1] on
> some design bits of the latest online btree repair work. Specifically,
> it logs free intents in the same transaction as block allocation to
> guard against inconsistency in the event of a crash during the repair
> sequence. These intents happen pin the log tail for an indeterminate
> amount of time. Darrick was looking for some form of auto relog
> mechanism to facilitate this general approach. It occurred to us that
> this is the same problem we've had with quotaoff for some time, so I
> figured it might be worth prototyping something against that to try and
> prove the concept.

Interesting idea. :)

> 
> Note that this is RFC because the code and interfaces are a complete
> mess and this is broken in certain ways. This occasionally triggers log
> reservation overrun shutdowns because transaction reservation checking
> has not yet been added, the cancellation path is overkill, etc. IOW, the
> purpose of this patch is purely to test a concept.

*nod*

> The concept is essentially to flag a log item for relogging on first
> transaction commit such that once it commits to the AIL, the next
> transaction that happens to commit with sufficient unused reservation
> opportunistically relogs the item to the current CIL context. For the
> log intent case, the transaction that commits the done item is required
> to cancel the relog state of the original intent to prevent further
> relogging.

Makes sense, but it seems like we removed the hook that would be
used by transactions to implement their own relogging on CIL commit
some time ago because nothign had used it for 15+ years....

> In practice, this allows a log item to automatically roll through CIL
> checkpoints and not pin the tail of the log while something like a
> quotaoff is running for a potentially long period of time. This is
> applied to quotaoff and focused testing shows that it avoids the
> associated deadlock.

Hmmm. How do we deal with multiple identical intents being found in
checkpoints with different LSNs in log recovery?

> Thoughts, reviews, flames appreciated.
> 
> [1] https://lore.kernel.org/linux-xfs/20191018143856.GA25763@bfoster/
> 
>  fs/xfs/xfs_log_cil.c     | 69 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_priv.h    |  6 ++++
>  fs/xfs/xfs_qm_syscalls.c | 13 ++++++++
>  fs/xfs/xfs_trace.h       |  2 ++
>  fs/xfs/xfs_trans.c       |  4 +++
>  fs/xfs/xfs_trans.h       |  4 ++-
>  6 files changed, 97 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index a1204424a938..b2d8b2d54df6 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -75,6 +75,33 @@ xlog_cil_iovec_space(
>  			sizeof(uint64_t));
>  }
>  
> +static void
> +xlog_cil_relog_items(
> +	struct xlog		*log,
> +	struct xfs_trans	*tp)
> +{
> +	struct xfs_cil		*cil = log->l_cilp;
> +	struct xfs_log_item	*lip;
> +
> +	ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
> +
> +	if (list_empty(&cil->xc_relog))
> +		return;
> +
> +	/* XXX: need to check trans reservation, process multiple items, etc. */
> +	spin_lock(&cil->xc_relog_lock);
> +	lip = list_first_entry_or_null(&cil->xc_relog, struct xfs_log_item, li_cil);
> +	if (lip)
> +		list_del_init(&lip->li_cil);
> +	spin_unlock(&cil->xc_relog_lock);
> +
> +	if (lip) {
> +		xfs_trans_add_item(tp, lip);
> +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +		trace_xfs_cil_relog(lip);
> +	}

I don't think this is safe - the log item needs to be locked to be
joined to a transaction. Hence this can race with whatever is
committing the done intent on the object and removing it from the
relog list and so the item could be clean (and potentially even
freed) by the time we go to add it to this transaction and mark it
dirty again...

> +}
> +
>  /*
>   * Allocate or pin log vector buffers for CIL insertion.
>   *
> @@ -1001,6 +1028,8 @@ xfs_log_commit_cil(
>  	struct xfs_log_item	*lip, *next;
>  	xfs_lsn_t		xc_commit_lsn;
>  
> +	xlog_cil_relog_items(log, tp);

Hmmm. This means that when there are relog items on the list, all
the transactional concurrency is going to be put onto the
xc_relog_lock spin lock. THis is potentially a major lock contention
point, especially if there are lots of items that need relogging.

> +
>  	/*
>  	 * Do all necessary memory allocation before we lock the CIL.
>  	 * This ensures the allocation does not deadlock with a CIL
> @@ -1196,6 +1225,8 @@ xlog_cil_init(
>  	spin_lock_init(&cil->xc_push_lock);
>  	init_rwsem(&cil->xc_ctx_lock);
>  	init_waitqueue_head(&cil->xc_commit_wait);
> +	INIT_LIST_HEAD(&cil->xc_relog);
> +	spin_lock_init(&cil->xc_relog_lock);
>  
>  	INIT_LIST_HEAD(&ctx->committing);
>  	INIT_LIST_HEAD(&ctx->busy_extents);
> @@ -1223,3 +1254,41 @@ xlog_cil_destroy(
>  	kmem_free(log->l_cilp);
>  }
>  
> +void
> +xfs_cil_relog_item(
> +	struct xlog		*log,
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_cil		*cil = log->l_cilp;
> +
> +	ASSERT(test_bit(XFS_LI_RELOG, &lip->li_flags));
> +	ASSERT(list_empty(&lip->li_cil));

So this can't be used for things like inodes and buffers?

> +	spin_lock(&cil->xc_relog_lock);
> +	list_add_tail(&lip->li_cil, &cil->xc_relog);
> +	spin_unlock(&cil->xc_relog_lock);
> +
> +	trace_xfs_cil_relog_queue(lip);
> +}
> +
> +bool
> +xfs_cil_relog_steal(
> +	struct xlog		*log,
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_cil		*cil = log->l_cilp;
> +	struct xfs_log_item	*pos, *ppos;
> +	bool			ret = false;
> +
> +	spin_lock(&cil->xc_relog_lock);
> +	list_for_each_entry_safe(pos, ppos, &cil->xc_relog, li_cil) {
> +		if (pos == lip) {
> +			list_del_init(&pos->li_cil);
> +			ret = true;
> +			break;
> +		}
> +	}
> +	spin_unlock(&cil->xc_relog_lock);

This is a remove operation, not a "steal" operation. But why are
we walking the relog list to find it? It would be much better to use
a flag to indicate what list the item is on, and then this just
becomes

	spin_lock(&cil->xc_relog_lock);
	if (test_and_clear_bit(XFS_LI_RELOG_LIST, &lip->li_flags))
		list_del_init(&pos->li_cil);
	spin_unlock(&cil->xc_relog_lock);



> @@ -556,6 +558,16 @@ xfs_qm_log_quotaoff_end(
>  					flags & XFS_ALL_QUOTA_ACCT);
>  	xfs_trans_log_quotaoff_item(tp, qoffi);
>  
> +	/*
> +	 * XXX: partly open coded relog of the start item to ensure no relogging
> +	 * after this point.
> +	 */
> +	clear_bit(XFS_LI_RELOG, &startqoff->qql_item.li_flags);
> +	if (xfs_cil_relog_steal(mp->m_log, &startqoff->qql_item)) {
> +		xfs_trans_add_item(tp, &startqoff->qql_item);
> +		xfs_trans_log_quotaoff_item(tp, startqoff);
> +	}

Urk. :)

> @@ -863,6 +864,9 @@ xfs_trans_committed_bulk(
>  		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
>  			continue;
>  
> +		if (test_bit(XFS_LI_RELOG, &lip->li_flags))
> +			xfs_cil_relog_item(lip->li_mountp->m_log, lip);

Ok, so this is moving the item from commit back onto the relog list.
This is going to hammer the relog lock on workloads where there is a
lot of transaction concurrency and a substantial number of items on
the relog list....

----

Ok, so I mentioned that we removed the hooks that could have been
used for this some time ago.

What we actually want here is a notification that an object needs
relogging. I can see how appealing the concept of automatically
relogging is, but I'm unconvinced that we can make it work,
especially when there aren't sufficient reservations to relog
the items that need relogging.

commit d420e5c810bce5debce0238021b410d0ef99cf08
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:53 2013 +1100

    xfs: remove unused transaction callback variables
    
    We don't do callbacks at transaction commit time, no do we have any
    infrastructure to set up or run such callbacks, so remove the
    variables and typedefs for these operations. If we ever need to add
    callbacks, we can reintroduce the variables at that time.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 09cf40b89e8c..71c835e9e810 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -85,18 +85,11 @@ struct xfs_item_ops {
 #define XFS_ITEM_LOCKED                2
 #define XFS_ITEM_FLUSHING      3
 
-/*
- * This is the type of function which can be given to xfs_trans_callback()
- * to be called upon the transaction's commit to disk.
- */
-typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
-
 /*
  * This is the structure maintained for every active transaction.
  */
 typedef struct xfs_trans {
        unsigned int            t_magic;        /* magic number */
-       xfs_log_callback_t      t_logcb;        /* log callback struct */
        unsigned int            t_type;         /* transaction type */
        unsigned int            t_log_res;      /* amt of log space resvd */
        unsigned int            t_log_count;    /* count for perm log res */

That's basically the functionality we want here - when the log item
hits the journal, we want a callback to tell us so we can relog it
ourselves if deemed necessary. i.e. it's time to reintroduce the
transaction/log commit callback infrastructure...

This would get used in conjunction with a permanent transaction
reservation, allowing the owner of the object to keep it locked over
transaction commit (while whatever work is running between intent
and done), and the transaction commit turns into a trans_roll. Then
we reserve space for the next relogging commit, and go about our
business.

On notification of the intent being logged, the relogging work
(which already has a transaction and a reservation) can be dumped to
a workqueue (to get it out of iclog completion context) and the item
relogged and the transaction rolled and re-reserved again.

This would work with any type of log item, not just intents, and it
doesn't have any reservation "stealing" requirements. ANd because
we've pre-reserved the log space for the relogging transaction, the
relogging callback will never get hung up on it's own items
preventing it from getting more log space.

i.e. we essentially make use of the existing relogging mechanism,
just with callbacks to trigger periodic relogging of the items for
long running transactions...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
