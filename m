Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECB6C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 17:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F922083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 17:26:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qqQ7TXZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgHaR0q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgHaR0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 13:26:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06CDC061573;
        Mon, 31 Aug 2020 10:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ju0PVpNY3/ckdFWEkNKtSiQqosF3ht57RIZrGyS4lo8=; b=qqQ7TXZeKin0LumxSCewynACa9
        L5lqeKhlui5AoMn4oHoZiCon7WwhQwVCbB9tceI4745HaM/ZNJDFM9kguVqZFbtO8Zen+mCiHSiUe
        m+EpUVyHI35nH+mPkZpkhZmq1DPKoBbgfkNXICHjm/PWCjlAuEAf71i1em3FNqAE7C0uzejBrgmvq
        NIGKcqTKWp6E7HDTfuc4/HwQ4vgHR8kU6o8DAHu6miO2lELnBz97yhZG0+dREiDugZCVdyYWzyfll
        DNGUqe6mv+xFLJsfA0wEjHFjuxL0WwM0F+YPsDy12idhs6QndTZUtU/aYSGhCVu83OdVpHB6kTJk5
        3a600W4Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCnZp-0007pK-19; Mon, 31 Aug 2020 17:26:41 +0000
Date:   Mon, 31 Aug 2020 18:26:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] iomap: Fix WARN_ON_ONCE() from unprivileged users
Message-ID: <20200831172640.GA30014@infradead.org>
References: <20200831172534.12464-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831172534.12464-1-cai@lca.pw>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 01:25:34PM -0400, Qian Cai wrote:
> It is trivial to trigger a WARN_ON_ONCE(1) in iomap_dio_actor() by
> unprivileged users which would taint the kernel, or worse - panic if
> panic_on_warn or panic_on_taint is set. Hence, just convert it to
> pr_warn_ratelimited() to let users know their workloads are racing.
> Thank Dave Chinner for the initial analysis of the racing reproducers.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
