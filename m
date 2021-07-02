Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F63C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D31261413
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGBIvS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhGBIvR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:51:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A33DC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wC5Rm1efVeX9eiwCBIKel5oM6QI1mTyE4EDGtlJoDL4=; b=A7/xJcCYOZTkUA3JNtE29iSYgG
        p7T1Yr266IN5SUQBcdc3/KxuShgv/m2/p3qW35ppewmL7wBOo190cQdDvkYVLIO0Trfz+A1thGpVi
        kwkmdjj+uU+sO9f8528U336vFmpsy3DhhFTG9/bK/Xfp204HW/GJRr5Co3BYqoWHiz1L2w+AHA4H6
        sRbt/scWUCQptzuInUoH5mBMp3vWfJjhCboVi/lsm8atjx8MuELm74x6MoPu+/uXdtZRksSdo96rJ
        xyI8qQL8WVFzLsUM63xg1fruzuxnUu2RPzvegv3ijUQdyxKjHLB+KA0Cx4wydpzj+oYGmRszMk+l5
        Zn41MzvA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEqV-007WtW-BT; Fri, 02 Jul 2021 08:48:30 +0000
Date:   Fri, 2 Jul 2021 09:48:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: don't run shutdown callbacks on active iclogs
Message-ID: <YN7S1/ZAd4IwP8aE@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 04:38:12PM +1000, Dave Chinner wrote:
> The problem is that xlog_state_release_iclog() aborts before doing
> anything if the log is already shut down. It assumes that the
> callbacks have already been cleaned up, and it doesn't need to do
> any cleanup.
> 
> Hence the fix is to remove the xlog_is_shutdown() check from
> xlog_state_release_iclog() so that reference counts are correctly
> released from the iclogs, and when the reference count is zero we
> always transition to SYNCING if the log is shut down. Hence we'll
> always enter the xlog_sync() path in a shutdown and eventually end
> up erroring out the iclog IO and running xlog_state_do_callback() to
> process the callbacks attached to the iclog.

Ok, this answers my question to the previous patch.  Maybe add a little
blurb there?

> +	if (xlog_is_shutdown(log)) {
> +		/*
> +		 * No more references to this iclog, so process the pending
> +		 * iclog callbacks that were waiting on the release of this
> +		 * iclog.
> +		 */
> +		spin_unlock(&log->l_icloglock);
> +		xlog_state_shutdown_callbacks(log);
> +		spin_lock(&log->l_icloglock);
> +	} else if (xlog_state_want_sync(log, iclog)) {
>  		spin_unlock(&log->l_icloglock);
>  		xlog_sync(log, iclog);
>  		spin_lock(&log->l_icloglock);

>  
> +out_check_shutdown:
> +	if (xlog_is_shutdown(log))
> +		return -EIO;
>  	return 0;

Nit: we can just return -EIO directly in the first xlog_is_shutdown
block..  It's not going to make any difference for the CPU, but makes
the code a little easier to follow.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
