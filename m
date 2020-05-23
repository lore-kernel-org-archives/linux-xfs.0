Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FEFC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 07:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88866206C3
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 07:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NFqeQMht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387645AbgEWHJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 03:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgEWHJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 03:09:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF815C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 00:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1Bxb5TtimHeQxUnY4IlwRYgVTFpzwRs2fA+FJdq6vjQ=; b=NFqeQMhtL8BBKcGsqUw0VBqOai
        Fa4dd2WVNkCwKJHw69jHwbu8tX2RJjDzI2pCCHLcD6K0gPLVV8J138P5CwI9tyk2bvdHRr65NNddM
        1U1JTt99LTislqBCqVJfMbRi6Ef6P1JEtLiJTm5Uruo6jRWO0Rm/X+4o4+HtL6iYXmD/Ai5gwnXXg
        4xVjDEcd343MAuYeSQaDr3uM+v/lEytQFiOJBhfyCb+pMF5v9sWoUFW7iRQj1GXNJ/yZnUrZC2jZd
        bT5KIaWkkeb51L6S/xbV63AqOQhBCcFuHT41CadgoteC6omgiyhG3QbTiig4Ej1x+FNZDFsOmFRWn
        gU7HterQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcOHm-0002Ks-0P; Sat, 23 May 2020 07:09:34 +0000
Date:   Sat, 23 May 2020 00:09:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200523070933.GA8693@infradead.org>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011598984.76931.15076402801787913960.stgit@magnolia>
 <20200522112722.GA50656@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522112722.GA50656@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 07:27:22AM -0400, Brian Foster wrote:
> Why do we replace the bit shifts with division/multiplication? I'd
> prefer to see the former for obvious power of 2 operations, even if this
> happens to be 32-bit arithmetic. I don't see any particular reason to
> change it in this patch.

Because it is the natural way to express the operation and matches what
is said in the comments.
