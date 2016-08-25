Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 937567D37
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:34:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1134EAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZSkLHeYL6jHG0y1A (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:16 -0700 (PDT)
Subject: [PATCH 21/71] xfs: refcount btree requires more reserved space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:34:12 -0700
Message-ID: <147216805266.867.13479037971772162849.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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
index 08ee609..6e81b27 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -38,6 +38,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
+#include "xfs_refcount_btree.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -128,6 +129,8 @@ xfs_alloc_ag_max_usable(
 		blocks++;		/* finobt root block */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		blocks++; 		/* rmap root block */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks++;		/* refcount root block */
 
 	return mp->m_sb.sb_agblocks - blocks;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 26f4eb7..c9d4823 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -381,3 +381,26 @@ xfs_refcountbt_compute_maxlevels(
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
