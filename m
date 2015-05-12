Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3B707F61
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 18:52:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C51108F8087
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 16:52:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	i7fcrHyxCnu4HiRV for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 16:52:44 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: inode and free block counters need to use
	__percpu_counter_compare
Date: Wed, 13 May 2015 09:52:34 +1000
Message-Id: <1431474754-15764-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1431474754-15764-1-git-send-email-david@fromorbit.com>
References: <1431474754-15764-1-git-send-email-david@fromorbit.com>
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
Cc: peterz@infradead.org, tj@kernel.org, linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because the counters use a custom batch size, the comparison
functions need to be aware of that batch size otherwise the
comparison does not work correctly. This leads to ASSERT failures
on generic/027 like this:

 XFS: Assertion failed: 0, file: fs/xfs/xfs_mount.c, line: 1099
 ------------[ cut here ]------------
....
 Call Trace:
  [<ffffffff81522a39>] xfs_mod_icount+0x99/0xc0
  [<ffffffff815285cb>] xfs_trans_unreserve_and_mod_sb+0x28b/0x5b0
  [<ffffffff8152f941>] xfs_log_commit_cil+0x321/0x580
  [<ffffffff81528e17>] xfs_trans_commit+0xb7/0x260
  [<ffffffff81503d4d>] xfs_bmap_finish+0xcd/0x1b0
  [<ffffffff8151da41>] xfs_inactive_ifree+0x1e1/0x250
  [<ffffffff8151dbe0>] xfs_inactive+0x130/0x200
  [<ffffffff81523a21>] xfs_fs_evict_inode+0x91/0xf0
  [<ffffffff811f3958>] evict+0xb8/0x190
  [<ffffffff811f433b>] iput+0x18b/0x1f0
  [<ffffffff811e8853>] do_unlinkat+0x1f3/0x320
  [<ffffffff811d548a>] ? filp_close+0x5a/0x80
  [<ffffffff811e999b>] SyS_unlinkat+0x1b/0x40
  [<ffffffff81e0892e>] system_call_fastpath+0x12/0x71

This is a regression introduced by commit 501ab32 ("xfs: use generic
percpu counters for inode counter").

This patch fixes the same problem for both the inode counter and the
free block counter in the superblocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 02f827f..461e791 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1100,14 +1100,18 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return xfs_sync_sb(mp, true);
 }
 
+/*
+ * Deltas for the inode count are +/-64, hence we use a large batch size
+ * of 128 so we don't need to take the counter lock on every update.
+ */
+#define XFS_ICOUNT_BATCH	128
 int
 xfs_mod_icount(
 	struct xfs_mount	*mp,
 	int64_t			delta)
 {
-	/* deltas are +/-64, hence the large batch size of 128. */
-	__percpu_counter_add(&mp->m_icount, delta, 128);
-	if (percpu_counter_compare(&mp->m_icount, 0) < 0) {
+	__percpu_counter_add(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
+	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
 		ASSERT(0);
 		percpu_counter_add(&mp->m_icount, -delta);
 		return -EINVAL;
@@ -1129,6 +1133,14 @@ xfs_mod_ifree(
 	return 0;
 }
 
+/*
+ * Deltas for the block count can vary from 1 to very large, but lock contention
+ * only occurs on frequent small block count updates such as in the delayed
+ * allocation path for buffered writes (page a time updates). Hence we set
+ * a large batch count (1024) to minimise global counter updates except when
+ * we get near to ENOSPC and we have to be very accurate with our updates.
+ */
+#define XFS_FDBLOCKS_BATCH	1024
 int
 xfs_mod_fdblocks(
 	struct xfs_mount	*mp,
@@ -1167,25 +1179,19 @@ xfs_mod_fdblocks(
 	 * Taking blocks away, need to be more accurate the closer we
 	 * are to zero.
 	 *
-	 * batch size is set to a maximum of 1024 blocks - if we are
-	 * allocating of freeing extents larger than this then we aren't
-	 * going to be hammering the counter lock so a lock per update
-	 * is not a problem.
-	 *
 	 * If the counter has a value of less than 2 * max batch size,
 	 * then make everything serialise as we are real close to
 	 * ENOSPC.
 	 */
-#define __BATCH	1024
-	if (percpu_counter_compare(&mp->m_fdblocks, 2 * __BATCH) < 0)
+	if (__percpu_counter_compare(&mp->m_fdblocks, 2 * XFS_FDBLOCKS_BATCH,
+				     XFS_FDBLOCKS_BATCH) < 0)
 		batch = 1;
 	else
-		batch = __BATCH;
-#undef __BATCH
+		batch = XFS_FDBLOCKS_BATCH;
 
 	__percpu_counter_add(&mp->m_fdblocks, delta, batch);
-	if (percpu_counter_compare(&mp->m_fdblocks,
-				   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
+	if (__percpu_counter_compare(&mp->m_fdblocks, XFS_ALLOC_SET_ASIDE(mp),
+				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
 	}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
