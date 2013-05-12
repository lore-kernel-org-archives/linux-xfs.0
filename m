Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 543D17F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 03:19:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43B66304051
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 01:19:33 -0700 (PDT)
Received: from mail-pb0-f52.google.com (mail-pb0-f52.google.com
	[209.85.160.52]) by cuda.sgi.com with ESMTP id a8BAkZWC2ykAt7XX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 May 2013 01:19:32 -0700 (PDT)
Received: by mail-pb0-f52.google.com with SMTP id xa7so3720588pbc.11
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 01:19:31 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests: change file mode
Date: Sun, 12 May 2013 16:37:06 +0800
Message-Id: <1368347826-32152-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Zheng Liu <wenqing.lz@taobao.com>

Now in tests/ there are some test cases whose mode is 0644.  But they
should be 0755.  So fix it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Dave Chinner <david@fromorbit.com>
---
 0 files changed
 mode change 100644 => 100755 tests/btrfs/284
 mode change 100644 => 100755 tests/btrfs/307
 mode change 100644 => 100755 tests/generic/285
 mode change 100644 => 100755 tests/generic/286
 mode change 100644 => 100755 tests/generic/288
 mode change 100644 => 100755 tests/generic/294
 mode change 100644 => 100755 tests/generic/299
 mode change 100644 => 100755 tests/generic/300
 mode change 100644 => 100755 tests/generic/306
 mode change 100644 => 100755 tests/generic/307
 mode change 100644 => 100755 tests/generic/308
 mode change 100644 => 100755 tests/generic/309
 mode change 100644 => 100755 tests/generic/311
 mode change 100644 => 100755 tests/shared/298
 mode change 100644 => 100755 tests/shared/305
 mode change 100644 => 100755 tests/xfs/287
 mode change 100644 => 100755 tests/xfs/290
 mode change 100644 => 100755 tests/xfs/292
 mode change 100644 => 100755 tests/xfs/293
 mode change 100644 => 100755 tests/xfs/295
 mode change 100644 => 100755 tests/xfs/296
 mode change 100644 => 100755 tests/xfs/297

diff --git a/tests/btrfs/284 b/tests/btrfs/284
old mode 100644
new mode 100755
diff --git a/tests/btrfs/307 b/tests/btrfs/307
old mode 100644
new mode 100755
diff --git a/tests/generic/285 b/tests/generic/285
old mode 100644
new mode 100755
diff --git a/tests/generic/286 b/tests/generic/286
old mode 100644
new mode 100755
diff --git a/tests/generic/288 b/tests/generic/288
old mode 100644
new mode 100755
diff --git a/tests/generic/294 b/tests/generic/294
old mode 100644
new mode 100755
diff --git a/tests/generic/299 b/tests/generic/299
old mode 100644
new mode 100755
diff --git a/tests/generic/300 b/tests/generic/300
old mode 100644
new mode 100755
diff --git a/tests/generic/306 b/tests/generic/306
old mode 100644
new mode 100755
diff --git a/tests/generic/307 b/tests/generic/307
old mode 100644
new mode 100755
diff --git a/tests/generic/308 b/tests/generic/308
old mode 100644
new mode 100755
diff --git a/tests/generic/309 b/tests/generic/309
old mode 100644
new mode 100755
diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
diff --git a/tests/shared/298 b/tests/shared/298
old mode 100644
new mode 100755
diff --git a/tests/shared/305 b/tests/shared/305
old mode 100644
new mode 100755
diff --git a/tests/xfs/287 b/tests/xfs/287
old mode 100644
new mode 100755
diff --git a/tests/xfs/290 b/tests/xfs/290
old mode 100644
new mode 100755
diff --git a/tests/xfs/292 b/tests/xfs/292
old mode 100644
new mode 100755
diff --git a/tests/xfs/293 b/tests/xfs/293
old mode 100644
new mode 100755
diff --git a/tests/xfs/295 b/tests/xfs/295
old mode 100644
new mode 100755
diff --git a/tests/xfs/296 b/tests/xfs/296
old mode 100644
new mode 100755
diff --git a/tests/xfs/297 b/tests/xfs/297
old mode 100644
new mode 100755
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
