Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3AK0Gsp052107 for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 15:00:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09B2A14AAEF0
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 13:03:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7RqBtGdsb3Oz1HJ6 for
	<xfs@oss.sgi.com>; Sun, 10 Apr 2011 13:03:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q90r7-0007iT-08
	for xfs@oss.sgi.com; Sun, 10 Apr 2011 20:03:33 +0000
Date: Sun, 10 Apr 2011 16:03:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: allow deeper symlink recursion in 005
Message-ID: <20110410200332.GA29662@infradead.org>
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

Recent kernels allow more than 40 nested symlinks, so up the limit
to still reproduce a failure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/005
===================================================================
--- xfstests-dev.orig/005	2011-03-16 13:10:39.000000000 +0000
+++ xfstests-dev/005	2011-03-16 13:11:00.000000000 +0000
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 _cleanup()
 {
     cd $testdir
-    rm -f symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9} symlink_self empty_file
+    rm -f symlink_{0,1,2,3,4}{0,1,2,3,4,5,6,7,8,9} symlink_self empty_file
     cd /
     _cleanup_testdir
 }
@@ -82,7 +82,7 @@ cd $testdir
 
 o=empty_file
 touch $o
-for f in symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9}
+for f in symlink_{0,1,2,3,4}{0,1,2,3,4,5,6,7,8,9}
 do
     ln -s $o $f
     o=$f
@@ -92,7 +92,7 @@ ln -s symlink_self symlink_self
 
 echo "*** touch deep symlinks"
 echo ""
-_touch symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9}
+_touch symlink_{0,1,2,3,4}{0,1,2,3,4,5,6,7,8,9}
 echo ""
 echo "*** touch recusive symlinks"
 echo ""

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
