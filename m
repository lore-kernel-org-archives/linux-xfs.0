Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5448AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiF2HnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiF2HnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:43:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E466C1E3F5
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rqmlm2X3BU2HTaaAs+l9Slb6rq
        T+urBZ54Vd1I06fl88svxLx7pr8hYnUFfAYNn8X3JS9mFmsU7eUoUZbe/isUBMciep7ZnCWT9uqcU
        YzuANVIVZcXnNvsen1aEgcWMJZFaUbKLYscvyettzfJJVnqqDT3RL75/u9RlzoIyS+K3Hn2YQ7y0h
        /DHdyIKfDqPRu3VyDSYvbLVtN37GHdyfQu8YtZusYsPykpFH/Ii3SuMWTcvEfnYvodMSa7NuPkw7J
        deHFEAamRId9HiqoKggzzEL7Wbac6BSkQzmkPtAc1tOHFVPB5wTnL8hurvEAr7AqHKzWGZvHIpedk
        seUNnSeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SM0-00AAbH-LI; Wed, 29 Jun 2022 07:43:16 +0000
Date:   Wed, 29 Jun 2022 00:43:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs_logprint: fix formatting specifiers
Message-ID: <YrwClO+cGuvRGyM6@infradead.org>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
 <165644931754.1089724.16023443761407042271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644931754.1089724.16023443761407042271.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
