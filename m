Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF824C3A59E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 07:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B125B20874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 07:52:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y4wPlm+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfHZHwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 03:52:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfHZHwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 03:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/Yo9oHfHHP4WjW/xa6RCiTYv+abbVI1JLNlYgbSzwWw=; b=Y4wPlm+i66mlhUu3r2LqOg0hUK
        fSkoB54TQ5nTfHfczxeIWGe8byyaj4IkBWm/gFxRH7UPskFNMh3e2XQ0QxGuncbSqtGusHTbwloPW
        Q/iPMUVC8wrkxnw3wA9cUQFAdjyhTfQtXExXnhMueVWeaGjIXrPnNnG9r8PbmHNL1GDR3lAhEJj3p
        mi0KKLSaOtoRK/GCY8FmRRLVYs1JOXIotUv2A4sIDsevJe6ozafH1WY+Hrx3oKlTiFF+lM7cfegT5
        UCVnqAmP4UpF8/5H9E7QNx6B1z07N93Qs6AMMQq6ecVu5LLA8bZTi7qERDhmc+cMBIbTh16XxVNo2
        buY1GZzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i29nV-0006hM-1u; Mon, 26 Aug 2019 07:52:17 +0000
Date:   Mon, 26 Aug 2019 00:52:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: add kmem_alloc_io()
Message-ID: <20190826075217.GC20346@infradead.org>
References: <20190826014007.10877-1-david@fromorbit.com>
 <20190826014007.10877-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826014007.10877-4-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	if (ptr) {
> +		if (!((uintptr_t)ptr & align_mask))
> +			return ptr;
> +		kfree(ptr);
> +	}
> +	return __kmem_vmalloc(size, flags);

Not that іt really matters, I'd write so that the fast path is the main
return:

	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
	if (unlikely(!ptr || (intptr_t)ptr & align_mask)) {
		kfree(ptr);
		ptr = __kmem_vmalloc(size, flags);
	}
	return ptr;

> +		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> +		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);

The int vs an unsigned type here looks a little odd, but I guess that
just propagates from queue_dma_alignment.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
