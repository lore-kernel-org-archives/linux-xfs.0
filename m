Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C9927CD2
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:32:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA3C18F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uSppi8WMfNcEKOp7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:15 -0700 (PDT)
Subject: [PATCH 02/71] xfs: create a standard btree size calculator code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:32:09 -0700
Message-ID: <147216792896.867.711816517859232858.stgit@birch.djwong.org>
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

Create a helper to generate AG btree height calculator functions.
This will be used (much) later when we get to the refcount btree.

v2: Use a helper function instead of a macro.
v3: We can (theoretically) store more than 2^32 records in a btree, so
    widen the fields to accept that.
v4: Don't modify xfs_bmap_worst_indlen; the purpose of /that/ function
    is to estimate the worst-case number of blocks needed for a bmbt
    expansion, not to calculate the space required to store nr records.
v5: More minor tweaks to the loop control; move down to reflink patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   24 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 2 files changed, 26 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d1155ca..1bc483b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4801,3 +4801,27 @@ xfs_btree_query_range(
 	return xfs_btree_overlapped_query_range(cur, &low_key, &high_key,
 			fn, priv);
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
+	for (level = 0, rval = 0; len > 1; level++) {
+		len += maxrecs - 1;
+		do_div(len, maxrecs);
+		maxrecs = limits[1];
+		rval += len;
+	}
+	return rval;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 870a5ab..607463a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -501,6 +501,8 @@ bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
+xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
+		unsigned long long len);
 
 /* return codes */
 #define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
