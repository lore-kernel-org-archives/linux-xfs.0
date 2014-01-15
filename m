Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B49629DFE
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:52 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F359930406A
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:51 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0Ur1q003612
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.464934231@sgi.com>
Date: Wed, 15 Jan 2014 16:00:16 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 04/17] xfs: (parent ptr) add parent pointer support to xfs_sb.h
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline;
	filename=04-pptr-add-xfs_sb_version_hasparent.patch
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

Add the parent pointer support to the superblock version 5.

---
 fs/xfs/xfs_sb.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_sb.h
===================================================================
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -89,6 +89,7 @@ struct xfs_trans;
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
+	 XFS_SB_VERSION2_PARENTBIT	| \
 	 XFS_SB_VERSION2_PROJID32BIT	| \
 	 XFS_SB_VERSION2_FTYPE)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
@@ -596,8 +597,10 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(2 << 0)	/* parent inode ptr */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -639,6 +642,12 @@ static inline int xfs_sb_version_hasftyp
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
+static inline int xfs_sb_version_hasparent(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_PARENT));
+}
+
 /*
  * end of superblock version macros
  */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
