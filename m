Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0064EC43381
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 16:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCAC422B2B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 16:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404607AbhALQ20 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392529AbhALQ20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 11:28:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F2C061786;
        Tue, 12 Jan 2021 08:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EIuSsvmI6Ar5WcXlcu9UR/Q9+1uVv6DO3lYSD+J4NiI=; b=W1RbhT6oO7Try5iMxEijtDnfrJ
        kpHLsto2nh3gnO9WBeXNzCuKhSoEBWjtg4Stz64XnlNXMnWnjAIoMc3/78QO1jwOmqiGqHorHYXkT
        IHP6FBmxgRCxjzkhDmqtjTIP0jpe2caIborcb9DbvDw2IFtwJw3XMG0ecd/ZqVOSPGcz3TXkKPyiW
        V99UUIk8ZTN8aIhYpLWOEkyHAOXKp6R/1hkqNw6vo8mmx4mOSRa4SC4L2ltJNIMJdICShMzaMQAV+
        xO/GRi3qMXkUcN7u/bdTSsyc++Mk9NMdQEJt4kPIvk5kpC0lE+S1tD46b2fhILWXp5Nag0ybeeSb3
        2Fpr2XZA==;
Received: from [2001:4bb8:19b:e528:5ff5:c533:abbf:c8ac] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzMVn-0052CM-E2; Tue, 12 Jan 2021 16:27:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, avi@scylladb.com
Subject: [PATCH 04/10] xfs: remove the buffered I/O fallback assert
Date:   Tue, 12 Jan 2021 17:26:10 +0100
Message-Id: <20210112162616.2003366-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112162616.2003366-1-hch@lst.de>
References: <20210112162616.2003366-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The iomap code has been designed from the start not to do magic fallback,
so remove the assert in preparation for further code cleanups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ae7313ccaa11ed..97836ec53397d4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -610,12 +610,6 @@ xfs_file_dio_write(
 out:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
-
-	/*
-	 * No fallback to buffered IO after short writes for XFS, direct I/O
-	 * will either complete fully or return an error.
-	 */
-	ASSERT(ret < 0 || ret == count);
 	return ret;
 }
 
-- 
2.29.2

