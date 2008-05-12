Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 04:01:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4CB10If027379
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 04:01:02 -0700
Date: Mon, 12 May 2008 21:01:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa 008 takes too long on UML...
Message-ID: <20080512110134.GH155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

With the recent change for reliability with 64k page size
made to test 008,the file sizes got much larger. It appears
that randholes actually reads the entire file, so this has
slowed the test down by a factor of ten (all file sizes
were increased by 10x). This means the test is now taking
about 18 minutes to run on a UML session, and all the time
is spent reading the files.

Instead, scale the file size based on the page size. We know
how many holes we are trying to produce and the I/O size
being used to produce them, so the size of the files can be
finely tuned. Assuming a decent random distribution, if the
number of blocks in the file is 4x the page size and the
I/O size is page sized, this means that every I/O should
generate a new hole and we'll only get a small amount of
adjacent extents. This has passed over 10 times on ia64
w/ 64k page and another 15 times on UML with 4k page.

UML runtime is down from ~1000s to 5s, ia64 runtime is down from
~30s to 7s.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 xfstests/008     |   13 +++++++------
 xfstests/008.out |   10 +++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

Index: xfs-cmds/xfstests/008
===================================================================
--- xfs-cmds.orig/xfstests/008	2008-04-28 15:57:02.000000000 +1000
+++ xfs-cmds/xfstests/008	2008-05-12 20:43:11.946325031 +1000
@@ -28,7 +28,8 @@ _cleanup()
 
 _filter()
 {
-    sed -e "s/-b $pgsize/-b PGSIZE/g"
+    sed -e "s/-b $pgsize/-b PGSIZE/g" \
+	-e "s/-l .* -c/-l FSIZE -c/g"
 }
 
 # get standard environment, filters and checks
@@ -79,13 +80,13 @@ _setup_testdir
 
 rm -f $here/$seq.out.full
 
-_do_test 1 50 "-l 50000000 -c 50 -b $pgsize"
-_do_test 2 100 "-l 100000000 -c 100 -b $pgsize"
-_do_test 3 100 "-l 100000000 -c 100 -b 512"   # test partial pages
+_do_test 1 50 "-l `expr 200 \* $pgsize` -c 50 -b $pgsize"
+_do_test 2 100 "-l `expr 400 \* $pgsize` -c 100 -b $pgsize"
+_do_test 3 100 "-l `expr 400 \* $pgsize` -c 100 -b 512"   # test partial pages
 
 # rinse, lather, repeat for direct IO
-_do_test 4 50 "-d -l 50000000 -c 50 -b $pgsize"
-_do_test 5 100 "-d -l 100000000 -c 100 -b $pgsize"
+_do_test 4 50 "-d -l `expr 200 \* $pgsize` -c 50 -b $pgsize"
+_do_test 5 100 "-d -l `expr 400 \* $pgsize` -c 100 -b $pgsize"
 # note: direct IO requires page aligned IO
 
 # todo: realtime.
Index: xfs-cmds/xfstests/008.out
===================================================================
--- xfs-cmds.orig/xfstests/008.out	2008-04-28 15:57:02.000000000 +1000
+++ xfs-cmds/xfstests/008.out	2008-05-12 20:41:12.053827580 +1000
@@ -1,21 +1,21 @@
 QA output created by 008
 
-randholes.1 : -l 50000000 -c 50 -b PGSIZE
+randholes.1 : -l FSIZE -c 50 -b PGSIZE
 ------------------------------------------
 holes is in range
 
-randholes.2 : -l 100000000 -c 100 -b PGSIZE
+randholes.2 : -l FSIZE -c 100 -b PGSIZE
 ------------------------------------------
 holes is in range
 
-randholes.3 : -l 100000000 -c 100 -b 512
+randholes.3 : -l FSIZE -c 100 -b 512
 ------------------------------------------
 holes is in range
 
-randholes.4 : -d -l 50000000 -c 50 -b PGSIZE
+randholes.4 : -d -l FSIZE -c 50 -b PGSIZE
 ------------------------------------------
 holes is in range
 
-randholes.5 : -d -l 100000000 -c 100 -b PGSIZE
+randholes.5 : -d -l FSIZE -c 100 -b PGSIZE
 ------------------------------------------
 holes is in range
