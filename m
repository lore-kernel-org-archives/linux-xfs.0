Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B04108091
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:32:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3692EAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id j5RfEIUNt0uHRlpM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:16 -0700 (PDT)
Subject: [PATCH 014/145] xfs: create a standard btree size calculator code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:32:12 -0700
Message-ID: <146612713249.16048.10611335362447244031.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

Create a helper to generate AG btree height calculator functions.
This will be used (much) later when we get to the refcount btree.

v2: Use a helper function instead of a macro.
v3: We can (theoretically) store more than 2^32 records in a btree, so
    widen the fields to accept that.
v4: Don't modify xfs_bmap_worst_indlen; the purpose of /that/ function
    is to estimate the worst-case number of blocks needed for a bmbt
    expansion, not to calculate the space required to store nr records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c |   27 +++++++++++++++++++++++++++
 libxfs/xfs_btree.h |    3 +++
 2 files changed, 30 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 1448fd6..27e58b2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4152,3 +4152,30 @@ xfs_btree_sblock_verify(
 
 	return true;
 }
+
+/*
+ * Calculate the number of blocks needed to store a given number of records
+ * in a short-format (per-AG metadata) btree.
+ */
+xfs_extlen_t
+xfs_btree_calc_size(
+	struct xfs_mount	*mp,
+	uint			*limits,
+	unsigned long long	len)
+{
+	int			level;
+	int			maxrecs;
+	xfs_extlen_t		rval;
+
+	maxrecs = limits[0];
+	for (level = 0, rval = 0; len > 0; level++) {
+		len += maxrecs - 1;
+		do_div(len, maxrecs);
+		rval += len;
+		if (len == 1)
+			return rval;
+		if (level == 0)
+			maxrecs = limits[1];
+	}
+	return rval;
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 9a88839..b330f19 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -475,4 +475,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 
+xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
+		unsigned long long len);
+
 #endif	/* __XFS_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
