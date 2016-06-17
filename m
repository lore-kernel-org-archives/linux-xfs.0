Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF1A37CB4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:19:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9FD92304051
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:19:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gwedssGVf0XYlwb7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:19:00 -0700 (PDT)
Subject: [PATCH 010/119] xfs: create a standard btree size calculator code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:18:56 -0700
Message-ID: <146612633632.12839.13314497569643567486.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_btree.c |   27 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |    3 +++
 2 files changed, 30 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 105979d..5eb4e40 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4156,3 +4156,30 @@ xfs_btree_sblock_verify(
 
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 9a88839..b330f19 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
