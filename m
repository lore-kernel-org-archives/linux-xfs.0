Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9B8C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiL3WkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D5217E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1689E61C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C0EC433EF;
        Fri, 30 Dec 2022 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440011;
        bh=0hh8Py0CHFO24hYEsFtArqreKNfCkWvzSnuLEwLMidQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OYmEEUtomE/c45eL2rfBDv1umS/NJNb3pq5huLs3fdpdnieqE8EXz4Z0onfCwJqwz
         HbhBWdeC0ps3usjxRlWsNIIIbnyJvwJnNSBsDFnMrFW6QmBCYsTiTKi9buO33GzEmu
         x/aeDN5xRGwgYBRWmexP51lIL0rk5s0mcp+fLNsNeFBHk3aB87OmqUQ81J220u6S/l
         1cGWALcIugb6ekQiAiK5wjh+TQdifegcfBWyFyoB/H0HHEAPhzPkkBfLoTWeb+gML7
         5UiDWgF5tB/4zwFDrPu7OQAGB+d9qrBh5zPHpyEdh+RF1XZmntndVz0WS5a8KbFp09
         kmTOG0p6thqOQ==
Subject: [PATCH 1/3] xfs: hoist rmap record flag checks from scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:15 -0800
Message-ID: <167243827554.684088.17848836865268694140.stgit@magnolia>
In-Reply-To: <167243827537.684088.11219968589590305107.stgit@magnolia>
References: <167243827537.684088.11219968589590305107.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the rmap record flag checks from xchk_rmapbt_rec into
xfs_rmap_check_irec so that they are applied everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   22 ++++++++++++++++++++++
 fs/xfs/scrub/rmap.c      |   22 ----------------------
 2 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 641114a023f2..e66ecd794a84 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -212,6 +212,10 @@ xfs_rmap_check_irec(
 	const struct xfs_rmap_irec	*irec)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
+	bool				is_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
 
 	if (irec->rm_blockcount == 0)
 		return __this_address;
@@ -232,6 +236,24 @@ xfs_rmap_check_irec(
 	       irec->rm_owner >= XFS_RMAP_OWN_MIN)))
 		return __this_address;
 
+	/* Check flags. */
+	is_inode = !XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	if (is_bmbt && irec->rm_offset != 0)
+		return __this_address;
+
+	if (!is_inode && irec->rm_offset != 0)
+		return __this_address;
+
+	if (is_unwritten && (is_bmbt || !is_inode || is_attr))
+		return __this_address;
+
+	if (!is_inode && (is_bmbt || is_unwritten || is_attr))
+		return __this_address;
+
 	return NULL;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 610b16f77e7e..a039008dc078 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -94,10 +94,6 @@ xchk_rmapbt_rec(
 	const union xfs_btree_rec *rec)
 {
 	struct xfs_rmap_irec	irec;
-	bool			non_inode;
-	bool			is_unwritten;
-	bool			is_bmbt;
-	bool			is_attr;
 
 	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
 	    xfs_rmap_check_irec(bs->cur, &irec) != NULL) {
@@ -105,24 +101,6 @@ xchk_rmapbt_rec(
 		return 0;
 	}
 
-	/* Check flags. */
-	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
-	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
-	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
-	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
-
-	if (is_bmbt && irec.rm_offset != 0)
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	if (non_inode && irec.rm_offset != 0)
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	if (is_unwritten && (is_bmbt || non_inode || is_attr))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	if (non_inode && (is_bmbt || is_unwritten || is_attr))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
 	xchk_rmapbt_xref(bs->sc, &irec);
 	return 0;
 }

