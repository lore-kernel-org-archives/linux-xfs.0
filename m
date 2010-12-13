Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD1X0tj148732 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:33:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA6CF1CBC35E
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:34:50 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	TI3MdLKvhAEMdSnM for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 17:34:50 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: rcu free inodes
Date: Mon, 13 Dec 2010 12:32:35 +1100
Message-Id: <1292203957-15819-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1292203957-15819-1-git-send-email-david@fromorbit.com>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
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
Cc: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com

From: Dave Chinner <dchinner@redhat.com>

Introduce RCU freeing of XFS inodes so that we can convert lookup
traversals to use rcu_read_lock() protection. This patch only
introduces the RCU freeing to minimise the potential conflicts with
mainline if this is merged into mainline via a VFS patchset. It
abuses the i_dentry list for the RCU callback structure because the
VFS patches make this a union so it is safe to use like this and
simplifies and merge issues.

This patch uses basic RCU freeing rather than SLAB_DESTROY_BY_RCU.
The later lookup patches need the same "found free inode" protection
regardless of the RCU freeing method used, so once again the RCU
freeing method can be dealt with apprpriately at merge time without
affecting any other code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index cdb1c25..9fae475 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -105,6 +105,18 @@ xfs_inode_alloc(
 }
 
 void
+__xfs_inode_free(
+	struct rcu_head		*head)
+{
+	struct inode		*inode = container_of((void *)head,
+							struct inode, i_dentry);
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
+void
 xfs_inode_free(
 	struct xfs_inode	*ip)
 {
@@ -147,7 +159,7 @@ xfs_inode_free(
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
 
-	kmem_zone_free(xfs_inode_zone, ip);
+	call_rcu((struct rcu_head *)&VFS_I(ip)->i_dentry, __xfs_inode_free);
 }
 
 /*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
