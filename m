Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MGmESG245031 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 11:48:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C692140E74B
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 09:53:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ICzoFsdTWufOiZ5e for <xfs@oss.sgi.com>;
	Thu, 22 Sep 2011 09:53:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R6mRW-0003Dg-5E
	for xfs@oss.sgi.com; Thu, 22 Sep 2011 16:48:10 +0000
Date: Thu, 22 Sep 2011 12:48:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] invutil: fix a gcc warning
Message-ID: <20110922164810.GA12353@infradead.org>
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

We never use the lines variable in put_line, except by writing to.  Replace
the fairly ugly getmaxyx macro causing this with the getmaxx call (which
is used by getmaxyx underneath) to only get the number of columns.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsdump/invutil/screen.c
===================================================================
--- xfsdump.orig/invutil/screen.c	2011-09-22 12:36:55.445019732 -0400
+++ xfsdump/invutil/screen.c	2011-09-22 12:38:39.272020235 -0400
@@ -27,11 +27,10 @@ put_line(WINDOW *win, int line, char *ms
 {
     int c;
     int cols;
-    int lines;
     int msglen;
     static char text[256];
 
-    getmaxyx(win, lines, cols);
+    cols = getmaxx(win);
     cols--;
     if(cols > 255) {
 	cols = 255;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
