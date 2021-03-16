Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E35C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DBF065002
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 08:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhCPIga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbhCPIgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 04:36:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FD6C06174A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 01:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2cuaZJGV4WgNGZkRxuRNt3QK51TzHdm6qcbbBM1r3/A=; b=F4CW+yPvl2gFFwHkMMWFxruBKG
        udKgx8RWItjNRXDq0nf3SkP/CVTv7Wy7ZCNocRWCM9jpa2I/S1JaMutOvqs9iZujJ9aqVVVnavHtU
        7xXpf8hN4h7nbgETMNFxy2741fgza3V99DPbLGcmqEQZxKgN8xUbtm0qbAC00rnDDqHDwmOqpcxfI
        EeDBjV5vDqlgV7Eh1NgsPyPineRTJ28EeAnvilXYwHl5XSnt00DMHkC6uJ3UEQcWn6uUoDJ3CwXAh
        OJKGnbHqHSZz4nAWwMD9qbJwD/Vewd9ABTeNq6zXsYI75eBOnJ6G87S4QiHbgh3Za0GJrwlAXKr3/
        vB4QdoTA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lM5B7-001fdq-DD; Tue, 16 Mar 2021 08:35:53 +0000
Date:   Tue, 16 Mar 2021 08:35:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/45] xfs: initialise attr fork on inode create
Message-ID: <20210316083549.GA398013@infradead.org>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'd still prefer the xfs_ifork_alloc to be separate, but otherwise
this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
