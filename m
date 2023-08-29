Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56486C83F1A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbjH2XED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbjH2XDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:03:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3041B139;
        Tue, 29 Aug 2023 16:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F685611BD;
        Tue, 29 Aug 2023 23:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05197C433C8;
        Tue, 29 Aug 2023 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350224;
        bh=Nptq/ar1YzNKVY9QJy9vccVCeZUfRc9cRT/A1f+WifE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WxCNo777tEPKb4yvOyNdWnVcWRgLLEBN4wUdmwiTsHaXfMdPhHLqS7ra1eetNDjsx
         mZGGN6hp1wFKJ3f8No7GYxJta47g6qdrQagt2qSvGRSFF1qSke4lWGQClWzNMk+HqV
         KWLy5SY01FPCgeDHTIS1S0Bi4zO27gzRqtN/oN2UUinIB7//KU+uP564caueHxYw/t
         A7jjnSiA+joyfXmyW18Ab5MPepmmeAqiREOniXJIKVIUVzk9vJWEK1APbfmBYTM3T2
         39sRgmaEO8E8/t94VreiJNRjsViY8g/FEl/WHgOGQJsVR9ycqK3JMW6qfyT7Wbc6mz
         0zQJMnSV6+z0Q==
Subject: [PATCH 2/3] common: rename get_page_size to _get_page_size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:03:43 -0700
Message-ID: <169335022356.3517899.16298598568849437206.stgit@frogsfrogsfrogs>
In-Reply-To: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
References: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This function does not follow the naming convention that common helpers
must start with an underscore.  Fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/btrfs      |    2 +-
 common/filter     |    2 +-
 common/rc         |    6 +++---
 common/verity     |    2 +-
 tests/btrfs/049   |    2 +-
 tests/btrfs/106   |    2 +-
 tests/btrfs/173   |    4 ++--
 tests/btrfs/174   |    2 +-
 tests/btrfs/175   |    4 ++--
 tests/btrfs/176   |    4 ++--
 tests/btrfs/192   |    2 +-
 tests/btrfs/215   |    2 +-
 tests/btrfs/251   |    2 +-
 tests/btrfs/271   |    2 +-
 tests/btrfs/274   |    2 +-
 tests/btrfs/293   |    2 +-
 tests/ext4/003    |    2 +-
 tests/ext4/022    |    2 +-
 tests/ext4/306    |    2 +-
 tests/generic/416 |    2 +-
 tests/generic/472 |    2 +-
 tests/generic/495 |    2 +-
 tests/generic/496 |    2 +-
 tests/generic/497 |    2 +-
 tests/generic/574 |    2 +-
 tests/generic/636 |    2 +-
 tests/generic/641 |    2 +-
 tests/xfs/513     |    2 +-
 tests/xfs/552     |    2 +-
 tests/xfs/559     |    2 +-
 30 files changed, 35 insertions(+), 35 deletions(-)


diff --git a/common/btrfs b/common/btrfs
index 0fec093d17..c9903a413c 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -489,7 +489,7 @@ _require_btrfs_support_sectorsize()
 	local sectorsize=$1
 
 	# PAGE_SIZE as sectorsize is always supported
-	if [ $sectorsize -eq $(get_page_size) ]; then
+	if [ $sectorsize -eq $(_get_page_size) ]; then
 		return
 	fi
 
diff --git a/common/filter b/common/filter
index f10ba78a04..509ee95039 100644
--- a/common/filter
+++ b/common/filter
@@ -228,7 +228,7 @@ _filter_xfs_io_blocks_modified()
 
 _filter_xfs_io_pages_modified()
 {
-	PAGE_SIZE=$(get_page_size)
+	PAGE_SIZE=$(_get_page_size)
 
 	_filter_xfs_io_units_modified "Page" $PAGE_SIZE
 }
diff --git a/common/rc b/common/rc
index b5bf3c3bcb..1618ded544 100644
--- a/common/rc
+++ b/common/rc
@@ -1100,7 +1100,7 @@ _scratch_mkfs_blocksized()
 	if ! [[ $blocksize =~ $re ]] ; then
 		_notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
 	fi
-	if [ $blocksize -lt $(get_page_size) ]; then
+	if [ $blocksize -lt $(_get_page_size) ]; then
 		_exclude_scratch_mount_option dax
 	fi
 
@@ -2808,7 +2808,7 @@ _require_scratch_swapfile()
 	_scratch_mount
 
 	# Minimum size for mkswap is 10 pages
