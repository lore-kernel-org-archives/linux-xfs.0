Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 100668048
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 011DE8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KTcuQbBg1uu1QiSK for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:40 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004JI-8u
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002Lm-7s
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 34/49] xfs: don't special case shared superblock mounts
Date: Fri, 19 Jul 2013 16:45:09 +1000
Message-Id: <1374216324-8781-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
 include/xfs_sb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index dea0373..d6f3648 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
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
