Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bU48235717 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E47A6177475
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	C0vqegYOMGod9ZAo for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:29 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651456-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:25 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROi-00053X-Mf
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:24 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008a-Ik
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfstests: don't redefine _GNU_SOURCE in aio tests
Date: Wed, 20 Jan 2010 14:38:08 +1100
Message-Id: <1263958688-435-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 src/aio-dio-regress/aio-dio-subblock-eof-read.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/src/aio-dio-regress/aio-dio-subblock-eof-read.c b/src/aio-dio-regress/aio-dio-subblock-eof-read.c
index cbcff97..a48841d 100644
--- a/src/aio-dio-regress/aio-dio-subblock-eof-read.c
+++ b/src/aio-dio-regress/aio-dio-subblock-eof-read.c
@@ -31,8 +31,6 @@
  *  worth of data, and the user issued a 4k read, we want to ensure that
  *  the return value is 300, not 4k.
  */
-
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <libaio.h>
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
