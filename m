Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 790067FE0
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7574F8F8033
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZbAuFYGZhUSAUfVx for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4j-0003Bf-Tw
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4U-0000Fv-Eo
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 33/50] xfs: don't special case shared superblock mounts
Date: Wed, 19 Jun 2013 15:35:56 +1000
Message-Id: <1371620173-712-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
 include/xfs_sb.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 8f78df1..677a480 100644
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
