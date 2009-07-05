Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n65HN5P3038539 for <xfs@oss.sgi.com>; Sun, 5 Jul 2009 12:23:06 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7162B1309523
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2009 10:30:20 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id w2NtNZHNJY7CdvQY for
	<xfs@oss.sgi.com>; Sun, 05 Jul 2009 10:30:20 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id D6EF38D78C5
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2009 12:23:35 -0500 (CDT)
Message-ID: <4A50E197.3070209@sandeen.net>
Date: Sun, 05 Jul 2009 12:23:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH (trivial)] remove XFS_INO64_OFFSET
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

Commit a19d9f887d81106d52cacbc9930207b487e07e0e removed the
ino64 option but left the XFS_INO64_OFFSET define it used
in place - just remove it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/xfs_inum.h b/fs/xfs/xfs_inum.h
index 7a28191..b8e4ee4 100644
--- a/fs/xfs/xfs_inum.h
+++ b/fs/xfs/xfs_inum.h
@@ -72,7 +72,6 @@ struct xfs_mount;
 
 #if XFS_BIG_INUMS
 #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
-#define	XFS_INO64_OFFSET	((xfs_ino_t)(1ULL << 32))
 #else
 #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 32) - 1ULL))
 #endif


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
