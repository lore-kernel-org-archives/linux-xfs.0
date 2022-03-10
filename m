Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E733C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 21:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245253AbiCJVyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 16:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240392AbiCJVyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 16:54:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCDA136EED
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 13:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9747A61AC1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 21:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03045C340E9;
        Thu, 10 Mar 2022 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949214;
        bh=4bzV0E+nMmz3NIXsJ7R64gHJhTVob+VQEWHp132spYw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cUH3Pm36A32ytKhKhJ877lsgApbyyoL3sY4o3KsjgIgDb7O81bBYhYKZ1LmXnSvg5
         GOZVdVDEPJgMU/W3hH6wlKUXmSk6D3kU0Ao6lctCk7+S7IBYnyibtQakxV74f2tV5R
         MFwODbJ7cq04pdcqqnctrElIK0tMJFYKfgMvTgqJxBE1A5RrUEs3XHYf+8U8p0ujEw
         Mjz8CNmY4DuYyANT9ZXlUOnVrebuFE7szvlaxxY0I1JAO281IBWxJiTb1akQcEf/wZ
         SwWkUS6R3/iJzfDlEFW9z3WUXhWpzifUvmQzn64Q5RagKYqb+ItK2XmriG2Myt3P0r
         INaeFp90RWI+A==
Subject: [PATCH 1/2] xfs: reserve quota for dir expansion when
 linking/unlinking files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 10 Mar 2022 13:53:33 -0800
Message-ID: <164694921349.1119636.8537050445789359437.stgit@magnolia>
In-Reply-To: <164694920783.1119636.13401244964062260779.stgit@magnolia>
References: <164694920783.1119636.13401244964062260779.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS does not reserve quota for directory expansion when linking or
unlinking children from a directory.  This means that we don't reject
the expansion with EDQUOT when we're at or near a hard limit, which
means that unprivileged userspace can use link()/unlink() to exceed
quota.

The fix for this is nuanced -- link operations don't always expand the
directory, and we allow a link to proceed with no space reservation if
we don't need to add a block to the directory to handle the addition.
Unlink operations generally do not expand the directory (you'd have to
free a block and then cause a btree split) and we can defer the
directory block freeing if there is no space reservation.

Moreover, there is a further bug in that we do not trigger the blockgc
workers to try to clear space when we're out of quota.

To fix both cases, create a new xfs_trans_alloc_dir function that
allocates the transaction, locks and joins the inodes, and reserves
quota for the directory.  If there isn't sufficient space or quota,
we'll switch the caller to reservationless mode.  This should prevent
quota usage overruns with the least restriction in functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   46 ++++++++++------------------
 fs/xfs/xfs_trans.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |    3 ++
 3 files changed, 106 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04bf467b1090..766a621b970d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1217,7 +1217,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
-	int			error;
+	int			error, nospace_error = 0;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1236,19 +1236,11 @@ xfs_link(
 		goto std_return;
 
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
-	}
+	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
+			&tp, &nospace_error);
 	if (error)
 		goto std_return;
 
-	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
-
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1306,6 +1298,8 @@ xfs_link(
  error_return:
 	xfs_trans_cancel(tp);
  std_return:
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
@@ -2755,6 +2749,7 @@ xfs_remove(
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
+	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
 
@@ -2772,31 +2767,24 @@ xfs_remove(
 		goto std_return;
 
 	/*
-	 * We try to get the real space reservation first,
-	 * allowing for directory btree deletion(s) implying
-	 * possible bmap insert(s).  If we can't get the space
-	 * reservation then we use 0 instead, and avoid the bmap
-	 * btree insert(s) in the directory code by, if the bmap
-	 * insert tries to happen, instead trimming the LAST
-	 * block from the directory.
+	 * We try to get the real space reservation first, allowing for
+	 * directory btree deletion(s) implying possible bmap insert(s).  If we
+	 * can't get the space reservation then we use 0 instead, and avoid the
+	 * bmap btree insert(s) in the directory code by, if the bmap insert
+	 * tries to happen, instead trimming the LAST block from the directory.
+	 *
+	 * Ignore EDQUOT and ENOSPC being returned via nospace_error because
+	 * the directory code can handle a reservationless update and we don't
+	 * want to prevent a user from trying to free space by deleting things.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
-				&tp);
-	}
+	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
+			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto std_return;
 	}
 
-	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 59e2f9031b9f..3d11f9bb0dbb 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1210,3 +1210,89 @@ xfs_trans_alloc_ichange(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.  If there isn't sufficient space,
+ * @dblocks will be set to zero for a reservationless directory update and
+ * @nospace_error will be set to a negative errno describing the space
+ * constraint we hit.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The ILOCKs will be dropped when the
+ * transaction is committed or cancelled.
+ */
+int
+xfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		*dblocks,
+	struct xfs_trans	**tpp,
+	int			*nospace_error)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		resblks;
+	bool			retried = false;
+	int			error;
+
+retry:
+	*nospace_error = 0;
+	resblks = *dblocks;
+	error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	if (error == -ENOSPC) {
+		*nospace_error = error;
+		resblks = 0;
+		error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	}
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_qm_dqattach_locked(dp, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	if (resblks == 0)
+		goto done;
+
+	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
+	if (error == -EDQUOT || error == -ENOSPC) {
+		if (!retried) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_quota(dp, 0);
+			retried = true;
+			goto retry;
+		}
+
+		*nospace_error = error;
+		resblks = 0;
+		error = 0;
+	}
+	if (error)
+		goto out_cancel;
+
+done:
+	*tpp = tp;
+	*dblocks = resblks;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a487b264a9eb..faa282204498 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -259,6 +259,9 @@ int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
 int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+		struct xfs_inode *ip, unsigned int *dblocks,
+		struct xfs_trans **tpp, int *nospace_error);
 
 static inline void
 xfs_trans_set_context(

