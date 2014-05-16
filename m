Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E37C7F51
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 18:01:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8FC7AAC001
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 16:01:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iOpiPpgqQKuAbW0Y for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 16:01:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WlR7Z-0004ws-HF
	for xfs@oss.sgi.com; Sat, 17 May 2014 09:00:57 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WlR7Z-0007x4-GO
	for xfs@oss.sgi.com; Sat, 17 May 2014 09:00:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: keep sb_bad_features2 the same a sb_features2
Date: Sat, 17 May 2014 09:00:49 +1000
Message-Id: <1400281252-29638-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1400281252-29638-1-git-send-email-david@fromorbit.com>
References: <1400281252-29638-1-git-send-email-david@fromorbit.com>
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

Whenever we update sb_features2, we need to update sb_bad_features2
so that they remain identical on disk. This prevents future mounts
or userspace utilities from getting confused over which features the
filesystem supports.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_sb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index c750126..9e6a3d5 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -468,11 +468,13 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
+	sbp->sb_bad_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
 static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
+	sbp->sb_bad_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
 	if (!sbp->sb_features2)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
