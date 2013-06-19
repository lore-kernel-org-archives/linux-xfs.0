Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A03F629E63
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D27EAC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cu0f8clSzb4EtF0c for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:39 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANp-00030M-Tz
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANf-00006j-Rx
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 40/60] xfs: don't special case shared superblock mounts
Date: Wed, 19 Jun 2013 14:50:48 +1000
Message-Id: <1371617468-32559-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

Neither kernel or userspace support shared read-only mounts, so
don't beother special casing the support check to be different
between kernel and userspace. The same check canbe used as neither
like it...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sb.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 8f78df1..677a480 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -355,15 +355,8 @@ static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 		     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS)))
 			return 0;
 
-#ifdef __KERNEL__
 		if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
 			return 0;
-#else
-		if ((sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) &&
-		    sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
-			return 0;
-#endif
-
 		return 1;
 	}
 	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
