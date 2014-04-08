Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C6297FF5
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 23:52:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9DA1AC016
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 21:52:55 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id QsA4UxRw1uKA4E2X for
	<xfs@oss.sgi.com>; Mon, 07 Apr 2014 21:52:49 -0700 (PDT)
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] xfstests: fix wallclock possibly wrapped problem
Date: Tue, 8 Apr 2014 12:52:18 +0800
Message-ID: <1396932738-13638-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
To: xfs@oss.sgi.com
Cc: yuanhan.liu@linux.intel.com, fengguang.wu@intel.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>

If a test cross two days, the time may be negative, let's use
the UTC seconds instead, for example:

2014-04-03 23:43:42 ./check generic/074 generic/075 generic/112 generic/113 generic/132 generic/133 generic/231
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 vpx-2 3.14.0-00001-g462fa88
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdd
MOUNT_OPTIONS -- /dev/vdd /fs/scratch

generic/074	 100s
generic/075	 220s
generic/112	 226s
generic/113	 188s
generic/132	 18s
generic/133	 37s
generic/231	 -85401s
Ran: generic/074 generic/075 generic/112 generic/113 generic/132 generic/133 generic/231
Passed all 7 tests

Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 check | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check b/check
index 8f1a6e1..a7e33ea 100755
--- a/check
+++ b/check
@@ -146,7 +146,7 @@ trim_test_list()
 
 _wallclock()
 {
-    date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
+    date "+%s"
 }
 
 _timestamp()
-- 
1.9.1.475.ge4eef26

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
