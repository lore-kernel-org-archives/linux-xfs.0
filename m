Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeGaFeR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 01:34:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6V3slQQ177745
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:56:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2kgh4py0yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:56:05 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6V3u3on015012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:56:04 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6V3u3wZ000943
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:56:03 GMT
Subject: [PATCH 4/4] xfs: check for unknown v5 feature bits in superblock
 write verifier
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jul 2018 20:56:02 -0700
Message-ID: <153300936259.5164.13952216512619844940.stgit@magnolia>
In-Reply-To: <153300933773.5164.7520087911614107147.stgit@magnolia>
References: <153300933773.5164.7520087911614107147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we never try to write the superblock with unknown feature bits
set.  We checked those at mount time, so if they're set now then memory
is corrupt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 05e7ed1b8022..ca1b3a7a9171 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -166,7 +166,40 @@ xfs_validate_sb_write(
 	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
 		return 0;
 
-	/* XXX: For write validation, we don't need to check feature masks?? */
+	/*
+	 * Version 5 superblock feature mask validation. Reject combinations
+	 * the kernel cannot support since we checked for unsupported bits in
+	 * the read verifier, which means that memory is corrupt.
+	 */
+	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
+		xfs_warn(mp,
+"Corruption detected in superblock compatible features (0x%x)!",
+			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
+		return -EFSCORRUPTED;
+	}
+
+	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+		xfs_alert(mp,
+"Corruption detected in superblock read-only compatible features (0x%x)!",
+			(sbp->sb_features_ro_compat &
+					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		return -EFSCORRUPTED;
+	}
+	if (xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
+		xfs_warn(mp,
+"Corruption detected in superblock incompatible features (0x%x)!",
+			(sbp->sb_features_incompat &
+					XFS_SB_FEAT_INCOMPAT_UNKNOWN));
+		return -EFSCORRUPTED;
+	}
+	if (xfs_sb_has_incompat_log_feature(sbp,
+			XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
+		xfs_warn(mp,
+"Corruption detected in superblock incompatible log features (0x%x)!",
+			(sbp->sb_features_log_incompat &
+					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * We can't read verify the sb LSN because the read verifier is called

