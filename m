Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPYZH227403 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:35 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 801071057B61
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:35 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id EJqCe2MCOJDEGTQb for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:35 -0700 (PDT)
Message-Id: <20100422190908.483003466@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:43 -0700
From: Greg KH <gregkh@suse.de>
Subject: [012/197] xfs: Wrapped journal record corruption on read at recovery
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Andy Poling <andy@realbig.com>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Andy Poling <andy@realbig.com>

commit fc5bc4c85c45f0bf854404e5736aa8b65720a18d upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_log_recover.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
