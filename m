Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf3rt194364 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A544B233ABD
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	RV6DxnKQhnATLKUW for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:35 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/19] xfs: Wrapped journal record corruption on read at
	recovery
Date: Fri, 12 Mar 2010 09:42:02 +1100
Message-Id: <1268347337-7160-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Andy Poling <andy@realbig.com>

>From fc5bc4c85c45f0bf854404e5736aa8b65720a18d
Date: Tue, 3 Nov 2009 17:26:47 +0000
Summary of problem:

If a journal record wraps at the physical end of the journal, it has to be
read in two parts in xlog_do_recovery_pass(): a read at the physical end and a
read at the physical beginning.  If xlog_bread() has to re-align the first
read, the second read request does not take that re-alignment into account.
If the first read was re-aligned, the second read over-writes the end of the
data from the first read, effectively corrupting it.  This can happen either
when reading the record header or reading the record data.

The first sanity check in xlog_recover_process_data() is to check for a valid
clientid, so that is the error reported.

Summary of fix:

If there was a first read at the physical end, XFS_BUF_PTR() returns where the
data was requested to begin.  Conversely, because it is the result of
xlog_align(), offset indicates where the requested data for the first read
actually begins - whether or not xlog_bread() has re-aligned it.

Using offset as the base for the calculation of where to place the second read
data ensures that it will be correctly placed immediately following the data
from the first read instead of sometimes over-writing the end of it.

The attached patch has resolved the reported problem of occasional inability
to recover the journal (reporting "bad clientid").

Signed-off-by: Andy Poling <andy@realbig.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_log_recover.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fb17f82..b5b0d80 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3517,7 +3517,7 @@ xlog_do_recovery_pass(
 {
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
-	xfs_caddr_t		bufaddr, offset;
+	xfs_caddr_t		offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
@@ -3610,7 +3610,7 @@ xlog_do_recovery_pass(
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = NULL;
+			offset = XFS_BUF_PTR(hbp);
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
@@ -3646,9 +3646,8 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				wrapped_hblks = hblks - split_hblks;
-				bufaddr = XFS_BUF_PTR(hbp);
 				error = XFS_BUF_SET_PTR(hbp,
-						bufaddr + BBTOB(split_hblks),
+						offset + BBTOB(split_hblks),
 						BBTOB(hblks - split_hblks));
 				if (error)
 					goto bread_err2;
@@ -3658,14 +3657,10 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
 
-				error = XFS_BUF_SET_PTR(hbp, bufaddr,
+				error = XFS_BUF_SET_PTR(hbp, offset,
 							BBTOB(hblks));
 				if (error)
 					goto bread_err2;
-
-				if (!offset)
-					offset = xlog_align(log, 0,
-							wrapped_hblks, hbp);
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
@@ -3685,7 +3680,7 @@ xlog_do_recovery_pass(
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = NULL;
+				offset = XFS_BUF_PTR(dbp);
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
@@ -3714,9 +3709,8 @@ xlog_do_recovery_pass(
 				 *   _first_, then the log start (LR header end)
 				 *   - order is important.
 				 */
-				bufaddr = XFS_BUF_PTR(dbp);
 				error = XFS_BUF_SET_PTR(dbp,
-						bufaddr + BBTOB(split_bblks),
+						offset + BBTOB(split_bblks),
 						BBTOB(bblks - split_bblks));
 				if (error)
 					goto bread_err2;
@@ -3727,13 +3721,9 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
 
-				error = XFS_BUF_SET_PTR(dbp, bufaddr, h_size);
+				error = XFS_BUF_SET_PTR(dbp, offset, h_size);
 				if (error)
 					goto bread_err2;
-
-				if (!offset)
-					offset = xlog_align(log, wrapped_hblks,
-						bblks - split_bblks, dbp);
 			}
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log, rhash,
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
