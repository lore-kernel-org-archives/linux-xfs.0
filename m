Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9CDDB7FA9
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:24:13 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80D9A30408B
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 12:24:10 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r7MJO97i002948
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:24:09 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130822191237.812184436@sgi.com>
Date: Thu, 22 Aug 2013 13:50:27 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/2] xfsprog: add xfs sb v4 support for dirent filetype field
References: <20130822185026.111080968@sgi.com>
Content-Disposition: inline; filename=47-add-dir-filetype-to-inode-v2.patch
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

Add xfsprog superblock v4 support for the file type field in the
directory entry feature.

This support adds a feature bit for version 4 superblocks and
leaves the original superblock 5 incompatibility bit.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 include/xfs_sb.h |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: b/include/xfs_sb.h
===================================================================
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -84,11 +84,13 @@ struct xfs_trans;
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
 #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
+#define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
-	 XFS_SB_VERSION2_PROJID32BIT)
+	 XFS_SB_VERSION2_PROJID32BIT	| \
+	 XFS_SB_VERSION2_FTYPE)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -615,11 +617,6 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
-static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
-
 /*
  * V5 superblock specific feature checks
  */
@@ -628,10 +625,17 @@ static inline int xfs_sb_version_hascrc(
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
 static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
+	       (xfs_sb_version_hasmorebits(sbp) &&
+		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
