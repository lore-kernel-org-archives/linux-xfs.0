Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3J3qJb180262 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 13:03:52 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CF945A8D8
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 11:04:06 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id rz5P0yuJCz14oBy1 for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2009 11:04:06 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 06723AA60C4
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 13:04:05 -0600 (CST)
Message-ID: <4AF07EA4.9000405@sandeen.net>
Date: Tue, 03 Nov 2009 13:04:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: include src/aio-dio-regress in install subdirs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

From: Izidor Matusov <imatusov@redhat.com>

Install src/aio-dio-regress tests on "make install"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/Makefile b/Makefile
index b017580..4dcb779 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	check.log check.time
 
 LIB_SUBDIRS = include lib
-TOOL_SUBDIRS = ltp src m4
+TOOL_SUBDIRS = ltp src src/aio-dio-regress m4
 
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
