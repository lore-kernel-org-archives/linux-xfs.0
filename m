Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84764A02;
	Mon,  1 Jan 2024 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJMozmzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A500AC433C8;
	Mon,  1 Jan 2024 00:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070648;
	bh=gr4SMOJ41U2PLOSrBIJPCzWxQeykfR4VWfQXCDEEOZs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tJMozmzbPqBToCftsFSa/yqbaNK3MAUeohXGT8ukjD7IOqurrkCWOKhUeIn7nW3mo
	 17Eg6rkpNMr7ctlaPPzzGQx3LCcYndqR4HLW9eUq2z1mAfd3SdcS1msAe7UphkKVCB
	 cMijmsgnVSTTs+aYYxgKvA5fKP/mJI8dTcK7dd6Vl7ZJ8mkssuPTIEyemQyjjn2Yva
	 wOl7ELFQIDN4HR60GZ0tUcllwrwCPc6TsjJczgl6jDu1sxpXTKoeGwyPbQzEBZPcz/
	 xV604IAW5TK8RD4E9YoMAFYEfSson1zC2/VzT6YSuRqtDrB9Rbo/E+yhLZq3IzTKCN
	 /nYUt89pyeskA==
Date: Sun, 31 Dec 2023 16:57:28 +9900
Subject: [PATCH 1/2] xfs: refactor statfs field extraction
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030881.1826812.8733545912595670620.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030868.1826812.10067703094837693199.stgit@frogsfrogsfrogs>
References: <170405030868.1826812.10067703094837693199.stgit@frogsfrogsfrogs>
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

Prepare for the next patch by refactoring the open-coded bits that call
statfs on a mounted xfs filesystem to extract a status field.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |    6 ++++++
 tests/xfs/176 |    4 ++--
 tests/xfs/187 |    6 +++---
 tests/xfs/541 |    6 ++----
 4 files changed, 13 insertions(+), 9 deletions(-)


diff --git a/common/xfs b/common/xfs
index 313b7045bd..d9aa242ec7 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2063,3 +2063,9 @@ _require_xfs_scratch_metadir()
 		_scratch_unmount
 	fi
 }
+
+# Extract a statfs attribute of the given mounted XFS filesystem.
+_xfs_statfs_field()
+{
+	$XFS_IO_PROG -c 'statfs' "$1" | grep -E "$2" | cut -d ' ' -f 3
+}
diff --git a/tests/xfs/176 b/tests/xfs/176
index 5231b888ba..0af81fcce3 100755
--- a/tests/xfs/176
+++ b/tests/xfs/176
@@ -49,7 +49,7 @@ fi
 
 _scratch_mount
 _xfs_force_bdev data $SCRATCH_MNT
-old_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
+old_dblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
 
 mkdir $SCRATCH_MNT/save/
 sino=$(stat -c '%i' $SCRATCH_MNT/save)
@@ -172,7 +172,7 @@ for ((ino = target_ino; ino >= icluster_ino; ino--)); do
 	res=$?
 
 	# Make sure shrink did not work
-	new_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
+	new_dblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
 	if [ "$new_dblocks" != "$old_dblocks" ]; then
 		echo "should not have shrank $old_dblocks -> $new_dblocks"
 		break
diff --git a/tests/xfs/187 b/tests/xfs/187
index 14c3b37670..03d92d0890 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -79,8 +79,8 @@ _xfs_force_bdev realtime $SCRATCH_MNT
 
 # Set the extent size hint larger than the realtime extent size.  This is
 # necessary to exercise the minlen constraints on the realtime allocator.
-fsbsize=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.bsize | awk '{print $3}')
-rtextsize_blks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.rtextsize | awk '{print $3}')
+fsbsize=$(_xfs_statfs_field "$SCRATCH_MNT" geom.bsize)
+rtextsize_blks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtextsize)
 extsize=$((2 * rtextsize_blks * fsbsize))
 
 echo "rtextsize_blks=$rtextsize_blks extsize=$extsize" >> $seqres.full
@@ -136,7 +136,7 @@ rtextsize_bytes=$((fsbsize * rtextsize_blks))
 $here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / rtextsize_bytes))
 
 # Make sure we have some free rtextents.
-free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')
+free_rtx=$(_xfs_statfs_field "$SCRATCH_MNT" statfs.f_bavail)
 if [ $free_rtx -eq 0 ]; then
 	echo "Expected fragmented free rt space, found none."
 fi
diff --git a/tests/xfs/541 b/tests/xfs/541
index ae2fd819d5..3a0a9d5390 100755
--- a/tests/xfs/541
+++ b/tests/xfs/541
@@ -83,13 +83,11 @@ test $grow_extszhint -eq 0 || \
 	echo "expected post-grow extszhint 0, got $grow_extszhint"
 
 # Check that we now have rt extents.
-rtextents=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | \
-	grep 'geom.rtextents' | cut -d ' ' -f 3)
+rtextents=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtextents)
 test $rtextents -gt 0 || echo "expected rtextents > 0"
 
 # Check the new rt extent size.
-after_rtextsz_blocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | \
-	grep 'geom.rtextsize' | cut -d ' ' -f 3)
+after_rtextsz_blocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtextsize)
 test $after_rtextsz_blocks -eq $new_rtextsz_blocks || \
 	echo "expected rtextsize $new_rtextsz_blocks, got $after_rtextsz_blocks"
 

