Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 937E17CA4
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:20:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58BEC8F8033
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gD99rwEzXq7pmrHH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:40 -0700 (PDT)
Subject: [PATCH 1/5] xfs: don't log the entire end of the AGF
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:20:35 -0700
Message-ID: <147200523494.14738.13569285576029583652.stgit@birch.djwong.org>
In-Reply-To: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
References: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
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

When we're logging the last non-spare field in the AGF, we don't
need to log the spare fields, so plumb in a new AGF logging flag
to help us avoid that.

(This patch is already in xfsprogs.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |    2 ++
 fs/xfs/libxfs/xfs_format.h |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3dd8f1d..05b5243 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2278,6 +2278,8 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_btreeblks),
 		offsetof(xfs_agf_t, agf_uuid),
 		offsetof(xfs_agf_t, agf_rmap_blocks),
+		/* needed so that we don't log the whole rest of the structure: */
+		offsetof(xfs_agf_t, agf_spare64),
 		sizeof(xfs_agf_t)
 	};
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e6a8bea..270fb5c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -674,7 +674,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BTREEBLKS	0x00000800
 #define	XFS_AGF_UUID		0x00001000
 #define	XFS_AGF_RMAP_BLOCKS	0x00002000
-#define	XFS_AGF_NUM_BITS	14
+#define	XFS_AGF_SPARE64		0x00004000
+#define	XFS_AGF_NUM_BITS	15
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
@@ -691,7 +692,8 @@ typedef struct xfs_agf {
 	{ XFS_AGF_LONGEST,	"LONGEST" }, \
 	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
 	{ XFS_AGF_UUID,		"UUID" }, \
-	{ XFS_AGF_RMAP_BLOCKS,	"RMAP_BLOCKS" }
+	{ XFS_AGF_RMAP_BLOCKS,	"RMAP_BLOCKS" }, \
+	{ XFS_AGF_SPARE64,	"SPARE64" }
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
