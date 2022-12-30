Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C160FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiLaDHC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbiLaDGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7404DFA;
        Fri, 30 Dec 2022 19:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C707B81EA8;
        Sat, 31 Dec 2022 03:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B4DC433D2;
        Sat, 31 Dec 2022 03:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455997;
        bh=VgJ9cEz09ZH1XITN9ukLcQCzI/N0489JadDqrOTCtTI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bZoIKkTc/4HLBcljxIEa2tKJmTjjB0+pcsE3KhnIbvC6kISqD7Rd3q+7Ly+OsbOe9
         +R0dBcnsPxz80aD76y/uvVrMa1z5WnXvYK9Zytz7bv3d2Gu9UCxXnGfyglKC7Z25ek
         wnYlpnglfoQIl57n411zevgU5ZGVvNz7S2shcNKbn5nxmP0U4oLiJs2b4DEFMAOZO8
         RIMOgLLBnxwx3aXIqOJD6RveCWxHmX24SoXlY69Sxsd/T0giKmW1PE6cOTkfr9ovyr
         brUEUcn/11a8XRBhNS6LjxDkGs6GmcWIi8/VzbGnPj23CZ7Eiw17mX/7XhKfzU0cW4
         RQygw6DawPikw==
Subject: [PATCH 2/9] various: fix finding metadata inode numbers when metadir
 is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:32 -0800
Message-ID: <167243883271.736753.35967461928530874.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a number of tests that use xfs_db to examine the contents of
metadata inodes to check correct functioning.  The logic is scattered
everywhere and won't work with metadata directory trees, so make a
shared helper to find these inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs     |   32 ++++++++++++++++++++++++++++++--
 tests/xfs/007  |   16 +++++++++-------
 tests/xfs/1562 |    9 ++-------
 tests/xfs/1563 |    9 ++-------
 tests/xfs/1564 |    9 ++-------
 tests/xfs/1565 |    9 ++-------
 tests/xfs/1566 |    9 ++-------
 tests/xfs/1567 |    9 ++-------
 tests/xfs/1568 |    9 ++-------
 tests/xfs/1569 |    9 ++-------
 tests/xfs/529  |    5 ++---
 tests/xfs/530  |    6 ++----
 12 files changed, 59 insertions(+), 72 deletions(-)


diff --git a/common/xfs b/common/xfs
index 8b365ad18b..dafbd1b874 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1396,7 +1396,7 @@ _scratch_get_bmx_prefix() {
 
 _scratch_get_iext_count()
 {
-	local ino=$1
+	local selector=$1
 	local whichfork=$2
 	local field=""
 
@@ -1411,7 +1411,7 @@ _scratch_get_iext_count()
 			return 1
 	esac
 
-	_scratch_xfs_get_metadata_field $field "inode $ino"
+	_scratch_xfs_get_metadata_field $field "$selector"
 }
 
 #
@@ -1742,3 +1742,31 @@ _require_xfs_scratch_atomicswap()
 		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
 	_scratch_unmount
 }
+
+# Find a metadata file within an xfs filesystem.  The sole argument is the
+# name of the field within the superblock.
+_scratch_xfs_find_metafile()
+{
+	local metafile="$1"
+	local selector=
+
+	if ! _check_scratch_xfs_features METADIR > /dev/null; then
+		sb_field="$(_scratch_xfs_get_sb_field "$metafile")"
+		if echo "$sb_field" | grep -q -w 'not found'; then
+			return 1
+		fi
+		selector="inode $sb_field"
+	else
+		case "${metafile}" in
+		"rootino")	selector="path /";;
+		"uquotino")	selector="path -m /quota/user";;
+		"gquotino")	selector="path -m /quota/group";;
+		"pquotino")	selector="path -m /quota/project";;
+		"rbmino")	selector="path -m /realtime/bitmap";;
+		"rsumino")	selector="path -m /realtime/summary";;
+		esac
+	fi
+
+	echo "${selector}"
+	return 0
+}
diff --git a/tests/xfs/007 b/tests/xfs/007
index 4f864100fd..6d6d828b13 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -22,6 +22,11 @@ _require_xfs_quota
 _scratch_mkfs_xfs | _filter_mkfs > /dev/null 2> $tmp.mkfs
 . $tmp.mkfs
 
+get_qfile_nblocks() {
+	local selector="$(_scratch_xfs_find_metafile "$1")"
+	_scratch_xfs_db -c "$selector" -c "p core.nblocks"
+}
+
 do_test()
 {
 	qino_1=$1
@@ -31,12 +36,9 @@ do_test()
 	echo "*** umount"
 	_scratch_unmount
 
-	QINO_1=`_scratch_xfs_get_sb_field $qino_1`
-	QINO_2=`_scratch_xfs_get_sb_field $qino_2`
-
 	echo "*** Usage before quotarm ***"
-	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks"
-	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks"
+	get_qfile_nblocks $qino_1
+	get_qfile_nblocks $qino_2
 
 	_qmount
 	echo "*** turn off $off_opts quotas"
@@ -66,8 +68,8 @@ do_test()
 	_scratch_unmount
 
 	echo "*** Usage after quotarm ***"
-	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks"
-	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks"
+	get_qfile_nblocks $qino_1
+	get_qfile_nblocks $qino_2
 }
 
 # Test user and group first
