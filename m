Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BDFC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBPUtl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBPUtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:49:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBB64BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:49:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90ECCB829BB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF6BC4339C;
        Thu, 16 Feb 2023 20:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580577;
        bh=MQH28wg0NxOaYGhe+UI/TrNBcnxpqhrure5CnSLZb98=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r7GLGspnigd3AI65qvX26xBgtaP4c0GbeeZrDlhBaWB90x/9ZbWP154G2Xgg92miY
         +eeXLSj7Xgm6aQzKVQPYPZtl5ASYECi6ZEO2YJJjrH1wCEs+6pLHKgd8z+0wqwnrat
         TsJ5RtEWBMLK9PUdMx1kQgIapyvpUZzpj3Mi0I2Nv/Nxpd8/yWQ/XpUx7uoE2f8INP
         52CZFKMSwAxPLa1tYFToAoo1DqHd6yDVcfQmoHJKp6xS2gPU6bLWREgjnHb94N5o3w
         /qB1Xdu5zWSWk108EGurPVS6eVphvOeGgibaBQQo+swUsFZxJwa9mQ3VLXW3c/vSdy
         PdU220aM+ljrA==
Date:   Thu, 16 Feb 2023 12:49:36 -0800
Subject: [PATCH 7/7] xfs: compare generated and existing dirents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874569.3474898.11791594095848245581.stgit@magnolia>
In-Reply-To: <167657874461.3474898.12919390014293805981.stgit@magnolia>
References: <167657874461.3474898.12919390014293805981.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check our work to make sure we found all the dirents that the original
directory had.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |  101 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h      |    2 +
 2 files changed, 100 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 25af002df1da..ec48b3268809 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -757,7 +757,10 @@ xrep_dir_scan_dirtree(
 	return 0;
 }
 
-/* Dump a dirent from the temporary dir. */
+/*
+ * Dump a dirent from the temporary dir and check it against the dir we're
+ * rebuilding.  We are not committing any of this.
+ */
 STATIC int
 xrep_dir_dump_tempdir(
 	struct xfs_scrub	*sc,
@@ -768,7 +771,9 @@ xrep_dir_dump_tempdir(
 	void			*priv)
 {
 	struct xrep_dir		*rd = priv;
+	xfs_ino_t		child_ino;
 	bool			child = true;
+	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
 	int			error;
 
 	/*
@@ -809,7 +814,88 @@ xrep_dir_dump_tempdir(
 	mutex_lock(&rd->lock);
 	error = xrep_dir_remove_dirent(rd, name, ino, dapos);
 	mutex_unlock(&rd->lock);
-	return error;
+	if (error)
+		return error;
+
+	/* Check that the dir being repaired has the same entry. */
+	error = xchk_dir_lookup(sc, sc->ip, name, &child_ino,
+			&child_diroffset);
+	if (error == -ENOENT) {
+		trace_xrep_dir_checkname(sc->ip, name, NULLFSINO,
+				XFS_DIR2_NULL_DATAPTR);
+		ASSERT(error != -ENOENT);
+		return -EFSCORRUPTED;
+	}
+	if (error)
+		return error;
+
+	if (ino != child_ino) {
+		trace_xrep_dir_checkname(sc->ip, name, child_ino,
+				child_diroffset);
+		ASSERT(ino == child_ino);
+		return -EFSCORRUPTED;
+	}
+
+	if (dapos != child_diroffset) {
+		trace_xrep_dir_badposname(sc->ip, name, child_ino,
+				child_diroffset);
+		/* We have no way to update this, so we just leave it. */
+	}
+
+	return 0;
+}
+
+/*
+ * Dump a dirent from the dir we're rebuilding and check it against the
+ * temporary dir.  This assumes that the directory wasn't really corrupt to
+ * begin with.
+ */
+STATIC int
+xrep_dir_dump_baddir(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	xfs_ino_t		child_ino;
+	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
+	int			error;
+
+	/* Ignore the directory's dot and dotdot entries. */
+	if (xrep_dir_samename(name, &xfs_name_dotdot) ||
+	    xrep_dir_samename(name, &xfs_name_dot))
+		return 0;
+
+	trace_xrep_dir_dumpname(sc->ip, name, ino, dapos);
+
+	/* Check that the tempdir has the same entry. */
+	error = xchk_dir_lookup(sc, sc->tempip, name, &child_ino,
+			&child_diroffset);
+	if (error == -ENOENT) {
+		trace_xrep_dir_checkname(sc->tempip, name, NULLFSINO,
+				XFS_DIR2_NULL_DATAPTR);
+		ASSERT(error != -ENOENT);
+		return -EFSCORRUPTED;
+	}
+	if (error)
+		return error;
+
+	if (ino != child_ino) {
+		trace_xrep_dir_checkname(sc->tempip, name, child_ino,
+				child_diroffset);
+		ASSERT(ino == child_ino);
+		return -EFSCORRUPTED;
+	}
+
+	if (dapos != child_diroffset) {
+		trace_xrep_dir_badposname(sc->ip, name, child_ino,
+				child_diroffset);
+		/* We have no way to update this, so we just leave it. */
+	}
+
+	return 0;
 }
 
 /*
@@ -876,12 +962,21 @@ xrep_dir_rebuild_tree(
 
 	trace_xrep_dir_rebuild_tree(sc->ip, rd->parent_ino);
 
-	xrep_tempfile_ilock(sc);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	error = xrep_tempfile_ilock_polled(sc);
+	if (error)
+		return error;
+
 	error = xchk_dir_walk(sc, sc->tempip, xrep_dir_dump_tempdir, rd);
 	if (error)
 		return error;
 
+	error = xchk_dir_walk(sc, sc->ip, xrep_dir_dump_baddir, rd);
+	if (error)
+		return error;
+
 	xrep_tempfile_iunlock(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 	xchk_trans_cancel(sc);
 
 	return xrep_dir_replay_updates(rd);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cbf914bce6db..81d26be0ef3b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1224,6 +1224,8 @@ DEFINE_XREP_DIRENT_CLASS(xrep_dir_createname);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_removename);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_replacename);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_dumpname);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_checkname);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_badposname);
 
 DECLARE_EVENT_CLASS(xrep_dir_class,
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino),

