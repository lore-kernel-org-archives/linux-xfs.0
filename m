Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A2A286292;
	Wed, 19 Feb 2025 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927051; cv=none; b=W7opprIE+5mOgN/9DY3zzehVeoYyp5olmm4MYzlZ1AtbYE/AYZPzYuKI3G9z77mktWbkeS1MpsKpX4i8flohs2FGICOIFK9IESU+soaa6JjiTg2l5U6dmC9vcGAEctRsc7EjiPuMSYvZKGF2flJE9dZCh2qtkuSUGk9B9yJ9AvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927051; c=relaxed/simple;
	bh=IPqf58z3ilpr7OBmvohUlIYNeo8nO4Jd4Y26NkjM2ag=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K71OiTv/MP2HIdYPx3O6bXixv7tGqj3zNdUtngS7AuEMWLN6snonae5Y3YemKyDqgz3AbiRMQeLnXaVH05qxBk4GJu5Eo3XxscqVyWpswK5bIh+FxQTkojREaJOJzN9y2CSmFFscE8meY3fI0ghBQah2WSMQINsVBhtOQQyLVyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnRirYSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnRirYSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1037FC4CEE2;
	Wed, 19 Feb 2025 01:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927051;
	bh=IPqf58z3ilpr7OBmvohUlIYNeo8nO4Jd4Y26NkjM2ag=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lnRirYSOcviZV9eG1W3qRQS3sd96vJ+HvEAKoSRs2V0Nr9W7Rbvbt2uQAyHq06hTh
	 IMOEcgeohOfd1ETLjv82o+cBAn7fDLD72hD+6wsPFgZbrKk+n7lVDGmAIvlpXiwWaC
	 byhuTNH+9xe5Ya7hlejdx7fgpBx7X9h7zd6z2ief1Nc0qbM0AmDCQeY83H6vp0XAzn
	 iQdh+pSbd1ScEuouQdqLs3K0/eICQ0lcPA4/1kz9+tqIOa7xF+MWhZDO4zw+LFBHgW
	 2fFij++lixEdqVxQF6U+KPI+60wfG3jccm/HhVSYay+25G9KGq7ZAWfOdaACnJZ8Bl
	 FTzIUAflWFN4g==
Date: Tue, 18 Feb 2025 17:04:10 -0800
Subject: [PATCH 02/13] xfs/336: port to common/metadump
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173992591149.4080556.17871153207427090752.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs/336 does this somewhat sketchy thing where it mdrestores into a
regular file, and then does this to validate the restored metadata:

SCRATCH_DEV=$TEST_DIR/image _scratch_mount

Unfortunately, commit 1a49022fab9b4d causes the following regression:

 --- /tmp/fstests/tests/xfs/336.out      2024-11-12 16:17:36.733447713 -0800
 +++ /var/tmp/fstests/xfs/336.out.bad    2025-01-04 19:10:39.861871114 -0800
 @@ -5,4 +5,5 @@ Create big file
  Explode the rtrmapbt
  Create metadump file
  Restore metadump
 -Check restored fs
 +Usage: _set_fs_sysfs_attr <mounted_device> <attr> <content>
 +(see /var/tmp/fstests/xfs/336.full for details)

This is due to the fact that SCRATCH_DEV is temporarily reassigned to
the regular file.  That path is passed straight through _scratch_mount
to _xfs_prepare_for_eio_shutdown, but that helper _fails because the
"dev" argument isn't actually a path to a block device.

Fix this by porting it to the new common/metadump code that we merged
last year.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 1a49022fab9b4d ("fstests: always use fail-at-unmount semantics for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/336     |   34 +++++++++++-----------------------
 tests/xfs/336.out |    4 +---
 2 files changed, 12 insertions(+), 26 deletions(-)


diff --git a/tests/xfs/336 b/tests/xfs/336
index 3f85429ea77ee6..61bc08d3cc818f 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -9,21 +9,22 @@
 . ./common/preamble
 _begin_fstest auto rmap realtime metadump prealloc
 
-# Override the default cleanup function.
 _cleanup()
 {
 	cd /
-	rm -rf "$tmp".* $metadump_file
+	rm -rf "$tmp".*
+	_xfs_cleanup_verify_metadump
 }
 
-# Import common functions.
 . ./common/filter
+. ./common/metadump
 
 _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_realtime
 _require_xfs_scratch_rmapbt
 _require_test_program "punch-alternating"
 _require_xfs_io_command "falloc"
+_xfs_setup_verify_metadump
 
 rm -f "$seqres.full"
 
@@ -34,16 +35,13 @@ cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
 blksz="$(_get_file_block_size $SCRATCH_MNT)"
 
-metadump_file=$TEST_DIR/${seq}_metadump
-rm -rf $metadump_file
-
 echo "Create a three-level rtrmapbt"
-# inode core size is at least 176 bytes; btree header is 56 bytes;
-# rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
+# inode core size is at least 176 bytes; btree block header is 64 bytes;
+# rtrmap record is 24 bytes; and rtrmap key/pointer are 48 bytes.
 i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
-i_ptrs=$(( (isize - i_core_size) / 56 ))
-bt_ptrs=$(( (blksz - 56) / 56 ))
-bt_recs=$(( (blksz - 56) / 32 ))
+i_ptrs=$(( (isize - i_core_size) / 48 ))
+bt_ptrs=$(( (blksz - 64) / 48 ))
+bt_recs=$(( (blksz - 64) / 24 ))
 
 blocks=$((i_ptrs * bt_ptrs * bt_recs))
 _require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
@@ -56,20 +54,10 @@ $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCR
 echo "Explode the rtrmapbt"
 $here/src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
 $here/src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
-_scratch_cycle_mount
-
-echo "Create metadump file"
 _scratch_unmount
-_scratch_xfs_metadump $metadump_file -a -o
 
-# Now restore the obfuscated one back and take a look around
-echo "Restore metadump"
-SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
-SCRATCH_DEV=$TEST_DIR/image _scratch_mount
-SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
-
-echo "Check restored fs"
-_check_scratch_fs $TEST_DIR/image
+echo "Test metadump"
+_xfs_verify_metadumps '-a -o'
 
 # success, all done
 status=0
diff --git a/tests/xfs/336.out b/tests/xfs/336.out
index aa61973da3e844..aeaffcbbbbd13b 100644
--- a/tests/xfs/336.out
+++ b/tests/xfs/336.out
@@ -3,6 +3,4 @@ Format and mount
 Create a three-level rtrmapbt
 Create big file
 Explode the rtrmapbt
-Create metadump file
-Restore metadump
-Check restored fs
+Test metadump

