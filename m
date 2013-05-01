Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E72097F6D
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:31:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75A88AC001
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 23:31:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qb1LLkkswACJnVtY for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 23:31:48 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UXQZl-0007ux-1W
	for xfs@oss.sgi.com; Wed, 01 May 2013 16:31:37 +1000
Date: Wed, 1 May 2013 16:31:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/8] xfs_logprint: fix continuation transactions
Message-ID: <20130501063136.GL10481@dastard>
References: <20130430121300.GB10481@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130430121300.GB10481@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

As demonstrated by xfs/295, continuation transactions cause of
problems for xfs_logprint. The failure demonstrated by the test is
that the buffer log format structures are variable sized on disk -
the dirty bitmap is sized according to the buffer length, not fixed
to the length of the maximum supported buffer size.

xfs_logprint assumes that the buf log format reocrds are of fixed
size, and so when a short buffer is found it fails to handle it
properly and treats it like a continuation record.  This causses the
opheader pointer to be incremented incorrectly and then logprint
wanders off into a dark corner and gets eaten by a grue.

While fixing this, make the xlog_print_record code that does the
transaction opheader walking a little easier to read and stop it
from outputting binary data direct to the console by converting the
no-data-print case to use a hex dumping loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 logprint/log_misc.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 30b7ea6..d08f900 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -268,7 +268,13 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
     blen = f->blf_len;
     map_size = f->blf_map_size;
     flags = f->blf_flags;
-    struct_size = sizeof(xfs_buf_log_format_t);
+
+    /*
+     * size of the format header is dependent on the size of the bitmap, not
+     * the size of the in-memory structure. Hence the slightly obtuse
+     * calculation.
+     */
+    struct_size = offsetof(struct xfs_buf_log_format, blf_map_size) + map_size;
 
     if (len >= struct_size) {
 	ASSERT((len - sizeof(struct_size)) % sizeof(int) == 0);
@@ -933,22 +939,28 @@ xlog_print_record(int			  fd,
 	continued = ((op_head->oh_flags & XLOG_WAS_CONT_TRANS) ||
 		     (op_head->oh_flags & XLOG_CONTINUE_TRANS));
 
-	/* print transaction data */
-	if (print_no_data ||
-	    (continued && be32_to_cpu(op_head->oh_len) == 0)) {
+	if (continued && be32_to_cpu(op_head->oh_len) == 0)
+		continue;
+
+	if (print_no_data) {
 	    for (n = 0; n < be32_to_cpu(op_head->oh_len); n++) {
-		printf("%c", *ptr);
+		printf("0x%02x ", (unsigned int)*ptr);
+		if (n % 16 == 15)
+			printf("\n");
 		ptr++;
 	    }
 	    printf("\n");
 	    continue;
 	}
+
+	/* print transaction data */
 	if (xlog_print_find_tid(be32_to_cpu(op_head->oh_tid),
 				op_head->oh_flags & XLOG_WAS_CONT_TRANS)) {
 	    printf(_("Left over region from split log item\n"));
 	    ptr += be32_to_cpu(op_head->oh_len);
 	    continue;
 	}
+
 	if (be32_to_cpu(op_head->oh_len) != 0) {
 	    if (*(uint *)ptr == XFS_TRANS_HEADER_MAGIC) {
 		skip = xlog_print_trans_header(&ptr,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
