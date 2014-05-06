Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24B1F29E1A
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:56:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 947FEAC002
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:56:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JXaNuvFXh3PPL01L for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:56:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWU5-0002Ux-I4
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWU5-0005Iv-HN
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: remove shared supberlock feature checking
Date: Tue,  6 May 2014 13:55:59 +1000
Message-Id: <1399348559-19889-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1399348559-19889-1-git-send-email-david@fromorbit.com>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
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

We reject any filesystem that is mounted with this feature bit set,
so we don't need to check for it anywhere else. Remove the function
for checking if the feature bit is set and any code that uses it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c |  2 --
 fs/xfs/xfs_sb.c    |  3 ++-
 fs/xfs/xfs_sb.h    | 17 ++++-------------
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b099799..97886a7 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -84,8 +84,6 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
 			(xfs_sb_version_hasdalign(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
-			(xfs_sb_version_hasshared(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_SHARED : 0) |
 			(xfs_sb_version_hasextflgbit(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_EXTFLG : 0) |
 			(xfs_sb_version_hassector(&mp->m_sb) ?
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index de16dd5..c3453b1 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -291,7 +291,8 @@ xfs_mount_validate_sb(
 	    (sbp->sb_imax_pct > 100 /* zero sb_imax_pct is valid */)	||
 	    sbp->sb_dblocks == 0					||
 	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
-	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
+	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp)			||
+	    sbp->sb_shared_vn != 0)) {
 		xfs_notice(mp, "SB sanity check failed");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 9aa5caa..3fcfc2a 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -51,11 +51,12 @@ struct xfs_trans;
 
 /*
  * Supported feature bit list is just all bits in the versionnum field because
- * we've used them all up and understand them all.
+ * we've used them all up and understand them all. Except, of course, for the
+ * shared superblock bit, which nobody knows what it does and so is unsupported.
  */
 #define	XFS_SB_VERSION_OKBITS		\
-	(XFS_SB_VERSION_NUMBITS		| \
-	 XFS_SB_VERSION_ALLFBITS)
+	((XFS_SB_VERSION_NUMBITS | XFS_SB_VERSION_ALLFBITS) & \
+		~XFS_SB_VERSION_SHAREDBIT)
 
 /*
  * There are two words to hold XFS "feature" bits: the original
@@ -341,10 +342,6 @@ static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
 	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
 		return false;
 
-	/* We don't support shared superblocks - nobody knows what it is */
-	if (sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT)
-		return false;
-
 	return true;
 }
 
@@ -397,12 +394,6 @@ static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
 	return (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
-static inline bool xfs_sb_version_hasshared(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
-}
-
 static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
