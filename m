Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85CFC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiL3Wjn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Wjm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:39:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467E18692
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:39:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E812E61C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EA8C433EF;
        Fri, 30 Dec 2022 22:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439980;
        bh=PabThboW82cPvey8GAByf5BIm/9w+rE7XW6ZKw1Wobk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mggchWdLMHF8FmYZu9y2X8Vf36qUgh3DQM39ZlW8AzTzyfehKpeFCTlwyaFK9khak
         L6f0ZsmKh6b34L5g85nwguNIyQErNVZjbTHsrcbRdrBmJq+pRqDXyfFk5/MkwSs/P3
         JMcGHZqY5AoDcE7BCqbjlLvRrbv+9FCgric/QiCtTq+gbBHTO0iOSiSUbbsYrE2SK0
         /h55QOYKJTgC91PK8NzdR+oFa+Rs4Y3H0UEYPT45JKD/2oXs6W9Cu2JIOrd6lPg9mD
         I1ICfMmNKMf7iiWqYKfEPoCj+JZKMS4R6z0rpKGeUsWXzyKvUifVOctcQg7WD0vIQk
         +U+i/fOl2fgYQ==
Subject: [PATCH 7/8] xfs: complain about bad records in query_range helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:12 -0800
Message-ID: <167243827230.683855.17831343367495322034.stgit@magnolia>
In-Reply-To: <167243827121.683855.6049797551028464473.stgit@magnolia>
References: <167243827121.683855.6049797551028464473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For every btree type except for the bmbt, refactor the code that
complains about bad records into a helper and make the ->query_range
helpers call it so that corruptions found via that avenue are logged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c    |   38 +++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_ialloc.c   |   38 ++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_refcount.c |   32 +++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_rmap.c     |   40 +++++++++++++++++++++++++---------------
 4 files changed, 91 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 13b668673243..8dcefff1db33 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -265,6 +265,24 @@ xfs_alloc_check_irec(
 	return NULL;
 }
 
