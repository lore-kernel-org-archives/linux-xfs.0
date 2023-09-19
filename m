Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90103CD5BD0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 15:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjISPBd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 11:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbjISPBc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2023 11:01:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D646EC6;
        Tue, 19 Sep 2023 08:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Rtc3uem8ddiR9Ja2IfzYS5WR/DSCeWUeDjOJFAPqtE8=; b=vV7xzhXLw4nmH7SNWv9DHWcrC/
        LlKLNp1Ua8UIgPvSuVGmmwt5P/Lpg6rk9yv1OSI+AINScnm40sviBiE+8TIJfpc/RzWk4TWv3bZc1
        DsXCBCLTMcdQPNdhVrDCPJxszKpFwMDtX2mdHv6m88tvH5SamsV9a4jQ6DVDm8/cpRzKmMSCa9pSV
        4zSaxFjFziPh+BYX+TWbVN9sn/v35CaUKuYjC4uTSyJ9Y6y/zNqaO6KjVcoGw9qPiIMW23OLVwk7/
        F0l/OQWHeh8z5zWlNQW5IT6UdISh7oBL11c7j8ZYgTsL/NgXKaTsijZQDKf3CA31dkllARhW3G+Fg
        Hp06KLzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qicE3-000GGV-5J; Tue, 19 Sep 2023 15:01:19 +0000
Date:   Tue, 19 Sep 2023 16:01:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Daniel Gomez <da.gomez@samsung.com>
Cc:     "minchan@kernel.org" <minchan@kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "hughd@google.com" <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 6/6] shmem: add large folios support to the write path
Message-ID: <ZQm3vywitP+UdIHF@casper.infradead.org>
References: <20230919135536.2165715-1-da.gomez@samsung.com>
 <CGME20230919135556eucas1p19920c52d4af0809499eac6bbf4466117@eucas1p1.samsung.com>
 <20230919135536.2165715-7-da.gomez@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919135536.2165715-7-da.gomez@samsung.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 19, 2023 at 01:55:54PM +0000, Daniel Gomez wrote:
> Add large folio support for shmem write path matching the same high
> order preference mechanism used for iomap buffered IO path as used in
> __filemap_get_folio() with a difference on the max order permitted
> (being PMD_ORDER-1) to respect the huge mount option when large folio
> is supported.

I'm strongly opposed to "respecting the huge mount option".  We're
determining the best order to use for the folios.  Artificially limiting
the size because the sysadmin read an article from 2005 that said to
use this option is STUPID.

>  	else
> -		folio = shmem_alloc_folio(gfp, info, index, *order);
> +		folio = shmem_alloc_folio(gfp, info, index, order);

Why did you introduce it as *order, only to change it back to order
in this patch?  It feels like you just fixed up patch 6 rather than
percolating the changes all the way back to where they should have
been done.  This makes the reviewer's life hard.

