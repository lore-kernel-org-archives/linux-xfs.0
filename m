Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6040C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Dec 2021 03:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbhLVDqq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Dec 2021 22:46:46 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37600 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhLVDqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Dec 2021 22:46:45 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D73738A62EC;
        Wed, 22 Dec 2021 14:46:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mzsaQ-005yrY-FC; Wed, 22 Dec 2021 14:46:42 +1100
Date:   Wed, 22 Dec 2021 14:46:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: prevent UAF in xfs_log_item_in_current_chkpt
Message-ID: <20211222034642.GD945095@dread.disaster.area>
References: <20211217174500.GI27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217174500.GI27664@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61c29fa4
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=YfZ6WuxZou2Z4fkI1OwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 09:45:00AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While I was running with KASAN and lockdep enabled, I stumbled upon an
> KASAN report about a UAF to a freed CIL checkpoint.  Looking at the
> comment for xfs_log_item_in_current_chkpt, it seems pretty obvious to me
> that the original patch to xfs_defer_finish_noroll should have done
> something to lock the CIL to prevent it from switching the CIL contexts
> while the predicate runs.
> 
> For upper level code that needs to know if a given log item is new
> enough not to need relogging, add a new wrapper that takes the CIL
> context lock long enough to sample the current CIL context.  This is
> kind of racy in that the CIL can switch the contexts immediately after
> sampling, but that's ok because the consequence is that the defer ops
> code is a little slow to relog items.
....
> 
> Fixes: 4e919af7827a ("xfs: periodically relog deferred intent items")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: use READ_ONCE on CIL instead of taking locks to get cil ctx
> ---
>  fs/xfs/xfs_log_cil.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 6c93c8ada6f3..b59cc9c0961c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1442,9 +1442,9 @@ xlog_cil_force_seq(
>   */
>  bool
>  xfs_log_item_in_current_chkpt(
> -	struct xfs_log_item *lip)
> +	struct xfs_log_item	*lip)
>  {
> -	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
> +	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
>  
>  	if (list_empty(&lip->li_cil))
>  		return false;
> @@ -1454,7 +1454,7 @@ xfs_log_item_in_current_chkpt(
>  	 * first checkpoint it is written to. Hence if it is different to the
>  	 * current sequence, we're in a new checkpoint.
>  	 */
> -	return lip->li_seq == ctx->sequence;
> +	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
>  }

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
