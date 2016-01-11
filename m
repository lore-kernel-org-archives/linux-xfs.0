Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59ACC7F37
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 21:26:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FC1A8F8033
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 19:26:04 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oGPfidFgwgWHfpPd for <xfs@oss.sgi.com>;
	Sun, 10 Jan 2016 19:26:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aIT6H-0001Zu-Fh
	for xfs@oss.sgi.com; Mon, 11 Jan 2016 14:24:57 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aIT6H-00079Q-Eq
	for xfs@oss.sgi.com; Mon, 11 Jan 2016 14:24:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: inode recovery readahead can race with inode buffer
	creation
Date: Mon, 11 Jan 2016 14:24:53 +1100
Message-Id: <1452482694-27314-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1452482694-27314-1-git-send-email-david@fromorbit.com>
References: <1452482694-27314-1-git-send-email-david@fromorbit.com>
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

When we do inode readahead in log recovery, we do can do the
readahead before we've replayed the icreate transaction that stamps
the buffer with inode cores. The inode readahead verifier catches
this and marks the buffer as !done to indicate that it doesn't yet
contain valid inodes.

In adding buffer error notification  (i.e. setting b_error = -EIO at
the same time as as we clear the done flag) to such a readahead
verifier failure, we can then get subsequent inode recovery failing
with this error:

XFS (dm-0): metadata I/O error: block 0xa00060 ("xlog_recover_do..(read#2)") error 5 numblks 32

This occurs when readahead completion races with icreate item replay
such as:

	inode readahead
		find buffer
		lock buffer
		submit RA io
	....
	icreate recovery
	    xfs_trans_get_buffer
		find buffer
		lock buffer
		<blocks on RA completion>
	.....
	<ra completion>
		fails verifier
		clear XBF_DONE
		set bp->b_error = -EIO
		release and unlock buffer
	<icreate gains lock>
	icreate initialises buffer
	marks buffer as done
	adds buffer to delayed write queue
	releases buffer

At this point, we have an initialised inode buffer that is up to
date but has an -EIO state registered against it. When we finally
get to recovering an inode in that buffer:

	inode item recovery
	    xfs_trans_read_buffer
		find buffer
		lock buffer
		sees XBF_DONE is set, returns buffer
	    sees bp->b_error is set
		fail log recovery!

Essentially, we need xfs_trans_get_buf_map() to clear the error status of
the buffer when doing a lookup. This function returns uninitialised
buffers, so the buffer returned can not be in an error state and
none of the code that uses this function expects b_error to be set
on return. Indeed, there is an ASSERT(!bp->b_error); in the
transaction case in xfs_trans_get_buf_map() that would have caught
this if log recovery used transactions....

This patch firstly changes the inode readahead failure to set -EIO
on the buffer, and secondly changes xfs_buf_get_map() to never
return a buffer with an error state set so this first change doesn't
cause unexpected log recovery failures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 12 +++++++-----
 fs/xfs/xfs_buf.c              |  7 +++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 1b8d98a..ff17c48 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -62,11 +62,12 @@ xfs_inobp_check(
  * has not had the inode cores stamped into it. Hence for readahead, the buffer
  * may be potentially invalid.
  *
- * If the readahead buffer is invalid, we don't want to mark it with an error,
- * but we do want to clear the DONE status of the buffer so that a followup read
- * will re-read it from disk. This will ensure that we don't get an unnecessary
- * warnings during log recovery and we don't get unnecssary panics on debug
- * kernels.
+ * If the readahead buffer is invalid, we need to mark it with an error and
+ * clear the DONE status of the buffer so that a followup read will re-read it
+ * from disk. We don't report the error otherwise to avoid warnings during log
+ * recovery and we don't get unnecssary panics on debug kernels. We use EIO here
+ * because all we want to do is say readahead failed; there is no-one to report
+ * the error to, so this will distinguish it from a non-ra verifier failure.
  */
 static void
 xfs_inode_buf_verify(
@@ -93,6 +94,7 @@ xfs_inode_buf_verify(
 						XFS_RANDOM_ITOBP_INOTOBP))) {
 			if (readahead) {
 				bp->b_flags &= ~XBF_DONE;
+				xfs_buf_ioerror(bp, -EIO);
 				return;
 			}
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 45a8ea7..ae86b16 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -604,6 +604,13 @@ found:
 		}
 	}
 
+	/*
+	 * Clear b_error if this is a lookup from a caller that doesn't expect
+	 * valid data to be found in the buffer.
+	 */
+	if (!(flags & XBF_READ))
+		xfs_buf_ioerror(bp, 0);
+
 	XFS_STATS_INC(target->bt_mount, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	return bp;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
