Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F808C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 12:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02BC0610F9
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 12:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhDHMRs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHMRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Apr 2021 08:17:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17281C061760
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 05:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9yyRvYtARg2P1C1ect+kQdkcuyyiiZaG04T5yPgzTpU=; b=ABT6RxH+7wJZhg3bEB/wBPrjrY
        qQtq5rXA7C0X4oN9ZTIulYOkpDqEUeTey2ERnGmSedrjYB2IYsMwjH5XGl6MgUBPjsYD+RcFD8yBY
        4YGu0Lqsoc8vssMZgCVPyuU79Sq8vJDkM5b0mHYCzbjf4qY5syRHeu9HKsuaE3O7yGmziLCRDiJBE
        RRSrYjxWUbFaPjE5NhFqaE7cpe2e37Cnzv/4YeMzOruDqabwcNa52YhAKMy04rqkFhl0bN/aij20W
        QmrmJsIL8qWIA8Moy7t2GIo33c+QGid230gDpOzGPdgz+Ax8JgZ/vjEIekQbqz6NeObRq8/8VMR3e
        cnrhhyTw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lUTbH-00G9Fa-0X; Thu, 08 Apr 2021 12:17:32 +0000
Date:   Thu, 8 Apr 2021 13:17:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix scrub and remount-ro protection when running
 scrub
Message-ID: <20210408121731.GA3848544@infradead.org>
References: <20210408005636.GS3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408005636.GS3957620@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can we use file for the variable/member name instead of the weird
filp?

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
