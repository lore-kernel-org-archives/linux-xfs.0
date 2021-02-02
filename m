Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1BEC43381
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1E64ED5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhBBCET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBBCEP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:04:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E4A64EDD;
        Tue,  2 Feb 2021 02:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231415;
        bh=+jHiDoEKbkF93coRyyuduiXisHBVXtQU/fZn2yOYzd4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OPutsc/AJCDkvFdYbJJ2ttU8W4bLgohrdvXs4NmNexev6asOIzJfDsJ2c32muNPUm
         4J7FnOl/dgT80g5LTu0EWIo9VePqgzBYFsCBiLxoo6TH88GDuMd5ld2sa64ikT46dZ
         b7C2n7tp7MctmWKrReUVrn4XePmvOHoAdHXuNvl9Wf61ge5P7RMFedJzLb4N94epsU
         Dgtqt3XZp3qeBdmqzO3u+w4RI0N0qtkWny4M79DIHw5moY6c+izcaUDW5aEs1kvo4q
         RXY5xjSl42+j1wA+jxAcvoTOz1vPnCWSakgYFAvIdH4Cpp+jghgJRCzpyIy7e5MTG6
         gGBo2NY4sqjZw==
Subject: [PATCH 03/16] xfs: create convenience wrappers for incore quota block
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:03:35 -0800
Message-ID: <161223141507.491593.13982158088212055815.stgit@magnolia>
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

Create a couple of convenience wrappers for creating and deleting quota
block reservations against future changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   10 ++++------
 fs/xfs/xfs_quota.h       |   19 +++++++++++++++++++
 fs/xfs/xfs_reflink.c     |    5 ++---
 3 files changed, 25 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c730288b5981..94d582a9587d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4097,8 +4097,7 @@ xfs_bmapi_reserve_delalloc(
 	 * blocks.  This number gets adjusted later.  We return if we haven't
 	 * allocated blocks already inside this loop.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
 		return error;
 
@@ -4144,8 +4143,7 @@ xfs_bmapi_reserve_delalloc(
 	xfs_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+		xfs_quota_unreserve_blkres(ip, alen);
 	return error;
 }
 
@@ -4937,8 +4935,8 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
-			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	ASSERT(!isrt);
+	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	if (error)
 		return error;
 	ip->i_delayed_blks -= del->br_blockcount;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 5a62398940d0..1d1a1634ea29 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -108,6 +108,12 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0,
+			XFS_QMOPT_RES_REGBLKS);
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
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -157,6 +170,12 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
+static inline int
+xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return xfs_quota_reserve_blkres(ip, -blocks);
+}
+
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 183142fd0961..bea64ed5a57f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,9 +508,8 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
-					del.br_blockcount, 0,
-					XFS_QMOPT_RES_REGBLKS);
+			error = xfs_quota_unreserve_blkres(ip,
+					del.br_blockcount);
 			if (error)
 				break;
 		} else {

