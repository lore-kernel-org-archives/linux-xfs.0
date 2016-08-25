Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89E94838E
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:57:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 32E8A8F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:35 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kfeKKhUPBtjpFoDy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:33 -0700 (PDT)
Subject: [PATCH 20/24] xfs: cross-reference refcount btree during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:57:27 -0700
Message-ID: <147216944755.6398.7839427955228756441.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
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

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_refcount.c |   19 +++++++++++++++++++
 libxfs/xfs_refcount.h |    3 +++
 2 files changed, 22 insertions(+)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 7d3735f..2d747ba 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1534,3 +1534,22 @@ xfs_refcount_free_cow_extent(
 	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_FREE_COW,
 			fsb, len);
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_refcount_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rc.rc_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 105c246..a00400f 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -64,4 +64,7 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
 		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
 		xfs_extlen_t len);
 
+extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
