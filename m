Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC0CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02DA122AAD
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbhAKQNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbhAKQNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 11:13:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55C3C061786
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 08:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2IB5u/+0MMlSth10imzyhQUSsRz4eoLazCf021+MYxI=; b=VF0N6MLYZSyxcsmpZKWGo9517D
        tJx1DTcTQnJZo2ht7cSkONxzHRr309WPbzfgzQp5m0UyuO0E5owbcQaLuO/wd50o9ZmbO19Ed6QiP
        2NfVsy2MZRWzXdeDI5uxAQxiFVml2aHq/wLiAiqoVFETDDtxB1cvj0R9Iaz4tYor+zGtfVQknwrjh
        4EiZHDZ/roUe0eFJZ4YdH37dclbXQQmPU5Uhp3gskO7edF9N3YMrC7MXkRNcNANXGF6shf/cZ5xRf
        IniimKjTOhlXL+IZJ704opeoAQQVa2S5BtXWeWcetD7nUk/wfmdfX/6njVKNBNUIdqOFIp/2UJofV
        twzgBeSA==;
Received: from [2001:4bb8:19b:e528:814e:4181:3d37:5818] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyzni-003TUX-C8; Mon, 11 Jan 2021 16:12:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Avi Kivity <avi@scylladb.com>
Subject: improve sub-block size direct I/O concurrency
Date:   Mon, 11 Jan 2021 17:12:09 +0100
Message-Id: <20210111161212.1414034-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series avoids taking the iolock exclusively for direct I/O
writes that are not file system block size aligned, but also do
not require allocations or unwritten extent conversion.
