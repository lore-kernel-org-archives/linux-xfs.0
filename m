Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8CED17F7D
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 04:15:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 767D88F8035
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 02:15:28 -0700 (PDT)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	FgnYRpLOOsoeKJ9O (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 02:15:27 -0700 (PDT)
Received: by mail-pd0-f177.google.com with SMTP id y14so107256pdi.36
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 02:15:26 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests 299-305: remove fio config files after finished test
Date: Tue, 19 Mar 2013 17:30:50 +0800
Message-Id: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

After finished test, temporarily fio config file should be removed.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 299 | 2 +-
 300 | 2 +-
 301 | 2 +-
 302 | 2 +-
 303 | 2 +-
 304 | 2 +-
 305 | 1 +
 7 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/299 b/299
index 4305ead..9d0c32f 100644
--- a/299
+++ b/299
@@ -32,7 +32,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/300 b/300
index 73c9ea7..413f9eb 100644
--- a/300
+++ b/300
@@ -32,7 +32,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/301 b/301
index fe2e59f..6ac8ecf 100644
--- a/301
+++ b/301
@@ -30,7 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/302 b/302
index e3dceb8..62398c9 100644
--- a/302
+++ b/302
@@ -31,7 +31,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/303 b/303
index 4141442..d198ebb 100644
--- a/303
+++ b/303
@@ -31,7 +31,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/304 b/304
index 5c414bd..fb94fe6 100644
--- a/304
+++ b/304
@@ -32,7 +32,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
diff --git a/305 b/305
index 6393461..9d89321 100644
--- a/305
+++ b/305
@@ -80,6 +80,7 @@ _cleanup()
 {
     poweron_scratch_dev
     disallow_fail_make_request
+    rm -f $tmp-$seq.fio
 }
 trap "_cleanup; exit \$status" 1 2 3 15
 
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
