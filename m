Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76DAC3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA62420848
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgCEBpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 20:45:40 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48483 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgCEBpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 20:45:39 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A8F9E7E9F64
        for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2020 12:45:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0005xR-K0
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0002wE-I0
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: make the btree cursor union members named structure
Date:   Thu,  5 Mar 2020 12:45:36 +1100
Message-Id: <20200305014537.11236-7-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200305014537.11236-1-david@fromorbit.com>
References: <20200305014537.11236-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=QqDFWJBckVzCCPuVRTEA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

we need to name the btree cursor private structures to be able
to pull them out of the deeply nested structure definition they are
in now.

Based on code extracted from a patchset by Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.h | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 561b6c344a2c..22aa26463ac3 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -188,6 +188,24 @@ union xfs_btree_cur_private {
 	} abt;
 };
 
+/* Per-AG btree information. */
+struct xfs_btree_cur_ag {
+	struct xfs_buf			*agbp;
+	xfs_agnumber_t			agno;
+	union xfs_btree_cur_private	priv;
+};
+
+/* Btree-in-inode cursor information */
+struct xfs_btree_cur_bt {
+	struct xfs_inode	*ip;
+	int			allocated;
+	short			forksize;
+	char			whichfork;
+	char			flags;
+#define	XFS_BC_BT_WASDEL	(1 << 0)
+#define	XFS_BC_BT_INVALID_OWNER	(1 << 1)
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -209,21 +227,9 @@ typedef struct xfs_btree_cur
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 	union {
-		struct {			/* needed for BNO, CNT, INO */
-			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
-			xfs_agnumber_t	agno;	/* ag number */
-			union xfs_btree_cur_private	priv;
-		} bc_ag;
-		struct {			/* needed for BMAP */
-			struct xfs_inode *ip;	/* pointer to our inode */
-			int		allocated;	/* count of alloced */
-			short		forksize;	/* fork's inode space */
-			char		whichfork;	/* data or attr fork */
-			char		flags;		/* flags */
-#define	XFS_BC_BT_WASDEL	(1 << 0)		/* was delayed */
-#define	XFS_BC_BT_INVALID_OWNER	(1 << 1)		/* for ext swap */
-		} bc_bt;
-	};				/* per-btree type data */
+		struct xfs_btree_cur_ag	bc_ag;
+		struct xfs_btree_cur_bt	bc_bt;
+	};
 } xfs_btree_cur_t;
 
 /* cursor flags */
-- 
2.24.0.rc0

