Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E480C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 17:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbiESRaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 13:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbiESRaf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 13:30:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4339C3336E
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 10:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ix5qJBj+xoxpHIxt/miXi4mACnjuGnoqdydA+GYFmkk=; b=Q2UEhQmoQUMSqZVuggoSXicWSC
        F+Pfo5PyeZbRDI2Mcvzi8+45esECeGgMqTXxwAGnCxDNq7mYXrz6WfxmPw9+5XTgk0y0gP9xkGfus
        zuzL71BLuGOul+rb4iA82xF3Q9TE0CC0aPaQbbn8UvrbXgvVKAQBF8x+Yz42j8ecGid3OtEBMBntS
        dWgpXW6MG/ejT+2BIS0dZhX3akqC+SWI6iBkjhimg54YOxNx2SRA7rpRGJM6pGwuPfTP0etDN1h3c
        V2JKpGq3oy09HxiPAxeroRfb/g/MduHvKidyaku1xfwzl58pMaqsulRn4KOeyfxCgE/d/jOiXd7qj
        PfsDbhXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrjxe-008bRd-RF; Thu, 19 May 2022 17:29:18 +0000
Date:   Thu, 19 May 2022 10:29:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: convert buf_cancel_table allocation to
 kmalloc_array
Message-ID: <YoZ+bupW4FAeuTHI@infradead.org>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
 <165290014021.1646290.13716646283504726941.stgit@magnolia>
 <YoYBqe1I5fjl9Dfl@infradead.org>
 <YoZ5nFI7fNSmFYCB@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoZ5nFI7fNSmFYCB@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 10:08:44AM -0700, Darrick J. Wong wrote:
> On Thu, May 19, 2022 at 01:36:57AM -0700, Christoph Hellwig wrote:
> > On Wed, May 18, 2022 at 11:55:40AM -0700, Darrick J. Wong wrote:
> > > +	p = kmalloc_array(XLOG_BC_TABLE_SIZE, sizeof(struct list_head),
> > > +			GFP_KERNEL | __GFP_NOWARN);
> > 
> > Why the __GFP_NOWARN?
> 
> It's a straight port of xfs_km_flags_t==0, which is what the old code
> did.  I suspect it doesn't make any practical difference since at most
> this will be allocating 1k of memory.  Want me to make it GFP_KERNEL
> only?

I think that would make more sense.  With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
