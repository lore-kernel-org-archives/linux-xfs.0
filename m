Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 14AC47F37
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:02:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAB7930404E
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 10:02:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wakNk03qUk5CV2ZG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 10:02:35 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id EA962A9A
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 17:02:34 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-92.bos.redhat.com [10.18.41.92])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8EH2YS7000980
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 13:02:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: add missing ilock around dio write last extent
	alignment
Date: Mon, 14 Sep 2015 13:02:33 -0400
Message-Id: <1442250153-38295-1-git-send-email-bfoster@redhat.com>
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

The iomap codepath (via get_blocks()) acquires and release the inode
lock in the case of a direct write that requires block allocation. This
is because xfs_iomap_write_direct() allocates a transaction, which means
the ilock must be dropped and reacquired after the transaction is
allocated and reserved.

xfs_iomap_write_direct() invokes xfs_iomap_eof_align_last_fsb() before
the transaction is created and thus before the ilock is reacquired. This
can lead to calls to xfs_iread_extents() and reads of the in-core extent
list without any synchronization (via xfs_bmap_eof() and
xfs_bmap_last_extent()). xfs_iread_extents() assert fails if the ilock
is not held, but this is not currently seen in practice as the current
callers had already invoked xfs_bmapi_read().

What has been seen in practice are reports of crashes down in the
xfs_bmap_eof() codepath on direct writes due to seemingly bogus pointer
references from xfs_iext_get_ext(). While an explicit reproducer is not
currently available to confirm the cause of the problem, crash analysis
and code inspection from David Jeffrey had identified the insufficient
locking.

xfs_iomap_eof_align_last_fsb() is called from other contexts with the
inode lock already held, so we cannot acquire it therein.
__xfs_get_blocks() acquires and drops the ilock with variable flags to
cover the event that the extent list must be read in. The common case is
that __xfs_get_blocks() acquires the shared ilock. To provide locking
around the last extent alignment call without adding more lock cycles to
the dio path, update xfs_iomap_write_direct() to expect the shared ilock
held on entry and do the extent alignment under its protection. Demote
the lock, if necessary, from __xfs_get_blocks() and push the
xfs_qm_dqattach() call outside of the shared lock critical section.
Also, add an assert to document that the extent list is always expected
to be present in this path. Otherwise, we risk a call to
xfs_iread_extents() while under the shared ilock. This is safe as all
current callers have executed an xfs_bmapi_read() call under the current
iolock context.

Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note that I opted not to complicate the pnfs caller, but I could do so
similar to __xfs_get_blocks() if we think it's necessary...

Brian

v2:
- Updated xfs_iomap_write_direct() to use ilock acquired by caller.
v1: http://oss.sgi.com/pipermail/xfs/2015-September/043570.html

 fs/xfs/xfs_aops.c  | 10 +++++-----
 fs/xfs/xfs_iomap.c | 33 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_pnfs.c  |  5 +++++
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 458fced..c5e743c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1403,12 +1403,12 @@ __xfs_get_blocks(
 	      imap.br_startblock == DELAYSTARTBLOCK))) {
 		if (direct || xfs_get_extsz_hint(ip)) {
 			/*
-			 * Drop the ilock in preparation for starting the block
-			 * allocation transaction.  It will be retaken
-			 * exclusively inside xfs_iomap_write_direct for the
-			 * actual allocation.
+			 * xfs_iomap_write_direct() expects the shared lock. It
+			 * is unlocked on return.
 			 */
-			xfs_iunlock(ip, lockmode);
+			if (lockmode == XFS_ILOCK_EXCL)
+				xfs_ilock_demote(ip, lockmode);
+
 			error = xfs_iomap_write_direct(ip, offset, size,
 						       &imap, nimaps);
 			if (error)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1f86033..1beda33 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -131,20 +131,29 @@ xfs_iomap_write_direct(
 	uint		qblocks, resblks, resrtextents;
 	int		committed;
 	int		error;
-
-	error = xfs_qm_dqattach(ip, 0);
-	if (error)
-		return error;
+	int		lockmode;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
+	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
+
+	ASSERT(xfs_isilocked(ip, lockmode));
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
 	if ((offset + count) > XFS_ISIZE(ip)) {
+		/*
+		 * Assert that the in-core extent list is present since this can
+		 * call xfs_iread_extents() and we only have the ilock shared.
+		 * This should be safe because the lock was held around a bmapi
+		 * call in the caller and we only need it to access the in-core
+		 * list.
+		 */
+		ASSERT(XFS_IFORK_PTR(ip, XFS_DATA_FORK)->if_flags &
+								XFS_IFEXTENTS);
 		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
 		if (error)
-			return error;
+			goto out_unlock;
 	} else {
 		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = MIN(last_fsb, (xfs_fileoff_t)
@@ -174,6 +183,15 @@ xfs_iomap_write_direct(
 	}
 
 	/*
+	 * Drop the shared lock acquired by the caller, attach the dquot if
+	 * necessary and move on to transaction setup.
+	 */
+	xfs_iunlock(ip, lockmode);
+	error = xfs_qm_dqattach(ip, 0);
+	if (error)
+		return error;
+
+	/*
 	 * Allocate and setup the transaction
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
@@ -187,7 +205,8 @@ xfs_iomap_write_direct(
 		return error;
 	}
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lockmode);
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
 	if (error)
@@ -229,7 +248,7 @@ xfs_iomap_write_direct(
 		error = xfs_alert_fsblock_zero(ip, imap);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return error;
 
 out_bmap_cancel:
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ab4a606..dc62219 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -181,6 +181,11 @@ xfs_fs_map_blocks(
 		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
 
 		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
+			/*
+			 * xfs_iomap_write_direct() expects to take ownership of
+			 * the shared ilock.
+			 */
+			xfs_ilock(ip, XFS_ILOCK_SHARED);
 			error = xfs_iomap_write_direct(ip, offset, length,
 						       &imap, nimaps);
 			if (error)
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
