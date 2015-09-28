Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45ABB7F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 17:38:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38CD1304053
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 15:38:05 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ojS25SlE9fQhF8aU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Sep 2015 15:38:03 -0700 (PDT)
Date: Mon, 28 Sep 2015 15:38:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix merge errors in fuzzer tests
Message-ID: <20150928223801.GH10391@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

Fix some merge errors when the fuzzer tests went in.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/085.out |    2 --
 tests/xfs/098.out |    1 -
 tests/xfs/099.out |    2 +-
 tests/xfs/100.out |    2 +-
 tests/xfs/101.out |    2 +-
 tests/xfs/102.out |    2 +-
 6 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/tests/xfs/085.out b/tests/xfs/085.out
index 6303081..ff3dccd 100644
--- a/tests/xfs/085.out
+++ b/tests/xfs/085.out
@@ -5,8 +5,6 @@ QA output created by 085
 + check fs
 + corrupt image
 + mount image
-+ modify files
-broken: 1
 + repair fs
 + mount image (2)
 + chattr -R -i
diff --git a/tests/xfs/098.out b/tests/xfs/098.out
index 84a2b4d..ef0554d 100644
--- a/tests/xfs/098.out
+++ b/tests/xfs/098.out
@@ -5,7 +5,6 @@ QA output created by 098
 + check fs
 + corrupt image
 + mount image
-broken: 1
 + repair fs
 + mount image (2)
 + chattr -R -i
diff --git a/tests/xfs/099.out b/tests/xfs/099.out
index 4426859..773200b 100644
--- a/tests/xfs/099.out
+++ b/tests/xfs/099.out
@@ -1,4 +1,4 @@
-QA output created by 016
+QA output created by 099
 + create scratch fs
 + mount fs image
 + make some files
diff --git a/tests/xfs/100.out b/tests/xfs/100.out
index 98d8dbc..97dba7c 100644
--- a/tests/xfs/100.out
+++ b/tests/xfs/100.out
@@ -1,4 +1,4 @@
-QA output created by 017
+QA output created by 100
 + create scratch fs
 + mount fs image
 + make some files
diff --git a/tests/xfs/101.out b/tests/xfs/101.out
index 49430f7..22ca620 100644
--- a/tests/xfs/101.out
+++ b/tests/xfs/101.out
@@ -1,4 +1,4 @@
-QA output created by 018
+QA output created by 101
 + create scratch fs
 + mount fs image
 + make some files
diff --git a/tests/xfs/102.out b/tests/xfs/102.out
index 58f493c..d8a8fa1 100644
--- a/tests/xfs/102.out
+++ b/tests/xfs/102.out
@@ -1,4 +1,4 @@
-QA output created by 019
+QA output created by 102
 + create scratch fs
 + mount fs image
 + make some files

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