+static inline int
+xfs_alloc_complain_bad_rec(
+	struct xfs_btree_cur		*cur,
+	xfs_failaddr_t			fa,
+	const struct xfs_alloc_rec_incore *irec)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+
+	xfs_warn(mp,
+		"%s Freespace BTree record corruption in AG %d detected at %pS!",
+		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size",
+		cur->bc_ag.pag->pag_agno, fa);
+	xfs_warn(mp,
+		"start block 0x%x block count 0x%x", irec->ar_startblock,
+		irec->ar_blockcount);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -276,8 +294,6 @@ xfs_alloc_get_rec(
 	int			*stat)	/* output: success/failure */
 {
 	struct xfs_alloc_rec_incore irec;
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -289,21 +305,11 @@ xfs_alloc_get_rec(
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	fa = xfs_alloc_check_irec(cur, &irec);
 	if (fa)
-		goto out_bad_rec;
+		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
 	*bno = irec.ar_startblock;
 	*len = irec.ar_blockcount;
 	return 0;
-
-out_bad_rec:
-	xfs_warn(mp,
-		"%s Freespace BTree record corruption in AG %d detected at %pS!",
-		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size",
-		pag->pag_agno, fa);
-	xfs_warn(mp,
-		"start block 0x%x block count 0x%x", irec.ar_startblock,
-		irec.ar_blockcount);
-	return -EFSCORRUPTED;
 }
 
 /*
@@ -3477,10 +3483,12 @@ xfs_alloc_query_range_helper(
 {
 	struct xfs_alloc_query_range_info	*query = priv;
 	struct xfs_alloc_rec_incore		irec;
+	xfs_failaddr_t				fa;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	if (xfs_alloc_check_irec(cur, &irec) != NULL)
-		return -EFSCORRUPTED;
+	fa = xfs_alloc_check_irec(cur, &irec);
+	if (fa)
+		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
 	return query->fn(cur, &irec, query->priv);
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 010d1f514742..b6f76935504e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -122,6 +122,25 @@ xfs_inobt_check_irec(
 	return NULL;
 }
 
+static inline int
+xfs_inobt_complain_bad_rec(
+	struct xfs_btree_cur		*cur,
+	xfs_failaddr_t			fa,
+	const struct xfs_inobt_rec_incore *irec)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+
+	xfs_warn(mp,
+		"%s Inode BTree record corruption in AG %d detected at %pS!",
+		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free",
+		cur->bc_ag.pag->pag_agno, fa);
+	xfs_warn(mp,
+"start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
+		irec->ir_startino, irec->ir_count, irec->ir_freecount,
+		irec->ir_free, irec->ir_holemask);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -143,20 +162,9 @@ xfs_inobt_get_rec(
 	xfs_inobt_btrec_to_irec(mp, rec, irec);
 	fa = xfs_inobt_check_irec(cur, irec);
 	if (fa)
-		goto out_bad_rec;
+		return xfs_inobt_complain_bad_rec(cur, fa, irec);
 
 	return 0;
-
-out_bad_rec:
-	xfs_warn(mp,
-		"%s Inode BTree record corruption in AG %d detected at %pS!",
-		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free",
-		cur->bc_ag.pag->pag_agno, fa);
-	xfs_warn(mp,
-"start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
-		irec->ir_startino, irec->ir_count, irec->ir_freecount,
-		irec->ir_free, irec->ir_holemask);
-	return -EFSCORRUPTED;
 }
 
 /*
@@ -2717,10 +2725,12 @@ xfs_ialloc_count_inodes_rec(
 {
 	struct xfs_inobt_rec_incore	irec;
 	struct xfs_ialloc_count_inodes	*ci = priv;
+	xfs_failaddr_t			fa;
 
 	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
-	if (xfs_inobt_check_irec(cur, &irec) != NULL)
-		return -EFSCORRUPTED;
+	fa = xfs_inobt_check_irec(cur, &irec);
+	if (fa)
+		return xfs_inobt_complain_bad_rec(cur, fa, &irec);
 
 	ci->count += irec.ir_count;
 	ci->freecount += irec.ir_freecount;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b77dea10c8bd..335f84bef81c 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -144,6 +144,23 @@ xfs_refcount_check_irec(
 	return NULL;
 }
 
+static inline int
+xfs_refcount_complain_bad_rec(
+	struct xfs_btree_cur		*cur,
+	xfs_failaddr_t			fa,
+	const struct xfs_refcount_irec	*irec)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+
+	xfs_warn(mp,
+ "Refcount BTree record corruption in AG %d detected at %pS!",
+				cur->bc_ag.pag->pag_agno, fa);
+	xfs_warn(mp,
+		"Start block 0x%x, block count 0x%x, references 0x%x",
+		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -153,8 +170,6 @@ xfs_refcount_get_rec(
 	struct xfs_refcount_irec	*irec,
 	int				*stat)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
-	struct xfs_perag		*pag = cur->bc_ag.pag;
 	union xfs_btree_rec		*rec;
 	xfs_failaddr_t			fa;
 	int				error;
@@ -166,19 +181,10 @@ xfs_refcount_get_rec(
 	xfs_refcount_btrec_to_irec(rec, irec);
 	fa = xfs_refcount_check_irec(cur, irec);
 	if (fa)
-		goto out_bad_rec;
+		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
-	trace_xfs_refcount_get(cur->bc_mp, pag->pag_agno, irec);
+	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 	return 0;
-
-out_bad_rec:
-	xfs_warn(mp,
-		"Refcount BTree record corruption in AG %d detected at %pS!",
-		pag->pag_agno, fa);
-	xfs_warn(mp,
-		"Start block 0x%x, block count 0x%x, references 0x%x",
-		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
-	return -EFSCORRUPTED;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 5c7b081cef87..641114a023f2 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -235,6 +235,24 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+static inline int
+xfs_rmap_complain_bad_rec(
+	struct xfs_btree_cur		*cur,
+	xfs_failaddr_t			fa,
+	const struct xfs_rmap_irec	*irec)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+
+	xfs_warn(mp,
+		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
+		cur->bc_ag.pag->pag_agno, fa);
+	xfs_warn(mp,
+		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
+		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
+		irec->rm_blockcount);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -244,8 +262,6 @@ xfs_rmap_get_rec(
 	struct xfs_rmap_irec	*irec,
 	int			*stat)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -258,18 +274,9 @@ xfs_rmap_get_rec(
 	if (!fa)
 		fa = xfs_rmap_check_irec(cur, irec);
 	if (fa)
-		goto out_bad_rec;
+		return xfs_rmap_complain_bad_rec(cur, fa, irec);
 
 	return 0;
-out_bad_rec:
-	xfs_warn(mp,
-		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-		pag->pag_agno, fa);
-	xfs_warn(mp,
-		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
-		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
-		irec->rm_blockcount);
-	return -EFSCORRUPTED;
 }
 
 struct xfs_find_left_neighbor_info {
@@ -2335,10 +2342,13 @@ xfs_rmap_query_range_helper(
 {
 	struct xfs_rmap_query_range_info	*query = priv;
 	struct xfs_rmap_irec			irec;
+	xfs_failaddr_t				fa;
 
-	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
-	    xfs_rmap_check_irec(cur, &irec) != NULL)
-		return -EFSCORRUPTED;
+	fa = xfs_rmap_btrec_to_irec(rec, &irec);
+	if (!fa)
+		fa = xfs_rmap_check_irec(cur, &irec);
+	if (fa)
+		return xfs_rmap_complain_bad_rec(cur, fa, &irec);
 
 	return query->fn(cur, &irec, query->priv);
 }

