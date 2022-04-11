Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493B5C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiDKAeO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiDKAeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D293DED4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DD8C310CE89A
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMu-Dh
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjX-Ck
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/17] xfs: convert dquot flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:41 +1000
Message-Id: <20220411003147.2104423-12-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=vWCpcOARs_OZSg8Qgq0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h     | 8 ++++----
 fs/xfs/libxfs/xfs_quota_defs.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0d6fa199a896..f524736d811e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1085,10 +1085,10 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
-#define XFS_DQTYPE_USER		0x01		/* user dquot record */
-#define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
-#define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
-#define XFS_DQTYPE_BIGTIME	0x80		/* large expiry timestamps */
+#define XFS_DQTYPE_USER		(1u << 0)	/* user dquot record */
+#define XFS_DQTYPE_PROJ		(1u << 1)	/* project dquot record */
+#define XFS_DQTYPE_GROUP	(1u << 2)	/* group dquot record */
+#define XFS_DQTYPE_BIGTIME	(1u << 7)	/* large expiry timestamps */
 
 /* bitmask to determine if this is a user/group/project dquot */
 #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index a02c5062f9b2..fdfe3cc6f15c 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -29,8 +29,8 @@ typedef uint8_t		xfs_dqtype_t;
 /*
  * flags for q_flags field in the dquot.
  */
-#define XFS_DQFLAG_DIRTY	(1 << 0)	/* dquot is dirty */
-#define XFS_DQFLAG_FREEING	(1 << 1)	/* dquot is being torn down */
+#define XFS_DQFLAG_DIRTY	(1u << 0)	/* dquot is dirty */
+#define XFS_DQFLAG_FREEING	(1u << 1)	/* dquot is being torn down */
 
 #define XFS_DQFLAG_STRINGS \
 	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
-- 
2.35.1

