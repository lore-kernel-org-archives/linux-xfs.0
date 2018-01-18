Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36290 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbeARAL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:11:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I0BmVB187798
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:11:55 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fjewf0cqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:11:51 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07Plf023196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:25 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07Ohe003235
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:25 GMT
Subject: [PATCH 2/5] xfs: introduce 'fixed agfl' feature
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 16:07:23 -0800
Message-ID: <151623404388.4727.13556729503051957189.stgit@magnolia>
In-Reply-To: <151623403113.4727.2418454911805718650.stgit@magnolia>
References: <151623403113.4727.2418454911805718650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce a new rocompat flag "FIXED_AGFL" to indicate that we've
scanned and verified that the AGFL does not hit the troublesome last
element of the AGFL array, and update xfs_agfl_size to its new
definition based on this feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index bb42a11..3befc92f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -464,6 +464,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL (1 << 3)	/* fixed agfl */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -566,6 +567,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+static inline bool xfs_sb_version_hasfixedagfl(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL);
+}
+
 /*
  * end of superblock version macros
  */

