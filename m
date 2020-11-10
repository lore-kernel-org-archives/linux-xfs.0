Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CFAC55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC5820797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mIClJN+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgKJShL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgKJShL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:37:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7AFC0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PeFY9C87H9q9wszYU734OJwk5piIXZUbRDkK+nXbecM=; b=mIClJN+Yg2TpVb+OKMUH4YUiDM
        4WkUY21s2E0+IagEndJ1Js7nWPJLarPhjprM5FRDxSlLyeKZKPd8dfrsgTju7Z44w8FOEe45d2DiC
        YtcEu+A0m3UwB6b3YWcx343FY36v5AghdMKUBpCh22K0i3V+ft1M6twt4tcpY3Q9swfT5qIq10JuK
        TiUrsxJZsM2uEqjI76tRgLdmrAxcEU08yQdC/qcqEdeaGUNEBOf6QMdLuFhKtyNsG0zpEtn1vlHsM
        BYf6VGwht7Yxh394gjPdP8Jpw3MwJeqBOkOIA48tY4d0mIIYaNfIAhpdQ1PC6xFZAfXAgBV5ckEus
        D4WhdBYQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYVv-0002gD-0n; Tue, 10 Nov 2020 18:37:07 +0000
Date:   Tue, 10 Nov 2020 18:37:06 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] mkfs: don't pass on extent size inherit flags when
 extent size is zero
Message-ID: <20201110183706.GG9418@infradead.org>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
 <160503140288.1201232.14448155271122385848.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160503140288.1201232.14448155271122385848.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 10:03:22AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the caller passes in an extent size hint of zero, clear the inherit
> flags because a hint value of zero is treated as not a hint.
> 
> Otherwise, you get stupid stuff like:
> $ mkfs.xfs -d cowextsize=0 /tmp/a.img -f
> illegal CoW extent size hint 0, must be less than 9600.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
