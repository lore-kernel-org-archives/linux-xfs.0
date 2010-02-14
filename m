Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1EM6bBs000683 for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 16:06:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F2AD1CF4F7
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 14:07:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JvcZItIQ0oPJpRlJ for
	<xfs@oss.sgi.com>; Sun, 14 Feb 2010 14:07:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ngmd7-00041G-IE
	for xfs@oss.sgi.com; Sun, 14 Feb 2010 22:07:53 +0000
Date: Sun, 14 Feb 2010 17:07:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: use blkid raw mode
Message-ID: <20100214220753.GB14927@infradead.org>
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

blkid without options usually gets no probe results at all just after
creating a filesystem.  This problem is due to the cache that blkid
uses in it's default mode, and is unlikely to get fixed.  Use the -p
option to bypass the cache layer.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/common
===================================================================
--- xfstests-dev.orig/common	2010-02-11 16:08:58.000000000 +0000
+++ xfstests-dev/common	2010-02-11 16:09:03.000000000 +0000
@@ -47,7 +47,7 @@ rm -f $tmp.list $tmp.tmp $tmp.sed
 # Autodetect fs type based on what's on $TEST_DEV
 if [ "$HOSTOS" == "Linux" ]
 then
-    export FSTYP=`blkid -s TYPE -o value $TEST_DEV`
+    export FSTYP=`blkid -p -s TYPE -o value $TEST_DEV`
 else
     export FSTYP=xfs
 fi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
