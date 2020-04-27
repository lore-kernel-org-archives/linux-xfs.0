Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A9DC55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512F42051A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S09IdrB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD0HmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgD0HmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 03:42:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035CDC061A0F
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 00:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ovFedqzXKlPaB3xC1YX4uKIZogNe/1eX2mWaUftoBN0=; b=S09IdrB+u/8Oq2lv1xBMoyA+51
        0mdLltiYAgEz6I98767eLFpKqX2xqDKIQMutOYrRIuWZxObN77Ml3AtbFIB6xw1QzCNFoh28QxLOX
        BYfpcGf0s2zKzt/++KO5i5oPot61PsdO1RfPokUJlrYTXSaNxIlJzY79vSRWRwdOivDm/billiPJU
        SMoT7xywM8LT4YkbDtVkMRvDKy69382SRYB9IRpmEwRDYo359L18gxusWIA/fMf/y4h18R2axiDt5
        vtlXeeIc8M635Ju+jz4Y/KrqS2fcR1fk6IPu1gXYPEWE640CVpwH7cQKzt8on+ZVyAvlJu0VwLq7T
        bbAPKQ2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSyP7-0008Vb-C9; Mon, 27 Apr 2020 07:42:13 +0000
Date:   Mon, 27 Apr 2020 00:42:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200427074213.GB15777@infradead.org>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-3-chandanrlinux@gmail.com>
 <20200407012000.GF21885@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407012000.GF21885@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 11:20:00AM +1000, Dave Chinner wrote:
> Ok, I think you've limited what we can do here by using this "fill
> holes" variable split. I've never liked doing this, and we've only
> done it in the past when we haven't had space in the inode to create
> a new 32 bit variable.
> 
> IOWs, this is a v5 format feature only, so we should just create a
> new variable:
> 
> 	__be32		di_attr_nextents;
> 
> With that in place, we can now do what we did extending the v1 inode
> link count (16 bits) to the v2 inode link count (32 bits).
> 
> That is, when the attribute count is going to overflow, we set a
> inode flag on disk to indicate that it now has a 32 bit extent count
> and uses that field in the inode, and we set a RO-compat feature
> flag in the superblock to indicate that there are 32 bit attr fork
> extent counts in use.
> 
> Old kernels can still read the filesystem, but see the extent count
> as "max" (65535) but can't modify the attr fork and hence corrupt
> the 32 bit count it knows nothing about.
> 
> If the kernel sees the RO feature bit set, it can set the inode flag
> on inodes it is modifying and update both the old and new counters
> appropriately when flushing the inode to disk (i.e. transparent
> conversion).
> 
> In future, mkfs can then set the RO feature flag by default so all
> new filesystems use the 32 bit counter.

I don't like just moving to a new counter.  This wastes precious
space that is going to be really confusing to reuse later, and doesn't
really help with performance.  And we can do the RO_COMPAT trick
even without that.
