Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C09CC3F2D7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C20420866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgCDHyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:08 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33971 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728539AbgCDHyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:08 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0DA8F3A29F6
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0007lV-Tq
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005cc-RY
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/11] xfs: merge xlog_commit_record with xlog_write_done()
Date:   Wed,  4 Mar 2020 18:53:54 +1100
Message-Id: <20200304075401.21558-5-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=Ogm-NnU_ru6a6b32IXgA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xlog_write_done() is just a thin wrapper around
xlog_commit_record(), so they can be merged together easily. Convert
all the xlog_commit_record() callers to use xlog_write_done() and
merge the implementations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 60 +++++++++++++++---------------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 702b38e4db6e..100eeaed4a7d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -24,13 +24,6 @@
 kmem_zone_t	*xfs_log_ticket_zone;
 
 /* Local miscellaneous function prototypes */
-STATIC int
-xlog_commit_record(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*commitlsnp);
-
 STATIC struct xlog *
 xlog_alloc_log(
 	struct xfs_mount	*mp,
@@ -493,7 +486,8 @@ xfs_log_reserve(
  */
 
 /*
- * Write a commit record to the log to close off a running log write.
+ * Write out the commit record of a transaction associated with the given
+ * ticket to close off a running log write. Return the lsn of the commit record.
  */
 int
 xlog_write_done(
@@ -502,10 +496,26 @@ xlog_write_done(
 	struct xlog_in_core	**iclog,
 	xfs_lsn_t		*lsn)
 {
+	struct xfs_log_iovec reg = {
+		.i_addr = NULL,
+		.i_len = 0,
+		.i_type = XLOG_REG_TYPE_COMMIT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+	int	error;
+
+	ASSERT_ALWAYS(iclog);
+
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
-	return xlog_commit_record(log, ticket, iclog, lsn);
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
+	if (error)
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	return error;
 }
 
 /*
@@ -1529,38 +1539,6 @@ xlog_alloc_log(
 	return ERR_PTR(error);
 }	/* xlog_alloc_log */
 
-
-/*
- * Write out the commit record of a transaction associated with the given
- * ticket.  Return the lsn of the commit record.
- */
-STATIC int
-xlog_commit_record(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*commitlsnp)
-{
-	struct xfs_mount *mp = log->l_mp;
-	int	error;
-	struct xfs_log_iovec reg = {
-		.i_addr = NULL,
-		.i_len = 0,
-		.i_type = XLOG_REG_TYPE_COMMIT,
-	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
-
-	ASSERT_ALWAYS(iclog);
-	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
-					XLOG_COMMIT_TRANS);
-	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-	return error;
-}
-
 /*
  * Push on the buffer cache code if we ever use more than 75% of the on-disk
  * log space.  This code pushes on the lsn which would supposedly free up
-- 
2.24.0.rc0

