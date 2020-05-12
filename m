Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9F6CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF672054F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tFMMQUIx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgELQDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELQDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 12:03:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FD1C061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 09:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P864GZPSFPNb8uTuPFkpJ28u20EYQVmyj/ARMb8AzHU=; b=tFMMQUIxuMG8oRAy9eu0a4p+fr
        8ox1PZiN3rBhTpETzUjq5rtSQX3BJ9LIc6KbGaG3VXVQB1Oi9aX5YtsrbzTesq53HILl1W2oPX4aj
        cw4QzIiDwbV2MGmVB7BcgVijJl87vKdeNlCX3zS873haQA9B4ESpqRrihsRjVhyhA+76o3Lq4FD07
        uFxumUfIpfkgplzGiF4Z5dMElqoRQGW2QP7PU/ZS2UPx4JQzxO1wptTEKT4WDfoqfQ2rbBELeRyJH
        hDpezxwJdbR9YO/4EigqetfZPOvtykUmTeIwe78QtoD/V9xvvs4CHbU4gJUKj9D+EULv+zWTWt9r/
        srKwxjgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYXMy-0005s4-9n; Tue, 12 May 2020 16:03:00 +0000
Date:   Tue, 12 May 2020 09:03:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: warn instead of fail verifier on empty attr3
 leaf block
Message-ID: <20200512160300.GA4642@infradead.org>
References: <20200511185016.33684-1-bfoster@redhat.com>
 <20200512081037.GB28206@infradead.org>
 <20200512155320.GD6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512155320.GD6714@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 08:53:20AM -0700, Darrick J. Wong wrote:
> I was gonna say, I think we've messed this up enough that I think we
> just have to accept empty attr leaf blocks. :/
> 
> I also think we should improve the ability to scan for and invalidate
> incore buffers so that we can invalidate and truncate the attr fork
> extents directly from an extent walk loop.  It seems a little silly that
> we have to walk the dabtree just to find out where multiblock remote
> attr value structures might be hiding.

The buffers are indexed by the physical block number.  Unless you
want to move to logical indexing that's what we'll need to do.
