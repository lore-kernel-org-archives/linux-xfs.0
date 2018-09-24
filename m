Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41493 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729730AbeIXVU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:20:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEZEu134131
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:17:49 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq28h8j53-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:17:48 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:17:47 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 01/20] Fix xfs/009 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:23 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-2-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

xfs_alloc_file_space() rounds up allocation requests by the filesystem
block size. Hence this commit changes the test to work with block size
units rather than with a multiple of 4096 bytes.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/009     | 92 ++++++++++++++++++++++++++++++++++++++++++++++---------
 tests/xfs/009.out | 66 +++++++++++++++++++--------------------
 2 files changed, 110 insertions(+), 48 deletions(-)

diff --git a/tests/xfs/009 b/tests/xfs/009
index 68f6379..7f95156 100755
--- a/tests/xfs/009
+++ b/tests/xfs/009
@@ -14,9 +14,6 @@ here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
-# This isn't really related to fs block size, it's just what
-# alloc uses for the "block" unit in it's input parameters...
-bsize=4096
 
 _cleanup()
 {
@@ -24,13 +21,6 @@ _cleanup()
     _scratch_unmount
 }
 
-_block_filter()
-{
-   sed \
-	-e 's/[0-9][0-9]*\.\.[0-9][0-9]*/BLOCKRANGE/g' \
-	-e "s/blocksize $bsize/blocksize BSIZE/g"
-}
-
 _init()
 {
     echo "*** mkfs"
@@ -49,11 +39,6 @@ _init()
     fi
 }
 
-_filesize()
-{
-    ls -l $1 | $AWK_PROG '{print "filesize = " $5}'
-}
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -64,9 +49,86 @@ _supported_os Linux
 
 _require_scratch
 
+_filesize()
+{
+    ls -l $1 | $AWK_PROG -v bsize="$bsize" '{print "filesize = " $5 / bsize}'
+}
+
+_block_filter()
+{
+	$AWK_PROG -v bsize="$bsize" '
+	/blocksize/ {
+		printf("    blocksize BSIZE\n")
+
+		next
+	}
+
+	/CMD/ {
+		split($3, off, "=")
+		offset = strtonum(off[2])
+		if (offset != -1)
+			offset = offset / bsize
+
+		split($4, len, "=")
+		nr_blocks = strtonum(len[2])
+		if (nr_blocks != -1)
+			nr_blocks = nr_blocks / bsize
+
+		printf("    %s %s off=%s, len=%d\n", $1, $2, offset, nr_blocks)
+
+		next
+	}
+
+	/MAP/ {
+		split($2, off, "=")
+		offset = strtonum(off[2])
+		if (offset != -1)
+			offset = offset / bsize
+
+		split($3, len, "=")
+
+		nr_blocks = strtonum(len[2])
+
+		if (nr_blocks != -1)
+			nr_blocks = nr_blocks / bsize
+
+		printf("    %s off=%s, len=%d %s\n", $1, offset, nr_blocks, $4)
+
+		next
+	}
+
+	/TRUNCATE/ {
+		split($2, off, "=")
+		offset = strtonum(off[2]) / bsize
+
+		printf("    %s off=%s\n", $1, offset)
+
+		next
+	}
+
+	/\[[0-9]+,[0-9]+\]:/ {
+		printf("        %s BLOCKRANGE\n", $1)
+
+		next
+	}
+
+	{
+		print
+
+		next
+	}
+	'
+}
+
 _init
 out=$SCRATCH_MNT/$$.tmp
 
+# This isn't really related to fs block size, it's just what
+# alloc uses for the "block" unit in it's input parameters...
+# However, xfs_alloc_file_space() rounds up allocation
+# request by the filesystem's block size.
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
 # since we're using a clean FS here, we make some assumptions
 # about availability of contiguous blocks
 
diff --git a/tests/xfs/009.out b/tests/xfs/009.out
index 7132aca..02b5d82 100644
--- a/tests/xfs/009.out
+++ b/tests/xfs/009.out
@@ -3,8 +3,8 @@ QA output created by 009
 *** mount
 *** test 1 - reservations cleared on O_TRUNC
     blocksize BSIZE
-    CMD resvsp, off=0, len=4096000
-    MAP off=0, len=4096000 [0,1000]
+    CMD resvsp, off=0, len=1000
+    MAP off=0, len=1000 [0,1000]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
     MAP off=0, len=-1 [0-]
