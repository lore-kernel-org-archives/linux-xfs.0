Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5E6C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1047361356
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhFPQeh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhFPQeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:34:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CB8C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=W25BuR1Escd7TTD7UYAfVOqUhYXpX4MSwFbBmmv7PL0=; b=k8ffZhYFfdYSAot2SVlFwJ8UP6
        CUG3NMYLgf2PzeNr1F45idCAS61d7rYiPpvNP7rg93nvVMTg7BIXQpQc8ZHBzpwQIcJPHPOleYeTO
        Km9l9XeChvj2mYEIIaCCBbfxZvDAqN3iTYi+kRrYKSSkwKwbFsVjYzbqRH5tzaFJbxFsLLQ6ZBFKZ
        NP2lHDKcBiRKP9wpMEiETdW65WKxo3u6+gMFKeaMb+1S662vZtaKgzhly5Zldvck+oF9UmlSDlzSN
        okCyNjx1nNgAmhhxs+t/8O7F/Olhe3LCCkoq/kOWk6TXF+y8rFAkMxNtemh+fxRERyms9jBo9Za6S
        eCeNTeoA==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYSb-008G0N-82
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:32:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: log write cleanups
Date:   Wed, 16 Jun 2021 18:32:04 +0200
Message-Id: <20210616163212.1480297-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up a few loose ends that I noticed while reviewing
the recent log rework.
