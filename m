Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeILMwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 08:52:21 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] fstests: fix _test_generic_punch() to fit 64k extent
Date: Wed, 12 Sep 2018 15:48:44 +0800
Message-Id: <1536738524-9205-1-git-send-email-anand.jain@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

14 test cases use _test_generic_punch() [1], and they work well as long
as the ext4/xfs blocksize or btrfs sectorsize is below 4K.

[1]
grep _test_generic_punch tests/*/[0-9][0-9][0-9] | cut -d"/" -f3 | cut
-d":" -f1| uniq | wc -l
14

In the system with 64K pagesize, as the blocksize can be upto 64K or the
sectorsize can be 64K so 13/14 test cases fail, because the
test-file-size (20k) and thus the extent boundary offsets aren't
big enough to fit the larger than 4k extent size.

Commit 2f194e4e820e6acfcfdadf9f488a162b22db9d86 (generic/009: don't run
for btrfs if PAGE_SIZE > 4096) tried to address this by calling the
not_run in generic/009.

And in the function _test_generic_punch() we use multiple=4 to address
the similar problem but its limited to the subcommand fcollapse.

Now to run these test cases successfully on systems with pagesize 64k,
this patch propose to increase the default multiple=1 to multiple=16.
With this we increase the test file size from 20k to 320k and thus it
encapsulates maximum extent size of 64k here. And we can drop the
multiple=4 which is just being done similar for the cases of fcollapse
subcommand only. And it appears to me there is no harm in increasing
the file size and offsets in general for all commands instead of just
fcollapse command.

This change is tested on ext4, xfs and btrfs using the script [2] on
system with pagesize 4K and 64K.

With this patch, these 14 test cases runs fine on system with 64K
pagesize as well as pagesize 4K. However we may hit the same limitation
at some point when we want to validate the FSs with pagesizes -gt 64K
like for example [3]. And this patch does not address that part as of
now.

Comments appreciated. Thanks.

[3]
-----------
x86
pagesize -a
4096
2097152
1073741824

pagesize -a
65536
2097152
536870912
17179869184
------------

[2]
------------------------------------------------------------
test_dev=/dev/<>
[ -b $$test_dev ] || { echo "$test_dev" not found; exit; }

pagesizes="1024 2048 4096 8192 16384 32768 65536"
tests="generic/009 generic/012 generic/016 generic/021 generic/022
generic/058 generic/060 generic/061 generic/063 generic/255 generic/316"

log()
{
	echo ------ $1 -------
}

log EXT4: default
for page in $pagesizes; do [ $page -le $(pagesize) ] && yes|mkfs.ext4 -q
-b $page $test_dev && log $page && ./check $tests ext4/001; done

log EXT4: nodelalloc
for page in $pagesizes; do [ $page -le $(pagesize) ] && yes|mkfs.ext4 -q
-b $page $test_dev && log $page && ./check $tests ext4/001; done

log EXT4: dioread_nolock
page=$(pagesize) && yes|mkfs.ext4 -q -b $page $test_dev && log $page &&
./check $tests ext4/001

log XFS:
for page in 512 $pagesizes; do [ $page -le $(pagesize) ] && log $page &&
mkfs.xfs -fq -b size=$page $test_dev && ./check $tests xfs/242 xfs/252;
done

log BTRFS: $(pagesize)
mkfs.btrfs -fq $test_dev && ./check generic/009 generic/255 generic/316
-----------------------------------------------------------

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/punch                  |  13 +-
 tests/ext4/001.out.default    | 472 ++++++++++++++++++++---------------------
 tests/ext4/001.out.nodelalloc | 476 +++++++++++++++++++++---------------------
 tests/ext4/001.out.nozero     | 472 ++++++++++++++++++++---------------------
 tests/generic/009             |   9 -
 tests/generic/009.out         | 472 ++++++++++++++++++++---------------------
 tests/generic/012.out         |  68 +++---
 tests/generic/016.out         |  68 +++---
 tests/generic/021.out         |  68 +++---
 tests/generic/022.out         |  68 +++---
 tests/generic/058.out         | 124 +++++------
 tests/generic/060.out         | 124 +++++------
 tests/generic/061.out         | 128 ++++++------
 tests/generic/063.out         | 128 ++++++------
 tests/generic/255.out         | 452 +++++++++++++++++++--------------------
 tests/generic/316.out         | 224 ++++++++++----------
 tests/xfs/242.out             | 114 +++++-----
 tests/xfs/252.out             | 452 +++++++++++++++++++--------------------
 18 files changed, 1956 insertions(+), 1976 deletions(-)

diff --git a/common/punch b/common/punch
index 8088b01a787c..108bad8ec14d 100644
--- a/common/punch
+++ b/common/punch
@@ -325,17 +325,10 @@ _test_generic_punch()
 	map_cmd=$4
 	filter_cmd=$5
 	testfile=$6
-	multiple=1
-
-	#
-	# If we are testing collapse range, we increare all the offsets of this
-	# test by a factor of 4. We do this because unlike punch, collapse
-	# range also decreases the size of file hence require bigger offsets.
-	#
-	if [ "$zero_cmd" == "fcollapse" ]; then
-		multiple=4
-	fi
 
+	# The punch hole tests needs multiple of the largest extent size being
+	# tested, with multiple=16 it can test extent size upto 64k.
+	multiple=16
 	_4k="$((multiple * 4))k"
 	_8k="$((multiple * 8))k"
 	_12k="$((multiple * 12))k"
diff --git a/tests/ext4/001.out.default b/tests/ext4/001.out.default
index c2f728483b23..435f1eb520b1 100644
--- a/tests/ext4/001.out.default
+++ b/tests/ext4/001.out.default
@@ -1,79 +1,77 @@
 QA output created by 001
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -83,76 +81,78 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..39]: data
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -162,82 +162,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -247,82 +247,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/ext4/001.out.nodelalloc b/tests/ext4/001.out.nodelalloc
index 212c24783387..435f1eb520b1 100644
--- a/tests/ext4/001.out.nodelalloc
+++ b/tests/ext4/001.out.nodelalloc
@@ -1,79 +1,77 @@
 QA output created by 001
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -83,80 +81,78 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -166,82 +162,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -251,82 +247,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/ext4/001.out.nozero b/tests/ext4/001.out.nozero
index c631034e3ec1..435f1eb520b1 100644
--- a/tests/ext4/001.out.nozero
+++ b/tests/ext4/001.out.nozero
@@ -1,77 +1,77 @@
 QA output created by 001
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -81,78 +81,78 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -162,82 +162,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -247,82 +247,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/generic/009 b/tests/generic/009
index a4f56d0473d7..a3542cabb869 100755
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -43,15 +43,6 @@ if [ "$FSTYP" = "overlay" -a "$OVL_BASE_FSTYP" = "ext4" ]; then
 	_ext4_disable_extent_zeroout "$OVL_BASE_TEST_DEV"
 fi
 
-# When PAGE_SIZE > 4096 some filesystems extent layout is different so
-# it would not match the output.
-if [ "$FSTYP" = "xfs" -o "$FSTYP" = "btrfs" ]; then
-	PAGE_SIZE=`getconf PAGE_SIZE`
-	if [ $PAGE_SIZE -gt 4096 ]; then
-		_notrun "Not supported on $FSTYP with page size > 4096"
-	fi
-fi
-
 # Standard zero range tests
 _test_generic_punch falloc fzero fzero fiemap _filter_fiemap $testfile
 
diff --git a/tests/generic/009.out b/tests/generic/009.out
index 4b451bacfb4c..e40cbc1d97a9 100644
--- a/tests/generic/009.out
+++ b/tests/generic/009.out
@@ -1,77 +1,77 @@
 QA output created by 009
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -81,78 +81,78 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -162,82 +162,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -247,82 +247,82 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	4. hole -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	6. data -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
-0: [0..7]: data
-1: [8..23]: unwritten
-2: [24..39]: data
-cc58a7417c2d7763adc45b6fcd3fa024
+0: [0..127]: data
+1: [128..383]: unwritten
+2: [384..639]: data
+2f7a72b9ca9923b610514a11a45a80c9
 	10. hole -> data -> hole
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
-0: [0..7]: data
-1: [8..31]: unwritten
-2: [32..39]: data
-f6aeca13ec49e5b266cd1c913cd726e3
+0: [0..127]: data
+1: [128..511]: unwritten
+2: [512..639]: data
+0bcfc7652751f8fe46381240ccadd9d7
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/generic/012.out b/tests/generic/012.out
index ffbf8a3a5328..8cc704f24f6e 100644
--- a/tests/generic/012.out
+++ b/tests/generic/012.out
@@ -1,49 +1,49 @@
 QA output created by 012
 	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+ef2e0d18474b2151ef5876b1e89c2f1d
 	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
 	3. into unwritten space
-0: [0..95]: extent
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..383]: extent
+da95adcbefc28ba59b21cf335c516c6f
 	4. hole -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
+0: [0..255]: extent
+1: [256..383]: hole
+6c08298ff068abc7a94c597b6120bd00
 	5. hole -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..255]: extent
+1: [256..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..127]: extent
+1: [128..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..255]: extent
+1: [256..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..127]: extent
+1: [128..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
+0: [0..255]: extent
+1: [256..383]: hole
+6c08298ff068abc7a94c597b6120bd00
 	10. hole -> data -> hole
-0: [0..31]: extent
-1: [32..63]: hole
-76cc863b386460b228a493933813a6a0
+0: [0..127]: extent
+1: [128..255]: hole
+9ef8ace32f3b9890cff4fd43699bbd81
 	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-76cc863b386460b228a493933813a6a0
+0: [0..255]: extent
+9ef8ace32f3b9890cff4fd43699bbd81
 	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
diff --git a/tests/generic/016.out b/tests/generic/016.out
index c45a44a8ba89..bf1a09c6b1ef 100644
--- a/tests/generic/016.out
+++ b/tests/generic/016.out
@@ -1,49 +1,49 @@
 QA output created by 016
 	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+ef2e0d18474b2151ef5876b1e89c2f1d
 	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
 	3. into unwritten space
-0: [0..95]: extent
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..383]: extent
+da95adcbefc28ba59b21cf335c516c6f
 	4. hole -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
+0: [0..255]: extent
+1: [256..383]: hole
+6c08298ff068abc7a94c597b6120bd00
 	5. hole -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..255]: extent
+1: [256..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..127]: extent
+1: [128..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..255]: extent
+1: [256..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..127]: extent
+1: [128..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
+0: [0..255]: extent
+1: [256..383]: hole
+6c08298ff068abc7a94c597b6120bd00
 	10. hole -> data -> hole
-0: [0..31]: extent
-1: [32..63]: hole
-76cc863b386460b228a493933813a6a0
+0: [0..127]: extent
+1: [128..255]: hole
+9ef8ace32f3b9890cff4fd43699bbd81
 	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-76cc863b386460b228a493933813a6a0
+0: [0..255]: extent
+9ef8ace32f3b9890cff4fd43699bbd81
 	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
diff --git a/tests/generic/021.out b/tests/generic/021.out
index 1137741c472c..b90c641e7252 100644
--- a/tests/generic/021.out
+++ b/tests/generic/021.out
@@ -1,49 +1,49 @@
 QA output created by 021
 	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+ef2e0d18474b2151ef5876b1e89c2f1d
 	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
 	3. into unwritten space
-0: [0..95]: extent
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+0: [0..383]: extent
+ef2e0d18474b2151ef5876b1e89c2f1d
 	4. hole -> data
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
+0: [0..127]: hole
+1: [128..255]: extent
+2: [256..383]: hole
+05424d688bd9df682d20616d21940871
 	5. hole -> unwritten
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+0: [0..127]: hole
+1: [128..255]: extent
+2: [256..383]: hole
+ef2e0d18474b2151ef5876b1e89c2f1d
 	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..127]: extent
+1: [128..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..255]: extent
+1: [256..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+0: [0..127]: extent
+1: [128..383]: hole
+ef2e0d18474b2151ef5876b1e89c2f1d
 	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
+0: [0..255]: extent
+1: [256..383]: hole
+05424d688bd9df682d20616d21940871
 	10. hole -> data -> hole
-bb7df04e1b0a2570657527a7e108ae23
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193
 	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-bb7df04e1b0a2570657527a7e108ae23
+0: [0..255]: extent
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193
 	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
diff --git a/tests/generic/022.out b/tests/generic/022.out
index fbffa5952a43..de4cff8a64bb 100644
--- a/tests/generic/022.out
+++ b/tests/generic/022.out
@@ -1,49 +1,49 @@
 QA output created by 022
 	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+ef2e0d18474b2151ef5876b1e89c2f1d
 	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
 	3. into unwritten space
-0: [0..95]: extent
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+0: [0..383]: extent
+ef2e0d18474b2151ef5876b1e89c2f1d
 	4. hole -> data
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
+0: [0..127]: hole
+1: [128..255]: extent
+2: [256..383]: hole
+05424d688bd9df682d20616d21940871
 	5. hole -> unwritten
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+0: [0..127]: hole
+1: [128..255]: extent
+2: [256..383]: hole
+ef2e0d18474b2151ef5876b1e89c2f1d
 	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..127]: extent
+1: [128..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
+0: [0..255]: extent
+1: [256..383]: hole
+da95adcbefc28ba59b21cf335c516c6f
 	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
+0: [0..127]: extent
+1: [128..383]: hole
+ef2e0d18474b2151ef5876b1e89c2f1d
 	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
+0: [0..255]: extent
+1: [256..383]: hole
+05424d688bd9df682d20616d21940871
 	10. hole -> data -> hole
-bb7df04e1b0a2570657527a7e108ae23
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193
 	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-bb7df04e1b0a2570657527a7e108ae23
+0: [0..255]: extent
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193
 	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
+0: [0..255]: extent
+d48858312a922db7eb86377f638dbc9f
 	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
+0: [0..383]: extent
+cc767c0ddc3ff5704c2de7f801707d85
diff --git a/tests/generic/058.out b/tests/generic/058.out
index b15308d7e274..3bb827d45ec6 100644
--- a/tests/generic/058.out
+++ b/tests/generic/058.out
@@ -1,78 +1,78 @@
 QA output created by 058
 	1. into a hole
-cf845a781c107ec1346e849c9dd1b7e8
+72b5e7556a604b06e790401ecc7b5b2d
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-64e72217eebcbdf31b1b058f9f5f476a
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+85150f56d1f598daa2776771bbfb8347
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-cf845a781c107ec1346e849c9dd1b7e8
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+72b5e7556a604b06e790401ecc7b5b2d
 	4. hole -> data
-0: [0..31]: hole
-1: [32..47]: extent
-2: [48..55]: hole
-adb08a6d94a3b5eff90fdfebb2366d31
+0: [0..511]: hole
+1: [512..767]: extent
+2: [768..895]: hole
+3bbe716019739da9679d10dafbaf0cdf
 	5. hole -> unwritten
-0: [0..31]: hole
-1: [32..47]: extent
-2: [48..55]: hole
-cf845a781c107ec1346e849c9dd1b7e8
+0: [0..511]: hole
+1: [512..767]: extent
+2: [768..895]: hole
+72b5e7556a604b06e790401ecc7b5b2d
 	6. data -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..55]: hole
-be0f35d4292a20040766d87883b0abd1
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..895]: hole
+097cbf706ff92b327228097f81e71f9e
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-be0f35d4292a20040766d87883b0abd1
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+097cbf706ff92b327228097f81e71f9e
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..55]: hole
-cf845a781c107ec1346e849c9dd1b7e8
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..895]: hole
+72b5e7556a604b06e790401ecc7b5b2d
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-adb08a6d94a3b5eff90fdfebb2366d31
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+3bbe716019739da9679d10dafbaf0cdf
 	10. hole -> data -> hole
-0: [0..39]: hole
-1: [40..47]: extent
-2: [48..63]: hole
-0487b3c52810f994c541aa166215375f
+0: [0..639]: hole
+1: [640..767]: extent
+2: [768..1023]: hole
+25d5a6b0e585c6786bad8e89772bec43
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-3: [40..47]: hole
-4: [48..63]: extent
-e3a8d52acc4d91a8ed19d7b6f4f26a71
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+3: [640..767]: hole
+4: [768..1023]: extent
+59318afefe51e77755ae7d3ef45cd067
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-0487b3c52810f994c541aa166215375f
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+25d5a6b0e585c6786bad8e89772bec43
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-2b22165f4a24a2c36fd05ef00b41df88
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+14f9fdcf7f1920275e6de2b342441a24
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-2: [40..55]: extent
-aa0f20d1edcdbce60d8ef82700ba30c3
+0: [0..383]: extent
+1: [384..639]: hole
+2: [640..895]: extent
+222a22b39253359b4afd167b9f150530
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..55]: extent
-86c9d033be2761385c9cfa203c426bb2
+0: [0..255]: hole
+1: [256..895]: extent
+3f701b5bae2bec1d49dd68b17fa334e5
diff --git a/tests/generic/060.out b/tests/generic/060.out
index 909b578f9670..e8affc60d236 100644
--- a/tests/generic/060.out
+++ b/tests/generic/060.out
@@ -1,78 +1,78 @@
 QA output created by 060
 	1. into a hole
-cf845a781c107ec1346e849c9dd1b7e8
+72b5e7556a604b06e790401ecc7b5b2d
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-64e72217eebcbdf31b1b058f9f5f476a
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+85150f56d1f598daa2776771bbfb8347
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-cf845a781c107ec1346e849c9dd1b7e8
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+72b5e7556a604b06e790401ecc7b5b2d
 	4. hole -> data
-0: [0..31]: hole
-1: [32..47]: extent
-2: [48..55]: hole
-adb08a6d94a3b5eff90fdfebb2366d31
+0: [0..511]: hole
+1: [512..767]: extent
+2: [768..895]: hole
+3bbe716019739da9679d10dafbaf0cdf
 	5. hole -> unwritten
-0: [0..31]: hole
-1: [32..47]: extent
-2: [48..55]: hole
-cf845a781c107ec1346e849c9dd1b7e8
+0: [0..511]: hole
+1: [512..767]: extent
+2: [768..895]: hole
+72b5e7556a604b06e790401ecc7b5b2d
 	6. data -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..55]: hole
-be0f35d4292a20040766d87883b0abd1
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..895]: hole
+097cbf706ff92b327228097f81e71f9e
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-be0f35d4292a20040766d87883b0abd1
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+097cbf706ff92b327228097f81e71f9e
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..55]: hole
-cf845a781c107ec1346e849c9dd1b7e8
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..895]: hole
+72b5e7556a604b06e790401ecc7b5b2d
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-adb08a6d94a3b5eff90fdfebb2366d31
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+3bbe716019739da9679d10dafbaf0cdf
 	10. hole -> data -> hole
-0: [0..39]: hole
-1: [40..47]: extent
-2: [48..63]: hole
-0487b3c52810f994c541aa166215375f
+0: [0..639]: hole
+1: [640..767]: extent
+2: [768..1023]: hole
+25d5a6b0e585c6786bad8e89772bec43
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-3: [40..47]: hole
-4: [48..63]: extent
-e3a8d52acc4d91a8ed19d7b6f4f26a71
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+3: [640..767]: hole
+4: [768..1023]: extent
+59318afefe51e77755ae7d3ef45cd067
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-0487b3c52810f994c541aa166215375f
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+25d5a6b0e585c6786bad8e89772bec43
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-2b22165f4a24a2c36fd05ef00b41df88
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+14f9fdcf7f1920275e6de2b342441a24
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-2: [40..55]: extent
-aa0f20d1edcdbce60d8ef82700ba30c3
+0: [0..383]: extent
+1: [384..639]: hole
+2: [640..895]: extent
+222a22b39253359b4afd167b9f150530
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..55]: extent
-86c9d033be2761385c9cfa203c426bb2
+0: [0..255]: hole
+1: [256..895]: extent
+3f701b5bae2bec1d49dd68b17fa334e5
diff --git a/tests/generic/061.out b/tests/generic/061.out
index 78d6c6dc7e76..bcf6cb95d97f 100644
--- a/tests/generic/061.out
+++ b/tests/generic/061.out
@@ -1,80 +1,80 @@
 QA output created by 061
 	1. into a hole
-cf845a781c107ec1346e849c9dd1b7e8
+72b5e7556a604b06e790401ecc7b5b2d
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-64e72217eebcbdf31b1b058f9f5f476a
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+85150f56d1f598daa2776771bbfb8347
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-22b7303d274481990b5401b6263effe0
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+4c4c2b9ddb351ce0383f1cbde06d9f47
 	4. hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..55]: extent
-c4fef62ba1de9d91a977cfeec6632f19
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..895]: extent
+8261145c98c99a577e6f3876525853ed
 	5. hole -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..55]: extent
-1ca74f7572a0f4ab477fdbb5682e5f61
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..895]: extent
+d8c5d68c8915b699e85d5391e0ad33a1
 	6. data -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..47]: hole
-4: [48..55]: extent
-be0f35d4292a20040766d87883b0abd1
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..767]: hole
+4: [768..895]: extent
+097cbf706ff92b327228097f81e71f9e
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-bddb1f3895268acce30d516a99cb0f2f
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+d4630e9bd614ad38e582e2a96402cb6a
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
-4: [40..55]: extent
-f8fc47adc45b7cf72f988b3ddf5bff64
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..639]: hole
+4: [640..895]: extent
+5b22d2fff0e44ea788fc4659fe992252
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-c4fef62ba1de9d91a977cfeec6632f19
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+8261145c98c99a577e6f3876525853ed
 	10. hole -> data -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-2: [40..63]: extent
-52af1bfcbf43f28af2328de32e0567e5
+0: [0..127]: extent
+1: [128..639]: hole
+2: [640..1023]: extent
+215afdd4acf40cd6e85ce3070d7651b9
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-3: [40..47]: hole
-4: [48..63]: extent
-e3a8d52acc4d91a8ed19d7b6f4f26a71
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+3: [640..767]: hole
+4: [768..1023]: extent
+59318afefe51e77755ae7d3ef45cd067
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-52af1bfcbf43f28af2328de32e0567e5
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+215afdd4acf40cd6e85ce3070d7651b9
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-2b22165f4a24a2c36fd05ef00b41df88
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+14f9fdcf7f1920275e6de2b342441a24
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-2: [40..55]: extent
-aa0f20d1edcdbce60d8ef82700ba30c3
+0: [0..383]: extent
+1: [384..639]: hole
+2: [640..895]: extent
+222a22b39253359b4afd167b9f150530
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..55]: extent
-86c9d033be2761385c9cfa203c426bb2
+0: [0..255]: hole
+1: [256..895]: extent
+3f701b5bae2bec1d49dd68b17fa334e5
diff --git a/tests/generic/063.out b/tests/generic/063.out
index d828ff6ff237..608bb687fb73 100644
--- a/tests/generic/063.out
+++ b/tests/generic/063.out
@@ -1,80 +1,80 @@
 QA output created by 063
 	1. into a hole
-cf845a781c107ec1346e849c9dd1b7e8
+72b5e7556a604b06e790401ecc7b5b2d
 	2. into allocated space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-64e72217eebcbdf31b1b058f9f5f476a
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+85150f56d1f598daa2776771bbfb8347
 	3. into unwritten space
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..55]: extent
-22b7303d274481990b5401b6263effe0
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..895]: extent
+4c4c2b9ddb351ce0383f1cbde06d9f47
 	4. hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..55]: extent
-c4fef62ba1de9d91a977cfeec6632f19
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..895]: extent
+8261145c98c99a577e6f3876525853ed
 	5. hole -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..55]: extent
-1ca74f7572a0f4ab477fdbb5682e5f61
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..895]: extent
+d8c5d68c8915b699e85d5391e0ad33a1
 	6. data -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..47]: hole
-4: [48..55]: extent
-be0f35d4292a20040766d87883b0abd1
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..767]: hole
+4: [768..895]: extent
+097cbf706ff92b327228097f81e71f9e
 	7. data -> unwritten
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-bddb1f3895268acce30d516a99cb0f2f
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+d4630e9bd614ad38e582e2a96402cb6a
 	8. unwritten -> hole
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..31]: extent
-3: [32..39]: hole
-4: [40..55]: extent
-f8fc47adc45b7cf72f988b3ddf5bff64
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..511]: extent
+3: [512..639]: hole
+4: [640..895]: extent
+5b22d2fff0e44ea788fc4659fe992252
 	9. unwritten -> data
-0: [0..7]: extent
-1: [8..23]: hole
-2: [24..47]: extent
-3: [48..55]: hole
-c4fef62ba1de9d91a977cfeec6632f19
+0: [0..127]: extent
+1: [128..383]: hole
+2: [384..767]: extent
+3: [768..895]: hole
+8261145c98c99a577e6f3876525853ed
 	10. hole -> data -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-2: [40..63]: extent
-52af1bfcbf43f28af2328de32e0567e5
+0: [0..127]: extent
+1: [128..639]: hole
+2: [640..1023]: extent
+215afdd4acf40cd6e85ce3070d7651b9
 	11. data -> hole -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..39]: extent
-3: [40..47]: hole
-4: [48..63]: extent
-e3a8d52acc4d91a8ed19d7b6f4f26a71
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..639]: extent
+3: [640..767]: hole
+4: [768..1023]: extent
+59318afefe51e77755ae7d3ef45cd067
 	12. unwritten -> data -> unwritten
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-52af1bfcbf43f28af2328de32e0567e5
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+215afdd4acf40cd6e85ce3070d7651b9
 	13. data -> unwritten -> data
-0: [0..7]: extent
-1: [8..31]: hole
-2: [32..63]: extent
-2b22165f4a24a2c36fd05ef00b41df88
+0: [0..127]: extent
+1: [128..511]: hole
+2: [512..1023]: extent
+14f9fdcf7f1920275e6de2b342441a24
 	14. data -> hole @ EOF
-0: [0..23]: extent
-1: [24..39]: hole
-2: [40..55]: extent
-aa0f20d1edcdbce60d8ef82700ba30c3
+0: [0..383]: extent
+1: [384..639]: hole
+2: [640..895]: extent
+222a22b39253359b4afd167b9f150530
 	15. data -> hole @ 0
-0: [0..15]: hole
-1: [16..55]: extent
-86c9d033be2761385c9cfa203c426bb2
+0: [0..255]: hole
+1: [256..895]: extent
+3f701b5bae2bec1d49dd68b17fa334e5
diff --git a/tests/generic/255.out b/tests/generic/255.out
index 217ef3ededbc..2fb9aaf13a7c 100644
--- a/tests/generic/255.out
+++ b/tests/generic/255.out
@@ -1,75 +1,75 @@
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -79,76 +79,76 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -158,79 +158,79 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -240,79 +240,79 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/generic/316.out b/tests/generic/316.out
index 383f0d1623b3..a083f5dcf2dd 100644
--- a/tests/generic/316.out
+++ b/tests/generic/316.out
@@ -1,39 +1,39 @@
 QA output created by 316
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
 	4. hole -> data
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: hole
+1: [384..511]: extent
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	6. data -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: extent
+1: [128..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -43,40 +43,40 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 	4. hole -> data
-0: [0..23]: hole
-1: [24..31]: extent
-2: [32..39]: hole
-cc63069677939f69a6e8f68cae6a6dac
+0: [0..383]: hole
+1: [384..511]: extent
+2: [512..639]: hole
+286aad7ca07b2256f0f2bb8e608ff63d
 	6. data -> hole
-0: [0..7]: extent
-1: [8..39]: hole
-1b3779878366498b28c702ef88c4a773
+0: [0..127]: extent
+1: [128..639]: hole
+3976e5cc0b8a47c4cdc9e0211635f568
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -86,44 +86,44 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 	4. hole -> data
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -133,44 +133,44 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 	4. hole -> data
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
 0: [0..7]: extent
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/xfs/242.out b/tests/xfs/242.out
index a516c23c48d4..5ab845f0ea29 100644
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
diff --git a/tests/xfs/252.out b/tests/xfs/252.out
index 47d9a4c96f21..b0842079e756 100644
--- a/tests/xfs/252.out
+++ b/tests/xfs/252.out
@@ -1,75 +1,75 @@
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -79,76 +79,76 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -158,79 +158,79 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
@@ -240,79 +240,79 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
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
 0: [0..7]: data
 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
-- 
1.8.3.1
