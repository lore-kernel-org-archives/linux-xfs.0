Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6638A29E07
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:32:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 470F58F804B
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:32:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FmuXx1Zt6tBmxw8N (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:32:55 -0700 (PDT)
Subject: [PATCH 05/11] xfs_repair: ignore "repaired" flag after we decide to
	clear xattr block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:52 -0700
Message-ID: <20150826003252.23973.60802.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
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

If in the course of examining extended attribute block contents we
first decide to repair an entry (*repair = 1) but secondly decide to
clear the whole block, set *repair = 0 because the clearing action
only happens if *repair == 0.  Put another way, if we're nuking a
block, don't pretend like we've fixed it too.

v2: fix all the paths to clear the attr block if the processing
functions error out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 83a07a8..c2b7c3a 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1311,6 +1311,13 @@ process_leaf_attr_block(
 		* we can add it then.
 		*/
 	}
+	/*
+	 * If we're just going to zap the block, don't pretend like we
+	 * repaired it, because repairing the block stops the clear
+	 * operation.
+	 */
+	if (clearit)
+		*repair = 0;
 	if (*repair)
 		xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, leaf, &leafhdr);
 
@@ -1524,6 +1531,7 @@ process_longform_attr(
 	xfs_dahash_t	next_hashval;
 	int		repairlinks = 0;
 	struct xfs_attr3_icleaf_hdr leafhdr;
+	int		error;
 
 	*repair = 0;
 
@@ -1589,6 +1597,7 @@ process_longform_attr(
 	case XFS_ATTR3_LEAF_MAGIC:
 		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
 				0, &next_hashval, repair)) {
+			*repair = 0;
 			/* the block is bad.  lose the attribute fork. */
 			libxfs_putbuf(bp);
 			return(1);
@@ -1604,12 +1613,16 @@ process_longform_attr(
 			libxfs_writebuf(bp, 0);
 		} else
 			libxfs_putbuf(bp);
-		return (process_node_attr(mp, ino, dip, blkmap)); /* + repair */
+		error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
+		if (error)
+			*repair = 0;
+		return error;
 	default:
 		do_warn(
 	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
 			be16_to_cpu(leaf->hdr.info.magic), ino);
 		libxfs_putbuf(bp);
+		*repair = 0;
 		return(1);
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
