Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99521C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7215A64EE0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhBBCEx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhBBCEw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9360C64ED6;
        Tue,  2 Feb 2021 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231449;
        bh=l2mHn/6QX0eIvPSWtmM5pMvLQIN5rTs0K7ckJridYko=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MRvfdJ9IVFECXcV6wqO588qRnuT9BQvYUi2vFQPENeq0F7IF79g77G+lEZ6SwgK/4
         gxyMkXk3Y9VbJax+I2lS8KiwQzB+TV5/y/rW0J/mhT9UWZuUa1giboKhjwDD54l8b3
         AwK02xb5nkCQoEuxje2joWYdCWowQC3Hf198OWeG79IShpp2bUB/y9J+gDkFX4zkmk
         g4WJ21a+N82FDkY9qAomE+u0tUTFbM0I6pinFEjcTtAJ4ZD5BpgoECADiGvPlypEs4
         ux9bUR1F9PCMuviUYFr1TacTF+RFQgryZPNzfqnTdPE2nLlZA7RW++YJ6KemXnP6KG
         BoWhwYf2jyWPg==
Subject: [PATCH 09/16] xfs: refactor common transaction/inode/quota allocation
 idiom
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:04:09 -0800
Message-ID: <161223144927.491593.10555860622988629255.stgit@magnolia>
In-Reply-To: <161223139756.491593.10895138838199018804.stgit@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new helper xfs_trans_alloc_inode that allocates a transaction,
locks and joins an inode to it, and then reserves the appropriate amount
of quota against that transction.  Then replace all the open-coded
idioms with a single call to this helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c |   11 +----------
 fs/xfs/libxfs/xfs_bmap.c |   10 ++--------
 fs/xfs/xfs_bmap_util.c   |   14 +++----------
 fs/xfs/xfs_iomap.c       |   11 ++---------
 fs/xfs/xfs_trans.c       |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |    3 +++
 6 files changed, 59 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e05dc0bc4a8f..cb95bc77fe59 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -458,14 +458,10 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	error = xfs_trans_alloc(mp, &tres, total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
+	error = xfs_trans_alloc_inode(dp, &tres, total, rsvd, &args->trans);
 	if (error)
 		return error;
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(args->trans, dp, 0);
-
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
@@ -474,11 +470,6 @@ xfs_attr_set(
 	}
 
 	if (args->value) {
-		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
-				args->total, 0, rsvd);
-		if (error)
-			goto out_trans_cancel;
-
 		error = xfs_has_attr(args);
 		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
 			goto out_trans_cancel;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6e6734398f0d..be6661645b59 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1079,19 +1079,13 @@ xfs_bmap_add_attrfork(
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks,
+			rsvd, &tp);
 	if (error)
 		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd);
-	if (error)
-		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_bmap_set_attrforkoff(ip, size, &version);
 	if (error)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ef8f7055af77..c5687ae437dc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -873,18 +873,10 @@ xfs_unmap_extent(
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	int			error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
-	if (error) {
-		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
+			false, &tp);
 	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ijoin(tp, ip, 0);
+		return error;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index fba7303d8ed6..ac91c971342d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -552,18 +552,11 @@ xfs_iomap_write_unwritten(
 		 * here as we might be asked to write out the same inode that we
 		 * complete here and might deadlock on the iolock.
 		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
-				XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
+				true, &tp);
 		if (error)
 			return error;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
-
-		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, true);
-		if (error)
-			goto error_on_bmapi_transaction;
-
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e72730f85af1..156b9ed8534f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_inode.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -1024,3 +1025,50 @@ xfs_trans_roll(
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	return xfs_trans_reserve(*tpp, &tres, 0, 0);
 }
+
+/*
+ * Allocate an transaction, lock and join the inode to it, and reserve quota.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The caller is responsible for
+ * releasing ILOCK_EXCL if a new transaction is returned.
+ */
+int
+xfs_trans_alloc_inode(
+	struct xfs_inode	*ip,
+	struct xfs_trans_res	*resv,
+	unsigned int		dblocks,
+	bool			force,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	error = xfs_trans_alloc(mp, resv, dblocks, 0,
+			force ? XFS_TRANS_RESERVE : 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, 0, force);
+	if (error)
+		goto out_cancel;
+
+	*tpp = tp;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 084658946cc8..aa50be244432 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,4 +268,7 @@ xfs_trans_item_relog(
 	return lip->li_ops->iop_relog(lip, tp);
 }
 
+int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
+		unsigned int dblocks, bool force, struct xfs_trans **tpp);
+
 #endif	/* __XFS_TRANS_H__ */

