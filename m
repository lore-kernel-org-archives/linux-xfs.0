Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420E5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiLaABw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiLaABv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:01:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E323414D14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F2F61CB7
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5FDC433D2;
        Sat, 31 Dec 2022 00:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444909;
        bh=YskDtZ00gTUygR+Dw8mkr73RFykpQ5CbD6B/LwcAJ8M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cdBLIIB7G6xoCsXh6gkr4l8SQlRiERJIzz+p4uuXSVCKuuTAXz+hV7wJ8m9YJjmzk
         cNEXBnsLJuSQ6wnOctDZSk3oR+lR81xPJmm/66YSl4UYTH3qho5lvT1qPVaIXur1Cw
         IK+elA/GYq/n0T5//yboE0V62wIuD5lOWirlpqlbVMyqyG4cV4MC7iUUwurpw8STYM
         sjExNz4CYS/qkB2aBCWJ1fg3yRvA1IYKMgFmx2nsK9PCdsqPq0KnSRXtXV+GYSZphf
         rM9Krg1+UPiVM9RFEsviTbeEAY9ZF30gLf5FE7UGUkt+C0X8GBgw4Ol607iZ1Ot3mN
         ZKkaiMW+hliTQ==
Subject: [PATCH 3/3] xfs: ask the dentry cache if it knows the parent of a
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:16 -0800
Message-ID: <167243845684.700660.7291988184687055178.stgit@magnolia>
In-Reply-To: <167243845636.700660.17331865239070788293.stgit@magnolia>
References: <167243845636.700660.17331865239070788293.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's possible that the dentry cache can tell us the parent of a
directory.  Therefore, when repairing directory dot dot entries, query
the dcache as a last resort before scanning the entire filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c    |   27 ++++++++++++++++++++++++++
 fs/xfs/scrub/parent.h        |    1 +
 fs/xfs/scrub/parent_repair.c |   44 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h         |    1 +
 4 files changed, 73 insertions(+)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index e2de2fc24ba0..871b14c09e86 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1033,6 +1033,29 @@ xrep_dir_lookup_parent(
 	return parent_ino;
 }
 
+/*
+ * Look up '..' in the dentry cache and confirm that it's really the parent.
+ * Returns NULLFSINO if the dcache misses or if the hit is implausible.
+ */
+static inline xfs_ino_t
+xrep_dir_dcache_parent(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		parent_ino;
+	int			error;
+
+	parent_ino = xrep_parent_from_dcache(sc);
+	if (parent_ino == NULLFSINO)
+		return parent_ino;
+
+	error = xrep_parent_confirm(sc, &parent_ino);
+	if (error)
+		return NULLFSINO;
+
+	return parent_ino;
+}
+
 /* Try to find the parent of the directory being repaired. */
 STATIC int
 xrep_dir_find_parent(
@@ -1044,6 +1067,10 @@ xrep_dir_find_parent(
 	if (rd->parent_ino != NULLFSINO)
 		return 0;
 
+	rd->parent_ino = xrep_dir_dcache_parent(rd);
+	if (rd->parent_ino != NULLFSINO)
+		return 0;
+
 	rd->parent_ino = xrep_dir_lookup_parent(rd);
 	if (rd->parent_ino != NULLFSINO)
 		return 0;
diff --git a/fs/xfs/scrub/parent.h b/fs/xfs/scrub/parent.h
index e1979f5bb001..c20673d8f093 100644
--- a/fs/xfs/scrub/parent.h
+++ b/fs/xfs/scrub/parent.h
@@ -10,6 +10,7 @@ int xchk_parent_lock_two_dirs(struct xfs_scrub *sc, struct xfs_inode *dp);
 
 int xrep_parent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
 int xrep_parent_scan(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
+xfs_ino_t xrep_parent_from_dcache(struct xfs_scrub *sc);
 
 xfs_ino_t xrep_parent_self_reference(struct xfs_scrub *sc);
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index d275c2129176..d83948d1fd05 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -263,6 +263,44 @@ xrep_parent_confirm(
 	return error;
 }
 
+/* Check the dentry cache to see if knows of a parent for the scrub target. */
+xfs_ino_t
+xrep_parent_from_dcache(
+	struct xfs_scrub	*sc)
+{
+	struct inode		*pip = NULL;
+	struct dentry		*dentry, *parent;
+	xfs_ino_t		ret = NULLFSINO;
+
+	dentry = d_find_alias(VFS_I(sc->ip));
+	if (!dentry)
+		goto out;
+
+	parent = dget_parent(dentry);
+	if (!parent)
+		goto out_dput;
+
+	if (parent->d_sb != sc->ip->i_mount->m_super) {
+		dput(parent);
+		goto out_dput;
+	}
+
+	pip = igrab(d_inode(parent));
+	dput(parent);
+
+	if (S_ISDIR(pip->i_mode)) {
+		trace_xrep_findparent_from_dcache(sc->ip, XFS_I(pip)->i_ino);
+		ret = XFS_I(pip)->i_ino;
+	}
+
+	xchk_irele(sc, XFS_I(pip));
+
+out_dput:
+	dput(dentry);
+out:
+	return ret;
+}
+
 /*
  * Scan the entire filesystem looking for a parent inode for the inode being
  * scrubbed.  @sc->ip must not be the root of a directory tree.
@@ -392,6 +430,12 @@ xrep_parent(
 	if (parent_ino != NULLFSINO)
 		goto reset_parent;
 
+	/* Does the VFS dcache have an answer for us? */
+	parent_ino = xrep_parent_from_dcache(sc);
+	error = xrep_parent_confirm(sc, &parent_ino);
+	if (!error && parent_ino != NULLFSINO)
+		goto reset_parent;
+
 	/* Scan the entire filesystem for a parent. */
 	error = xrep_parent_scan(sc, &parent_ino);
 	if (error)
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b27abaa84d11..d8223ec24369 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2535,6 +2535,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_dirent);
+DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_from_dcache);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

