Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D638C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 23:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiHIXEA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 19:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHIXD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 19:03:57 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C8C56AA0C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:03:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6BAF262D553
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 09:03:56 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oLYGR-00BDI8-EA
        for linux-xfs@vger.kernel.org; Wed, 10 Aug 2022 09:03:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1oLYGR-00E4WT-D6
        for linux-xfs@vger.kernel.org;
        Wed, 10 Aug 2022 09:03:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: collapse xlog_state_set_callback in caller
Date:   Wed, 10 Aug 2022 09:03:50 +1000
Message-Id: <20220809230353.3353059-7-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220809230353.3353059-1-david@fromorbit.com>
References: <20220809230353.3353059-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62f2e7dc
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=biHskzXt2R4A:10 a=20KFwNOVAAAA:8 a=eNFZjYxO8Yb06G2fAiIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The function is called from a single place, and it isn't just
setting the iclog state to XLOG_STATE_CALLBACK - it can mark iclogs
clean, which moves tehm to states after CALLBACK. Hence the function
is now badly named, and should just be folded into the caller where
the iclog completion logic makes a whole lot more sense.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e420591b1a8a..5b7c91a42edf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2520,25 +2520,6 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
-static void
-xlog_state_set_callback(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		header_lsn)
-{
-	/*
-	 * If there are no callbacks on this iclog, we can mark it clean
-	 * immediately and return. Otherwise we need to run the
-	 * callbacks.
-	 */
-	if (list_empty(&iclog->ic_callbacks)) {
-		xlog_state_clean_iclog(log, iclog);
-		return;
-	}
-	trace_xlog_iclog_callback(iclog, _RET_IP_);
-	iclog->ic_state = XLOG_STATE_CALLBACK;
-}
-
 /*
  * Return true if we need to stop processing, false to continue to the next
  * iclog. The caller will need to run callbacks if the iclog is returned in the
@@ -2570,7 +2551,17 @@ xlog_state_iodone_process_iclog(
 		lowest_lsn = xlog_get_lowest_lsn(log);
 		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 			return false;
-		xlog_state_set_callback(log, iclog, header_lsn);
+		/*
+		 * If there are no callbacks on this iclog, we can mark it clean
+		 * immediately and return. Otherwise we need to run the
+		 * callbacks.
+		 */
+		if (list_empty(&iclog->ic_callbacks)) {
+			xlog_state_clean_iclog(log, iclog);
+			return false;
+		}
+		trace_xlog_iclog_callback(iclog, _RET_IP_);
+		iclog->ic_state = XLOG_STATE_CALLBACK;
 		return false;
 	default:
 		/*
-- 
2.36.1

