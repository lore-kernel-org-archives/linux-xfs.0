Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1DC3v03047258 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 06:03:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D6C915600A4
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 04:06:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FohWEImdTLhVs3gG for
	<xfs@oss.sgi.com>; Sun, 13 Feb 2011 04:06:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Poaio-00017m-EB
	for xfs@oss.sgi.com; Sun, 13 Feb 2011 12:06:34 +0000
Date: Sun, 13 Feb 2011 07:06:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: enable delaylog by default
Message-ID: <20110213120634.GA4322@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-02-12 08:01:36.523700058 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-02-12 08:01:47.373201415 +0100
@@ -189,6 +189,7 @@ xfs_parseargs(
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
 	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+	mp->m_flags |= XFS_MOUNT_DELAYLOG;
 
 	/*
 	 * These can be overridden by the mount option parsing.
Index: xfs/Documentation/filesystems/xfs-delayed-logging-design.txt
===================================================================
--- xfs.orig/Documentation/filesystems/xfs-delayed-logging-design.txt	2011-02-12 08:01:58.844704558 +0100
+++ xfs/Documentation/filesystems/xfs-delayed-logging-design.txt	2011-02-12 08:02:04.843703022 +0100
@@ -791,10 +791,3 @@ mount option. Fundamentally, there is no
 be able to swap methods automatically and transparently depending on load
 characteristics, but this should not be necessary if delayed logging works as
 designed.
-
-Roadmap:
-
-2.6.39 Switch default mount option to use delayed logging
-	=> should be roughly 12 months after initial merge
-	=> enough time to shake out remaining problems before next round of
-	   enterprise distro kernel rebases

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
