Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F82FC4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21615235FD
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="loNk2093"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIWHsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWHsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:48:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50304C061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EC5mY1/bmO1AYprpZoMJQbKxvoqpAqAWmmg2G/BphcE=; b=loNk2093B1dJA4fP5IwShDMvks
        CjZPzeKaK+07zUjL2Sp0V479IgXgk1yAUsdmJBSHsBuVXN6eLwbiwOvERm5+JXk7i/FapFrQ7Azpf
        vMmNZmGMGk5Rt1Fvjv6aObs5qhpFRTGmfZkZsQ/kaGU4G92hARE0CX0rc6ITfKQeH4t143It/d0YY
        1B5zRl4cF1u32SyvB1GylCgoQbqMuYtj+FAAMn5w+iWg9okzy5tyf/0qBfXaH4POUuxiU/PaPQhUD
        ClaNk8Y1gM8R6BTCRSze8e7Z7nrlaHELNVkiO0YUnqt4Jli+zetyFMQSsHhoZnyt0UUm5FFX+cqBa
        rrXo054Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKzVg-0001JR-LK; Wed, 23 Sep 2020 07:48:16 +0000
Date:   Wed, 23 Sep 2020 08:48:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200923074816.GA31918@infradead.org>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031334683.3624461.7162765986332930241.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031334683.3624461.7162765986332930241.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:29:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we replay unfinished intent items that have been recovered from the
> log, it's possible that the replay will cause the creation of more
> deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> recovery should replay deferred ops in order"), later work items have an
> implicit ordering dependency on earlier work items.  Therefore, recovery
> must replay the items (both recovered and created) in the same order
> that they would have been during normal operation.
> 
> For log recovery, we enforce this ordering by using an empty transaction
> to collect deferred ops that get created in the process of recovering a
> log intent item to prevent them from being committed before the rest of
> the recovered intent items.  After we finish committing all the
> recovered log items, we allocate a transaction with an enormous block
> reservation, splice our huge list of created deferred ops into that
> transaction, and commit it, thereby finishing all those ops.
> 
> This is /really/ hokey -- it's the one place in XFS where we allow
> nested transactions; the splicing of the defer ops list is is inelegant
> and has to be done twice per recovery function; and the broken way we
> handle inode pointers and block reservations cause subtle use-after-free
> and allocator problems that will be fixed by this patch and the two
> patches after it.
> 
> Therefore, replace the hokey empty transaction with a structure designed
> to capture each chain of deferred ops that are created as part of
> recovering a single unfinished log intent.  Finally, refactor the loop
> that replays those chains to do so using one transaction per chain.

Wow, that is a massive change, but I really like the direction.


> +int
>  xfs_defer_capture(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_capture	**dfcp)
>  {
> +	struct xfs_defer_capture	*dfc = NULL;
> +
> +	if (!list_empty(&tp->t_dfops)) {
> +		dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
> +
> +		xfs_defer_create_intents(tp);
> +
> +		INIT_LIST_HEAD(&dfc->dfc_list);
> +		INIT_LIST_HEAD(&dfc->dfc_dfops);
> +
> +		/* Move the dfops chain and transaction state to the freezer. */
> +		list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
> +		dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
> +		xfs_defer_reset(tp);
> +	}
> +
> +	*dfcp = dfc;
> +	return xfs_trans_commit(tp);

Don't we need to free the structure if xfs_trans_commit fails?

Wouldn't a saner calling convention would to pass the list_head into
->iop_recover and this function, and just add it to the list here
instead of passing it around as an output pointer argument.

> +/*
> + * Freeze any deferred ops and commit the transaction.  This is the last step
> + * needed to finish a log intent item that we recovered from the log.
> + */
> +int
> +xlog_recover_trans_commit(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_capture	**dfcp)
> +{
> +	return xfs_defer_capture(tp, dfcp);
> +}

I don't think this wrapper is very helpful.  I think a direct call
to xfs_defer_capture captures the intent better than pretending it just
is another commit.

> +
>  /* Take all the collected deferred ops and finish them in order. */
>  static int
>  xlog_finish_defer_ops(
> +	struct xfs_mount	*mp,
> +	struct list_head	*dfops_freezers)
>  {
> +	struct xfs_defer_capture *dfc, *next;
>  	struct xfs_trans	*tp;
>  	int64_t			freeblks;
> +	uint64_t		resblks;
> +	int			error = 0;
>  
> +	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
> +		/*
> +		 * We're finishing the defer_ops that accumulated as a result
> +		 * of recovering unfinished intent items during log recovery.
> +		 * We reserve an itruncate transaction because it is the
> +		 * largest permanent transaction type.  Since we're the only
> +		 * user of the fs right now, take 93% (15/16) of the available
> +		 * free blocks.  Use weird math to avoid a 64-bit division.
> +		 */
> +		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> +		if (freeblks <= 0) {
> +			error = -ENOSPC;
> +			break;
> +		}
>  
> +		resblks = min_t(uint64_t, UINT_MAX, freeblks);
> +		resblks = (resblks * 15) >> 4;
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> +				0, XFS_TRANS_RESERVE, &tp);

This isn't actually new, but how did we end up with the truncate
reservation here?

> +		if (error)
> +			break;
> +
> +		/* transfer all collected dfops to this transaction */
> +		list_del_init(&dfc->dfc_list);
> +		xfs_defer_continue(dfc, tp);
> +
> +		error = xfs_trans_commit(tp);
> +		xfs_defer_capture_free(mp, dfc);
> +		if (error)
> +			break;

I'd just do direct returns and return 0 outside the loop, but that is
just nitpicking.

>  /* Is this log item a deferred action intent? */
> @@ -2528,28 +2566,16 @@ STATIC int
>  xlog_recover_process_intents(
>  	struct xlog		*log)
>  {
> +	LIST_HEAD(dfops_freezers);
>  	struct xfs_ail_cursor	cur;
> +	struct xfs_defer_capture *freezer = NULL;
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
> +	int			error = 0;
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	xfs_lsn_t		last_lsn;
>  #endif
>  
>  	ailp = log->l_ailp;
>  	spin_lock(&ailp->ail_lock);
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> @@ -2578,26 +2604,31 @@ xlog_recover_process_intents(
>  
>  		/*
>  		 * NOTE: If your intent processing routine can create more
> +		 * deferred ops, you /must/ attach them to the freezer in
>  		 * this routine or else those subsequent intents will get
>  		 * replayed in the wrong order!
>  		 */
>  		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
>  			spin_unlock(&ailp->ail_lock);
> +			error = lip->li_ops->iop_recover(lip, &freezer);
>  			spin_lock(&ailp->ail_lock);
>  		}
> +		if (freezer) {
> +			list_add_tail(&freezer->dfc_list, &dfops_freezers);
> +			freezer = NULL;
> +		}
>  		if (error)
> +			break;
> +
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);

The code flow looks really very odd (though correct) to me, what do you
think of something like:

  	spin_lock(&ailp->ail_lock);
	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
	     lip;
	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
			continue;

		spin_unlock(&ailp->ail_lock);
		error = lip->li_ops->iop_recover(lip, &dfops_freezers);
		spin_lock(&ailp->ail_lock);
		if (error)
			break;
	}
  	xfs_trans_ail_cursor_done(&cur);
  	spin_unlock(&ailp->ail_lock);
