Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABD9C07E9B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 14:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804B061CBE
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 14:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhGGOHO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 10:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhGGOHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 10:07:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711FCC061574;
        Wed,  7 Jul 2021 07:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gzml0XG5yWOMd0LHz5lwYo4suZ+MYJh1kfg9zvF/qmg=; b=EkJdw3Ab2u/2OlU9wvZFKXB/+H
        1XdJavrd1c97XJhr3jvfVUMaTN20IONLhT8VuBx/KwzYbcD484prcklBROve4gYg3Xg2jelPW1ICR
        BZgmYfuy4yHG96zfkMHZcZwfy7uMMHzikS4SchXZttidsmkvC54Rd8iR5Up6od8a1mFGnvtO3rBnw
        ZvE/xjAB53U3U0qxAcPVi04K9Ui+9SxUWUg9yCwXCDaJjeLuU8cEKGbLgwFYKL/pwnJKo/YfeA5oZ
        sFl0igr2qjgymQe7ETr9JjgUWXjGA3ReJJ8Lzt5G/o1fQELUFKghhk+3OkHE3ORSHSU5PK36USb1d
        KBhhKlRg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m189X-00CScZ-Ct; Wed, 07 Jul 2021 14:03:57 +0000
Date:   Wed, 7 Jul 2021 15:03:51 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH v3 3/3] iomap: Don't create iomap_page objects in
 iomap_page_mkwrite_actor
Message-ID: <YOW0R5y8QPqTdnmj@casper.infradead.org>
References: <20210707115524.2242151-1-agruenba@redhat.com>
 <20210707115524.2242151-4-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707115524.2242151-4-agruenba@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 01:55:24PM +0200, Andreas Gruenbacher wrote:
> Now that we create those objects in iomap_writepage_map when needed,
> there's no need to pre-create them in iomap_page_mkwrite_actor anymore.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks for sticking with this.  It looks like a nice cleanup now
rather than "argh, a bug, burn it with fire".
