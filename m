Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8723BC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F18E20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W/8NsXtm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgBYRwR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:52:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgBYRwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ts6Gpl+1EcgYGUOXyaqdWKtMobHvbMYUt+63lTObLRw=; b=W/8NsXtmbkkOBhKncG4KpxxtSy
        ogJRwBexQv1QzLr9Q7ibL+nQgq7wZBkTkKUmHdbHAYWXz+OpAno0WvL/IMC/6eIWlayGHMlaPB2eh
        tTLZnGfaj0ywxUx9X8nAKC9tlpLDqH7QZxGtyeTcCS6kObNaW0OnPsaO29v6exwgrh2eF2o8hzGVq
        D9gU9ubG72rXl/ElII/cEtn7dPb5pMd5V3noRakMmcBguVNX2hU0mtZ2AvM66gn+ZaacDXJYlWF90
        CuqEbNpuTJ/lYBzQGr11tIwj8pwiMlirEAQ6jnuuqNYXdGe3MDkb/JTS/K5U3iAUp+HG+N+jkIYFQ
        rnwvuTiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eNU-00010m-5h; Tue, 25 Feb 2020 17:52:16 +0000
Date:   Tue, 25 Feb 2020 09:52:16 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/25] libxfs: remove dangerous casting between xfs_buf
 and cache_node
Message-ID: <20200225175216.GS20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258961671.451378.13182510046201286918.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258961671.451378.13182510046201286918.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  #define XFS_BUF_SET_PRIORITY(bp,pri)	cache_node_set_priority( \
>  						libxfs_bcache, \
> -						(struct cache_node *)(bp), \
> +						&(bp)->b_node, \
>  						(pri))

I think this one would benefit from being turned into an inline
function..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
