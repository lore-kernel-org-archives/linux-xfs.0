Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTlFf146506 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 298CA8F80D6
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:40 -0700 (PDT)
Subject: [PATCHv2 7/10] xfs: tidy up some goto labels
From: Alex Elder <aelder@sgi.com>
Date: Fri, 09 Apr 2010 17:29:23 -0500
Message-ID: <1270852163.7840.154.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Rename a label used in xlog_find_head() that I thought was poorly
chosen.  Also combine two adjacent labels xlog_find_tail() into
a single label, and give it a more generic name.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log_recover.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -739,7 +739,7 @@ xlog_find_head(
 			goto bp_err;
 		if (new_blk != -1) {
 			head_blk = new_blk;
-			goto bad_blk;
+			goto fine_tune;
 		}
 
 		/*
@@ -757,7 +757,7 @@ xlog_find_head(
 			head_blk = new_blk;
 	}
 
- bad_blk:
+fine_tune:
 	/*
 	 * Now we need to make sure head_blk is not pointing to a block in
 	 * the middle of a log record.
@@ -864,12 +864,12 @@ xlog_find_tail(
 	if (*head_blk == 0) {				/* special case */
 		error = xlog_bread(log, 0, 1, bp, &offset);
 		if (error)
-			goto bread_err;
+			goto done;
 
 		if (xlog_get_cycle(offset) == 0) {
 			*tail_blk = 0;
 			/* leave all other log inited values alone */
-			goto exit;
+			goto done;
 		}
 	}
 
@@ -880,7 +880,7 @@ xlog_find_tail(
 	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
 		error = xlog_bread(log, i, 1, bp, &offset);
 		if (error)
-			goto bread_err;
+			goto done;
 
 		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
 			found = 1;
@@ -897,7 +897,7 @@ xlog_find_tail(
 		for (i = log->l_logBBsize - 1; i >= (int)(*head_blk); i--) {
 			error = xlog_bread(log, i, 1, bp, &offset);
 			if (error)
-				goto bread_err;
+				goto done;
 
 			if (XLOG_HEADER_MAGIC_NUM ==
 			    be32_to_cpu(*(__be32 *)offset)) {
@@ -972,7 +972,7 @@ xlog_find_tail(
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
 		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
 		if (error)
-			goto bread_err;
+			goto done;
 
 		op_head = (xlog_op_header_t *)offset;
 		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
@@ -1018,12 +1018,10 @@ xlog_find_tail(
 	 * But... if the -device- itself is readonly, just skip this.
 	 * We can't recover this device anyway, so it won't matter.
 	 */
-	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp))
 		error = xlog_clear_stale_blocks(log, tail_lsn);
-	}
 
-bread_err:
-exit:
+done:
 	xlog_put_bp(bp);
 
 	if (error)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
