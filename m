Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 23:17:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k966H1aG020720
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 23:17:03 -0700
Date: Fri, 06 Oct 2006 16:18:10 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: review: xfs_copy fix
Message-ID: <5635EC4CFB723E7E36B51235@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Request for review.

xfs_copy was seg faulting for me on my x86_64 box.
This fixes up the variable arg handling for multiple
vfprintf calls by putting va_start and va_end calls
around them (never done this before:).

Thanks,
--Tim


===========================================================================
Index: xfs-cmds/xfsprogs/copy/xfs_copy.c
===================================================================
--- xfs-cmds.orig/xfsprogs/copy/xfs_copy.c	2006-10-06 13:55:01.000000000 
+1000
+++ xfs-cmds/xfsprogs/copy/xfs_copy.c	2006-10-06 13:52:14.000000000 +1000
@@ -77,17 +77,23 @@
 	va_list	ap;
 	int	eek = 0;

-	va_start(ap, fmt);
-	if (flags & LOG)
+	if (flags & LOG) {
+		va_start(ap, fmt);
 		if (vfprintf(logerr, fmt, ap) <= 0)
 			eek = 1;
+		va_end(ap);
+	}
 	if (eek)
 		flags |= ERR;	/* failed, force stderr */
-	if (flags & ERR)
+	if (flags & ERR) {
+		va_start(ap, fmt);
 		vfprintf(stderr, fmt, ap);
-	else if (flags & OUT)
+		va_end(ap);
+	} else if (flags & OUT) {
+		va_start(ap, fmt);
 		vfprintf(stdout, fmt, ap);
-	va_end(ap);
+		va_end(ap);
+	}

 	if (flags & PRE) {
 		do_message(flags & ~PRE, 0, ":  %s\n", strerror(code));
