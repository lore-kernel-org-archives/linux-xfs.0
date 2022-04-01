Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E16C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 11:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345602AbiDALt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 07:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbiDALt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 07:49:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702FF216A6A
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 04:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rZzoub8zbH5INBW68VNQJ3aSd7
        PEURDBsAT+S15kdYef9388Qq17pCA2cqFCnzJYzGbZAVf46KtQw4ZJKmDFv2MamaswKLlMxWwE4Qs
        ZJ4U0FIuOAfCrAuzudgCKE1ZcPtLir9N8YXh+uETndBapEFqXgG9kbBDufEIogmt5WH2tECQIFOHp
        vbJDqxGqPjFgCvJOIPJV5meLMtrVzXoZIxHD9QQ1seGWXLd8z2wqyxasjVb2n8QNn/kevUXLH9d4K
        OenPVVaRn2vTSQNOi4+hRGbqwHhGwyYgo36K6oq8ttYgTWlBbKksyWJcwjtiWa/pK2xPVKKIz6MZ2
        UpsZ0+QQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naFl9-005P64-32; Fri, 01 Apr 2022 11:48:07 +0000
Date:   Fri, 1 Apr 2022 04:48:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: shutdown in intent recovery has non-intent
 items in the AIL
Message-ID: <Ykbmd7MUwUZL0IoV@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
