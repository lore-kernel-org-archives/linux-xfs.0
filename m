Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01408C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 13:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A532098B
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 13:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XWXfEFJ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgFPNXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 09:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgFPNXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jun 2020 09:23:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94AAC061573;
        Tue, 16 Jun 2020 06:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d4uLhaAKFoCQdlS/f0wvm9nDPSwC3vPF4E1PF6wpm1A=; b=XWXfEFJ9kPYogNWmhr+8G05nQR
        cgOdzK1zkx3U/BL8vb+jNGE20kHjRpFG2pkzLfdDTBKS0L45lm3BK6PX1mE/llUx5Qk4PHcqcIkrK
        +JQJbNGp7igBm+AqIFkY3m9GVdh603Ny4/Na/CcHRyjvm2ohLe7008pT35H12tm4Ii3aNEZMkYjp4
        0j5VlefI45UpkXP0jwaUfU4MWQq0JB2N6dHBFLkvgYtv+csMgV2gsitZV3sl0xuPNgXp0sTUP7HT6
        etQK4cqb7P6X2hCan6dE5F0gqjuc7bV9ci4gMQIXNmBt87nwGTlDe8bW1IBEP3Ifnkk2QK3lVW4z7
        1v/L9mXA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlBYd-00071Y-1G; Tue, 16 Jun 2020 13:23:19 +0000
Date:   Tue, 16 Jun 2020 06:23:18 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Bob Peterson <rpeterso@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
Message-ID: <20200616132318.GZ8681@bombadil.infradead.org>
References: <20200615160244.741244-1-agruenba@redhat.com>
 <20200615233239.GY2040@dread.disaster.area>
 <20200615234437.GX8681@bombadil.infradead.org>
 <20200616003903.GC2005@dread.disaster.area>
 <315900873.34076732.1592309848873.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <315900873.34076732.1592309848873.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 16, 2020 at 08:17:28AM -0400, Bob Peterson wrote:
> ----- Original Message -----
> > > I'd assume Andreas is looking at converting a filesystem to use iomap,
> > > since this problem only occurs for filesystems which have returned an
> > > invalid extent.
> > 
> > Well, I can assume it's gfs2, but you know what happens when you
> > assume something....
> 
> Yes, it's gfs2, which already has iomap. I found the bug while just browsing
> the code: gfs2 takes a lock in the begin code. If there's an error,
> however unlikely, the end code is never called, so we would never unlock.
> It doesn't matter to me whether the error is -EIO because it's very unlikely
> in the first place. I haven't looked back to see where the problem was
> introduced, but I suspect it should be ported back to stable releases.

It shouldn't just be "unlikely", it should be impossible.  This is the
iomap code checking whether you've returned an extent which doesn't cover
the range asked for.  I don't think it needs to be backported, and I'm
pretty neutral on whether it needs to be applied.
