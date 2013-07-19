Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6129B80B0
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43804304039
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	X2W6td62pTqAabqc for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004I7-LM
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002JM-KP
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/49] libxfs: fix directory/attribute format issues
Date: Fri, 19 Jul 2013 16:44:39 +1000
Message-Id: <1374216324-8781-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

directory data headers and attr leaf headers need padding for 32 bit
systems to correctly align the data sections on 64 bit boundaries.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_attr_leaf.h   | 1 +
 include/xfs_dir2_format.h | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/xfs_attr_leaf.h b/include/xfs_attr_leaf.h
index b3e93bb..c102213 100644
--- a/include/xfs_attr_leaf.h
+++ b/include/xfs_attr_leaf.h
@@ -128,6 +128,7 @@ struct xfs_attr3_leaf_hdr {
 	__u8			holes;
 	__u8			pad1;
 	struct xfs_attr_leaf_map freemap[XFS_ATTR_LEAF_MAPSIZE];
+	__be32			pad2;		/* 64 bit alignment */
 };
 
 #define XFS_ATTR3_LEAF_CRC_OFF	(offsetof(struct xfs_attr3_leaf_hdr, info.crc))
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index 8c16bb0..4126e86 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -260,6 +260,7 @@ struct xfs_dir3_blk_hdr {
 struct xfs_dir3_data_hdr {
 	struct xfs_dir3_blk_hdr	hdr;
 	xfs_dir2_data_free_t	best_free[XFS_DIR2_DATA_FD_COUNT];
+	__be32			pad;	/* 64 bit alignment */
 };
 
 #define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
@@ -471,7 +472,7 @@ struct xfs_dir3_leaf_hdr {
 	struct xfs_da3_blkinfo	info;		/* header for da routines */
 	__be16			count;		/* count of entries */
 	__be16			stale;		/* count of stale entries */
-	__be32			pad;
+	__be32			pad;		/* 64 bit alignment */
 };
 
 struct xfs_dir3_icleaf_hdr {
@@ -712,7 +713,7 @@ struct xfs_dir3_free_hdr {
 	__be32			firstdb;	/* db of first entry */
 	__be32			nvalid;		/* count of valid entries */
 	__be32			nused;		/* count of used entries */
-	__be32			pad;		/* 64 bit alignment. */
+	__be32			pad;		/* 64 bit alignment */
 };
 
 struct xfs_dir3_free {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
