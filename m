Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3HQbTX175498 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 11:26:37 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH] xfs: Wrapped journal record corruption on read at recovery
Date: Tue, 3 Nov 2009 11:26:47 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE64@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <alpine.DEB.2.00.0910151858340.5504@andydesk>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: John Quigley <jquigley@cleversafe.com>, Andy Poling <andy@realbig.com>

Andy Poling wrote:
> On Wed, 14 Oct 2009, Christoph Hellwig wrote:
>>> It seems like the more elegant approach would be to set offset before the
>>> first read, and then update it if the first read takes place (in case it was
>>> unaligned).  That also gets rid of bufaddr, and seems like it might read
>>> better.
>> 
>> Yeah.  Note that in Linux 2.6.29 I did some changes in that are to
>> take the read and offset calculation into a common helper
> 
> Looking at the improved code since 2.6.29, and assuming that the beginning of
> the log will always be aligned, I have come up with the attached patch against
> 2.6.31.4.  I think it's cleaner, and it passes my tests.
> 
> The bufaddr variable is no longer needed.  I removed the xlog_align() after
> the second read for both headers and data since the second read will always be
> aligned (even if there was no first read) since it is always at the beginning
> of the log.
> 
> It sets offset to the beginning of the buffer with XFS_BUF_PTR() before the
> first read, and then your improved xlog_bread() will update the offset if the
> first read had to be re-aligned.
> 
> What do you think?
> 
> -Andy

I am re-submitting Andy's patch using the conventions that
(hopefully) Patchwork understands to facilitate tracking.

					-Alex

Author: Andy Poling <andy@realbig.com>

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


--- fs/xfs/xfs_log_recover.c.orig	2009-10-14 23:39:49.753494876 -0500
+++ fs/xfs/xfs_log_recover.c	2009-10-15 18:26:23.790887700 -0500
@@ -3517,7 +3517,7 @@
 {
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
-	xfs_caddr_t		bufaddr, offset;
+	xfs_caddr_t		offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
@@ -3610,7 +3610,7 @@
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = NULL;
+			offset = XFS_BUF_PTR(hbp);
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
@@ -3646,9 +3646,8 @@
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
@@ -3658,14 +3657,10 @@
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
@@ -3685,7 +3680,7 @@
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = NULL;
+				offset = XFS_BUF_PTR(dbp);
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
@@ -3714,9 +3709,8 @@
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
@@ -3727,13 +3721,9 @@
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
