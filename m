Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xPWl127444 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:26 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9AUoxaAkPwzopMiJ for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIy-0001aF-NW
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004Xt-Iy
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/37] xfs: remove some obsolete comments in xfs_trans_ail.c
Date: Mon, 23 Apr 2012 15:58:40 +1000
Message-Id: <1335160747-17254-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 49d9cde..959374a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -750,20 +750,6 @@ xfs_trans_ail_delete_bulk(
 	}
 }
 
-/*
- * The active item list (AIL) is a doubly linked list of log
- * items sorted by ascending lsn.  The base of the list is
- * a forw/back pointer pair embedded in the xfs mount structure.
- * The base is initialized with both pointers pointing to the
- * base.  This case always needs to be distinguished, because
- * the base has no lsn to look at.  We almost always insert
- * at the end of the list, so on inserts we search from the
- * end of the list to find where the new item belongs.
- */
-
-/*
- * Initialize the doubly linked list to point only to itself.
- */
 int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
