Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD53B7F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 03:59:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69BD6AC004
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:59:49 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	zeYVAYvossvrWGlh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:59:44 -0700 (PDT)
Received: by wieq12 with SMTP id q12so21262239wie.1
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:59:42 -0700 (PDT)
From: Avi Kivity <avi@scylladb.com>
Subject: [PATCH] xfsprogs: make platform_defs.h more friendly to C++ code
Date: Tue, 13 Oct 2015 11:59:38 +0300
Message-Id: <1444726778-11867-1-git-send-email-avi@scylladb.com>
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

C++ has its own min(); and xfsprog's min() interferes with it.

(It's likely to interfere with C applications too, so maybe it should be
moved to an internal header)

Signed-off-by: Avi Kivity <avi@scylladb.com>
---
 include/platform_defs.h.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 30dd7a4..aaabed6 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -74,10 +74,12 @@ typedef unsigned short umode_t;
 					| (minor&IRIX_DEV_MAXMIN)))
 #define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))
 
+#ifndef __cplusplus
 #ifndef min
 #define min(a,b)	(((a)<(b))?(a):(b))
 #define max(a,b)	(((a)>(b))?(a):(b))
 #endif
+#endif
 
 #ifndef NBBY
 #define NBBY 8
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
