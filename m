Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 719307CA9
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:39:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 637588F804B
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:33 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id C5XlN17JgYkCdLlw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:31 -0800 (PST)
Subject: [PATCH 01/32] generic/182: this is a dedupe test, check for dedupe
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:39:23 -0800
Message-ID: <20160211233923.2202.16359.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Since this test examines dedupe behavior, the documentation should
say 'dedupe', not 'reflink'.  Furthermore, the feature checks must
look for working dedupe functionality, not reflink functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: add the test for dedupe support]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/182 |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/tests/generic/182 b/tests/generic/182
index bf5cd38..ef10af8 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 182
 #
-# Test the convention that reflink with length == 0 means "to the end of fileA"
+# Test the convention that dedupe with length == 0 means "to the end of fileA"
 #   - Create a file.
-#   - Try to reflink "zero" bytes (which means reflink to EOF).
-#   - Check that the reflink happened.
+#   - Try to dedupe "zero" bytes (which means dedupe to EOF).
+#   - Check that the dedupe happened.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
@@ -45,8 +45,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_os Linux
-_require_test_reflink
-_require_cp_reflink
+_require_test_dedupe
 
 rm -f "$seqres.full"
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
