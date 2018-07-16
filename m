Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728075AbeGPTzr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jul 2018 15:55:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F060C4070489
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jul 2018 19:26:56 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-122-15.rdu2.redhat.com [10.10.122.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 625612026D65
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jul 2018 19:26:56 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH v2] libxfs: add more bounds checking to sb sanity checks
Date: Mon, 16 Jul 2018 14:26:55 -0500
Message-Id: <20180716192655.27792-1-billodo@redhat.com>
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
v2: make extra sanity checks exclusive to writes (allow read)

 fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 350119eeaecb..6a98ec68e8ad 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -104,7 +104,8 @@ xfs_mount_validate_sb(
 	xfs_mount_t	*mp,
 	xfs_sb_t	*sbp,
 	bool		check_inprogress,
-	bool		check_version)
+	bool		check_version,
+	bool		write_flag)
 {
 	uint32_t	agcount = 0;
 	uint32_t	rem;
@@ -266,6 +267,15 @@ xfs_mount_validate_sb(
 		return -EFSCORRUPTED;
 	}
 
+	/* Additional sb sanity checks for writes */
+	if (write_flag) {
+		if (sbp->sb_fdblocks > sbp->sb_dblocks ||
+		    sbp->sb_ifree > sbp->sb_icount) {
+			    xfs_notice(mp, "SB sanity check failed");
+			    return -EFSCORRUPTED;
+		}
+	}
+
 	if (sbp->sb_unit) {
 		if (!xfs_sb_version_hasdalign(sbp) ||
 		    sbp->sb_unit > sbp->sb_width ||
@@ -599,7 +609,9 @@ xfs_sb_to_disk(
 static int
 xfs_sb_verify(
 	struct xfs_buf	*bp,
-	bool		check_version)
+	bool		check_version,
+	bool		write_flag)
+
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
@@ -616,7 +628,7 @@ xfs_sb_verify(
 	 */
 	return xfs_mount_validate_sb(mp, &sb,
 				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
-				     check_version);
+				     check_version, write_flag);
 }
 
 /*
@@ -657,7 +669,7 @@ xfs_sb_read_verify(
 			}
 		}
 	}
-	error = xfs_sb_verify(bp, true);
+	error = xfs_sb_verify(bp, true, false);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
@@ -695,7 +707,7 @@ xfs_sb_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			error;
 
-	error = xfs_sb_verify(bp, false);
+	error = xfs_sb_verify(bp, false, true);
 	if (error) {
 		xfs_verifier_error(bp, error, __this_address);
 		return;
-- 
2.17.1

