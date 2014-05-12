Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C1487F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 07:46:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3371D8F8037
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 05:46:45 -0700 (PDT)
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com
	[209.85.216.173]) by cuda.sgi.com with ESMTP id
	J6IAstoSZiuPJw9t (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 05:46:43 -0700 (PDT)
Received: by mail-qc0-f173.google.com with SMTP id i8so7722908qcq.32
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 05:46:42 -0700 (PDT)
Received: from tlielax.poochiereds.net ([2001:470:8:d63:3a60:77ff:fe93:a95d])
	by mx.google.com with ESMTPSA id
	q33sm7141551qgq.27.2014.05.12.05.46.41 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 12 May 2014 05:46:41 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH] loggen: remove deprecated header includes and add
	definition for XFS_TRANS_MAGIC
Date: Mon, 12 May 2014 08:46:35 -0400
Message-Id: <1399898795-12967-1-git-send-email-jlayton@poochiereds.net>
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

xfstests was failing to build on my rawhide box. The problem was that
some of the headers included by loggen.c no longer exist in current
releases. This just removes those includes and adds a conditional
definition of XFS_TRANS_MAGIC.

It may make more sense to just move XFS_TRANS_MAGIC to a different
header, but this seems to work on both f20 and rawhide boxes.

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 src/loggen.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/loggen.c b/src/loggen.c
index 522c9178ee26..1740732249b6 100644
--- a/src/loggen.c
+++ b/src/loggen.c
@@ -26,8 +26,6 @@
  */
 
 #include <xfs/libxfs.h>
-#include <xfs/xfs_log.h>
-#include <xfs/xfs_log_priv.h>
 
 #ifndef ASSIGN_ANY_LSN_DISK
 #define ASSIGN_ANY_LSN_DISK(lsn,cycle,block)  \
@@ -37,6 +35,10 @@
     }
 #endif
 
+#ifndef XFS_TRANS_MAGIC
+#define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
+#endif
+
 void
 usage(void)
 {
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
