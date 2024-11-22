Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C595022339;
	Fri, 22 Nov 2024 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294462; cv=none; b=ZB6nbhcP+kPSrppJBZLFOGWBdHqOwSvW+heohv4V+EkJfrz2NJ78TNTkhU5KIelhI0m2AU9nVtS5XC8UBtZWpJziwaTH6/yvoxMWi50Z+ADYZc68ITyjV/igZJyOErVfWEkhA3oWEnja/VR2TOvhWgGyi6Tj0E95gXdwpPLTcPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294462; c=relaxed/simple;
	bh=aZ92cBGikadawS733SmHE9j0KKxvkfJZgfCH1/QFwe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8bZLrtppGAjOq/gl1MErp9XS8Sjc/BOUtKEqgbSnunRmHQLnYTozkW076iDpZaGZOOor6hoiiVa0ccp6Q6MvvLw7QW3GvTWPe28vZDpgtB3pqgS83k/BrXApyZxiCw/fcHmrfYU1wOQwhbM9oWerAUuR9CZUu6do2jiCIW/vp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6QCWvW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6QCWvW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEA7C4CECE;
	Fri, 22 Nov 2024 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294462;
	bh=aZ92cBGikadawS733SmHE9j0KKxvkfJZgfCH1/QFwe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b6QCWvW5DI1ML2nvqXQVV/s7In+4Sj9wqcg/sEj73+eoQXXvHSOQDl+t9vU+8tvXB
	 iBrqj0MWGZBFnwewFkv73e8V9NAZn/iOKtLF9shlvrdy6GsIzf0u4HPehg1jCIpzIm
	 eOcWt5SP3BuDwlwy6twce7jKzVyojvwbsifTy9x4VzTtrz4TwIY3pUBt9Lk7ZFh4ue
	 MRRyvY6+OqEFGOAvXjj4bCipITpL109Pt0kQm7kdT+HtzeA9QvRU2t7vMgwMsV2S4b
	 m51I1uTzGJuGEU6cxvrDBBrkO7w6MA1u/a730xCvDwpnIsKHwd6JfRmtHfh6KgUJ1m
	 XB247kmlb/Oww==
Date: Fri, 22 Nov 2024 08:54:21 -0800
Subject: [PATCH 15/17] common/rc: _scratch_mkfs_sized supports extra arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420240.358248.13252517041858687590.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zorro Lang <zlang@kernel.org>

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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: fix string quoting issues]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)


diff --git a/common/rc b/common/rc
index 70a0f1d1c6acd9..6acacbe4c88eea 100644
--- a/common/rc
+++ b/common/rc
@@ -1026,11 +1026,13 @@ _small_fs_size_mb()
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
@@ -1094,10 +1096,10 @@ _try_scratch_mkfs_sized()
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
@@ -1108,7 +1110,7 @@ _try_scratch_mkfs_sized()
 				_notrun "Could not make scratch logdev"
 			MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
 		fi
-		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
 		;;
 	gfs2)
 		# mkfs.gfs2 doesn't automatically shrink journal files on small
@@ -1123,13 +1125,13 @@ _try_scratch_mkfs_sized()
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
@@ -1137,33 +1139,33 @@ _try_scratch_mkfs_sized()
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
@@ -1173,7 +1175,7 @@ _try_scratch_mkfs_sized()
 
 _scratch_mkfs_sized()
 {
-	_try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
+	_try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($*)"
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units

