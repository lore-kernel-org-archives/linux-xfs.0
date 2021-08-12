Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29621C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E43260FC4
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhHLHu6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbhHLHuz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 03:50:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2D9C0613D3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 00:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oKi884gXhIk5i3Ok4/nEKdpXplc6i5IIutmKBLnP/sM=; b=YvDutx1/Hwall28cJARbSCqUCK
        K4JMmbqrrsa+Drtv6M3PdAFDRIyjkrgGyLjXEsTDsTfMjGTjDJ2wg0HE4SDmSTL5Pfn3ZqfB605G6
        axdFzJzo7XhuXJY2wkXhz3kGJ+fWe7rm8CodO7op/bOh1X5E7xxyqF0WR6Vy//cfgH85zDqTu8SUo
        fdQMSr0XCsDUwnBenv4w4082mYFxZ1LU+Dx74qBWtqMhw+1mI27Ui5+DZ+GD6WVPITx6Nh4/K2zq0
        iqNZws9rWdeO6nru/PdSzoYYuDuGmXpIMVq1dWgZOO6KQGqCnXn/JWHRSiimnEKwRKafJMAnl2zA2
        4LhGc6wg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5Sz-00EItA-Hf; Thu, 12 Aug 2021 07:49:53 +0000
Date:   Thu, 12 Aug 2021 08:49:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: order CIL checkpoint start records
Message-ID: <YRTSiQz27Prrr8cJ@infradead.org>
References: <20210810052120.41019-1-david@fromorbit.com>
 <20210810052120.41019-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052120.41019-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks fine, although I would still prefer xlog_cil_order_write to be split
over the paramter that makes it behave very differently:

Reviewed-by: Christoph Hellwig <hch@lst.de>
