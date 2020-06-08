Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E23AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 06:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B6720774
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 06:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sZgSa6+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgFHGUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgFHGUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 02:20:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C743C08C5C3;
        Sun,  7 Jun 2020 23:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F6KQARBWnhLvbW+hxsj446Ur56hXK5lCtDmjbXN4+dU=; b=sZgSa6+ibLKXjgq82B/rR2d3xp
        ym/EpzjeLtGzwSIGMBcOTpy/TEt7I6hUzeayrtc2oAQthTsiV/i7OTN1J8AP3hKjlp1i7ZaSf6OTD
        I3euzkyuMQhEZKRqeGWPhYj5FIRnWGjgknb/YmrX4QZwR020FglYf09AF57VM9lfFMV2/NdHP9BSO
        SBUEw5NFiYGIQLtqrY9PdyxRMJrgLsfYOyrBnAN75imoshxHNKfAxFwcFXBrMY7toqUYGQoAMw6o0
        qdDSeojAfx4ijW74OmfRVL4GYicwmPwJrWneY1AQ7ODqQmHVrcK35O32Dxc7lsxBA5FybesKxVqfa
        p2sx4f6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jiB9E-0003fH-4J; Mon, 08 Jun 2020 06:20:40 +0000
Date:   Sun, 7 Jun 2020 23:20:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: Fix unsharing of an extent >2GB on a 32-bit
 machine
Message-ID: <20200608062040.GA14861@infradead.org>
References: <20200607103536.26508-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607103536.26508-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 07, 2020 at 03:35:36AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Widen the type used for counting the number of bytes unshared.

Looks good, although at least for XFS we can't have that large
extents anyway:

Reviewed-by: Christoph Hellwig <hch@lst.de>
