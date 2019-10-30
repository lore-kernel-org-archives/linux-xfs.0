Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128F4CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 14:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7AE42087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 14:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UgyoGHaq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfJ3O0W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 10:26:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfJ3O0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 10:26:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nhztzaIsS/uHsRljaQMJ2sHAvtAOwKAp+LP1aH+6tkc=; b=UgyoGHaq/HDrz17zVIZzMKsj56
        9N1Lb1IoztW+mx5ukU0XqkFZv9Ew46DGrVK+XdyZqTgd1uDbTx/xCyTsw4N1jHQB20X5F7kC9fuHN
        FfK0L+e9cLe/BYrV5L8bcROca4O4nY2cdlIfCjIHTr10Dyt1d8a3ZA4hSobnJESH166VA2oB6kBHn
        3u8V+qDR44Kpr4j7g7VJQmiA1iGZb+kLwXXqTDwKQozeu2W4qm3ZAZDN/bue7hwkOszFvYX1tfp4r
        8EUNxanXmCjM4rNYCQKgv/FQV5ZaC2feOgosixlkdK+xIJ1P0MlyiZKaoAZ7EUM8j6fpgqU+mJu4J
        vsXB+8gQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPovW-0004GX-12; Wed, 30 Oct 2019 14:26:22 +0000
Date:   Wed, 30 Oct 2019 07:26:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191030142622.GA10453@infradead.org>
References: <20191029223752.28562-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029223752.28562-1-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, I've been pondering multiple times if we can kill off i_dio_count
again, at least for iomap users.  I've added in the request of Thomas
how want to kill non-owner rw_semaphore unlocks.  But it turns out those
were needed in other placeѕ and have been added back at least partially.
I'll try to just use those again when I find some time, which should
simplify a lot of the mess we around waiting for direct I/O.
