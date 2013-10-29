Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECFBC7F5E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 06:12:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC94A8F8033
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:12:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KPyfS5ylGuxTl2BZ for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 04:12:13 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vb7DN-0000Pl-6F
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vb7DN-000886-4q
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/15] xfs: prevent stack overflows from page cache allocation
Date: Tue, 29 Oct 2013 22:11:57 +1100
Message-Id: <1383045118-31107-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1383045118-31107-1-git-send-email-david@fromorbit.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

Page cache allocation doesn't always go through ->begin_write and
hence we don't always get the opportunity to set the allocation
context to GFP_NOFS. Failing to do this means we open up the direct
relcaim stack to recurse into the filesystem and consume a
significant amount of stack.

On RHEL6.4 kernels we are seeing ra_submit() and
generic_file_splice_read() from an nfsd context recursing into the
filesystem via the inode cache shrinker and evicting inodes. This is
causing truncation to be run (e.g EOF block freeing) and causing
bmap btree block merges and free space btree block splits to occur.
These btree manipulations are occurring with the call chain already
30 functions deep and hence there is not enough stack space to
complete such operations.

To avoid these specific overruns, we need to prevent the page cache
allocation from recursing via direct reclaim. We can do that because
the allocation functions take the allocation context from that which
is stored in the mapping for the inode. We don't set that right now,
so the default is GFP_HIGHUSER_MOVABLE, which is effectively a
GFP_KERNEL context. We need it to be the equivalent of GFP_NOFS, so
when we initialise an inode, set the mapping gfp mask appropriately.

This makes the use of AOP_FLAG_NOFS redundant from other parts of
the XFS IO path, so get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 3 +--
 fs/xfs/xfs_iops.c | 9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index eb310ca..71c8c9d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1572,8 +1572,7 @@ xfs_vm_write_begin(
 
 	ASSERT(len <= PAGE_CACHE_SIZE);
 
-	page = grab_cache_page_write_begin(mapping, index,
-					   flags | AOP_FLAG_NOFS);
+	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c4cd6d4..27e0e54 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1168,6 +1168,7 @@ xfs_setup_inode(
 	struct xfs_inode	*ip)
 {
 	struct inode		*inode = &ip->i_vnode;
+	gfp_t			gfp_mask;
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state = I_NEW;
@@ -1230,6 +1231,14 @@ xfs_setup_inode(
 	}
 
 	/*
+	 * Ensure all page cache allocations are done from GFP_NOFS context to
+	 * prevent direct reclaim recursion back into the filesystem and blowing
+	 * stacks or deadlocking.
+	 */
+	gfp_mask = mapping_gfp_mask(inode->i_mapping);
+	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
+
+	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
 	 */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