diff --git a/tests/xfs/1562 b/tests/xfs/1562
index 015209eeb2..1e5b6881ee 100755
--- a/tests/xfs/1562
+++ b/tests/xfs/1562
@@ -27,13 +27,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.bitmap')
-else
-	path=('sb' 'addr rbmino')
-fi
-_scratch_xfs_fuzz_metadata '' 'online' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rbmino)"
+_scratch_xfs_fuzz_metadata '' 'online' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
 # success, all done
diff --git a/tests/xfs/1563 b/tests/xfs/1563
index 2be0870a3d..a9da78106d 100755
--- a/tests/xfs/1563
+++ b/tests/xfs/1563
@@ -27,13 +27,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.summary')
-else
-	path=('sb' 'addr rsumino')
-fi
-_scratch_xfs_fuzz_metadata '' 'online' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rsumino)"
+_scratch_xfs_fuzz_metadata '' 'online' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
 # success, all done
diff --git a/tests/xfs/1564 b/tests/xfs/1564
index c0d10ff0e9..4482861d50 100755
--- a/tests/xfs/1564
+++ b/tests/xfs/1564
@@ -27,13 +27,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.bitmap')
-else
-	path=('sb' 'addr rbmino')
-fi
-_scratch_xfs_fuzz_metadata '' 'offline' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rbmino)"
+_scratch_xfs_fuzz_metadata '' 'offline' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
 # success, all done
diff --git a/tests/xfs/1565 b/tests/xfs/1565
index 6b4186fb3c..c43ccd848e 100755
--- a/tests/xfs/1565
+++ b/tests/xfs/1565
@@ -27,13 +27,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.summary')
-else
-	path=('sb' 'addr rsumino')
-fi
-_scratch_xfs_fuzz_metadata '' 'offline' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rsumino)"
+_scratch_xfs_fuzz_metadata '' 'offline' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
 # success, all done
diff --git a/tests/xfs/1566 b/tests/xfs/1566
index 8d0f61ae10..aad4fafb15 100755
--- a/tests/xfs/1566
+++ b/tests/xfs/1566
@@ -28,13 +28,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.bitmap')
-else
-	path=('sb' 'addr rbmino')
-fi
-_scratch_xfs_fuzz_metadata '' 'both' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rbmino)"
+_scratch_xfs_fuzz_metadata '' 'both' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
 # success, all done
diff --git a/tests/xfs/1567 b/tests/xfs/1567
index 7dc2012b67..ff782fc239 100755
--- a/tests/xfs/1567
+++ b/tests/xfs/1567
@@ -28,13 +28,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.summary')
-else
-	path=('sb' 'addr rsumino')
-fi
-_scratch_xfs_fuzz_metadata '' 'both' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rsumino)"
+_scratch_xfs_fuzz_metadata '' 'both' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
 # success, all done
diff --git a/tests/xfs/1568 b/tests/xfs/1568
index c80640ef97..e2a28df58a 100755
--- a/tests/xfs/1568
+++ b/tests/xfs/1568
@@ -27,13 +27,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.bitmap')
-else
-	path=('sb' 'addr rbmino')
-fi
-_scratch_xfs_fuzz_metadata '' 'none' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rbmino)"
+_scratch_xfs_fuzz_metadata '' 'none' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
 # success, all done
diff --git a/tests/xfs/1569 b/tests/xfs/1569
index e303f08ff5..dcb07440e8 100755
--- a/tests/xfs/1569
+++ b/tests/xfs/1569
@@ -27,13 +27,8 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
-if [ -n "$is_metadir" ]; then
-	path=('path -m /realtime/0.summary')
-else
-	path=('sb' 'addr rsumino')
-fi
-_scratch_xfs_fuzz_metadata '' 'none' "${path[@]}" 'dblock 0' >> $seqres.full
+path="$(_scratch_xfs_find_metafile rsumino)"
+_scratch_xfs_fuzz_metadata '' 'none' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
 # success, all done
diff --git a/tests/xfs/529 b/tests/xfs/529
index 83d24da0ac..e10af6753b 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -159,9 +159,8 @@ done
 _scratch_unmount >> $seqres.full
 
 echo "Verify uquota inode's extent count"
-uquotino=$(_scratch_xfs_get_metadata_field 'uquotino' 'sb 0')
-
-nextents=$(_scratch_get_iext_count $uquotino data || \
+selector="$(_scratch_xfs_find_metafile uquotino)"
+nextents=$(_scratch_get_iext_count "$selector" data || \
 		   _fail "Unable to obtain inode fork's extent count")
 if (( $nextents > 10 )); then
 	echo "Extent count overflow check failed: nextents = $nextents"
diff --git a/tests/xfs/530 b/tests/xfs/530
index 56f5e7ebdb..cb8c2e3978 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -104,10 +104,8 @@ _scratch_unmount >> $seqres.full
 
 echo "Verify rbmino's and rsumino's extent count"
 for rtino in rbmino rsumino; do
-	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
-	echo "$rtino = $ino" >> $seqres.full
-
-	nextents=$(_scratch_get_iext_count $ino data || \
+	selector="$(_scratch_xfs_find_metafile "$rtino")"
+	nextents=$(_scratch_get_iext_count "$selector" data || \
 			_fail "Unable to obtain inode fork's extent count")
 	if (( $nextents > 10 )); then
 		echo "Extent count overflow check failed: nextents = $nextents"

