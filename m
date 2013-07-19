Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DD587F7E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1EE028F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QkpS0UmCLV613kuE for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048g-3O
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001ys-2S
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/49] xfs: don't special case shared superblock mounts
Date: Fri, 19 Jul 2013 16:24:59 +1000
Message-Id: <1374215120-7271-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_sb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index dea0373..d6f3648 100644
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
