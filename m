Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE163C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9638F61156
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241385AbhKIBzd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:55:33 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49316 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241509AbhKIBzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:31 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id EA44A1A4A2D
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006ZaR-AC
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006Uj9-8z
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/14] xfs: avoid cil push lock if possible
Date:   Tue,  9 Nov 2021 12:52:38 +1100
Message-Id: <20211109015240.1547991-13-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6189d46d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=F6O72S5bnyPC6Df_giEA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because now it hurts when the CIL fills up.

  - 37.20% __xfs_trans_commit
      - 35.84% xfs_log_commit_cil
         - 19.34% _raw_spin_lock
            - do_raw_spin_lock
                 19.01% __pv_queued_spin_lock_slowpath
         - 4.20% xfs_log_ticket_ungrant
              0.90% xfs_log_space_wake


Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 84924da6396d..3355da50d5c0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1299,10 +1299,18 @@ xlog_cil_push_background(
 	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
-	 * Don't do a background push if we haven't used up all the
-	 * space available yet.
+	 * We are done if:
+	 * - we haven't used up all the space available yet; or
+	 * - we've already queued up a push; and
+	 * - we're not over the hard limit; and
+	 * - nothing has been over the hard limit.
+	 *
+	 * If so, we don't need to take the push lock as there's nothing to do.
 	 */
-	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+	if (space_used < XLOG_CIL_SPACE_LIMIT(log) ||
+	    (cil->xc_push_seq == cil->xc_current_sequence &&
+	     space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log) &&
+	     !waitqueue_active(&cil->xc_push_wait))) {
 		up_read(&cil->xc_ctx_lock);
 		return;
 	}
-- 
2.33.0

