Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24080C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEAF6610FC
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhDBHHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhDBHHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 03:07:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63E8C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 00:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IDPiEhtEHY1DdAzGFq56oJu2G3BzShlMDmRCMTj7jTI=; b=hW5NOB8dLmKwvubII3KbXzEpPx
        6oibhtCAmE1e0QJDnZYYqaApelGalvR+pg4ehsyx7w70T7cGitt9dKWT1EO+izAzY2jPT47u5nHNl
        vDclvPA4iE0xD0yA7MmAA1pQ+0bB6mnouaPDTsBnAxGwomMHsYKnGKVsf8iBPLJDqsd6If2/w/YZD
        LfT04N74aBBROOPe3FtzAK+FZMrn5r8TSIwmaJ2jCtv46ayL0TCkvG8TAtvFTPlauIYWollzdd0PU
        rVNUPWMskl791jE/Cdlj7rA9qZ84IlLGSr9YvRj77NZDMjbA0LZE07JmGtPy1e+8Z0UchLE8gfH7v
        VbXzj67Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDtS-007JvD-Sr; Fri, 02 Apr 2021 07:07:05 +0000
Date:   Fri, 2 Apr 2021 08:06:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210402070658.GG1739516@infradead.org>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:57PM +1100, Dave Chinner wrote:
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -292,6 +292,15 @@ xfs_ifork_alloc(
>  	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
>  	ifp->if_format = format;
>  	ifp->if_nextents = nextents;
> +
> +	/*
> +	 * If this is a caller initialising a newly created fork, we need to
> +	 * set XFS_IFEXTENTS to indicate the fork state is completely up to
> +	 * date. Otherwise it is up to the caller to initialise the in-memory
> +	 * state of the inode fork from the on-disk state.
> +	 */
> +	if (format == XFS_DINODE_FMT_EXTENTS && nextents == 0)
> +		ifp->if_flags |= XFS_IFEXTENTS;
>  	return ifp;

I'm not sure this is a good idea.  I'd rather set XFS_IFEXTENTS manually
in xfs_init_new_inode until we sort out the whole flags thing.
