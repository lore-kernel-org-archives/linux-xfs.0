Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51293 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:53 -0400
Subject: [PATCH 08/16] libxfs: return bool from sb_version_hasmetauuid
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:08:48 -0700
Message-ID: <147830452891.26713.7192990963898417019.stgit@birch.djwong.org>
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

The kernel's version of this function returns bool, so do so here too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 8628bab..e14f964 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -536,7 +536,7 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
  * user-visible UUID to be changed on V5 filesystems which have a
  * filesystem UUID stamped into every piece of metadata.
  */
-static inline int xfs_sb_version_hasmetauuid(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);

