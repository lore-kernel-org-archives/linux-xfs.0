Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64199C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368E42137B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:50:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KEfFwteL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbgDAPuE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:50:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732683AbgDAPuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 11:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YPcg5S7B5tgWiLQIrBOdGQhMplIP3C4lUzJhc0ednxc=; b=KEfFwteLsPmwq84Et+bs3PiH17
        op61DL1qICw6A2W4w00jJeKFSdlWUf/Qza0wzpxPBG5yQ+eIGEbdHgpEsemVY2aOVa/FcN7JM4346
        uSQfJSSo7wlSVtPVAuAb9EA38GomoPQ4aqAog75+R54KptrRlPox93FEUuzq/xeZ4Pgfr098ib2w+
        1ZU4T/XriAPWQnivUTNvGcqYRgnIdF30+aDYQdVTFLuQzSZsB1BvZrFYRBDgEn9YAFmhZOc38XuU6
        2tXb700H3vgNMtq0+hqty0NuWe4aaWYu7brghABz8phu7VF+Ec7Eu/S8l51ZjHrknKNDKiwXNZjgu
        /Je7CsNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJfcy-0002iF-6i; Wed, 01 Apr 2020 15:50:04 +0000
Date:   Wed, 1 Apr 2020 08:50:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: Handle memory allocation failure in readahead
Message-ID: <20200401155004.GA8331@infradead.org>
References: <20200401030421.17195-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401030421.17195-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 31, 2020 at 08:04:21PM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> bio_alloc() can fail when we use GFP_NORETRY.  If it does, allocate
> a bio large enough for a single page like mpage_readpages() does.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks ok - not because I'm a fan of the pattern, but because we have
a real bug and this seems to be the quickest fix and similar to the
mpage codebase..

Reviewed-by: Christoph Hellwig <hch@lst.de>
