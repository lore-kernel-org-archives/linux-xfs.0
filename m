Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417131F91D4;
	Thu, 16 Jan 2025 23:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070724; cv=none; b=B7K+yYVHACK/mtIvL2SQHW2A+sjnCn6IM5lXyJ9m8qgCoBGUSjUjJPLOTOpMqxNXWuCAoRHCKKfnJFAWMW8ol5Amz08IPDa/xbWNQOm27S6o1d5EythONBI4m80ZKFrbPgnQ498CPeMAWKAHhOoqfJSXHV0IPQ3p7FNTcAASCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070724; c=relaxed/simple;
	bh=KpyB4PUV2mWZYH4zeUxxOw+bvtin+sw/bMUjNntUZoE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nuT7UHH5biwnwyx+BY1mKiR+5+b+IfWopvCsirkgmVXdmGQkmQUZARzscfYPU8KuygQSXjO5jRwfKswENqsCeG8mwpjn1nw04t15t9hx8tmu2PwN9pjiHu31nZmCY1I/VsE0mASBNnmeBorXHzekUgRugIiN6NvgV5Jdq8L7AIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgEDG54I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgEDG54I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFBCC4CED6;
	Thu, 16 Jan 2025 23:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070724;
	bh=KpyB4PUV2mWZYH4zeUxxOw+bvtin+sw/bMUjNntUZoE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KgEDG54I0s9Kw/GGb8k4sEDWfSg0+7Ux5wjgyn926MlgRGpUHI+1OkByuFOIM8lSO
	 hsNwvyjh9vk8p3M2ujNgU88sBhu/QB7kNON3SfcCIADTA9BoHfWSFpbYhaWf4JkiVr
	 zYbjjb7+SwZ/2spNCHsqY1jm8KKo8m/mg89k8bpbWIEblhWD51ab5NSXxSjdhG8CNx
	 NORRKCHnK/2PBVjRBfM+v9I1INNna1P+/zE52/324Gq3gFFbeUmkt1/Utjn26QZ+89
	 9TGnyJmmb25iZ6sWaKlyFFfzj3JhWdhGAK9PvUoQjrEe4Qy7ShwACEX3x0dH7lVhAb
	 CTNCISsJ9D3qw==
Date: Thu, 16 Jan 2025 15:38:43 -0800
Subject: [PATCH 14/14] xfs: fix fuzz tests of rtgroups bitmap and summary
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976278.1928798.16957823477897463484.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

With rtgroups, the rt bitmap and summary files are now per-group, so
adjust the fuzz and fsck tests to find the new locations.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |   19 +++++++++++++++++++
 tests/xfs/581 |    9 ++++++++-
 tests/xfs/582 |   14 +++++++-------
 tests/xfs/739 |    6 +++++-
 tests/xfs/740 |    6 +++++-
 tests/xfs/741 |    6 +++++-
 tests/xfs/742 |    6 +++++-
 tests/xfs/743 |    6 +++++-
 tests/xfs/744 |    6 +++++-
 tests/xfs/745 |    6 +++++-
 tests/xfs/746 |    6 +++++-
 tests/xfs/793 |   14 +++++++-------
 12 files changed, 81 insertions(+), 23 deletions(-)


diff --git a/common/xfs b/common/xfs
index 49fb2ea7e7894e..aa635f8b4745fa 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1956,6 +1956,25 @@ _scratch_xfs_find_metafile()
 	local metafile="$1"
 	local sb_field
 
+	# With metadir=1, the realtime volume is sharded into allocation
+	# groups.  Each rtgroup has its own bitmap and summary file.  Tests
+	# should pick a particular file, but this compatibility shim still
+	# exists to keep old tests working.
+	case "$metafile" in
+	"rbmino")
+		if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+			echo "path -m /rtgroups/0.bitmap"
+			return 0
+		fi
+		;;
+	"rsumino")
+		if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+			echo "path -m /rtgroups/0.summary"
+			return 0
+		fi
+		;;
+	esac
+
 	sb_field="$(_scratch_xfs_get_sb_field "$metafile")"
 	if echo "$sb_field" | grep -q -w 'not found'; then
 		return 1
diff --git a/tests/xfs/581 b/tests/xfs/581
index 6aa360b37b90c5..7d79dbcad70149 100755
--- a/tests/xfs/581
+++ b/tests/xfs/581
@@ -30,7 +30,14 @@ _require_xfs_stress_scrub
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" realtime
-_scratch_xfs_stress_scrub -s "scrub rtbitmap"  -s "scrub rgbitmap %rgno%"
+
+if _xfs_has_feature "$SCRATCH_MNT" rtgroups; then
+	_scratch_xfs_stress_scrub -s "scrub rtbitmap %rgno%"
+elif xfs_io -c 'help scrub' | grep -q rgsuper; then
+	_scratch_xfs_stress_scrub -s "scrub rtbitmap 0"
+else
+	_scratch_xfs_stress_scrub -s "scrub rtbitmap"
+fi
 
 # success, all done
 echo Silence is golden
diff --git a/tests/xfs/582 b/tests/xfs/582
index e92f128f8a5695..a2cc58c04bf8d2 100755
--- a/tests/xfs/582
+++ b/tests/xfs/582
@@ -31,13 +31,13 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" realtime
 
