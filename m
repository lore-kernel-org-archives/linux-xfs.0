Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9804B7462;
	Tue, 26 Nov 2024 01:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584221; cv=none; b=oosE1jtrwXO/9zft6vlWEqIUoAHhhEkusRQjxrT1Sq0jmtG7sO5Y1mYkjm2RUrNi8JCTO088o3jZ8RSmbjtQJtJLpsBl6Vl4QpWKRfYDLv+V+W7tXp2/6nKnjFEWuGDWD+S9GaB3JreRiMWHzmins/pW5orG8lodEWsTmADd2qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584221; c=relaxed/simple;
	bh=aZ92cBGikadawS733SmHE9j0KKxvkfJZgfCH1/QFwe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVJruVMvz74Jet8RcpejQs/ZPWg7QQvzVs/UcRffZVRcxuuuBSt64Zx/vSerzFhypF6Oj7b4ZRHLkTNc6LxPjLsXR7bgCwuzytrjyFC1eM0rovsMyzRF3fgoFcTuP6WNvlJUjsm23Ja4JFFrJyVrboluiqXLz6y6H8udrnxQRSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jk/m27qR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jk/m27qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03706C4CECE;
	Tue, 26 Nov 2024 01:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584221;
	bh=aZ92cBGikadawS733SmHE9j0KKxvkfJZgfCH1/QFwe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jk/m27qRZWDpCRoReVshzp79TQpMEiIahBRQ6iY+2udm4quCnIIyNTo1o//N0XWHl
	 pbZfmYNe7V+1rdaNbPFJ5WNgEyR9R+61Pv3vwikRdjV5Z5viPJOrLKj8lou98IaNZU
	 xogyj8hXJjaf4l1hLhkfe4YbZ+98TdJMxnaYeJBnqhYjX0karfNou7RLxT7YZwkR7o
	 hhm81Eg8DyARn3xJG9qYjBA4moQ9rCOLyVwyrCmWIjSxdGBJJFrQZtf9siA55NtoeW
	 Le/lEHZ04YpZH0Zmenjh0nEvtojloQnXSeq8wO/ZEuEG9P2VCJev1mS0buY4T/HTAr
	 AGJO+WuicQxww==
Date: Mon, 25 Nov 2024 17:23:40 -0800
Subject: [PATCH 12/16] common/rc: _scratch_mkfs_sized supports extra arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395253.4031902.12874006046992433886.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
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

