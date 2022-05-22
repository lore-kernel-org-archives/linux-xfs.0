Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7352C433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 07:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiEVHTd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 03:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiEVHTc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 03:19:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3E03C498;
        Sun, 22 May 2022 00:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7PKJsj68IInPVINb0fO3beho68vuOikPK51xBQIehs4=; b=xAsYrHh7Hv253E7T10KyKjM/4e
        IxVhCJ0M1juCWxSPf/LWPFCuGpkPa8PKgqfUm0GdZJjRgXwOMSAGS/e7ADlFVrtsewj7sKEIQYG0Y
        vdq7UinY0Q7KMduTDKrEkMPAYpEXrJ+X99R4QZ4N6w4sld+FyrGrvOaEVwxxcvaKGoaLK6AVySPBQ
        ZXL+dWTwKKaYu/fkHzhM65a4pGeJtYSvkFF6VbbmjP/6zc0YUJuoAuLUoH82cqAGqoONKeQIDg40z
        34ODzw6mRCZD+CFg6TfYtfvHTs1tfGpbVR28NTgiIdg+bzMIkdk6SZclkbDqKTlbfudbFg2A0/7pK
        H7tM3FMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsfsB-000mKN-IS; Sun, 22 May 2022 07:19:31 +0000
Date:   Sun, 22 May 2022 00:19:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 07/17] iomap: Use
 balance_dirty_pages_ratelimited_flags in iomap_write_iter
Message-ID: <YonkAyZvfjHWdzsa@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-8-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 20, 2022 at 11:36:36AM -0700, Stefan Roesch wrote:
> @@ -765,14 +765,22 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  	do {
>  		struct folio *folio;
>  		struct page *page;
> +		struct address_space *mapping = iter->inode->i_mapping;
>  		unsigned long offset;	/* Offset into pagecache page */
>  		unsigned long bytes;	/* Bytes to write to page */
>  		size_t copied;		/* Bytes copied from user */
> +		unsigned int bdp_flags =
> +			(iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;

Bot the mapping and bdp_flags don't change over the loop iterations,
so we can initialize them once at the start of the function.

Otherwise this looks good, but I think this should go into the
previous patch as it is a central part of supporting async buffered
writes.

