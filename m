Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TC8Oxc085871 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:08:24 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	V88g3Gm5P8qOlCRN for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:08:22 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDE9M-0003dl-T4
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:08:20 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDE91-0003Kd-UJ
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:07:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: remove some obsolete comments in xfs_trans_ail.c
Date: Thu, 29 Mar 2012 23:07:59 +1100
Message-Id: <1333022879-12777-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_trans_ail.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index b868035..cd2fde7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -761,20 +761,6 @@ xfs_trans_ail_delete_bulk(
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
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
