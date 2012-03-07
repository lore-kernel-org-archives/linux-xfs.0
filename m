Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274ol4v020641 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:47 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	P0yUUuWtfWJ1hRlE for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:45 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pm-0001o7-Dj
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:42 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pc-0007V0-7U
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/10] xfs: fix inode lookup race
Date: Wed,  7 Mar 2012 15:50:25 +1100
Message-Id: <1331095828-28742-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-1-git-send-email-david@fromorbit.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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

When we get concurrent lookups of the same inode that is not in the
per-AG inode cache, there is a race condition that triggers warnings
in unlock_new_inode() indicating that we are initialising an inode
that isn't in a the correct state for a new inode.

When we do an inode lookup via a file handle or a bulkstat, we don't
serialise lookups at a higher level through the dentry cache (i.e.
pathless lookup), and so we can get concurrent lookups of the same
inode.

The race condition is between the insertion of the inode into the
cache in the case of a cache miss and a concurrently lookup:

Thread 1			Thread 2
xfs_iget()
  xfs_iget_cache_miss()
    xfs_iread()
    lock radix tree
    radix_tree_insert()
				rcu_read_lock
				radix_tree_lookup
				lock inode flags
				XFS_INEW not set
				igrab()
				unlock inode flags
				rcu_read_unlock
				use uninitialised inode
				.....
    lock inode flags
    set XFS_INEW
    unlock inode flags
    unlock radix tree
  xfs_setup_inode()
    inode flags = I_NEW
    unlock_new_inode()
      WARNING as inode flags != I_NEW

This can lead to inode corruption, inode list corruption, etc, and
is generally a bad thing to occur.

Fix this by setting XFS_INEW before inserting the inode into the
radix tree. This will ensure any concurrent lookup will find the new
inode with XFS_INEW set and that forces the lookup to wait until the
XFS_INEW flag is removed before allowing the lookup to succeed.

cc: <stable@vger.kernel.org> # for 3.0.x, 3.2.x
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_iget.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 37f22da..93fc1dc 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -350,9 +350,20 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	spin_lock(&pag->pag_ici_lock);
+	/*
+	 * These values must be set before inserting the inode into the radix
+	 * tree as the moment it is inserted a concurrent lookup (allowed by the
+	 * RCU locking mechanism) can find it and that lookup must see that this
+	 * is an inode currently under construction (i.e. that XFS_INEW is set).
+	 * The ip->i_flags_lock that protects the XFS_INEW flag forms the
+	 * memory barrier that ensures this detection works correctly at lookup
+	 * time.
+	 */
+	ip->i_udquot = ip->i_gdquot = NULL;
+	xfs_iflags_set(ip, XFS_INEW);
 
 	/* insert the new inode */
+	spin_lock(&pag->pag_ici_lock);
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
 	if (unlikely(error)) {
 		WARN_ON(error != -EEXIST);
@@ -360,11 +371,6 @@ xfs_iget_cache_miss(
 		error = EAGAIN;
 		goto out_preload_end;
 	}
-
-	/* These values _must_ be set before releasing the radix tree lock! */
-	ip->i_udquot = ip->i_gdquot = NULL;
-	xfs_iflags_set(ip, XFS_INEW);
-
 	spin_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
