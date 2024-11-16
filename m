Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7745A191F77;
	Sat, 16 Nov 2024 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731784085; cv=none; b=qNzF2Tt3dXOGRcA7bhFvOzHdbLkb/waDSoMa8Qv6k8sDAR9Q3OCifUrvxgPHPO5wu/bjkZiJZtMTOIH9x5HMtbmShvgPo+9QV/vCugdloRGfIczYlu9W3bzI0gwkD4JqvI1V9HENSuZoFCpOmspVc8AcEODtBt0ZLdLi+57fyS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731784085; c=relaxed/simple;
	bh=D+4307XcFXllu/gd85KGWczfgoBKO81IYzozqhcpCKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uvdh9uYVB6vZZ5aqN7xnFwX8is6v6l5Yqdk7gOpGfwN2RvxUkQ5N7uSLtoFiSRW5qU9ujDnDtqDQj8iQfgVFziy42J/dpD0FU2RxaLLPUOd+DyeCTzafw8VRVcveeyfwFY2+Y7pDA1UoBvdyUqxqIWmEBqqbrQxosw4jn8a+rrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKNaCvcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKNaCvcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C22C4CEC3;
	Sat, 16 Nov 2024 19:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731784084;
	bh=D+4307XcFXllu/gd85KGWczfgoBKO81IYzozqhcpCKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKNaCvcKOGUnY0ntbv+J06NeJWuWr6GWLnqKV4k/KajVn6deo5AUTjipZOfnxOQIQ
	 Mwoz/xroKPnMBc3Jqi08Kbcdo0WcCZbtioqudrUe2GO1t+wMxew5WIm8YtMi9rJJVD
	 luwDRborASN7a0WgUM4MA+Iq9JM+7GuUgs4CzhX2eB3L+u8Em/9cVMMg4iUoL/wqTf
	 WMbuiNrCXttrTKEMKRHXt6gc8BJFAsmcBYzDW2Il1+Qw2H5KC2KBpJ8rl3yFSxxiZM
	 OG0RdjOgR1WlR3G4LSepkHNuo5kB88HJU3/NLqnkt0lUsMF4EoL+ERETPPN7SqJpCO
	 jLyVBDwvofGFQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] common/rc: _scratch_mkfs_sized supports extra arguments
Date: Sun, 17 Nov 2024 03:07:59 +0800
Message-ID: <20241116190800.1870975-2-zlang@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241116190800.1870975-1-zlang@kernel.org>
References: <20241116190800.1870975-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To give more arguments to _scratch_mkfs_sized, we generally do as:

  MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size

to give "-L oldlabel" to it. But if _scratch_mkfs_sized fails, it
will get rid of the whole MKFS_OPTIONS and try to mkfs again.
Likes:

  ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
  ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **

But that's not the fault of "-L oldlabel". So for keeping the mkfs
options ("-L oldlabel") we need, we'd better to let the
scratch_mkfs_sized to support extra arguments, rather than using
global MKFS_OPTIONS.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/rc | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/common/rc b/common/rc
index 2af26f23f..ce8602383 100644
--- a/common/rc
+++ b/common/rc
@@ -1023,11 +1023,13 @@ _small_fs_size_mb()
 }
 
 # Create fs of certain size on scratch device
-# _try_scratch_mkfs_sized <size in bytes> [optional blocksize]
+# _try_scratch_mkfs_sized <size in bytes> [optional blocksize] [other options]
 _try_scratch_mkfs_sized()
 {
 	local fssize=$1
-	local blocksize=$2
+	shift
+	local blocksize=$1
+	shift
 	local def_blksz
 	local blocksize_opt
 	local rt_ops
@@ -1091,10 +1093,10 @@ _try_scratch_mkfs_sized()
 		# don't override MKFS_OPTIONS that set a block size.
 		echo $MKFS_OPTIONS |grep -E -q "b\s*size="
 		if [ $? -eq 0 ]; then
-			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops
+			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops "$@"
 		else
 			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops \
-				-b size=$blocksize
+				-b size=$blocksize "$@"
 		fi
 		;;
 	ext2|ext3|ext4)
@@ -1105,7 +1107,7 @@ _try_scratch_mkfs_sized()
 				_notrun "Could not make scratch logdev"
 			MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
 		fi
-		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
 		;;
 	gfs2)
 		# mkfs.gfs2 doesn't automatically shrink journal files on small
@@ -1120,13 +1122,13 @@ _try_scratch_mkfs_sized()
 			(( journal_size >= min_journal_size )) || journal_size=$min_journal_size
 			MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
 		fi
-		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize "$@" $SCRATCH_DEV $blocks
 		;;
 	ocfs2)
-		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
 		;;
 	udf)
-		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
 		;;
 	btrfs)
 		local mixed_opt=
@@ -1134,33 +1136,33 @@ _try_scratch_mkfs_sized()
 		# the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
 		(( fssize < $((256 * 1024 * 1024)) )) &&
 			! _scratch_btrfs_is_zoned && mixed_opt='--mixed'
-		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
+		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATCH_DEV
 		;;
 	jfs)
-		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS "$@" $SCRATCH_DEV $blocks
 		;;
 	reiserfs)
-		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
 		;;
 	reiser4)
 		# mkfs.resier4 requires size in KB as input for creating filesystem
-		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
+		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize "$@" $SCRATCH_DEV \
 				   `expr $fssize / 1024`
 		;;
 	f2fs)
 		# mkfs.f2fs requires # of sectors as an input for the size
 		local sector_size=`blockdev --getss $SCRATCH_DEV`
-		$MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
+		$MKFS_F2FS_PROG $MKFS_OPTIONS "$@" $SCRATCH_DEV `expr $fssize / $sector_size`
 		;;
 	tmpfs)
 		local free_mem=`_free_memory_bytes`
 		if [ "$free_mem" -lt "$fssize" ] ; then
 		   _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
 		fi
-		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
+		export MOUNT_OPTIONS="-o size=$fssize "$@" $TMPFS_MOUNT_OPTIONS"
 		;;
 	bcachefs)
-		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
+		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt "$@" $SCRATCH_DEV
 		;;
 	*)
 		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
@@ -1170,7 +1172,7 @@ _try_scratch_mkfs_sized()
 
 _scratch_mkfs_sized()
 {
-	_try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
+	_try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($@)"
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units
-- 
2.45.2

