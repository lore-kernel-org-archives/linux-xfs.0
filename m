Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731801AbeGZR6Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 13:58:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E40DD72621
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 16:40:46 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-63.rdu2.redhat.com [10.10.121.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEC202142F20
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 16:40:46 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH v4] libxfs: add more bounds checking to sb sanity checks
Date: Thu, 26 Jul 2018 11:40:46 -0500
Message-Id: <20180726164046.18503-1-billodo@redhat.com>
In-Reply-To: <20180713131003.31121-1-billodo@redhat.com>
References: <20180713131003.31121-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
Add sanity checks for these parameters.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---

v4: adjust control flow to standard error checking. Add
    more descriptive comment. Add validation for sb_icount.
v3: eliminate need for additional write_flag, doing those
    unique checks in xfs_sb_write_verify()
v2: make extra sanity checks exclusive to writes

 fs/xfs/libxfs/xfs_sb.c | 46 +++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b3ad15956366..8d8e579ca426 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -599,22 +599,16 @@ xfs_sb_to_disk(
 static int
 xfs_sb_verify(
 	struct xfs_buf	*bp,
+	struct xfs_sb	*sb,
 	bool		check_version)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_sb	sb;
-
-	/*
-	 * Use call variant which doesn't convert quota flags from disk 
-	 * format, because xfs_mount_validate_sb checks the on-disk flags.
-	 */
-	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
 
 	/*
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
 	 */
-	return xfs_mount_validate_sb(mp, &sb,
+	return xfs_mount_validate_sb(mp, sb,
 				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
 				     check_version);
 }
@@ -637,6 +631,7 @@ xfs_sb_read_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_sb	sb;
 	int		error;
 
 	/*
@@ -657,7 +652,13 @@ xfs_sb_read_verify(
 			}
 		}
 	}
-	error = xfs_sb_verify(bp, true);
+
+	/*
+	 * Use call variant which doesn't convert quota flags from disk
+	 * format, because xfs_mount_validate_sb checks the on-disk flags.
+	 */
+	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+	error = xfs_sb_verify(bp, &sb, true);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
@@ -693,9 +694,34 @@ xfs_sb_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_sb		sb;
 	int			error;
 
-	error = xfs_sb_verify(bp, false);
+	/*
+	 * Use call variant which doesn't convert quota flags from disk
+	 * format, because xfs_mount_validate_sb checks the on-disk flags.
+	 */
+	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+
+	error = xfs_sb_verify(bp, &sb, false);
+	if (error)
+		goto err;
+
+	/*
+	 * Carry out additional sb sanity checks exclusively for writes.
+	 * We don't do these checks for reads, since faulty parameters could
+	 * already be on disk, and we shouldn't preclude reads for those
+	 * cases.
+	 */
+	if (sb.sb_fdblocks > sb.sb_dblocks ||
+	    sb.sb_icount / sb.sb_inopblock > sb.sb_dblocks ||
+	    sb.sb_ifree > sb.sb_icount) {
+		xfs_notice(mp, "SB sanity check failed");
+		error = -EFSCORRUPTED;
+		goto err;
+	}
+
+err:
 	if (error) {
 		xfs_verifier_error(bp, error, __this_address);
 		return;
-- 
2.17.1

