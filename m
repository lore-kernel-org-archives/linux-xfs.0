Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEFA28628D;
	Wed, 19 Feb 2025 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927176; cv=none; b=YUFemPAZOpqT0wPp0dYwoa/APA3oSLvX+YL/YtpHLdXiOgR3ARItZ5czxpd8BMT8GnIUbE7jKjOkOBZj/TPZQhq/8WwrLD0ADO8iIPZaQHag1cmMz8izMSroeUZ3a/fqUzdfhMov3ywXkR6f6aroasYFR2lTmJAEA7/GzfJB2O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927176; c=relaxed/simple;
	bh=+SUfAL8wjjdlus8Hk1ECOxHa3I3B8xgeYisT8j1H03w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q5JPCmghGye42aC/PFaayBiKoFyFRbHMLENz1zCuT4lKjW3e8vp4c4j8qh1q1SWdorOzNkpnBeJ1FN95r3UfM4wXEaovdxaUHIqv3hzxfJzzbNDoJHd7dmECYbdVheDriTI6gj/puS6Trq8NrfO7mYqqt7YVciAdCPISq0+N2m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njUcYFB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njUcYFB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD4EC4CEE2;
	Wed, 19 Feb 2025 01:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927175;
	bh=+SUfAL8wjjdlus8Hk1ECOxHa3I3B8xgeYisT8j1H03w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=njUcYFB7QafsvP/H2IqY3SRfazTDwgtBW/puthL4s60pAn2ViO1q0zrDaqY1XrRE4
	 IvtOHhxgwjzLvNmSzh6LYNDq1+OPnVv/zs8neuHxOP4Skuja5vTapY3c/ORms3qwNk
	 dTmToxjhS8JstlHqeyq1P0XWSTNZ5/op+H8UFRTIUpPoEA2YbtFl7m3ExWW0NA85b4
	 OtNu+pZjuuS2BLoHK5SzeBd3pgElb1MtB5uuw7yh/0kzVeq/MgGmKX+U9VyFGVYRj0
	 pOqPZH5ExkhtWP89cYAx+/x2E7MXaItvBXu+A0I5jjeVdA4qdlY8uPaaSPznyKyXQi
	 r6XuEHhOl9oNw==
Date: Tue, 18 Feb 2025 17:06:15 -0800
Subject: [PATCH 10/13] xfs/443: use file allocation unit, not dbsize
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591294.4080556.4260451757807530626.stgit@frogsfrogsfrogs>
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

We can only punch in units of file allocation boundaries, so update this
test to use that instead of the fs blocksize.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/443 |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/443 b/tests/xfs/443
index 8db51a834d094e..0e3c6519a3c0f7 100755
--- a/tests/xfs/443
+++ b/tests/xfs/443
@@ -38,14 +38,15 @@ _scratch_mount
 
 file1=$SCRATCH_MNT/file1
 file2=$SCRATCH_MNT/file2
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
 
 # The goal is run an extent swap where one of the associated files has the
 # minimum number of extents to remain in btree format. First, create a couple
 # files with large enough extent counts (200 or so should be plenty) to ensure
 # btree format on the largest possible inode size filesystems.
-$XFS_IO_PROG -fc "falloc 0 $((400 * dbsize))" $file1
+$XFS_IO_PROG -fc "falloc 0 $((400 * file_blksz))" $file1
 $here/src/punch-alternating $file1
-$XFS_IO_PROG -fc "falloc 0 $((400 * dbsize))" $file2
+$XFS_IO_PROG -fc "falloc 0 $((400 * file_blksz))" $file2
 $here/src/punch-alternating $file2
 
 # Now run an extent swap at every possible extent count down to 0. Depending on
@@ -53,12 +54,12 @@ $here/src/punch-alternating $file2
 # btree format.
 for i in $(seq 1 2 399); do
 	# punch one extent from the tmpfile and swap
-	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "fpunch $((i * file_blksz)) $file_blksz" $file2
 	$XFS_IO_PROG -c "exchangerange $file2" $file1
 
 	# punch the same extent from the old fork (now in file2) to resync the
 	# extent counts and repeat
-	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "fpunch $((i * file_blksz)) $file_blksz" $file2
 done
 
 # sanity check that no extents are left over

