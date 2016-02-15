Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F8607CB3
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1A66AC005
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:03 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sua2vYUkeKDmHwnu for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:19:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MH-Jr
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005Gn-J6
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/14] xfs: inode recovery readahead can race with inode
	buffer creation
Date: Mon, 15 Feb 2016 17:18:20 +1100
Message-Id: <1455517105-20033-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

Source kernel commit b79f4a1c68bb99152d0785ee4ea3ab4396cdacc6

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

cc: <stable@vger.kernel.org> # 3.12 - current
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_inode_buf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 324715e..546af74 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -71,11 +71,12 @@ xfs_dinode_good_version(
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
@@ -102,6 +103,7 @@ xfs_inode_buf_verify(
 						XFS_RANDOM_ITOBP_INOTOBP))) {
 			if (readahead) {
 				bp->b_flags &= ~XBF_DONE;
+				xfs_buf_ioerror(bp, -EIO);
 				return;
 			}
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
