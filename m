Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5D997FC8
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF8D88F8035
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tZBE7m24aiDx82yH for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:40 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4E-0003As-Mn
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4E-0000EM-HS
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/50] libxfs: fix directory/attribute format issues
Date: Wed, 19 Jun 2013 15:35:35 +1000
Message-Id: <1371620173-712-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
 include/xfs_attr_leaf.h   |    1 +
 include/xfs_dir2_format.h |    5 +++--
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
index 3a73736..2095e17 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -266,6 +266,7 @@ struct xfs_dir3_blk_hdr {
 struct xfs_dir3_data_hdr {
 	struct xfs_dir3_blk_hdr	hdr;
 	xfs_dir2_data_free_t	best_free[XFS_DIR2_DATA_FD_COUNT];
+	__be32			pad;	/* 64 bit alignment */
 };
 
 #define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
@@ -477,7 +478,7 @@ struct xfs_dir3_leaf_hdr {
 	struct xfs_da3_blkinfo	info;		/* header for da routines */
 	__be16			count;		/* count of entries */
 	__be16			stale;		/* count of stale entries */
-	__be32			pad;
+	__be32			pad;		/* 64 bit alignment */
 };
 
 struct xfs_dir3_icleaf_hdr {
@@ -718,7 +719,7 @@ struct xfs_dir3_free_hdr {
 	__be32			firstdb;	/* db of first entry */
 	__be32			nvalid;		/* count of valid entries */
 	__be32			nused;		/* count of used entries */
-	__be32			pad;		/* 64 bit alignment. */
+	__be32			pad;		/* 64 bit alignment */
 };
 
 struct xfs_dir3_free {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
