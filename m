Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538BAC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDEFA22250
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 09:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="exqFCYYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388814AbgJOJtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 05:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388789AbgJOJtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 05:49:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2001C061755;
        Thu, 15 Oct 2020 02:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jH4hxqblbxrM90Ai3bxxnVnZ7lSgxnnL4RvCWur4iNE=; b=exqFCYYNYUmeZwdJ3EDnOfTOEa
        TIz+jhh+O8BzqqtwRLgZxSD28kOhrj7r2+/gvBKMnl6Vnaweulb29IpD+RmIUZXxSXGowRmWMgv15
        iKLcEFZgS9YlkvUgmhQrkJ3bn9HdwcAbuyl2gzHP3Rw1xGB6ruvNVzSg8BJ+HWeWpL/PUERDOyZhR
        C4GV80x+Cwq6TW9qCkh6sfBEpORjy5XM0uEZRfKdAYJHrpf3VzYgtY1zj9Ym7Jz3BytjKZ4Ufc8n3
        vRxfwb5DA+K3yNKiFHlM3Z+o/U1TXXcICjF0dG8wU/qXA6PqqY2m94iMrjvvsiCxdufYgZWNoR8/d
        kakZhkJg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSzsb-00064G-I2; Thu, 15 Oct 2020 09:49:01 +0000
Date:   Thu, 15 Oct 2020 10:49:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: zero cached pages over unwritten extents on
 zero range
Message-ID: <20201015094901.GC21420@infradead.org>
References: <20201012140350.950064-1-bfoster@redhat.com>
 <20201012140350.950064-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012140350.950064-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +iomap_zero_range_skip_uncached(struct inode *inode, loff_t *pos,
> +		loff_t *count, loff_t *written)
> +{
> +	unsigned dirty_offset, bytes = 0;
> +
> +	dirty_offset = page_cache_seek_hole_data(inode, *pos, *count,
> +				SEEK_DATA);
> +	if (dirty_offset == -ENOENT)
> +		bytes = *count;
> +	else if (dirty_offset > *pos)
> +		bytes = dirty_offset - *pos;
> +
> +	if (bytes) {
> +		*pos += bytes;
> +		*count -= bytes;
> +		*written += bytes;
> +	}

I find the calling conventions weird.  why not return bytes and
keep the increments/decrements of the three variables in the caller?
