Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QM7i6r046092 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 17:08:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 121E8154E726
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 15:08:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AEq9pkvHOoAr7gAw for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 15:08:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MgQfU-0004x4-Oq
	for xfs@oss.sgi.com; Wed, 26 Aug 2009 22:08:36 +0000
Date: Wed, 26 Aug 2009 18:08:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix 192 for external logs and enable it by default
Message-ID: <20090826220836.GA18119@infradead.org>
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

Use _test_mount instead of plain mount to make it work with external logs.

Enable it by default now that it runs everywhere.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2009-08-26 21:57:59.000000000 +0000
+++ xfstests-dev/group	2009-08-26 21:58:06.000000000 +0000
@@ -301,7 +301,7 @@ prealloc
 189 mount auto quick
 190 rw auto quick
 191 nfs4acl auto
-192 atime
+192 atime auto
 193 metadata auto quick
 194 rw auto
 195 ioctl dump auto quick
Index: xfstests-dev/192
===================================================================
--- xfstests-dev.orig/192	2009-08-26 21:57:51.000000000 +0000
+++ xfstests-dev/192	2009-08-26 22:04:16.000000000 +0000
@@ -67,7 +67,7 @@ time2=`_access_time $testfile | tee -a $
 
 cd /
 umount $TEST_DIR
-mount $TEST_DIR
+_test_mount
 time3=`_access_time $testfile | tee -a $seq.full`
 
 delta1=`expr $time2 - $time1`

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
