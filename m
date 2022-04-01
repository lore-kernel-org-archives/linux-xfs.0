Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413FEC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 12:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345695AbiDAMFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 08:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiDAMFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 08:05:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43B3269A7B
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 05:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oc+H3s3bk64oTElOhZiXM55q5x
        6yiiO0HjcIMYyI5D56RUQWk+xH7eIV+8P25b0Ax97tk+wtWQnZILAwfQjzKGrI0GQkXjn2EeoKWYW
        M7aNp185fdR9GE6wWkd7olMQTafUS2YRVicJLEtap+Rc9ajjrsjPghzWt7KUPSDnvIvk1rgnxUnM9
        vtr8jGGyt2SQBNLqnRqP+ce4B2/HCHM9AJ/mlMcaPkLaOxQfmP7aEchcwdsLFPwjIedFCrWoGvGMG
        NmiKZFfxmYW85vORkGbZ/PYiT0midH4xajc7NWDNrBe3Y9MLcigAtvievxJBLCX2IDVxXc0rqNO3G
        nJ8ie2EQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naFzm-005UsT-Ff; Fri, 01 Apr 2022 12:03:14 +0000
Date:   Fri, 1 Apr 2022 05:03:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: xfs_trans_commit() path must check for log
 shutdown
Message-ID: <YkbqAh7cmp4A4BrY@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
