Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAFE271839;
	Wed, 12 Feb 2025 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331088; cv=none; b=PR3+gGpZJ8X+UuYQNpXddOI1/GII63un7iZPs/7RWbVr+z1xpeelfLS8YckTpkiKEhzvB4PjFP2B2SpmlNnotAswTNHjiMwhda4jG9yOFfNGDz1V81AGgGTyqR1px94W6Vb8GZ78KrsCbtaf9ohLz+MTG1rYqLNCX7XMuZtGIjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331088; c=relaxed/simple;
	bh=4Vo3B1NoJiPb9nFIR2rlIEtOJQFxP3eMgT4R8v4e5o8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwEuJdU8ogzKMIx5FlA1R+YEjWenOBZPOc1lk9edznsGcJbzuB0a5r7aYsqfjgQJaY2Zj0y+2OmjDwghAtX07vOclcpBhTutyiELOChpt1lvTrD2TvJtH2KbWq8FQr8YLj2XSjj5N09G0D8funyn21aFSNfBMqrGM75PIzOs4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVF03VkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVF03VkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0234C4CEDF;
	Wed, 12 Feb 2025 03:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331088;
	bh=4Vo3B1NoJiPb9nFIR2rlIEtOJQFxP3eMgT4R8v4e5o8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iVF03VkT5vA+M9LnPv5F1YMeou2Z878h5jT85/3F9y77QQY2NCZrn0SLE1QFMDEpv
	 qfDHQ8gV9zheKoDaJLbzxm6RtYk1r2o11FaXj6gP7JeZD9IPgjiyd/TgV67SJiDOxI
	 S6cS6SwXH3/Xv8wVDYbfmZI9O2TR0QCN/8HiLbBEumJIReDw0NS5wZRNqP+AE5x8GD
	 MYaluftHNuC+pPDXak6iBdWr3rybF7ccQZg6+KvKmKFdK7HRARIGsk546Q3N83r/7f
	 cRz0WhO8AsHe3EvAkDFostwjvENvUNgSRt6c/TdlByfVKeafbwK8Vj5P3WcKGKg/K4
	 iz+VPGtGZOXhA==
Date: Tue, 11 Feb 2025 19:31:27 -0800
Subject: [PATCH 03/34] metadump: fix cleanup for v1 metadump testing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094400.1758477.17916073142035868763.stgit@frogsfrogsfrogs>
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

In commit ce79de11337e38, the metadump v2 tests were updated to leave
the names of loop devices in some global variables so that the cleanup
method can find them and remove the loop devices.  Inexplicably, the
metadump v1 test function was not upgraded.  Do so now.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: ce79de11337e38 ("fstests: clean up loop device instantiation")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
 

