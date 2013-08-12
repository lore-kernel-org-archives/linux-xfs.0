Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D1117F6D
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E169D304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LjG93ndNy2RSwJ40 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:45 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xi-Nr
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Lf-Mu
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 02/17] xfs: separate inode chunk
	allocation from free inode allocation
Date: Mon, 12 Aug 2013 23:19:52 +1000
Message-Id: <1376313607-28133-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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

Now that we can guarantee the availability of a free inode for an
inode allocation transaction, split the inode chunk allocation out
of the inode allocation transaction completely.  Instead, if the
inode ticket reservation detects no free inodes available, do the
inode chunk allocation immediately from this context.

This means that we need to split the create/mkdir/mknod transaction
reservations apart - we use the inode chunk allocation reservation
part for inode chunk allocation transactions, and the free inode
allocation and directory modification part for the
create/mkdir/mknod operation.

At this point, we have effectively decoupled free inode allocation
from inode chunk allocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2b49463..f469e72 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -109,7 +109,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
 #define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_TYPE_MAX		43
+#define	XFS_TRANS_IALLOC_CHUNK		44
+#define	XFS_TRANS_TYPE_MAX		44
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
