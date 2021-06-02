Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75302C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E54613CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFBAyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhFBAyh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED421613C5;
        Wed,  2 Jun 2021 00:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595175;
        bh=zn5exg2bJY7xJk9UmfJM/OMjGE4ZH2GVprDJaiyqtWU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nSSFHGPT1kM9VoC21IOEtN0Wcu+9OcmSeIMR/JZsYE6LYzY7htyEAtesawgpfA+39
         URUFqv9bNz3JzVzVAqy/k9Iq3JxAj7JymixX1yEfeiPkqoAmbhjEVJso2OyqOW9UPJ
         zocuKtFrRBdOJb9tW+Q/AuYPOuB8te0joPyudbcmVZtDEZWgJJtkqI5jE+MYmdpW5+
         jEosTO8UPyqUlnXFWEts13bMJgPMKmELqM/7zl96mIA3U8NYY1WapHxbvGOjFNgr7E
         7dDo1JK5gQQWrotmdP8PwehzcEzvcv9EfAl90oNaNoYi1EaQDXbtRcLOw76bcy3QzJ
         nFZTBzw0HahZg==
Subject: [PATCH 04/14] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:52:54 -0700
Message-ID: <162259517467.662681.7329146794207007368.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
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
 fs/xfs/xfs_icache.c |   51 +++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_icache.h |    9 ---------
 2 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e70ce7868444..018b3f8bdd21 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,12 +26,35 @@
 
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
+	XFS_ICWALK_DQRELE	= -1,
+	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
+};
+
+/* Is there a radix tree tag for this goal? */
+static inline bool
+xfs_icwalk_tagged(enum xfs_icwalk_goal goal)
+{
+	return goal != XFS_ICWALK_DQRELE;
+}
+
 static int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
 		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, int tag);
+		void *args, enum xfs_icwalk_goal goal);
 static int xfs_inode_walk_ag(struct xfs_perag *pag, int iter_flags,
 		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, int tag);
+		void *args, enum xfs_icwalk_goal goal);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -781,7 +804,7 @@ xfs_dqrele_all_inodes(
 		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
 
 	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&eofb, XFS_ICI_NO_TAG);
+			&eofb, XFS_ICWALK_DQRELE);
 }
 #endif /* CONFIG_XFS_QUOTA */
 
@@ -1529,7 +1552,7 @@ xfs_blockgc_worker(
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
 	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
-			XFS_ICI_BLOCKGC_TAG);
+			XFS_ICWALK_BLOCKGC);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1548,7 +1571,7 @@ xfs_blockgc_free_space(
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
 	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+			XFS_ICWALK_BLOCKGC);
 }
 
 /*
@@ -1629,7 +1652,7 @@ xfs_inode_walk_ag(
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
-	int			tag)
+	enum xfs_icwalk_goal	goal)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1650,7 +1673,7 @@ xfs_inode_walk_ag(
 
 		rcu_read_lock();
 
-		if (tag == XFS_ICI_NO_TAG)
+		if (!xfs_icwalk_tagged(goal))
 			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
@@ -1658,7 +1681,7 @@ xfs_inode_walk_ag(
 			nr_found = radix_tree_gang_lookup_tag(
 					&pag->pag_ici_root,
 					(void **) batch, first_index,
-					XFS_LOOKUP_BATCH, tag);
+					XFS_LOOKUP_BATCH, goal);
 
 		if (!nr_found) {
 			rcu_read_unlock();
@@ -1733,11 +1756,11 @@ static inline struct xfs_perag *
 xfs_inode_walk_get_perag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	int			tag)
+	enum xfs_icwalk_goal	goal)
 {
-	if (tag == XFS_ICI_NO_TAG)
+	if (!xfs_icwalk_tagged(goal))
 		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
+	return xfs_perag_get_tag(mp, agno, goal);
 }
 
 /*
@@ -1750,7 +1773,7 @@ xfs_inode_walk(
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
-	int			tag)
+	enum xfs_icwalk_goal	goal)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1758,9 +1781,9 @@ xfs_inode_walk(
 	xfs_agnumber_t		ag;
 
 	ag = 0;
-	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
+	while ((pag = xfs_inode_walk_get_perag(mp, ag, goal))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
+		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, goal);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a4f737cea460..bc0998a2f7d6 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -26,15 +26,6 @@ struct xfs_eofblocks {
 				 XFS_EOFB_DROP_GDQUOT | \
 				 XFS_EOFB_DROP_PDQUOT)
 
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

