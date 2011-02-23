Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NMQbV5087402 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 16:26:38 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA0BB12DB605
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 14:29:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0IFBNUMZjaiSV5TD for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 14:29:21 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_repair: inode flags check should use flags
Date: Thu, 24 Feb 2011 09:29:11 +1100
Message-Id: <1298500151-27017-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: aelder@sgi.com

From: Dave Chinner <dchinner@redhat.com>

The RT bitmap inode format flag check should use the flag, not the
bit definition. As a result, it is incorrectly detecting inodes with
the prealloc flag set as has having an invalid bit set.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 repair/dinode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index fad15b2..3a092e4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2551,11 +2551,11 @@ process_dinode_int(xfs_mount_t *mp,
 						XFS_DIFLAG_RTINHERIT);
 			}
 		}
-		if (flags & XFS_DIFLAG_NEWRTBM_BIT) {
+		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */
 			if (lino != mp->m_sb.sb_rbmino) {
 				do_warn(_("inode %llu not rt bitmap"), lino);
-				flags &= ~XFS_DIFLAG_NEWRTBM_BIT;
+				flags &= ~XFS_DIFLAG_NEWRTBM;
 			}
 		}
 		if (flags & (XFS_DIFLAG_RTINHERIT |
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
