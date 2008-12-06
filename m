Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6ARASF005105 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 04:27:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61A06CE1793
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 02:27:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nQdiJyWNOddYAmf1 for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 02:27:10 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L8uNR-0007v8-U3
	for xfs@oss.sgi.com; Sat, 06 Dec 2008 10:27:09 +0000
Date: Sat, 6 Dec 2008 05:27:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsdump: cleanup _rmt_dev
Message-ID: <20081206102709.GB30364@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

Rewrite _rmt_dev to be proper ANSI C and readable.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsdump/librmt/rmtdev.c
===================================================================
--- xfs-cmds.orig/xfsdump/librmt/rmtdev.c	2008-11-25 16:39:45.000000000 +0530
+++ xfs-cmds/xfsdump/librmt/rmtdev.c	2008-11-25 16:41:06.000000000 +0530
@@ -28,18 +28,12 @@
  *	is any string that contains ":/dev/".  Returns 1 if remote,
  *	0 otherwise.
  */
-
-int _rmt_dev (path)
-register char *path;
+int _rmt_dev(char *path)
 {
-	if ((path = strchr (path, ':')) != (char *)0)
-	{
-		if (strncmp (path + 1, "/dev/", 5) == 0)
-		{
-			return (1);
-		}
-	}
-	return (0);
-}
-
+	char *c;
 
+	c = strchr(path, ':');
+	if (c && strncmp(c + 1, "/dev/", 5) == 0)
+		return 1;
+	return 0;
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
