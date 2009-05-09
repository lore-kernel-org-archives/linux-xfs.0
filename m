Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n494fqLI055934 for <xfs@oss.sgi.com>; Fri, 8 May 2009 23:41:52 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 012141D1F7DF
	for <xfs@oss.sgi.com>; Fri,  8 May 2009 21:41:55 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id D2EkVb9RniOMpcjR for
	<xfs@oss.sgi.com>; Fri, 08 May 2009 21:41:55 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 473A59CE5BB
	for <xfs@oss.sgi.com>; Fri,  8 May 2009 23:41:55 -0500 (CDT)
Message-ID: <4A050993.1020208@sandeen.net>
Date: Fri, 08 May 2009 23:41:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: tidy up 205
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
To: xfs-oss <xfs@oss.sgi.com>

Test 205 wasn't marked executable, and had the wrong test
number in the comments.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/205 b/205
old mode 100644
new mode 100755
index 2a0b94e..1604cb3
--- a/205
+++ b/205
@@ -1,5 +1,5 @@
 #! /bin/sh
-# FS QA Test No. 203
+# FS QA Test No. 205
 #
 # Test out ENOSPC flushiung on small filesystems.
 #


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
