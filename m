Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334F4C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 00:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbiCXAWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 20:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240524AbiCXAWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 20:22:39 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD96C7891B
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 17:21:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AE4E110E506B
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 11:21:07 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXBDt-0096a5-Q1
        for linux-xfs@vger.kernel.org; Thu, 24 Mar 2022 11:21:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nXBDt-002z4v-PJ
        for linux-xfs@vger.kernel.org;
        Thu, 24 Mar 2022 11:21:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: xfs_do_force_shutdown needs to block racing shutdowns
Date:   Thu, 24 Mar 2022 11:21:02 +1100
Message-Id: <20220324002103.710477-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324002103.710477-1-david@fromorbit.com>
References: <20220324002103.710477-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623bb973
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=oz-SYxHX2ioO59wv_cgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we call xfs_forced_shutdown(), the caller often expects the
filesystem to be completely shut down when it returns. However,
if we have racing xfs_forced_shutdown() calls, the first caller sets
the mount shutdown flag then goes to shutdown the log. The second
caller sees the mount shutdown flag and returns immediately - it
does not wait for the log to be shut down.

Unfortunately, xfs_forced_shutdown() is used in some places that
expect it to completely shut down the filesystem before it returns
(e.g. xfs_trans_log_inode()). As such, returning before the log has
been shut down leaves us in a place where the transaction failed to
complete correctly but we still call xfs_trans_commit(). This
situation arises because xfs_trans_log_inode() does not return an
error and instead calls xfs_force_shutdown() to ensure that the
transaction being committed is aborted.

Unfortunately, we have a race condition where xfs_trans_commit()
needs to check xlog_is_shutdown() because it can't abort log items
before the log is shut down, but it needs to use xfs_is_shutdown()
because xfs_forced_shutdown() does not block waiting for the log to
shut down.

To fix this conundrum, first we make all calls to
xfs_forced_shutdown() block until the log is also shut down. This
means we can then safely use xfs_forced_shutdown() as a mechanism
that ensures the currently running transaction will be aborted by
xfs_trans_commit() regardless of the shutdown check it uses.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c    |  6 +++++-
 fs/xfs/xfs_log.c      |  1 +
 fs/xfs/xfs_log_priv.h | 11 +++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..093a44aecec0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -17,6 +17,7 @@
 #include "xfs_fsops.h"
 #include "xfs_trans_space.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
@@ -528,8 +529,11 @@ xfs_do_force_shutdown(
 	int		tag;
 	const char	*why;
 
-	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate))
+
+	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate)) {
+		xlog_shutdown_wait(mp->m_log);
 		return;
+	}
 	if (mp->m_sb_bp)
 		mp->m_sb_bp->b_flags |= XBF_DONE;
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6879d6d19d68..4336eb804a4a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3909,6 +3909,7 @@ xlog_force_shutdown(
 	xlog_state_shutdown_callbacks(log);
 	spin_unlock(&log->l_icloglock);
 
+	wake_up_var(&log->l_opstate);
 	return log_error;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 80d77aac6fe4..401cdc400980 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -484,6 +484,17 @@ xlog_is_shutdown(struct xlog *log)
 	return test_bit(XLOG_IO_ERROR, &log->l_opstate);
 }
 
+/*
+ * Wait until the xlog_force_shutdown() has marked the log as shut down
+ * so xlog_is_shutdown() will always return true.
+ */
+static inline void
+xlog_shutdown_wait(
+	struct xlog	*log)
+{
+	wait_var_event(&log->l_opstate, xlog_is_shutdown(log));
+}
+
 /* common routines */
 extern int
 xlog_recover(
-- 
2.35.1

