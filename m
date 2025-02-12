Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6938271839;
	Wed, 12 Feb 2025 03:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331072; cv=none; b=qTRb+rXe6dnZPtUb6Z2mJ9TKMddLBicENFO8OTv+I+k3jSLHojTpdAeoo8jsMUxUE+bqp4WYHvKHnqq5ZPXKQS8+mX10Ry29fwjAHxL3/sFLyb5cyzbmRCmSvgNmhOcY/tuZBAFO2yMOJm1zKVjiH+JycsR7yw6BWaTaPbGxO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331072; c=relaxed/simple;
	bh=O7UsdjRvd3ikrleJoJT87R/+CCyi8FbeYmU5NyFUu68=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fY9lDspkaXNiqpGgHGHJcrjWFJ+zNbQWLSioS6yWw3US0+X8vlLs6kMDjG24eLcCwYesi9G62dxGOrxiyNYdoet5taw5oyhXpXkUzzg7Wh41ucKf14ELboIVc/WFUb0Q4kcx8Xxozun8Oo5aePMCvPHAzIed3nyJhpX5dDX7PWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1wdDRI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1wdDRI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242B4C4CEDF;
	Wed, 12 Feb 2025 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331072;
	bh=O7UsdjRvd3ikrleJoJT87R/+CCyi8FbeYmU5NyFUu68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T1wdDRI1Yi8msycWFWliOq3ubTom16GoP+zCt5rbusj+fDL91ZK0S9OF0+mrGKgqd
	 +4oqDE+BBKRH9ohfRqGd/tzG0ZGx05YBL2sW6ckVWSljAzTJXIqZhdYU0kl+tnifQe
	 CGSCPxHxnHEkjybhDhRH+4GDWBxMHBjU5rM/zPQonXkUG/75AVph5RSFp9WYrF+WEf
	 05Vdx1AYz+D6pSG94cAq9XQ+seIt6SKv7aj2ERSwmv6PTxN/32tuhhCmvUBD2vJEMj
	 4HeN9o6W7I8ye2pDMBhwTqFwOWrwJYP1rCdLwgBn9g/d//VSN5KGtrdJ15X42oXlw3
	 Tov2Jb/Hppwew==
Date: Tue, 11 Feb 2025 19:31:11 -0800
Subject: [PATCH 02/34] metadump: make non-local function variables more
 obvious
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094384.1758477.15976165381123294095.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
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
 

