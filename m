Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135B07FD;
	Mon,  1 Jan 2024 01:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGmEneI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30EEC433C8;
	Mon,  1 Jan 2024 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070820;
	bh=IfjQZHXjRIiqHQ3FFzV1RNJqYfT5tIMuzLDYlQRjQf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PGmEneI4edwYxH9A9SA+BK9DjXXIrjoA/MkEg6WfilossJB8QYCaM91HAKrlBIhEA
	 /3c3xho67XxyUGZJoJK0+zBl06YGGXYieUxMfdh5wGHy9x5OHPZKqlke848UoEZneM
	 +aySyTr1PmVwW06jLCv2cSxdOTfZSEENbEiuIhuwvXtG4aMNGSdi22f8zTRpjoCTQB
	 vJq4pv6cOA8Mr5mAIHdULUscweNoSSMJ6WvAr59WslULLKUk8k8PtKpYasEHoNBKOo
	 ej3MPgF+bZAJmrlBLkLfcmwhnd+1QbSGCINpCF+oUBuT11O6CvkdBQIR4FwgCTrtrc
	 WfY9YyoSIXgCQ==
Date: Sun, 31 Dec 2023 17:00:20 +9900
Subject: [PATCH 10/13] xfs/443: use file allocation unit, not dbsize
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031365.1826914.17503370018968217272.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

We can only punch in units of file allocation boundaries, so update this
test to use that instead of the fs blocksize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/443 |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/443 b/tests/xfs/443
index 56828decae..ab3cda59f3 100755
--- a/tests/xfs/443
+++ b/tests/xfs/443
@@ -40,14 +40,15 @@ _scratch_mount
 
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
@@ -55,12 +56,12 @@ $here/src/punch-alternating $file2
 # btree format.
 for i in $(seq 1 2 399); do
 	# punch one extent from the tmpfile and swap
-	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "fpunch $((i * file_blksz)) $file_blksz" $file2
 	$XFS_IO_PROG -c "swapext $file2" $file1
 
 	# punch the same extent from the old fork (now in file2) to resync the
 	# extent counts and repeat
-	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "fpunch $((i * file_blksz)) $file_blksz" $file2
 done
 
 # sanity check that no extents are left over

