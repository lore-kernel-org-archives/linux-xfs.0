Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08IiWvp021263 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 12:44:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78925715AA
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 10:44:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xz4oPlJoBkEuyJn7 for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 10:44:32 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LKzrr-00062d-1i
	for xfs@oss.sgi.com; Thu, 08 Jan 2009 18:44:31 +0000
Message-Id: <20090108184430.967925000@bombadil.infradead.org>
References: <20090108184222.244013000@bombadil.infradead.org>
Date: Thu, 08 Jan 2009 13:42:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: make xfs_ino_t an unsigned long long
Content-Disposition: inline; filename=xfs-ino-printing-fixes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Currently xfs_ino_t is defined as a u64 which can either be an unsigned
long long or on some 64 bit platforms and unsigned long.  Just making
it and unsigned long long mean's it's still always 64 bits wide, but we
don't need to resort to cases to print it.

Fixes a warning regression on 64 bit powerpc in current git.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_types.h
===================================================================
--- xfs.orig/fs/xfs/xfs_types.h	2009-01-01 11:53:17.321546620 +0100
+++ xfs/fs/xfs/xfs_types.h	2009-01-05 20:30:04.794549213 +0100
@@ -45,7 +45,7 @@ typedef __uint32_t		prid_t;		/* project 
 typedef __uint32_t		inst_t;		/* an instruction */
 
 typedef __s64			xfs_off_t;	/* <file offset> type */
-typedef __u64			xfs_ino_t;	/* <inode> type */
+typedef unsigned long long	xfs_ino_t;	/* <inode> type */
 typedef __s64			xfs_daddr_t;	/* <disk address> type */
 typedef char *			xfs_caddr_t;	/* <core address> type */
 typedef __u32			xfs_dev_t;

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
