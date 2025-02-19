Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8208E7DA95;
	Wed, 19 Feb 2025 01:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926846; cv=none; b=Fh9bVsbnfzkM9HLYjFcXKLM30Px4mWBhrUmfmsK5Z84Ii66v4dkU0Gj4jzOxqHiruASfYBQjE4TPebrleizBpWX09c3F03M4LOgW/VfJlUkaNbawuW9fry3aAPgYlBPy3KRBpwDQTrpKlmGJTdQjxeZ2owNYgYkgH5lZsQGMptQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926846; c=relaxed/simple;
	bh=PJ0wG4kzUFFDoIBvAW8Lc76GLCxurPmCxMq5cRuW8Ok=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qbv9BX/mSNNb8yJVxSy2ToxDROyldjEBps6iGSSFMc47uxX+3fACAKc1SYySUGA+DdfNHCFGd1/MJMiXmulmjdTNEXzsbT/epFT6zAnV27pirYmvrWH/xs0tGv9udAh7EpmGlnZAETqEa/Ch7DBIfmj9YqQy+8MU3I0CzAl+Zro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHKy2fyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHKy2fyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE6FC4CEE2;
	Wed, 19 Feb 2025 01:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926845;
	bh=PJ0wG4kzUFFDoIBvAW8Lc76GLCxurPmCxMq5cRuW8Ok=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HHKy2fyzWHiRMs7NGBBgEK4RRKzeVb3B4DLA2xnefzg6/Fg0XPTlXuxwTC0SFNrTu
	 qnJjy9HwLrOIFOsTDg/0V2mnio0/5WZ2jbshlb1FbTI5j4L7dbyc+1ksEqXFmTt2f9
	 4h+xb+nbN5CRZkV1Sz05BRcf5wPtbWG7nZHwZs5fCpzRGfOMUjBFGdbYz5j5i7Hr7Y
	 Y1TzMUQ0DmjBNq7JT9edRI+DzEhnaMCq8PBdbSIbWnnbmqXaOAZ5Hbmxvs7iK8U47a
	 9N2p1ImRWwe7IiBgNFf7JzH0lZeIIb1shiKBQOvGrk3hZ3Lyhf6d3K/V0bTY8IMAPS
	 oDKAOMsLGbkwg==
Date: Tue, 18 Feb 2025 17:00:45 -0800
Subject: [PATCH 12/15] xfs/271,xfs/556: fix tests to deal with rtgroups output
 in bmap/fsmap commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589400.4079457.7456085852406287416.stgit@frogsfrogsfrogs>
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

Fix these tests to deal with the xfs_io bmap and fsmap commands printing
out realtime group numbers if the feature is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |    7 +++++++
 tests/xfs/271 |    4 +++-
 tests/xfs/556 |   16 ++++++++++------
 3 files changed, 20 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index 547e91167718e9..5a829637dc1cfb 100644
--- a/common/xfs
+++ b/common/xfs
@@ -419,6 +419,13 @@ _xfs_has_feature()
 		feat="rtextents"
 		feat_regex="[1-9][0-9]*"
 		;;
+	"rtgroups")
+		# any fs with rtgroups enabled will have a nonzero rt group
+		# size, even if there is no rt device (and hence zero actual
+		# groups)
+		feat="rgsize"
+		feat_regex="[1-9][0-9]*"
+		;;
 	esac
 
 	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -E -w -c "$feat=$feat_regex")"
diff --git a/tests/xfs/271 b/tests/xfs/271
index 420f4e7479220a..8a71746d6eaede 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -29,6 +29,8 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
 agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+agcount_wiggle=0
+_xfs_has_feature $SCRATCH_MNT rtgroups && agcount_wiggle=1
 
 # mkfs lays out btree root blocks in the order bnobt, cntbt, inobt, finobt,
 # rmapbt, refcountbt, and then allocates AGFL blocks.  Since GETFSMAP has the
@@ -46,7 +48,7 @@ cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Check AG header" | tee -a $seqres.full
 grep 'static fs metadata[[:space:]]*[0-9]*[[:space:]]*(0\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
-_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
+_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount $agcount_wiggle -v
 
 echo "Check freesp/rmap btrees" | tee -a $seqres.full
 grep 'per-AG metadata[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
diff --git a/tests/xfs/556 b/tests/xfs/556
index 79e03caf40a0a5..83d5022e700c8b 100755
--- a/tests/xfs/556
+++ b/tests/xfs/556
@@ -45,16 +45,20 @@ victim=$SCRATCH_MNT/a
 file_blksz=$(_get_file_block_size $SCRATCH_MNT)
 $XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
 unset errordev
-_xfs_is_realtime_file $victim && errordev="RT"
+
+awk_len_prog='{print $6}'
+if _xfs_is_realtime_file $victim; then
+	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+		awk_len_prog='{print $4}'
+	fi
+	errordev="RT"
+fi
 bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
 echo "$errordev:$bmap_str" >> $seqres.full
 
 phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
-if [ "$errordev" = "RT" ]; then
-	len="$(echo "$bmap_str" | $AWK_PROG '{print $4}')"
-else
-	len="$(echo "$bmap_str" | $AWK_PROG '{print $6}')"
-fi
+len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
+
 fs_blksz=$(_get_block_size $SCRATCH_MNT)
 echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
 kernel_sectors_per_fs_block=$((fs_blksz / 512))

