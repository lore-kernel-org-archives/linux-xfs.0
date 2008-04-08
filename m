Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 18:38:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m381c0MR008259
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 18:38:03 -0700
Date: Tue, 8 Apr 2008 11:38:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa - 008 is unreliable on 64k page size
Message-ID: <20080408013833.GN108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Test 008 is unreliable on 64k page size. The I/O size is large
enough that the probability of extent merging results in intermittent
failures due to fewer extents that the +/- 10% tolerance allows.

Fix by making the files larger.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/008     |   10 +++++-----
 xfstests/008.out |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: xfs-cmds/xfstests/008
===================================================================
--- xfs-cmds.orig/xfstests/008	2006-11-14 19:57:39.000000000 +1100
+++ xfs-cmds/xfstests/008	2008-04-08 10:18:10.641024202 +1000
@@ -79,13 +79,13 @@ _setup_testdir
 
 rm -f $here/$seq.out.full
 
-_do_test 1 50 "-l 5000000 -c 50 -b $pgsize"
-_do_test 2 100 "-l 10000000 -c 100 -b $pgsize"
-_do_test 3 100 "-l 10000000 -c 100 -b 512"   # test partial pages
+_do_test 1 50 "-l 50000000 -c 50 -b $pgsize"
+_do_test 2 100 "-l 100000000 -c 100 -b $pgsize"
+_do_test 3 100 "-l 100000000 -c 100 -b 512"   # test partial pages
 
 # rinse, lather, repeat for direct IO
-_do_test 4 50 "-d -l 5000000 -c 50 -b $pgsize"
-_do_test 5 100 "-d -l 10000000 -c 100 -b $pgsize"
+_do_test 4 50 "-d -l 50000000 -c 50 -b $pgsize"
+_do_test 5 100 "-d -l 100000000 -c 100 -b $pgsize"
 # note: direct IO requires page aligned IO
 
 # todo: realtime.
Index: xfs-cmds/xfstests/008.out
===================================================================
--- xfs-cmds.orig/xfstests/008.out	2006-11-14 19:57:39.000000000 +1100
+++ xfs-cmds/xfstests/008.out	2008-04-08 11:25:52.584176769 +1000
@@ -1,21 +1,21 @@
 QA output created by 008
 
-randholes.1 : -l 5000000 -c 50 -b PGSIZE
+randholes.1 : -l 50000000 -c 50 -b PGSIZE
 ------------------------------------------
 holes is in range
 
-randholes.2 : -l 10000000 -c 100 -b PGSIZE
+randholes.2 : -l 100000000 -c 100 -b PGSIZE
 ------------------------------------------
 holes is in range
 
-randholes.3 : -l 10000000 -c 100 -b 512
+randholes.3 : -l 100000000 -c 100 -b 512
 ------------------------------------------
 holes is in range
 
-randholes.4 : -d -l 5000000 -c 50 -b PGSIZE
+randholes.4 : -d -l 50000000 -c 50 -b PGSIZE
 ------------------------------------------
 holes is in range
 
-randholes.5 : -d -l 10000000 -c 100 -b PGSIZE
+randholes.5 : -d -l 100000000 -c 100 -b PGSIZE
 ------------------------------------------
 holes is in range
