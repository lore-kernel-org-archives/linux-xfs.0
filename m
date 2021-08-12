Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C687C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E405F60560
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhHLISP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbhHLISK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:18:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7D6C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PrA14O/JGryrz/7pzDjupDJNg02Doih8WMmJs6XuXps=; b=J6DSpqYPmyD1d1i3wLSVGrKXz4
        WVKC1Gay13IyyDB2VYlFBnIAJDr4Hu7qONp0iEavU+mEumruqmJETNzJA4doHgj78zPUAXqatgITe
        1l+C27Eqg2/VPy142q0P6soy5KLQnOwpmpf0n5Zv/6isS+Z9ZcN7U5ccIgD7Xlc/XztWOzVvRVPOW
        pPPcOpUECVnhaVNrQXovxyXt7RyC7DVS6eOMDacV4+E16GlB2hb10kP8buwQUZQOU3sU5xBBzynpk
        RfuOtA57TAONyOoNelMmn/a58L8GcGr4vCNrjdWid2/pbfxCsZZedElLyxW2FcV0VukIHs+kHnDgE
        cMw3SJ+w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5sg-00EKrZ-K5; Thu, 12 Aug 2021 08:16:57 +0000
Date:   Thu, 12 Aug 2021 09:16:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce xfs_buf_daddr()
Message-ID: <YRTYwuzgaWDprozP@infradead.org>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-2-david@fromorbit.com>
 <YRTXkHkJeIzEfGfQ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRTXkHkJeIzEfGfQ@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 09:10:56AM +0100, Christoph Hellwig wrote:
> On Tue, Aug 10, 2021 at 03:28:49PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Introduce a helper function xfs_buf_daddr() to extract the disk
> > address of the buffer from the struct xfs_buf. This will replace
> > direct accesses to bp->b_bn and bp->b_maps[0].bm_bn, as well as
> > the XFS_BUF_ADDR() macro.
> > 
> > This patch introduces the helper function and replaces all uses of
> > XFS_BUF_ADDR() as this is just a simple sed replacement.
> 
> The end result looks sane, but I would have preferred to do one patch
> that just does the script rename of XFS_BUF_ADDR, and one ore more to
> clean up the rest.

Which is exactly what this patch does - I should have looked at it
more carefully and not just the applied series.

So maybe tweak the above commit message bit, otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
