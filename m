Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FA41F1506;
	Thu, 16 Jan 2025 23:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070333; cv=none; b=bdtn5RE5DGBX5xKbltRzXa0S2CC1PDYIsQpY577mOunbkb86y+RHVKzlMnhEQDVGz7vxbhoyFyPvOdS/PVXQOi5Ky/Vcua4nAvvrYwFoYPHJ06KHCuufPabqBIZHE/Si8pSh5DR+iKtr7c0WjMJGA4+ii7Mn+Hdn8coE+ZJSoQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070333; c=relaxed/simple;
	bh=jWTgIPZulYRTdqG8E1uS+mbp2fiKKtVNN0C5jVOQFFw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDuaW/PfiX4fOiTtzeI/zbRFupajfj5cEWLqr5r9O/FPnZ9nW5TmTIJKRRjK9DfIuavpdeGWBYFhQhzHqxp/M6PYYxtbW66IfINFsNe8wEkft3rNipD4O7sWj673hc4E6URymn4siHf1NvjzAiisqALtvU+Gq/SdDYG33DjgYcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=id4+aG2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="id4+aG2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF023C4CED6;
	Thu, 16 Jan 2025 23:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070333;
	bh=jWTgIPZulYRTdqG8E1uS+mbp2fiKKtVNN0C5jVOQFFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=id4+aG2kfoNsaFdn70CKQTs5cf2EaLR7F7sgWvI07/x55z730RnLe5dNF/SYXEMXp
	 cZLxMZ8Um+xwG9rb4rantZqxK0Ps5QxOo9bEKzIiQTYPzRNCEZfVxj6DAIvRaxQqr5
	 4VkARkKr+xebt+7/FOoID1anxJGpIqs1fuhJoRJx2qfrlQRQh5JftPWY98nc0Ydesi
	 f/dnEKHP81jnOUA8u/bfLblfH7wAiJr39USoGJTCqKXyuDwAVSam2itp/0nb0LwEHZ
	 Wl/V/ERpokA2+PrOmBmYI7UBtjR9N/38TnJeiQOdUbCY7KJFn418i8cm1Nu6YynvYU
	 t/3f1rzIaJcOw==
Date: Thu, 16 Jan 2025 15:32:12 -0800
Subject: [PATCH 01/11] various: fix finding metadata inode numbers when
 metadir is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975181.1928284.18198198372285762402.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There are a number of tests that use xfs_db to examine the contents of
metadata inodes to check correct functioning.  The logic is scattered
everywhere and won't work with metadata directory trees, so make a
shared helper to find these inodes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |   21 +++++++++++++++++++--
 tests/xfs/007 |   16 +++++++++-------
 tests/xfs/529 |    5 ++---
 tests/xfs/530 |    6 ++----
 tests/xfs/739 |    9 ++-------
 tests/xfs/740 |    9 ++-------
 tests/xfs/741 |    9 ++-------
 tests/xfs/742 |    9 ++-------
 tests/xfs/743 |    9 ++-------
 tests/xfs/744 |    9 ++-------
 tests/xfs/745 |    9 ++-------
 tests/xfs/746 |    9 ++-------
 12 files changed, 48 insertions(+), 72 deletions(-)


diff --git a/common/xfs b/common/xfs
index c68bd6d7c773ac..092b3dc6f3bdc5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1406,7 +1406,7 @@ _scratch_get_bmx_prefix() {
 
 _scratch_get_iext_count()
 {
-	local ino=$1
+	local selector=$1
 	local whichfork=$2
 	local field=""
 
@@ -1421,7 +1421,7 @@ _scratch_get_iext_count()
 			return 1
 	esac
 
-	_scratch_xfs_get_metadata_field $field "inode $ino"
+	_scratch_xfs_get_metadata_field $field "$selector"
 }
 
 #
@@ -1891,3 +1891,20 @@ _wipe_xfs_properties()
 		setfattr --remove="$name" "$1"
 	done
 }
+
+# Return the xfs_db selector for a superblock-rooted metadata file on the
+# scratch filesystem.  The sole argument is the name of the field within the
+# superblock.  This helper cannot be used to find files under the metadata
+# directory tree.
+_scratch_xfs_find_metafile()
+{
+	local metafile="$1"
+	local sb_field
+
+	sb_field="$(_scratch_xfs_get_sb_field "$metafile")"
+	if echo "$sb_field" | grep -q -w 'not found'; then
+		return 1
+	fi
+	echo "inode $sb_field"
+	return 0
+}
diff --git a/tests/xfs/007 b/tests/xfs/007
index 2535f04cac36a5..e35a069f9bd5c5 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -21,6 +21,11 @@ _require_xfs_quota
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
@@ -30,12 +35,9 @@ do_test()
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
@@ -65,8 +67,8 @@ do_test()
 	_scratch_unmount
 
 	echo "*** Usage after quotarm ***"
-	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks"
-	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks"
+	get_qfile_nblocks $qino_1
+	get_qfile_nblocks $qino_2
 }
 
 # Test user and group first
diff --git a/tests/xfs/529 b/tests/xfs/529
index 14bdd2eebf7047..aab8668c76f46c 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -161,9 +161,8 @@ done
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
index 95ab32f1e1f828..4a41127e3b820f 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -102,10 +102,8 @@ _scratch_unmount >> $seqres.full
 
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
diff --git a/tests/xfs/739 b/tests/xfs/739
index 52c90b91b218df..5fd6caa5bce2f8 100755
--- a/tests/xfs/739
+++ b/tests/xfs/739
@@ -25,13 +25,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/740 b/tests/xfs/740
index fb616a16362a6c..c8990034773b32 100755
--- a/tests/xfs/740
+++ b/tests/xfs/740
@@ -25,13 +25,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/741 b/tests/xfs/741
index ea1c2d98516fdb..96c2315c524311 100755
--- a/tests/xfs/741
+++ b/tests/xfs/741
@@ -25,13 +25,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/742 b/tests/xfs/742
index bbc186f8472b64..301ae7b9574320 100755
--- a/tests/xfs/742
+++ b/tests/xfs/742
@@ -25,13 +25,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/743 b/tests/xfs/743
index 8021d7ecdc9009..039624f711c0a6 100755
--- a/tests/xfs/743
+++ b/tests/xfs/743
@@ -26,13 +26,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/744 b/tests/xfs/744
index 0e719dcebf03d2..13f63b9ceb1756 100755
--- a/tests/xfs/744
+++ b/tests/xfs/744
@@ -26,13 +26,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/745 b/tests/xfs/745
index 3549ad08772c2c..56a6d58ef9f4ca 100755
--- a/tests/xfs/745
+++ b/tests/xfs/745
@@ -25,13 +25,8 @@ echo "Format and populate"
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
diff --git a/tests/xfs/746 b/tests/xfs/746
index 5afc71ad19c6e6..935b2e5acba5d4 100755
--- a/tests/xfs/746
+++ b/tests/xfs/746
@@ -25,13 +25,8 @@ echo "Format and populate"
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

