Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D744153BE4;
	Mon, 18 Nov 2024 23:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971040; cv=none; b=tXT9HWGbujne4zeTONnO6M/53IHEtU2hMGg2Pn/qQzhswezfGwAHzdcLnzt/cgjo58NruvI29LiJgQq1k7MlX/rI/MRVyf6Dg6d5mr/B1LCc9IXKLKp4bUHuxUBppWMgn23jg+j8s3MkMan/kDqn2fZ7CwCkwG/S7rGDNw+dnrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971040; c=relaxed/simple;
	bh=aZ92cBGikadawS733SmHE9j0KKxvkfJZgfCH1/QFwe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cYC0kcIVQpNG+SoY0HPcprR+n5ZEVRDdvpMvLATabu7fi2kEio8MNI0qCzdxDm5hFkgdZj9hjjaN0i48rATaL0n/Oanz6pawQsY+2gmc2J1G9vOSpq2Y6dNx57qz6Rv7FDsYSn6NxypJhlLTHKlbkwPyhhnN1ZFY8zlWLw3XBgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoLzsNDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoLzsNDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C720C4CECC;
	Mon, 18 Nov 2024 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971040;
	bh=aZ92cBGikadawS733SmHE9j0KKxvkfJZgfCH1/QFwe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hoLzsNDhM4diVoJRQeivGf4VXgcqzPGQUrfekIISOcKgPY0xv0+0dHCpam6aUrg6P
	 RAQmlDOP0VbFfwh4gXZ9n7RHbknOGD8lJu3VXtt/x6JSfiGDnWD/4HGiE4Gq4xVN5U
	 XqM+zmP1Iv8GTrE5qJx5zjc2nvomObs/JXvta1SD4lnAzVwtJ6UjYK8TOFxQzyiQvW
	 km5ojjAK/kjA83rWhC1m+vaKrThxZ7xNo5XSEVnQZXbL7mwtoSjgSofFhP6XDNa60O
	 djfDlQMlmVBaFabxXE+i5mp1JZUzQehdjMcbD2rozX/lTB5zYylmv15U5pWtXDRIWj
	 AhOxnc3jyJwzg==
Date: Mon, 18 Nov 2024 15:03:59 -0800
Subject: [PATCH 10/12] common/rc: _scratch_mkfs_sized supports extra arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064578.904310.6385654630635505402.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
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

