Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49979C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 16:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhLPQfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 11:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhLPQfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 11:35:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E25CC061574
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 08:35:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0965861EA7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 16:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60892C36AE5;
        Thu, 16 Dec 2021 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639672532;
        bh=eEOW7SWW2OEXh00B9oTL4JMwRwvmq8AhuXsF362Fk1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sKEvwPjZElMlAVLQtYn5zOU9U9V+kOb8utzS6gXqv5N85GzxPgZI/AV2D/1A+Rl4P
         8vY7He6eJdnsv6CBX2UXezpw98ei3futh5YTZwM+U04IpjLJrA6dvvEWb5R/ta+8GX
         /MTyv9CBvA0a7panDtIjh+KMrQ7Pas0nR6OUOzNF2RBEEp0vpFitI1/prsOEK9T6qr
         Dc6vvuSCFN+9+IXrmVxsz4R0CMidYuksluttZFSqlE4TuKUhkpzeSByGuzUrOu/2BQ
         PlkoqkoD0KOFVARmJruXtXt5kkvzwqaLOty0C70+zFW5Vivg62ECPmi1hDSb3ogfzi
         Y2tpq/bHI3DAQ==
Date:   Thu, 16 Dec 2021 08:35:31 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: prevent UAF in xfs_log_item_in_current_chkpt
Message-ID: <20211216163531.GB27664@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961697749.3129691.10072192517670663885.stgit@magnolia>
 <20211216043607.GW449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216043607.GW449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 16, 2021 at 03:36:07PM +1100, Dave Chinner wrote:
> On Wed, Dec 15, 2021 at 05:09:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While I was running with KASAN and lockdep enabled, I stumbled upon an
> > KASAN report about a UAF to a freed CIL checkpoint.  Looking at the
> > comment for xfs_log_item_in_current_chkpt, it seems pretty obvious to me
> > that the original patch to xfs_defer_finish_noroll should have done
> > something to lock the CIL to prevent it from switching the CIL contexts
> > while the predicate runs.
> > 
> > For upper level code that needs to know if a given log item is new
> > enough not to need relogging, add a new wrapper that takes the CIL
> > context lock long enough to sample the current CIL context.  This is
> > kind of racy in that the CIL can switch the contexts immediately after
> > sampling, but that's ok because the consequence is that the defer ops
> > code is a little slow to relog items.
> > 
> 
> I see the problem, but I don't think this is the right way to fix
> it.  The CIL context lock is already a major contention point in the
> transaction commit code when it is only taken once per
> xfs_trans_commit() call.  If we now potentially take it once per
> intent item per xfs_trans_commit() call, we're going to make the
> contention even worse than it already is.
> 
> The current sequence is always available from the CIL itself via
> cil->xc_current_sequence, and we can read that without needing any
> locking to provide existence guarantees of the CIL structure.
> 
> So....
> 
> bool
> xfs_log_item_in_current_chkpt(
> 	struct xfs_log_item *lip)
> {
> 	struct xfs_cil	*cil = lip->li_mountp->m_log->l_cilp;
> 
> 	if (list_empty(&lip->li_cil))
> 		return false;
> 
> 	/*
> 	 * li_seq is written on the first commit of a log item to record the
> 	 * first checkpoint it is written to. Hence if it is different to the
> 	 * current sequence, we're in a new checkpoint.
> 	 */
> 	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);

Ooh, much better!

--D

> }
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
