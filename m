Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B66199FBA;
	Wed, 19 Feb 2025 01:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926862; cv=none; b=UQ5g+Lk8E1cP3E1HObXlmsnmdc4Bu42O57DutzwZ2UR+ZdlzbBp2uLkW6YGS9DgqtmnLuBaZc3BRCKBNYOaRBJnzmejGYI14eS/rql7mkjuXmOnqbqgJOy9UTP7SJB3MnOJGlKmZBO5+d+Vt3tOzOB61vUakCzqIaIn3ESWXXOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926862; c=relaxed/simple;
	bh=bhX4iR5LgKi29v4RzC9PQzU+rUhe8fQhHSryhi8i6Bg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gXwJJxnvAAY3jIelFNwhwtJrAkcjf02JnPi/fpxMztYb4LejEPeS5UO92baoont3OMIDKnEecfsmV4G0guOJBxSxYp+XBiAwUR9F9tXX9EwZTkSb7zoHnlLfOyCnae1mTbuMzZsRF8o0Xl20ritphebgi4V3NqkdnbLedBcs/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNYrYp6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNYrYp6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1C9C4CEE2;
	Wed, 19 Feb 2025 01:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926861;
	bh=bhX4iR5LgKi29v4RzC9PQzU+rUhe8fQhHSryhi8i6Bg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HNYrYp6um5tnaD0+xJYMCLaLaas/CXvg6WXWKi9L2clMKavpsaqDtWXRXzB7+N08t
	 MNCVX6AUg02t8tfNFvbwAd7n6Kx17tmkPP17BwlKleQqKGwGcSC5nTNq20XB1yTdrz
	 bGI+Dt0j2qykM0gThkCmRGCCEhY/aKG08qlr4NEaWYrYEVlU7juvmFJ/31VREY+MvR
	 dy4CtJoErMBCj35LzKo6JOzDwka1yqkMxhXdsF/lkcTsmtnh1rzshXU0pRrmweHI8h
	 iKqZTvyNcQ2tBsYBtwokD52vUQpUPtccvt0p8yoFdqYd+P+cHeMP00kgNWKoIVs2he
	 bYBEDCAXo8SXw==
Date: Tue, 18 Feb 2025 17:01:00 -0800
Subject: [PATCH 13/15] common/xfs: capture realtime devices during
 metadump/mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589419.4079457.7193155898233380338.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If xfs_metadump supports the -r switch to capture the contents of
realtime devices and there is a realtime device, add the option to the
command line to enable preservation.

Similarly, if the dump file could restore to an external scratch rtdev,
pass the -r option to mdrestore so that we can restore rtdev contents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/metadump |   22 ++++++++++++++++++----
 common/populate |    6 +++++-
 common/xfs      |   48 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 63 insertions(+), 13 deletions(-)


diff --git a/common/metadump b/common/metadump
index a4ec9a7f921acf..61ba3cbb91647c 100644
--- a/common/metadump
+++ b/common/metadump
@@ -27,6 +27,7 @@ _xfs_cleanup_verify_metadump()
 	if [ -n "$XFS_METADUMP_IMG" ]; then
 		[ -b "$METADUMP_DATA_LOOP_DEV" ] && _destroy_loop_device $METADUMP_DATA_LOOP_DEV
 		[ -b "$METADUMP_LOG_LOOP_DEV" ] && _destroy_loop_device $METADUMP_LOG_LOOP_DEV
+		[ -b "$METADUMP_RT_LOOP_DEV" ] && _destroy_loop_device $METADUMP_RT_LOOP_DEV
 		for img in "$XFS_METADUMP_IMG"*; do
 			test -e "$img" && rm -f "$img"
 		done
@@ -101,6 +102,7 @@ _xfs_verify_metadump_v2()
 	local version="-v 2"
 	local data_img="$XFS_METADUMP_IMG.data"
 	local log_img=""
+	local rt_img=""
 
 	# Capture metadump, which creates metadump_file
 	_scratch_xfs_metadump $metadump_file $metadump_args $version
@@ -111,8 +113,12 @@ _xfs_verify_metadump_v2()
 	# from such a metadump file.
 	test -n "$SCRATCH_LOGDEV" && log_img="$XFS_METADUMP_IMG.log"
 
+	# Use a temporary file to hold restored rt device contents
+	test -n "$SCRATCH_RTDEV" && _xfs_metadump_supports_rt && \
+		rt_img="$XFS_METADUMP_IMG.rt"
+
 	# Restore metadump, which creates data_img and log_img
-	SCRATCH_DEV=$data_img SCRATCH_LOGDEV=$log_img \
+	SCRATCH_DEV=$data_img SCRATCH_LOGDEV=$log_img SCRATCH_RTDEV=$rt_img \
 		_scratch_xfs_mdrestore $metadump_file
 
 	# Create loopdev for data device so we can mount the fs
@@ -121,12 +127,15 @@ _xfs_verify_metadump_v2()
 	# Create loopdev for log device if we recovered anything
 	test -s "$log_img" && METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
 
+	# Create loopdev for rt device if we recovered anything
+	test -s "$rt_img" && METADUMP_RT_LOOP_DEV=$(_create_loop_device $rt_img)
+
 	# Mount fs, run an extra test, fsck, and unmount
