Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83294C64E7B
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD3421D7F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgLBRQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgLBRQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 12:16:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1A5C0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  2 Dec 2020 09:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JLJ36IUJ/0qXDv8U8aJT3olouSPocivye1VMOOz0/Gg=; b=iLuYdijIMmS6X9hT0qa52mMKSU
        +BOI1mjmMbagjS6odJN6qXn9TPvEjD/QQqE/jkM1hzGZ3IYcnxG1f3CJdjpxVaVTEXUnZlckavheL
        icm5nKhYR2/3MnTGD97rQLlBjYrruFvxGGpAI5frIOR96vmRIRfRtr5Be+J8OTcQe9p2ASijLLnS6
        dJ8Rf4geh8Et65kH71qHRmjKHTsOhHoT3JgtcPgbuE1Tas9cpVhgP7tDy+Vy/4dPLK59UFQMBbDSD
        dogF5hbDK/njFnnjHKruuTwrzdvRgbPBE6P1ijhTUTX3qYWLz4siS8duBqli9IN2RqXauBdVuGaar
        /yBq75YA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkVj0-0006P3-8k; Wed, 02 Dec 2020 17:15:30 +0000
Date:   Wed, 2 Dec 2020 17:15:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] xfs: do not allow reflinking inodes with the dax
 flag set
Message-ID: <20201202171530.GA24200@infradead.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <07c41ba8-ecb7-5042-fa6c-dd8c9754b824@redhat.com>
 <20201202102221.GB19762@infradead.org>
 <49e44513-2f52-b221-6c33-e5e7119eb8b9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49e44513-2f52-b221-6c33-e5e7119eb8b9@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 02, 2020 at 08:44:24AM -0600, Eric Sandeen wrote:
> Would it be correct to restate your last sentence as "Disallowing reflink
> when XFS_DIFLAG2_DAX is set and dax=inode is set makes sense?"
> 
> If so, then the only change you're suggesting to this patch is to /allow/
> reflinking if dax=never is set?

Yes, I think we should.

> I just figured a very clear statementa bout incompatible flags was simplest,
> but I get it that it's overly restrictive, functionally.

The simplest in terms of semantics is to make sure reflink+DAX works,
and while we are on the way we'll still need a workaround until that
happen.

