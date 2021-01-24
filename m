Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B10C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE3A22ADC
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbhAXJtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXJtE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:49:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA84C061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MZq41eXZABYeP36UGtLp0mtksjWFqi0Mm1gABx236gI=; b=pXzbnlBnDDV9MqYUTAlQ5aelHH
        nRKoXa2X0lOoJR6QxnBcCwcKFK5fk75XGobfIKGuDBjy9qofB2cHuf8B84vrPjTvZG7YEGwYHNc3+
        uwNrvNIKPRfbUzBOr0aKkgfXk5ZfqEakk3r0zbQvle4ibwbvuCRp71r3NkC/s7OmD6nezUganYXtI
        pLObUCE2frfD8frdvE3+L9V5Brm3tvrca+8onJqIH2tQBfoQjhVyIM+JTKLTJoVIWRuyVHQWODEyO
        6vaJtz2bqhd2YrycO0+pNo3vC4vvzD6VqmY7fP8cV76Qob/cL2BzFKe5cuOT7E4ooYVU/jTR6gMK8
        FnGzenxw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3c0G-002pFm-Ha; Sun, 24 Jan 2021 09:48:20 +0000
Date:   Sun, 24 Jan 2021 09:48:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210124094816.GE670331@infradead.org>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142798066.2171939.9311024588681972086.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +retry:
>  	/*
>  	 * Allocate the handle before we do our freeze accounting and setting up
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> @@ -285,6 +289,22 @@ xfs_trans_alloc(
>  	tp->t_firstblock = NULLFSBLOCK;
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> +	if (error == -ENOSPC && tries > 0) {
> +		xfs_trans_cancel(tp);
> +
> +		/*
> +		 * We weren't able to reserve enough space for the transaction.
> +		 * Flush the other speculative space allocations to free space.
> +		 * Do not perform a synchronous scan because callers can hold
> +		 * other locks.
> +		 */
> +		error = xfs_blockgc_free_space(mp, NULL);
> +		if (error)
> +			return error;
> +
> +		tries--;
> +		goto retry;
> +	}
>  	if (error) {
>  		xfs_trans_cancel(tp);
>  		return error;

Why do we need to restart the whole function?  A failing
xfs_trans_reserve should restore tp to its initial state, and keeping
the SB_FREEZE_FS counter increased also doesn't look harmful as far as
I can tell.  So why not:

	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
	if (error == -ENOSPC) {
		/*
		 * We weren't able to reserve enough space for the transaction.
		 * Flush the other speculative space allocations to free space.
		 * Do not perform a synchronous scan because callers can hold
		 * other locks.
		 */
		error = xfs_blockgc_free_space(mp, NULL);
		if (error)
			return error;
		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
	}
 	if (error) {
  		xfs_trans_cancel(tp);
  		return error;

?
