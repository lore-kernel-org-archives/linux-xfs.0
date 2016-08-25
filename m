Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9DA6782FD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:56:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 452FD8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jJlrkeAoEHhUjGv8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:07 -0700 (PDT)
Subject: [PATCH 07/24] xfs: scrub AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:56:03 -0700
Message-ID: <147216936304.6398.907217110911507233.stgit@birch.djwong.org>
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

Check the block references in the AGF and AGFL headers to make sure
they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |    2 +-
 libxfs/xfs_alloc.h |    2 ++
 libxfs/xfs_fs.h    |    4 +++-
 3 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 0f93016..055d57e 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -625,7 +625,7 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 /*
  * Read in the allocation group free block array.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 0b00de0..c3ada6b 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -204,6 +204,8 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, struct xfs_buf **bpp);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 64c7b43..dbdd346 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -560,7 +560,9 @@ struct xfs_scrub_metadata {
  * Metadata types and flags for scrub operation.
  */
 #define XFS_SCRUB_TYPE_SB	0	/* superblock */
-#define XFS_SCRUB_TYPE_MAX	0
+#define XFS_SCRUB_TYPE_AGF	1	/* AG free header */
+#define XFS_SCRUB_TYPE_AGFL	2	/* AG free list */
+#define XFS_SCRUB_TYPE_MAX	2
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
