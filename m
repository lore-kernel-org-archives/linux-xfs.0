Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29FC27CC7
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:38:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE5E9304039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:38:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	94LFd2c0D1F4dCH2 for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 16:38:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aoJVK-00004t-CF
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:38:26 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aoJUo-0006GD-89
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: xfs_inode_free() isn't RCU safe
Date: Fri,  8 Apr 2016 09:37:50 +1000
Message-Id: <1460072271-23923-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1460072271-23923-1-git-send-email-david@fromorbit.com>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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

The xfs_inode freed in xfs_inode_free() has multiple allocated
structures attached to it. We free these in xfs_inode_free() before
we mark the inode as invalid, and before we run call_rcu() to queue
the structure for freeing.

Unfortunately, this freeing can race with other accesses that are in
the RCU current grace period that have found the inode in the radix
tree with a valid state.  This includes xfs_iflush_cluster(), which
calls xfs_inode_clean(), and that accesses the inode log item on the
xfs_inode.

The log item structure is freed in xfs_inode_free(), so there is the
possibility we can be accessing freed memory in xfs_iflush_cluster()
after validating the xfs_inode structure as being valid for this RCU
context. Hence we can get spuriously incorrect clean state returned
from such checks. This can lead to use thinking the inode is dirty
when it is, in fact, clean, and so incorrectly attaching it to the
buffer for IO and completion processing.

This then leads to use-after-free situations on the xfs_inode itself
if the IO completes after the current RCU grace period expires. The
buffer callbacks will access the xfs_inode and try to do all sorts
of things it shouldn't with freed memory.

IOWs, xfs_iflush_cluster() only works correctly when racing with
inode reclaim if the inode log item is present and correctly stating
the inode is clean. If the inode is being freed, then reclaim has
already made sure the inode is clean, and hence xfs_iflush_cluster
can skip it. However, we are accessing the inode inode under RCU
read lock protection and so also must ensure that all dynamically
allocated memory we reference in this context is not freed until the
RCU grace period expires.

To fix this, move all the potential memory freeing into
xfs_inode_free_callback() so that we are guarantee RCU protected
lookup code will always have the memory structures it needs
available during the RCU grace period that lookup races can occur
in.

Discovered-by: Brain Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bf2d607..0c94cde 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -94,13 +94,6 @@ xfs_inode_free_callback(
 	struct inode		*inode = container_of(head, struct inode, i_rcu);
 	struct xfs_inode	*ip = XFS_I(inode);
 
-	kmem_zone_free(xfs_inode_zone, ip);
-}
-
-void
-xfs_inode_free(
-	struct xfs_inode	*ip)
-{
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
 	case S_IFREG:
 	case S_IFDIR:
@@ -118,6 +111,13 @@ xfs_inode_free(
 		ip->i_itemp = NULL;
 	}
 
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
+void
+xfs_inode_free(
+	struct xfs_inode	*ip)
+{
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always
 	 * appears to be reclaimed with an invalid inode number when in the
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
