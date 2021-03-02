Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C543C43332
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A5BA61477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245639AbhCCDPu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360758AbhCBW3K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A66BE64F37;
        Tue,  2 Mar 2021 22:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724108;
        bh=Uqzhl1wtvEb4SICT89GlQCy142/M2LgqhcFSSJJB1qY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ptsTu9Qpo/jgcX4/Gcmv7OJn2u8CS4R6ym1M8TgbHpfNWaOl+ozPCI+uII2BxV2y7
         YkKoC8JRP8F+cd+tb7waiXE8bKPezrgKhe7xmNW1/n1Lvbp9xnO1WmTwwO0k6z8IDd
         t25qlrpb3QhPZwVsIgnpm9L6Oa6n8MYLCelrTzurKVEOj4QIpeZLuE4VHym5QGcuj6
         /AbGZgusRluEMILMSpW/O5cOM7kiZ0tVqwUM88PAevYRpgMnd81UCzerj3U2QOhTtv
         loCYQHQcIuUAHh2YNFjGdGp8nvUtXp+JL9JdTYvbgrD7Wt2Azg1jYMSIuxLa/2TEbs
         2xqtrsfkndGZw==
Subject: [PATCH 2/3] xfs: avoid buffer deadlocks in inumbers/bulkstat
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Tue, 02 Mar 2021 14:28:28 -0800
Message-ID: <161472410813.3421449.1691962515820573818.stgit@magnolia>
In-Reply-To: <161472409643.3421449.2100229515469727212.stgit@magnolia>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're servicing an INUMBERS or BULKSTAT request, grab an empty
transaction so that we don't hit an ABBA buffer deadlock if the inode
btree contains a cycle.

Found by fuzzing an inode btree pointer to introduce a cycle into the
tree (xfs/365).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_itable.c |   46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ca310a125d1e..2339a1874efa 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_error.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_trans.h"
 
 /*
  * Bulk Stat
@@ -166,6 +167,7 @@ xfs_bulkstat_one(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	ASSERT(breq->icount == 1);
@@ -175,9 +177,20 @@ xfs_bulkstat_one(
 	if (!bc.buf)
 		return -ENOMEM;
 
+	/*
+	 * Grab freeze protection and allocate an empty transaction so that
+	 * we avoid deadlocking if the inobt is corrupt.
+	 */
+	sb_start_write(breq->mp->m_super);
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
 	error = xfs_bulkstat_one_int(breq->mp, breq->mnt_userns, NULL,
 				     breq->startino, &bc);
-
+	xfs_trans_cancel(tp);
+out:
+	sb_end_write(breq->mp->m_super);
 	kmem_free(bc.buf);
 
 	/*
@@ -241,6 +254,7 @@ xfs_bulkstat(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -256,9 +270,20 @@ xfs_bulkstat(
 	if (!bc.buf)
 		return -ENOMEM;
 
-	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
+	/*
+	 * Grab freeze protection and allocate an empty transaction so that
+	 * we avoid deadlocking if the inobt is corrupt.
+	 */
+	sb_start_write(breq->mp->m_super);
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
-
+	xfs_trans_cancel(tp);
+out:
+	sb_end_write(breq->mp->m_super);
 	kmem_free(bc.buf);
 
 	/*
@@ -371,13 +396,26 @@ xfs_inumbers(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error = 0;
 
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	error = xfs_inobt_walk(breq->mp, NULL, breq->startino, breq->flags,
+	/*
+	 * Grab freeze protection and allocate an empty transaction so that
+	 * we avoid deadlocking if the inobt is corrupt.
+	 */
+	sb_start_write(breq->mp->m_super);
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_inumbers_walk, breq->icount, &ic);
+	xfs_trans_cancel(tp);
+out:
+	sb_end_write(breq->mp->m_super);
 
 	/*
 	 * We found some inode groups, so clear the error status and return