-	_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10)) > /dev/null
+	_format_swapfile "$SCRATCH_MNT/swap" $(($(_get_page_size) * 10)) > /dev/null
 
 	# ext* has supported all variants of swap files since their
 	# introduction, so swapon should not fail.
@@ -4667,7 +4667,7 @@ _require_file_block_size_equals_fs_block_size()
 		_notrun "File allocation unit is larger than a filesystem block"
 }
 
-get_page_size()
+_get_page_size()
 {
 	echo $(getconf PAGE_SIZE)
 }
diff --git a/common/verity b/common/verity
index e09377177d..03d175ce1b 100644
--- a/common/verity
+++ b/common/verity
@@ -61,7 +61,7 @@ _require_scratch_verity()
 	# Therefore, we default to merkle_tree_block_size == min(fs_block_size,
 	# page_size).  That maximizes the chance of verity actually working.
 	local fs_block_size=$(_get_block_size $scratch_mnt)
-	local page_size=$(get_page_size)
+	local page_size=$(_get_page_size)
 	if (( fs_block_size <= page_size )); then
 		FSV_BLOCK_SIZE=$fs_block_size
 	else
diff --git a/tests/btrfs/049 b/tests/btrfs/049
index 6993050b72..9569c14173 100755
--- a/tests/btrfs/049
+++ b/tests/btrfs/049
@@ -23,7 +23,7 @@ _spare_dev_get
 swapfile="$SCRATCH_MNT/swap"
 _scratch_pool_mkfs >/dev/null
 _scratch_mount
-_format_swapfile "$swapfile" $(($(get_page_size) * 10)) >/dev/null
+_format_swapfile "$swapfile" $(($(_get_page_size) * 10)) >/dev/null
 
 check_exclusive_ops()
 {
diff --git a/tests/btrfs/106 b/tests/btrfs/106
index 7496697f7a..7444e4d5a7 100755
--- a/tests/btrfs/106
+++ b/tests/btrfs/106
@@ -26,7 +26,7 @@ test_clone_and_read_compressed_extent()
 	_scratch_mkfs >>$seqres.full 2>&1
 	_scratch_mount $mount_opts
 
-	PAGE_SIZE=$(get_page_size)
+	PAGE_SIZE=$(_get_page_size)
 
 	# Create our test file with 16 pages worth of data in a single extent
 	# that is going to be compressed no matter which compression algorithm
diff --git a/tests/btrfs/173 b/tests/btrfs/173
index 9f53143ecc..4972a5a705 100755
--- a/tests/btrfs/173
+++ b/tests/btrfs/173
@@ -24,14 +24,14 @@ echo "COW file"
 rm -f "$SCRATCH_MNT/swap"
 touch "$SCRATCH_MNT/swap"
 chmod 0600 "$SCRATCH_MNT/swap"
-_pwrite_byte 0x61 0 $(($(get_page_size) * 10)) "$SCRATCH_MNT/swap" >> $seqres.full
+_pwrite_byte 0x61 0 $(($(_get_page_size) * 10)) "$SCRATCH_MNT/swap" >> $seqres.full
 $MKSWAP_PROG "$SCRATCH_MNT/swap" >> $seqres.full
 swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
 swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
 
 echo "Compressed file"
 rm -f "$SCRATCH_MNT/swap"
-_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10)) > /dev/null
+_format_swapfile "$SCRATCH_MNT/swap" $(($(_get_page_size) * 10)) > /dev/null
 $CHATTR_PROG +c "$SCRATCH_MNT/swap" 2>&1 | grep -o "Invalid argument while setting flags"
 
 status=0
diff --git a/tests/btrfs/174 b/tests/btrfs/174
index 3bb5e7f918..0acd65f0e3 100755
--- a/tests/btrfs/174
+++ b/tests/btrfs/174
@@ -20,7 +20,7 @@ _scratch_mount
 
 $BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/swapvol" >> $seqres.full
 swapfile="$SCRATCH_MNT/swapvol/swap"
-_format_swapfile "$swapfile" $(($(get_page_size) * 10)) > /dev/null
+_format_swapfile "$swapfile" $(($(_get_page_size) * 10)) > /dev/null
 swapon "$swapfile"
 
 # Turning off nocow doesn't do anything because the file is not empty, not
