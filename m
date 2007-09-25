Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 17:11:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8P0BfQ3000813
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 17:11:43 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id B119B18011E8F
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 19:11:44 -0500 (CDT)
Message-ID: <46F85240.1060206@sandeen.net>
Date: Mon, 24 Sep 2007 19:11:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] lose xfs_hex_dump in favor of print_hex_dump
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

No need for xfs to have its own hex dumping routine now that the
kernel has one.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6-xfs/fs/xfs/xfs_error.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_error.c
+++ linux-2.6-xfs/fs/xfs/xfs_error.c
@@ -230,37 +230,6 @@ xfs_error_report(
 	}
 }
 
-STATIC void
-xfs_hex_dump(void *p, int length)
-{
-	__uint8_t *uip = (__uint8_t*)p;
-	int	i;
-	char	sbuf[128], *s;
-
-	s = sbuf;
-	*s = '\0';
-	for (i=0; i<length; i++, uip++) {
-		if ((i % 16) == 0) {
-			if (*s != '\0')
-				cmn_err(CE_ALERT, "%s\n", sbuf);
-			s = sbuf;
-			sprintf(s, "0x%x: ", i);
-			while( *s != '\0')
-				s++;
-		}
-		sprintf(s, "%02x ", *uip);
-
-		/*
-		 * the kernel sprintf is a void; user sprintf returns
-		 * the sprintf'ed string's length.  Find the new end-
-		 * of-string
-		 */
-		while( *s != '\0')
-			s++;
-	}
-	cmn_err(CE_ALERT, "%s\n", sbuf);
-}
-
 void
 xfs_corruption_error(
 	char		*tag,
Index: linux-2.6-xfs/fs/xfs/xfs_error.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_error.h
+++ linux-2.6-xfs/fs/xfs/xfs_error.h
@@ -174,6 +174,8 @@ extern void xfs_cmn_err(int panic_tag, i
 /* PRINTFLIKE3 */
 extern void xfs_fs_cmn_err(int level, struct xfs_mount *mp, char *fmt, ...);
 
+extern void xfs_hex_dump(void *p, int length);
+
 #define xfs_fs_repair_cmn_err(level, mp, fmt, args...) \
 	xfs_fs_cmn_err(level, mp, fmt "  Unmount and run xfs_repair.", ## args)
 
Index: linux-2.6-xfs/fs/xfs/support/debug.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/debug.c
+++ linux-2.6-xfs/fs/xfs/support/debug.c
@@ -81,3 +81,9 @@ assfail(char *expr, char *file, int line
 	printk("Assertion failed: %s, file: %s, line: %d\n", expr, file, line);
 	BUG();
 }
+
+void
+xfs_hex_dump(void *p, int length)
+{
+	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
+}
