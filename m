Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2IDXWG027043 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 12:13:34 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2E14C75F9
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 10:14:03 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id c3PBGzBhR7nEij1q for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 10:14:03 -0800 (PST)
Received: from liberator.sandeen.net (sandeen.net [209.173.210.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 30220A7DC08
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 12:14:03 -0600 (CST)
Message-ID: <4B16AE64.5080700@sandeen.net>
Date: Wed, 02 Dec 2009 12:13:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: enable missing functions
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

madvise and mincore were never hooked up to init_commands().

Further, there is no HAVE_INJECT test in the configure scripts,
so just remove that test (and keep the existing unconditional
inject_init() prototype.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/io/init.c b/io/init.c
index 6539a55..f8fc25d 100644
--- a/io/init.c
+++ b/io/init.c
@@ -64,6 +64,8 @@ init_commands(void)
 	help_init();
 	imap_init();
 	inject_init();
+	madvise_init();
+	mincore_init();
 	mmap_init();
 	open_init();
 	parent_init();
diff --git a/io/io.h b/io/io.h
index 43754ca..630897d 100644
--- a/io/io.h
+++ b/io/io.h
@@ -112,12 +112,6 @@ extern void		fadvise_init(void);
 #define fadvise_init()	do { } while (0)
 #endif
 
-#ifdef HAVE_INJECT
-extern void		inject_init(void);
-#else
-#define inject_init()	do { } while (0)
-#endif
-
 #ifdef HAVE_RESBLKS
 extern void		resblks_init(void);
 #else

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
