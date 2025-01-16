Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E07232438;
	Thu, 16 Jan 2025 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069943; cv=none; b=PfkfhP5XUkUc8BKHHKah9h0g/tpHmfMM6eTDYaNJxOASUEkjtBteGq5uUIOv5SOHfm9clAP4x/kzuVO7YtpAynj2ao20xPSuDqRxLxGTETVtKYnS71lTgBrutW4sq+Efz3s+knVjOyIXjnOoa62cjX/cwNsFUuq/bhFcE+ydgXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069943; c=relaxed/simple;
	bh=rzffV7zKDY/h9TXj41MYP7ZD0mPufvZp7Z0ydAP9svI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xldydgbn6GWW1ieY8G9Oi0MnFAmSN5Eto9VMRLmaFKAcP92b1ld53YXoPGenR2Mn43SKUnxERGs30FTlqSpxpQ15eBHusiuQcQlkpqWbJ1Fi9qnPyWToiVEV3NTpOsi22iNz4hv9CPrJKTvgtG0IoNwpwe1DQ9B5bHugCvVinaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3TUxHus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3TUxHus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D094C4CED6;
	Thu, 16 Jan 2025 23:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069942;
	bh=rzffV7zKDY/h9TXj41MYP7ZD0mPufvZp7Z0ydAP9svI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O3TUxHusoSIPhczDqmwtIeT4lKHqfuMYsU+xGla88sSbK7wDZjKA4hkGvWWPNuNWu
	 9rGqxaFyek5qOESGn0VkvQ9fHpFjoEV6qBQ/VHjxoOPmvZLao2hnOi7cTPSvvQ9Hc+
	 0CYWW08nqnacGwgQKWljoS5up3PRQdn1kwqFgg0ZV4TfM0Odq1GnbC/Yk+OilDkAU0
	 Vz8vtnmLNaoojwfnmswEdMwt/xYND0EmU9hBhOgOkA7XP1Ukifetp/+ayHwzrPa50R
	 kwdH6vF73DXdfBJF93Tkul7VJm7nPc8g8WQ0MmvtD/KyqeeAySNLcd/Qkg8x2nvRiN
	 YCqC0um/TA/1g==
Date: Thu, 16 Jan 2025 15:25:42 -0800
Subject: [PATCH 02/23] metadump: make non-local function variables more
 obvious
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974107.1927324.17123378052376946322.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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
 

