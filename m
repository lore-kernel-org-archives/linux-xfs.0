Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786F1F3FD5;
	Thu, 16 Jan 2025 23:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070677; cv=none; b=l97/PTYoj55QWWIDFCsPvZpM+3rqZxxpxk2kqELIUQPa/FbD6sepLEaVORwpaxwdBHTDIi3H655t3Zi3AR7CCHorj2I4TftnJAvvi9mz32X2PfCbYFPyC6Yg4U0/2AswwHiJW3h7LMs2Qb3hT4T4LjuKp8spR7V/ksvv3OUOQeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070677; c=relaxed/simple;
	bh=NHQjM9TWFExQ7V97IMv5MRWE4QOHhBt36m+LGrRRNV0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TsxjzGZulT8C/1+Db8Klvdf3DsoXO8iW9GxW3GvA8tZ3m025q16LihK6t7Q+h+dmE5SrUTpCERR+dcjLR+ZtsDMWl2Ezet8UnCX/kGteL2lpLu4ON7H25TtMG7MCnWikVFQZg2wrEgcp4xBZ915qpoUkyciWmTRely97+zZp7JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uG9dLFhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uG9dLFhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E41C4CED6;
	Thu, 16 Jan 2025 23:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070677;
	bh=NHQjM9TWFExQ7V97IMv5MRWE4QOHhBt36m+LGrRRNV0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uG9dLFhsqXFcoKZf2bNUVCKTW+SDPpnI+hCwr3Yuaf63wgKpKbJANxRqbukUtprHj
	 1ah6TydS9jvgMIiStL5N+xAlP+PytKSswnIfTF/yksF38ty3MJa0cQ5ovKbkC9yJN+
	 FRECMPAQK3fruucQywe+m0B+wb6+1mgIZr6zHBwM1+Sb8KFaqXrmSyNW4r2jz2o2SQ
	 QWUHObTrvGeDpWlGy69ZxtlXBVLFs3U5zdGsHOrgVRapJskDy7aJ2W7WWm9gqrAqk3
	 KOk55gAbouO+dqZ7C9Ose46le5qeRrzZKBM6is2ZiGOfp0sQacp2rRnC5yOyAY0wMN
	 Y89Ip2s+xbI+Q==
Date: Thu, 16 Jan 2025 15:37:56 -0800
Subject: [PATCH 11/14] xfs/271,xfs/556: fix tests to deal with rtgroups output
 in bmap/fsmap commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976231.1928798.8963336797307739220.stgit@frogsfrogsfrogs>
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

Fix these tests to deal with the xfs_io bmap and fsmap commands printing
out realtime group numbers if the feature is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |    7 +++++++
 tests/xfs/271 |    4 +++-
 tests/xfs/556 |   16 ++++++++++------
 3 files changed, 20 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index 6e2070b5647b38..744785279df97b 100644
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

