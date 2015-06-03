Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 445877F92
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3448D8F8087
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SbL49xBtTjLw0hDs for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001Dv-SE
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002wE-Qm
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/20] xfs: enable the rmap btree functionality
Date: Wed,  3 Jun 2015 16:04:57 +1000
Message-Id: <1433311497-10245-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
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

Add the feature flag to the supported matrix so that the kernel can
mount and use rmap btree enabled filesystems

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 fs/xfs/libxfs/xfs_sb.c     | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cd61ce9..9cff517 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -447,7 +447,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index c136abd..5fb5410 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -196,6 +196,12 @@ xfs_mount_validate_sb(
 		}
 	}
 
+	if (xfs_sb_version_hasrmapbt(sbp)) {
+		xfs_alert(mp,
+"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
+	}
+
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
