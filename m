Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F1DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 21:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243112AbiECVsN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 17:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiECVsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 17:48:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431F441625;
        Tue,  3 May 2022 14:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3kZQrcKSvNN25QXUtIV/pIqvcz6ABm2ldpp+seuRKQQ=; b=v1Z2vq+0O/BU3lhpTEQ/+ksIrc
        ai2fo/xQD4c6ky1atjbCvqWwbZDGkTk+ffBBlbiCXw1ZpTrKrmkyI9gwvE8/3aWrd/Cw/9k1Zj011
        nY610TVYLU+W1ftZ/IviINRRqPPavG4zlPn9EBpgYaiUwm9b5Wqj7SUy3s+Gb9zWV+iNs9zV/ioar
        wgICiH1ebX2Sv24OuVN0ao5AxuMhxZ8JXDXpq2/k2elxgvgF4zdWVgYn2ImYGeocUrfUWYeHa7aBs
        vg0yxQaCQHYpc5Ft4xGjTqrhZyj2XWYRasPRW/szCmUZptGiN35m5wpHKEXYzMMnHyt191c/2CkWS
        zV1LJnOw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nm0Jl-00Fz8T-8v; Tue, 03 May 2022 21:44:25 +0000
Date:   Tue, 3 May 2022 22:44:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: iomap_write_failed fix
Message-ID: <YnGiOVCSfHP0iOBo@casper.infradead.org>
References: <20220503213645.3273828-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503213645.3273828-1-agruenba@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 11:36:45PM +0200, Andreas Gruenbacher wrote:
> The @lend parameter of truncate_pagecache_range() should be the offset
> of the last byte of the hole, not the first byte beyond it.
> 
> Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")

Hm, yes, this is _true_, but it's a fix without importance (except maybe
for an overflow case?)  Look at the condition this is called in.  We
aren't punching out an extra byte in the page cache because we're
punching beyond the end of the file.

It should be fixed because people copy-and-paste code.  But it's not
urgent, and doesn't need to be backported.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8ce8720093b9..358ee1fb6f0d 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -531,7 +531,8 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  	 * write started inside the existing inode size.
>  	 */
>  	if (pos + len > i_size)
> -		truncate_pagecache_range(inode, max(pos, i_size), pos + len);
> +		truncate_pagecache_range(inode, max(pos, i_size),
> +					 pos + len - 1);
>  }
>  
>  static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
> -- 
> 2.35.1
> 
