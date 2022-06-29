Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D2AC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiF2HEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiF2HE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:04:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387643DDEC
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0dBftAUooIUnO8iGrnGfxPGvAS
        kIoR65TQbsmg+FSajbkg8wQnXuTE3PFHIfVkzlvBbj5B17W4AFC348DaisH1Lq7Msl0CPkCxMQfvd
        A6ToRxtdc+k1bU6SLkGF0scHz5//Smq8KRqyBx3TdbmwCaphzevTYPvh1Z0zYQeuCc/75BzBZW45A
        vebQQVNECxgsXp8NSPoj+7i+zMD3cl5ExpjmRgMF5yPG9x2QffbEHciSS1iP1+4XK8pJVOF3sfEmf
        241dDk95PJo6hHp/DZd06evoPhI36dYD9F4j4mZZJ75cGyMt98H98sP9Kv3SCgh5JVe0KGiztDEfq
        QKfKphbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6Rib-009z0A-Va; Wed, 29 Jun 2022 07:02:34 +0000
Date:   Wed, 29 Jun 2022 00:02:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: replace xfs_ag_block_count() with perag
 accesses
Message-ID: <Yrv5CZY962ojg7Dl@infradead.org>
References: <20220627001832.215779-1-david@fromorbit.com>
 <20220627001832.215779-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627001832.215779-14-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
