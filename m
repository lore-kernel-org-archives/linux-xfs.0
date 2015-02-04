Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 071547FBE
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 15:04:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96DF9AC004
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 13:04:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	k5mprNPwcAPF9QV0 for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 13:04:44 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YJ77c-0003G9-8T
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 08:04:28 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YJ77c-0007Xj-7R
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 08:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: xfs_setattr_size no longer races with page faults
Date: Thu,  5 Feb 2015 08:04:18 +1100
Message-Id: <1423083859-28439-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1423083859-28439-1-git-send-email-david@fromorbit.com>
References: <1423083859-28439-1-git-send-email-david@fromorbit.com>
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

Now that truncate locks out new page faults, we no longer need to do
special writeback hacks in truncate to work around potential races
between page faults, page cache truncation and file size updates to
ensure we get write page faults for extending truncates on sub-page
block size filesystems. Hence we can remove the code in
xfs_setattr_size() that handles this and update the comments around
the code tha thandles page cache truncate and size updates to
reflect the new reality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 56 ++++++++++++++-----------------------------------------
 1 file changed, 14 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0362b65..6a77ea9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -842,55 +842,27 @@ xfs_setattr_size(
 	inode_dio_wait(inode);
 
 	/*
-	 * Do all the page cache truncate work outside the transaction context
-	 * as the "lock" order is page lock->log space reservation.  i.e.
-	 * locking pages inside the transaction can ABBA deadlock with
-	 * writeback. We have to do the VFS inode size update before we truncate
-	 * the pagecache, however, to avoid racing with page faults beyond the
-	 * new EOF they are not serialised against truncate operations except by
-	 * page locks and size updates.
+	 * We've already locked out new page faults, so now we can safely remove
+	 * pages from the page cache knowing they won't get refaulted until we
+	 * drop the XFS_MMAP_EXCL lock after the extent manipulations are
+	 * complete. The truncate_setsize() call also cleans partial EOF page
+	 * PTEs on extending truncates and hence ensures sub-page block size
+	 * filesystems are correctly handled, too.
 	 *
-	 * Hence we are in a situation where a truncate can fail with ENOMEM
-	 * from xfs_trans_reserve(), but having already truncated the in-memory
-	 * version of the file (i.e. made user visible changes). There's not
-	 * much we can do about this, except to hope that the caller sees ENOMEM
-	 * and retries the truncate operation.
+	 * We have to do all the page cache truncate work outside the
+	 * transaction context as the "lock" order is page lock->log space
+	 * reservation as defined by extent allocation in the writeback path.
+	 * Hence a truncate can fail with ENOMEM from xfs_trans_reserve(), but
+	 * having already truncated the in-memory version of the file (i.e. made
+	 * user visible changes). There's not much we can do about this, except
+	 * to hope that the caller sees ENOMEM and retries the truncate
+	 * operation.
 	 */
 	error = block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
 	if (error)
 		return error;
 	truncate_setsize(inode, newsize);
 
-	/*
-	 * The "we can't serialise against page faults" pain gets worse.
-	 *
-	 * If the file is mapped then we have to clean the page at the old EOF
-	 * when extending the file. Extending the file can expose changes the
-	 * underlying page mapping (e.g. from beyond EOF to a hole or
-	 * unwritten), and so on the next attempt to write to that page we need
-	 * to remap it for write. i.e. we need .page_mkwrite() to be called.
-	 * Hence we need to clean the page to clean the pte and so a new write
-	 * fault will be triggered appropriately.
-	 *
-	 * If we do it before we change the inode size, then we can race with a
-	 * page fault that maps the page with exactly the same problem. If we do
-	 * it after we change the file size, then a new page fault can come in
-	 * and allocate space before we've run the rest of the truncate
-	 * transaction. That's kinda grotesque, but it's better than have data
-	 * over a hole, and so that's the lesser evil that has been chosen here.
-	 *
-	 * The real solution, however, is to have some mechanism for locking out
-	 * page faults while a truncate is in progress.
-	 */
-	if (newsize > oldsize && mapping_mapped(VFS_I(ip)->i_mapping)) {
-		error = filemap_write_and_wait_range(
-				VFS_I(ip)->i_mapping,
-				round_down(oldsize, PAGE_CACHE_SIZE),
-				round_up(oldsize, PAGE_CACHE_SIZE) - 1);
-		if (error)
-			return error;
-	}
-
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error)
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
