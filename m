Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LBXLis069071 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 05:33:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFE5312F4A90
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:34:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EfF5i4iD7stxGCH2 for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:34:22 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NXvIr-00011F-Et
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 11:34:21 +0000
Date: Thu, 21 Jan 2010 06:34:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix format string warnings in aio-dio-extend-stat.c
Message-ID: <20100121113421.GC3580@infradead.org>
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

Index: xfstests-dev/src/aio-dio-regress/aio-dio-extend-stat.c
===================================================================
--- xfstests-dev.orig/src/aio-dio-regress/aio-dio-extend-stat.c	2010-01-21 11:27:36.000000000 +0000
+++ xfstests-dev/src/aio-dio-regress/aio-dio-extend-stat.c	2010-01-21 11:28:15.000000000 +0000
@@ -149,8 +149,9 @@ void fun_read(void *ptr)
 			if (filestat.st_size < exSize)
 				fail("write of %lu bytes @%llu finished, "
 				     "expected filesize at least %llu, but "
-				     "got %ld\n", event->obj->u.c.nbytes,
-				     event->obj->u.c.offset, exSize, filestat.st_size);
+				     "got %lld\n", event->obj->u.c.nbytes,
+				     event->obj->u.c.offset, exSize,
+				     (long long)filestat.st_size);
 		}
 	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
