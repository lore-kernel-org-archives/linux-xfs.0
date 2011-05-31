Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4V4LD3f024958 for <xfs@oss.sgi.com>; Mon, 30 May 2011 23:21:14 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1384911CBFFE
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 21:21:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UuGv55lLBtZ0azuf for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 21:21:12 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QRGS4-0002AE-Pd
	for xfs@oss.sgi.com; Tue, 31 May 2011 14:21:08 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QRGRy-00065B-SP
	for xfs@oss.sgi.com; Tue, 31 May 2011 14:21:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: clear inode per-lifetime state when recycling it
Date: Tue, 31 May 2011 14:20:58 +1000
Message-Id: <1306815659-23346-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1306815659-23346-1-git-send-email-david@fromorbit.com>
References: <1306815659-23346-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

XFs inodes have several per-lifetime state flags that determine heaviour of the
inode. These state flags are not reset when an inode is reallocated and reused
from the reclaimable state.

This can lead to specualtive preallocation not being truncated away in the
expected manner for local files until the inode is subsequently truncated,
freed or cycles out of the cache. It can also lead to an inode being considered
to be a filestream inode or having been truncated when that is not the case.

Clear the state flags when the inode is recycled to avoid these problems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index cb9b6d1..36467f1 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -262,7 +262,17 @@ xfs_iget_cache_hit(
 
 		spin_lock(&pag->pag_ici_lock);
 		spin_lock(&ip->i_flags_lock);
-		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
+
+		/*
+		 * Clear the relcaim and per-lifetime state flags as we are now
+		 * effectively a new inode and so we need to reset to the
+		 * initial state.
+		 *
+		 * XXX(dgc): should the XFS_ISTALE flag only be cleared here?
+		 */
+		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM |
+				 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED |
+				 XFS_IFILESTREAM);
 		ip->i_flags |= XFS_INEW;
 		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 		inode->i_state = I_NEW;
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
