Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB621A432;
	Tue,  4 Feb 2025 21:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704170; cv=none; b=MThRYNCZUf5RX6JZuYkVYFcGwKx7JbRAcyPDfxLPefFBJbdhsR7+lm2MRNgDnJtNz+GlJ1buDL6D9lt7yzWNGpqBvY/kecbhadlilBhcoC219wzSAphJ1vo1Cr0TruLuskOfZn0ygd+x7lvAMKZvHvJJTl5VyZHU1DThcaSiqB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704170; c=relaxed/simple;
	bh=O7UsdjRvd3ikrleJoJT87R/+CCyi8FbeYmU5NyFUu68=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyKlpKs4PBKnAgAQuUOUKRVkYgY+uGRYc+LfTjPSD3otzKl8ugBlSBoqaGRKVq6D/dmZtGG9eI4WMeuJz2+PXutH0jrY4Zlqqt8pRAA6rkWUL6ox3JDEOH7J0iOTx87WX8ji1pvk5qwzYmSbDiuvleCzYyH+CmssFWJ5xtGDmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXuiwhzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXuiwhzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4E6C4CEDF;
	Tue,  4 Feb 2025 21:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704169;
	bh=O7UsdjRvd3ikrleJoJT87R/+CCyi8FbeYmU5NyFUu68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gXuiwhzyzC2egdU6vZXfxqqHW7gsuNCQCLXawWKa854zJg+ySYk89GPd+6aL526XD
	 vEbzNtgx4wgCUhiyJ00iMMFSedQkRV7YdbcDdzFKfbcc45qlmXWibUkHP/8q3R+NfA
	 atzPNSgO8cdbRN2pg3oNPbKU7GrX5O3UC/DBjeE+Cx8CJXMLBMkMTd7CzHiVLPgn2Z
	 1N2R4f32ILfTwPy3xgxYLQlRQ/MG1DzNtx8gdFwA71ig5rbjtB+4KFmrdqJcz1a1ru
	 k1fEvE2XI6SV6BbIy2xAYYmcwvr2PINAKyxj6FOIk1OuBzY8TcQvgnoMSoQPamRfQU
	 OV96GDUsv58ag==
Date: Tue, 04 Feb 2025 13:22:48 -0800
Subject: [PATCH 02/34] metadump: make non-local function variables more
 obvious
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406138.546134.17826364950785247195.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In _xfs_verify_metadump_v2(), we want to set up some loop devices,
record the names of those loop devices, and then leave the variables in
the global namespace so that _xfs_cleanup_verify_metadump can dispose of
them.

Elsewhere in fstests the convention for global variables is to put them
in all caps to make it obvious that they're global and not local
variables, so do that here too.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: ce79de11337e38 ("fstests: clean up loop device instantiation")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/metadump |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)


diff --git a/common/metadump b/common/metadump
index 3aa7adf76da4bb..493f8b6379dc0b 100644
--- a/common/metadump
+++ b/common/metadump
@@ -25,8 +25,8 @@ _xfs_cleanup_verify_metadump()
 	test -n "$XFS_METADUMP_FILE" && rm -f "$XFS_METADUMP_FILE"
 
 	if [ -n "$XFS_METADUMP_IMG" ]; then
-		[ -b "$md_data_loop_dev" ] && _destroy_loop_device $md_data_loop_dev
-		[ -b "$md_log_loop_dev" ] && _destroy_loop_device $md_log_loop_dev
+		[ -b "$METADUMP_DATA_LOOP_DEV" ] && _destroy_loop_device $METADUMP_DATA_LOOP_DEV
+		[ -b "$METADUMP_LOG_LOOP_DEV" ] && _destroy_loop_device $METADUMP_LOG_LOOP_DEV
 		for img in "$XFS_METADUMP_IMG"*; do
 			test -e "$img" && rm -f "$img"
 		done
@@ -100,9 +100,7 @@ _xfs_verify_metadump_v2()
 	local metadump_file="$XFS_METADUMP_FILE"
 	local version="-v 2"
 	local data_img="$XFS_METADUMP_IMG.data"
-	local data_loop
 	local log_img=""
-	local log_loop
 
 	# Capture metadump, which creates metadump_file
 	_scratch_xfs_metadump $metadump_file $metadump_args $version
@@ -118,27 +116,27 @@ _xfs_verify_metadump_v2()
 		_scratch_xfs_mdrestore $metadump_file
 
 	# Create loopdev for data device so we can mount the fs
-	md_data_loop_dev=$(_create_loop_device $data_img)
+	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
 
 	# Create loopdev for log device if we recovered anything
-	test -s "$log_img" && md_log_loop_dev=$(_create_loop_device $log_img)
+	test -s "$log_img" && METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
 
 	# Mount fs, run an extra test, fsck, and unmount
-	SCRATCH_DEV=$md_data_loop_dev SCRATCH_LOGDEV=$md_log_loop_dev _scratch_mount
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV _scratch_mount
 	if [ -n "$extra_test" ]; then
-		SCRATCH_DEV=$md_data_loop_dev SCRATCH_LOGDEV=$md_log_loop_dev $extra_test
+		SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV $extra_test
 	fi
-	SCRATCH_DEV=$md_data_loop_dev SCRATCH_LOGDEV=$md_log_loop_dev _check_xfs_scratch_fs
-	_unmount $md_data_loop_dev
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV _check_xfs_scratch_fs
+	_unmount $METADUMP_DATA_LOOP_DEV
 
 	# Tear down what we created
-	if [ -b "$md_log_loop_dev" ]; then
-		_destroy_loop_device $md_log_loop_dev
-		unset md_log_loop_dev
+	if [ -b "$METADUMP_LOG_LOOP_DEV" ]; then
+		_destroy_loop_device $METADUMP_LOG_LOOP_DEV
+		unset METADUMP_LOG_LOOP_DEV
 		rm -f $log_img
 	fi
-	_destroy_loop_device $md_data_loop_dev
-	unset md_data_loop_dev
+	_destroy_loop_device $METADUMP_DATA_LOOP_DEV
+	unset METADUMP_DATA_LOOP_DEV
 	rm -f $data_img
 }
 

