Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7A54A03;
	Mon,  1 Jan 2024 00:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbKWbi2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA676C433C7;
	Mon,  1 Jan 2024 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070601;
	bh=WfURwhsVtITh/bBLPu/AwDwWUwZY5uQNfWGVEh6ML7c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NbKWbi2JKMLHU7C61VADUXxYAXtt8A5zCv30suaW8gQjD54bnBoJcb5rsEA4evrP6
	 JbdQslHkZ4QZr74yxuVD6QYRB7+kUYd+c23mg9HXS8mI04138yLBHe78ckhgcrIrII
	 ya7nr/vdjk4Pdo8sNbj9jZQlo5VhMnvpK/T7YVQukEiFz2FUlcHz8/Btxa9tXfdiBe
	 TLD7D2atB+C3IaIjhQpIqpTrC1LiLm2ovKiHC/P7KhOMoVJvi/5J4VQZUE3+agtT4U
	 mvM5YLpXpHEZ3rERxLlF5STbONVM5/JMtECbCeiLsFzGoJWq1iCoA0OoKDFqg6btTO
	 gUkc08LQzX7aQ==
Date: Sun, 31 Dec 2023 16:56:41 +9900
Subject: [PATCH 15/17] xfs/27[46],xfs/556: fix tests to deal with rtgroups
 output in bmap/fsmap commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030534.1826350.7625739026116302245.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

Fix these tests to deal with the xfs_io bmap and fsmap commands printing
out realtime group numbers if the feature is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |    7 +++++++
 tests/xfs/271 |    3 ++-
 tests/xfs/556 |   16 ++++++++++------
 3 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index e66e11f15d..1136d685e7 100644
--- a/common/xfs
+++ b/common/xfs
@@ -485,6 +485,13 @@ _xfs_has_feature()
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
index d67ac4d6c1..74e2c822c1 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -31,6 +31,7 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
 agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+rgcount=$(_xfs_mount_rgcount $SCRATCH_MNT)
 
 # mkfs lays out btree root blocks in the order bnobt, cntbt, inobt, finobt,
 # rmapbt, refcountbt, and then allocates AGFL blocks.  Since GETFSMAP has the
@@ -48,7 +49,7 @@ cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Check AG header" | tee -a $seqres.full
 grep 'static fs metadata[[:space:]]*[0-9]*[[:space:]]*(0\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
-_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
+_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $((agcount + rgcount)) 0 -v
 
 echo "Check freesp/rmap btrees" | tee -a $seqres.full
 grep 'per-AG metadata[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
diff --git a/tests/xfs/556 b/tests/xfs/556
index 061d8d5723..5940226223 100755
--- a/tests/xfs/556
+++ b/tests/xfs/556
@@ -47,16 +47,20 @@ victim=$SCRATCH_MNT/a
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

