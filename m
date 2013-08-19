Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A4E27F98
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 15:20:13 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1F2F30406B
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:20:09 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r7JKK96N003769
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 15:20:09 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130819201940.516942026@sgi.com>
Date: Mon, 19 Aug 2013 15:19:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
Content-Disposition: inline;
	filename=51-50-add-filetype-for-superblock-v4.patch
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

Add XFS superblock v4 support for the file type field in the
directory entry feature.

This support adds a feature bit for version 4 superblocks and
leaves the original superblock 5 incompatibility bit.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_sb.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_sb.h
===================================================================
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
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
@@ -631,8 +633,10 @@ static inline int xfs_sb_version_has_pqu
 
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
