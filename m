Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E59C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiF2HMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiF2HMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:12:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F82EDFE0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TEaLQbm7/qAHGbvc3imlxgQjD3
        c77L9n3bvAjbhWnLYwmTfKces4blPov9jR21QOb5gIRkseSZPpSbriztd1MigMhb2UCeYcvUlH4vW
        SryYsc1a9Lf8v3QK43Mgk/Pf9wFXVT569hhERtWKkZ++kBz3q16pPZfZ/fnV2L7Tj4bW5BvM71/HZ
        pMKvIcjcsqGqs2+7RJmlq+7YvAtS48/8rs4xXZ9AGgcrgYgTK1fE5pdJCA4UiPVACASwABoAlPM86
        ttAhZ60xcRrrQZKormDYwGsbNLypCKV9x8pT80+bAAzvbHrVeca75m5OkrW2xXa2rLbJa+Belg9lV
        i9IS9MmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6RsO-00A1ku-Us; Wed, 29 Jun 2022 07:12:40 +0000
Date:   Wed, 29 Jun 2022 00:12:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: refactor xlog_recover_process_iunlinks()
Message-ID: <Yrv7aPaBiYm5ajcU@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
