Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AE2C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0AFD619F3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhCZAVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhCZAVL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2370F61A43;
        Fri, 26 Mar 2021 00:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718071;
        bh=lG1zA5DFWzjKvekkBucxBF9HweaAeaV3ilWqQfeVzcc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F8kwQfrKANUQk3uAg6pQu5Ylld8ynUq+j99aHNGoMFi1EeoPywYtjc7vmX7gCR33z
         L8rVwsJR0nhfWOTAI08V+FX9DwQBZwEbBFClPJ2c8Jaj0qeorTZcgtK/vlqMe+xOPP
         FSP6wSJnL0dRMVzpJzvpHZpKk07XvsPoXsHTbq9Hq4gDsE90u6BhFUuAoXutRrCXVp
         9mPmvI/FrEyfdZ1Bs384BNOTIObHXmLO4+7zG80u9l67NVv9ylmrmdJJzAg+7Y1h9y
         pYMAdyw3JlfTTxAG5PHejAOHsHvKij5fORxSb+DudUPD5mfvbjMsaeRYlJaA0mnXbx
         6juYviO2Fm4TA==
Subject: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:10 -0700
Message-ID: <161671807074.621829.1806705819432894284.stgit@magnolia>
In-Reply-To: <161671805938.621829.266575450099624132.stgit@magnolia>
References: <161671805938.621829.266575450099624132.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the weird split of responsibilities between xfs_can_free_eofblocks
and xfs_free_eofblocks by moving the chunk of code that looks for any
actual post-EOF space mappings from the second function into the first.

This clears the way for deferred inode inactivation to be able to decide
if an inode needs inactivation work before committing the released inode
to the inactivation code paths (vs. marking it for reclaim).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  155 ++++++++++++++++++++++++++----------------------
 1 file changed, 85 insertions(+), 70 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2b9991e5ea47..e79e3d1ff38d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -597,8 +597,24 @@ xfs_bmap_punch_delalloc_range(
  * regular files that are marked preallocated or append-only.
  */
 bool
-xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
+xfs_can_free_eofblocks(
+	struct xfs_inode	*ip,
+	bool			force)
 {
+	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		end_fsb;
+	xfs_fileoff_t		last_fsb;
+	int			nimaps = 1;
+	int			error;
+
+	/*
+	 * Caller must either hold the exclusive io lock; or be inactivating
+	 * the inode, which guarantees there are no other users of the inode.
+	 */
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL) ||
+	       (VFS_I(ip)->i_state & I_FREEING));
+
 	/* prealloc/delalloc exists only on regular files */
 	if (!S_ISREG(VFS_I(ip)->i_mode))
 		return false;
@@ -624,91 +640,90 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
 
-	return true;
-}
-
-/*
- * This is called to free any blocks beyond eof. The caller must hold
- * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
- * reference to the inode.
- */
-int
-xfs_free_eofblocks(
-	struct xfs_inode	*ip)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	xfs_fileoff_t		end_fsb;
-	xfs_fileoff_t		last_fsb;
-	xfs_filblks_t		map_len;
-	int			nimaps;
-	struct xfs_bmbt_irec	imap;
-	struct xfs_mount	*mp = ip->i_mount;
-
 	/*
-	 * Figure out if there are any blocks beyond the end
-	 * of the file.  If not, then there is nothing to do.
+	 * Do not try to free post-EOF blocks if EOF is beyond the end of the
+	 * range supported by the page cache, because the truncation will loop
+	 * forever.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
-		return 0;
-	map_len = last_fsb - end_fsb;
+		return false;
 
-	nimaps = 1;
+	/*
+	 * Look up the mapping for the first block past EOF.  If we can't find
+	 * it, there's nothing to free.
+	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
+	error = xfs_bmapi_read(ip, end_fsb, last_fsb - end_fsb, &imap, &nimaps,
+			0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (error || nimaps == 0)
+		return false;
 
 	/*
-	 * If there are blocks after the end of file, truncate the file to its
-	 * current size to free them up.
+	 * If there's a real mapping there or there are delayed allocation
+	 * reservations, then we have post-EOF blocks to try to free.
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
+	return imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
+}
 
-		/* wait on dio to ensure i_size has settled */
-		inode_dio_wait(VFS_I(ip));
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
+	int			error;
 
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
-				&tp);
-		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			return error;
-		}
+	/* Attach the dquots to the inode up front. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
+	/* Wait on dio to ensure i_size has settled. */
+	inode_dio_wait(VFS_I(ip));
 
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
+	 * Do not update the on-disk file size.  If we update the on-disk file
+	 * size and then the system crashes before the contents of the file are
+	 * flushed to disk then the files may be full of holes (ie NULL files
+	 * bug).
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
 

