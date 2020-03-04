Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7675AC3F2CD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5841B20866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgCDHyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:07 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34029 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728557AbgCDHyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:07 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 244B13A2A29
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0007la-0T
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005ci-Tq
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/11] xfs: move xlog_state_ioerror()
Date:   Wed,  4 Mar 2020 18:53:56 +1100
Message-Id: <20200304075401.21558-7-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=bkf_lyP68qlAmJxVHm4A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To clean up unmount record writing error handling, we need to move
xlog_state_ioerror() higher up in the file. Also move the setting of
the XLOG_IO_ERROR state to inside the function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 59 ++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2e9f3baa7cc8..0de3c32d42b6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -874,6 +874,36 @@ xfs_log_mount_cancel(
 	xfs_log_unmount(mp);
 }
 
+/*
+ * Mark all iclogs IOERROR. l_icloglock is held by the caller.
+ */
+STATIC int
+xlog_state_ioerror(
+	struct xlog	*log)
+{
+	xlog_in_core_t	*iclog, *ic;
+
+	log->l_flags |= XLOG_IO_ERROR;
+
+	iclog = log->l_iclog;
+	if (iclog->ic_state != XLOG_STATE_IOERROR) {
+		/*
+		 * Mark all the incore logs IOERROR.
+		 * From now on, no log flushes will result.
+		 */
+		ic = iclog;
+		do {
+			ic->ic_state = XLOG_STATE_IOERROR;
+			ic = ic->ic_next;
+		} while (ic != iclog);
+		return 0;
+	}
+	/*
+	 * Return non-zero, if state transition has already happened.
+	 */
+	return 1;
+}
+
 /*
  * Mark the filesystem clean by writing an unmount record to the head of the
  * log.
@@ -3770,34 +3800,6 @@ xlog_verify_iclog(
 }	/* xlog_verify_iclog */
 #endif
 
-/*
- * Mark all iclogs IOERROR. l_icloglock is held by the caller.
- */
-STATIC int
-xlog_state_ioerror(
-	struct xlog	*log)
-{
-	xlog_in_core_t	*iclog, *ic;
-
-	iclog = log->l_iclog;
-	if (iclog->ic_state != XLOG_STATE_IOERROR) {
-		/*
-		 * Mark all the incore logs IOERROR.
-		 * From now on, no log flushes will result.
-		 */
-		ic = iclog;
-		do {
-			ic->ic_state = XLOG_STATE_IOERROR;
-			ic = ic->ic_next;
-		} while (ic != iclog);
-		return 0;
-	}
-	/*
-	 * Return non-zero, if state transition has already happened.
-	 */
-	return 1;
-}
-
 /*
  * This is called from xfs_force_shutdown, when we're forcibly
  * shutting down the filesystem, typically because of an IO error.
@@ -3868,7 +3870,6 @@ xfs_log_force_umount(
 	 * Mark the log and the iclogs with IO error flags to prevent any
 	 * further log IO from being issued or completed.
 	 */
-	log->l_flags |= XLOG_IO_ERROR;
 	retval = xlog_state_ioerror(log);
 	spin_unlock(&log->l_icloglock);
 
-- 
2.24.0.rc0

