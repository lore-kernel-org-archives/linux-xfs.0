Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E31F7CA7
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:14:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D1EB8F8039
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:05 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id PjsB7OgT22nIdBtv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:03 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfstests: change to relative margins for reflinks tests
Date: Thu, 28 Jan 2016 18:13:56 +0100
Message-Id: <1454001236-2600-5-git-send-email-hch@lst.de>
In-Reply-To: <1454001236-2600-1-git-send-email-hch@lst.de>
References: <1454001236-2600-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com, xfs@oss.sgi.com

NFS uses 32K blocks and thus the numbers used for sanity checking
various reflink operations are way off.  Change to relative margings
and increase them a bit to make NFS happy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/150 | 2 +-
 tests/generic/151 | 2 +-
 tests/generic/152 | 2 +-
 tests/generic/153 | 2 +-
 tests/generic/154 | 2 +-
 tests/generic/155 | 2 +-
 tests/generic/156 | 2 +-
 tests/generic/157 | 2 +-
 tests/generic/158 | 2 +-
 tests/generic/159 | 2 +-
 tests/generic/160 | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tests/generic/150 b/tests/generic/150
index f3a6311..90ac46b 100755
--- a/tests/generic/150
+++ b/tests/generic/150
@@ -57,7 +57,7 @@ mkdir "$testdir"
 echo "Create the original file blocks"
 blksz="$(stat -f $testdir -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 sz=$((blksz * blks))
 nr=7
 _pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
diff --git a/tests/generic/151 b/tests/generic/151
index 286b9ec..c67a12c 100755
--- a/tests/generic/151
+++ b/tests/generic/151
@@ -61,7 +61,7 @@ mkdir "$testdir"
 echo "Create the original file blocks"
 blksz="$(stat -f "$testdir" -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f "$testdir" -c '%f')
 nr=7
diff --git a/tests/generic/152 b/tests/generic/152
index 506a754..cdb2bf9 100755
--- a/tests/generic/152
+++ b/tests/generic/152
@@ -62,7 +62,7 @@ mkdir "$testdir"
 echo "Create the original file blocks"
 blksz="$(stat -f "$testdir" -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f "$testdir" -c '%f')
 nr=4
diff --git a/tests/generic/153 b/tests/generic/153
index 011879e..b2f4022 100755
--- a/tests/generic/153
+++ b/tests/generic/153
@@ -62,7 +62,7 @@ mkdir "$testdir"
 echo "Create the original file blocks"
 blksz="$(stat -f "$testdir" -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f "$testdir" -c '%f')
 nr=4
diff --git a/tests/generic/154 b/tests/generic/154
index 474c578..579f78b 100755
--- a/tests/generic/154
+++ b/tests/generic/154
@@ -61,7 +61,7 @@ mkdir "$testdir"
 echo "Create the original file blocks"
 blksz="$(stat -f "$testdir" -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 free_blocks0=$(stat -f "$testdir" -c '%f')
 nr=4
 sz=$((blks * blksz))
diff --git a/tests/generic/155 b/tests/generic/155
index 611cf1a..56d2912 100755
--- a/tests/generic/155
+++ b/tests/generic/155
@@ -65,7 +65,7 @@ mkdir $testdir
 echo "Create the original file blocks"
 blksz="$(stat -f "$testdir" -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f "$testdir" -c '%f')
 nr=4
diff --git a/tests/generic/156 b/tests/generic/156
index 7194e87..9fea988 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -73,7 +73,7 @@ mkdir "$testdir"
 echo "Create the original file blocks"
 blksz="$(stat -f "$testdir" -c '%S')"
 blks=2000
-margin=100
+margin='15%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f "$testdir" -c '%f')
 nr=4
diff --git a/tests/generic/157 b/tests/generic/157
index a5b84fc..0150866 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -63,7 +63,7 @@ mkdir "$testdir2"
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
 blks=1000
-margin=50
+margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
diff --git a/tests/generic/158 b/tests/generic/158
index 58b7090..807c247 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -63,7 +63,7 @@ mkdir "$testdir2"
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
 blks=1000
-margin=50
+margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
diff --git a/tests/generic/159 b/tests/generic/159
index 14baf64..88a0c7e 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -56,7 +56,7 @@ mkdir "$testdir1"
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
 blks=1000
-margin=50
+margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
diff --git a/tests/generic/160 b/tests/generic/160
index acd2c4e..83325d5 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -56,7 +56,7 @@ mkdir "$testdir1"
 echo "Create the original files"
 blksz="$(stat -f $testdir1 -c '%S')"
 blks=1000
-margin=50
+margin='7%'
 sz=$((blksz * blks))
 free_blocks0=$(stat -f $testdir1 -c '%f')
 nr=4
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
