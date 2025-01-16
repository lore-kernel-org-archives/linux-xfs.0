Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34DA1F91DB;
	Thu, 16 Jan 2025 23:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070693; cv=none; b=aQN0ju3svuFaS1x+5tOKdikOwPDkCCP/869Inls+lEnZxt2dlh2RTP8+euCJ7j6WutsR6tSfgoxIInsyi4ZifMJLTek2i2kPiM3juC3aPcPymghMEUfdv0k1irEDEKXnEs9r+kWOOB0kXJTFskwQbMfLH6G7MQ0FKMwI0ZLpx8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070693; c=relaxed/simple;
	bh=BhadfMJ8TmXsL/TuzqaIyLDi1yHk20PYFa/skS+Haok=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FKGDBWw+8whwWXMEAFYH2Fjr28BdAhBmUu8NrXMxLStLzYZWlw08zo/x0lafPvMb7zAqGRaJub/c1vopMkbCvEPVrG6zJmHmK366lninkUvL0EvtjTvqq+Z661AA1OGlAyiN0Xz5VNGt4cX11Y9f6M4iBCGYe+QgQzs6rGifbeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkUhjxkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkUhjxkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EBFC4CED6;
	Thu, 16 Jan 2025 23:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070692;
	bh=BhadfMJ8TmXsL/TuzqaIyLDi1yHk20PYFa/skS+Haok=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GkUhjxkIkX55b8FjHFfWKa42Am7V7Q41ISCJEFZsGlU3my2KrU9UPxCLHjLT0NZQW
	 4q8pMneuzLZngBq6xcxofnobUNf8qgtHLqDLdqDc7sQJeKWDx4ZmgeuC1/je50yqVI
	 j5K5fiWRDFJhi9BFoQjVupiZ135wtyfJSm/20Y+KgpRYbGYBvP/NUg2BwlMBNQDK4H
	 pDMOAQ5rNqEg5PUKoicvNPHL4+hEjLbNueOfVr2YN6a6SzAgMzGEtYXo/y0Gy/PyeE
	 PqX5RP7OBXQAmZF3GHGzSb6TMPmknx8TUTcOGwCoPfT9BxFwXVUlBP/RqDbuZDWnAN
	 53RP5RJNbp7BA==
Date: Thu, 16 Jan 2025 15:38:12 -0800
Subject: [PATCH 12/14] common/xfs: capture realtime devices during
 metadump/mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976247.1928798.10688828222606951604.stgit@frogsfrogsfrogs>
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
index 96fc13875df503..9c3d49efebb3a4 100644
--- a/common/populate
+++ b/common/populate
@@ -1048,12 +1048,16 @@ _scratch_populate_save_metadump()
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
index 744785279df97b..81b080b7d8088f 100644
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
 

