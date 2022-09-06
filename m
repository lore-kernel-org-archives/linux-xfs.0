Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A317AECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Sep 2022 06:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbiIFGsD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Sep 2022 02:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiIFGsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 02:48:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65846FA2A;
        Mon,  5 Sep 2022 23:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oFuTZk4zKE5mAVI0W5HcV1QEwth0M1OUe/8JfOFc7i4=; b=qu2isCifsZ2DAo2Q5ZJ8unnHj8
        lYJqoyJRc11lTwpPaUNVLA+1+Y87Tvpx76OepMVZu+0gIu/+vIuNEeff37Z4KS8KT//T7tAbGaLko
        XyDJaWYJhzxKG8CK4N4THMRd/2w88PEn3nJp0mia12EUesXoFRN4lHfipW1PMHBt6cJA88nJzgmQv
        XpF7iA46K9x9Mp0blxVRAOYNNICAbtjNtF+rYr+zfhmIpxZDK4CKNHRp6VKJpXp5gwGZFE0pc2KY9
        WGnsJmMDwaaAi+FpCAyEsH5JCqI8U2PJBGjMc4jwhsPw+cHPHYzJolat+Lpf3slGwBhEmDxRmrJ58
        M9K8XWLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVSND-00AXVf-Qh; Tue, 06 Sep 2022 06:47:51 +0000
Date:   Mon, 5 Sep 2022 23:47:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>, Jan Kara <jack@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] iov_iter: new iov_iter_pin_pages*() routines
Message-ID: <YxbtF1O8+kXhTNaj@infradead.org>
References: <20220831041843.973026-1-jhubbard@nvidia.com>
 <20220831041843.973026-5-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831041843.973026-5-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'd it one step back.  For BVECS we never need a get or pin.  The
block layer already does this, an the other callers should as well.
For KVEC the same is true.  For PIPE and xarray as you pointed out
we can probably just do the pin, it is not like these are performance
paths.

So, I'd suggest to:

 - factor out the user backed and bvec cases from
   __iov_iter_get_pages_alloc into helper just to keep
   __iov_iter_get_pages_alloc readable.
 - for the pin case don't use the existing bvec helper at all, but
   copy the logic for the block layer for not pinning.
