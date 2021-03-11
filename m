Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC31C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E40FE64FCE
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCKDGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229767AbhCKDFw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:05:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6BCE64EDB;
        Thu, 11 Mar 2021 03:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431952;
        bh=6iiuLUwyjNk50xf94MQ7HUSs3rnb7OzMLuHg8ZF9tVY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jJdm3wNHrxXU7iFYLaMjU7FwwDGo2h2ohqfL3XdspmTPxWZAGVCxOkdq7xfL0tPTG
         fNsRzHUM8GXFxuFfkdEQC6UFXWnNre+y7Yon3f0+ezOb7oxf2aoLSsUOBHmBRre0ag
         c6Lfn7GNyuwP3SsdtyQje6FETaBDHbhX2BnK/+oCMWLdwlmGIaNmSLIUcFS9V24JY3
         HIJJRmK/4xbhiG3LXyLkvD//kkttpkMZSHh7aa2rc/zRpDDBjTWOuNHt8CnNezUPMP
         k1W6ZKSMoqh386qX77Id5FWmKFwh3gDhigBT7dP68e/yPs2s2SWOLS3fTdxF5VKnyo
         caexEymUnt0JA==
Subject: [PATCH 02/11] xfs: refactor the predicate part of xfs_free_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:05:51 -0800
Message-ID: <161543195167.1947934.16237799936089844524.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
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
 fs/xfs/xfs_bmap_util.c |  129 ++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_bmap_util.h |    1 
 2 files changed, 76 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e7d68318e6a5..21aa38183ae9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -628,27 +628,23 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 }
 
 /*
- * This is called to free any blocks beyond eof. The caller must hold
- * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
- * reference to the inode.
+ * Decide if this inode have post-EOF blocks.  The caller is responsible
+ * for knowing / caring about the PREALLOC/APPEND flags.
  */
 int
-xfs_free_eofblocks(
-	struct xfs_inode	*ip)
+xfs_has_eofblocks(
+	struct xfs_inode	*ip,
+	bool			*has)
 {
-	struct xfs_trans	*tp;
-	int			error;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		end_fsb;
 	xfs_fileoff_t		last_fsb;
 	xfs_filblks_t		map_len;
 	int			nimaps;
-	struct xfs_bmbt_irec	imap;
-	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
-	/*
-	 * Figure out if there are any blocks beyond the end
-	 * of the file.  If not, then there is nothing to do.
-	 */
+	*has = false;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
@@ -660,55 +656,80 @@ xfs_free_eofblocks(
 	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
+	if (error || nimaps == 0)
+		return error;
+
+	*has = imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
+	return 0;
+}
+
+/*
+ * This is called to free any blocks beyond eof. The caller must hold
+ * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
+ * reference to the inode.
+ */
+int
+xfs_free_eofblocks(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			has;
+	int			error;
+
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
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 9f993168b55b..af07a4a20d7c 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,6 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 
 /* EOF block manipulation functions */
+int	xfs_has_eofblocks(struct xfs_inode *ip, bool *has);
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
 int	xfs_free_eofblocks(struct xfs_inode *ip);
 

