Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87686C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 23:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 574BD2339E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 23:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lbBecBZw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfHUXYk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 19:24:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfHUXYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 19:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p2g8wrEX9j9XMSOH5GKO56q2IUK+OOYQEOnb7SagmVs=; b=lbBecBZwmwAcL7bqRJLxSV0Cm
        W66i5NfLXEMdaqgLLrMs+sKHPoUE9opyrdYaSzjVF2tY/zSkEnH30odff8f8sVfMq4Sv6W7rcJKcf
        vYHh932n/rYKbfv+13Fr8NhNemGaZW69jpZWxhOrJHHX1zm92GnSsnZheUi7HfS445r8xojSiqFL3
        XpQSKtf/3CYrcWHJxwsAY6SG5RQcMU17sr7hDOaQTnLeCSjtVh7o9YJAFgRMg5TNPaY/vsQDYbjNp
        0QAYA6K+Ypgln5y6fO0fo3+lT2URU+9AiopStLmHcwsdZpsMyV0vZzbNPvTtfan6HxRtZS8KGVxoC
        npm1cdrEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0Zy4-0000FG-4r; Wed, 21 Aug 2019 23:24:40 +0000
Date:   Wed, 21 Aug 2019 16:24:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190821232440.GB24904@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821083820.11725-3-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +
> +/*
> + * __vmalloc() will allocate data pages and auxillary structures (e.g.
> + * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
> + * we need to tell memory reclaim that we are in such a context via
> + * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
> + * and potentially deadlocking.
> + */

Btw, I think we should eventually kill off KM_NOFS and just use
PF_MEMALLOC_NOFS in XFS, as the interface makes so much more sense.
But that's something for the future.

> +/*
> + * Same as kmem_alloc_large, except we guarantee a 512 byte aligned buffer is
> + * returned. vmalloc always returns an aligned region.
> + */
> +void *
> +kmem_alloc_io(size_t size, xfs_km_flags_t flags)
> +{
> +	void	*ptr;
> +
> +	trace_kmem_alloc_io(size, flags, _RET_IP_);
> +
> +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	if (ptr) {
> +		if (!((long)ptr & 511))

Please use unsigned long (or uintptr_t if you want to be fancy),
and (SECTOR_SIZE - 1).

As said elsewhere if we want to be fancy we should probably pass a
request queue or something pointing to it.  But then again I don't think
it really matters much, it would save us the reallocation with slub debug
for a bunch of scsi adapters that support dword aligned I/O.  But last
least the interface would be a little more obvious.
