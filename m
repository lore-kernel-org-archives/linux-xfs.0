Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761B7146D5A;
	Mon, 16 Mar 2026 23:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703760; cv=none; b=rEJtPv8+RGscG1Tty+4CcGxSAGk6vk46DzaazdgES/b4AfOi8jN89podjnJsDsZaaxdIOjmwi+DKoX8WNigvVZZ178vRJX0bRtVlpEs0/6w1qXgYIG2J6moyhEjMEodNeZyXWhAGMkAFacLLiMDTOrQQ0xaGNNmMqqdEWWJ5zGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703760; c=relaxed/simple;
	bh=VFMkxLOt5Ee4UsggCho6/sROX/QQKbAPtoZImpqi9vg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKmVHGl85AOg4B6TprsrXUJ4tpl3IxGnhILNG74EEluyKWRVIO/e3vpJbVslhamWrvCElYMYtRDnZUe7t9k819lcT3gt/IID4eoHybBFhxO+dptmtC3clURXdF16uTaBbK2Bl4diuptU2/AxNZ594QXk+Irq1MNMov8JV3y9cxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxtDtfdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxtDtfdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1A2C19421;
	Mon, 16 Mar 2026 23:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773703760;
	bh=VFMkxLOt5Ee4UsggCho6/sROX/QQKbAPtoZImpqi9vg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RxtDtfdAOb/srrZjfyRvkU3w2NsmHRbz0eviRtnFRmje7v4Oy6KE3oMywFdApPmP0
	 UHl4J7S/Rjp4TaQYIXCghPRhqggn9PqdaIXX7fEX6wTYHDJ90cZ7ZX2nluLnYjJi/K
	 GULfIYJZm8JU0d0E0RM3k8XJAQHcJlHs6jrPz9F+NBY0Wsm5+tFeXIjSzqhWDQSmQf
	 jKte6gti6sN7oCmwCLzPMpn7m8oSejCt0AJdFQInMfibVfKoc3yM4k+erJqfoo8Fi0
	 k8lzKQa7Iil4GEl4tYkhg6IToS7JyO5zYEeZYfF+uz1OtBST8rX+9TC4uFs1YKIL9q
	 Cci2J5/oVXocA==
Date: Mon, 16 Mar 2026 16:29:19 -0700
Subject: [PATCH 2/3] xfs/6{59-61}: force xfs_healer to run
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177370372704.2108664.14001765676527302739.stgit@frogsfrogsfrogs>
In-Reply-To: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
References: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Set the autofsck property so that xfs_healer actually runs on
filesystems with old feature sets.  Since these tests are looking for
error reports that don't require backref metadata (media errors, file IO
errors, shutdowns) we needn't _notrun them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/659 |    3 +++
 tests/xfs/660 |    3 +++
 tests/xfs/661 |    4 ++++
 3 files changed, 10 insertions(+)


diff --git a/tests/xfs/659 b/tests/xfs/659
index 6d17711a07b118..556c1991a3c467 100755
--- a/tests/xfs/659
+++ b/tests/xfs/659
@@ -26,6 +26,7 @@ _cleanup()
 _require_scratch
 _require_scrub
 _require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
 _require_dm_target error
 _require_no_xfs_always_cow	# no out of place writes
 
@@ -59,6 +60,8 @@ _scratch_mkfs >> $seqres.full
 #
 _scratch_mount
 _require_xfs_scratch_non_zoned
+# Force xfs_healer to run even if there's no backref metadata
+$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=check >> $seqres.full
 _require_xfs_healer $SCRATCH_MNT
 _scratch_unmount
 
diff --git a/tests/xfs/660 b/tests/xfs/660
index 214dfe1a15b130..962a2fc78353ff 100755
--- a/tests/xfs/660
+++ b/tests/xfs/660
@@ -25,6 +25,7 @@ _require_scratch
 _require_scrub
 _require_dm_target error
 _require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
 _require_xfs_io_command verifymedia
 
 filter_healer() {
@@ -57,6 +58,8 @@ _scratch_mkfs >> $seqres.full
 _scratch_mount
 _require_xfs_scratch_non_zoned
 _require_xfs_healer $SCRATCH_MNT
+# Force xfs_healer to run even if there's no backref metadata
+$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=check >> $seqres.full
 _scratch_unmount
 
 _dmerror_init
diff --git a/tests/xfs/661 b/tests/xfs/661
index f3f74cfe582c51..45e095395365f5 100755
--- a/tests/xfs/661
+++ b/tests/xfs/661
@@ -16,10 +16,14 @@ _begin_fstest auto quick scrub eio selfhealing shutdown
 _require_scratch_nocheck
 _require_scrub
 _require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
 _require_xfs_healer $SCRATCH_MNT
+# Force xfs_healer to run even if there's no backref metadata
+$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=check >> $seqres.full
+
 $XFS_IO_PROG -f -c "pwrite -S 0x58 0 500k" -c "fsync" $victim >> $seqres.full
 
 echo "Start healer and shut down"

