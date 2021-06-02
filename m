Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12329C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF768613CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhFBAy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhFBAy7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E96FD613C5;
        Wed,  2 Jun 2021 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595197;
        bh=4VicXZ4VJ6Eop2oxRtqaxaMME6D+7eDCgePTUJ60aSg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GSmBHAQqMLo+6LWJAjPiVbOGfxN2zXVAL0FgSu3lKzJipInX8lINLdrh+1MXmbdb9
         SQiWLnmB2joq3wg+uw5GzbieR/Fsvp01IO0nE+4f6lWgU5XCkssSmBd2fo36aVZGZq
         420jiUWSxdXJ8hT4YY+VQtxBmyzJbRXGkhzNFO4PgZ4eEVHHGw19k1PpxGHtOqag14
         hgILGoP4wB4kAyXQCHCo8CUE0HFLEddR8M/SSBhBD9w4ZECBxOoJYVe24peUoveMgo
         iMh51ftlaq+vYr5SLLwkACaERPRzG2SAGKMs/+ldMHWCHwfpO+KjAnYMSfjtRj1mMJ
         +N8Z0VBTR5OlA==
Subject: [PATCH 08/14] xfs: remove indirect calls from xfs_inode_walk{,_ag}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:16 -0700
Message-ID: <162259519664.662681.8440195387091934320.stgit@locust>
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

It turns out that there is a 1:1 mapping between the execute and goal
parameters that are passed to xfs_inode_walk_ag:

	xfs_blockgc_scan_inode <=> XFS_ICWALK_BLOCKGC
	xfs_dqrele_inode <=> XFS_ICWALK_DQRELE

Because of this exact correspondence, we don't need the execute function
pointer and can replace it with a direct call.

For the price of a forward static declaration, we can eliminate the
indirect function call.  This likely has a negligible impact on
performance (since the execute function runs transactions), but it also
simplifies the function signature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2e13e9347147..5c17bed8edb2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -50,11 +50,9 @@ xfs_icwalk_tagged(enum xfs_icwalk_goal goal)
 }
 
 static int xfs_inode_walk(struct xfs_mount *mp,
-		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, enum xfs_icwalk_goal goal);
+		enum xfs_icwalk_goal goal, void *args);
 static int xfs_inode_walk_ag(struct xfs_perag *pag,
-		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, enum xfs_icwalk_goal goal);
+		enum xfs_icwalk_goal goal, void *args);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -844,11 +842,11 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
 
-	return xfs_inode_walk(mp, xfs_dqrele_inode, &eofb,
-			XFS_ICWALK_DQRELE);
+	return xfs_inode_walk(mp, XFS_ICWALK_DQRELE, &eofb);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
+# define xfs_dqrele_inode(ip, priv)	(0)
 #endif /* CONFIG_XFS_QUOTA */
 
 /*
@@ -1591,8 +1589,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, xfs_blockgc_scan_inode, NULL,
-			XFS_ICWALK_BLOCKGC);
+	error = xfs_inode_walk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1610,8 +1607,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb,
-			XFS_ICWALK_BLOCKGC);
+	return xfs_inode_walk(mp, XFS_ICWALK_BLOCKGC, eofb);
 }
 
 /*
@@ -1698,15 +1694,14 @@ xfs_grabbed_for_walk(
 }
 
 /*
- * For a given per-AG structure @pag, grab, @execute, and rele all incore
- * inodes with the given radix tree @tag.
+ * For a given per-AG structure @pag and a goal, grab qualifying inodes and
+ * process them in some manner.
  */
 static int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	enum xfs_icwalk_goal	goal)
+	enum xfs_icwalk_goal	goal,
+	void			*args)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1777,7 +1772,14 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = execute(batch[i], args);
+			switch (goal) {
+			case XFS_ICWALK_DQRELE:
+				error = xfs_dqrele_inode(batch[i], args);
+				break;
+			case XFS_ICWALK_BLOCKGC:
+				error = xfs_blockgc_scan_inode(batch[i], args);
+				break;
+			}
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -1814,16 +1816,12 @@ xfs_inode_walk_get_perag(
 	return xfs_perag_get_tag(mp, agno, goal);
 }
 
-/*
- * Call the @execute function on all incore inodes matching the radix tree
- * @tag.
- */
+/* Walk all incore inodes to achieve a given goal. */
 static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	enum xfs_icwalk_goal	goal)
+	enum xfs_icwalk_goal	goal,
+	void			*args)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1833,7 +1831,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, goal))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, execute, args, goal);
+		error = xfs_inode_walk_ag(pag, goal, args);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

