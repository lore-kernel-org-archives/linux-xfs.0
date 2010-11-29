Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATMDBIQ226651 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 16:13:11 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8F0A8F8052
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 14:14:50 -0800 (PST)
Subject: [PATCH] xfstests: ensure uint64_t is defined for <linux/fs.h>
From: Alex Elder <aelder@sgi.com>
Date: Mon, 29 Nov 2010 16:14:00 -0600
Message-ID: <1291068840.2425.15.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: XFS Mailing List <xfs@oss.sgi.com>

When compiling "fiemap-tester.c" in my environment, I am
getting complaints at the first reference to "uint64_t"
in <linux/fs.h>.  This simple patch resolves that.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/fiemap-tester.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/src/fiemap-tester.c
===================================================================
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -18,6 +18,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <string.h>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
