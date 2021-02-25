Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0141C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D77E64E4D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbhBYIpP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbhBYIpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:45:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18B1C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1PIC041XnMVqtq0EBsb8g+bL2WoYYwaEgBVUeDMvR2M=; b=SrJx02f58fZdKp6C4IPOVO0VUD
        zeQibCNVBsSDr3ymEr/yTli5EunPPHXCcnaguoTfxsX77LLDIubMx303l1mt5SkEk1pa84agx5rAE
        5BU7yVwJVHz6VFtpEmx3wY6Dkw5oD07ybZ/jOUHzovU/4xPYDujqZULGx3HvYXpW7T9qzTK44CL1w
        oDRNzuZYwB9xsZaR2Azqfq08xr0n4M8r4Ht/0kpdZVUWg5cxTDMIRno4szeQFbiv/nL/8zjOiuKxQ
        RP7coTVZ+rCQy2f7789OssmI6ZTR3xK4KN4u7jY7HgELMYvyjMgqh1RfoK33r5N7uRuJXDyJDGoJf
        H1npUyPA==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCFt-00ATqc-Cz; Thu, 25 Feb 2021 08:44:21 +0000
Date:   Thu, 25 Feb 2021 09:42:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: CIL checkpoint flushes caches unconditionally
Message-ID: <YDdi2pgRDJtv5M8P@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks ok, but please make add two trivial checks that the device
actually supports/needs flushes.  All that magic of allocating a bio


On Tue, Feb 23, 2021 at 02:34:39PM +1100, Dave Chinner wrote:
>  	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -719,10 +720,24 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
> -	 * pull all the log vectors off the items in the CIL, and
> -	 * remove the items from the CIL. We don't need the CIL lock
> -	 * here because it's only needed on the transaction commit
> -	 * side which is currently locked out by the flush lock.
> +	 * The CIL is stable at this point - nothing new will be added to it
> +	 * because we hold the flush lock exclusively. Hence we can now issue
> +	 * a cache flush to ensure all the completed metadata in the journal we
> +	 * are about to overwrite is on stable storage.
> +	 *
> +	 * This avoids the need to have the iclogs issue REQ_PREFLUSH based
> +	 * cache flushes to provide this ordering guarantee, and hence for CIL
> +	 * checkpoints that require hundreds or thousands of log writes no
> +	 * longer need to issue device cache flushes to provide metadata
> +	 * writeback ordering.
> +	 */
> +	xfs_flush_bdev_async(log->l_mp->m_ddev_targp->bt_bdev, &bdev_flush);

This still causes a bio allocation, also even if the device does not need
flush.  Please also use bio_init on a bio passed into xfs_flush_bdev_async to
avoid that, and make the whole code conditional to only run if we actually need
to flush caches.