diff --git a/tests/btrfs/175 b/tests/btrfs/175
index db877d4196..de52c71ee2 100755
--- a/tests/btrfs/175
+++ b/tests/btrfs/175
@@ -17,7 +17,7 @@ _require_scratch_swapfile
 _check_minimal_fs_size $((1024 * 1024 * 1024))
 
 cycle_swapfile() {
-	local sz=${1:-$(($(get_page_size) * 10))}
+	local sz=${1:-$(($(_get_page_size) * 10))}
 	_format_swapfile "$SCRATCH_MNT/swap" "$sz" > /dev/null
 	swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
 	swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
@@ -47,7 +47,7 @@ _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
 # Create the swap file, then add the device. That way we know it's all on one
 # device.
-_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10)) > /dev/null
+_format_swapfile "$SCRATCH_MNT/swap" $(($(_get_page_size) * 10)) > /dev/null
 scratch_dev2="$(echo "${SCRATCH_DEV_POOL}" | $AWK_PROG '{ print $2 }')"
 $BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT" >> $seqres.full
 swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
diff --git a/tests/btrfs/176 b/tests/btrfs/176
index 7080d8608b..0ddff8d8e6 100755
--- a/tests/btrfs/176
+++ b/tests/btrfs/176
@@ -29,7 +29,7 @@ scratch_dev3="$(echo "${SCRATCH_DEV_POOL}" | $AWK_PROG '{ print $3 }')"
 echo "Remove device"
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
-_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10)) > /dev/null
+_format_swapfile "$SCRATCH_MNT/swap" $(($(_get_page_size) * 10)) > /dev/null
 $BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT" >> $seqres.full
 swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
 # We know the swap file is on device 1 because we added device 2 after it was
@@ -47,7 +47,7 @@ _check_scratch_fs "$scratch_dev2"
 echo "Replace device"
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
-_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10)) > /dev/null
+_format_swapfile "$SCRATCH_MNT/swap" $(($(_get_page_size) * 10)) > /dev/null
 $BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT" >> $seqres.full
 swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
 # Again, we know the swap file is on device 1.
diff --git a/tests/btrfs/192 b/tests/btrfs/192
index 7324c9e398..ea261b34fb 100755
--- a/tests/btrfs/192
+++ b/tests/btrfs/192
@@ -41,7 +41,7 @@ _require_scratch
 _require_attrs
 
 # We require a 4K nodesize to ensure the test isn't too slow
-if [ $(get_page_size) -ne 4096 ]; then
+if [ $(_get_page_size) -ne 4096 ]; then
 	_notrun "This test doesn't support non-4K page size yet"
 fi
 
diff --git a/tests/btrfs/215 b/tests/btrfs/215
index 3daa696aa6..006468984b 100755
--- a/tests/btrfs/215
+++ b/tests/btrfs/215
@@ -33,7 +33,7 @@ _scratch_mkfs > /dev/null
 # blobk group
 _scratch_mount $(_btrfs_no_v1_cache_opt)
 
-pagesize=$(get_page_size)
+pagesize=$(_get_page_size)
 blocksize=$(_get_block_size $SCRATCH_MNT)
 
 # For subpage case, since we still do read in full page size, if have 8 corrupted
diff --git a/tests/btrfs/251 b/tests/btrfs/251
index 4b6edd6cbe..af01095828 100755
--- a/tests/btrfs/251
+++ b/tests/btrfs/251
@@ -19,7 +19,7 @@ _begin_fstest auto quick compress dangerous
 _supported_fs btrfs
 _require_scratch
 
-pagesize=$(get_page_size)
+pagesize=$(_get_page_size)
 
 # Read the content from urandom to a known safe location
 $XFS_IO_PROG -f -c "pwrite -i /dev/urandom 0 $pagesize" "$tmp.good" > /dev/null
diff --git a/tests/btrfs/271 b/tests/btrfs/271
index c7c95b3e38..273799f179 100755
--- a/tests/btrfs/271
+++ b/tests/btrfs/271
@@ -25,7 +25,7 @@ _scratch_mount
 
 dev2=`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`
 
-pagesize=$(get_page_size)
+pagesize=$(_get_page_size)
 blocksize=$(_get_block_size $SCRATCH_MNT)
 sectors_per_page=$(($pagesize / $blocksize))
 
diff --git a/tests/btrfs/274 b/tests/btrfs/274
index c0594e25de..ec7d66269a 100755
--- a/tests/btrfs/274
+++ b/tests/btrfs/274
@@ -30,7 +30,7 @@ swap_file="$SCRATCH_MNT/subvol/swap"
 $BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/subvol | _filter_scratch
 
 echo "Creating and activating swap file..."
