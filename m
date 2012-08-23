Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54L4j135681 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:21 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	J4BbyIQ8C7ryHGGX for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbK-0003J7-Le
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbA-0003hg-Cd
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 077/102] xfs: prevent needless mount warning causing test
	failures
Date: Thu, 23 Aug 2012 15:02:35 +1000
Message-Id: <1345698180-13612-78-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 81158e0cecdf53b1f6d88a514c6c20e0ee18ec7b

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
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 687bc9f..82f7d18 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -439,6 +439,8 @@ xlog_find_verify_cycle(
 	 * a log sector, or we're out of luck.
 	 */
 	bufblks = 1 << ffs(nbblks);
+	while (bufblks > log->l_logBBsize)
+		bufblks >>= 1;
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
 		if (bufblks < log->l_sectBBsize)
@@ -1224,6 +1226,8 @@ xlog_write_log_records(
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
