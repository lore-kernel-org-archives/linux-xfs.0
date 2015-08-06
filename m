Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB00C7F84
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 02:55:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C1F1C8F8035
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 00:55:00 -0700 (PDT)
Received: from p-smtp-as-02.sunrise.ch (p-smtp-as-01.sunrise.ch
	[212.35.39.69]) by cuda.sgi.com with ESMTP id 4C3jH6uyTQJUy7YS
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Aug 2015 00:54:58 -0700 (PDT)
Message-ID: <55C312CF.2040408@vollmann.ch>
Date: Thu, 06 Aug 2015 09:54:55 +0200
From: Detlef Vollmann <dv@vollmann.ch>
MIME-Version: 1.0
Subject: xfsdump doesn't compile: undefined reference to 'min'
Content-Type: multipart/mixed; boundary="------------010409060606010109010604"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------010409060606010109010604
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

 > commit 5a2985233c390d59d2a9757b119cb0e001c87a96
 > Author: Dave Chinner <dchinner@redhat.com>
 > Date:   Fri Jul 18 08:02:26 2014 +1000
 >
 >     dump: don't redefine min() or max()
 >
 >     They are included from other header files.
The message doesn't say from which header and configure doesn't test
for it.
If I compile it (cross-compilation, gcc, uclibc, xfsprogs 3.1.11,
xfsdump 3.1.4), I get lots of errors:
warning: implicit declaration of function 'max'
undefined reference to 'min'

Attached is a pragmatic patch.

   Detlef

PS: I'm not on the list.

--------------010409060606010109010604
Content-Type: text/x-patch;
 name="001-minmax.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="001-minmax.patch"

diff --git a/common/util.h b/common/util.h
index 86ea8d2..460aea5 100644
--- a/common/util.h
+++ b/common/util.h
@@ -66,6 +66,12 @@ extern intgen_t read_buf( char *bufp,
 			  rrbfp_t return_read_buf_funcp,
 			  intgen_t *statp );
 
+#ifndef min
+#define min( a, b )	( ( ( a ) < ( b ) ) ? ( a ) : ( b ) )
+#endif
+#ifndef max
+#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
+#endif
 
 
 /* strncpyterm - like strncpy, but guarantees the destination is null-terminated
diff --git a/restore/dirattr.c b/restore/dirattr.c
index fcfa0c8..6413c15 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -51,6 +51,10 @@
 
 /* structure definitions used locally ****************************************/
 
+#ifndef max
+#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
+#endif
+
 /* node handle limits
  */
 #ifdef DIRATTRCHK
diff --git a/restore/namreg.c b/restore/namreg.c
index 41362d1..4630605 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -34,6 +34,10 @@
 
 /* structure definitions used locally ****************************************/
 
+#ifndef max
+#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
+#endif
+
 #define NAMREG_AVGLEN	10
 
 /* persistent context for a namreg - placed in first page
diff --git a/restore/node.c b/restore/node.c
index 4cc8fb0..97d46e1 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -30,6 +30,13 @@
 #include "node.h"
 #include "mmap.h"
 
+#ifndef max
+#define max( a, b )	( ( ( a ) > ( b ) ) ? ( a ) : ( b ) )
+#endif
+#ifndef min
+#define min( a, b )	( ( ( a ) < ( b ) ) ? ( a ) : ( b ) )
+#endif
+
 extern size_t pgsz;
 extern size_t pgmask;
 

--------------010409060606010109010604
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------010409060606010109010604--
