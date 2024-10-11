Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EB2FC12;
	Fri, 11 Oct 2024 01:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611062; cv=none; b=Z7MTip//XfQEnjOdrEen5q2j6y2S2OvChmPplh3Cz5QqLHE3VxJ0k4N6fL2u4hfPvXDGCC4RgiPeDLKpq46HBVrtr7FzgS26GNKWmGRZvqQjilOW4cjHBLzT+m/+obzjMVxvsmrhF5LgYsErerXD4Rc84ZbmCms+xcixBhrLE7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611062; c=relaxed/simple;
	bh=pXlzLUzUMc99Pqykl+S5tJicI9TY3YC0rwB+XeUbSAU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TE3ej+JhK0+pdi5aqWsLYwBvGIKGZmfl07QBHOHug17egQWhHIfZGELEZ/MXwA1JfKNGV83ZXVdOvrJVjEqLeMi/shBvT6qdmcUAOidNRlm1zuMraCIAzmveJTeFDuAEUgw6b/qq6hIo8ZigTPryfSYSFm9qqXl9Kz/hdprh0Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLf9Ei9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLf9Ei9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEA0C4CEC5;
	Fri, 11 Oct 2024 01:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611062;
	bh=pXlzLUzUMc99Pqykl+S5tJicI9TY3YC0rwB+XeUbSAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bLf9Ei9HJGA34uC8bPqKDA0K2rGDMPCIpMB8etMXj+IHEPDRvb86/s1CrWQVU/tmL
	 kgn3AJBVyQdRITXMYi/0mNKo8C1y/YyygTbQoAlFeKpv95Ehez74M1Xil716RPdcGa
	 1Mt6cNH1HvmiZPyZBeTW2vBxwAZd4K8FSuzjbgSe2KYE/bk5JAac8qHshQ3932+lhk
	 KVgKWLxFec52vbqoTJS/DXrtDSscqqcCh+fuodNCfQEc1ivRc5OtL6T3hErYZbwLxJ
	 sFQcnD8qamky20GtsWX3MwEn6oRVVJDfSv9+V7rD5NV0YasDnLQNRK2ywGcq8bNn08
	 eOM4GZjh6pTeA==
Date: Thu, 10 Oct 2024 18:44:22 -0700
Subject: [PATCH 13/16] xfs/271,xfs/556: fix tests to deal with rtgroups output
 in bmap/fsmap commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658719.4188964.17463502770217003820.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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
 tests/xfs/271 |    4 +++-
 tests/xfs/556 |   16 ++++++++++------
 3 files changed, 20 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index ffa5f3fa6d0d7b..f73cd467a2e7c5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -414,6 +414,13 @@ _xfs_has_feature()
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

