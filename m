Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8513C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiDKAeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiDKAeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:04 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9814210FCD
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D4C0F10CE825
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:49 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMh-9y
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjD-94
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/17] xfs: convert AGI log flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:37 +1000
Message-Id: <20220411003147.2104423-8-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f5
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=SIxSS3yGSWZCach_KcEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 30 +++++++++++++++---------------
 fs/xfs/libxfs/xfs_ialloc.c |  6 +++---
 fs/xfs/libxfs/xfs_ialloc.h |  2 +-
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 65e24847841e..0d6fa199a896 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -619,22 +619,22 @@ typedef struct xfs_agi {
 
 #define XFS_AGI_CRC_OFF		offsetof(struct xfs_agi, agi_crc)
 
-#define	XFS_AGI_MAGICNUM	(1 << 0)
-#define	XFS_AGI_VERSIONNUM	(1 << 1)
-#define	XFS_AGI_SEQNO		(1 << 2)
-#define	XFS_AGI_LENGTH		(1 << 3)
-#define	XFS_AGI_COUNT		(1 << 4)
-#define	XFS_AGI_ROOT		(1 << 5)
-#define	XFS_AGI_LEVEL		(1 << 6)
-#define	XFS_AGI_FREECOUNT	(1 << 7)
-#define	XFS_AGI_NEWINO		(1 << 8)
-#define	XFS_AGI_DIRINO		(1 << 9)
-#define	XFS_AGI_UNLINKED	(1 << 10)
+#define	XFS_AGI_MAGICNUM	(1u << 0)
+#define	XFS_AGI_VERSIONNUM	(1u << 1)
+#define	XFS_AGI_SEQNO		(1u << 2)
+#define	XFS_AGI_LENGTH		(1u << 3)
+#define	XFS_AGI_COUNT		(1u << 4)
+#define	XFS_AGI_ROOT		(1u << 5)
+#define	XFS_AGI_LEVEL		(1u << 6)
+#define	XFS_AGI_FREECOUNT	(1u << 7)
+#define	XFS_AGI_NEWINO		(1u << 8)
+#define	XFS_AGI_DIRINO		(1u << 9)
+#define	XFS_AGI_UNLINKED	(1u << 10)
 #define	XFS_AGI_NUM_BITS_R1	11	/* end of the 1st agi logging region */
-#define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
-#define	XFS_AGI_FREE_ROOT	(1 << 11)
-#define	XFS_AGI_FREE_LEVEL	(1 << 12)
-#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
+#define	XFS_AGI_ALL_BITS_R1	((1u << XFS_AGI_NUM_BITS_R1) - 1)
+#define	XFS_AGI_FREE_ROOT	(1u << 11)
+#define	XFS_AGI_FREE_LEVEL	(1u << 12)
+#define	XFS_AGI_IBLOCKS		(1u << 13) /* both inobt/finobt block counters */
 #define	XFS_AGI_NUM_BITS_R2	14
 
 /* disk block (xfs_daddr_t) in the AG */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..54c2be6a2972 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2414,9 +2414,9 @@ xfs_imap(
  */
 void
 xfs_ialloc_log_agi(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	struct xfs_buf	*bp,		/* allocation group header buffer */
-	int		fields)		/* bitmask of fields to log */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	uint32_t		fields)
 {
 	int			first;		/* first byte number */
 	int			last;		/* last byte number */
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 8b5c2b709022..a7705b6a1fd3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -60,7 +60,7 @@ void
 xfs_ialloc_log_agi(
 	struct xfs_trans *tp,		/* transaction pointer */
 	struct xfs_buf	*bp,		/* allocation group header buffer */
-	int		fields);	/* bitmask of fields to log */
+	uint32_t	fields);	/* bitmask of fields to log */
 
 /*
  * Read in the allocation group header (inode allocation section)
-- 
2.35.1

