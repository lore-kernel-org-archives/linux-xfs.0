Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F310A22D4F3;
	Fri, 21 Mar 2025 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576061; cv=none; b=jKPGVbqrVIQ5moSThVWJpqyrVcHt7MNvavXIqS+n5LmMu83TbByEAvO0V3gphXOq25hdliphH63UGgxOG5YpNhTpZBMpM1rJVZvAyvovyBV8W1VOgugMFCRMy4P70N188qR1NyxKi8BKWv9m4dPAuLyW2qoGnQae7tWspX2dMPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576061; c=relaxed/simple;
	bh=8dUJmfPs4S10R56woWhthw8lqM8k9CXT9AERs+VsvAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nl3xUqjaSZe+v429bREGlNjK2bdbbra/VZgfQztSTYwQUHN6U6ApNTsJoKJdV7xWPO3ok7W3PRm5cHCs9tZlqfGSOvWPjjWwPI6SCMVb95pqL9Tvoz9jK02CRpNy4P6NKO5LiVUYEUzg+nOvPfD9y1Tdje1mueZ0Z5ZqsCv7GaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trQPcVRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trQPcVRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6527AC4CEE8;
	Fri, 21 Mar 2025 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742576059;
	bh=8dUJmfPs4S10R56woWhthw8lqM8k9CXT9AERs+VsvAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=trQPcVRkyMM8rHbdft3UyOh9Bs2kmMcV5L+On1c4kPjGH2kjvbO6F76Rwtl3esEEp
	 V81br/TsFgaB0PvbVAw9invNYH5UUh4bQKwSebwSdJsnfMmswb1xf8K4K0g1j9RCRF
	 F9BniosWgD4Z/ihRA9AGtrFMt/cmtsjGGzS15KuJbfXH4iMS+8ErDd+Rwgs9TXaaF+
	 1JDHtbHZVDyfvBO6G9LH0Ngnxh4L5k7b9FVKeHxZG2M9N5AvKVsecmEVZGX1CfgWW4
	 vVOMs5peI2AZv80DzFb52bqLEtOYsAuaezuT8TeXvZb1e2JS7ILcZ1ud7ilwyNod3X
	 QmEZPjetJL1Gg==
Date: Fri, 21 Mar 2025 09:54:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5/3] xfs/818: fix some design issues
Message-ID: <20250321165418.GP2803749@frogsfrogsfrogs>
References: <20250312230736.GS2803749@frogsfrogsfrogs>
 <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

While QA'ing zoned filesystem support, I discovered some design errors
in this test:

1) Since we're test formatting a sparse file on an xfs filesystem,
there's no need to play games with optimal device size; we can create
a totally sparse file that's the same size as SCRATCH_DEV.

2) mkfs.xfs cannot create realtime files, so if it fails with that,
there's no need to continue the test.

3) If mkfs -p fails for none of the proscribed reasons, it should exit
the test.  The final cat $tmp.mkfs will take care of tweaking the golden
output to register the test failure for further investigation.

Cc: <fstests@vger.kernel.org> # v2025.03.09
Fixes: 6d39dc34e61e11 ("xfs: test filesystem creation with xfs_protofile")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/818 |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/818 b/tests/xfs/818
index aeb462353df7e9..bc809390b9e340 100755
--- a/tests/xfs/818
+++ b/tests/xfs/818
@@ -75,9 +75,8 @@ _run_fsstress -n 1000 -d $SCRATCH_MNT/newfiles
 make_stat $SCRATCH_MNT before
 make_md5 $SCRATCH_MNT before
 
-kb_needed=$(du -k -s $SCRATCH_MNT | awk '{print $1}')
-img_size=$((kb_needed * 2))
-test "$img_size" -lt $((300 * 1024)) && img_size=$((300 * 1024))
+scratch_sectors="$(blockdev --getsz $SCRATCH_DEV)"
+img_size=$((scratch_sectors * 512 / 1024))
 
 echo "Clone image with protofile"
 $XFS_PROTOFILE_PROG $SCRATCH_MNT > $testfiles/protofile
@@ -99,7 +98,21 @@ if ! _try_mkfs_dev -p $testfiles/protofile $testfiles/image &> $tmp.mkfs; then
 	if grep -q 'No space left on device' $tmp.mkfs; then
 		_notrun "not enough space in filesystem"
 	fi
+
+	# mkfs cannot create realtime files.
+	#
+	# If zoned=1 is in MKFS_OPTIONS, mkfs will create an internal realtime
+	# volume with rtinherit=1 and fail, so we need to _notrun that case.
+	#
+	# If zoned=1 is /not/ in MKFS_OPTIONS, we didn't pass a realtime device
+	# to mkfs so it will not create realtime files.  The format should work
+	# just fine.
+	if grep -q 'creating realtime files from proto file not supported' $tmp.mkfs; then
+		_notrun "mkfs cannot create realtime files"
+	fi
+
 	cat $tmp.mkfs
+	exit
 fi
 
 _mount $testfiles/image $testfiles/mount
