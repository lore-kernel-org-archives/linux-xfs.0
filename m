Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AB6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 22:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A6E5610E8
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 22:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbhIBWxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:53:23 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34038
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232013AbhIBWxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 18:53:20 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F22A23F249;
        Thu,  2 Sep 2021 22:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630623140;
        bh=HFc1EgoJvcTCiU96mH1fKfidDkMXe510FYrg9SYSXGA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=PFQEXEg1aR5NUtZ+fnWJT6eJ5xAu8XMoF0KU8VWpuPu4trHeG9p21maZ+IFByW507
         znfVBlS4Z0SZgavdj/5cq674Rtq+/RkLqoqkVjfOIPrObRynSmla19yTQIwUBusBFf
         jaXLUUM/H9bIfHjHttWmufrP0/m06aL6YkxJzmjqM1h5F4a5hZ4GsG2KBuEAcA4yG4
         ShDj3damaVs98yTy0/gu51VTlWXFthZKVCN90cj6jLT7eDYzCV677rDi+kJ4QdQ7gf
         2VftbJC2+siRwj33Kg1rjFZMzLN6fdnJFw+BrkVp5DHgxh+KZz74rzxPjyGtHfpLcQ
         z3P0jwpk7dRYg==
From:   Colin King <colin.king@canonical.com>
To:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: clean up some inconsistent indenting
Date:   Thu,  2 Sep 2021 23:52:19 +0100
Message-Id: <20210902225219.57929-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are bunch of statements where the indentation is not correct,
clean these up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/xfs_log.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6cd2d4aa770..9afc58a1a9ee 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3700,21 +3700,20 @@ xlog_verify_tail_lsn(
 	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
 	int		blocks;
 
-    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
-	blocks =
-	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
-	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    } else {
-	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
-
-	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
-		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
-
-	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
-	if (blocks < BTOBB(iclog->ic_offset) + 1)
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    }
+	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
+		blocks = log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
+		if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
+			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
+	} else {
+		ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
+
+		if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
+			xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
+
+		blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
+		if (blocks < BTOBB(iclog->ic_offset) + 1)
+			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
+	}
 }
 
 /*
-- 
2.32.0

