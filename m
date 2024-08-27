Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E745024;
	Tue, 27 Aug 2024 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784415; cv=none; b=Xt0ZWq4/F7SELXMjmRTeHeHHE2MHqL2RR5li/ZyWspJ+SRzfK23zHmNub7ZMwD2+s5rFq8dH7NnubDjNjf74OXRrYEt64vjjNN6B0LbkObCGT92iIoBljYgvU15kv7KJgtlp3cKb4T4+l2V+0Ic5lDflx/vHw55V1ljTgU9k35g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784415; c=relaxed/simple;
	bh=GV02vmXBWEfvxZWz9UG6iKbf9KtxLjRxvba4U6cdGJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIsnHLzpoOyWAIJbsZMzCPwqSVx4SDAVKzBvblSz/N7WDzjylGw5I7U6N3E8sR9c2DdqvrcxNqHzwpnSOH+5jC97DE6zTQJwPURYD8L1xV8hddHz1nMPmx27JKo2paPYOl5syTFptxMi7+BkeN/fEA9/NybWW5zhZdw8FxSq0iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ig9s9RzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ig9s9RzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DF6C4FEA1;
	Tue, 27 Aug 2024 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784415;
	bh=GV02vmXBWEfvxZWz9UG6iKbf9KtxLjRxvba4U6cdGJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ig9s9RzJetMNpXe/hvTHdo3ulwsSr73mzGhIRlRLN/9SFvG3sGPGHpdxf2DdxnvRB
	 ppWsK2BZjy+lHBHzFrE1de6p2xstR1zQcR119s/orNm3hNHesUiqR6AfCsGERp+7iU
	 YrjLQd46uKp07A0mEHVNcl6OGaZwcawn9SMP0h17MhnR/3LrA9w8d0VOL+4RKOa9qS
	 QSkoQyh4mhbQfQoaN7LG1fd3+2glYXipuBZ44lVoq/N+Xt0EToMTvWXYpO7NrHz6uz
	 Xi2PB8jt7+qXpgUaDr/jS5Ua/Tv5QmCByiaowkhfNlMFcG2Hhy4Pv1I4Isqn0UistP
	 YCcCx7zWPihsA==
Date: Tue, 27 Aug 2024 11:46:54 -0700
Subject: [PATCH 1/2] xfs: refactor statfs field extraction
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423399.2039664.15689426615151903933.stgit@frogsfrogsfrogs>
In-Reply-To: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
References: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
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
index 6370f17523..7ee6fbec84 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1818,3 +1818,9 @@ _require_xfs_parent()
 		|| _notrun "kernel does not support parent pointers"
 	_scratch_unmount
 }
+
+# Extract a statfs attribute of the given mounted XFS filesystem.
+_xfs_statfs_field()
+{
+	$XFS_IO_PROG -c 'statfs' "$1" | grep -E "$2" | cut -d ' ' -f 3
+}
diff --git a/tests/xfs/176 b/tests/xfs/176
index db7001a5b9..8d58590fd9 100755
--- a/tests/xfs/176
+++ b/tests/xfs/176
@@ -47,7 +47,7 @@ fi
 
 _scratch_mount
 _xfs_force_bdev data $SCRATCH_MNT
-old_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
+old_dblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
 
 mkdir $SCRATCH_MNT/save/ $SCRATCH_MNT/urk/
 sino=$(stat -c '%i' $SCRATCH_MNT/save)
@@ -170,7 +170,7 @@ for ((ino = target_ino; ino >= icluster_ino; ino--)); do
 	res=$?
 
 	# Make sure shrink did not work
-	new_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
+	new_dblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
 	if [ "$new_dblocks" != "$old_dblocks" ]; then
 		echo "should not have shrank $old_dblocks -> $new_dblocks"
 		break
diff --git a/tests/xfs/187 b/tests/xfs/187
index 04ff9a81b6..56a9adc164 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -77,8 +77,8 @@ _xfs_force_bdev realtime $SCRATCH_MNT
 
 # Set the extent size hint larger than the realtime extent size.  This is
 # necessary to exercise the minlen constraints on the realtime allocator.
-fsbsize=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.bsize | awk '{print $3}')
-rtextsize_blks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.rtextsize | awk '{print $3}')
+fsbsize=$(_xfs_statfs_field "$SCRATCH_MNT" geom.bsize)
+rtextsize_blks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtextsize)
 extsize=$((2 * rtextsize_blks * fsbsize))
 
 echo "rtextsize_blks=$rtextsize_blks extsize=$extsize" >> $seqres.full
@@ -133,7 +133,7 @@ punch_off=$((bigfile_sz - frag_sz))
 $here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
 
 # Make sure we have some free rtextents.
-free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')
+free_rtx=$(_xfs_statfs_field "$SCRATCH_MNT" statfs.f_bavail)
 if [ $free_rtx -eq 0 ]; then
 	echo "Expected fragmented free rt space, found none."
 fi
diff --git a/tests/xfs/541 b/tests/xfs/541
index f18b801cfe..518373fa89 100755
--- a/tests/xfs/541
+++ b/tests/xfs/541
@@ -81,13 +81,11 @@ test $grow_extszhint -eq 0 || \
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
 

