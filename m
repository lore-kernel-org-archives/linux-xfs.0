Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUN9ELR007372 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:09:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD12A53C3E
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XvbLPglleVJXis6G for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHni5-0000Ha-CW
	for xfs@oss.sgi.com; Tue, 30 Dec 2008 23:09:13 +0000
Message-Id: <20081230230913.302710000@bombadil.infradead.org>
References: <20081230230810.986105000@bombadil.infradead.org>
Date: Tue, 30 Dec 2008 18:08:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfstests: test 195, add a testcase for the nodump flag
Content-Disposition: inline; filename=xfstests-add-dump-flag-test
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

Based on http://oss.sgi.com/bugzilla/show_bug.cgi?id=340.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/195
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests/195	2008-12-29 17:55:16.000000000 +0000
@@ -0,0 +1,75 @@
+#! /bin/sh
+# FS QA Test No. 195
+#
+# Make sure the chattr dump flag gets picked up by xfsdump without a sync
+#
+# http://oss.sgi.com/bugzilla/show_bug.cgi?id=340
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Christoph Hellwig.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=hch@lst.de
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -rf $TEST_DIR/d
+	rm -f $TEST_DIR/dumpfile
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+#
+# Perform a level 0 dump that respects the chattr dump exclude flag,
+# and grep the output for the inode number we expect / do not expect
+# to be skipped
+#
+# Only dump a subtree so we get away with a single partition for
+# the subtree to be dumped and the dump file.
+#
+_do_dump()
+{
+	xfsdump -l 0 -s d -F  \
+		-L prova -M prova \
+		-f $TEST_DIR/dumpfile -e -v excluded_files=debug $TEST_DIR \
+		| grep "ino $inum" \
+		| sed -e 's/xfsdump: pruned ino [0-9]*, owner 0, estimated size 0: skip flag set/xfsdump: pruned ino NNN, owner 0, estimated size 0: skip flag set/'
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_user
+
+echo "Preparing subtree"
+mkdir $TEST_DIR/d
+touch $TEST_DIR/d/t
+inum=`stat --format "%i" $TEST_DIR/d/t`
+
+echo "No dump exclude flag set (should not be skipped)"
+_do_dump
+
+echo "Dump exclude flag set, but no sync yet (should be skipped)"
+chattr +d $TEST_DIR/d/t
+_do_dump
+
+echo "Dump exclude flag set, after sync (should be skipped)"
+sync
+_do_dump
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
Index: xfstests/195.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests/195.out	2008-12-29 17:16:38.000000000 +0000
@@ -0,0 +1,8 @@
+QA output created by 195
+Preparing subtree
+No dump exclude flag set (should not be skipped)
+Dump exclude flag set, but no sync yet (should be skipped)
+xfsdump: pruned ino NNN, owner 0, estimated size 0: skip flag set
+Dump exclude flag set, after sync (should be skipped)
+xfsdump: pruned ino NNN, owner 0, estimated size 0: skip flag set
+*** done
Index: xfstests/group
===================================================================
--- xfstests/group	2008-12-29 17:16:24.000000000 +0000
+++ xfstests/group	2008-12-29 17:55:09.000000000 +0000
@@ -297,3 +297,4 @@
 192 atime
 193 metadata auto
 194 rw auto
+195 ioctl dump auto

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
