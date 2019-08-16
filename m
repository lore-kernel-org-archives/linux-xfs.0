Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B37BC3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 16:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21D0B2077C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 16:57:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nh4nbtZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfHPQ5N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 12:57:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfHPQ5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 12:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Byk+Z7fbnw+hJ1A3SXtpTv1x5R988Tvo9jglZrJEceo=; b=nh4nbtZQHdQyyXyIZ8CCXW9B/
        Q6+zu6EJF1Xcn2mr2x72Atv+5kyKcdBI/cQxIlXqO08bN0XW2egrk7fH6vSHBn3lhwVqWZD1lX5gZ
        kAuVdmlTDHvWxAhYd49msq4tZtygFrf1K33cYSMo5o+UxWyufnldWB4yGSe9jgRpoUaE0XY3lJAOV
        lDl9hEMplWHuTax+CfUKDZqJ+uv/mJmL6JDSorK2vF/U7Q5ySksfd9GeyxtwzBFkmwdEL5256bNHH
        nDTraS8sQ+MkuD3csxYuOFrErbyxU15Tg3ZDjYNqMk6Cc4inid54cX9uvP9/ucJETGxCMPMmjkCK8
        OPN4XfqZA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hyfXL-0005vL-Vi; Fri, 16 Aug 2019 16:57:11 +0000
Date:   Fri, 16 Aug 2019 09:57:11 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        fdmanana@gmail.com, gaoxiang25@huawei.com
Subject: Re: [PATCH v4] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190816165711.GC18474@bombadil.infradead.org>
References: <20190815164940.GA15198@magnolia>
 <20190815181804.GB18474@bombadil.infradead.org>
 <20190816064753.GD2024@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816064753.GD2024@infradead.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 15, 2019 at 11:47:53PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 15, 2019 at 11:18:04AM -0700, Matthew Wilcox wrote:
> > But I don't think read_mapping_page() can return a page which doesn't have
> > PageUptodate set.  Follow the path down through read_cache_page() into
> > do_read_cache_page().
> 
> read_mapping_page() can't, but I think we need the check after the 
> lock_page still.

The current code checks before locking the page:

        if (!PageUptodate(page)) {
                put_page(page);
                return ERR_PTR(-EIO);
        }
        lock_page(page);

so the race with clearing Uptodate already existed.

XFS can ClearPageUptodate if it gets an error while doing writeback of
a dirty page.  But we shouldn't be able to get a dirty page.  Before we
get to this point, we call filemap_write_and_wait_range() while holding
the inode's modification lock.

So I think we can't see a !Uptodate page, but of course I'd be happy to
see a sequence of events that breaks this reasoning.
