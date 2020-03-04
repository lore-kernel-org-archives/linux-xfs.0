Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36A4C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B652F20866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgCDHyF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:05 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43674 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgCDHyF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:05 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 407937EA131
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0007ll-3M
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0005co-1G
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/11] xfs: rename the log unmount writing functions.
Date:   Wed,  4 Mar 2020 18:53:58 +1100
Message-Id: <20200304075401.21558-9-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=pDtEVDZtZgkmEOs7AtQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The naming and calling conventions are a bit of a mess. Clean it up
so the call chain looks like:

	xfs_log_unmount_write(mp)
	  xlog_unmount_write(log)
	    xlog_write_unmount_record(log, ticket)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a310ca9e7615..bdf604d31d8c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -491,7 +491,7 @@ xfs_log_reserve(
  * transaction context that has already done the accounting for us.
  */
 static int
-xlog_write_unmount(
+xlog_write_unmount_record(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*lsn,
@@ -903,10 +903,10 @@ xlog_state_ioerror(
  * log.
  */
 static void
-xfs_log_write_unmount_record(
-	struct xfs_mount	*mp)
+xlog_unmount_write(
+	struct xlog		*log)
 {
-	struct xlog		*log = mp->m_log;
+	struct xfs_mount	*mp = log->l_mp;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
 	xfs_lsn_t		lsn;
@@ -930,7 +930,7 @@ xfs_log_write_unmount_record(
 		flags &= ~XLOG_UNMOUNT_TRANS;
 	}
 
-	error = xlog_write_unmount(log, tic, &lsn, flags);
+	error = xlog_write_unmount_record(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
@@ -1006,7 +1006,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		xfs_log_write_unmount_record(mp);
+		xlog_unmount_write(log);
 	} else {
 		/*
 		 * We're already in forced_shutdown mode, couldn't
-- 
2.24.0.rc0

