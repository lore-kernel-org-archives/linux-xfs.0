Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UJpJGw233520 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 13:51:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D90441C92333
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:52:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1sRslPD3nHzLtn4W for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:52:26 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NbJMo-00041o-JJ
	for xfs@oss.sgi.com; Sat, 30 Jan 2010 19:52:26 +0000
Date: Sat, 30 Jan 2010 14:52:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] mkfs.xfs: fix fd validity check in get_topology
Message-ID: <20100130195226.GA15379@infradead.org>
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

Only negatie return values from open mean we failed to open the device.
Without this check we do not print the usage message when no device is
specified.  This leads to a weird failure in xfstests 122.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-01-30 20:44:03.505255109 +0100
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-01-30 20:44:20.579255807 +0100
@@ -455,7 +455,7 @@ static void get_topology(libxfs_init_t *
 				&ft->dsunit, &ft->dswidth, &ft->sectoralign);
 		fd = open(dfile, O_RDONLY);
 		/* If this fails we just fall back to BBSIZE */
-		if (fd) {
+		if (fd >= 0) {
 			platform_findsizes(dfile, fd, &dummy, &bsz);
 			close(fd);
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
