Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E96FC43381
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E0F364EDB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhBBCFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhBBCFI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:05:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE0164ED5;
        Tue,  2 Feb 2021 02:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231466;
        bh=SvwsHcwr5mcNr7mbef8pJj99rkli0PTAWy+vEa1EZCk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XVFohS/zTGVEgUlac4f8WMyPfYSxD+DlrNvUDLgHha/nfi94BEZZxTGlDXMQLhow4
         OoapSYmg4f5yqX2PnfyuiU4Y2yWM7IMDTS+9fHYW6g6PkWI//GoqEcdHwixNkbr88+
         +zeS/VZz3LnCbUEpLM2NJUPrUU9f59pmKhJ4Re+Xp1rneElCuxQY5lS8zA7CN1FLDd
         R+xtthui+01mcviVBiS8ScnIRsX+wpaKnko3433GQaWxHNwfKKefarG8iX+HSbRjqk
         nQ6Gky1NY3jbCO9J2bYal3CuDhV47ciOIorNIXH4GltSPI+hW1CEecOhnWjFRydEU/
         B8Zsqn9ew3MDg==
Subject: [PATCH 12/16] xfs: refactor inode creation transaction/inode/quota
 allocation idiom
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:04:26 -0800
Message-ID: <161223146614.491593.11301427761911644549.stgit@magnolia>
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

For file creation, create a new helper xfs_trans_alloc_icreate that
allocates a transaction and reserves the appropriate amount of quota
against that transction.  Replace all the open-coded idioms with a
single call to this helper so that we can contain the retry loops in the
next patchset.

This changes the locking behavior for non-tempfile creation slightly, in
that we now make the quota reservation without holding the directory
ILOCK.  While the dquots chosen for inode creation are based on the
directory state at a given point in time, the directory ILOCK was
released as soon as the dquot references are picked up.  Hence it was
never necessary to hold the directory ILOCK for the quota reservation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c   |   28 ++++++++++------------------
 fs/xfs/xfs_symlink.c |   14 ++++----------
 fs/xfs/xfs_trans.c   |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h   |    6 ++++++
 4 files changed, 53 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4bbd2fb628f7..636ac13b1df2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1022,25 +1022,20 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
+			&tp);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+		error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
+				resblks, &tp);
 	}
 	if (error)
-		goto out_release_inode;
+		goto out_release_dquots;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	/*
-	 * Reserve disk quota and the inode.
-	 */
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
-	if (error)
-		goto out_trans_cancel;
-
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1120,7 +1115,7 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+ out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
@@ -1164,13 +1159,10 @@ xfs_create_tmpfile(
 	resblks = XFS_IALLOC_SPACE_RES(mp);
 	tres = &M_RES(mp)->tr_create_tmpfile;
 
-	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
+			&tp);
 	if (error)
-		goto out_release_inode;
-
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
-	if (error)
-		goto out_trans_cancel;
+		goto out_release_dquots;
 
 	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
@@ -1213,7 +1205,7 @@ xfs_create_tmpfile(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+ out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d5dee8f409b2..8565663b16cd 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -197,9 +197,10 @@ xfs_symlink(
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
+			pdqp, resblks, &tp);
 	if (error)
-		goto out_release_inode;
+		goto out_release_dquots;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -212,13 +213,6 @@ xfs_symlink(
 		goto out_trans_cancel;
 	}
 
-	/*
-	 * Reserve disk quota : blocks and inode.
-	 */
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
-	if (error)
-		goto out_trans_cancel;
-
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -347,7 +341,7 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 151f274eee43..6c68635cc6ac 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -21,6 +21,8 @@
 #include "xfs_error.h"
 #include "xfs_defer.h"
 #include "xfs_inode.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -1074,3 +1076,34 @@ xfs_trans_alloc_inode(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
+
+/*
+ * Allocate an transaction in preparation for inode creation by reserving quota
+ * against the given dquots.  Callers are not required to hold any inode locks.
+ */
+int
+xfs_trans_alloc_icreate(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*resv,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	unsigned int		dblocks,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, resv, dblocks, 0, 0, &tp);
+	if (error)
+		return error;
+
+	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	*tpp = tp;
+	return 0;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 52bbd7e6a552..04c132c55e9b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,8 +268,14 @@ xfs_trans_item_relog(
 	return lip->li_ops->iop_relog(lip, tp);
 }
 
+struct xfs_dquot;
+
 int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
 		unsigned int dblocks, unsigned int rblocks, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int dblocks,
+		struct xfs_trans **tpp);
 
 #endif	/* __XFS_TRANS_H__ */

