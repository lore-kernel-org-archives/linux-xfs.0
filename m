Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47KSC0j156259 for <xfs@oss.sgi.com>; Mon, 7 May 2012 15:28:12 -0500
Message-Id: <20120507204246.674137290@nfs10.americas.sgi.com>
Date: Mon, 07 May 2012 15:42:24 -0500
From: bpm@sgi.com
Subject: [patch 2/5] [PATCH 3/3] xfs: prevent needless mount warning causing
	test failures
References: <20120507204222.921092617@nfs10.americas.sgi.com>
Content-Disposition: inline;
	filename=xfs-prevent-needless-mount-warning-causing-test-failures.patch
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
To: xfs-dev@sgi.com, xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Often mounting small filesystem with small logs will emit a warning
such as:

XFS (vdb): Invalid block length (0x2000) for buffer

during log recovery. This causes tests to randomly fail because this
output causes the clean filesystem checks on test completion to
think the filesystem is inconsistent.

The cause of the error is simply that log recovery is asking for a
buffer size that is larger than the log when zeroing the tail. This
is because the buffer size is rounded up, and if the right head and
tail conditions exist then the buffer size can be larger than the log.
Limit the variable size xlog_get_bp() callers to requesting buffers
smaller than the log.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d7abe5f..ca38690 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -441,6 +441,8 @@ xlog_find_verify_cycle(
 	 * a log sector, or we're out of luck.
 	 */
 	bufblks = 1 << ffs(nbblks);
+	while (bufblks > log->l_logBBsize)
+		bufblks >>= 1;
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
 		if (bufblks < log->l_sectBBsize)
@@ -1226,6 +1228,8 @@ xlog_write_log_records(
 	 * log sector, or we're out of luck.
 	 */
 	bufblks = 1 << ffs(blocks);
+	while (bufblks > log->l_logBBsize)
+		bufblks >>= 1;
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
 		if (bufblks < sectbb)
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
