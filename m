Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUN9EkM007370 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:09:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5C7D53C3D
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jCye6b1MnkPZsqXo for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHni5-0000H9-8Q
	for xfs@oss.sgi.com; Tue, 30 Dec 2008 23:09:13 +0000
Message-Id: <20081230230913.139390000@bombadil.infradead.org>
References: <20081230230810.986105000@bombadil.infradead.org>
Date: Tue, 30 Dec 2008 18:08:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfstests: update for xfs_dinode_core_t removal
Content-Disposition: inline; filename=xfstests-forkoff-fixes
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

Strip away the core. prefixes in 186 to make sure the golden output
works for both old and new xfsprogs.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/186
===================================================================
--- xfstests/186	2008-12-30 13:04:58.000000000 +0000
+++ xfstests/186	2008-12-30 14:25:51.000000000 +0000
@@ -66,8 +66,10 @@
 
 _filter_inode()
 {
-	tee -a $seq.full | egrep '^u.sfdir2|^a.sfattr|core.forkoff' |\
-	egrep -v 'inumber|parent'
+	tee -a $seq.full | \
+		sed -e "s/core.forkoff/forkoff/g" | \
+		egrep '^u.sfdir2|^a.sfattr|forkoff' | \
+		egrep -v 'inumber|parent'
 }
 
 _filter_version()
Index: xfstests/186.out
===================================================================
--- xfstests/186.out	2008-12-30 13:04:58.000000000 +0000
+++ xfstests/186.out	2008-12-30 13:05:50.000000000 +0000
@@ -2,7 +2,7 @@
 
 =================================
 ATTR2
-core.forkoff = 0
+forkoff = 0
 u.sfdir2.hdr.count = 0
 u.sfdir2.hdr.i8count = 0
 =================================
@@ -12,7 +12,7 @@
 
 =================================
 ATTR2
-core.forkoff = 0
+forkoff = 0
 u.sfdir2.hdr.count = 25
 u.sfdir2.hdr.i8count = 0
 u.sfdir2.list[0].namelen = 6
@@ -98,7 +98,7 @@
 =================================
 ATTR
 ATTR2
-core.forkoff = 47
+forkoff = 47
 u.sfdir2.hdr.count = 25
 u.sfdir2.hdr.i8count = 0
 u.sfdir2.list[0].namelen = 6
@@ -195,7 +195,7 @@
 
 =================================
 ATTR
-core.forkoff = 47
+forkoff = 47
 u.sfdir2.hdr.count = 25
 u.sfdir2.hdr.i8count = 0
 u.sfdir2.list[0].namelen = 6

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
