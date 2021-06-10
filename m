Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5FAC47094
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 11:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D94B613FF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 11:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFJLCE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJLCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 07:02:03 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F5DC061760
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jun 2021 04:00:07 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:a946:bccb:b1a1:3055])
        by xavier.telenet-ops.be with bizsmtp
        id FP04250060wnyou01P04UY; Thu, 10 Jun 2021 13:00:05 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lrIPr-00FF9M-Na; Thu, 10 Jun 2021 13:00:03 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lrIPq-00Blno-SW; Thu, 10 Jun 2021 13:00:02 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        noreply@ellerman.id.au
Subject: [PATCH] xfs: Fix 64-bit division on 32-bit in xlog_state_switch_iclogs()
Date:   Thu, 10 Jun 2021 13:00:01 +0200
Message-Id: <20210610110001.2805317-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 32-bit (e.g. m68k):

    ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!

Fix this by using a uint32_t intermediate, like before.

Reported-by: noreply@ellerman.id.au
Fixes: 7660a5b48fbef958 ("xfs: log stripe roundoff is a property of the log")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.
---
 fs/xfs/xfs_log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0e563ff8cd3be4aa..0c91da5defee6b9f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3143,8 +3143,8 @@ xlog_state_switch_iclogs(
 
 	/* Round up to next log-sunit */
 	if (log->l_iclog_roundoff > BBSIZE) {
-		log->l_curr_block = roundup(log->l_curr_block,
-						BTOBB(log->l_iclog_roundoff));
+		uint32_t sunit_bb = BTOBB(log->l_iclog_roundoff);
+		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
 	}
 
 	if (log->l_curr_block >= log->l_logBBsize) {
-- 
2.25.1

