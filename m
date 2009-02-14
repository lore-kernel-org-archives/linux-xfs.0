Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1EGg2u2003418 for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 10:42:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BB4611F487
	for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 08:41:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id InhEVQzRGoIfV6Q1 for
	<xfs@oss.sgi.com>; Sat, 14 Feb 2009 08:41:28 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LYNa3-0005cO-V5
	for xfs@oss.sgi.com; Sat, 14 Feb 2009 16:41:27 +0000
Date: Sat, 14 Feb 2009 11:41:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: remove tests 171, 172 and 173 from auto group
Message-ID: <20090214164127.GC19813@infradead.org>
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

I don't have a single machine where these succeed, and due to the wait
the filestreams allocator works these tests might depend on the phase
on the moon to get their expected output.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2009-02-14 15:13:08.000000000 +0000
+++ xfstests-dev/group	2009-02-14 15:14:13.000000000 +0000
@@ -273,9 +273,12 @@
 168 dmapi auto
 169 rw metadata auto
 170 rw filestreams auto
-171 rw filestreams auto
-172 rw filestreams auto
-173 rw filestreams auto
+# the next three tests are not deterministic enough to get the
+# "right" result on all platforms/configuration, so don't run
+# them by default.
+171 rw filestreams
+172 rw filestreams
+173 rw filestreams
 174 rw filestreams auto
 175 dmapi auto
 176 dmapi auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