@@ -17,53 +17,53 @@ filesize = 0
 filesize = 0
 *** test 2 - reserve & filesize
     blocksize BSIZE
-    CMD resvsp, off=0, len=4096000
-    MAP off=0, len=4096000 [0,1000]
+    CMD resvsp, off=0, len=1000
+    MAP off=0, len=1000 [0,1000]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
 filesize = 0
 *** test 3 - alloc & filesize
     blocksize BSIZE
-    CMD allocsp, off=4096000, len=-1
-    MAP off=4096000, len=-1 [1000-]
+    CMD allocsp, off=1000, len=-1
+    MAP off=1000, len=-1 [1000-]
         [ofs,count]: start..end
-filesize = 4096000
+filesize = 1000
 *** test 4 - allocations cleared on O_TRUNC
     blocksize BSIZE
-    CMD allocsp, off=4096000, len=-1
-    MAP off=4096000, len=-1 [1000-]
+    CMD allocsp, off=1000, len=-1
+    MAP off=1000, len=-1 [1000-]
         [ofs,count]: start..end
-filesize = 4096000
+filesize = 1000
     blocksize BSIZE
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
 filesize = 0
 *** test 5 - reserve / unreserve
     blocksize BSIZE
-    CMD resvsp, off=0, len=409600
-    MAP off=0, len=409600 [0,100]
+    CMD resvsp, off=0, len=100
+    MAP off=0, len=100 [0,100]
         [ofs,count]: start..end
         [0,100]: BLOCKRANGE
-    CMD unresvsp, off=409600, len=2048000
-    MAP off=409600, len=2048000 [100,500]
+    CMD unresvsp, off=100, len=500
+    MAP off=100, len=500 [100,500]
         [ofs,count]: start..end
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,100]: BLOCKRANGE
-    CMD unresvsp, off=3686400, len=819200
-    MAP off=3686400, len=819200 [900,200]
+    CMD unresvsp, off=900, len=200
+    MAP off=900, len=200 [900,200]
         [ofs,count]: start..end
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,100]: BLOCKRANGE
 *** test 6 - reserve adjacent
     blocksize BSIZE
-    CMD resvsp, off=0, len=409600
-    MAP off=0, len=409600 [0,100]
+    CMD resvsp, off=0, len=100
+    MAP off=0, len=100 [0,100]
         [ofs,count]: start..end
         [0,100]: BLOCKRANGE
-    CMD resvsp, off=409600, len=409600
-    MAP off=409600, len=409600 [100,100]
+    CMD resvsp, off=100, len=100
+    MAP off=100, len=100 [100,100]
         [ofs,count]: start..end
         [100,100]: BLOCKRANGE
     MAP off=0, len=-1 [0-]
@@ -71,44 +71,44 @@ filesize = 0
         [0,200]: BLOCKRANGE
 *** test 7 - alloc
     blocksize BSIZE
-    CMD allocsp, off=4096000, len=-1
-    MAP off=4096000, len=-1 [1000-]
+    CMD allocsp, off=1000, len=-1
+    MAP off=1000, len=-1 [1000-]
         [ofs,count]: start..end
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
-    CMD allocsp, off=8192000, len=-1
-    MAP off=8192000, len=-1 [2000-]
+    CMD allocsp, off=2000, len=-1
+    MAP off=2000, len=-1 [2000-]
         [ofs,count]: start..end
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,2000]: BLOCKRANGE
-filesize = 8192000
+filesize = 2000
 *** test 8 - alloc & truncate
     blocksize BSIZE
-    CMD allocsp, off=4096000, len=-1
-    MAP off=4096000, len=-1 [1000-]
+    CMD allocsp, off=1000, len=-1
+    MAP off=1000, len=-1 [1000-]
         [ofs,count]: start..end
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
-    TRUNCATE off=2048000
+    TRUNCATE off=500
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,500]: BLOCKRANGE
-filesize = 2048000
+filesize = 500
 *** test 9 - reserve & truncate
     blocksize BSIZE
-    CMD resvsp, off=0, len=4096000
-    MAP off=0, len=4096000 [0,1000]
+    CMD resvsp, off=0, len=1000
+    MAP off=0, len=1000 [0,1000]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
-    TRUNCATE off=2048000
+    TRUNCATE off=500
     MAP off=0, len=-1 [0-]
         [ofs,count]: start..end
         [0,1000]: BLOCKRANGE
-filesize = 2048000
+filesize = 500
 *** unmount
-- 
2.9.5
