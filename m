Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483C4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 07:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B78761264
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 07:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhKKH6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhKKH6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 02:58:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35F7C061766
        for <linux-xfs@vger.kernel.org>; Wed, 10 Nov 2021 23:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mTYzkEjxdYFyKyDmZKCVp1pNANyh/oF5MdCQ/ei2QOY=; b=j2dMyRwcLkPLjU32npzpHyq4Cs
        GSgnF1SJ+GgYw3aRoPtXMTPE+aAHh2PoW1o693PjXONNKGShREl+XSSuEp2aacvoQBoXWQ40mjvYJ
        J6le1qizEzsAtKL397WvQrq/kmgmQstleJxCJpjPEfjjhbXefU4Rfs682CJE5ldf96HwtDIhpgKdT
        GRu8aBn5nKwlaGxQDZ9Gp6LP/IxOR0yVlFcjE53phFrshSpFQIsx81MMO8R3vkpgzj7ImbwL1RRyb
        rL25NRl4augszQnKbaCZHQYjKZRwg0+tahQXQNky1PdS8yTNgxfI3Cjah7Bm6ayP06GRNKF07YIxc
        Z3FxE1VQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml4wA-007RYK-Jb; Thu, 11 Nov 2021 07:55:58 +0000
Date:   Wed, 10 Nov 2021 23:55:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: only CIL pushes require a start record
Message-ID: <YYzMjlKMbS/TjWU9@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  struct xlog_cil_trans_hdr {
> +	struct xlog_op_header	oph[2];
>  	struct xfs_trans_header	thdr;
> +	struct xfs_log_iovec	lhdr[2];

I find the logic where xlog_cil_build_trans_hdr stuffs oph[1] and
thdr into a single log_iovec rather confusing even if it is correct.
But I'd also rather get this series in and see if it can be cleaned
up later, so I'll just leave that as a note here.

>  	struct xlog_ticket	*tic = ctx->ticket;
> +	uint32_t		tid = cpu_to_be32(tic->t_tid);

This needs to be a __be32.

> -	hdr->thdr.th_tid = tic->t_tid;
> +	hdr->thdr.th_tid = tid;

And this needs to keep using the not byteswapped version.
(but it appears we never look at the trans header in recovery anyway
currently).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
