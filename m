Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA24FC4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA526120D
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhHOPby (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 11:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhHOPbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 11:31:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49D3C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FNkwkwyI8x1qV4pmZoJq9b6BYPX//FytXVuMABDl5yo=; b=slv21wgKD0W+NKFr4UqwIwy2ny
        Jk0YQKaDvzsLrMe3FhrAHT/hznuywwJAOpFFYDwBdQ2hKBVPoWsVDUItBIUuxlNjnFjs/3jhihJGT
        28DpJWULoxer1r5zj/RGvvqbqptNxbbkWMTwhetTU4WoCMiJ4Fk3TK3J/iOJ1Nc1aMlFhEtG7zUFQ
        8y+NOwQ1i2dRqjbDxXAzcRWaylo7ololrLyqREL2xfKxIaHt63onKsgBDg+BYdHG2nAOS5xgwCLAS
        9eXBWpyA4pgeoXSREfQJbNTi0brpLHau+f45/hSbcOXdOwG7vAHBT2DH6IcIhFa3VbkhzH0Uab30H
        vIX3yVpA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFI6I-000NxD-Ua; Sun, 15 Aug 2021 15:31:09 +0000
Date:   Sun, 15 Aug 2021 16:31:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: make the start pointer passed to btree
 update_lastrec functions const
Message-ID: <YRkzNsg7onp2R4nj@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881113307.1695493.9966859891966312704.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881113307.1695493.9966859891966312704.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 04:32:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This btree function is called when updating a record in the rightmost
> block of a btree so that we can update the AGF's longest free extent
> length field.  Neither parameter is supposed to be updated, so mark them
> both const.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
