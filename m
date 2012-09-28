Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S3WR2P170491 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 22:32:27 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oonPDAMZuRrxtZQi for
	<xfs@oss.sgi.com>; Thu, 27 Sep 2012 20:33:47 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8S3XkW6024234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:33:46 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8S3XjDF011359
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:33:46 -0400
Message-ID: <50651A99.1070307@redhat.com>
Date: Thu, 27 Sep 2012 22:33:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 068: Add mmap load
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
To: xfs-oss <xfs@oss.sgi.com>

Test 068 is the go-to test for freeze deadlock coverage;
unfortunately it only uses fsstress, which doesn't do any mmap
IO.

Using the existing fstest binary gets us a cheap mmap exerciser
as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I think it's fair to modify this test vs. making a new one -
it's never passed yet, and will only start passing in kernel 3.6,
so it shouldn't cause new test regressions to add mmap ops.

And I can verify that this finds mmap bugs; I had a backport
which messed up ext4's freeze vs. mmap handling, and this exposes
it.  :)


diff --git a/068 b/068
index 617420c..a0bf425 100755
--- a/068
+++ b/068
@@ -90,6 +90,21 @@ touch $tmp.running
     rmdir $STRESS_DIR
 } &
 
+# start fstest -m loop in a background block; this gets us mmap coverage
+{
+    FSTEST_DIR="$SCRATCH_MNT/fstest_test_dir"
+    mkdir "$FSTEST_DIR"
+
+    procs=2
+    while [ -f "$tmp.running" ]
+      do
+      src/fstest -m -p $FSTEST_DIR  -n $procs -f 4 > /dev/null 2>&1
+    done
+
+    rm -rf $FSTEST_DIR/*
+    rmdir $FSTEST_DIR
+} &
+
 i=0
 let ITERATIONS=$ITERATIONS-1
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
