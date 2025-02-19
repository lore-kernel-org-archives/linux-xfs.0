Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3952B46B8;
	Wed, 19 Feb 2025 01:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927067; cv=none; b=Yh2tXHm4kWIA70eCrBbcqk6PNLUGyP35EuIqGit4HfVW+3zFGL6ZCVG8lgGW56n5ZFfacMb1k56Yj/DGhBcLr4xyvibZP8wH29fSojxVZH3UWYQNY+hMIOHYv8KT/gwyjw1smVwePKFA5m0BKVTuKg1ucf4qQDs9A3rkFm8fU6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927067; c=relaxed/simple;
	bh=h7g65ya5mmyPcqZEz07VTn3VcYc6Ouf+4KWupov03/U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7CZcpfPH8mCXMyLWEEUB+e1VCUI7MRuiptaTbrLZkc5zKSPTEO/T2s9QT/YAhralAK6YEt0MmWd8cVUhmg2QQdxafKNxrboyknh8lF7gXb4pssjAfBxjYZtO4LpRMgjKWt0xYRjwnI3DNT6fOnCPuJW6IPOMqpGawXCmhxeZqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyxpC8Ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyxpC8Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0615C4CEE2;
	Wed, 19 Feb 2025 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927066;
	bh=h7g65ya5mmyPcqZEz07VTn3VcYc6Ouf+4KWupov03/U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LyxpC8IbKlZqfUZuhCQtNoemDf70S34AlVbqO5QDX28mRe5CNHwrXOU3L52Gtr8/4
	 wNXE6j4IkY7b8v0oX9XHYsjYulOuzirAz+g82GfyAJ8sT0PvxmOz896nSc4/1LWxBI
	 U3R3p7iRdcLMyvCZY/9WotqWUpHxewdBuuAV4S4vexiT8FBLesDThzRprWLo1yryol
	 W0VtePI6QvAu8g0TNuUlmF9gDAlsJ/ibUpdZEw3S8YO8aTWhu/huZmnjDmcOaT2wXd
	 +CI/r1xT4Q4HIMqo1z61HrNW7qYH31rBVkfJ/euCCEuoVYeJdBP3PwobiGHKxansqW
	 UbbBadaBs+8ig==
Date: Tue, 18 Feb 2025 17:04:26 -0800
Subject: [PATCH 03/13] fuzz: for fuzzing the rtrmapbt,
 find the path to the rt rmap btree file
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591168.4080556.16741355731984742368.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The fs population code creates a realtime rmap btree in /some/ realtime
group with at least two levels.  This rmapbt file isn't necessarily the
one for group 0, so we need to find it programmatically.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |   33 +++++++++++++++++++++++++++++++++
 tests/xfs/406 |    6 ++++--
 tests/xfs/407 |    6 ++++--
 tests/xfs/408 |    7 +++++--
 tests/xfs/409 |    7 +++++--
 tests/xfs/481 |    6 ++++--
 tests/xfs/482 |    7 +++++--
 7 files changed, 60 insertions(+), 12 deletions(-)


diff --git a/common/xfs b/common/xfs
index 1a0ececde39422..1be8cbf1c563d9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1827,6 +1827,39 @@ _scratch_xfs_find_agbtree_height() {
 	return 1
 }
 
+# Find us the path to the inode containing a realtime btree with a specific
+# height.
+_scratch_xfs_find_rgbtree_height() {
+	local bt_type="$1"
+	local bt_height="$2"
+	local rgcount=$(_xfs_mount_rgcount $SCRATCH_DEV)
+	local path
+	local path_format
+	local bt_prefix
+
+	case "${bt_type}" in
+	"rmap")
+		path_format="/rtgroups/%u.rmap"
+		bt_prefix="u3.rtrmapbt"
+		;;
+	*)
+		_fail "Don't know about rt btree ${bt_type}"
+		;;
+	esac
+
+	for ((rgno = 0; rgno < rgcount; rgno++)); do
+		path="$(printf "${path_format}" "${rgno}")"
+		bt_level=$(_scratch_xfs_db -c "path -m ${path}" -c "p ${bt_prefix}.level" | awk '{print $3}')
+		# "level" is the actual level within the btree
+		if [ "${bt_level}" -eq "$((bt_height - 1))" ]; then
+			echo "${path}"
+			return 0
+		fi
+	done
+
+	return 1
+}
+
 _require_xfs_mkfs_atomicswap()
 {
 	# atomicswap can be activated on rmap or reflink filesystems.
diff --git a/tests/xfs/406 b/tests/xfs/406
index 7a6e8bdb535237..0219f4a2f2562e 100755
--- a/tests/xfs/406
+++ b/tests/xfs/406
@@ -24,10 +24,12 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 
 echo "Fuzz rtrmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'offline' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
 echo "Done fuzzing rtrmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/407 b/tests/xfs/407
index 035578b97b4793..1eff49218a86bf 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -24,10 +24,12 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 1)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 
 echo "Fuzz rtrmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'online' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
 echo "Done fuzzing rtrmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/408 b/tests/xfs/408
index 3c7d16f0e6c6b7..1d41fd0923ae4a 100755
--- a/tests/xfs/408
+++ b/tests/xfs/408
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 408
 #
-# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Populate a XFS filesystem and fuzz every rtrmapbt key/pointer field.
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
 echo "Fuzz rtrmapbt keyptrs"
-_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
 echo "Done fuzzing rtrmapbt keyptrs"
 
 # success, all done
diff --git a/tests/xfs/409 b/tests/xfs/409
index f3885e56010daa..f863b3bd4530ce 100755
--- a/tests/xfs/409
+++ b/tests/xfs/409
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 409
 #
-# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Populate a XFS filesystem and fuzz every rtrmapbt key/pointer field.
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
 echo "Fuzz rtrmapbt keyptrs"
-_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'online' "path -m $path" >> $seqres.full
 echo "Done fuzzing rtrmapbt keyptrs"
 
 # success, all done
diff --git a/tests/xfs/481 b/tests/xfs/481
index 43eb14aafb2903..a3010a76177957 100755
--- a/tests/xfs/481
+++ b/tests/xfs/481
@@ -25,10 +25,12 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 
 echo "Fuzz rtrmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'none' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
 echo "Done fuzzing rtrmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/482 b/tests/xfs/482
index 2b08b9aab2bb01..d0386448564b7c 100755
--- a/tests/xfs/482
+++ b/tests/xfs/482
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 482
 #
-# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Populate a XFS filesystem and fuzz every rtrmapbt key/pointer field.
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
@@ -25,8 +25,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
 echo "Fuzz rtrmapbt keyptrs"
-_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
 echo "Done fuzzing rtrmapbt keyptrs"
 
 # success, all done

