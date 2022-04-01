Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C423AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 11:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbiDALtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 07:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbiDALtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 07:49:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9872E21C05B
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 04:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oFHMsS2f7Q7j41fJZLJueD/0QyGERxx99c5ppW2pKeU=; b=KkxcoCVcqJE/njWPvH/Gxtqnvr
        /fR2baG85MquiR8rOY7MMIoZ5BJuz9X3hrfzmEnqXFGa0Y8TD5Ea7xZsJdl5jBYbjvdSqx3ZIGGvF
        CtIjDtJXZlpx4wFFw0pZH6E/ZRH//eYJNkmtOkeZoN3LdR8DOxX2HbcHgGki7tTZEUJ91Y02iWJe2
        VnumN6iNlkjWycnEBx2+665R8yGvTdUo3AbtSA3XXUBC6dLsSmp9st4XjjVmA2o/nu74nDJR4CFSx
        I7xxWvgT9zGFrImuJfD0RrTEVS6Rh/a35sZX/JdD2wSPSqYIOc9wmOCL+LG6W+pDoj48+hO2s5IFs
        wO2k+Otw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naFkJ-005P0A-AB; Fri, 01 Apr 2022 11:47:15 +0000
Date:   Fri, 1 Apr 2022 04:47:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <YkbmQ/fJ+55fNDw9@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:10:41PM +1100, Dave Chinner wrote:
> xfs_iflush_abort() can be called without the buffer lock being held
> resulting in inodes being removed from the buffer list while other
> list operations are occurring. This causes problems with corrupted
> bp->b_io_list inode lists during filesystem shutdown, leading to
> traversals that never end, double removals from the AIL, etc.
> 
> Fix this by passing the buffer to xfs_iflush_abort() if we have
> it locked. If the inode is attached to the buffer, we're going to
> have to remove it from the buffer list and we'd have to get the
> buffer off the inode log item to do that anyway.

There is not buffer passed to xfs_iflush_abort.  I think this now
needs to say

"Fix this by ensuring the inode buffer is locked when calling 
xfs_iflush_abort if the inode is attached to a buffer."

or something like that.

The code changes themselves looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
