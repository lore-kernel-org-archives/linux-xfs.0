Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D21AC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58564610FC
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhDBHD3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhDBHD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 03:03:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD911C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 00:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y11eJ805n7XHbpaFdgZ70I2dO9vPNi6nJOxFmEQ4VIc=; b=AFf8v1RBqFZ1AKai8xvPz+8jKj
        g5BOpc04ehuIddpViv07OUbnVYYgCOGNwz7Gu3V9hNeV6CaUMlAXhdkbuDo6LEB/0OJVIND3h6SVt
        EP5xEI9BgcbZpNMqrtF/GAE4OZWd+Ha+yj3WaoEOgIwOgI7Z8GLtZ8szooaRcWfeHdrza2irmcoBy
        oXQ9g4/InUSJFKEvk+xxzyZnnzhjz2dI0rhYuOE5Y/wh8NH4u1F6fxmS0Yi0mypVkyQp0Tj/ZHCw2
        FXsvlYh9dnXu2UQB1SH+KBFA0lG3BHv+e7F/r48/JMJ7/6eVL6sQPC+qiqFjxtx1OeQR5RGK+P+z6
        v6h53/VQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDpF-007Jby-JU; Fri, 02 Apr 2021 07:02:53 +0000
Date:   Fri, 2 Apr 2021 08:02:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210402070237.GF1739516@infradead.org>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-3-david@fromorbit.com>
 <20210330180617.GR4090233@magnolia>
 <20210330214007.GU63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330214007.GU63242@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 08:40:07AM +1100, Dave Chinner wrote:
> ifp->if_flags is set to XFS_IFINLINE for local format forks,
> XFS_IFEXTENTS for extent format forks, and XFS_IFBROOT for btree
> roots in the inode fork.

No.  All the above are flags, not alternatives.  (and reading futher
you actually properly document it below).

> The problem is that we've overloaded XFS_IFEXTENTS to -also- mean
> "extents loaded in memory".

I would not call this an overload.  It is a somewhat quirky encoding
that actually works pretty well for the use case.

> What we used to have is another flag - XFS_IFEXTIREC - to indicate
> that the XFS_IFBROOT format root was read into the incore memory
> tree. This was removed in commit 6bdcf26ade88 ("xfs: use a b+tree
> for the in-core extent list") when the btree was added for both
> extent format and btree format forks, and it's use to indicate that
> the btree had been read was replaced with the XFS_IFEXTENTS flag.
> 
> That's when XFS_IFEXTENTS gained it's dual meaning.

No. The XFS_IFEXTENTS meaning did not change at all in that commit.
Even before a lot of code looked at XFS_IFEXTENTS and if it wasn't
set called xfs_iread_extents, XFS_IFEXTIREC was only used internally
for the in-memory indirection array and was completely unrelated to the
on-disk format.

> - XFS_IFINLINE means inode fork data is inode type specific data
> - XFS_IFEXTENTS means the inode fork data is in extent format and
>   that the in-core extent btree has been populated
> - XFS_IFBROOT means the inode fork data is a btree root
> - XFS_IFBROOT|XFS_IFEXTENTS mean the inode data fork is a btree root
>   and that the in-core extent btree has been populated
> 
> Historically, that last case was XFS_IFBROOT|XFS_IFEXTIREC. 

No, that was not the case, even historically.  btree based inodes
already existed for more than 10 years when commit 0293ce3a9fd1
added XFS_IFEXTIREC to singinify the in-memory indirect extent
array.

> What
> should have been done in 6bdcf26ade88 is the XFS_IFEXTENTS format
> fork should have become XFS_IFEXTENTS|XFS_IFEXTIREC to indicate
> "extent format, extent tree populated", rather than eliding
> XFS_IFEXTIREC and redefining XFS_IFEXTENTS to mean "extent tree
> populated".  i.e. the separate flag to indicate the difference
> between fork format and in-memory state should have been
> retained....

I strongly disagree.  If we want to clean this up the right thing is
to remove XFS_IFINLINE and XFS_IFBROOT entirely, and just look at the
if_format field for the extent format.
