Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ECD4A04;
	Mon,  1 Jan 2024 00:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TN0KgWWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89A4C433C8;
	Mon,  1 Jan 2024 00:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070695;
	bh=6z7yiC1VU0pUBqdVF0TpynQAFvd8xb/S4LZTMWnLdN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TN0KgWWDRPxEwF+trXocEvLbGi9etZvMtaBJ5+B8jBYi3szm2YnpaomPaKn+Xlq13
	 2kRgKlHkQ3lPsIVltS3Su14ROmAWoL5+He/IT6tE4bQRBbNdfhlQlsrYr2FwRl0RaS
	 a5lOtkwCERl2VUYTVtmB3VGsyOkY8CTcBgtgccklZt3vzr/Sm2AvL1J85DVqn8LEM0
	 QG8nLGjUgYEx3YIHp70zqKikZegp1i1hcZeoZrpRToW6ktriCZc9ILdV9AhxoMVoDj
	 tyPzSeZLrtEQ9F8ZiJS6D+jXwqE3w0/NFOpRXX7H/IPzbHNH6o9PwXWZgd3xl437yq
	 kIR8opWV+6nGQ==
Date: Sun, 31 Dec 2023 16:58:15 +9900
Subject: [PATCH 02/13] fuzz: for fuzzing the rtrmapbt,
 find the path to the rt rmap btree file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031260.1826914.7202041015850827164.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

The fs population code creates a realtime rmap btree in /some/ realtime
group with at least two levels.  This rmapbt file isn't necessarily the
one for group 0, so we need to find it programmatically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
index d3baa7a7c3..b8dd8d4a40 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1914,6 +1914,39 @@ _scratch_xfs_find_agbtree_height() {
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
+		path_format="/realtime/%u.rmap"
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
index 78db18077c..8c5570886b 100755
--- a/tests/xfs/406
+++ b/tests/xfs/406
@@ -26,10 +26,12 @@ _require_scratch_xfs_fuzz_fields
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
index 5a43775b55..2460ea336c 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -26,10 +26,12 @@ _require_scratch_xfs_fuzz_fields
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
index 8049d6bead..3bed3824e8 100755
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
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
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
index adac95fea8..ce66175c6e 100755
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
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
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
index 48c7580ccb..d303f2c27d 100755
--- a/tests/xfs/481
+++ b/tests/xfs/481
@@ -27,10 +27,12 @@ _disable_dmesg_check
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
index 0192b94cc0..32a3012154 100755
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
@@ -27,8 +27,11 @@ _disable_dmesg_check
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

