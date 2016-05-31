Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7CE47CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 14:33:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5317BAC001
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 12:33:02 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id K8q22CVStMBy4viz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 12:32:59 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, reflink] xfs: fix logging of AGF refcount btree fields
Date: Tue, 31 May 2016 21:32:55 +0200
Message-Id: <1464723175-2164-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

These fields are separate from the existing roots and levels array
and thus need a separate logging flag.

That being said the API to logs the AGI/AGF is a bit of a nightmare,
and I have an idea how to improve it.  Stay tuned..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c          | 4 ++++
 fs/xfs/libxfs/xfs_format.h         | 5 ++++-
 fs/xfs/libxfs/xfs_refcount_btree.c | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6cbca1b..e6e32c2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2327,6 +2327,10 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_longest),
 		offsetof(xfs_agf_t, agf_btreeblks),
 		offsetof(xfs_agf_t, agf_uuid),
+		offsetof(xfs_agf_t, agf_refcount_root),
+		offsetof(xfs_agf_t, agf_refcount_level),
+		/* needed so that we don't log the whole rest of the structure: */
+		offsetof(xfs_agf_t, agf_spare64),
 		sizeof(xfs_agf_t)
 	};
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e00037c..5cc0b8c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -681,7 +681,10 @@ typedef struct xfs_agf {
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
 #define	XFS_AGF_UUID		0x00001000
-#define	XFS_AGF_NUM_BITS	13
+#define	XFS_AGF_REFCOUNT_ROOT	0x00002000
+#define	XFS_AGF_REFCOUNT_LEVEL	0x00004000
+#define	XFS_AGF_SPARE64		0x00008000
+#define	XFS_AGF_NUM_BITS	16
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 3391cbd..303f959 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -61,7 +61,8 @@ xfs_refcountbt_set_root(
 	pag->pagf_refcount_level += inc;
 	xfs_perag_put(pag);
 
-	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+	xfs_alloc_log_agf(cur->bc_tp, agbp,
+			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
 }
 
 STATIC int
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
