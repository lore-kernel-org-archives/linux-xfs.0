Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1C3780B1
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:01:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A399E304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:43 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id AKY1fsFp4jmDND3l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:40 -0800 (PST)
Subject: [PATCH 47/76] xfs: refcount btree requires more reserved space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:01:37 -0800
Message-ID: <20151219090137.12713.42513.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

The reference count btree is allocated from the free space, which
means that we have to ensure that an AG can't run out of free space
while performing a refcount operation.  In the pathological case each
AG block has its own refcntbt record, so we have to keep that much
space available.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |    3 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 +++
 3 files changed, 22 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 71dac69..637e2e7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -36,6 +36,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_refcount_btree.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -136,6 +137,8 @@ xfs_alloc_ag_max_usable(struct xfs_mount *mp)
 		/* rmap root block + full tree split on full AG */
 		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
 	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks += xfs_refcountbt_max_btree_size(mp);
 
 	return mp->m_sb.sb_agblocks - blocks;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index d7574cd..c785433 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -374,3 +374,19 @@ xfs_refcountbt_maxrecs(
 	return blocklen / (sizeof(struct xfs_refcount_key) +
 			   sizeof(xfs_refcount_ptr_t));
 }
+
+DEFINE_BTREE_SIZE_FN(refcountbt, m_refc_mxr, XFS_BTREE_MAXLEVELS);
+
+/**
+ * xfs_refcountbt_max_btree_size() -- Calculate the maximum refcount btree size.
+ */
+unsigned int
+xfs_refcountbt_max_btree_size(
+	struct xfs_mount	*mp)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_refc_mxr[0] == 0)
+		return 0;
+
+	return xfs_refcountbt_calc_btree_size(mp, mp->m_sb.sb_agblocks);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index d51dc1a..0f55544 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -62,4 +62,7 @@ extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
 		bool leaf);
 
+DECLARE_BTREE_SIZE_FN(refcountbt);
+extern unsigned int xfs_refcountbt_max_btree_size(struct xfs_mount *mp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
