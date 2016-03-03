Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C7427CAF
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 06:40:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 036A4AC003
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 04:40:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nSdcUcuLIy511HkH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 04:40:00 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] xfs: only run torn log write detection on dirty logs
Date: Thu,  3 Mar 2016 07:39:58 -0500
Message-Id: <1457008798-58734-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
References: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
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
Cc: Jan Beulich <JBeulich@suse.com>

XFS uses CRC verification over a sub-range of the head of the log to
detect and handle torn writes. This torn log write detection currently
runs unconditionally at mount time, regardless of whether the log is
dirty or clean. This is problematic in cases where a filesystem might
end up being moved across different, incompatible (i.e., opposite
byte-endianness) architectures.

The problem lies in the fact that log data is not necessarily written in
an architecture independent format. For example, certain bits of data
are written in native endian format. Further, the size of certain log
data structures differs (i.e., struct xlog_rec_header) depending on the
word size of the cpu. This leads to false positive crc verification
errors and ultimately failed mounts when a cleanly unmounted filesystem
is mounted on a system with an incompatible architecture from data that
was written near the head of the log.

Update the log head/tail discovery code to run torn write detection only
when the log is not clean. This means something other than an unmount
record resides at the head of the log and log recovery is imminent. It
is a requirement to run log recovery on the same type of host that had
written the content of the dirty log and therefore CRC failures are
legitimate corruptions in that scenario.

Reported-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ebc2b2..9347bf1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1375,17 +1375,6 @@ xlog_find_tail(
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
 	/*
-	 * Trim the head block back to skip over torn records. We can have
-	 * multiple log I/Os in flight at any time, so we assume CRC failures
-	 * back through the previous several records are torn writes and skip
-	 * them.
-	 */
-	error = xlog_verify_head(log, head_blk, tail_blk, bp, &rhead_blk,
-				 &rhead, &wrapped);
-	if (error)
-		goto done;
-
-	/*
 	 * Set the log state based on the current head record.
 	 */
 	xlog_set_state(log, *head_blk, rhead, rhead_blk, wrapped);
@@ -1401,6 +1390,37 @@ xlog_find_tail(
 		goto done;
 
 	/*
+	 * Verify the log head if the log is not clean (e.g., we have anything
+	 * but an unmount record at the head). This uses CRC verification to
+	 * detect and trim torn writes. If discovered, CRC failures are
+	 * considered torn writes and the log head is trimmed accordingly.
+	 *
+	 * Note that we can only run CRC verification when the log is dirty
+	 * because there's no guarantee that the log data behind an unmount
+	 * record is compatible with the current architecture.
+	 */
+	if (!clean) {
+		xfs_daddr_t	orig_head = *head_blk;
+
+		error = xlog_verify_head(log, head_blk, tail_blk, bp,
+					 &rhead_blk, &rhead, &wrapped);
+		if (error)
+			goto done;
+
+		/* update in-core state again if the head changed */
+		if (*head_blk != orig_head) {
+			xlog_set_state(log, *head_blk, rhead, rhead_blk,
+				       wrapped);
+			tail_lsn = atomic64_read(&log->l_tail_lsn);
+			error = xlog_check_unmount_rec(log, head_blk, tail_blk,
+						       rhead, rhead_blk, bp,
+						       &clean);
+			if (error)
+				goto done;
+		}
+	}
+
+	/*
 	 * Note that the unmount was clean. If the unmount was not clean, we
 	 * need to know this to rebuild the superblock counters from the perag
 	 * headers if we have a filesystem using non-persistent counters.
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
