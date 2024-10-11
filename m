Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D433C2ED;
	Fri, 11 Oct 2024 01:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610719; cv=none; b=Jvi6LeHTMpdebzcTPhtY45sVA07H+9V7EEsUrhc/bHsqBu3xuhbFUKTWNN2GWUJoYLQdnLM3adjORYuU8XE9Y2ph39u+icYO3v/2tpsgRvcl6cRoxsfdnr+b7ye7feY8kDrMRoprI9Q6IOgB73gnItDIZodSWnlxRUemhrCAM9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610719; c=relaxed/simple;
	bh=s0ai5DTScLKwEvTTcc041vfaNz/lvK1e9d6Tni/62oY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1suulJkEOfFYFZ10Coh9Ue1GJ95RhMtSDxShApIjsuqcSuP+EtHSZDzylo4BsMpdQy24qiUCI4DQY+Nj0DQyk9MvplEnUrjIuzRfulJcuy2YUWELFDCQAhaRWiG+UP05vrsHoby6OUpTf24gEcN3f+MelUjXKfj0MLGqHK/1L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6WO2qyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6WO2qyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4337C4CEC5;
	Fri, 11 Oct 2024 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610718;
	bh=s0ai5DTScLKwEvTTcc041vfaNz/lvK1e9d6Tni/62oY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u6WO2qyDNoqfiUTn3tdJYP2Tvdp+JT7UxcqPv58+dIfJGyb8FhtY5fwtfla20YjaL
	 2Z1kTIknf+zJL1sgnd+ZZk6bz3duxNhR2/E9lV3mlz1T0UC6DwO+NDPAn8afv8aJ67
	 wLyCQNiBWo8USwDdn7wY7NfUW/JYFQz8HKJWMV//ZBRHGertAM26IkTYLciJe3SjrG
	 dz8uvi53cewb1FJkw6XEZo76+R4yga7S5OwjJrrtpKyqW2Ezhw798683yj3xaeJDfI
	 ows0YX+OmSjkNAt/7yqaqB8YTKSibuRNrS2qKvImqnxTiiIf4TJ4tRicI0nO14Pl1f
	 FLa03hz97tPmw==
Date: Thu, 10 Oct 2024 18:38:38 -0700
Subject: [PATCH 02/11] various: fix finding metadata inode numbers when
 metadir is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658028.4187056.18362387796681471507.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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
index 62e3100ee117a7..ae32710072671e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1385,7 +1385,7 @@ _scratch_get_bmx_prefix() {
 
 _scratch_get_iext_count()
 {
-	local ino=$1
+	local selector=$1
 	local whichfork=$2
 	local field=""
 
@@ -1400,7 +1400,7 @@ _scratch_get_iext_count()
 			return 1
 	esac
 
-	_scratch_xfs_get_metadata_field $field "inode $ino"
+	_scratch_xfs_get_metadata_field $field "$selector"
 }
 
 #
@@ -1870,3 +1870,20 @@ _wipe_xfs_properties()
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
index 8a182bd6a3928a..f6c88cd12e187c 100755
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
index a4f553d818c2be..a143325e3facb6 100755
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
index 971bf31e3239b1..e867d591fd99cb 100755
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
index 4e24fb4e2fef31..ea4aa75b24741b 100755
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
index eabe766d725c07..967e384f659f72 100755
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
index b5cec7d71a4002..82b87b33792cdd 100755
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
index e2d097c2f0d59f..4840e78c4427ab 100755
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
index d139aeefdd8a37..6cc3805d4c9df8 100755
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
index 696d024532982a..b6ec74524b0eaa 100755
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

