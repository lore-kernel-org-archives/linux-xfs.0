Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24488C43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D01C121D7B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgIIITS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:19:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38961 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbgIIITR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 04:19:17 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A767A824414
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 18:19:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-00005N-JW
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-004yO5-4J
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: add a free space extent change reservation
Date:   Wed,  9 Sep 2020 18:19:11 +1000
Message-Id: <20200909081912.1185392-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909081912.1185392-1-david@fromorbit.com>
References: <20200909081912.1185392-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=NvrPUYSSg0wYV7KhmsoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Lots of the transaction reservation code reserves space for an
extent allocation. It is inconsistently implemented, and many of
them get it wrong. Introduce a new function to calculate the log
space reservation for adding or removing an extent from the free
space btrees.

This function reserves space for logging the AGF, the AGFL and the
free space btrees, avoiding the need to account for them seperately
in every reservation that manipulates free space.

Convert the EFI recovery reservation to use this transaction
reservation as EFI recovery only needs to manipulate the free space
index.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index da2ec052ac0a..621ddb277dfa 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -79,6 +79,23 @@ xfs_allocfree_log_count(
 	return blocks;
 }
 
+/*
+ * Log reservation required to add or remove a single extent to the free space
+ * btrees.  This requires modifying:
+ *
+ * the agf header: 1 sector
+ * the agfl header: 1 sector
+ * the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
+uint
+xfs_allocfree_extent_res(
+	struct xfs_mount *mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+				XFS_FSB_TO_B(mp, 1));
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -922,7 +939,7 @@ xfs_trans_resv_calc(
 	 * EFI recovery is itruncate minus the initial transaction that logs
 	 * logs the EFI.
 	 */
-	resp->tr_efi.tr_logres = resp->tr_itruncate.tr_logres;
+	resp->tr_efi.tr_logres = xfs_allocfree_extent_res(mp);
 	resp->tr_efi.tr_logcount = resp->tr_itruncate.tr_logcount - 1;
 	resp->tr_efi.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-- 
2.28.0

