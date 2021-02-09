Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC1AC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9004064EC4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBIJUz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhBIJRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:17:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48607C061797
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yCoYu8zbB5OSficI5t8xYViwuQ37ZHHDmlfMF70/4nc=; b=B8qmAf8lCFUsqxjnGSq1RjI7Lm
        VD/7yRwXNhHOmBo9d6HSD+YKIzwgap8GVNcL1u9Ix9VHkUVdycxv9CHZ6/91ClWLHvzwWQ5ZAak/l
        Et6jrCCUvBl1MhoLxe2CdZWtKW18rDywR6Sd1gUtc41A7NDPW1qjG7TO+VkZba+2ISmpWTfWGlsff
        wzpKIJYga/FHUepbm9v8uHiRmJ4HFwON9ksFrttR6PJvyFKC4QCYKNLWTdAX0s352c9rB/ti3rLEX
        /9XhZDYZIKW6HrRyTlZG0LjNhTm9yLUT3w/+mCQEZy4G+BPf7+5KoMt3ZpwJdHOEk92VTRZPoT9O/
        9K9olJaQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P8Y-007Dfa-L1; Tue, 09 Feb 2021 09:16:47 +0000
Date:   Tue, 9 Feb 2021 09:16:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
Message-ID: <20210209091646.GI1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284385516.3057868.355176047687079022.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284385516.3057868.355176047687079022.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Simulate a crash when anyone calls force_needsrepair.  This is a debug
> knob so that we can test that the kernel won't mount after setting
> needsrepair and that a re-run of xfs_repair will clear the flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
