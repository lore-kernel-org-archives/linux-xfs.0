Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C6FCCA481
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348150AbiFKB1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347609AbiFKB1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:13 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C8B03A481E
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3A1215EC7DF
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AP2-KN
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELMB-JD
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/50] xfs: convert xfs_ialloc_next_ag() to an atomic
Date:   Sat, 11 Jun 2022 11:26:29 +1000
Message-Id: <20220611012659.3418072-21-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=7GaMYM1hFZgjFW6SNswA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is currently a spinlock lock protected rotor which can be
implemented with a single atomic operation. Change it to be more
efficient and get rid of the m_agirotor_lock. Noticed while
converting the inode allocation AG selection loop to active perag
references.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +----------------
 fs/xfs/libxfs/xfs_sb.c     |  3 ++-
 fs/xfs/xfs_mount.h         |  3 +--
 fs/xfs/xfs_super.c         |  1 -
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b0a6e88f3f5f..f997c7b73329 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1576,21 +1576,6 @@ xfs_dialloc_roll(
 	return error;
 }
 
-static xfs_agnumber_t
-xfs_ialloc_next_ag(
-	xfs_mount_t	*mp)
-{
-	xfs_agnumber_t	agno;
-
-	spin_lock(&mp->m_agirotor_lock);
-	agno = mp->m_agirotor;
-	if (++mp->m_agirotor >= mp->m_maxagi)
-		mp->m_agirotor = 0;
-	spin_unlock(&mp->m_agirotor_lock);
-
-	return agno;
-}
-
 static bool
 xfs_dialloc_good_ag(
 	struct xfs_perag	*pag,
@@ -1747,7 +1732,7 @@ xfs_dialloc(
 	 * an AG has enough space for file creation.
 	 */
 	if (S_ISDIR(mode))
-		start_agno = xfs_ialloc_next_ag(mp);
+		start_agno = atomic_inc_return(&mp->m_agirotor) % mp->m_maxagi;
 	else {
 		start_agno = XFS_INO_TO_AGNO(mp, parent);
 		if (start_agno >= mp->m_maxagi)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f30372d04a9c..4e826a1046a8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -918,7 +918,8 @@ xfs_sb_mount_common(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	mp->m_agfrotor = mp->m_agirotor = 0;
+	mp->m_agfrotor = 0;
+	atomic_set(&mp->m_agirotor, 0);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ba5d42abf66e..3a7b71e4ddca 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -210,8 +210,7 @@ typedef struct xfs_mount {
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
-	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
-	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
+	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
 	struct shrinker		m_inodegc_shrinker;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ed18160e6181..732d38ba4fbc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1910,7 +1910,6 @@ static int xfs_init_fs_context(
 		return -ENOMEM;
 
 	spin_lock_init(&mp->m_sb_lock);
-	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
-- 
2.35.1

