Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2478C4727E
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 06:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A3C21941
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 06:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgI1GhU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 02:37:20 -0400
Received: from verein.lst.de ([213.95.11.211]:34397 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgI1GhU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 02:37:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7542467373; Mon, 28 Sep 2020 08:37:17 +0200 (CEST)
Date:   Mon, 28 Sep 2020 08:37:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: proper replay of deferred ops queued during
 log recovery
Message-ID: <20200928063717.GB15425@lst.de>
References: <160125006793.174438.10683462598722457550.stgit@magnolia> <160125008079.174438.4841984502957067911.stgit@magnolia> <20200928052618.GD14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928052618.GD14422@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 03:26:18PM +1000, Dave Chinner wrote:
> > +	struct xfs_mount		*mp = tp->t_mountp;
> > +	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
> > +	int				error;
> > +
> > +	/* If we don't capture anything, commit tp and exit. */
> > +	if (!dfc)
> > +		return xfs_trans_commit(tp);
> > +
> > +	/*
> > +	 * Commit the transaction.  If that fails, clean up the defer ops and
> > +	 * the dfc that we just created.  Otherwise, add the dfc to the list.
> > +	 */
> > +	error = xfs_trans_commit(tp);
> > +	if (error) {
> > +		xfs_defer_capture_free(mp, dfc);
> > +		return error;
> > +	}
> > +
> > +	list_add_tail(&dfc->dfc_list, capture_list);
> > +	return 0;
> > +}
> 
> And, really, this is more than a "transaction commit" operation; it
> doesn't have anything recovery specific to it, so if the
> xfs_defer_capture() API is "generic xfs_defer" functionality, why
> isn't this placed next to it and nameed
> xfs_defer_capture_and_commit()?

Agreed.  I find the xlog_recover_trans_commit naming pretty weird.

> > @@ -2533,28 +2577,28 @@ xlog_recover_process_intents(
> >  		 */
> >  		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
> >  
> > +		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
> > +			continue;
> > +
> 
> Why do we still need XFS_LI_RECOVERED here? This log item is going to get
> removed from the AIL by the committing of the first transaction
> in the ->iop_recover() sequence we are running, so we'll never find
> it again in the AIL. Nothing else checks for XFS_LI_RECOVERED
> anymore, so this seems unnecessary now...

We also never restart the list walk as far as I can tell.  So yes,
XFS_LI_RECOVERED seems entirely superflous and should probably be
removed in a prep patch.

> > -out:
> > +
> >  	xfs_trans_ail_cursor_done(&cur);
> >  	spin_unlock(&ailp->ail_lock);
> >  	if (!error)
> > -		error = xlog_finish_defer_ops(parent_tp);
> > -	xfs_trans_cancel(parent_tp);
> > +		error = xlog_finish_defer_ops(log->l_mp, &capture_list);
> >  
> > +	xlog_cancel_defer_ops(log->l_mp, &capture_list);
> >  	return error;
> >  }
> 
> Again, why are we cancelling the capture list if we just
> successfully processed the defer ops on the capture list?

Yes, we'll probably just want to assert it is non-empty at the end of
xlog_finish_defer_ops.
