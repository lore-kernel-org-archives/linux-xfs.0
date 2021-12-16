Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29A3C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 04:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhLPEgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 23:36:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54593 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233525AbhLPEgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 23:36:10 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C189D10A482A;
        Thu, 16 Dec 2021 15:36:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxiUx-003dAG-IR; Thu, 16 Dec 2021 15:36:07 +1100
Date:   Thu, 16 Dec 2021 15:36:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: prevent UAF in xfs_log_item_in_current_chkpt
Message-ID: <20211216043607.GW449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961697749.3129691.10072192517670663885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961697749.3129691.10072192517670663885.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61bac238
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=NVHcf84rL-_35JxVOOUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:37PM -0800, Darrick J. Wong wrote:
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
> 

I see the problem, but I don't think this is the right way to fix
it.  The CIL context lock is already a major contention point in the
transaction commit code when it is only taken once per
xfs_trans_commit() call.  If we now potentially take it once per
intent item per xfs_trans_commit() call, we're going to make the
contention even worse than it already is.

The current sequence is always available from the CIL itself via
cil->xc_current_sequence, and we can read that without needing any
locking to provide existence guarantees of the CIL structure.

So....

bool
xfs_log_item_in_current_chkpt(
	struct xfs_log_item *lip)
{
	struct xfs_cil	*cil = lip->li_mountp->m_log->l_cilp;

	if (list_empty(&lip->li_cil))
		return false;

	/*
	 * li_seq is written on the first commit of a log item to record the
	 * first checkpoint it is written to. Hence if it is different to the
	 * current sequence, we're in a new checkpoint.
	 */
	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
