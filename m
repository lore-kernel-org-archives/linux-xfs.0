Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EIc4id116318 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 12:38:05 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BuA9TBJhQVe9LolX for
	<xfs@oss.sgi.com>; Tue, 14 Feb 2012 10:38:03 -0800 (PST)
Message-ID: <4F3AAA03.2010305@redhat.com>
Date: Tue, 14 Feb 2012 10:37:55 -0800
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: skip FSGEOMETRY call in openfile if no geom var
	present
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
To: xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>

sendfile_f() calls openfile() with NULL *geom even if it's on an
xfs filesystem, so we need to skip the ioctl if (!geom).

Fixes regression from d1b88183bb3fc5e338746db53269310348646753

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/open.c b/io/open.c
index 97631e2..ac39ccc 100644
--- a/io/open.c
+++ b/io/open.c
@@ -163,7 +163,7 @@ openfile(
 		}
 	}
 
-	if (!platform_test_xfs_fd(fd))
+	if (!geom || !platform_test_xfs_fd(fd))
 		return fd;
 
 	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
