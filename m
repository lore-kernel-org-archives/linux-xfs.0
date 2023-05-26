Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3831BC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbjEZBfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbjEZBfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B423B125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4765E61248
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED7C433D2;
        Fri, 26 May 2023 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064949;
        bh=T4ri+Rfwo0AW9y/G+ZaILTt+uRW79KaiQhx4Kr97UJc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Pd26IMB0RXU0DDkr3GTTauZzP5Z0WZQ+GDtvZUXHAg3CSt7l9VhvryqhgtdMH5KGY
         3q1kHmXVj7hKHpXv/gAk9r0eD9crgv0cd5U8vyzUPUuM+lc7/Qr7VWpRB/QeBC0OVr
         0f2xzveF9WMXKftOuM4Km8t03xOWRObHjllbjw4MC4k8P3GmYZPaWKkl4VfUH3bugk
         f4gN+cPODMOCL82KhDNBGak5FeTb4PiCPG88Wp1G1iRNjehMUMYTRbThOBCW2G6xcr
         JzmiT9AVRTkeZP0iWuV7ZCek4POQAI/XUsDxigf3CkBrfvWw+UUGBAM6aqVJHj0fZx
         4XB7shoWOFhkw==
Date:   Thu, 25 May 2023 18:35:49 -0700
Subject: [PATCH 7/7] xfs: ask the dentry cache if it knows the parent of a
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067334.3737555.5361183930176736067.stgit@frogsfrogsfrogs>
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

It's possible that the dentry cache can tell us the parent of a
directory.  Therefore, when repairing directory dot dot entries, query
the dcache as a last resort before scanning the entire filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c    |   29 +++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |   41 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/findparent.h    |    1 +
 fs/xfs/scrub/parent_repair.c |   13 +++++++++++++
 fs/xfs/scrub/trace.h         |    1 +
 5 files changed, 84 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 289a7cda936d..215a8c1ce5e3 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -204,6 +204,29 @@ xrep_dir_lookup_parent(
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
+	parent_ino = xrep_findparent_from_dcache(sc);
+	if (parent_ino == NULLFSINO)
+		return parent_ino;
+
+	error = xrep_findparent_confirm(sc, &parent_ino);
+	if (error)
+		return NULLFSINO;
+
+	return parent_ino;
+}
+
 /* Try to find the parent of the directory being repaired. */
 STATIC int
 xrep_dir_find_parent(
@@ -217,6 +240,12 @@ xrep_dir_find_parent(
 		return 0;
 	}
 
+	ino = xrep_dir_dcache_parent(rd);
+	if (ino != NULLFSINO) {
+		xrep_findparent_scan_finish_early(&rd->pscan, ino);
+		return 0;
+	}
+
 	ino = xrep_dir_lookup_parent(rd);
 	if (ino != NULLFSINO) {
 		xrep_findparent_scan_finish_early(&rd->pscan, ino);
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 52b635ff7a2a..0c3940d397da 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -55,7 +55,8 @@
  * must not read the scan results without re-taking @sc->ip's ILOCK.
  *
  * There are a few shortcuts that we can take to avoid scanning the entire
- * filesystem, such as noticing directory tree roots.
+ * filesystem, such as noticing directory tree roots and querying the dentry
+ * cache for parent information.
  */
 
 struct xrep_findparent_info {
@@ -412,3 +413,41 @@ xrep_findparent_self_reference(
 
 	return NULLFSINO;
 }
+
+/* Check the dentry cache to see if knows of a parent for the scrub target. */
+xfs_ino_t
+xrep_findparent_from_dcache(
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
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
index 79f76a43009b..0bc3921e6ddc 100644
--- a/fs/xfs/scrub/findparent.h
+++ b/fs/xfs/scrub/findparent.h
@@ -45,5 +45,6 @@ void xrep_findparent_scan_finish_early(struct xrep_parent_scan_info *pscan,
 int xrep_findparent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
 
 xfs_ino_t xrep_findparent_self_reference(struct xfs_scrub *sc);
+xfs_ino_t xrep_findparent_from_dcache(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_FINDPARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 3210426b3d88..0343b1fdbeeb 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -118,7 +118,20 @@ xrep_parent_find_dotdot(
 	 * then retake the ILOCK so that we can salvage directory entries.
 	 */
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/* Does the VFS dcache have an answer for us? */
+	ino = xrep_findparent_from_dcache(sc);
+	if (ino != NULLFSINO) {
+		error = xrep_findparent_confirm(sc, &ino);
+		if (!error && ino != NULLFSINO) {
+			xrep_findparent_scan_finish_early(&rp->pscan, ino);
+			goto out_relock;
+		}
+	}
+
+	/* Scan the entire filesystem for a parent. */
 	error = xrep_findparent_scan(&rp->pscan);
+out_relock:
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 
 	return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 629c9db5784b..260720500440 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2542,6 +2542,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_dirent);
+DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_from_dcache);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

