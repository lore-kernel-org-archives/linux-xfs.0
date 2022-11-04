Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D914AC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 08:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiKDIM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 04:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiKDIMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 04:12:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2028B26562;
        Fri,  4 Nov 2022 01:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kr184M0Z5n0lucNF4A8W2OxYrKBVZrwT2wbedE6jVFI=; b=kGVbR2Yiscc0PAZ/PjsyZnETyQ
        X7ZTx60x8zWHeYhc8nP4uVpKxDZIIXv9mM0owtB7Bf+GQ2OWx2YG882Jx0HScbtgLIj+AOkBHvLF7
        7nVl7dnHthyN66B67Knwvo1/EkIre27qm5pjgqDYY38lo0RDV6DaljRgEvBxYWc26hiiSMGoIgruk
        hSfxibS5wQr3bONi6r5TNcJucrWRGUe4PKXW1G5bCWnrrFqilWmWKQGwkIIPgmGFoQyLuhOVqa2DB
        zdG3yDxxdRYifhyyomjOW/0OhK8riWA5NjJmz7J3N4yRZZsLbCNAnVL3vIGcHX4rjDajMQrii0hIN
        nFTUGvFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqroD-002uOg-Qw; Fri, 04 Nov 2022 08:12:13 +0000
Date:   Fri, 4 Nov 2022 01:12:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/7] iomap: write iomap validity checks
Message-ID: <Y2TJXfGmOF3wtVmU@infradead.org>
References: <20221101003412.3842572-1-david@fromorbit.com>
 <20221101003412.3842572-6-david@fromorbit.com>
 <Y2IsGbU6bbbAvksP@infradead.org>
 <Y2KeSU6w1kMi6Aer@magnolia>
 <Y2KhurifaYbxkyNX@magnolia>
 <20221103003515.GD3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103003515.GD3600936@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 11:35:15AM +1100, Dave Chinner wrote:
> My first thought was to make this a page op, but I ended up deciding
> against that because it isn't operating on the folio at all.
> Perhaps I misunderstood what "page_ops" was actually intended for,
> because it seems that the existing hooks are to allow the filesystem
> to wrap per-folio operations with an external context, not to
> perform iomap-specific per-folio operations.
> 
> I guess if I read "pageops" as "operations to perform on each folio
> in an operation",

Yes, that was the idea behind it.  iomap_ops is really just the
iteration, and I've still not given up on the plan from willy to
merge the two ops into a single next iterator eventually.

So basic idea is iomap_ops - complete generic iterator, that
just returns and finishes of an iomap.

iomap_page_ops - callbacks for each folio (used to be page)

> then validating the iomap is not stale once the
> folio is locked could be considered a page op. I think we could
> probably make that work for writeback, too, because we have the
> folio locked when we call ->map_blocks....

.. and then separate ops for users of iomap, like the writeback code
with iomap_writeback_ops.
