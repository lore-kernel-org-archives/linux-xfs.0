Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B922B7F37
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 01:10:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A72A7304062
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 23:10:25 -0700 (PDT)
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143]) by
	cuda.sgi.com with ESMTP id t0Y7B4A6JjEvnzXe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Aug 2013 23:10:21 -0700 (PDT)
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Thu, 8 Aug 2013 16:00:16 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 01DE03578053
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:10:17 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r785sYXh29622522
	for <xfs@oss.sgi.com>; Thu, 8 Aug 2013 15:54:35 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r786AGr9016825 for <xfs@oss.sgi.com>; Thu, 8 Aug 2013 16:10:16 +1000
From: chandan <chandan@linux.vnet.ibm.com>
Subject: [PATCH] _test_generic_punch: Extend $testfile's size to work with 64k
	block.
Date: Thu, 08 Aug 2013 11:40:04 +0530
Message-ID: <3326777.u9YeDIQiYF@localhost.localdomain>
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Cc: sekharan@linux.vnet.ibm.com

>From cf6e1fc3a8d7806a97055b5f483cf50f58c8294f Mon Sep 17 00:00:00 2001
From: chandan <chandan@linux.vnet.ibm.com>
Date: Thu, 8 Aug 2013 11:33:10 +0530
Subject: [PATCH] _test_generic_punch: Extend $testfile's size to work with 64k
 block.

The current script does not work with 64k block size. This patch fixes it
by creating a larger $testfile.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 common/punch          | 119 +++++++------
 tests/generic/255.out | 476 +++++++++++++++++++++++++-------------------------
 tests/xfs/242.out     | 118 ++++++-------
 tests/xfs/252.out     | 476 +++++++++++++++++++++++++-------------------------
 4 files changed, 594 insertions(+), 595 deletions(-)

diff --git a/common/punch b/common/punch
index d8f73d0..e6f0b2a 100644
--- a/common/punch
+++ b/common/punch
@@ -316,8 +316,8 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -326,9 +326,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 0 320k" $sync_cmd \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -337,9 +337,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 0 320k" \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -348,9 +348,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 8k 8k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 128k 128k" $sync_cmd \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -359,9 +359,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 8k 8k" \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 128k 128k" \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -370,9 +370,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 8k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 0 128k" $sync_cmd \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -381,10 +381,10 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 8k" $sync_cmd \
-		-c "$alloc_cmd 8k 8k" \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 0 128k" $sync_cmd \
+		-c "$alloc_cmd 128k 128k" \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -393,9 +393,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 8k" \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 0 128k" \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -404,10 +404,10 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 8k" \
-		-c "pwrite 8k 8k" $sync_cmd \
-		-c "$zero_cmd 4k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 0 128k" \
+		-c "pwrite 128k 128k" $sync_cmd \
+		-c "$zero_cmd 64k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -416,9 +416,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 8k 4k" $sync_cmd \
-		-c "$zero_cmd 4k 12k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 128k 64k" $sync_cmd \
+		-c "$zero_cmd 64k 192k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -427,12 +427,12 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "pwrite 0 8k" \
-		-c "pwrite 12k 8k" $sync_cmd \
-		-c "$punch_cmd 8k 4k" \
-		-c "$zero_cmd 4k 12k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 0 320k" \
+		-c "pwrite 0 128k" \
+		-c "pwrite 192k 128k" $sync_cmd \
+		-c "$punch_cmd 128k 64k" \
+		-c "$zero_cmd 64k 192k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -441,10 +441,10 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "pwrite 8k 4k" $sync_cmd \
-		-c "$zero_cmd 4k 12k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 0 320k" \
+		-c "pwrite 128k 64k" $sync_cmd \
+		-c "$zero_cmd 64k 192k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -453,20 +453,20 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "$alloc_cmd 0 20k" \
-		-c "pwrite 0k 8k" $sync_cmd \
-		-c "pwrite 12k 8k" -c "fsync" \
-		-c "$zero_cmd 4k 12k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "$alloc_cmd 0 320k" \
+		-c "pwrite 0k 128k" $sync_cmd \
+		-c "pwrite 192k 128k" -c "fsync" \
+		-c "$zero_cmd 64k 192k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
 
 	echo "	14. data -> hole @ EOF"
 	rm -f $testfile
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 12k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 0 320k" $sync_cmd \
+		-c "$zero_cmd 192k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -475,9 +475,9 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 0k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 0 320k" $sync_cmd \
+		-c "$zero_cmd 0k 128k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 	_md5_checksum $testfile
@@ -489,12 +489,12 @@ _test_generic_punch()
 	else
 		cp $testfile $testfile.2
 	fi
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 8k 12k" -c "fsync" $testfile.2 \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 128k 192k" -c "fsync" $testfile.2 \
 		> /dev/null
