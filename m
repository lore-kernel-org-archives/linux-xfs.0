Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABB1C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D41C61058
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhHLIdV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhHLIdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:33:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B6DC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oBXME2WVZ8NHMgRsLLgbbEicFNDhWwHe+498Eqox48Q=; b=YeqhvVh+aMm6bHE2y24Bfn59hw
        4tJ2K90O2wrxmu0BxVRII3v9AM9WR79DhUYa4Oik+QkzYqNwyghvTxJOW3jmQvf25feXopxSrUXYy
        e78sI6bDlnY8pYMhEXyKVbVAnzaIZoNJi7KAO9Zb5uRCo1ndeZhLow+pqcVMjumBTB8D74zEKnb5N
        5N0MZpZ+SZCNNBinqvFYlNZ2kOAdoNNoquPGM1GOLNsj8dZR0qkwqHL/OgTtMn8lbUYSazv9rgVx2
        sQhqkw70u/2J0sXzh0xer4KSRTmWG3dXIq7mKu9tmqv7S/OK3tpHPPABiWANKqmst5l+xulNG3HpD
        g2KOBeUw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE66j-00ELSI-Pq; Thu, 12 Aug 2021 08:31:15 +0000
Date:   Thu, 12 Aug 2021 09:30:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make xfs_rtalloc_query_range input parameters
 const
Message-ID: <YRTcKcK1z430Y+Lg@infradead.org>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
 <162872992222.1220643.2988115020171417694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162872992222.1220643.2988115020171417694.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 05:58:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 8ad560d2565e, we changed xfs_rtalloc_query_range to constrain
> the range of bits in the realtime bitmap file that would actually be
> searched.  In commit a3a374bf1889, we changed the range again
> (incorrectly), leading to the fix in commit d88850bd5516, which finally
> corrected the range check code.  Unfortunately, the author never noticed
> that the function modifies its input parameters, which is a totaly no-no
> since none of the other range query functions change their input
> parameters.
> 
> So, fix this function yet again to stash the upper end of the query
> range (i.e. the high key) in a local variable and hope this is the last
> time I have to fix my own function.  While we're at it, mark the key
> inputs const so nobody makes this mistake again. :(

Heh.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> Not-fixed-by: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
> Not-fixed-by: d88850bd5516 ("xfs: fix high key handling in the rt allocator's query_range function")

Are these tags a thing now or is this just a grumpy Darrick?

