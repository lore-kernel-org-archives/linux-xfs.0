Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1EC7EF;
	Mon,  1 Jan 2024 00:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcaPqKPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03217C433C8;
	Mon,  1 Jan 2024 00:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070226;
	bh=CHj6s+oDPlAfT6Agql0hXOemothI/GUiBRbW34S3Cuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kcaPqKPc+0Bssm2H5BkrKtnKKujqGhp782lspohtoXW4PNJKoLzoOdYs2MMtHb8xN
	 oQb+ripKE3+y1VLvAxESZ7oR+wIQljWD4nh6FbxuBXiM/FSNffO/AL0Mxlky6+cixv
	 2SWucVHJSRl7II7TvH+tAqgkLXk6312CKbTOy1asq8LwVM1X0IGrQsufSnE83VsFR0
	 0sVLZvmhqLkpAsnebD5x1FVaUfRQbVq4+Rz+CjwRZ082fHoAoi+j6exwU69mhZbWXC
	 2yDg2jQtlejLone/3divKVTiUpwzyjeLaM4GPi81kn38RI8intqsYQ2YrfTqaBtQAH
	 YCSo6Ne76F9yQ==
Date: Sun, 31 Dec 2023 16:50:25 +9900
Subject: [PATCH 02/11] various: fix finding metadata inode numbers when
 metadir is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029875.1826032.15574802393255784135.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   32 ++++++++++++++++++++++++++++++--
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
 12 files changed, 59 insertions(+), 72 deletions(-)


diff --git a/common/xfs b/common/xfs
index f77d4639b9..48643b7c18 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1422,7 +1422,7 @@ _scratch_get_bmx_prefix() {
 
 _scratch_get_iext_count()
 {
-	local ino=$1
+	local selector=$1
 	local whichfork=$2
 	local field=""
 
@@ -1437,7 +1437,7 @@ _scratch_get_iext_count()
 			return 1
 	esac
 
-	_scratch_xfs_get_metadata_field $field "inode $ino"
+	_scratch_xfs_get_metadata_field $field "$selector"
 }
 
 #
@@ -1843,3 +1843,31 @@ _require_xfs_parent()
 		|| _notrun "kernel does not support parent pointers"
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
diff --git a/tests/xfs/529 b/tests/xfs/529
index cd176877f5..43199a37ff 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -163,9 +163,8 @@ done
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
diff --git a/tests/xfs/739 b/tests/xfs/739
index fb7fe2e643..b6bbaf7c1d 100755
--- a/tests/xfs/739
+++ b/tests/xfs/739
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
diff --git a/tests/xfs/740 b/tests/xfs/740
index a59fa37ecf..7cee2b110f 100755
--- a/tests/xfs/740
+++ b/tests/xfs/740
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
diff --git a/tests/xfs/741 b/tests/xfs/741
index 957bed791b..1d18f4d9e4 100755
--- a/tests/xfs/741
+++ b/tests/xfs/741
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
diff --git a/tests/xfs/742 b/tests/xfs/742
index d911748443..96ef89275c 100755
--- a/tests/xfs/742
+++ b/tests/xfs/742
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
diff --git a/tests/xfs/743 b/tests/xfs/743
index 69e865a438..29f21e32c6 100755
--- a/tests/xfs/743
+++ b/tests/xfs/743
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
diff --git a/tests/xfs/744 b/tests/xfs/744
index ea490b524e..72ae8f8593 100755
--- a/tests/xfs/744
+++ b/tests/xfs/744
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
diff --git a/tests/xfs/745 b/tests/xfs/745
index 7621d45744..caecaa4edd 100755
--- a/tests/xfs/745
+++ b/tests/xfs/745
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
diff --git a/tests/xfs/746 b/tests/xfs/746
index 401233162c..f005893965 100755
--- a/tests/xfs/746
+++ b/tests/xfs/746
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

