Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1FDC34031
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C23D24656
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ErXIBkd3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBTEFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:05:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38694 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBTEFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=oIAKaMKaWwjc/CMNeWyntMZtOjcpNuLvFMtuiJjA3qU=; b=ErXIBkd3BHtwgiGV/x4xUBkfYc
        tW1/4xJ5R04WZstiG/Q34ZLBKyUMVjf8jVDADsk59UzbCF3lx84lb/S2OoC9YD08PTx0NRL3K6GGw
        wiJhVg1m6tStDWDY0LA98DLwcQc36CsFw6uINovNssMssSiWKENUdJAEUeBCS+488bHcTXpvC2tyq
        ibVGTFyVtB8FNPmsXSTnan1HEQRkRs3K1aMSEqi5GvZCeehhh6ZZT8TwSM31MoPdjNgBsYso9LnY/
        Q604Sjre9zWlz6JLOCwjSLCmpgrWx4gCS9qUJVUDi+7j90jKp+c6qI8Yps2sUnI4IJYAClBEaKcyj
        LpO1/xLA==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4d5z-0001Qm-Th
        for linux-xfs@vger.kernel.org; Thu, 20 Feb 2020 04:05:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: reduce dmesg spam
Date:   Wed, 19 Feb 2020 20:05:47 -0800
Message-Id: <20200220040549.366547-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

When a device keeps failing I/O (for example using dm-flakey in various
tests), we keep spamming the log for each I/O error, although the
messages are very much duplicates.  Use printk_ratelimit() to reduce
the number of logged lines.
