Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1911B1C28E;
	Wed, 19 Feb 2025 00:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926502; cv=none; b=t9zlAFf5WjncQ33qabdqb5VIaNNooBFgBRgiO5RoTXELfdKD+5U7U+wcWnYN5Sduk0nhgwP8zNrQX55NwuF3CgQ9fRtM1ccGMqfnQL5B9tXKoWC/rPRST2iKN5NKZPAoCRla82FpCCbRC2p6bxqqAT8ri8QyVaWkYnP5Si9lCl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926502; c=relaxed/simple;
	bh=/2aY3XYRd4ng7wBdqXkhNSTNmTbBnT3tX8K2CzM22rQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVBv7cVaeXlte4zKL+K+1R5ghjClUmaQJb0u+gmfdYzHc8w4OXFkJdStwFiTrGk3U0x6EoYqce2c0D8U6PqFqqulMRbxjgXg+FfIwga1jKIbXsaYJXQkFz7zKYpKERfddD2roPVhfG4Fv7j+qPn2hyUnAELvi6xkpBdc2i3DiWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHFGiVg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHFGiVg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75200C4CEE2;
	Wed, 19 Feb 2025 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926501;
	bh=/2aY3XYRd4ng7wBdqXkhNSTNmTbBnT3tX8K2CzM22rQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VHFGiVg7IpHwP24uB5L7jHtdGefISLhB3BiUJ0CpBzx5wjTYsbSlXfS4OMnkij5ie
	 iG4hcl913dStEUlRK2FDMTg2Bsqd39AiDPpyDUB01iO7rleYM8lPzY7PIFHSYEZKEK
	 omysPc7JOtnhVYwGTd6EylvXQUWxlS0C4ZMvJR6C9dtoFTRpAVxUw0luKAdB2tun/2
	 jVR8ipdjCfejKF2fxbWgstRkYVCBQa7/ZeNbIbzBFaVoiySQvzTwOv+OeB8XV1Fg2/
	 8YeplMrEz/4syMwGm45iIpgppENTxB8m6bqOjLHdF9LlVR1F7qNoVZjQxQksDZ6dwx
	 /Fu0rqoENmNwA==
Date: Tue, 18 Feb 2025 16:55:01 -0800
Subject: [PATCH 06/12] xfs/509: adjust inumbers accounting for metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588171.4078751.10552424872825170445.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The INUMBERS ioctl exports data from the inode btree directly -- the
number of inodes it reports is taken from ir_freemask and includes all
the files in the metadata directory tree.  BULKSTAT, on the other hand,
only reports non-metadata files.  When metadir is enabled, this will
(eventually) cause a discrepancy in the inode counts that is large
enough to exceed the tolerances, thereby causing a test failure.

Correct this by counting the files in the metadata directory and
subtracting that from the INUMBERS totals.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/509 |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/509 b/tests/xfs/509
index 53c6bd9c0772a1..9b07fecc5d1a10 100755
--- a/tests/xfs/509
+++ b/tests/xfs/509
@@ -91,13 +91,13 @@ inumbers_count()
 	bstat_versions | while read v_tag v_flag; do
 		echo -n "inumbers all($v_tag): "
 		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
-		_within_tolerance "inumbers" $nr $expect $tolerance -v
+		_within_tolerance "inumbers" $((nr - METADATA_FILES)) $expect $tolerance -v
 
 		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 		for batchsize in 71 2 1; do
 			echo -n "inumbers $batchsize($v_tag): "
 			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
-			_within_tolerance "inumbers" $nr $expect $tolerance -v
+			_within_tolerance "inumbers" $((nr - METADATA_FILES)) $expect $tolerance -v
 		done
 	done
 }
@@ -142,9 +142,28 @@ _require_xfs_io_command inumbers
 DIRCOUNT=8
 INOCOUNT=$((2048 / DIRCOUNT))
 
+# Count everything in the metadata directory tree.
+count_metadir_files() {
+	# Each possible path in the metadata directory tree must be listed
+	# here.
+	local metadirs=('/rtgroups')
+	local db_args=('-f')
+
+	for m in "${metadirs[@]}"; do
+		db_args+=('-c' "ls -m $m")
+	done
+
+	local ret=$(_scratch_xfs_db "${db_args[@]}" 2>/dev/null | grep regular | wc -l)
+	test -z "$ret" && ret=0
+	echo $ret
+}
+
 _scratch_mkfs "-d agcount=$DIRCOUNT" >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
+METADATA_FILES=$(count_metadir_files)
+echo "found $METADATA_FILES metadata files" >> $seqres.full
+
 # Figure out if we have v5 bulkstat/inumbers ioctls.
 has_v5=
 bs_root_out="$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT 2>>$seqres.full)"