-_format_swapfile $swap_file $(($(get_page_size) * 32)) >> $seqres.full
+_format_swapfile $swap_file $(($(_get_page_size) * 32)) >> $seqres.full
 _swapon_file $swap_file
 
 echo "Attempting to delete subvolume with swap file enabled..."
diff --git a/tests/btrfs/293 b/tests/btrfs/293
index f51d40ddec..5cbbee8fd1 100755
--- a/tests/btrfs/293
+++ b/tests/btrfs/293
@@ -29,7 +29,7 @@ _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
 
 swap_file="$SCRATCH_MNT/swapfile"
-_format_swapfile $swap_file $(($(get_page_size) * 64)) >> $seqres.full
+_format_swapfile $swap_file $(($(_get_page_size) * 64)) >> $seqres.full
 
 echo "Creating first snapshot..."
 $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1 | _filter_scratch
diff --git a/tests/ext4/003 b/tests/ext4/003
index 8ac467b89b..a70ad97a91 100755
--- a/tests/ext4/003
+++ b/tests/ext4/003
@@ -26,7 +26,7 @@ _supported_fs ext4
 _require_scratch
 _require_scratch_ext4_feature "bigalloc"
 
-BLOCK_SIZE=$(get_page_size)
+BLOCK_SIZE=$(_get_page_size)
 features=bigalloc
 if echo "${MOUNT_OPTIONS}" | grep -q 'test_dummy_encryption' ; then
     features+=",encrypt"
diff --git a/tests/ext4/022 b/tests/ext4/022
index 321050b35c..96929cb8aa 100755
--- a/tests/ext4/022
+++ b/tests/ext4/022
@@ -27,7 +27,7 @@ _require_attrs
 
 # Block size
 BLOCK_SIZE=4096
-if [[ $(get_page_size) -ne $BLOCK_SIZE ]]; then
+if [[ $(_get_page_size) -ne $BLOCK_SIZE ]]; then
        _exclude_scratch_mount_option dax
 fi
 # Use large inodes to have enough space for experimentation
diff --git a/tests/ext4/306 b/tests/ext4/306
index db2562848e..715732a76e 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -37,7 +37,7 @@ if echo "${MOUNT_OPTIONS}" | grep -q 'test_dummy_encryption' ; then
     features+=",encrypt"
 fi
 
-blksz=$(get_page_size)
+blksz=$(_get_page_size)
 
 $MKFS_EXT4_PROG -F -b $blksz -O "$features" $SCRATCH_DEV 512m >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/generic/416 b/tests/generic/416
index deb05f07dd..0f6e3bc9a1 100755
--- a/tests/generic/416
+++ b/tests/generic/416
@@ -22,7 +22,7 @@ _supported_fs generic
 _require_scratch
 
 fs_size=$((128 * 1024 * 1024))
-page_size=$(get_page_size)
+page_size=$(_get_page_size)
 
 # We will never reach this number though
 nr_files=$(($fs_size / $page_size))
diff --git a/tests/generic/472 b/tests/generic/472
index a64735caa4..7d11ba3700 100755
--- a/tests/generic/472
+++ b/tests/generic/472
@@ -57,7 +57,7 @@ swapfile_cycle $swapfile $((len + 3))
 # Create a ridiculously small swap file.  Each swap file must have at least
 # two pages after the header page.
 echo "tiny swap" | tee -a $seqres.full
-swapfile_cycle $swapfile $(($(get_page_size) * 3))
+swapfile_cycle $swapfile $(($(_get_page_size) * 3))
 
 status=0
 exit
diff --git a/tests/generic/495 b/tests/generic/495
index 5e03dfee62..84547f1823 100755
--- a/tests/generic/495
+++ b/tests/generic/495
@@ -30,7 +30,7 @@ test $blksize -eq $(getconf PAGE_SIZE) || \
 touch "$SCRATCH_MNT/swap"
 $CHATTR_PROG +C "$SCRATCH_MNT/swap" >> $seqres.full 2>&1
 chmod 0600 "$SCRATCH_MNT/swap"
-$XFS_IO_PROG -c "truncate $(($(get_page_size) * 10))" "$SCRATCH_MNT/swap"
+$XFS_IO_PROG -c "truncate $(($(_get_page_size) * 10))" "$SCRATCH_MNT/swap"
 "$here/src/mkswap" "$SCRATCH_MNT/swap"
 "$here/src/swapon" "$SCRATCH_MNT/swap"
 swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
