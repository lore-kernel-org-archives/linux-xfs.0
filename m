Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62973C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154272343B
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbhAMOjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAMOjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 09:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC29C061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 06:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i65N92m55koKxnNdxat9bZXpF4HJWLmZa7gcR+aO/Wo=; b=KKQuCPFoPm2Rl6Mi1bujWbgH1+
        EYFg55Lu7nxxmyF08kuHMpWSv3LY5a6MMa5AKAyAz6XXfiW3BVeCb4D7EtBplT2+FKzxd+nU5VxI+
        Xji3cgvPqWJ4U463lTbMshMdYWsUAToddvFriIZrYpXSEVATF3FoQKd3Ooz615iX4/VS6PFw0/QCe
        YZf/XVCeVU5uWKMocFDkP9ealovPeOFLH03x1ZR/q+7TTTjpOug3yGIrtB04AvewAPMcP4vSTzdTL
        gCzcSYJYncdv8t/kZGy8bGPAMrSycdMr1gCxuEhGz7l/HJqXgPO6XGl6FmzR0HELRbDZ6uNP72tdn
        +eve12zA==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhHb-006MpH-2F; Wed, 13 Jan 2021 14:38:16 +0000
Date:   Wed, 13 Jan 2021 15:37:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: refactor messy xfs_inode_free_quota_* functions
Message-ID: <X/8FxPzcM2OX6ocG@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040736645.1582114.5611056362119068032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040736645.1582114.5611056362119068032.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:22:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The functions to run an eof/cowblocks scan to try to reduce quota usage
> are kind of a mess -- the logic repeatedly initializes an eofb structure
> and there are logic bugs in the code that result in the cowblocks scan
> never actually happening.
> 
> Replace all three functions with a single function that fills out an
> eofb if we're low on quota and runs both eof and cowblocks scans.
> 
> Fixes: 83104d449e8c4 ("xfs: garbage collect old cowextsz reservations")

This just cleans things up and doesn't actually fix any bug, does it?

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5b0f93f73837..5d5cf25668b5 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -652,7 +652,7 @@ xfs_file_buffered_aio_write(
>  	struct inode		*inode = mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
> -	int			enospc = 0;
> +	bool			cleared_space = false;

The variable renaming here looks useful, but unrelated to the rest.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
