Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC3527F63
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB3A1304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	29OXS8svilIKhvDI for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YR-8y
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00062h-80
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 28/50] xfs: don't special case
	shared superblock mounts
Date: Mon, 12 Aug 2013 20:49:49 +1000
Message-Id: <1376304611-22994-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
between kernel and userspace. The same check can be used as neither
like it...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_sb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 91e163a..db7593f 100644
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
