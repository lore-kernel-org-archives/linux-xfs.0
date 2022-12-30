Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F541C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiL3WjL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3WjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:39:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E43F17E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:39:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5DE561C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7ACC433EF;
        Fri, 30 Dec 2022 22:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439949;
        bh=2jlZYh53BFg7mwCZRMKGNgLrrsZp7b+X7XpMUmQJruo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Kg/LOGLA1Oi0hawcpsfDSAGLLdaMhj1erYrZ+lQXlzD0kIzVzgu9UuxPzyNYPkIjo
         IqhB04NuSK/8Ho8+HuYVjdleYUuiNmG2r+lI6EcyTMmyKQB5XIU0pWLoObjdrFctvl
         TdNAM0bb7s4IMXXKnkU6L5hUWVzuPrs/u54Z/O8m5aRna4XPHhimjpL2zMhKZc4OjD
         NNI6/EgdOGuaTd+YnOknuK0sr1LxNwh4Ss8eAz5h2PHV76Zm07bUlQg0fz9LmJth81
         ZfCFmd0tI6+OZkNU6W2kwlCNNuXM9/mqVVpUQGdH3whG47NLd2td0A0eHSLoSOHvz2
         36gfGG4PEoaQg==
Subject: [PATCH 5/8] xfs: standardize ondisk to incore conversion for rmap
 btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:12 -0800
Message-ID: <167243827202.683855.12229796597984229303.stgit@magnolia>
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

Create a xfs_rmap_check_irec function to detect corruption in btree
records.  Fix all xfs_rmap_btrec_to_irec callsites to call the new
helper and bubble up corruption reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   72 ++++++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_rmap.h |    3 ++
 fs/xfs/scrub/rmap.c      |   39 +------------------------
 3 files changed, 49 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 830b38337cd5..5c7b081cef87 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -205,51 +205,66 @@ xfs_rmap_btrec_to_irec(
 			irec);
 }
 
-/*
- * Get the data from the pointed-to record.
- */
-int
-xfs_rmap_get_rec(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*irec,
-	int			*stat)
+/* Simple checks for rmap records. */
+xfs_failaddr_t
+xfs_rmap_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*irec)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
-	union xfs_btree_rec	*rec;
-	int			error;
-
-	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (error || !*stat)
-		return error;
-
-	if (xfs_rmap_btrec_to_irec(rec, irec))
-		goto out_bad_rec;
+	struct xfs_mount		*mp = cur->bc_mp;
 
 	if (irec->rm_blockcount == 0)
-		goto out_bad_rec;
+		return __this_address;
 	if (irec->rm_startblock <= XFS_AGFL_BLOCK(mp)) {
 		if (irec->rm_owner != XFS_RMAP_OWN_FS)
-			goto out_bad_rec;
+			return __this_address;
 		if (irec->rm_blockcount != XFS_AGFL_BLOCK(mp) + 1)
-			goto out_bad_rec;
+			return __this_address;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbext(pag, irec->rm_startblock,
-					    irec->rm_blockcount))
-			goto out_bad_rec;
+		if (!xfs_verify_agbext(cur->bc_ag.pag, irec->rm_startblock,
+						       irec->rm_blockcount))
+			return __this_address;
 	}
 
 	if (!(xfs_verify_ino(mp, irec->rm_owner) ||
 	      (irec->rm_owner <= XFS_RMAP_OWN_FS &&
 	       irec->rm_owner >= XFS_RMAP_OWN_MIN)))
+		return __this_address;
+
+	return NULL;
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int
+xfs_rmap_get_rec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*irec,
+	int			*stat)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
+	union xfs_btree_rec	*rec;
+	xfs_failaddr_t		fa;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (error || !*stat)
+		return error;
+
+	fa = xfs_rmap_btrec_to_irec(rec, irec);
+	if (!fa)
+		fa = xfs_rmap_check_irec(cur, irec);
+	if (fa)
 		goto out_bad_rec;
 
 	return 0;
 out_bad_rec:
 	xfs_warn(mp,
-		"Reverse Mapping BTree record corruption in AG %d detected!",
-		pag->pag_agno);
+		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
+		pag->pag_agno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -2321,7 +2336,8 @@ xfs_rmap_query_range_helper(
 	struct xfs_rmap_query_range_info	*query = priv;
 	struct xfs_rmap_irec			irec;
 
-	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL)
+	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
+	    xfs_rmap_check_irec(cur, &irec) != NULL)
 		return -EFSCORRUPTED;
 
 	return query->fn(cur, &irec, query->priv);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 6a08c403e8b7..7fb298bcc15f 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -195,6 +195,9 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
+		const struct xfs_rmap_irec *irec);
+
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exists);
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 94650f11a4a5..610b16f77e7e 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -93,43 +93,18 @@ xchk_rmapbt_rec(
 	struct xchk_btree	*bs,
 	const union xfs_btree_rec *rec)
 {
-	struct xfs_mount	*mp = bs->cur->bc_mp;
 	struct xfs_rmap_irec	irec;
-	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
 	bool			non_inode;
 	bool			is_unwritten;
 	bool			is_bmbt;
 	bool			is_attr;
 
-	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL) {
+	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
+	    xfs_rmap_check_irec(bs->cur, &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return 0;
 	}
 
-	/* Check extent. */
-	if (irec.rm_startblock + irec.rm_blockcount <= irec.rm_startblock)
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	if (irec.rm_owner == XFS_RMAP_OWN_FS) {
-		/*
-		 * xfs_verify_agbno returns false for static fs metadata.
-		 * Since that only exists at the start of the AG, validate
-		 * that by hand.
-		 */
-		if (irec.rm_startblock != 0 ||
-		    irec.rm_blockcount != XFS_AGFL_BLOCK(mp) + 1)
-			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	} else {
-		/*
-		 * Otherwise we must point somewhere past the static metadata
-		 * but before the end of the FS.  Run the regular check.
-		 */
-		if (!xfs_verify_agbno(pag, irec.rm_startblock) ||
-		    !xfs_verify_agbno(pag, irec.rm_startblock +
-				irec.rm_blockcount - 1))
-			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	}
-
 	/* Check flags. */
 	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
 	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
@@ -148,16 +123,6 @@ xchk_rmapbt_rec(
 	if (non_inode && (is_bmbt || is_unwritten || is_attr))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	if (!non_inode) {
-		if (!xfs_verify_ino(mp, irec.rm_owner))
-			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	} else {
-		/* Non-inode owner within the magic values? */
-		if (irec.rm_owner <= XFS_RMAP_OWN_MIN ||
-		    irec.rm_owner > XFS_RMAP_OWN_FS)
-			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	}
-
 	xchk_rmapbt_xref(bs->sc, &irec);
 	return 0;
 }

