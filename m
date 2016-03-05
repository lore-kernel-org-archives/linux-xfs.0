Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E15627CA3
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:37:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90F81304043
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:37:52 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6sJsGXyZfZLsldOM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:37:51 -0800 (PST)
Subject: [PATCH 04/12] xfs/23[3-6]: don't source common/xfs, it doesn't exist
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:37:43 -0800
Message-ID: <20160305003743.28738.8245.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Don't source common/xfs, since it doesn't (yet) exist.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/233 |    1 -
 tests/xfs/234 |    1 -
 tests/xfs/235 |    1 -
 tests/xfs/236 |    1 -
 4 files changed, 4 deletions(-)


diff --git a/tests/xfs/233 b/tests/xfs/233
index f10af2b..8fcf766 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -39,7 +39,6 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
diff --git a/tests/xfs/234 b/tests/xfs/234
index 649cb7e..2bbf295 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -41,7 +41,6 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
diff --git a/tests/xfs/235 b/tests/xfs/235
index 5af72a6..370131b 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -41,7 +41,6 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 . ./common/attr
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux
diff --git a/tests/xfs/236 b/tests/xfs/236
index 99e9a75..c7b3a19 100755
--- a/tests/xfs/236
+++ b/tests/xfs/236
@@ -41,7 +41,6 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
-. ./common/xfs
 
 # real QA test starts here
 _supported_os Linux

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
