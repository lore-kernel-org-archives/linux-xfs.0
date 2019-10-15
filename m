Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CDCC10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 08:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E3CF20873
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 08:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RGBms1Y7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfJOICb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 04:02:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfJOICb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 04:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0gZkPGGgJa9iSyUv77MQVrQmPwNpjMY2lce/1+UsIWE=; b=RGBms1Y74jJhXuT8svbor9iRk
        76ASPve5ePAXQuvcg/5VIGxt5bEDpXQyyaWkKnEBsGYHRwBuIoIMS2YQxRgOz/ifAOvXC0KFyMIxq
        0zCslsZgbuleqvCbFjb6sxTRAa4VUnKPCT7OYDE5YgFGxWAJx/k2/sDmbAZY93uTKi5mXx34NRxAk
        ySZnkCse+ZbysorpuoHYjKRJDcvW6j+UY5kPPDR7rcW/uD56HJU4VNtMoHHB7fGNZGVJq1/Zi5yoH
        bnzbp8iwWqgxBh8748wvOIIcfulOaMjZ8gf4Xd4FqIzLWhMr8kwWnBzGO6Hdm9Rsk48jr0HtGIwQp
        sFC1L+Pdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKHmo-0002Y0-PK; Tue, 15 Oct 2019 08:02:30 +0000
Date:   Tue, 15 Oct 2019 01:02:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: change the seconds fields in xfs_bulkstat to signed
Message-ID: <20191015080230.GD3055@infradead.org>
References: <20191014171211.GG26541@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014171211.GG26541@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 10:12:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 64-bit time is a signed quantity in the kernel, so the bulkstat
> structure should reflect that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Strictly speaking this is a break of the userspace API, but I can't see
how it causes problems in practice, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
