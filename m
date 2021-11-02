Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6E7C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 07:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13AB60C41
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 07:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKBHQY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhKBHQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Nov 2021 03:16:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D755EC061764;
        Tue,  2 Nov 2021 00:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kSthjGL7SDopyUnpB9YVlk25Gn
        EaU55W6Bh3y4pFw4pa4kHzimIPnGzDiG3xmvv0oHWUE2siAMuydilqdtcCYoDcOGTUi1Gib88a/sV
        V9+Jn/646XGT2gy3zTDrXCNx+Fg/vco8j/5b/Z4/mxKtPpj4kqwHRy5ZX+aw47vJ6OYn1y5EfQVoP
        x0AqGlimnDenQDO/s7Q7EIi+tXdu5rOECVh3OuyrOUd7X66kK0m7XjWsPvdpl74HsR7d3QN7Gbnm0
        RKuq6suYARqQ+E0iqDSqDga+FSc2U0pSKHog+6SpMvR/8k8uo8VU4Cr2GFE9hu1ka84y0cWCR/9zC
        /gK79AxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhnzM-000jnG-VD; Tue, 02 Nov 2021 07:13:44 +0000
Date:   Tue, 2 Nov 2021 00:13:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/21] iomap: Convert to_iomap_page to take a folio
Message-ID: <YYDlKENvT0JODCg4@infradead.org>
References: <20211101203929.954622-1-willy@infradead.org>
 <20211101203929.954622-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101203929.954622-5-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
