Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306A184;
	Fri, 11 Oct 2024 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611078; cv=none; b=V4IWw0LDkFkJd2d+4esSPoKbGMI8hn0K/4GCVsa1wjnduy2ksY8hSnz0Lb1MpAaL51J4G2HGyK24jxOxwb5DTBuJlHPxDRciDzb9qudQFNj+kN4T8dAz5uUwio07mS4MBKchvdOCfuf4pZdWHUnuqb2BlNq/riMX05i+dtJ80WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611078; c=relaxed/simple;
	bh=dxiQqe0afWVXJo5UX0M0PMZrSgcWoEdf9Pu+r/zNVAQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jpI3/hiMVuihirnMFAgsIeQEhTnxqfXLAQ6eE61cea5/uXSTtnVr4ujYzd2PMP46zOOUzMeHVH1RY8voCzBrXrcKy9wscspVW3e3t8S59BWcYZq6zRO/KqS0UgtHvW4qttOGrsiBEBI8l9ueqKlATyOuMOFMer459sS/Hh9C01c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1cmBmqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1cmBmqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D53BC4CEC5;
	Fri, 11 Oct 2024 01:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611078;
	bh=dxiQqe0afWVXJo5UX0M0PMZrSgcWoEdf9Pu+r/zNVAQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l1cmBmqDS7hFc6tGpsUsCx0mYiJtT5fJChNqbl+Pd+urSoYYHX50LLjuGDHlFDfIA
	 3Vmmxy7n8p3wbJ7igi/H1jz5ERD4f26bgZN8cr22RR7FFQ5rHODMEi9MJ4sgcgmvGi
	 gmrQjnKELcRU5/92aaCsj0konfLoAvmlLMOE/UiBKkcomMGXDS7ofeIrF6zF0LrD+g
	 ihrpuMgBzg+6fJTJpfnObZcAXTtH/E+mfpOs3+asqXlwBYkndX/lNxmHn8eMv8zqI0
	 T+R026A/SdlzcUkzF7ZujkgVWx3tmFZmCHxU1O4SDcMEn1zB39b2V6IZflEU2wTrx9
	 YkV/YUrhsdPxA==
Date: Thu, 10 Oct 2024 18:44:37 -0700
Subject: [PATCH 14/16] common/xfs: capture realtime devices during
 metadump/mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658735.4188964.16562748663445704930.stgit@frogsfrogsfrogs>
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

If xfs_metadump supports the -r switch to capture the contents of
realtime devices and there is a realtime device, add the option to the
command line to enable preservation.

Similarly, if the dump file could restore to an external scratch rtdev,
pass the -r option to mdrestore so that we can restore rtdev contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/metadump |   21 +++++++++++++++++----
 common/populate |    6 +++++-
 common/xfs      |   48 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 62 insertions(+), 13 deletions(-)


diff --git a/common/metadump b/common/metadump
index 3373edfe92efd6..aebcb45875ddb3 100644
--- a/common/metadump
+++ b/common/metadump
@@ -107,6 +107,8 @@ _xfs_verify_metadump_v2()
 	local data_loop
 	local log_img=""
 	local log_loop
+	local rt_img=""
+	local rt_loop
 
 	# Capture metadump, which creates metadump_file
 	_scratch_xfs_metadump $metadump_file $metadump_args $version
@@ -117,8 +119,12 @@ _xfs_verify_metadump_v2()
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
@@ -127,15 +133,22 @@ _xfs_verify_metadump_v2()
 	# Create loopdev for log device if we recovered anything
 	test -s "$log_img" && log_loop=$(_create_loop_device $log_img)
 
+	# Create loopdev for rt device if we recovered anything
+	test -s "$rt_img" && rt_loop=$(_create_loop_device $rt_img)
+
 	# Mount fs, run an extra test, fsck, and unmount
-	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop _scratch_mount
+	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop SCRATCH_RTDEV=$rt_loop _scratch_mount
 	if [ -n "$extra_test" ]; then
-		SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop $extra_test
+		SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop SCRATCH_RTDEV=$rt_loop $extra_test
 	fi
-	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop _check_xfs_scratch_fs
+	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop SCRATCH_RTDEV=$rt_loop _check_xfs_scratch_fs
 	SCRATCH_DEV=$data_loop _scratch_unmount
 
 	# Tear down what we created
+	if [ -b "$rt_loop" ]; then
+		_destroy_loop_device $rt_loop
+		rm -f $rt_img
+	fi
 	if [ -b "$log_loop" ]; then
 		_destroy_loop_device $log_loop
 		rm -f $log_img
diff --git a/common/populate b/common/populate
index b9d4b0fad5999c..a0dc48f14559bf 100644
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
index f73cd467a2e7c5..09ce830ffdefbe 100644
--- a/common/xfs
+++ b/common/xfs
@@ -620,14 +620,19 @@ _xfs_metadump() {
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
@@ -651,7 +656,8 @@ _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	shift; shift; shift
+	local rtdev="$4"
+	shift; shift; shift; shift
 	local options="$@"
 	local dumpfile_ver
 
@@ -679,6 +685,18 @@ _xfs_mdrestore() {
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
 
@@ -692,17 +710,27 @@ _xfs_metadump_max_version()
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
@@ -711,6 +739,7 @@ _scratch_xfs_mdrestore()
 	local metadump=$1
 	shift
 	local logdev=none
+	local rtdev=none
 	local options="$@"
 
 	# $SCRATCH_LOGDEV should have a non-zero length value only when all of
@@ -721,7 +750,10 @@ _scratch_xfs_mdrestore()
 		logdev=$SCRATCH_LOGDEV
 	fi
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
 }
 
 # Do not use xfs_repair (offline fsck) to rebuild the filesystem
@@ -842,7 +874,7 @@ _check_xfs_filesystem()
 	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 		local flatdev="$(basename "$device")"
 		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
-			compress -a -o >> $seqres.full
+			"$rtdev" compress -a -o >> $seqres.full
 	fi
 
 	# Optionally test the index rebuilding behavior.
@@ -875,7 +907,7 @@ _check_xfs_filesystem()
 		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
-				"$logdev" compress -a -o >> $seqres.full
+				"$logdev" "$rtdev" compress -a -o >> $seqres.full
 		fi
 	fi
 
@@ -959,7 +991,7 @@ _check_xfs_filesystem()
 		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
-				"$logdev" compress -a -o >> $seqres.full
+				"$logdev" "$rtdev" compress -a -o >> $seqres.full
 		fi
 	fi
 

