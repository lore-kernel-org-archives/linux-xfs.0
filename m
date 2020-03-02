Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B67C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 05:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B76C42468D
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 05:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgCBF6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 00:58:44 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:32875 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgCBF6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 00:58:44 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EDE767E990E;
        Mon,  2 Mar 2020 16:58:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8e69-000721-En; Mon, 02 Mar 2020 16:58:37 +1100
Date:   Mon, 2 Mar 2020 16:58:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 4/9] xfs: automatic relogging item management
Message-ID: <20200302055837.GJ10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227134321.7238-5-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=1ko7waxPol9UnTp3EfwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:43:16AM -0500, Brian Foster wrote:
> As implemented by the previous patch, relogging can be enabled on
> any item via a relog enabled transaction (which holds a reference to
> an active relog ticket). Add a couple log item flags to track relog
> state of an arbitrary log item. The item holds a reference to the
> global relog ticket when relogging is enabled and releases the
> reference when relogging is disabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_trace.h      |  2 ++
>  fs/xfs/xfs_trans.c      | 36 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h      |  6 +++++-
>  fs/xfs/xfs_trans_priv.h |  2 ++
>  4 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a86be7f807ee..a066617ec54d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1063,6 +1063,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> +DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
> +DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
>  
>  DECLARE_EVENT_CLASS(xfs_ail_class,
>  	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8ac05ed8deda..f7f2411ead4e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -778,6 +778,41 @@ xfs_trans_del_item(
>  	list_del_init(&lip->li_trans);
>  }
>  
> +void
> +xfs_trans_relog_item(
> +	struct xfs_log_item	*lip)
> +{
> +	if (!test_and_set_bit(XFS_LI_RELOG, &lip->li_flags)) {
> +		xfs_trans_ail_relog_get(lip->li_mountp);
> +		trace_xfs_relog_item(lip);
> +	}

What if xfs_trans_ail_relog_get() fails to get a reference here
because there is no current ail relog ticket? Isn't the transaction
it was reserved in required to be checked here for XFS_TRANS_RELOG
being set?

> +}
> +
> +void
> +xfs_trans_relog_item_cancel(
> +	struct xfs_log_item	*lip,
> +	bool			drain) /* wait for relogging to cease */
> +{
> +	struct xfs_mount	*mp = lip->li_mountp;
> +
> +	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
> +		return;
> +	xfs_trans_ail_relog_put(lip->li_mountp);
> +	trace_xfs_relog_item_cancel(lip);
> +
> +	if (!drain)
> +		return;
> +
> +	/*
> +	 * Some operations might require relog activity to cease before they can
> +	 * proceed. For example, an operation must wait before including a
> +	 * non-lockable log item (i.e. intent) in another transaction.
> +	 */
> +	while (wait_on_bit_timeout(&lip->li_flags, XFS_LI_RELOGGED,
> +				   TASK_UNINTERRUPTIBLE, HZ))
> +		xfs_log_force(mp, XFS_LOG_SYNC);
> +}

What is a "cancel" operation? Is it something you do when cancelling
a transaction (i.e. on operation failure) or is is something the
final transaction does to remove the relog item from the AIL (i.e.
part of the normal successful finish to a long running transaction)?


>  /* Detach and unlock all of the items in a transaction */
>  static void
>  xfs_trans_free_items(
> @@ -863,6 +898,7 @@ xfs_trans_committed_bulk(
>  
>  		if (aborted)
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> +		clear_and_wake_up_bit(XFS_LI_RELOGGED, &lip->li_flags);

I don't know what the XFS_LI_RELOGGED flag really means in this
patch because I don't know what sets it. Perhaps this would be
better moved into the patch that first sets the RELOGGED flag?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