-	$XFS_IO_PROG -f -c "truncate 20k" \
-		-c "pwrite 0 20k" $sync_cmd \
-		-c "$zero_cmd 0k 8k" \
+	$XFS_IO_PROG -f -c "truncate 320k" \
+		-c "pwrite 0 320k" $sync_cmd \
+		-c "$zero_cmd 0k 128k" \
 		-c "fadvise -d" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	diff $testfile $testfile.2
@@ -506,9 +506,8 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
-	$XFS_IO_PROG -f -c "truncate $block_size" \
-		-c "pwrite 0 $block_size" $sync_cmd \
+	$XFS_IO_PROG -f -c "truncate 64k" \
+		-c "pwrite 0 64k" $sync_cmd \
 		-c "$zero_cmd 128 128" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
diff --git a/tests/generic/255.out b/tests/generic/255.out
index 2ce882b..5aa1ce1 100644
--- a/tests/generic/255.out
+++ b/tests/generic/255.out
@@ -1,307 +1,307 @@
 QA output created by 255
 	1. into a hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: hole
+1: [384..511]: extent
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..383]: hole
+1: [384..511]: extent
+2: [512..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: extent
+1: [128..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: extent
+1: [128..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: extent
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: extent
+27b1998d7d1907fb55376ff286f3f506
 	1. into a hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: hole
+1: [384..511]: extent
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..383]: hole
+1: [384..511]: extent
+2: [512..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: extent
+1: [128..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: extent
+1: [128..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: extent
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: extent
+27b1998d7d1907fb55376ff286f3f506
 	1. into a hole
-0: [0..7]: extent
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+0: [0..127]: extent
+1: [128..639]: hole
+4c4016ef1838c07e9cf59da9c77d017f
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: extent
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: extent
+27b1998d7d1907fb55376ff286f3f506
 	1. into a hole
-0: [0..7]: extent
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+0: [0..127]: extent
+1: [128..639]: hole
+4c4016ef1838c07e9cf59da9c77d017f
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..39]: extent
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..639]: extent
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: extent
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: extent
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: extent
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: extent
+27b1998d7d1907fb55376ff286f3f506
diff --git a/tests/xfs/242.out b/tests/xfs/242.out
index 72026a3..11531d4 100644
--- a/tests/xfs/242.out
+++ b/tests/xfs/242.out
@@ -1,77 +1,77 @@
 QA output created by 242
 	1. into a hole
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: hole
+1: [128..383]: unwritten
+2: [384..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	2. into allocated space
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
+0: [0..639]: unwritten
+1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
-0: [0..7]: hole
-1: [8..23]: unwritten
-2: [24..31]: data
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..127]: hole
+1: [128..383]: unwritten
+2: [384..511]: data
+3: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..7]: hole
-1: [8..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: hole
+1: [128..511]: unwritten
+2: [512..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..23]: unwritten
-1: [24..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..383]: unwritten
+1: [384..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..23]: unwritten
-1: [24..31]: data
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: unwritten
+1: [384..511]: data
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
-0: [0..7]: hole
-1: [8..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: hole
+1: [128..511]: unwritten
+2: [512..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
+0: [0..639]: unwritten
+1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: unwritten
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: data
+1: [384..639]: unwritten
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: unwritten
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: unwritten
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: unwritten
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: data
+27b1998d7d1907fb55376ff286f3f506
diff --git a/tests/xfs/252.out b/tests/xfs/252.out
index 3caf9d6..ba37288 100644
--- a/tests/xfs/252.out
+++ b/tests/xfs/252.out
@@ -1,307 +1,307 @@
 QA output created by 252
 	1. into a hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	2. into allocated space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: unwritten
-1: [8..23]: hole
-2: [24..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: unwritten
+1: [128..383]: hole
+2: [384..639]: unwritten
+1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
-0: [0..23]: hole
-1: [24..31]: data
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: hole
+1: [384..511]: data
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..383]: hole
+1: [384..511]: unwritten
+2: [512..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
-0: [0..7]: data
-1: [8..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: data
+1: [128..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..31]: unwritten
-3: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..511]: unwritten
+3: [512..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..7]: unwritten
-1: [8..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: unwritten
+1: [128..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..7]: unwritten
-1: [8..23]: hole
-2: [24..31]: data
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..127]: unwritten
+1: [128..383]: hole
+2: [384..511]: data
+3: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: unwritten
-1: [8..31]: hole
-2: [32..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: unwritten
+1: [128..511]: hole
+2: [512..639]: unwritten
+1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: data
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: data
+27b1998d7d1907fb55376ff286f3f506
 	1. into a hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	2. into allocated space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: unwritten
-1: [8..23]: hole
-2: [24..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: unwritten
+1: [128..383]: hole
+2: [384..639]: unwritten
+1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
-0: [0..23]: hole
-1: [24..31]: data
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: hole
+1: [384..511]: data
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: unwritten
-2: [32..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..383]: hole
+1: [384..511]: unwritten
+2: [512..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
-0: [0..7]: data
-1: [8..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: data
+1: [128..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..31]: unwritten
-3: [32..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..511]: unwritten
+3: [512..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..7]: unwritten
-1: [8..39]: hole
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: unwritten
+1: [128..639]: hole
+1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..7]: unwritten
-1: [8..23]: hole
-2: [24..31]: data
-3: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..127]: unwritten
+1: [128..383]: hole
+2: [384..511]: data
+3: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
-daa100df6e6711906b61c9ab5aa16032
+1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: unwritten
-1: [8..31]: hole
-2: [32..39]: unwritten
-daa100df6e6711906b61c9ab5aa16032
+0: [0..127]: unwritten
+1: [128..511]: hole
+2: [512..639]: unwritten
+1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: data
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: data
+27b1998d7d1907fb55376ff286f3f506
 	1. into a hole
-0: [0..7]: data
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+0: [0..127]: data
+1: [128..639]: hole
+4c4016ef1838c07e9cf59da9c77d017f
 	2. into allocated space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: data
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: data
+27b1998d7d1907fb55376ff286f3f506
 	1. into a hole
-0: [0..7]: data
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+0: [0..127]: data
+1: [128..639]: hole
+4c4016ef1838c07e9cf59da9c77d017f
 	2. into allocated space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: hole
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	13. data -> unwritten -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: hole
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
 	14. data -> hole @ EOF
-0: [0..23]: data
-1: [24..39]: hole
-e1f024eedd27ea6b1c3e9b841c850404
+0: [0..383]: data
+1: [384..639]: hole
+eb591f549edabba2b21f80ce4deed8a9
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	16. data -> cache cold ->hole
-0: [0..15]: hole
-1: [16..39]: data
-eecb7aa303d121835de05028751d301c
+0: [0..255]: hole
+1: [256..639]: data
+b0c249edb75ce5b52136864d879cde83
 	17. data -> hole in single block file
-0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0: [0..127]: data
+27b1998d7d1907fb55376ff286f3f506
-- 
1.8.3.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
