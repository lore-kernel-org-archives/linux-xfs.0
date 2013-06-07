Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F0F507F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FF42AC007
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HX5pSDdLQTY7FCku for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:20 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVW-0003tp-Pt
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVR-0001JW-Mk
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/48] logprint: fix wrapped log dump issue.
Date: Fri,  7 Jun 2013 10:25:25 +1000
Message-Id: <1370564771-4929-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

When running xfs/295 on a 512 byte block size filesystem, logprint
fails during checking with a "Bad log record header" error. This is
due to the fact that the log has wrapped and there is partial record
a the start of the log.

logprint doesn't check for this condition, and simply assumes that
the first block in the log contains a log header, and hence aborts
when this case occurs. So we now have a spurious test failure due to
logprint displaying how right this comment is:

/*
 * This code is gross and needs to be rewritten.
 */

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 logprint/log_misc.c |   49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index d08f900..334b6bf 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -833,7 +833,8 @@ xlog_print_record(int			  fd,
 		 int			  *read_type,
 		 xfs_caddr_t		  *partial_buf,
 		 xlog_rec_header_t	  *rhead,
-		 xlog_rec_ext_header_t	  *xhdrs)
+		 xlog_rec_ext_header_t	  *xhdrs,
+		 int			  bad_hdr_warn)
 {
     xfs_caddr_t		buf, ptr;
     int			read_len, skip;
@@ -1006,11 +1007,17 @@ xlog_print_record(int			  fd,
 			break;
 		    }
 		    default: {
-			fprintf(stderr, _("%s: unknown log operation type (%x)\n"),
-				progname, *(unsigned short *)ptr);
-			if (print_exit) {
-				free(buf);
-				return BAD_HEADER;
+			if(bad_hdr_warn) {
+				fprintf(stderr,
+			_("%s: unknown log operation type (%x)\n"),
+					progname, *(unsigned short *)ptr);
+				if (print_exit) {
+					free(buf);
+					return BAD_HEADER;
+				}
+			} else {
+				printf(
+			_("Left over region from split log item\n"));
 			}
 			skip = 0;
 			ptr += be32_to_cpu(op_head->oh_len);
@@ -1028,7 +1035,7 @@ xlog_print_record(int			  fd,
 
 
 int
-xlog_print_rec_head(xlog_rec_header_t *head, int *len)
+xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
 {
     int i;
     char uub[64];
@@ -1041,9 +1048,10 @@ xlog_print_rec_head(xlog_rec_header_t *head, int *len)
 	return ZEROED_LOG;
 
     if (be32_to_cpu(head->h_magicno) != XLOG_HEADER_MAGIC_NUM) {
-	printf(_("Header 0x%x wanted 0x%x\n"),
-		be32_to_cpu(head->h_magicno),
-		XLOG_HEADER_MAGIC_NUM);
+	if (bad_hdr_warn)
+		printf(_("Header 0x%x wanted 0x%x\n"),
+			be32_to_cpu(head->h_magicno),
+			XLOG_HEADER_MAGIC_NUM);
 	return BAD_HEADER;
     }
 
@@ -1269,8 +1277,9 @@ void xfs_log_print(struct xlog  *log,
     xfs_daddr_t			zeroed_blkno = 0, cleared_blkno = 0;
     int				read_type = FULL_READ;
     xfs_caddr_t			partial_buf;
-    int         		zeroed = 0;
-    int         		cleared = 0;
+    int				zeroed = 0;
+    int				cleared = 0;
+    int				first_hdr_found = 0;
 
     logBBsize = log->l_logBBsize;
 
@@ -1302,7 +1311,7 @@ void xfs_log_print(struct xlog  *log,
 	    blkno++;
 	    goto loop;
 	}
-	num_ops = xlog_print_rec_head(hdr, &len);
+	num_ops = xlog_print_rec_head(hdr, &len, first_hdr_found);
 	blkno++;
 
 	if (zeroed && num_ops != ZEROED_LOG) {
@@ -1328,7 +1337,10 @@ void xfs_log_print(struct xlog  *log,
 		    cleared_blkno = blkno-1;
 		cleared++;
 	    } else {
-		print_xlog_bad_header(blkno-1, hbuf);
+		if (!first_hdr_found)
+			block_start = blkno;
+		else
+			print_xlog_bad_header(blkno-1, hbuf);
 	    }
 
 	    goto loop;
@@ -1339,7 +1351,9 @@ void xfs_log_print(struct xlog  *log,
 		break;
 	}
 
-	error =	xlog_print_record(fd, num_ops, len, &read_type, &partial_buf, hdr, xhdrs);
+	error =	xlog_print_record(fd, num_ops, len, &read_type, &partial_buf,
+				  hdr, xhdrs, first_hdr_found);
+	first_hdr_found++;
 	switch (error) {
 	    case 0: {
 		blkno += BTOBB(len);
@@ -1415,7 +1429,7 @@ loop:
 		blkno++;
 		goto loop2;
 	    }
-	    num_ops = xlog_print_rec_head(hdr, &len);
+	    num_ops = xlog_print_rec_head(hdr, &len, first_hdr_found);
 	    blkno++;
 
 	    if (num_ops == ZEROED_LOG ||
@@ -1444,7 +1458,8 @@ partial_log_read:
 				    &read_type,
 				    &partial_buf,
 				    (xlog_rec_header_t *)hbuf,
-				    xhdrs);
+				    xhdrs,
+				    first_hdr_found);
 	    if (read_type != FULL_READ)
 		len -= read_type;
 	    read_type = FULL_READ;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
