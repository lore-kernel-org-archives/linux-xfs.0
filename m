Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BEe9bD102249 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 09:40:10 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iXdNZqUHi2Q2l0nM for
	<xfs@oss.sgi.com>; Mon, 11 Jun 2012 07:40:09 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5BEe8e9030169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 10:40:08 -0400
Received: from bfoster.bfoster (dhcp-187-76.bos.redhat.com [10.16.187.76])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5BEe8KO010418
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 10:40:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: check for stale inode before acquiring iflock on push
Date: Mon, 11 Jun 2012 10:39:43 -0400
Message-Id: <1339425583-54949-1-git-send-email-bfoster@redhat.com>
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

An inode in the AIL can be flush locked and marked stale if
a cluster free transaction occurs at the right time. The
inode item is then marked as flushing, which causes xfsaild
to spin and leaves the filesystem stalled. This is
reproduced by running xfstests 273 in a loop for an
extended period of time.

Check for stale inodes before the flush lock. This marks
the inode as pinned, leads to a log flush and allows the
filesystem to proceed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This patch resolves the stall I was reproducing with the 273 loop test.
I repeated the test pretty much throughout the weekend. I still hit one
hung task timeout message, but the test proceeded through it.

Dave, I know you mentioned you were sending a similar patch. Either you
didn't get to it or I missed it, but here's what I've been testing....

Brian

 fs/xfs/xfs_inode_item.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0309c979..e6ba0ec 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -505,6 +505,14 @@ xfs_inode_item_push(
 	}
 
 	/*
+	 * Stale inode items should force out the iclog.
+	 */
+	if (ip->i_flags & XFS_ISTALE) {
+		rval = XFS_ITEM_PINNED;
+		goto out_unlock;
+	}
+
+	/*
 	 * Someone else is already flushing the inode.  Nothing we can do
 	 * here but wait for the flush to finish and remove the item from
 	 * the AIL.
@@ -514,15 +522,6 @@ xfs_inode_item_push(
 		goto out_unlock;
 	}
 
-	/*
-	 * Stale inode items should force out the iclog.
-	 */
-	if (ip->i_flags & XFS_ISTALE) {
-		xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return XFS_ITEM_PINNED;
-	}
-
 	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
 	ASSERT(iip->ili_logged == 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
