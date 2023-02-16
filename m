Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B58C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBPUvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBPUvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:51:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00EA4BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BA4E60B71
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38CDC433EF;
        Thu, 16 Feb 2023 20:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580671;
        bh=ojS5xOONlG93u1RR/oF1+LKJDuE3n26RkF9jxeeianQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FIULRiShS8LyYtvZJ9hzSVpgalP89J1XkreGWT0S6k5/HFruh6R2sTnWcfuaFbHX6
         3+VOPMtRFytHjQ+wOX+CgNV5ORlyYh9XO/8bgWqu4Gm5vxGjyXLSJ2GUTvhq6F1zeV
         lSSFfKbB7kVE8IlvR82kpPVa86tIw2PPkHTZxXxZgzKVAkiKFZiNxlcOy4yUhxTCY9
         HhA88NcIdtoSTJKN56Jqudo0s797C1zh8xNW49tsId96c0QUI30zCwwJaGgsr9+p2v
         pORW00m0F0rxSmt02v0BT6jg+4w7eEyMrGhTXHa9QPcvNgIZb0DHk9CFZ2nPWe8xD5
         TxGVJGcxlsTqw==
Date:   Thu, 16 Feb 2023 12:51:10 -0800
Subject: [PATCH 1/2] xfs: check dirents have parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875546.3475324.11451468475517114628.stgit@magnolia>
In-Reply-To: <167657875530.3475324.17245553975507455352.stgit@magnolia>
References: <167657875530.3475324.17245553975507455352.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the fs has parent pointers, we need to check that each child dirent
points to a file that has a parent pointer pointing back at us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d720f1e143dd..39ae59eb4f40 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -15,6 +15,8 @@
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
@@ -39,6 +41,20 @@ xchk_setup_directory(
 
 /* Directories */
 
+struct xchk_dir {
+	struct xfs_scrub	*sc;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_name_irec pptr;
+
+	/* xattr key and da args for parent pointer validation. */
+	struct xfs_parent_scratch pptr_scratch;
+
+	/* Name buffer for pptr validation and dirent revalidation. */
+	uint8_t			namebuf[MAXNAMELEN];
+
+};
+
 /* Scrub a directory entry. */
 
 /* Check that an inode's mode matches a given XFS_DIR3_FT_* type. */
@@ -61,6 +77,105 @@ xchk_dir_check_ftype(
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 }
 
+/*
+ * Try to lock a child file for checking parent pointers.  Returns the inode
+ * flags for the locks we now hold, or zero if we failed.
+ */
+STATIC unsigned int
+xchk_dir_lock_child(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+		return 0;
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	if (!xfs_inode_has_attr_fork(ip) || !xfs_need_iread_extents(&ip->i_af))
+		return XFS_IOLOCK_SHARED | XFS_ILOCK_SHARED;
+
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	return XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+}
+
+/* Check the backwards link (parent pointer) associated with this dirent. */
+STATIC int
+xchk_dir_parent_pointer(
+	struct xchk_dir		*sd,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	int			pptr_namelen;
+
+	sd->pptr.p_ino = sc->ip->i_ino;
+	sd->pptr.p_gen = VFS_I(sc->ip)->i_generation;
+	sd->pptr.p_diroffset = dapos;
+
+	pptr_namelen = xfs_parent_lookup(sc->tp, ip, &sd->pptr, sd->namebuf,
+			MAXNAMELEN, &sd->pptr_scratch);
+	if (pptr_namelen == -ENOATTR) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+	if (pptr_namelen < 0) {
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+				&pptr_namelen);
+		return pptr_namelen;
+	}
+
+	if (pptr_namelen != name->len) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
+	if (memcmp(sd->namebuf, name->name, name->len)) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
+	return 0;
+}
+
+/* Look for a parent pointer matching this dirent, if the child isn't busy. */
+STATIC int
+xchk_dir_check_pptr_fast(
+	struct xchk_dir		*sd,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	unsigned int		lockmode;
+	int			error;
+
+	/* dot and dotdot entries do not have parent pointers */
+	if (!strncmp(".", name->name, name->len) ||
+	    !strncmp("..", name->name, name->len))
+		return 0;
+
+	/* Try to lock the inode. */
+	lockmode = xchk_dir_lock_child(sc, ip);
+	if (!lockmode) {
+		xchk_set_incomplete(sc);
+		return -ECANCELED;
+	}
+
+	error = xchk_dir_parent_pointer(sd, dapos, name, ip);
+	xfs_iunlock(ip, lockmode);
+	return error;
+}
+
 /*
  * Scrub a single directory entry.
  *
@@ -78,6 +193,7 @@ xchk_dir_actor(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip;
+	struct xchk_dir		*sd = priv;
 	xfs_ino_t		lookup_ino;
 	xfs_dablk_t		offset;
 	int			error = 0;
@@ -144,6 +260,14 @@ xchk_dir_actor(
 		goto out;
 
 	xchk_dir_check_ftype(sc, offset, ip, name->type);
+
+	if (xfs_has_parent(mp)) {
+		error = xchk_dir_check_pptr_fast(sd, dapos, name, ip);
+		if (error)
+			goto out_rele;
+	}
+
+out_rele:
 	xchk_irele(sc, ip);
 out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -759,6 +883,7 @@ int
 xchk_directory(
 	struct xfs_scrub	*sc)
 {
+	struct xchk_dir		*sd;
 	int			error;
 
 	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
@@ -786,9 +911,16 @@ xchk_directory(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return 0;
 
+	sd = kvzalloc(sizeof(struct xchk_dir), XCHK_GFP_FLAGS);
+	if (!sd)
+		return -ENOMEM;
+	sd->sc = sc;
+
 	/* Look up every name in this directory by hash. */
-	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, NULL);
+	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, sd);
 	if (error == -ECANCELED)
 		error = 0;
+
+	kvfree(sd);
 	return error;
 }

