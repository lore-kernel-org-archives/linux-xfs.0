Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0ABF77F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 14:27:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EDA3C8F8054
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 12:27:39 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id oWGSKb95lvJCF18F (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2014 12:27:33 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7BBE9AC24
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 20:27:32 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Keep sb_bad_features2 consistent with sb_features2
Date: Wed, 17 Dec 2014 21:27:26 +0100
Message-Id: <1418848046-11265-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Currently when we modify sb_features2, we store the same value also in
sb_bad_features2. However in most places we forget to mark field
sb_bad_features2 for logging and thus it can happen that a change to it
is lost. This results in an inconsistent sb_features2 and
sb_bad_features2 fields e.g. after xfstests test xfs/187.

Fix the problem by changing XFS_SB_FEATURES2 to actually mean both
sb_features2 and sb_bad_features2 fields since this is always what we
want to log. This isn't ideal because the fact that XFS_SB_FEATURES2
means two fields could cause some problem in future however the code is
hopefully less error prone that it is now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/libxfs/xfs_format.h | 10 +++++-----
 fs/xfs/xfs_mount.c         |  5 ++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fbd6da263571..476273287aaf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -304,8 +304,8 @@ typedef enum {
 #define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
 #define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
-#define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
-#define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_FEATURES2	(XFS_SB_MVAL(FEATURES2) | \
+				 XFS_SB_MVAL(BAD_FEATURES2))
 #define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
 #define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
 #define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
@@ -319,9 +319,9 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
-	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
-	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
+	 XFS_SB_FEATURES_COMPAT | XFS_SB_FEATURES_RO_COMPAT | \
+	 XFS_SB_FEATURES_INCOMPAT | XFS_SB_FEATURES_LOG_INCOMPAT | \
+	 XFS_SB_PQUOTINO)
 
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d3d38836f87f..71d2c97cf58a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -678,7 +678,7 @@ xfs_mountfs(
 		xfs_warn(mp, "correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
 		sbp->sb_bad_features2 = sbp->sb_features2;
-		mp->m_update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
+		mp->m_update_flags |= XFS_SB_FEATURES2;
 
 		/*
 		 * Re-check for ATTR2 in case it was found in bad_features2
@@ -1436,8 +1436,7 @@ xfs_mount_log_sb(
 	int		error;
 
 	ASSERT(fields & (XFS_SB_UNIT | XFS_SB_WIDTH | XFS_SB_UUID |
-			 XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2 |
-			 XFS_SB_VERSIONNUM));
+			 XFS_SB_FEATURES2 | XFS_SB_VERSIONNUM));
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
