Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB35C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 12:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiHKMhb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiHKMha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:37:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B991F2C2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 05:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l7rg5RLk+bMZZ59k2IionIn3vt
        SqKt8v2M9P/A8cq41MMZDgWzQsoCpPs/5pLdVynezpQmhqfy6NzO2kDy/DpRD/3bxk/Vp8QNpVMnj
        ub59t0CkhpysYhEv7RE05jDHKrhu31qBoHhLRNxXpvjeS3C8AA343tEb2Az9XX1Xwq4Kpmhl7MFqp
        tp1YyelMRR40KPW21IilDQudO+bNKnoJFYFv4rkZ4azdVRkdkh1KGNaZUbJJLPSYFE9Om9v4NxaSS
        rMzcoTUUHdP6C9xDkleUrt8oM6UHsQ0D28JRTARmtJIOdWWh2Kq+MqcFa7LQDzlxf63kNDe8PD7oF
        BkV4qkAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM7RG-00CAX5-J4; Thu, 11 Aug 2022 12:37:26 +0000
Date:   Thu, 11 Aug 2022 05:37:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: fix printf format specifiers on 32-bit
 platforms
Message-ID: <YvT4BojMgNOomRfl@infradead.org>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
 <166007921188.3294543.15116997712558160181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007921188.3294543.15116997712558160181.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
