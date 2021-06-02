Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3AAC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D64613E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFBW1J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhFBW1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF8C6138C;
        Wed,  2 Jun 2021 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672725;
        bh=ELyNj2dtbgWLB++3GO3Y8RuohyFIVCJRhP0bdCKn6mk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YvNRnSzT3Gv/n4x+OsCR3Cph2il0dy561EM27yFfO3xOKRtC+Ff3BLg6KPOOb+LOk
         xlusn5a6LYqTVgEUW+4BIcnvLKu8DCO8JQopDZh5oIwOO9mQ+ZppVjVOFPwBWh+4RK
         lJKdDCkp5QFJ1jvYqkqxq1XtKBN4CTAjz/86Av6C+45kg4so5c2KPP64eve0Ql1bPz
         amWXCr/tzYsGh3pbDrCzEFrU8R7yABRdF4YsoN5Taabo2mo7cNnxXaJW0zD958LAIA
         +DmrBSCMqdXiSjINCpJvLJiXml221fppq4f1w6JK3oByWRK07tNdBe8Xr6nUZMy4dV
         jbvzDNx1xDMnA==
Subject: [PATCH 05/15] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:24 -0700
Message-ID: <162267272469.2375284.14945153699742283950.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As part of removing the indirect calls and radix tag implementation
details from the incore inode walk loop, create an enum to represent the
goal of the inode iteration.  More immediately, this separate removes
the need for the "ICI_NOTAG" define which makes little sense.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   55 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_icache.h |    9 --------
 2 files changed, 43 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d5ecd4cd3ef5..c6d956406033 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,12 +26,40 @@
 
 #include <linux/iversion.h>
 
+/* Radix tree tags for incore inode tree. */
+
+/* inode is to be reclaimed */
+#define XFS_ICI_RECLAIM_TAG	0
+/* Inode has speculative preallocations (posteof or cow) to clean. */
+#define XFS_ICI_BLOCKGC_TAG	1
+
+/*
+ * The goal for walking incore inodes.  These can correspond with incore inode
+ * radix tree tags when convenient.  Avoid existing XFS_IWALK namespace.
+ */
+enum xfs_icwalk_goal {
+	/* Goals that are not related to tags; these must be < 0. */
+	XFS_ICWALK_DQRELE	= -1,
+
+	/* Goals directly associated with tagged inodes. */
+	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
+};
+
+#define XFS_ICWALK_NULL_TAG	(-1U)
+
+/* Compute the inode radix tree tag for this goal. */
+static inline unsigned int
+xfs_icwalk_tag(enum xfs_icwalk_goal goal)
+{
+	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
+}
+
 static int xfs_icwalk(struct xfs_mount *mp, int iter_flags,
 		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, int tag);
+		void *args, enum xfs_icwalk_goal goal);
 static int xfs_icwalk_ag(struct xfs_perag *pag, int iter_flags,
 		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, int tag);
+		void *args, enum xfs_icwalk_goal goal);
 
 /*
  * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
@@ -791,7 +819,7 @@ xfs_dqrele_all_inodes(
 		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
 	return xfs_icwalk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&eofb, XFS_ICI_NO_TAG);
+			&eofb, XFS_ICWALK_DQRELE);
 }
 #endif /* CONFIG_XFS_QUOTA */
 
@@ -1539,7 +1567,7 @@ xfs_blockgc_worker(
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
 	error = xfs_icwalk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
-			XFS_ICI_BLOCKGC_TAG);
+			XFS_ICWALK_BLOCKGC);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1558,7 +1586,7 @@ xfs_blockgc_free_space(
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
 	return xfs_icwalk(mp, 0, xfs_blockgc_scan_inode, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+			XFS_ICWALK_BLOCKGC);
 }
 
 /*
@@ -1639,7 +1667,7 @@ xfs_icwalk_ag(
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
-	int			tag)
+	enum xfs_icwalk_goal	goal)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1655,12 +1683,13 @@ xfs_icwalk_ag(
 	nr_found = 0;
 	do {
 		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+		unsigned int	tag = xfs_icwalk_tag(goal);
 		int		error = 0;
 		int		i;
 
 		rcu_read_lock();
 
-		if (tag == XFS_ICI_NO_TAG)
+		if (tag == XFS_ICWALK_NULL_TAG)
 			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
@@ -1743,9 +1772,11 @@ static inline struct xfs_perag *
 xfs_icwalk_get_perag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	int			tag)
+	enum xfs_icwalk_goal	goal)
 {
-	if (tag == XFS_ICI_NO_TAG)
+	unsigned int		tag = xfs_icwalk_tag(goal);
+
+	if (tag == XFS_ICWALK_NULL_TAG)
 		return xfs_perag_get(mp, agno);
 	return xfs_perag_get_tag(mp, agno, tag);
 }
@@ -1760,16 +1791,16 @@ xfs_icwalk(
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
-	int			tag)
+	enum xfs_icwalk_goal	goal)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		agno = 0;
 
-	while ((pag = xfs_icwalk_get_perag(mp, agno, tag))) {
+	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_icwalk_ag(pag, iter_flags, execute, args, tag);
+		error = xfs_icwalk_ag(pag, iter_flags, execute, args, goal);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d9baa6df1121..c4274c45d914 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -17,15 +17,6 @@ struct xfs_eofblocks {
 	__u64		eof_min_file_size;
 };
 
-/*
- * tags for inode radix tree
- */
-#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_walk */
-#define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
-/* Inode has speculative preallocations (posteof or cow) to clean. */
-#define XFS_ICI_BLOCKGC_TAG	1
-
 /*
  * Flags for xfs_iget()
  */

