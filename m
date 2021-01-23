Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F4DC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6043123340
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbhAWSwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAWSwb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:52:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A5922D57;
        Sat, 23 Jan 2021 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427910;
        bh=J619jnrWkyLVw5zOkr76AmmOJ/QMSYPoRwWobWJH6tE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CQF0md3z2rUNeCjmsqdNAKQuviKjLJKTzQWysKAxEkcFg1mYhta/RKF9E9gHRFj2N
         NxMMj2YvtuztGxtUcnb7DtdbQtyjQxX/0vQZWPYTgH58DTXE5tvOCuNn9YYLo1yLQP
         vRYRsd5m0mesEPJYa5gquXAxT1xgsoS2zB68d3D1sR3v1dAwnAJwy88ShwdxestsI0
         PpZ4ex9ErdJNZiZQOjl3ta8MUEep8CH0Ncpd+Ou8gFUSkiLWgf94rWbBoIDHPlN4tF
         lGOyAj17FCHo4oGxZtMBlKgbu5wBuH4JNx00aKcrqznp21iKvyBisDvmVEFAzUimzg
         UMZn33Ky+hICQ==
Subject: [PATCH 3/4] xfs: create convenience wrappers for incore quota block
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:51:51 -0800
Message-ID: <161142791177.2170981.5671264062040255172.stgit@magnolia>
In-Reply-To: <161142789504.2170981.1372317837643770452.stgit@magnolia>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a couple of convenience wrappers for creating and deleting quota
block reservations against future changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   12 ++++++------
 fs/xfs/xfs_quota.h       |   19 +++++++++++++++++++
 fs/xfs/xfs_reflink.c     |    6 +++---
 3 files changed, 28 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aea179212946..908b7d49da60 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4067,9 +4067,12 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
+	bool			isrt;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
+	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
@@ -4098,8 +4101,7 @@ xfs_bmapi_reserve_delalloc(
 	 * blocks.  This number gets adjusted later.  We return if we haven't
 	 * allocated blocks already inside this loop.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_reserve_blkres(ip, alen, isrt);
 	if (error)
 		return error;
 
@@ -4145,8 +4147,7 @@ xfs_bmapi_reserve_delalloc(
 	xfs_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+		xfs_quota_unreserve_blkres(ip, alen, isrt);
 	return error;
 }
 
@@ -4938,8 +4939,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
-			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount, isrt);
 	if (error)
 		return error;
 	ip->i_delayed_blks -= del->br_blockcount;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index bd28d17941e7..a25e3ce04c60 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -108,6 +108,12 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
+{
+	return xfs_trans_reserve_quota_nblks(NULL, ip, nblks, 0,
+			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+}
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -136,6 +142,13 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 {
 	return 0;
 }
+
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
+{
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -162,6 +175,12 @@ xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
+static inline int
+xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
+{
+	return xfs_quota_reserve_blkres(ip, -nblks, isrt);
+}
+
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 183142fd0961..0da1a603b7d8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,9 +508,9 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
-					del.br_blockcount, 0,
-					XFS_QMOPT_RES_REGBLKS);
+			error = xfs_quota_unreserve_blkres(ip,
+					del.br_blockcount,
+					XFS_IS_REALTIME_INODE(ip));
 			if (error)
 				break;
 		} else {

