Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBKPZO205252 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:20:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 068B61358586
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:20:24 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	o7kGLuYrC5BuCI9A for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:20:24 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QkwjP-0004yn-Sy
	for xfs@oss.sgi.com; Sun, 24 Jul 2011 11:20:23 +0000
Date: Sun, 24 Jul 2011 07:20:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix fsx build with the new xfs headers
Message-ID: <20110724112023.GA16125@infradead.org>
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

The libxfs resync brought in a new round_up macro that conflicts with the
round_up function in fsx.  Rename the latter to allow building against the
new headers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/ltp/fsx.c
===================================================================
--- xfstests-dev.orig/ltp/fsx.c	2011-07-23 14:27:27.000000000 +0000
+++ xfstests-dev/ltp/fsx.c	2011-07-23 14:28:10.000000000 +0000
@@ -165,7 +165,7 @@ FILE *	fsxlogf = NULL;
 int badoff = -1;
 int closeopen = 0;
 
-static void *round_up(void *ptr, unsigned long align, unsigned long offset)
+static void *round_ptr_up(void *ptr, unsigned long align, unsigned long offset)
 {
 	unsigned long ret = (unsigned long)ptr;
 
@@ -1570,10 +1570,10 @@ main(int argc, char **argv)
 	for (i = 0; i < maxfilelen; i++)
 		original_buf[i] = random() % 256;
 	good_buf = (char *) malloc(maxfilelen + writebdy);
-	good_buf = round_up(good_buf, writebdy, 0);
+	good_buf = round_ptr_up(good_buf, writebdy, 0);
 	memset(good_buf, '\0', maxfilelen);
 	temp_buf = (char *) malloc(maxoplen + readbdy);
-	temp_buf = round_up(temp_buf, readbdy, 0);
+	temp_buf = round_ptr_up(temp_buf, readbdy, 0);
 	memset(temp_buf, '\0', maxoplen);
 	if (lite) {	/* zero entire existing file */
 		ssize_t written;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
