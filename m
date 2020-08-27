Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD46C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE53B20738
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WYZeTVhc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgH0IYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgH0IYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:24:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5056AC06121B;
        Thu, 27 Aug 2020 01:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wRVRvBwHw4mKLQT5BkBZOHmTkNVsAilc82JLzdgdiFQ=; b=WYZeTVhcyUgsEJuYehPDTfQeC6
        hdIJ+GHDZ7Lx85RR9NSO7b703Fd8D+0WUXycpsHfrAye2jxLdcvRrKf4CedVG70eq5TN9sbDoy/Ie
        lxGlcYIMfI7tHsWaBRdMIxerlgj3jwMc5mqrifjYZtvcSM1rLfHZTyyaJ8sZB/zvuL3M8wv3zzHnu
        pqOqjDW5ZKIDtXKGLF754ib/kRd6NPyidkl6fR3J5ex535yLT5GDOOQNuuHewALlii+CQ2xOymSPO
        Z84Eko0WFWpIn4//Yz5HWmb0hPbB5vskC1vlUbvk4gO/E6x7QPwaeEL8uPlML7pGiD7XxWcN2QuMa
        VOUcyflg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBDCb-00030m-29; Thu, 27 Aug 2020 08:24:09 +0000
Date:   Thu, 27 Aug 2020 09:24:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] iomap: Fix misplaced page flushing
Message-ID: <20200827082408.GA11067@infradead.org>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824145511.10500-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 03:55:02PM +0100, Matthew Wilcox (Oracle) wrote:
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index bcfc288dba3f..cffd575e57b6 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -715,6 +715,7 @@ iomap_write_end_inline(struct inode *inode, struct page *page,
>  {
>  	void *addr;
>  
> +	flush_dcache_page(page);
>  	WARN_ON_ONCE(!PageUptodate(page));
>  	BUG_ON(pos + copied > PAGE_SIZE - offset_in_page(iomap->inline_data));

Please move the call down below the asserts.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
