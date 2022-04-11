Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264C2C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbiDKAeM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiDKAeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 107C1101C8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8BCDE10CE8AF
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEN7-Hq
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjr-GT
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/17] xfs: convert quota options flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:45 +1000
Message-Id: <20220411003147.2104423-16-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=fOiYvdzM27_PIthXDlwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h | 45 +++++++++++++++++++++++-----------
 fs/xfs/xfs_trace.h             | 16 ------------
 2 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index fdfe3cc6f15c..3076cd74fcaa 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -73,29 +73,45 @@ typedef uint8_t		xfs_dqtype_t;
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
  * persistent values (ie. their values can and will change between versions)
  */
-#define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
-#define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
-#define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
-#define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
-#define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
+#define XFS_QMOPT_UQUOTA	(1u << 0) /* user dquot requested */
+#define XFS_QMOPT_GQUOTA	(1u << 1) /* group dquot requested */
+#define XFS_QMOPT_PQUOTA	(1u << 2) /* project dquot requested */
+#define XFS_QMOPT_FORCE_RES	(1u << 3) /* ignore quota limits */
+#define XFS_QMOPT_SBVERSION	(1u << 4) /* change superblock version num */
 
 /*
  * flags to xfs_trans_mod_dquot to indicate which field needs to be
  * modified.
  */
-#define XFS_QMOPT_RES_REGBLKS	0x0010000
-#define XFS_QMOPT_RES_RTBLKS	0x0020000
-#define XFS_QMOPT_BCOUNT	0x0040000
-#define XFS_QMOPT_ICOUNT	0x0080000
-#define XFS_QMOPT_RTBCOUNT	0x0100000
-#define XFS_QMOPT_DELBCOUNT	0x0200000
-#define XFS_QMOPT_DELRTBCOUNT	0x0400000
-#define XFS_QMOPT_RES_INOS	0x0800000
+#define XFS_QMOPT_RES_REGBLKS	(1u << 7)
+#define XFS_QMOPT_RES_RTBLKS	(1u << 8)
+#define XFS_QMOPT_BCOUNT	(1u << 9)
+#define XFS_QMOPT_ICOUNT	(1u << 10)
+#define XFS_QMOPT_RTBCOUNT	(1u << 11)
+#define XFS_QMOPT_DELBCOUNT	(1u << 12)
+#define XFS_QMOPT_DELRTBCOUNT	(1u << 13)
+#define XFS_QMOPT_RES_INOS	(1u << 14)
 
 /*
  * flags for dqalloc.
  */
-#define XFS_QMOPT_INHERIT	0x1000000
+#define XFS_QMOPT_INHERIT	(1u << 31)
+
+#define XFS_QMOPT_FLAGS \
+	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
+	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
+	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
+	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
+	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
+	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
+	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
+	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
+	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
+	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
+	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
+	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
+	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
+	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
 
 /*
  * flags to xfs_trans_mod_dquot.
@@ -114,6 +130,7 @@ typedef uint8_t		xfs_dqtype_t;
 		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
+
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 		struct xfs_disk_dquot *ddq, xfs_dqid_t id);
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 989ecda904db..b88bd45da27a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1096,22 +1096,6 @@ DEFINE_DQUOT_EVENT(xfs_dqflush_done);
 DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_before);
 DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_after);
 
-#define XFS_QMOPT_FLAGS \
-	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
-	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
-	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
-	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
-	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
-	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
-	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
-	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
-	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
-	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
-	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
-	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
-	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
-	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
-
 TRACE_EVENT(xfs_trans_mod_dquot,
 	TP_PROTO(struct xfs_trans *tp, struct xfs_dquot *dqp,
 		 unsigned int field, int64_t delta),
-- 
2.35.1

