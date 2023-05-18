Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A07C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 18 May 2023 22:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjERWEj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 May 2023 18:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjERWEi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2023 18:04:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C971736;
        Thu, 18 May 2023 15:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=se9osx5DLxA1TGKtkzhQNgYarl0trlRDDGYH2xdZOhY=; b=rNgWM9ASyIQONmE4qc8JX1txi8
        3iO9tS50dsO29PM5YOpsHB5T0qUpVX6tZBqvTOWpGpc+eA7Q9/ti7rmNaV8/gRbVCfAapLSavBGFu
        MVH5EVeFkkWWlBtilnZCdCWBjt2GqE53lVCA5ew99Blr9JT0oc1fEFfOkvzdf8AJ9yldiLN1vxugQ
        S9HwF0B1MFWuJwhFYAZ82cCRYIqc1W43BmFBtGnUpAo+IZQJWy4fefOKJn/8yHMNUDBcgxotFqpYR
        ywW2fs4kOtnV/uB3HW48JExyKviV229lil5nrEkyluX7uXiwgvDwy4drvbWSqL7YdU42FGPIQkLL3
        fznkIs3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzlip-0066ZL-Ot; Thu, 18 May 2023 22:03:43 +0000
Date:   Thu, 18 May 2023 23:03:43 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Creating large folios in iomap buffered write path
Message-ID: <ZGagv+dXx9xwuBy9@casper.infradead.org>
References: <20230510165055.01D5.409509F4@e16-tech.com>
 <20230511013410.GY3223426@dread.disaster.area>
 <20230517210740.6464.409509F4@e16-tech.com>
 <ZGZwNqYhttjREl0V@casper.infradead.org>
 <ZGacw+1cu49qnttj@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGacw+1cu49qnttj@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 18, 2023 at 10:46:43PM +0100, Matthew Wilcox wrote:
> -struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos)
> +struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>  {
>  	unsigned fgp = FGP_WRITEBEGIN | FGP_NOFS;
> +	struct folio *folio;
>  
>  	if (iter->flags & IOMAP_NOWAIT)
>  		fgp |= FGP_NOWAIT;
> +	fgp |= fgp_order(len);
>  
> -	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
> +	folio = __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
>  			fgp, mapping_gfp_mask(iter->inode->i_mapping));
> +	if (!IS_ERR(folio) && folio_test_large(folio))
> +		printk("index:%lu len:%zu order:%u\n", (unsigned long)(pos / PAGE_SIZE), len, folio_order(folio));
> +	return folio;
>  }

Forgot to take the debugging out.  This should read:

-struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos)
+struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 {
 	unsigned fgp = FGP_WRITEBEGIN | FGP_NOFS;
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
+	fgp |= fgp_order(len);
 
 	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
 			fgp, mapping_gfp_mask(iter->inode->i_mapping));
 }