-	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV _scratch_mount
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV SCRATCH_RTDEV=$METADUMP_RT_LOOP_DEV _scratch_mount
 	if [ -n "$extra_test" ]; then
-		SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV $extra_test
+		SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV SCRATCH_RTDEV=$METADUMP_RT_LOOP_DEV $extra_test
 	fi
-	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV _check_xfs_scratch_fs
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV SCRATCH_RTDEV=$METADUMP_RT_LOOP_DEV _check_xfs_scratch_fs
 	_unmount $METADUMP_DATA_LOOP_DEV
 
 	# Tear down what we created
@@ -135,6 +144,11 @@ _xfs_verify_metadump_v2()
 		unset METADUMP_LOG_LOOP_DEV
 		rm -f $log_img
 	fi
+	if [ -b "$METADUMP_RT_LOOP_DEV" ]; then
+		_destroy_loop_device $METADUMP_RT_LOOP_DEV
+		unset METADUMP_RT_LOOP_DEV
+		rm -f $rt_img
+	fi
 	_destroy_loop_device $METADUMP_DATA_LOOP_DEV
 	unset METADUMP_DATA_LOOP_DEV
 	rm -f $data_img
diff --git a/common/populate b/common/populate
index 9fc1ee32bd490d..a77d1b0f5f3873 100644
--- a/common/populate
+++ b/common/populate
@@ -1061,12 +1061,16 @@ _scratch_populate_save_metadump()
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 
+		local rtdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+			rtdev=$SCRATCH_RTDEV
+
 		mdargs=('-a' '-o')
 		test "$(_xfs_metadump_max_version)" -gt 1 && \
 			mdargs+=('-v' '2')
 
 		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
-				compress "${mdargs[@]}"
+				"$rtdev" compress "${mdargs[@]}"
 		res=$?
 		;;
 	"ext2"|"ext3"|"ext4")
diff --git a/common/xfs b/common/xfs
index 5a829637dc1cfb..a94b9de032f932 100644
--- a/common/xfs
+++ b/common/xfs
@@ -625,14 +625,19 @@ _xfs_metadump() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	local compressopt="$4"
-	shift; shift; shift; shift
+	local rtdev="$4"
+	local compressopt="$5"
+	shift; shift; shift; shift; shift
 	local options="$@"
 
 	if [ "$logdev" != "none" ]; then
 		options="$options -l $logdev"
 	fi
 
+	if [ "$rtdev" != "none" ] && _xfs_metadump_supports_rt; then
+		options="$options -r $rtdev"
+	fi
+
 	$XFS_METADUMP_PROG $options "$device" "$metadump"
 	res=$?
 	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
@@ -656,7 +661,8 @@ _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	shift; shift; shift
+	local rtdev="$4"
+	shift; shift; shift; shift
 	local options="$@"
 	local dumpfile_ver
 
@@ -684,6 +690,18 @@ _xfs_mdrestore() {
 		options="$options -l $logdev"
 	fi
 
+	if [ "$rtdev" != "none" ] && [[ $dumpfile_ver > 1 ]] && _xfs_metadump_supports_rt; then
+		# metadump and mdrestore capture and restore metadata on the
+		# realtime volume by turning on metadump v2 format.  This is
+		# only done if the realtime volume contains metadata such as
+		# rtgroup superblocks.  The -r option to mdrestore wasn't added
+		# until the creation of rtgroups.
+		#
+		# Hence it only makes sense to specify -r here if the dump file
+		# itself is in v2 format.
+		options="$options -r $rtdev"
+	fi
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
@@ -697,17 +715,27 @@ _xfs_metadump_max_version()
 	fi
 }
 
+# Do xfs_metadump/mdrestore support the -r switch for realtime devices?
+_xfs_metadump_supports_rt()
+{
+	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-r rtdev'
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {
 	local metadump=$1
 	shift
 	local logdev=none
+	local rtdev=none
 
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" nocompress "$@"
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" nocompress "$@"
 }
 
 # Restore snapshotted metadata on the scratch device
@@ -716,6 +744,7 @@ _scratch_xfs_mdrestore()
 	local metadump=$1
 	shift
 	local logdev=none
+	local rtdev=none
 	local options="$@"
 
 	# $SCRATCH_LOGDEV should have a non-zero length value only when all of
@@ -726,7 +755,10 @@ _scratch_xfs_mdrestore()
 		logdev=$SCRATCH_LOGDEV
 	fi
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
 }
 
 # Do not use xfs_repair (offline fsck) to rebuild the filesystem
@@ -847,7 +879,7 @@ _check_xfs_filesystem()
 	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 		local flatdev="$(basename "$device")"
 		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
-			compress -a -o >> $seqres.full
+			"$rtdev" compress -a -o >> $seqres.full
 	fi
 
 	# Optionally test the index rebuilding behavior.
@@ -880,7 +912,7 @@ _check_xfs_filesystem()
 		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
-				"$logdev" compress -a -o >> $seqres.full
+				"$logdev" "$rtdev" compress -a -o >> $seqres.full
 		fi
 	fi
 
@@ -964,7 +996,7 @@ _check_xfs_filesystem()
 		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
-				"$logdev" compress -a -o >> $seqres.full
+				"$logdev" "$rtdev" compress -a -o >> $seqres.full
 		fi
 	fi
 

