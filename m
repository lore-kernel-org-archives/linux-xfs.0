Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q14HFXSK228529 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 11:15:33 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id QrkA2GOCffXdEdAT for <xfs@oss.sgi.com>;
	Sat, 04 Feb 2012 09:15:32 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 3F33E496334E
	for <xfs@oss.sgi.com>; Sat,  4 Feb 2012 11:15:32 -0600 (CST)
Message-ID: <4F2D67B3.4050800@sandeen.net>
Date: Sat, 04 Feb 2012 11:15:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fsstress - make sync a write op
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

I was running 068 to test freeze changes, and realized that
"sync" is not in the op list when "-w" (write ops) is specified,
although fsync & fdatasync are.  It seems to me that sync should
be a default write op as well.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 9b3af17..738843d 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -178,6 +178,7 @@ void	unresvsp_f(int, long);
 void	write_f(int, long);
 
 opdesc_t	ops[] = {
+     /* { OP_ENUM, "name", function, freq, iswrite }, */
 	{ OP_ALLOCSP, "allocsp", allocsp_f, 1, 1 },
 	{ OP_ATTR_REMOVE, "attr_remove", attr_remove_f, /* 1 */ 0, 1 },
 	{ OP_ATTR_SET, "attr_set", attr_set_f, /* 2 */ 0, 1 },
@@ -207,7 +208,7 @@ opdesc_t	ops[] = {
 	{ OP_SETXATTR, "setxattr", setxattr_f, 1, 1 },
 	{ OP_STAT, "stat", stat_f, 1, 0 },
 	{ OP_SYMLINK, "symlink", symlink_f, 2, 1 },
-	{ OP_SYNC, "sync", sync_f, 1, 0 },
+	{ OP_SYNC, "sync", sync_f, 1, 1 },
 	{ OP_TRUNCATE, "truncate", truncate_f, 2, 1 },
 	{ OP_UNLINK, "unlink", unlink_f, 1, 1 },
 	{ OP_UNRESVSP, "unresvsp", unresvsp_f, 1, 1 },


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
