Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8936AEE;
	Tue,  9 Jan 2024 10:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6xr/70p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E9C433F1;
	Tue,  9 Jan 2024 10:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704795670;
	bh=X7T7SibnpDblAuAHtg1wbVmEECiEvQrQbOkkajbEF0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6xr/70pm7K5AChP3vvJct5Qqj4aLzV26sxkHbKDRQaGAa6HTj5zNseET6bMxO63r
	 Tw8+8TwTQ4K9eMgwvhTJTX5UYYbZ9azJLjDwzDV8KnBiv/wfS9c4Q2km+nEajmv5lz
	 6flUlZbyupv73Lb0/3AUbWkID14zE2AKzrf2r/gHPOAmi88tSP9ly0tohMQ3z3PUAU
	 5QCsZRF0r0xgsCsOag6vUQWPkrc1XrR9Y8cuqiUg91657CupqIZygmET/RIuNbXmIb
	 D/Tlv18LMa2k3q/Z3Ue8IKhFITvlUjybi+If/9cvxKsaKtXCj6jcL76wXlrgRRZhle
	 6J8RCjquOd2PA==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V2 1/5] common/xfs: Do not append -a and -o options to metadump
Date: Tue,  9 Jan 2024 15:50:43 +0530
Message-ID: <20240109102054.1668192-2-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240109102054.1668192-1-chandanbabu@kernel.org>
References: <20240109102054.1668192-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs/253 requires the metadump to be obfuscated. However _xfs_metadump() would
append the '-o' option causing the metadump to be unobfuscated.

This commit fixes the bug by modifying _xfs_metadump() to no longer append any
metadump options. The direct/indirect callers of this function now pass the
required options explicitly.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 common/populate | 2 +-
 common/xfs      | 7 +++----
 tests/xfs/291   | 2 +-
 tests/xfs/336   | 2 +-
 tests/xfs/432   | 2 +-
 tests/xfs/503   | 2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/common/populate b/common/populate
index 3d233073..cfbfd88a 100644
--- a/common/populate
+++ b/common/populate
@@ -55,7 +55,7 @@ __populate_fail() {
 	case "$FSTYP" in
 	xfs)
 		_scratch_unmount
-		_scratch_xfs_metadump "$metadump"
+		_scratch_xfs_metadump "$metadump" -a -o
 		;;
 	ext4)
 		_scratch_unmount
diff --git a/common/xfs b/common/xfs
index f53b33fc..38094828 100644
--- a/common/xfs
+++ b/common/xfs
@@ -667,7 +667,6 @@ _xfs_metadump() {
 	local compressopt="$4"
 	shift; shift; shift; shift
 	local options="$@"
-	test -z "$options" && options="-a -o"
 
 	if [ "$logdev" != "none" ]; then
 		options="$options -l $logdev"
@@ -855,7 +854,7 @@ _check_xfs_filesystem()
 	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 		local flatdev="$(basename "$device")"
 		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
-			compress >> $seqres.full
+			compress -a -o >> $seqres.full
 	fi
 
 	# Optionally test the index rebuilding behavior.
@@ -888,7 +887,7 @@ _check_xfs_filesystem()
 		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
-				"$logdev" compress >> $seqres.full
+				"$logdev" compress -a -o >> $seqres.full
 		fi
 	fi
 
@@ -972,7 +971,7 @@ _check_xfs_filesystem()
 		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
-				"$logdev" compress >> $seqres.full
+				"$logdev" compress -a -o >> $seqres.full
 		fi
 	fi
 
diff --git a/tests/xfs/291 b/tests/xfs/291
index 600dcb2e..54448497 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -92,7 +92,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
-_scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
+_scratch_xfs_metadump $tmp.metadump -a -o || _fail "xfs_metadump failed"
 SCRATCH_DEV=$tmp.img _scratch_xfs_mdrestore $tmp.metadump || _fail "xfs_mdrestore failed"
 SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
 	_fail "xfs_repair of metadump failed"
diff --git a/tests/xfs/336 b/tests/xfs/336
index d7a074d9..43b3790c 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -62,7 +62,7 @@ _scratch_cycle_mount
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_xfs_metadump $metadump_file
+_scratch_xfs_metadump $metadump_file -a
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
diff --git a/tests/xfs/432 b/tests/xfs/432
index 66315b03..dae68fb2 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -86,7 +86,7 @@ echo "qualifying extent: $extlen blocks" >> $seqres.full
 test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
 
 echo "Try to metadump"
-_scratch_xfs_metadump $metadump_file -w
+_scratch_xfs_metadump $metadump_file -a -o -w
 SCRATCH_DEV=$metadump_img _scratch_xfs_mdrestore $metadump_file
 
 echo "Check restored metadump image"
diff --git a/tests/xfs/503 b/tests/xfs/503
index f5710ece..8805632d 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -46,7 +46,7 @@ metadump_file_ag=${metadump_file}.ag
 copy_file=$testdir/copy.img
 
 echo metadump
-_scratch_xfs_metadump $metadump_file >> $seqres.full
+_scratch_xfs_metadump $metadump_file -a -o >> $seqres.full
 
 echo metadump a
 _scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
-- 
2.43.0

