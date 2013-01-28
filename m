Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EB597F52
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 01:20:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 222A7AC001
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:27 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id RB6Udt8wTzUdq7db
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:26 -0800 (PST)
Received: by mail-pa0-f43.google.com with SMTP id fb10so1351157pad.16
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:26 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/4] xfstests: check unwritten extent preallocation in 255
Date: Mon, 28 Jan 2013 15:32:48 +0800
Message-Id: <1359358371-21411-2-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
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
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

255 misses call _require_xfs_io_falloc to check whether a filesystem
supports fallocate(2) to preallocate unwritten extents or not.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
---
 255 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/255 b/255
index 0083963..700c3c0 100755
--- a/255
+++ b/255
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test No. 255
 #
-# Test Generic fallocate hole punching
+# Test Generic fallocate hole punching w/ unwritten extent
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2010 Red Hat.  All Rights Reserved.
@@ -47,6 +47,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs generic 
 _supported_os Linux
 
+_require_xfs_io_falloc
 _require_xfs_io_falloc_punch
 _require_xfs_io_fiemap
 
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