-# XXX the realtime summary scrubber isn't currently implemented upstream.
-# Don't bother trying to test it on those kernels
-$XFS_IO_PROG -c 'scrub rtsummary' -c 'scrub rtsummary' "$SCRATCH_MNT" 2>&1 | \
-	grep -q 'Scan was not complete' && \
-	_notrun "rtsummary scrub is incomplete"
-
-_scratch_xfs_stress_scrub -s "scrub rtsummary"
+if _xfs_has_feature "$SCRATCH_MNT" rtgroups; then
+	_scratch_xfs_stress_scrub -s "scrub rtsummary %rgno%"
+elif xfs_io -c 'help scrub' | grep -q rgsuper; then
+	_scratch_xfs_stress_scrub -s "scrub rtsummary 0"
+else
+	_scratch_xfs_stress_scrub -s "scrub rtsummary"
+fi
 
 # success, all done
 echo Silence is golden
diff --git a/tests/xfs/739 b/tests/xfs/739
index 5fd6caa5bce2f8..77cceac7ac7f02 100755
--- a/tests/xfs/739
+++ b/tests/xfs/739
@@ -25,7 +25,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-path="$(_scratch_xfs_find_metafile rbmino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.bitmap"
+else
+	path="$(_scratch_xfs_find_metafile rbmino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'online' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
diff --git a/tests/xfs/740 b/tests/xfs/740
index c8990034773b32..fe5d054956d5e2 100755
--- a/tests/xfs/740
+++ b/tests/xfs/740
@@ -25,7 +25,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-path="$(_scratch_xfs_find_metafile rsumino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.summary"
+else
+	path="$(_scratch_xfs_find_metafile rsumino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'online' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
diff --git a/tests/xfs/741 b/tests/xfs/741
index 96c2315c524311..35f78aab7faead 100755
--- a/tests/xfs/741
+++ b/tests/xfs/741
@@ -25,7 +25,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-path="$(_scratch_xfs_find_metafile rbmino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.bitmap"
+else
+	path="$(_scratch_xfs_find_metafile rbmino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'offline' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
diff --git a/tests/xfs/742 b/tests/xfs/742
index 301ae7b9574320..04087c1a224558 100755
--- a/tests/xfs/742
+++ b/tests/xfs/742
@@ -25,7 +25,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-path="$(_scratch_xfs_find_metafile rsumino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.summary"
+else
+	path="$(_scratch_xfs_find_metafile rsumino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'offline' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
diff --git a/tests/xfs/743 b/tests/xfs/743
index 039624f711c0a6..1e70147fa3bcef 100755
--- a/tests/xfs/743
+++ b/tests/xfs/743
@@ -26,7 +26,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-path="$(_scratch_xfs_find_metafile rbmino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.bitmap"
+else
+	path="$(_scratch_xfs_find_metafile rbmino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'both' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
diff --git a/tests/xfs/744 b/tests/xfs/744
index 13f63b9ceb1756..0db3dd617c2d1f 100755
--- a/tests/xfs/744
+++ b/tests/xfs/744
@@ -26,7 +26,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-path="$(_scratch_xfs_find_metafile rsumino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.summary"
+else
+	path="$(_scratch_xfs_find_metafile rsumino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'both' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
diff --git a/tests/xfs/745 b/tests/xfs/745
index 56a6d58ef9f4ca..acfbe72597fd5a 100755
--- a/tests/xfs/745
+++ b/tests/xfs/745
@@ -25,7 +25,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtbitmap"
-path="$(_scratch_xfs_find_metafile rbmino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.bitmap"
+else
+	path="$(_scratch_xfs_find_metafile rbmino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'none' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtbitmap"
 
diff --git a/tests/xfs/746 b/tests/xfs/746
index 935b2e5acba5d4..0d1ab895aacd62 100755
--- a/tests/xfs/746
+++ b/tests/xfs/746
@@ -25,7 +25,11 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Fuzz rtsummary"
-path="$(_scratch_xfs_find_metafile rsumino)"
+if _xfs_has_feature "$SCRATCH_DEV" rtgroups; then
+	path="path -m /rtgroups/0.summary"
+else
+	path="$(_scratch_xfs_find_metafile rsumino)"
+fi
 _scratch_xfs_fuzz_metadata '' 'none' "$path" 'dblock 0' >> $seqres.full
 echo "Done fuzzing rtsummary"
 
diff --git a/tests/xfs/793 b/tests/xfs/793
index a779bf81738537..07c64e7a3f9744 100755
--- a/tests/xfs/793
+++ b/tests/xfs/793
@@ -32,13 +32,13 @@ _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" realtime
 _xfs_force_bdev realtime $SCRATCH_MNT
 
-# XXX the realtime summary scrubber isn't currently implemented upstream.
-# Don't bother trying to fix it on those kernels
-$XFS_IO_PROG -c 'scrub rtsummary' -c 'scrub rtsummary' "$SCRATCH_MNT" 2>&1 | \
-	grep -q 'Scan was not complete' && \
-	_notrun "rtsummary scrub is incomplete"
-
-_scratch_xfs_stress_online_repair -s "repair rtsummary"
+if _xfs_has_feature "$SCRATCH_MNT" rtgroups; then
+	_scratch_xfs_stress_online_repair -s "repair rtsummary %rgno%"
+elif xfs_io -c 'help scrub' | grep -q rgsuper; then
+	_scratch_xfs_stress_online_repair -s "repair rtsummary 0"
+else
+	_scratch_xfs_stress_online_repair -s "repair rtsummary"
+fi
 
 # success, all done
 echo Silence is golden

