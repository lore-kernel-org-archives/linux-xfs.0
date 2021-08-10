Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F35BC4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA58D60F35
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhHJFZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:25:18 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43732 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236330AbhHJFZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:25:18 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 420B980BB96
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:24:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-00GZfh-OO
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-000App-GV
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/16] xfs: consolidate mount option features in m_features
Date:   Tue, 10 Aug 2021 15:24:41 +1000
Message-Id: <20210810052451.41578-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810052451.41578-1-david@fromorbit.com>
References: <20210810052451.41578-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ccDssqCNqLZjo417zBQA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This provides separation of mount time feature flags from runtime
mount flags and mount option state. It also makes the feature
checks use the same interface as the superblock features. i.e. we
don't care if the feature is enabled by superblock flags or mount
options, we just care if it's enabled or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e44ac7a870df..a8a3a73749cf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -278,6 +278,25 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 
+/* Mount features */
+#define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
+#define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
+#define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
+#define XFS_FEAT_LARGE_IOSIZE	(1ULL << 51)	/* report large preferred
+						 * I/O size in stat() */
+#define XFS_FEAT_WSYNC		(1ULL << 52)	/* synchronous metadata ops */
+#define XFS_FEAT_DIRSYNC	(1ULL << 53)	/* synchronous directory ops */
+#define XFS_FEAT_DISCARD	(1ULL << 54)	/* discard unused blocks */
+#define XFS_FEAT_GRPID		(1ULL << 55)	/* group-ID assigned from directory */
+#define XFS_FEAT_SMALL_INUMS	(1ULL << 56)	/* user wants 32bit inodes */
+#define XFS_FEAT_IKEEP		(1ULL << 57)	/* keep empty inode clusters*/
+#define XFS_FEAT_SWALLOC	(1ULL << 58)	/* stripe width allocation */
+#define XFS_FEAT_FILESTREAMS	(1ULL << 59)	/* use filestreams allocator */
+#define XFS_FEAT_DAX_ALWAYS	(1ULL << 60)	/* DAX always enabled */
+#define XFS_FEAT_DAX_NEVER	(1ULL << 61)	/* DAX never enabled */
+#define XFS_FEAT_NORECOVERY	(1ULL << 62)	/* no recovery - dirty fs */
+#define XFS_FEAT_NOUUID		(1ULL << 63)	/* ignore uuid during mount */
+
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
 { \
@@ -293,6 +312,7 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
 	xfs_sb_version_add ## name(&mp->m_sb); \
 }
 
+/* Superblock features */
 __XFS_ADD_FEAT(attr, ATTR)
 __XFS_HAS_FEAT(nlink, NLINK)
 __XFS_ADD_FEAT(quota, QUOTA)
@@ -320,6 +340,30 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 
+/*
+ * Mount features
+ *
+ * These do not change dynamically - features that can come and go,
+ * such as 32 bit inodes and read-only state, are kept as flags rather than
+ * features.
+ */
+__XFS_HAS_FEAT(noattr2, NOATTR2)
+__XFS_HAS_FEAT(noalign, NOALIGN)
+__XFS_HAS_FEAT(allocsize, ALLOCSIZE)
+__XFS_HAS_FEAT(large_iosize, LARGE_IOSIZE)
+__XFS_HAS_FEAT(wsync, WSYNC)
+__XFS_HAS_FEAT(dirsync, DIRSYNC)
+__XFS_HAS_FEAT(discard, DISCARD)
+__XFS_HAS_FEAT(grpid, GRPID)
+__XFS_HAS_FEAT(small_inums, SMALL_INUMS)
+__XFS_HAS_FEAT(ikeep, IKEEP)
+__XFS_HAS_FEAT(swalloc, SWALLOC)
+__XFS_HAS_FEAT(filestreams, FILESTREAMS)
+__XFS_HAS_FEAT(dax_always, DAX_ALWAYS)
+__XFS_HAS_FEAT(dax_never, DAX_NEVER)
+__XFS_HAS_FEAT(norecovery, NORECOVERY)
+__XFS_HAS_FEAT(nouuid, NOUUID)
+
 /*
  * Flags for m_flags.
  */
-- 
2.31.1

