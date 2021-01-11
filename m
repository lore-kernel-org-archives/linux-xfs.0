Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A76C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AED522D5B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391785AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404081AbhAKXYJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2106D22D08;
        Mon, 11 Jan 2021 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407408;
        bh=5KeL5GVjaVaEquUqKkRUoSPgJuTg/XqAuXW+Q1m/cNw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q9hB4Jww+284Po46tfx3Kf1vsNTxENFMrhQmRAZjHfih2gJhncJFZbOOq9fMUwBCT
         tBBuGJlqlG84+Qg6+jJ07gC9mXx+wDj8HtqJMUy/QoPymOY/3J3nVytccN6YljkUev
         MUo/vMkEFuL2I3vneimD7Nh36m7cXeqyLH3loRkrGRK4fFP4JhADYAmRxt3DviyChD
         wyoH8ByU56rCzxWNRq+mUc8BFHLr2cXt3Ji1Q16lEVuNuj+rbuCw0Dh7Cs603JI/TG
         CNYjDPG8/QM5j4EikGlDQiUS92dk991t0D9ypKhJIp78leUZs75nb7549JM9uUJTDe
         z4hyD+SulEyYQ==
Subject: [PATCH 2/7] xfs: refactor the predicate part of xfs_free_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:28 -0800
Message-ID: <161040740813.1582286.3253329052236449810.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the part of _free_eofblocks that decides if it's really going
to truncate post-EOF blocks into a separate helper function.  The
upcoming deferred inode inactivation patch requires us to be able to
decide this prior to actual inactivation.  No functionality changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  109 +++++++++++++++++++++---------------------------
 fs/xfs/xfs_inode.c     |   36 ++++++++++++++++
 fs/xfs/xfs_inode.h     |    2 +
 3 files changed, 85 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 602011f06fb6..16e996ae0ff3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -637,78 +637,63 @@ xfs_free_eofblocks(
 	struct xfs_inode	*ip)
 {
 	struct xfs_trans	*tp;
-	int			error;
-	xfs_fileoff_t		end_fsb;
-	xfs_fileoff_t		last_fsb;
-	xfs_filblks_t		map_len;
-	int			nimaps;
-	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
-
-	/*
-	 * Figure out if there are any blocks beyond the end
-	 * of the file.  If not, then there is nothing to do.
-	 */
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (last_fsb <= end_fsb)
-		return 0;
-	map_len = last_fsb - end_fsb;
-
-	nimaps = 1;
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	bool			has;
+	int			error;
 
 	/*
 	 * If there are blocks after the end of file, truncate the file to its
 	 * current size to free them up.
 	 */
-	if (!error && (nimaps != 0) &&
-	    (imap.br_startblock != HOLESTARTBLOCK ||
-	     ip->i_delayed_blks)) {
-		/*
-		 * Attach the dquots to the inode up front.
-		 */
-		error = xfs_qm_dqattach(ip);
-		if (error)
-			return error;
+	error = xfs_has_eofblocks(ip, &has);
+	if (error || !has)
+		return error;
 
-		/* wait on dio to ensure i_size has settled */
-		inode_dio_wait(VFS_I(ip));
+	/*
+	 * Attach the dquots to the inode up front.
+	 */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
 
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
-				&tp);
-		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			return error;
-		}
+	/* wait on dio to ensure i_size has settled */
+	inode_dio_wait(VFS_I(ip));
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
-
-		/*
-		 * Do not update the on-disk file size.  If we update the
-		 * on-disk file size and then the system crashes before the
-		 * contents of the file are flushed to disk then the files
-		 * may be full of holes (ie NULL files bug).
-		 */
-		error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
-					XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
-		if (error) {
-			/*
-			 * If we get an error at this point we simply don't
-			 * bother truncating the file.
-			 */
-			xfs_trans_cancel(tp);
-		} else {
-			error = xfs_trans_commit(tp);
-			if (!error)
-				xfs_inode_clear_eofblocks_tag(ip);
-		}
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		return error;
 	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/*
+	 * Do not update the on-disk file size.  If we update the
+	 * on-disk file size and then the system crashes before the
+	 * contents of the file are flushed to disk then the files
+	 * may be full of holes (ie NULL files bug).
+	 */
+	error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
+				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
+	if (error)
+		goto err_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_unlock;
+
+	xfs_inode_clear_eofblocks_tag(ip);
+	goto out_unlock;
+
+err_cancel:
+	/*
+	 * If we get an error at this point we simply don't
+	 * bother truncating the file.
+	 */
+	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0e6cc33a33ad..d30b49cd60d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3711,3 +3711,39 @@ xfs_iunlock2_io_mmap(
 	if (!same_inode)
 		inode_unlock(VFS_I(ip1));
 }
+
+/*
+ * Decide if this inode have post-EOF blocks.  The caller is responsible
+ * for knowing / caring about the PREALLOC/APPEND flags.
+ */
+int
+xfs_has_eofblocks(
+	struct xfs_inode	*ip,
+	bool			*has)
+{
+	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		end_fsb;
+	xfs_fileoff_t		last_fsb;
+	xfs_filblks_t		map_len;
+	int			nimaps;
+	int			error;
+
+	*has = false;
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
+	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	if (last_fsb <= end_fsb)
+		return 0;
+	map_len = last_fsb - end_fsb;
+
+	nimaps = 1;
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (error || nimaps == 0)
+		return error;
+
+	*has = imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
+	return 0;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index eca333f5f715..5295791be4e2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -468,6 +468,8 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+int xfs_has_eofblocks(struct xfs_inode *ip, bool *has);
+
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 

