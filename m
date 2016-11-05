Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51458 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752523AbcKEAJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:09:42 -0400
Subject: [PATCH 16/16] xfs: check minimum block size for CRC filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:09:38 -0700
Message-ID: <147830457847.26713.15949781885999402794.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check the minimum block size on v5 filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_sb.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index adc47e2..46e57aa 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -259,6 +259,13 @@ xfs_mount_validate_sb(
 		return -EFSCORRUPTED;
 	}
 
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    unlikely(
+	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE)) {
+		xfs_notice(mp, "v5 SB sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Currently only very few inode sizes are supported.
 	 */

