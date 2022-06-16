Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84C1C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359438AbiFPHfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359579AbiFPHfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:35:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302DE54F96
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RJSmN5b8WxQWzFGKhV1s65UNgd
        O9OsGki9zWLnqwGQ/6oKTVygRPuYejNX+6YoGKAR8Z1uy57I8ZNIhjIjjbH4rcjDMUk3BBAHSXT5R
        m/MTzCJZA6owYGY9ETMMZtD58c56InIlkEReuW0BcD620QFHI/tUIS4aE0NU/J2fOPHJivSU1vifd
        ACtVn3zA4jioN6wJQGUPEQmOriRWy/IYP2WifKmCLa1ysOCOSePyQHYCjVZr0ze7VOgZHNykXMKRs
        URyQZxe/gAXY+8USa6RUt85gScp/zUJbWaJCeUmiJKb/ii9KwPmPIJXq7xnrwIX3SWEu5R3j1KY/R
        eS1MMYHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k2C-0015Iz-Od; Thu, 16 Jun 2022 07:35:20 +0000
Date:   Thu, 16 Jun 2022 00:35:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/50] xfs: kill xfs_alloc_pagf_init()
Message-ID: <YqrdOGN7Wj349iSv@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
