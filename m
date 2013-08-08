Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E32797F74
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:20:12 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:20:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 5/14] xfsprogs: sync commit f5f3d9b016 completely
Message-ID: <20130808212012.GS3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
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
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

TODO

---
 include/xfs_dir2_format.h |    2 +-
 libxfs/xfs_dir2_data.c    |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: b/include/xfs_dir2_format.h
===================================================================
--- a/include/xfs_dir2_format.h	2013-08-06 12:52:58.830818621 -0500
+++ b/include/xfs_dir2_format.h	2013-08-06 12:53:38.550877679 -0500
@@ -247,7 +247,7 @@ typedef struct xfs_dir2_data_free {
  */
 typedef struct xfs_dir2_data_hdr {
 	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
-	/* XFS_DIR2_BLOCK_MAGIC */
+						/* XFS_DIR2_BLOCK_MAGIC */
 	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
 } xfs_dir2_data_hdr_t;
 
Index: b/libxfs/xfs_dir2_data.c
===================================================================
--- a/libxfs/xfs_dir2_data.c	2013-08-06 12:54:17.540817693 -0500
+++ b/libxfs/xfs_dir2_data.c	2013-08-06 12:55:10.460877745 -0500
@@ -54,6 +54,7 @@ __xfs_dir2_data_check(
 	p = (char *)xfs_dir3_data_entry_p(hdr);
 
 	switch (be32_to_cpu(hdr->magic)) {
+		/* XXX bpm endian switch does not match commit */
 	case XFS_DIR2_BLOCK_MAGIC:
 	case XFS_DIR3_BLOCK_MAGIC:
 		btp = xfs_dir2_block_tail_p(mp, hdr);
@@ -203,6 +204,7 @@ xfs_dir2_data_reada_verify(
 	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
 
 	switch (be32_to_cpu(hdr->magic)) {
+		/* XXX bpm: endian switch does not match kernel commit */
 	case XFS_DIR2_BLOCK_MAGIC:
 	case XFS_DIR3_BLOCK_MAGIC:
 		bp->b_ops = &xfs_dir3_block_buf_ops;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
