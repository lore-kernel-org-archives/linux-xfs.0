Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B540CC5519A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 00:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 915B0206DD
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 00:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hw2aeXyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgD0A0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Apr 2020 20:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbgD0A0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Apr 2020 20:26:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88C9C061A0F;
        Sun, 26 Apr 2020 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jjLax//BuDpcxDOp0BIVWUJX1J9XOhT/8ZfdvTzz92o=; b=Hw2aeXyu3FsC+Q372WpXkATaex
        FvPS6iGK0xDCYad8q6fw1GYeNEx6EmMEistGAxt+5V34HsLdbj40Bfam1LpkEzqAM48+eAgHho/RI
        CSyCL+zb1KfJL+J9Bx4Anvz2AfF6gyJRkRe97gnytDocZLltq6sB/BCiqXW5uWFfMQ0H1igNtiQVn
        kgq5/Xpj02pSBATAnm6qHf1MynPDlCkTmJD1HZcbu/nQCAgXOsey4eOiNr849JdtWiR6Zw7geMiRh
        iEORVdfFaVPtT51aQoN2VjMcZOcTaEL1wR08exNgTvApTItQ6ADjnL0Y6DLP0ztm+tCFFrCAUxrNT
        Hc2XCbrQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSrbT-00049E-Fj; Mon, 27 Apr 2020 00:26:31 +0000
Date:   Sun, 26 Apr 2020 17:26:31 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 6/9] iomap: use set/clear_fs_page_private
Message-ID: <20200427002631.GC29705@bombadil.infradead.org>
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
 <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 26, 2020 at 11:49:22PM +0200, Guoqing Jiang wrote:
> @@ -59,24 +59,18 @@ iomap_page_create(struct inode *inode, struct page *page)
>  	 * migrate_page_move_mapping() assumes that pages with private data have
>  	 * their count elevated by 1.
>  	 */
> -	get_page(page);
> -	set_page_private(page, (unsigned long)iop);
> -	SetPagePrivate(page);
> -	return iop;
> +	return (struct iomap_page *)set_fs_page_private(page, iop);
>  }

This cast is unnecessary.  void * will be automatically cast to the
appropriate pointer type.

> @@ -556,11 +550,9 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
>  
>  	if (page_has_private(page)) {
>  		ClearPagePrivate(page);
> -		get_page(newpage);
> -		set_page_private(newpage, page_private(page));
> +		set_fs_page_private(newpage, (void *)page_private(page));
>  		set_page_private(page, 0);
>  		put_page(page);
> -		SetPagePrivate(newpage);
>  	}

Same comment here as for the btrfs migrate page that Dave reviewed.
