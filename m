Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295A7C3F2D9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A3B720866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgCDHyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:07 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43852 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgCDHyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:07 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8CB0D7EA137
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0007lY-VI
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005ce-Sk
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/11] xfs: factor out unmount record writing
Date:   Wed,  4 Mar 2020 18:53:55 +1100
Message-Id: <20200304075401.21558-6-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=RJ33b4CtU-wh5j9jekAA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Separate out the unmount record writing from the rest of the
ticket and log state futzing necessary to make it work. This is
a no-op, just makes the code cleaner and places the unmount record
formatting and writing alongside the commit record formatting and
writing code.

We can also get rid of the ticket flag clearing before the
xlog_write() call because it no longer cares about the state of
XLOG_TIC_INITED.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 100eeaed4a7d..2e9f3baa7cc8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -485,6 +485,38 @@ xfs_log_reserve(
  *		marked as with WANT_SYNC.
  */
 
+/*
+ * Write out an unmount record using the ticket provided. We have to account for
+ * the data space used in the unmount ticket as this write is not done from a
+ * transaction context that has already done the accounting for us.
+ */
+static int
+xlog_write_unmount(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*lsn,
+	uint			flags)
+{
+	/* the data section must be 32 bit size aligned */
+	struct xfs_unmount_log_format magic = {
+		.magic = XLOG_UNMOUNT_TYPE,
+	};
+	struct xfs_log_iovec reg = {
+		.i_addr = &magic,
+		.i_len = sizeof(magic),
+		.i_type = XLOG_REG_TYPE_UNMOUNT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= sizeof(magic);
+
+	return xlog_write(log, &vec, ticket, lsn, NULL, flags);
+}
+
 /*
  * Write out the commit record of a transaction associated with the given
  * ticket to close off a running log write. Return the lsn of the commit record.
@@ -843,31 +875,13 @@ xfs_log_mount_cancel(
 }
 
 /*
- * Final log writes as part of unmount.
- *
- * Mark the filesystem clean as unmount happens.  Note that during relocation
- * this routine needs to be executed as part of source-bag while the
- * deallocation must not be done until source-end.
+ * Mark the filesystem clean by writing an unmount record to the head of the
+ * log.
  */
-
-/* Actually write the unmount record to disk. */
 static void
 xfs_log_write_unmount_record(
 	struct xfs_mount	*mp)
 {
-	/* the data section must be 32 bit size aligned */
-	struct xfs_unmount_log_format magic = {
-		.magic = XLOG_UNMOUNT_TYPE,
-	};
-	struct xfs_log_iovec reg = {
-		.i_addr = &magic,
-		.i_len = sizeof(magic),
-		.i_type = XLOG_REG_TYPE_UNMOUNT,
-	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
 	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
@@ -892,10 +906,7 @@ xfs_log_write_unmount_record(
 		flags &= ~XLOG_UNMOUNT_TRANS;
 	}
 
-	/* remove inited flag, and account for space used */
-	tic->t_flags = 0;
-	tic->t_curr_res -= sizeof(magic);
-	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
+	error = xlog_write_unmount(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
-- 
2.24.0.rc0

