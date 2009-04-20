Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3K2YViH021160 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 21:34:31 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 725081432FBB
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 19:36:59 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 9WEfuR23OGx7C6pY for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 19:36:59 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 784D5A9ABC2
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 21:34:24 -0500 (CDT)
Message-ID: <49EBDF30.90702@sandeen.net>
Date: Sun, 19 Apr 2009 21:34:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH, RFC] put xfs build features into the stats file
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

Running xfstests on an xfs build w/o xattrs enabled, I realized
there's no reliable way to see if the running xfs has various
features other than debug (which is shown in /proc/fs/xfs/stat)

What do folks think of adding the BUILD_OPTIONS to this file
as well?

# cat /proc/fs/xfs/stat
extent_alloc 0 0 0 0
...
xpc 0 0 0
debug 0
features security attributes, large block numbers, no debug 

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_stats.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_stats.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_stats.c
@@ -89,6 +89,8 @@ xfs_read_xfsstats(
 		0);
 #endif
 
+	len += sprintf(buffer + len, "features " XFS_BUILD_OPTIONS "\n");
+
 	if (offset >= len) {
 		*start = buffer;
 		*eof = 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
