Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40CAB29E20
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:56:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33768304059
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:56:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9aVlwK8XzhEZhMQk for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:56:08 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWU5-0002Uu-H8
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWU5-0005Ig-GK
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: keep sb_bad_features2 the same a sb_features2
Date: Tue,  6 May 2014 13:55:56 +1000
Message-Id: <1399348559-19889-3-git-send-email-david@fromorbit.com>
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

Whenever we update sb_features2, we need to update sb_bad_features2
so that they remain identical on disk. This prevents future mounts
or userspace utilities from getting confused over which features the
filesystem supports.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 85f0146..7dfa8f1 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -475,11 +475,13 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
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
