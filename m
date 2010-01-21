Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LBX1Dh069044 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 05:33:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5EC017F65B
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:34:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id k2DA2Mp3XiLyDTF8 for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:34:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NXvIY-00010j-E7
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 11:34:02 +0000
Date: Thu, 21 Jan 2010 06:34:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix format string warnings in locktest.c
Message-ID: <20100121113402.GB3580@infradead.org>
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

Index: xfstests-dev/src/locktest.c
===================================================================
--- xfstests-dev.orig/src/locktest.c	2010-01-21 11:26:53.000000000 +0000
+++ xfstests-dev/src/locktest.c	2010-01-21 11:27:13.000000000 +0000
@@ -741,7 +741,7 @@ send_ctl(void)
         if (nwrite < 0)
             perror("send_ctl: write");
         else
-            fprintf(stderr, "send_ctl[%d]: write() returns %d, not %lu as expected\n", 
+            fprintf(stderr, "send_ctl[%d]: write() returns %d, not %zu as expected\n", 
                     ctl.test, nwrite, sizeof(ctl));
         exit(1);
         /*NOTREACHED*/
@@ -756,7 +756,7 @@ void recv_ctl(void)
         if (nread < 0)
             perror("recv_ctl: read");
         else {
-            fprintf(stderr, "recv_ctl[%d]: read() returns %d, not %lu as expected\n", 
+            fprintf(stderr, "recv_ctl[%d]: read() returns %d, not %zu as expected\n", 
                     ctl.test, nread, sizeof(ctl));
 	    fprintf(stderr, "socket might has been closed by other locktest\n");
 	} 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
