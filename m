Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E777C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080422076D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XxqnKqro"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgEFPEU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFPEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:04:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC5BC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j87L1nO5RmCYXHvLKUN1cuVat6rdh9NbHRgXKuqKyKs=; b=XxqnKqro1sstBa16/B26MXtCRB
        J9iCE+hxEDurlEstkFqec/ebxrZBpY+wlaYGUK+6wXVrPyxxmU2lqemtA8fM5fNEZ0tlrV7yBeTs9
        AE94RXHvF228tybyzDT6JmUwmuGEDVBFOqi/HJMVzFQDMIzhCSZx9dKH9DsTUWNP0TZQVQzCoJqej
        t5YNR0IrWjS9DTDmRjKDEHbtW4epQ5iR3fwzlTaLtdj6vOmNz4DwVUWxgC9pJGHDI0egdslHdJ3jf
        e9xycaXeAp9inCRU3/76Ko/QqymJI3bwWeTVO1ZI3j/UMZ1Y2uAeK5aWnc13NnODg2+oJ7WUmIC+8
        kvxB4wCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLau-00028p-1o; Wed, 06 May 2020 15:04:20 +0000
Date:   Wed, 6 May 2020 08:04:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/28] xfs: refactor log recovery item dispatch for pass2
 readhead functions
Message-ID: <20200506150420.GF7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864105149.182683.6318302965348913819.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864105149.182683.6318302965348913819.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:10:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the pass2 readhead code into the per-item source code files and use
> the dispatch function to call them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
