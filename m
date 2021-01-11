Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D04C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 261C0225AB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387985AbhAKQQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732697AbhAKQQn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 11:16:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17706C06179F
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 08:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=lSZD6js3BLYKHlDDRKGP95veYWFEuPefwvLli4bCx1k=; b=JwXkAyqJFGppzTKtsPL3m29yab
        ZE3X/iZ1ZmigumDXkCRVz2Bdb2nXsqgaoJRhXF/L5Hjm6ffSpSmfPMidOOvwjFSuMTSnMD/2Xspl1
        H1j7POIfu5TstLfxrEDiaERXKEUeQxRSa96kmUn3itjWw5wB4Ly24wTdy4IldzDm6faxbYwyB1AI9
        BcJNMTOGi9lrbouMAQS1Msvva6fAcjH+qonj1g4WKqrcS00Fis0+Ji41MOnEAA7ESzhp1DrklVwMi
        L7QMfcesils+nKp2avStTkWUXsN8+c6zh3riL+bNGNvXk8T0BqhCjd63QPPQZRor4A39arLo1rmmD
        DfFOE3qQ==;
Received: from [2001:4bb8:19b:e528:814e:4181:3d37:5818] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyzrE-003Tmn-PJ
        for linux-xfs@vger.kernel.org; Mon, 11 Jan 2021 16:15:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Date:   Mon, 11 Jan 2021 17:15:44 +0100
Message-Id: <20210111161544.1414409-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111161544.1414409-1-hch@lst.de>
References: <20210111161544.1414409-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the inode is not pinned by the time fsync is called we don't need the
ilock to protect against concurrent clearing of ili_fsync_fields as the
inode won't need a log flush or clearing of these fields.  Not taking
the iolock allows for full concurrency of fsync and thus O_DSYNC
completions with io_uring/aio write submissions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 414d856e2e755a..ba02780dee6439 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -200,7 +200,8 @@ xfs_file_fsync(
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
-	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+	if (xfs_ipincount(ip))
+		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 
 	/*
 	 * If we only have a single device, and the log force about was
-- 
2.29.2

