Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D658C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiJBSfY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJBSfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6512872B
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B490F60F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E13FC433D6;
        Sun,  2 Oct 2022 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735721;
        bh=Y/VEHJ2LnbG3B9NMvoCqxSik243D/NKYBCthGgFKqLQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ldKyl0BqFkZicpNdCDTHlrD9Lp84CDc0uC5cfFl3ckp4CvNHLXk31RA8Yoc6mDyJ8
         +53MD1t9XTLoC94r5b40RpWZcQBSnOm1f35tSOrgC1HlSUFotdRoQRpfP/RsCJV9gk
         6/56sh4DpSZLPVJ46ln/6l8sibJK/CiFjZHVasiQrTrPiGOXlmEwpq+Wh0fXLX2r5S
         LqwU4f45HVgZA19ztq2ZR5h9qRbviSDHV8jjQa93DCemNN6ezhmXr950J9xOh7wIDH
         XEA8c9fI1wQEIoQZAuUuSp86pfI+n7HKwyUqo843TEOa/9UBJa4K1trg8l5BdOQO7N
         YQJkA34VyCefg==
Subject: [PATCH 3/3] xfs: always check the existence of a dirent's child inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:33 -0700
Message-ID: <166473483306.1084804.9706058704375501674.stgit@magnolia>
In-Reply-To: <166473483259.1084804.16578148649615408100.stgit@magnolia>
References: <166473483259.1084804.16578148649615408100.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're scrubbing directory entries, we always need to iget the child
inode to make sure that the inode pointer points to a valid inode.  The
original directory scrub code (commit a5c4) only set us up to do this
for ftype=1 filesystems, which is not sufficient; and then commit 4b80
made it worse by exempting the dot and dotdot entries.

Sorta-fixes: a5c46e5e8912 ("xfs: scrub directory metadata")
Sorta-fixes: 4b80ac64450f ("xfs: scrub should mark a directory corrupt if any entries cannot be iget'd")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |   75 ++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 61cd1330de42..ee086d1c482a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -39,52 +39,28 @@ struct xchk_dir_ctx {
 };
 
 /* Check that an inode's mode matches a given DT_ type. */
-STATIC int
+STATIC void
 xchk_dir_check_ftype(
 	struct xchk_dir_ctx	*sdc,
 	xfs_fileoff_t		offset,
-	xfs_ino_t		inum,
+	struct xfs_inode	*ip,
 	int			dtype)
 {
 	struct xfs_mount	*mp = sdc->sc->mp;
-	struct xfs_inode	*ip;
 	int			ino_dtype;
-	int			error = 0;
 
 	if (!xfs_has_ftype(mp)) {
 		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
-		goto out;
+		return;
 	}
 
-	/*
-	 * Grab the inode pointed to by the dirent.  Use UNTRUSTED here to
-	 * check the allocation status of the inode in the inode btrees.
-	 *
-	 * If _iget returns -EINVAL or -ENOENT then the child inode number is
-	 * garbage and the directory is corrupt.  If the _iget returns
-	 * -EFSCORRUPTED or -EFSBADCRC then the child is corrupt which is a
-	 *  cross referencing error.  Any other error is an operational error.
-	 */
-	error = xchk_iget(sdc->sc, inum, &ip);
-	if (error == -EINVAL || error == -ENOENT) {
-		error = -EFSCORRUPTED;
-		xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, 0, &error);
-		goto out;
-	}
-	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
-			&error))
-		goto out;
-
 	/* Convert mode to the DT_* values that dir_emit uses. */
 	ino_dtype = xfs_dir3_get_dtype(mp,
 			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
 	if (ino_dtype != dtype)
 		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-	xchk_irele(sdc->sc, ip);
-out:
-	return error;
 }
 
 /*
@@ -105,17 +81,17 @@ xchk_dir_actor(
 	unsigned		type)
 {
 	struct xfs_mount	*mp;
+	struct xfs_inode	*dp;
 	struct xfs_inode	*ip;
 	struct xchk_dir_ctx	*sdc;
 	struct xfs_name		xname;
 	xfs_ino_t		lookup_ino;
 	xfs_dablk_t		offset;
-	bool			checked_ftype = false;
 	int			error = 0;
 
 	sdc = container_of(dir_iter, struct xchk_dir_ctx, dir_iter);
-	ip = sdc->sc->ip;
-	mp = ip->i_mount;
+	dp = sdc->sc->ip;
+	mp = dp->i_mount;
 	offset = xfs_dir2_db_to_da(mp->m_dir_geo,
 			xfs_dir2_dataptr_to_db(mp->m_dir_geo, pos));
 
@@ -136,11 +112,7 @@ xchk_dir_actor(
 
 	if (!strncmp(".", name, namelen)) {
 		/* If this is "." then check that the inum matches the dir. */
-		if (xfs_has_ftype(mp) && type != DT_DIR)
-			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
-					offset);
-		checked_ftype = true;
-		if (ino != ip->i_ino)
+		if (ino != dp->i_ino)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 	} else if (!strncmp("..", name, namelen)) {
@@ -148,11 +120,7 @@ xchk_dir_actor(
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.
 		 */
-		if (xfs_has_ftype(mp) && type != DT_DIR)
-			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
-					offset);
-		checked_ftype = true;
-		if (ip->i_ino == mp->m_sb.sb_rootino && ino != ip->i_ino)
+		if (dp->i_ino == mp->m_sb.sb_rootino && ino != dp->i_ino)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 	}
@@ -162,7 +130,7 @@ xchk_dir_actor(
 	xname.len = namelen;
 	xname.type = XFS_DIR3_FT_UNKNOWN;
 
-	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	error = xfs_dir_lookup(sdc->sc->tp, dp, &xname, &lookup_ino, NULL);
 	/* ENOENT means the hash lookup failed and the dir is corrupt */
 	if (error == -ENOENT)
 		error = -EFSCORRUPTED;
@@ -174,12 +142,27 @@ xchk_dir_actor(
 		goto out;
 	}
 
-	/* Verify the file type.  This function absorbs error codes. */
-	if (!checked_ftype) {
-		error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
-		if (error)
-			goto out;
+	/*
+	 * Grab the inode pointed to by the dirent.  Use UNTRUSTED here to
+	 * check the allocation status of the inode in the inode btrees.
+	 *
+	 * If _iget returns -EINVAL or -ENOENT then the child inode number is
+	 * garbage and the directory is corrupt.  If the _iget returns
+	 * -EFSCORRUPTED or -EFSBADCRC then the child is corrupt which is a
+	 *  cross referencing error.  Any other error is an operational error.
+	 */
+	error = xchk_iget(sdc->sc, ino, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		error = -EFSCORRUPTED;
+		xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, 0, &error);
+		goto out;
 	}
+	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
+			&error))
+		goto out;
+
+	xchk_dir_check_ftype(sdc, offset, ip, type);
+	xchk_irele(sdc->sc, ip);
 out:
 	/*
 	 * A negative error code returned here is supposed to cause the

