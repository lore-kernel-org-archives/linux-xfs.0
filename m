Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76F067F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:44:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB59EAC003
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:44:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oBEQJTTSz3Piuqlp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:44:05 -0700 (PDT)
Subject: [PATCH 03/10] xfs_repair: ignore "repaired" flag after we decide to
	clear xattr block
From: "Darrick J. Wong" <djwong@alder.djwong.org>
Date: Fri, 14 Aug 2015 18:43:58 -0700
Message-ID: <20150815014357.1839.68720.stgit@birch.djwong.org>
In-Reply-To: <20150815014338.1839.37405.stgit@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 62f80e7..2bd9334 100644
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
 
@@ -1604,12 +1612,16 @@ process_longform_attr(
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
