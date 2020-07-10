Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD775C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 16:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F822078D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 16:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p+yz66OG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGJQJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 12:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbgGJQJC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 12:09:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE842C08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VEpkiV93M29xnBILzNHonfhL0JsgK/CdcKUo2oJ/PJo=; b=p+yz66OGyelKYeVfUkwizkwKI2
        kdYu4AN2BFMs/U7x1j4N34vAv8VszitQtFn3J3To7h/D2pBI3mjaSFKp7C9cFarphckeoBSOZDnuy
        M45aoH3IKWqBuSSkpOUg3rE0vGvfpSWYPA5FY3P5w3d2NqT+Oh9nfEQlrgZllAUc1hBgYgfSKCm51
        +2NEXXsNADKn+bx6aqd4dSZJYjYxA0yuy4AoJdVv42tJW+JHSM0gMtjVuDCeVhDBA9kkofb7kXenb
        BhNP00RtbibRUrZq415tNCiKS2ZINtMKd++/Y5t4OC3bGoBYDd9MWxL8NrGpM06eUS5sxx/xKZdOZ
        HN5ZbolA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtva9-00031i-Dr; Fri, 10 Jul 2020 16:09:01 +0000
Date:   Fri, 10 Jul 2020 17:09:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/5] xfs: Remove kmem_zone_zalloc() usage
Message-ID: <20200710160901.GB10364@infradead.org>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710091536.95828-3-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 11:15:33AM +0200, Carlos Maiolino wrote:
> Use kmem_cache_zalloc() directly.
> 
> With the exception of xlog_ticket_alloc() which will be dealt on the
> next patch for readability.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
