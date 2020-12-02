Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A330BC64E8A
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3FE221EB
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgLBRQZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbgLBRQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 12:16:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B82C0613D4
        for <linux-xfs@vger.kernel.org>; Wed,  2 Dec 2020 09:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3yimKcHtVHFfJscPE195qKQyf/19Z1S2lvZD/DhgpGk=; b=RsB8FRp7saXZTGKC2S9iG8iwhh
        jQPwnVgCICyI/QFhMUxQGXVOEjG60a8LqbeYJSYeZ2eEJo6zj9KSb9yCrlZxYaf6kmypLhqC8sSpp
        FQOwWMJ7oD3lDQHI1v9k2pbEDBU+pKk1Gl9YtHPZ93tCERgfcXL5TMuCDTIt/sH2U3MNuK+cEuqdH
        YAYk0rx+ialmPLGltqWKxnYWpiRkij0I9cRjakx60fQDaCpMKh7FYvwnE1S1Pi6v99wIn4EiewCDe
        TuCZYyRcqjTZKSZVUNYT087+6zpgb5PFTaTCXzRkvnt5txhEx2bEr2HBmQY2VcR4cmJvI37dkalkP
        bbqlig/g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkVjD-0006QB-IA; Wed, 02 Dec 2020 17:15:43 +0000
Date:   Wed, 2 Dec 2020 17:15:43 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] xfs: do not allow reflinking inodes with the dax
 flag set
Message-ID: <20201202171543.GB24200@infradead.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <07c41ba8-ecb7-5042-fa6c-dd8c9754b824@redhat.com>
 <20201202102221.GB19762@infradead.org>
 <49e44513-2f52-b221-6c33-e5e7119eb8b9@redhat.com>
 <20201202171530.GA24200@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202171530.GA24200@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 02, 2020 at 05:15:30PM +0000, Christoph Hellwig wrote:
> On Wed, Dec 02, 2020 at 08:44:24AM -0600, Eric Sandeen wrote:
> > Would it be correct to restate your last sentence as "Disallowing reflink
> > when XFS_DIFLAG2_DAX is set and dax=inode is set makes sense?"
> > 
> > If so, then the only change you're suggesting to this patch is to /allow/
> > reflinking if dax=never is set?
> 
> Yes, I think we should.
> 
> > I just figured a very clear statementa bout incompatible flags was simplest,
> > but I get it that it's overly restrictive, functionally.
> 
> The simplest in terms of semantics is to make sure reflink+DAX works,
> and while we are on the way we'll still need a workaround until that
> happen.
happens.
