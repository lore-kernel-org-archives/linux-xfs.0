Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1GUwhJ037632 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 11:30:58 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AEk6AdtmnESLjeEz for
	<xfs@oss.sgi.com>; Thu, 01 Nov 2012 09:32:50 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA1GWoKA028470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 12:32:50 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qA1GWncT013407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 12:32:49 -0400
Message-ID: <5092A430.8080109@redhat.com>
Date: Thu, 01 Nov 2012 11:32:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs_logprint: Handle continued inode transactions
References: <5092A1DE.10609@redhat.com>
In-Reply-To: <5092A1DE.10609@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

xlog_print_trans_inode() has a special case for 2
specific op_head->oh_len lengths.  If it matches
sizeof(xfs_inode_log_format_32_t) or
sizeof(xfs_inode_log_format_64_t), it assumes that
it's got an inode, and attempts to convert it and
print it accordingly.

However, if we arrive here via an op header which
is continued, then the length is simply a continuation
of the previous op, and it might *randomly* match the
size of one of the inode log formats, and thus get parsed
incorrectly.

Change the caller to pass in whether or not it's a continued
op, so that it can be handled correctly.

Tested by running xfs_logprint of TEST_DEV in xfsprogs
after sequential tests; without this change it gets off
in the weeds eventually; with this fix, it lasts longer,
until it hits some other yet-unfixed logprint bug...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index be2426e..75e221d 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -595,7 +595,7 @@ xlog_print_dir_sf(xfs_dir_shortform_t *sfp, int size)
 }
 
 int
-xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
+xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops, int continued)
 {
     xfs_icdinode_t	   dino;
     xlog_op_header_t	   *op_head;
@@ -617,8 +617,9 @@ xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
     memmove(&src_lbuf, *ptr, MIN(sizeof(xfs_inode_log_format_64_t), len));
     (*i)++;					/* bump index */
     *ptr += len;
-    if (len == sizeof(xfs_inode_log_format_32_t) ||
-	len == sizeof(xfs_inode_log_format_64_t)) {
+    if (!continued &&
+	(len == sizeof(xfs_inode_log_format_32_t) ||
+	 len == sizeof(xfs_inode_log_format_64_t))) {
 	f = xfs_inode_item_format_convert((char*)&src_lbuf, len, &dst_lbuf);
 	printf(_("INODE: "));
 	printf(_("#regs: %d   ino: 0x%llx  flags: 0x%x   dsize: %d\n"),
@@ -932,16 +933,18 @@ xlog_print_record(int			  fd,
 
     ptr = buf;
     for (i=0; i<num_ops; i++) {
+	int continued;
+
 	xlog_op_header_t *op_head = (xlog_op_header_t *)ptr;
 
 	print_xlog_op_line();
 	xlog_print_op_header(op_head, i, &ptr);
+	continued = (XLOG_SET(op_head->oh_flags, XLOG_WAS_CONT_TRANS) ||
+		     XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS));
 
 	/* print transaction data */
 	if (print_no_data ||
-	    ((XLOG_SET(op_head->oh_flags, XLOG_WAS_CONT_TRANS) ||
-	      XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS)) &&
-	     be32_to_cpu(op_head->oh_len) == 0)) {
+	    (continued && be32_to_cpu(op_head->oh_len) == 0)) {
 	    for (n = 0; n < be32_to_cpu(op_head->oh_len); n++) {
 		printf("%c", *ptr);
 		ptr++;
@@ -970,7 +973,7 @@ xlog_print_record(int			  fd,
 		    case XFS_LI_INODE: {
 			skip = xlog_print_trans_inode(&ptr,
 					be32_to_cpu(op_head->oh_len),
-					&i, num_ops);
+					&i, num_ops, continued);
 			break;
 		    }
 		    case XFS_LI_DQUOT: {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
