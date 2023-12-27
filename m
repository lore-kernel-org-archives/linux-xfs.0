Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314017F9;
	Mon,  1 Jan 2024 01:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYNRdl7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBB0C433C8;
	Mon,  1 Jan 2024 01:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071008;
	bh=v5t/VCu9Eh7EbvI3dy4porQrhQuQOlHnWICHHOqNeCo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fYNRdl7NPb4pV/jwI4mYXAGYpxNYeVToyjTvuSD0Xnu3hcES+uBSzHnzvMlHeH9u7
	 i9rWK8hJmpovDo4N94up2XlWwwE78pvH1fMgZ9aGxRekvYyjfYl7g9rQ8I4WDj8FKa
	 cj4NXZo+5lT/jkxutoYP7/TfyUE5Eu7utjOenjIeRKa9tqexcg9VZmDP2CHAd+yEYT
	 NY86SUfbvvBsJeLk6vgWKaqULXn6BZRJA6ksfSezbsQRHZu2wen7vlyDpOY+NRavHp
	 Gd42jsHBDfU8Va10jZTw3kQ1aQUBoCLC3e3hIcPTCf+zTVf1gE8IMV06QWahLOenJL
	 WiGKT9lYcwDnQ==
Date: Sun, 31 Dec 2023 17:03:28 +9900
Subject: [PATCH 8/9] generic/331,xfs/240: support files that skip delayed
 allocation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032121.1827358.9242931540348227468.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
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

The goal of this test is to ensure that log recovery finishes a copy on
write operation in the event of temporary media errors.  It's important
that the test observe some sort of IO error once we switch the scratch
device to fail all IOs, but regrettably the test encoded the specific
behavior of XFS and btrfs when the test was written -- the aio write
to the page cache doesn't have to touch the disk and succeeds, and the
fdatasync flushes things to disk and hits the IO error.

However, this is not how things work on the XFS realtime device.  There
is no delalloc on realtime, so the aio write allocates an unwritten
extent to stage the write.  The allocation fails due to EIO, so it's the
write call that fails.  Therefore, all we need to do is to detect an IO
error at any point between the write and the fdatasync call to be
satisfied that the test does what we want to do.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/331     |   12 ++++++++++--
 tests/generic/331.out |    2 +-
 tests/xfs/240         |   13 +++++++++++--
 tests/xfs/240.out     |    2 +-
 4 files changed, 23 insertions(+), 6 deletions(-)


diff --git a/tests/generic/331 b/tests/generic/331
index 492abedf76..8c665ce4fc 100755
--- a/tests/generic/331
+++ b/tests/generic/331
@@ -59,9 +59,17 @@ echo "CoW and unmount"
 $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
 sync
+
+# If the filesystem supports delalloc, then the fdatasync will report an IO
+# error.  If the write goes directly to disk, then aiocp will return nonzero.
+unset write_failed
 _dmerror_load_error_table
-$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -c "fdatasync" $testdir/file2
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 &>> $seqres.full || \
+	write_failed=1
+$XFS_IO_PROG -c "fdatasync" $testdir/file2 2>&1 | grep -q 'Input.output error' && \
+	write_failed=1
+test -n $write_failed && echo "write failed"
+
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/generic/331.out b/tests/generic/331.out
index adbf841d00..d8ccea704b 100644
--- a/tests/generic/331.out
+++ b/tests/generic/331.out
@@ -5,7 +5,7 @@ Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file1
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file2
 CoW and unmount
-fdatasync: Input/output error
+write failed
 Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file1
 d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-331/file2
diff --git a/tests/xfs/240 b/tests/xfs/240
index a65c270d23..cabe309201 100755
--- a/tests/xfs/240
+++ b/tests/xfs/240
@@ -66,8 +66,17 @@ $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
 sync
 _dmerror_load_error_table
-$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -c "fdatasync" $testdir/file2
+
+# If the filesystem supports delalloc, then the fdatasync will report an IO
+# error.  If the write goes directly to disk, then aiocp will return nonzero.
+unset write_failed
+_dmerror_load_error_table
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 &>> $seqres.full || \
+	write_failed=1
+$XFS_IO_PROG -c "fdatasync" $testdir/file2 2>&1 | grep -q 'Input.output error' && \
+	write_failed=1
+test -n $write_failed && echo "write failed"
+
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/xfs/240.out b/tests/xfs/240.out
index 1a22e8a389..00bb116e5c 100644
--- a/tests/xfs/240.out
+++ b/tests/xfs/240.out
@@ -5,7 +5,7 @@ Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file1
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file2
 CoW and unmount
-fdatasync: Input/output error
+write failed
 Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file1
 d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-240/file2

