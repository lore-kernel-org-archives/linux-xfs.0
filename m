Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F87BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZBef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjEZBee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD5D125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:34:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388FB61A8E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C62CC433EF;
        Fri, 26 May 2023 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064871;
        bh=JoJiP8Y9FPbhOU7aYoBCgNic4//m4sA158gp7oY+nK0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Duq3+RXZfeCiuLMHksXSoYuVHNkiHeaY4OJtr/kaotwalRjcVF0xw4VQ8AgIx97If
         kJE9x31LDH6RpNiZM9iUK2AGbi+YZfvdlC7rt1hsBfo4Fbd+jv1uW8afjSoePvvleT
         qwfAC/JA1twpGhzMXjV+XpjgT0lBQTfKf+ZabsWvIH8hPhi7h/b938gVlGZRUD62mu
         +kjj0yaLihwgFMC6y+UlTt1KPLhOYHShsmlW3W8PqVBWuHhGFeSeh+iIwmsl06mcqn
         t0raoE83wlFI1PrNUk1DzIzYgCeqgcncN+H5uw7vFfoqTxhKNINb5l47oqrQch5M30
         rQvRRdD7XO95w==
Date:   Thu, 25 May 2023 18:34:31 -0700
Subject: [PATCH 2/7] xfs: ensure unlinked list state is consistent with nlink
 during scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067259.3737555.11982182097894235550.stgit@frogsfrogsfrogs>
In-Reply-To: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
References: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the means to tell if an inode is on an unlinked inode
list or not, we can check that an inode with zero link count is on the
unlinked list; and an inode that has nonzero link count is not on that
list.  Make repair clean things up too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c        |   19 +++++++++++++++++++
 fs/xfs/scrub/inode_repair.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.c          |    5 +----
 fs/xfs/xfs_inode.h          |    2 ++
 4 files changed, 63 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index fcd6e9df618f..df5b4f22f049 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -738,6 +738,23 @@ xchk_inode_check_reflink_iflag(
 		xchk_ino_set_corrupt(sc, ino);
 }
 
+/*
+ * If this inode has zero link count, it must be on the unlinked list.  If
+ * it has nonzero link count, it must not be on the unlinked list.
+ */
+STATIC void
+xchk_inode_check_unlinked(
+	struct xfs_scrub	*sc)
+{
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		if (!xfs_inode_on_unlinked_list(sc->ip))
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	} else {
+		if (xfs_inode_on_unlinked_list(sc->ip))
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	}
+}
+
 /* Scrub an inode. */
 int
 xchk_inode(
@@ -770,6 +787,8 @@ xchk_inode(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
+	xchk_inode_check_unlinked(sc);
+
 	xchk_inode_xref(sc, sc->ip->i_ino, &di);
 out:
 	return error;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 6d301c84270f..37b228a4b5ae 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1576,6 +1576,46 @@ xrep_inode_problems(
 	return xrep_roll_trans(sc);
 }
 
+/*
+ * Make sure this inode's unlinked list pointers are consistent with its
+ * link count.
+ */
+STATIC int
+xrep_inode_unlinked(
+	struct xfs_scrub	*sc)
+{
+	unsigned int		nlink = VFS_I(sc->ip)->i_nlink;
+	int			error;
+
+	/*
+	 * If this inode is linked from the directory tree and on the unlinked
+	 * list, remove it from the unlinked list.
+	 */
+	if (nlink > 0 && xfs_inode_on_unlinked_list(sc->ip)) {
+		struct xfs_perag	*pag;
+		int			error;
+
+		pag = xfs_perag_get(sc->mp,
+				XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+		error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If this inode is not linked from the directory tree yet not on the
+	 * unlinked list, put it on the unlinked list.
+	 */
+	if (nlink == 0 && !xfs_inode_on_unlinked_list(sc->ip)) {
+		error = xfs_iunlink(sc->tp, sc->ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -1615,5 +1655,5 @@ xrep_inode(
 	if (xfs_is_reflink_inode(sc->ip))
 		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
 
-	return 0;
+	return xrep_inode_unlinked(sc);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04c4cd6c4cda..1fb58de0b8ec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,9 +42,6 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
-	struct xfs_inode *);
-
 /*
  * helper function to extract extent size hint from inode
  */
@@ -2160,7 +2157,7 @@ xfs_iunlink_remove_inode(
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
-STATIC int
+int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3b8470c2db7b..2fe629eede76 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -594,6 +594,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
 
 void xfs_end_io(struct work_struct *work);
 

