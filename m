Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC117C4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C72C218DE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kvtC7OtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfI3Hsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:48:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfI3Hsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A8stAC97Ahttb6c40iyo9o5g9M7uA3PUIbimoTMn5h4=; b=kvtC7OtGrYidOiGcFK1ctJIWE
        liL9Q5Od++Izt/sC4J+30CcMSnxYk6+ijr+2jbN328Fqr450l9O6UER5s2EXjTMAstBeDwA3vXSXv
        Oan+v+N4Nkmj1elN4CgktRVsPR6jiLAyt6Y9aA4fmerYkAwx2w0CdPcy5OyGpphf52KyB0yLXhqcw
        LDPSkVZ0zWEUxoyuTDrkdXF6/Nusm4sQ7XQoY4pmpnNm7rMTxIf+sj9DIosKPoREPSsgoDzQcmiir
        WW83+tU77LtZtAQt6ivCKr95/kkcnUilbRXzZDf7yPagoqyrc6xhvHU/KLPOElSvTo9eNSpfFDfeB
        e4MwinZJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqQQ-0000tD-GE; Mon, 30 Sep 2019 07:48:54 +0000
Date:   Mon, 30 Sep 2019 00:48:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Reitz <mreitz@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix tail rounding in xfs_alloc_file_space()
Message-ID: <20190930074854.GB27886@infradead.org>
References: <20190926142238.26973-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926142238.26973-1-mreitz@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 04:22:38PM +0200, Max Reitz wrote:
> To ensure that all blocks touched by the range [offset, offset + count)
> are allocated, we need to calculate the block count from the difference
> of the range end (rounded up) and the range start (rounded down).
> 
> Before this patch, we just round up the byte count, which may lead to
> unaligned ranges not being fully allocated:

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
