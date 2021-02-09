Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCF6C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C9B764E26
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBIJeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhBIJcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:32:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89415C061794
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EQaVxlbhWVJqq8vyuaGroGYpUu4nxThZCUwTx2ucQ3I=; b=jcTcGAcAVy435Di1gcSQAsyH4W
        31KWD3TFFwZpekCxno/6D2Fe/iDZ0+kuXLtZVY9HTluuuIO7VrL6rsm4X7C2oegQpK4VldJeQ9xbH
        Lj4mFOgOcUL8ghxxGfIumWr9qbvcAd2RELTc9wq14JdYisAKvHCId/vug0hWxmnKVbdty/X9jgu27
        4imgIuMFEYZ7QbUDcYF64xLuhX/GKxjAFvd4HXW+5cA7z2ohUW/w+0HU7Cjxg3ASNFCd8PTu+2EXA
        b2QpzTOiHfqIOcWD1jYb02EHClLSaxIsnCmhEh/yYfB31XVPVK8wB6aC3utWeTH6JhU/R6va9Nylm
        COuqV/yA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PMY-007Elp-KL; Tue, 09 Feb 2021 09:31:14 +0000
Date:   Tue, 9 Feb 2021 09:31:14 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 5/6] xfs_repair: check dquot id and type
Message-ID: <20210209093114.GQ1718132@infradead.org>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284390433.3058224.6853671538193339438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284390433.3058224.6853671538193339438.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that we actually check the type and id of an ondisk dquot.

This looks copied from the kernel code.

But otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
