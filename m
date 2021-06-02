Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223EBC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AC8B613E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFBW1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhFBW1a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F0E6138C;
        Wed,  2 Jun 2021 22:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672747;
        bh=A+dLnLnxPtIIRcrK3XYQmPKXOvPVBAyyZv9/DiKBDOw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fWe7Rz63csU1iZOxC/TJOxjKi8GjebP4v0Q/bgJR+M6tPfySaEe0NIAg4M/+llKZv
         cbdMyr6v0fVHMJo/vo/FMD8RdtzwO0QtH2Rmenf349m9R63G7Wyn5/fyiQNTPtaqJw
         4C91CElvkoFajx/BuXSWeDE5PvIq5ODNkM9LYyVwWBZ/geaAEJ/KhGNAcCfeQZO7Fa
         pa91FecIlYIHEImECXsEqQPCQ0F2u/dxDUjlW7zjGmmAGB1hC0N9HWIiG0jV7vRMmK
         rUfgUm+oi/CYMP2AcLgsfEO4Z8od1BoGXYqmsP4hSujxqnLH0/UXu75uYW3Sx5OvtE
         2HkPTnKWdbGtA==
Subject: [PATCH 09/15] xfs: remove indirect calls from xfs_inode_walk{,_ag}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:46 -0700
Message-ID: <162267274676.2375284.4741896598250655117.stgit@locust>
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
 fs/xfs/xfs_icache.c |   60 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b5ce9580934f..5ca5bd2ee5ae 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -55,11 +55,9 @@ xfs_icwalk_tag(enum xfs_icwalk_goal goal)
 }
 
 static int xfs_icwalk(struct xfs_mount *mp,
-		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, enum xfs_icwalk_goal goal);
+		enum xfs_icwalk_goal goal, void *args);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
-		int (*execute)(struct xfs_inode *ip, void *args),
-		void *args, enum xfs_icwalk_goal goal);
+		enum xfs_icwalk_goal goal, void *args);
 
 /*
  * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
@@ -859,10 +857,11 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
-	return xfs_icwalk(mp, xfs_dqrele_inode, &eofb, XFS_ICWALK_DQRELE);
+	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &eofb);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
+# define xfs_dqrele_inode(ip, priv)	(0)
 #endif /* CONFIG_XFS_QUOTA */
 
 /*
@@ -1605,8 +1604,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_icwalk_ag(pag, xfs_blockgc_scan_inode, NULL,
-			XFS_ICWALK_BLOCKGC);
+	error = xfs_icwalk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1624,8 +1622,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_icwalk(mp, xfs_blockgc_scan_inode, eofb,
-			XFS_ICWALK_BLOCKGC);
+	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, eofb);
 }
 
 /*
@@ -1716,16 +1713,36 @@ xfs_icwalk_igrab(
 	}
 }
 
+/* Process an inode and release it.  Return -EAGAIN to skip an inode. */
+static inline int
+xfs_icwalk_process_inode(
+	enum xfs_icwalk_goal	goal,
+	struct xfs_inode	*ip,
+	void			*args)
+{
+	int			error;
+
+	switch (goal) {
+	case XFS_ICWALK_DQRELE:
+		error = xfs_dqrele_inode(ip, args);
+		break;
+	case XFS_ICWALK_BLOCKGC:
+		error = xfs_blockgc_scan_inode(ip, args);
+		break;
+	}
+	xfs_irele(ip);
+	return error;
+}
+
 /*
- * For a given per-AG structure @pag, grab, @execute, and rele all incore
- * inodes with the given radix tree @tag.
+ * For a given per-AG structure @pag and a goal, grab qualifying inodes and
+ * process them in some manner.
  */
 static int
 xfs_icwalk_ag(
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	enum xfs_icwalk_goal	goal)
+	enum xfs_icwalk_goal	goal,
+	void			*args)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1797,8 +1814,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = execute(batch[i], args);
-			xfs_irele(batch[i]);
+			error = xfs_icwalk_process_inode(goal, batch[i], args);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -1836,16 +1852,12 @@ xfs_icwalk_get_perag(
 	return xfs_perag_get_tag(mp, agno, tag);
 }
 
-/*
- * Call the @execute function on all incore inodes matching the radix tree
- * @tag.
- */
+/* Walk all incore inodes to achieve a given goal. */
 static int
 xfs_icwalk(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	enum xfs_icwalk_goal	goal)
+	enum xfs_icwalk_goal	goal,
+	void			*args)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1854,7 +1866,7 @@ xfs_icwalk(
 
 	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_icwalk_ag(pag, execute, args, goal);
+		error = xfs_icwalk_ag(pag, goal, args);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

