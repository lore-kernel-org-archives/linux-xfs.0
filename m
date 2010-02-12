Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKtgob027301 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:55:42 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002122056.o1CKuruK025550@stout.americas.sgi.com>
Date: Fri, 12 Feb 2010 14:56:53 -0600
Subject: [PATCH] dmapi: Fix a build warning
MIME-Version: 1.0
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

Fix a build warning.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 libdm/getdents.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: dmapi/libdm/getdents.c
===================================================================
--- dmapi.orig/libdm/getdents.c
+++ dmapi/libdm/getdents.c
@@ -72,7 +72,9 @@ extern int __have_no_getdents64;
 # endif
 #endif
 
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#ifndef offsetof
+# define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif /* ! offsetof */
 
 
 /* For Linux we need a special version of this file since the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
