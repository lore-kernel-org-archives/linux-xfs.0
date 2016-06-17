Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 21C2C7CB4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D76038F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id w55Kp5ddNcLI1xAN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:07 -0700 (PDT)
Subject: [PATCH 067/119] xfs: refcount btree requires more reserved space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:25:01 -0700
Message-ID: <146612670132.12839.1688051800857080032.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

The reference count btree is allocated from the free space, which
means that we have to ensure that an AG can't run out of free space
while performing a refcount operation.  In the pathological case each
AG block has its own refcntbt record, so we have to keep that much
space available.

v2: Calculate the maximum possible size of the rmap and refcount
btrees based on minimally-full btree blocks.  This increases the
per-AG block reservations to handle the worst case btree size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |    3 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |   23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    4 ++++
 3 files changed, 30 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index be5d0df..c46db76 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -38,6 +38,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
+#include "xfs_refcount_btree.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -138,6 +139,8 @@ xfs_alloc_ag_max_usable(struct xfs_mount *mp)
 		/* rmap root block + full tree split on full AG */
 		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
 	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks += xfs_refcountbt_max_size(mp);
 
 	return mp->m_sb.sb_agblocks - blocks;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 7093c71..a944fca 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -373,3 +373,26 @@ xfs_refcountbt_compute_maxlevels(
 	mp->m_refc_maxlevels = xfs_btree_compute_maxlevels(mp,
 			mp->m_refc_mnr, mp->m_sb.sb_agblocks);
 }
+
+/* Calculate the refcount btree size for some records. */
+xfs_extlen_t
+xfs_refcountbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_refc_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+xfs_extlen_t
+xfs_refcountbt_max_size(
+	struct xfs_mount	*mp)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_refc_mxr[0] == 0)
+		return 0;
+
+	return xfs_refcountbt_calc_size(mp, mp->m_sb.sb_agblocks);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 9e9ad7c..780b02f 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -64,4 +64,8 @@ extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
 		bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
+extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