diff --git a/tests/generic/496 b/tests/generic/496
index 4aeaffd319..12f1bc4f94 100755
--- a/tests/generic/496
+++ b/tests/generic/496
@@ -33,7 +33,7 @@ _scratch_mount >>$seqres.full 2>&1
 
 swapfile=$SCRATCH_MNT/swap
 len=$((2 * 1048576))
-page_size=$(get_page_size)
+page_size=$(_get_page_size)
 
 swapfile_cycle() {
 	local swapfile="$1"
diff --git a/tests/generic/497 b/tests/generic/497
index 6188e3854b..05e368ab6f 100755
--- a/tests/generic/497
+++ b/tests/generic/497
@@ -33,7 +33,7 @@ _scratch_mount >>$seqres.full 2>&1
 
 swapfile=$SCRATCH_MNT/swap
 len=$((2 * 1048576))
-page_size=$(get_page_size)
+page_size=$(_get_page_size)
 
 swapfile_cycle() {
 	local swapfile="$1"
diff --git a/tests/generic/574 b/tests/generic/574
index 5d12151079..067b3033a8 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -55,7 +55,7 @@ setup_zeroed_file()
 round_up_to_page_boundary()
 {
 	local n=$1
-	local page_size=$(get_page_size)
+	local page_size=$(_get_page_size)
 
 	echo $(( (n + page_size - 1) & ~(page_size - 1) ))
 }
diff --git a/tests/generic/636 b/tests/generic/636
index 10e658b68a..afb9df986b 100755
--- a/tests/generic/636
+++ b/tests/generic/636
@@ -24,7 +24,7 @@ _scratch_mount
 touch "$SCRATCH_MNT/swap"
 $CHATTR_PROG +C "$SCRATCH_MNT/swap" >> $seqres.full 2>&1
 chmod 0600 "$SCRATCH_MNT/swap"
-_pwrite_byte 0x61 0 $(get_page_size) "$SCRATCH_MNT/swap" >> $seqres.full
+_pwrite_byte 0x61 0 $(_get_page_size) "$SCRATCH_MNT/swap" >> $seqres.full
 "$here/src/mkswap" "$SCRATCH_MNT/swap"
 "$here/src/swapon" "$SCRATCH_MNT/swap"
 swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
diff --git a/tests/generic/641 b/tests/generic/641
index 1fd3db2adb..124f2e1dae 100755
--- a/tests/generic/641
+++ b/tests/generic/641
@@ -40,7 +40,7 @@ make_unaligned_swapfile()
 
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
-psize=`get_page_size`
+psize=`_get_page_size`
 bsize=`_get_file_block_size $SCRATCH_MNT`
 # Due to we need page-unaligned blocks, so blocksize < pagesize is necessary.
 # If not, try to make a smaller enough block size
diff --git a/tests/xfs/513 b/tests/xfs/513
index eb5ad8ee98..ce2bb34916 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -178,7 +178,7 @@ echo "** start xfs mount testing ..."
 # Test allocsize=size
 # Valid values for this option are page size (typically 4KiB) through to 1GiB
 do_mkfs
-pagesz=$(get_page_size)
+pagesz=$(_get_page_size)
 if [ $pagesz -ge 1024 ];then
 	pagesz="$((pagesz / 1024))k"
 fi
diff --git a/tests/xfs/552 b/tests/xfs/552
index 172ed2065d..cb97b2ff6c 100755
--- a/tests/xfs/552
+++ b/tests/xfs/552
@@ -30,7 +30,7 @@ mkdir $testdir
 
 echo "Create the original files"
 nr=16
-blksz=$(get_page_size)
+blksz=$(_get_page_size)
 _pwrite_byte 0x61 0 $((blksz * nr)) $testdir/testfile >> $seqres.full
 _pwrite_byte 0x62 0 $((blksz * nr)) $testdir/poisonfile >> $seqres.full
 seq 0 2 $((nr - 1)) | while read i; do
diff --git a/tests/xfs/559 b/tests/xfs/559
index 92822d26c7..cffe5045a5 100755
--- a/tests/xfs/559
+++ b/tests/xfs/559
@@ -42,7 +42,7 @@ $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
 _require_pagecache_access $SCRATCH_MNT
 
 blocks=10
-blksz=$(get_page_size)
+blksz=$(_get_page_size)
 filesz=$((blocks * blksz))
 dirty_offset=$(( filesz - 1 ))
 write_len=$(( ( (blocks - 1) * blksz) + 1 ))

