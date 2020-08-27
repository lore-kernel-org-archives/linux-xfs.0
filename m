Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4857C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4AF22B4D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D/vWZ91g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgH0IJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0IJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:09:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E23FC061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z9Kiofu4xx8QE7kOhVb0dS2b9ieuZY8mACAXVSvNhPI=; b=D/vWZ91g88gJnxsQGhIfSRqWJp
        STYp9/4vzEi+yElpVMSDGP6IJT432Sw0E/ttbafAxSOWhkVSsF5W0yKX8jCkJFW+JT1PrG0vZpycy
        8++HvkHM6Xnf/j8ENJ13En2mumncHNeCBfNvtPA8/+37ElyB0NJQOb/1nlpHiLJ742eBSt+n9BPaK
        NpRWDJwaEfVxCHMwjSe/N5vFsQbJFoiN70f7p5fyYPxUY0y4G4mICBcAoooLE5nKjZ8E4B3IJ9wH5
        GBpuZ7bwGgXid3lUE3b1sXl9/jToD/KctRkE0mTvAUF/puDkvYOHa0DsvsRrEb3+Pzcq5a+wbwy16
        bpLxBqOQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBCxz-000242-Jy; Thu, 27 Aug 2020 08:09:03 +0000
Date:   Thu, 27 Aug 2020 09:09:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, david@fromorbit.com
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20200827080903.GA7605@infradead.org>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
 <20200814080833.84760-3-chandanrlinux@gmail.com>
 <20200817065307.GB23516@infradead.org>
 <1740557.YaExq995uO@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1740557.YaExq995uO@garuda>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 01:14:16PM +0530, Chandan Babu R wrote:
> > > +		error = xfs_iext_count_may_overflow(ip, whichfork,
> > > +				XFS_IEXT_ADD_CNT);
> > 
> > I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
> > for a counter parameter makes a lot more sense to me.
> 
> The reason to do this was to consolidate the comment descriptions at one
> place. For e.g. the comment for XFS_IEXT_DIR_MANIP_CNT (from "[PATCH V2 05/10]
> xfs: Check for extent overflow when adding/removing dir entries") is slightly
> larger. Using constants (instead of macros) would mean that the same comment
> has to be replicated across the 6 locations it is being used.

I agree with a constant if we have a complex computed value.  But a
constant for 1 where it is obvious from the context that one means
the number one as in adding a single items is just silly and really
hurts when reading the code.

> 
> -- 
> chandan
> 
> 
> 
---end quoted text---
