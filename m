Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7476FBF6;
	Fri, 11 Oct 2024 01:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611109; cv=none; b=Q7SKRPiLvnDSuaVGeo6LyI/I94r9NepLeadenmPGDTgi+Q0ObY0tEl4kflONvZFJS5D3ZYcAaB+d9e0rwpx5rayGSIrKKDLu1NQiMw1hfkgbwFvvk7KdUUZoPVh/lH+9GQRMWeMXouBtmWZaScmIP8RiZOkaTp/sLOAjtDOBfws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611109; c=relaxed/simple;
	bh=xQg+Hp2UiOLeM2kkTZTskVi/1Vrnnwj5ZBTvCrU+WSs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJnaB5Vdnn2/Rus5wLkgGVi/A3HXCXBetLTM1ztR0daPaO0PJJEqwFAdsO+mtPQxBxSHDx7RqMaMvU0xkHaD+nqOfUrA8O1C8QmEefIWbmsoHzVyfJ7+KDfVc2/N/qFr9oLp5R3Ra7pcMChRQUOdTsDfkUnTrLzJ1QPtRfEx9C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5PDIw1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5PDIw1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49984C4CEC5;
	Fri, 11 Oct 2024 01:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611109;
	bh=xQg+Hp2UiOLeM2kkTZTskVi/1Vrnnwj5ZBTvCrU+WSs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O5PDIw1GwrvVEsfNrrwr1zD/+WP9XPqoX6LNg44bHFteWJhOpTaknMcvX0kIa4szD
	 92JVX+m976wU5zXwUU1EH0G1l5AL+46NVSmnAdwqbMFRngo0lGo9QSGIZt2ybtozM3
	 55sLf6j+8BG/CEuBaKWYDkE4eprKT8evsM/jl7V2usHGl5J5FhL4vb2N/7o8/m8E9c
	 SwZ22T/ZtdmH+bL+9JZUtdwW3IwRiQu8szRQKqeMw+Tqmmy3IfYxBlmpjbmzu3QIQi
	 kYpqnQetzNBZQbCIhjBVrVhiVwNebpZf8ZGCi5KuBgw5tfTCU3WOndM5VG3w2jF1z2
	 SR2JuGiG5D+3Q==
Date: Thu, 10 Oct 2024 18:45:08 -0700
Subject: [PATCH 16/16] xfs: fix fuzz tests of rtgroups bitmap and summary
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658765.4188964.5049650273332581384.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

With rtgroups, the rt bitmap and summary files are now per-group, so
adjust the fuzz and fsck tests to find the new locations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
index 9036fdb363904e..6bd411cad67f5f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1932,6 +1932,25 @@ _scratch_xfs_find_metafile()
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
index 3af9ef8a19c0bb..1bac2d5b6739a0 100755
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
index f390b77f3439ee..c949e14899788a 100755
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
index a143325e3facb6..1fcae151f007d1 100755
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
index e867d591fd99cb..74c37312b088f1 100755
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
index ea4aa75b24741b..95b7c5f01646b5 100755
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
index 967e384f659f72..50dd387fae3456 100755
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
index 82b87b33792cdd..c8129b76a87e33 100755
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
index 4840e78c4427ab..9382676fbb2707 100755
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
index 6cc3805d4c9df8..be61f4bc463a18 100755
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
index b6ec74524b0eaa..84600ab755a5aa 100755
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
index d942d9807967b5..59080467e90606 100755
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

