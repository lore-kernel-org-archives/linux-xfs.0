Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37010C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 09:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C03BD2224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 09:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BWzZnL2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388981AbgJOJvC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 05:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388980AbgJOJvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 05:51:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2760DC061755;
        Thu, 15 Oct 2020 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=guRr2sUyuNye8RHMu+leAsFkrCOr1xJH+9OoZsxpg/c=; b=BWzZnL2ZCgjHk1D10k3yXEnUCn
        j864aWyaoTwKxdIPtbVRGCiQ43wG9UekS9IwaOTc0uZBnZofKHm68KSXZa9oJOvrGQEspb/GkN1va
        0fN5cFMmsNgvcdkW9EmLw7T/dcLAvIFqM8YjrGqjdmryDkaMkPLteoNpKhQqiU0e9lji3uBIOCoU6
        aG92NZGKSd5HAQIVE/P789PFuDNXJ+bSV5n0aZpcOl/+Wmzup7IY7bNAfs9CtMv54Qykzu5Jt7l3w
        htnaY+eoe2q9sCcxP1+Xjl1YyL4UfiUlWrZRtmGqXTJZXgusUOKnxnXM2oB1MvDocSseafvSgz+ZL
        Wycpqwdw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSzuU-0006F2-PX; Thu, 15 Oct 2020 09:50:59 +0000
Date:   Thu, 15 Oct 2020 10:50:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 04/14] iomap: Support THPs in iomap_adjust_read_range
Message-ID: <20201015095058.GB23441@infradead.org>
References: <20201014030357.21898-1-willy@infradead.org>
 <20201014030357.21898-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014030357.21898-5-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 04:03:47AM +0100, Matthew Wilcox (Oracle) wrote:
> Pass the struct page instead of the iomap_page so we can determine the
> size of the page.  Use offset_in_thp() instead of offset_in_page() and
> use thp_size() instead of PAGE_SIZE.  Convert the arguments to be size_t
> instead of unsigned int, in case pages ever get larger than 2^31 bytes.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/iomap/buffered-io.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 935468d79d9d..95ac66731297 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -82,16 +82,16 @@ iomap_page_release(struct page *page)
>  /*
>   * Calculate the range inside the page that we actually need to read.
>   */
> -static void
> -iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
> -		loff_t *pos, loff_t length, unsigned *offp, unsigned *lenp)
> +static void iomap_adjust_read_range(struct inode *inode, struct page *page,
> +		loff_t *pos, loff_t length, size_t *offp, size_t *lenp)

Can you please stop the pointless reformatting?
