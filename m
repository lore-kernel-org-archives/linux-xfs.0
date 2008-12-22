Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiB91006539 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E8863F8DF
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uOJPTCvbDrCDJpYC for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:10 -0800 (PST)
Message-Id: <20081222164409.723776000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/20] xfstests: add a unified diff option
Content-Disposition: inline; filename=xfstests-udiff-option
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

From: Matthew Kent <mkent@magoazul.com>


Add the -udiff option to the test driver to make test output more
easily readable.

[hch:  why not make this default?]


Reviewed-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfstests/common
===================================================================
--- xfs-cmds.orig/xfstests/common	2008-12-01 22:06:21.000000000 +0100
+++ xfs-cmds/xfstests/common	2008-12-22 14:06:59.485250140 +0100
@@ -107,6 +107,7 @@ check options
     -nfs                test NFS
     -l			line mode diff (default)
     -xdiff		graphical mode diff
+    -udiff		show unified diff
     -n			show me, do not run tests
     -q			quick [deprecated]
     -T			output timestamps
@@ -157,6 +158,11 @@ testlist options
 	    fi
 	    ;;
 
+	-udiff) # show a unified diff
+	    xpand=false
+	    diff="$diff -u"
+	    ;;
+
 	-q)	# "quick", no longer used - always quick :-)
 	    xpand=false
 	    ;;

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
