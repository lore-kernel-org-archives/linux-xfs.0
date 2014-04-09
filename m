Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5048C7F76
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 16:04:27 -0500 (CDT)
Received: from eagdhcp-232-178.americas.sgi.com
	(eagdhcp-232-178.americas.sgi.com [128.162.232.178])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A0A18F8054
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:04:24 -0700 (PDT)
Received: from eagdhcp-232-178.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-178.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s39L4OfM003000
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 16:04:24 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-178.americas.sgi.com)
Message-Id: <20140409210048.859660076@sgi.com>
Date: Wed, 09 Apr 2014 16:00:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfsprogs: fix xfs_logprint EFI entry split on log buffer
References: <20140409210013.095709266@sgi.com>
Content-Disposition: inline;
	filename=xfsprogs-xfs_logprint-fix-efi-entries-contiued-on-next-buf.patch
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
To: XFS Filesystem <xfs@oss.sgi.com>

xfs_logprint does not correctly handle EFI entries that
are split across two log buffers. xfs_efi_copy_format()
falsely interrupts the truncated size of the split entry
as being a corrupt entry.

If the first log entry has enough information, namely the
number of extents in the entry and the identifier, then
display this information and a warning that this entry is
truncated. Otherwise, if there is not enough information in
the first log buffer, then print a message that the EFI decode
was not possible. These messages are similar to split inode
entries.

Example of a continued entry:
Oper (336): tid: f214bdb  len: 44  clientid: TRANS  flags: CONTINUE
EFI:  #regs: 1    num_extents: 2  id: 0xffff880804f63900
EFI free extent data skipped (CONTINUE set, no space)

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 logprint/log_misc.c      |   31 ++++++++++++++++++++++++++-----
 logprint/log_print_all.c |    2 +-
 logprint/logprint.h      |    2 +-
 3 files changed, 28 insertions(+), 7 deletions(-)

Index: b/logprint/log_misc.c
===================================================================
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -477,13 +477,17 @@ xlog_print_trans_efd(xfs_caddr_t *ptr, u
 
 
 int
-xlog_print_trans_efi(xfs_caddr_t *ptr, uint src_len)
+xlog_print_trans_efi(
+	xfs_caddr_t *ptr,
+	uint src_len,
+	int continued)
 {
     xfs_efi_log_format_t *src_f, *f;
     uint		 dst_len;
     xfs_extent_t	 *ex;
     int			 i;
     int			 error = 0;
+    int			 core_size = offsetof(xfs_efi_log_format_t, efi_extents);
 
     /*
      * memmove to ensure 8-byte alignment for the long longs in
@@ -498,17 +502,29 @@ xlog_print_trans_efi(xfs_caddr_t *ptr, u
 
     /* convert to native format */
     dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+
+    if (continued && src_len < core_size) {
+	printf(_("EFI: Not enough data to decode further\n"));
+	return 1;
+    }
+
     if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
 	fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
 	exit(1);
     }
-    if (xfs_efi_copy_format((char*)src_f, src_len, f)) {
+    if (xfs_efi_copy_format((char*)src_f, src_len, f, continued)) {
 	error = 1;
 	goto error;
     }
 
     printf(_("EFI:  #regs: %d    num_extents: %d  id: 0x%llx\n"),
 	   f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+
+    if (continued) {
+	printf(_("EFI free extent data skipped (CONTINUE set, no space)\n"));
+	goto error;
+    }
+
     ex = f->efi_extents;
     for (i=0; i < f->efi_nextents; i++) {
 	    printf("(s: 0x%llx, l: %d) ",
@@ -1034,7 +1050,8 @@ xlog_print_record(
 		    }
 		    case XFS_LI_EFI: {
 			skip = xlog_print_trans_efi(&ptr,
-					be32_to_cpu(op_head->oh_len));
+					be32_to_cpu(op_head->oh_len),
+					continued);
 			break;
 		    }
 		    case XFS_LI_EFD: {
@@ -1572,7 +1589,11 @@ xfs_inode_item_format_convert(char *src_
 }
 
 int
-xfs_efi_copy_format(char *buf, uint len, xfs_efi_log_format_t *dst_efi_fmt)
+xfs_efi_copy_format(
+	char			  *buf,
+	uint			  len,
+	struct xfs_efi_log_format *dst_efi_fmt,
+	int			  continued)
 {
         uint i;
 	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
@@ -1580,7 +1601,7 @@ xfs_efi_copy_format(char *buf, uint len,
         uint len32 = sizeof(xfs_efi_log_format_32_t) + (nextents - 1) * sizeof(xfs_extent_32_t);
         uint len64 = sizeof(xfs_efi_log_format_64_t) + (nextents - 1) * sizeof(xfs_extent_64_t);
 
-        if (len == dst_len) {
+        if (len == dst_len || continued) {
                 memcpy((char *)dst_efi_fmt, buf, len);
                 return 0;
         } else if (len == len32) {
Index: b/logprint/log_print_all.c
===================================================================
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -411,7 +411,7 @@ xlog_recover_print_efi(
 	    fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"), progname);
 	    exit(1);
 	}
-	if (xfs_efi_copy_format((char*)src_f, src_len, f)) {
+	if (xfs_efi_copy_format((char*)src_f, src_len, f, 0)) {
 	    free(f);
 	    return;
 	}
Index: b/logprint/logprint.h
===================================================================
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -47,6 +47,6 @@ extern void print_stars(void);
 
 extern xfs_inode_log_format_t *
 	xfs_inode_item_format_convert(char *, uint, xfs_inode_log_format_t *);
-extern int xfs_efi_copy_format(char *, uint, xfs_efi_log_format_t *);
+extern int xfs_efi_copy_format(char *, uint, xfs_efi_log_format_t *, int);
 
 #endif	/* LOGPRINT_H */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
