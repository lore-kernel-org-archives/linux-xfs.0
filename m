Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n05JVUYk013559 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 13:31:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3C4E17A8684
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 11:31:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zCWtbErP3M0YLK2y for
	<xfs@oss.sgi.com>; Mon, 05 Jan 2009 11:31:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LJvAf-0005Dh-2Q
	for xfs@oss.sgi.com; Mon, 05 Jan 2009 19:31:29 +0000
Date: Mon, 5 Jan 2009 14:31:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] define xfs_ino_t as unsigned long long
Message-ID: <20090105193129.GA19909@infradead.org>
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

That way we can avoid ugly casts when printining it (like the ones
that show up on powerpc with Linus' current tree).


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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
