Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FD1D7F51
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 20:44:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E1EB8F8050
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 18:44:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	aiTWAq2rQrRn4VtJ for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 18:44:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VLkLB-00069l-OJ
	for xfs@oss.sgi.com; Tue, 17 Sep 2013 11:44:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VLkLB-0007pG-Ne
	for xfs@oss.sgi.com; Tue, 17 Sep 2013 11:44:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: asserting lock not held during freeing not valid
Date: Tue, 17 Sep 2013 11:44:31 +1000
Message-Id: <1379382271-29907-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1379382271-29907-1-git-send-email-david@fromorbit.com>
References: <1379382271-29907-1-git-send-email-david@fromorbit.com>
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

When we free an inode, we do so via RCU. As an RCU lookup can occur
at any time before we free an inode, and that lookup takes the inode
flags lock, we cannot safely assert that the flags lock is not held
just before marking it dead and running call_rcu() to free the
inode.

We check on allocation of a new inode structre that the lock is not
held, so we still have protection against locks being leaked and
hence not correctly initialised when allocated out of the slab.
Hence just remove the assert...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 193206b..474807a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -119,11 +119,6 @@ xfs_inode_free(
 		ip->i_itemp = NULL;
 	}
 
-	/* asserts to verify all state is correct here */
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(!xfs_isiflocked(ip));
-
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always
 	 * appears to be reclaimed with an invalid inode number when in the
@@ -135,6 +130,10 @@ xfs_inode_free(
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!xfs_isiflocked(ip));
+
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
 }
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
