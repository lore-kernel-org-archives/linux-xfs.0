Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5410C7F77
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:24:16 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:24:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 6/14] xfsprogs: cleanup some whitespace
Message-ID: <20130808212415.GT3111@sgi.com>
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

This whitespace was added in patch 10 of the crc-dev series.

The extra ; in xfs_dir3_free_get_buf was taken care of in another patch.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 libxfs/xfs_dir2_node.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/libxfs/xfs_dir2_node.c
===================================================================
--- a/libxfs/xfs_dir2_node.c	2013-08-06 16:17:36.570193682 -0500
+++ b/libxfs/xfs_dir2_node.c	2013-08-06 16:44:23.730877972 -0500
@@ -257,7 +257,6 @@ xfs_dir3_free_get_buf(
 		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
-
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
 	xfs_dir3_free_hdr_to_disk(bp->b_addr, &hdr);
@@ -1101,7 +1100,6 @@ xfs_dir3_data_block_free(
 	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
 
-
 	xfs_dir3_free_hdr_from_disk(&freehdr, free);
 
 	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
@@ -1159,7 +1157,6 @@ xfs_dir3_data_block_free(
 		 */
 	}
 
-
 	/* Log the free entry that changed, unless we got rid of it.  */
 	if (logfree)
 		xfs_dir2_free_log_bests(tp, fbp, findex, findex);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
