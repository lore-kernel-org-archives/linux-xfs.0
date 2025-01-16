Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8942C158520;
	Thu, 16 Jan 2025 23:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069958; cv=none; b=pBhNy8GCy4qe+xWfesN8q58e/qRJBA1CI83KdMSkM7gyJMmRLLAsrnJbmAOxYJ0QmofVYsPwBEJFMvcPAxIxv7Xao4QwvXtKwKZcBWJ5m3sTtIEtu3sZkNqk1dH7+Q3Jc2GGP/OxXPbv8b5ILTu5G06OM6SaIvCPpoVnJV+My9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069958; c=relaxed/simple;
	bh=3NLVBAXGcewNdwbuqWIMRnRIdlhR5mt7CikGt4TuJtg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irZeynaLBh+bt5YWChJP3BQ25165WsX6VIxJiJT9nlw0MF2rUe4ekKH4OsrNlxGV/BbDLNOh6GJ30b41K8i/8ogYJIzijwGmXzFioArgfQEEIStcmgPhJRCA0Wd5U0E0ppldGulPjQqepR2/yxPzooyl7tKuNoMagYvXlnZ20bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaiIJFAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaiIJFAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21565C4CED6;
	Thu, 16 Jan 2025 23:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069958;
	bh=3NLVBAXGcewNdwbuqWIMRnRIdlhR5mt7CikGt4TuJtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QaiIJFAUkL7hj957oEVo2gKeT83V4b0zR/auKOph4WD4OqTk0XzchHuMi1Ooxnvbr
	 p3m/w0xB7HjCf7UJcQNh3rWWt4M0zXIyVoPwfZnI1izNmjRjqw4jxJEFtqWpXpPt2p
	 OjtGxDxLK1pt2HFlCLToPZqzNop87ozdZ6Orf0bgY2RGcg8KkRLFIQoVmLbBrU28zl
	 11YlUzF96Hk2Sa9AKEdQMNzqN+8THMYLKL+eZcsRzK7PxA5f5lFAs629TcqniDtBWo
	 vpsYcmuNKWg2sfK/C8/nVsStBOa+gBBPD9PPeww5bLSyRbJ/PxHkSMHap+sxE8mLRh
	 UcWRb8bKgZofg==
Date: Thu, 16 Jan 2025 15:25:57 -0800
Subject: [PATCH 03/23] metadump: fix cleanup for v1 metadump testing
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974122.1927324.15053204612789959097.stgit@frogsfrogsfrogs>
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

In commit ce79de11337e38, the metadump v2 tests were updated to leave
the names of loop devices in some global variables so that the cleanup
method can find them and remove the loop devices.  Inexplicably, the
metadump v1 test function was not upgraded.  Do so now.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: ce79de11337e38 ("fstests: clean up loop device instantiation")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/metadump |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/common/metadump b/common/metadump
index 493f8b6379dc0b..a4ec9a7f921acf 100644
--- a/common/metadump
+++ b/common/metadump
@@ -61,7 +61,6 @@ _xfs_verify_metadump_v1()
 	local metadump_file="$XFS_METADUMP_FILE"
 	local version=""
 	local data_img="$XFS_METADUMP_IMG.data"
-	local data_loop
 
 	# Force v1 if we detect v2 support
 	if [[ $MAX_XFS_METADUMP_FORMAT > 1 ]]; then
@@ -75,18 +74,19 @@ _xfs_verify_metadump_v1()
 	SCRATCH_DEV=$data_img _scratch_xfs_mdrestore $metadump_file
 
 	# Create loopdev for data device so we can mount the fs
-	data_loop=$(_create_loop_device $data_img)
+	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
 
 	# Mount fs, run an extra test, fsck, and unmount
-	SCRATCH_DEV=$data_loop _scratch_mount
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _scratch_mount
 	if [ -n "$extra_test" ]; then
-		SCRATCH_DEV=$data_loop $extra_test
+		SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV $extra_test
 	fi
-	SCRATCH_DEV=$data_loop _check_xfs_scratch_fs
-	SCRATCH_DEV=$data_loop _scratch_unmount
+	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _check_xfs_scratch_fs
+	_unmount $METADUMP_DATA_LOOP_DEV
 
 	# Tear down what we created
-	_destroy_loop_device $data_loop
+	_destroy_loop_device $METADUMP_DATA_LOOP_DEV
+	unset METADUMP_DATA_LOOP_DEV
 	rm -f $data_img
 }
 

