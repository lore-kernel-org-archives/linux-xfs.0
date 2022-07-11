Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1BCC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiGKFYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGKFYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:24:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78358A1B8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z093A167oaUjTi/vZuL9PyrWcQ
        n2FBBAAG8oS8F6IWqw8+A+rF/py82fTLqrSPVWNMVfqfyFkrcSvLA4dAEkRekcKI7JVIe+rhjvCwg
        z2/23py9GBvvS5ZpUq85MArImJMHwZRfMVAk58w93TYf7NBCFmQzDjogGjApWHSruoU7uwDtrXq6A
        BzcqKlONdqsLK2ZBa5Kuvp5TOZvboZfCBSlx6YSO8wTbzzaqpl5SO2EBgo+IBfGWICYQimKP0frTu
        5GIVwrDTNWj41vUK3jsTp9IoS3lzgrxnkvQcUe8YuqLaeHFudQpePFZnl4hSmnViN4OsqlbCXrdg3
        fTA1+1DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlu2-00G6fw-5k; Mon, 11 Jul 2022 05:24:14 +0000
Date:   Sun, 10 Jul 2022 22:24:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: add in-memory iunlink log item
Message-ID: <Ysuz/mFiT0ZgV4W3@infradead.org>
References: <20220707234345.1097095-1-david@fromorbit.com>
 <20220707234345.1097095-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707234345.1097095-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
