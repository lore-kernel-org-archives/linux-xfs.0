Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22238C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74B364DD8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhA1J4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhA1J4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:56:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2BCC061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3oCfKyA1CBYF9eIFCWeKh6jZ6lHQatAD7I+nAn9vozA=; b=TwMoR2E2AepVq5I4rKsOHdXmIB
        IECCTfltESIOp+KtWChUsxaWb1QuFSFEaBpq0PCQhHQ7+NS2RjnmCGHCy4gfWdxxnMSsIliVn7P4M
        vYQcfBu9lhnVBYm0aApJlyglBxzjRjPWdE0bagNDTBZ8BhKul/rzDQTpGQYVDIODgyfY6hhZuTafS
        qfEyAlnU9CMAg3VhXNvmCtkqGQXmpSmQcf23BAyTckKZlClkfpF+r+ubDIMpaMGsdLDll3elaT7+W
        5Y958b5rEE7rpcJU5tL0S9OkcABCGqjEVBSiY3tPrfR0/E5C4fL9whp2F+4k9VLUfQ/hyjzRNfphO
        fdeg5TmA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l541V-008I86-81; Thu, 28 Jan 2021 09:55:33 +0000
Date:   Thu, 28 Jan 2021 09:55:33 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 10/13] xfs: try worst case space reservation upfront in
 xfs_reflink_remap_extent
Message-ID: <20210128095533.GF1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181372121.1523592.2524488839590698117.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181372121.1523592.2524488839590698117.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:02:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've converted xfs_reflink_remap_extent to use the new
> xfs_trans_alloc_inode API, we can focus on its slightly unusual behavior
> with regard to quota reservations.
> 
> Since it's valid to remap written blocks into a hole, we must be able to
> increase the quota count by the number of blocks in the mapping.
> However, the incore space reservation process requires us to supply an
> asymptotic guess before we can gain exclusive access to resources.  We'd
> like to reserve all the quota we need up front, but we also don't want
> to fail a written -> allocated remap operation unnecessarily.
> 
> The solution is to make the remap_extents function call the transaction
> allocation function twice.  The first time we ask to reserve enough
> space and quota to handle the absolute worst case situation, but if that
> fails, we can fall back to the old strategy: ask for the bare minimum
> space reservation upfront and increase the quota reservation later if we
> need to.
> 
> This isn't a problem now, but in the next patchset we change the
> transaction and quota code to try to reclaim space if we cannot reserve
> free space or quota.  Restructuring the remap_extent function in this
> manner means that if the fallback increase fails, we can pass that back
> to the caller knowing that the transaction allocation already tried
> freeing space.

The patch itself looks good, but I don't see what problem it solves.

Maybe I'll find out when reading the remaining patches..
