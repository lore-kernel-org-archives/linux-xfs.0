Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB09C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 420E86103A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhHLIij (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbhHLIii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:38:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06131C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ypQrZ0KQ7+z90sxUzgq4bEAhhEFUHjvqEJLTIlPJBQE=; b=EPmY0ZhSxSjBJmYiyDOcBmk7LO
        INgtIbQacvw2PRfj7cQ0RLi0p6UpwCLxLpKb8hjEBnLTzICFGKI2Odx6j2Q7JLpZHON4iNRf5CEEG
        LNEZabvh98+WS/VgA6PUh4UB1YY2kT2a+fzYpv6CoNdChjOev9Rf02413MAA8NL09DYzfoFRb7Y3z
        gArkrbpYEl1AhPk/NW50HI26GG9ZB1jkeIsmQ7d/drYTBPQhg5NisC6bbcDHl/bqrtC/ZS/LZD8l8
        jyKByVC5wcPnYapJCLRTpTQ5FlsY95MBIdz9camtXpuigwLJCenE1BhqyUbcRs5Hf/H9jmDOHwP4k
        xO2Zhw/g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6Cq-00ELd5-J2; Thu, 12 Aug 2021 08:37:37 +0000
Date:   Thu, 12 Aug 2021 09:36:52 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix off-by-one error when the last rt extent is
 in use
Message-ID: <YRTdpEM4/pjeODwG@infradead.org>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
 <162872992772.1220643.10308054638747493338.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162872992772.1220643.10308054638747493338.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 05:58:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The fsmap implementation for realtime devices uses the gap between
> info->next_daddr and a free rtextent reported by xfs_rtalloc_query_range
> to feed userspace fsmap records with an "unknown" owner.  We use this
> trick to report to userspace when the last rtextent in the filesystem is
> in use by synthesizing a null rmap record starting at the next block
> after the query range.
> 
> Unfortunately, there's a minor accounting bug in the way that we
> construct the null rmap record.  Originally, ahigh.ar_startext contains
> the last rtextent for which the user wants records.  It's entirely
> possible that number is beyond the end of the rt volume, so the location
> synthesized rmap record /must/ be constrained to the minimum of the high
> key and the number of extents in the rt volume.

Looks good, although the change is a little hard to follow due to the
big amount of cleanups vs the tiny actual bug fix.

Reviewed-by: Christoph Hellwig <hch@lst.de>
