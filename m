Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B33C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Dec 2020 23:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B484B20825
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Dec 2020 23:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL2X5c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:57:32 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:55319 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgL2X5c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Dec 2020 18:57:32 -0500
Received: from deadbird.molgen.mpg.de (deadbird.molgen.mpg.de [141.14.19.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.molgen.mpg.de (Postfix) with ESMTPS id 17D8320646231;
        Wed, 30 Dec 2020 00:56:49 +0100 (CET)
From:   Donald Buczek <buczek@molgen.mpg.de>
To:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de, Donald Buczek <buczek@molgen.mpg.de>
Subject: [PATCH] xfs: Wake CIL push waiters more reliably
Date:   Wed, 30 Dec 2020 00:56:27 +0100
Message-Id: <20201229235627.33289-1-buczek@molgen.mpg.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Threads, which committed items to the CIL, wait in the xc_push_wait
waitqueue when used_space in the push context goes over a limit. These
threads need to be woken when the CIL is pushed.

The CIL push worker tries to avoid the overhead of calling wake_all()
when there are no waiters waiting. It does so by checking the same
condition which caused the waits to happen. This, however, is
unreliable, because ctx->space_used can actually decrease when items are
recommitted. If the value goes below the limit while some threads are
already waiting but before the push worker gets to it, these threads are
not woken.

Always wake all CIL push waiters. Test with waitqueue_active() as an
optimization. This is possible, because we hold the xc_push_lock
spinlock, which prevents additions to the waitqueue.

Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
---
 fs/xfs/xfs_log_cil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b0ef071b3cb5..d620de8e217c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -670,7 +670,7 @@ xlog_cil_push_work(
 	/*
 	 * Wake up any background push waiters now this context is being pushed.
 	 */
-	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+	if (waitqueue_active(&cil->xc_push_wait))
 		wake_up_all(&cil->xc_push_wait);
 
 	/*
-- 
2.26.2

