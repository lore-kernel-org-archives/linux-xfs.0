Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88557C07E9C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 05:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF9F6198F
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 05:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhGFFGz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 01:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhGFFGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jul 2021 01:06:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D37C061574;
        Mon,  5 Jul 2021 22:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9RvGsPwl1Fmk0JIzNFiJdslAg2y5RrA1YSWYjeiCoYM=; b=j0l0DAjtksIIh1s8AP+lDkejmP
        /Jcc6jowY+lquLPgVq9RbUC39i6sSayMLEGJcH7177eQUePIYwR2lYyx55UNzDu/SdwJvOVZ7iCYb
        FqoHnkrokscY/EOuIrQEJj1m5Dh7h1BLTcxb/xWDwQfrrwonnq6dkA/DdRdEH50Ov0i459M6/Fh++
        ttYZ5Q8GWfijOJYKy9dpWeqSRmGh/Ux01H/zo0amBFQ946zTIvcJ2s31qlKTYEk1kINQz8ls4yFiH
        OT3Rdodq6SXwsZ2SsZVR0L9PkpscgYYvVLoH64Tef4DlZv3W01Ni/s/A+K8LeJ03cdybFUha6a+8R
        jmKWtYxQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0dFO-00Aqlb-Fi; Tue, 06 Jul 2021 05:03:54 +0000
Date:   Tue, 6 Jul 2021 06:03:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 1/2] iomap: Don't create iomap_page objects for inline
 files
Message-ID: <YOPkNnQ34vRiVYs6@infradead.org>
References: <20210705181824.2174165-1-agruenba@redhat.com>
 <20210705181824.2174165-2-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705181824.2174165-2-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 08:18:23PM +0200, Andreas Gruenbacher wrote:
> In iomap_readpage_actor, don't create iop objects for inline inodes.
> Otherwise, iomap_read_inline_data will set PageUptodate without setting
> iop->uptodate, and iomap_page_release will eventually complain.
> 
> To prevent this kind of bug from occurring in the future, make sure the
> page doesn't have private data attached in iomap_read_inline_data.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

As mentioned last round I'd prefer to simply not create the iomap_page
at all in the readpage/readpages path.

Also this patch needs to go after the current patch 2 to be bisection
clean.
