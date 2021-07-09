Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8B0C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A7B61442
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhGIGZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 02:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhGIGZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 02:25:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DA2C0613DD;
        Thu,  8 Jul 2021 23:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gcaPJR/4ZOOQGcy6fMULIQ4pZUsPloc0zoNnWdhQIOw=; b=v9bPUv83zCzPX6tc3JEJwNdxin
        ttYdeUKkQUzZVjUkQXlel8M9xC0dtHbA1guI+qwE3QIVuK6FTJa3cH+W4qnKMkruUGLD78jaw62Gi
        zzqJQkNVYJjES7iRxaQ2kXpNHal+QhPvUsBIT8yEbxWLe4FWN8PV6nt2nzMSfY4tMrY7LBcgp1Pfw
        HCQsA8uDKhtJyILVeljz2+CY1ZsXewHCDtQxOzjwwYuLvSghzZd5JagG5rlC+UDo6uAHft9EE7OBS
        5LMKn+XY6Qj8aYrPUYVcZUUdORF2IVh5R91GHAt0uqNIvtGG6pXT8gP2q8wNNz2AhR/WVBkiXhJnF
        Dum2BYrQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1juA-00EDYY-EJ; Fri, 09 Jul 2021 06:22:36 +0000
Date:   Fri, 9 Jul 2021 07:22:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [PATCH v3 3/3] iomap: Don't create iomap_page objects in
 iomap_page_mkwrite_actor
Message-ID: <YOfrJoqZVyB6F7Z1@infradead.org>
References: <20210707115524.2242151-1-agruenba@redhat.com>
 <20210707115524.2242151-4-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707115524.2242151-4-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 01:55:24PM +0200, Andreas Gruenbacher wrote:
> Now that we create those objects in iomap_writepage_map when needed,
> there's no need to pre-create them in iomap_page_mkwrite_actor anymore.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
