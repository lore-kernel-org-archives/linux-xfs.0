Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793A325757;
	Wed, 19 Feb 2025 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927316; cv=none; b=DzYthfN33t60UFia+ZUG4XrKe8lQ4RPvf/lkJqpYcz3L9wfJenvYxEWJacRsTm3BzVIwO6bxR8b04f6BuHA09+6esITZ9GgScW9vNSGm9KxydazNkV51yq0pq0EDEhTzMgI66io7T2ek6Y2Ykpoln4+YWsmFJZm0kNN5mEtYduY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927316; c=relaxed/simple;
	bh=PRKM71L7YTWGMDmPr1mAluU3wLZNxdjp/th4NI8qlE0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mEeM7Pt2SeSWRQGev4AtVjfQ227v1FaCLZCWSBbNR72Kg1YPWYVmjW3s6sWxZqlZWO8967LKCCJ4EKEY+diweRGET/dzg5eReiV8vUfvub1YlGhC7oPynu9RChjbDPxA1zzYi7Ph8lt9zcRJktCKspBbaVMQHyDexNaJi+WHSl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mP39EoS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mP39EoS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F2AC4CEE2;
	Wed, 19 Feb 2025 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927316;
	bh=PRKM71L7YTWGMDmPr1mAluU3wLZNxdjp/th4NI8qlE0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mP39EoS7izvga3wLP/ckFHM5hyWl6F7O7dODH7VBCnDSrVCoK2s2TQjaH9DrlrwKQ
	 N6Sh0NdYPGdIf7UD+/myV0CFenGk+t08AwH+8NBRC6wJU1hN6Ws3krXwqlnTaU/u+M
	 VaoFbkKvE8aWdtMXOykejCOC6Pjskt0agzO8+irQeXwPZ25GQlTsaMzPU6RN6Czbe6
	 P0UaTWYt3IlZT4o9geC+vIH0JbSOuxC719D0QTy1lcL1sOpzgUWQuJpU0+b8p28X8E
	 D0tgeMWLuLqzqp8ix+DAykyVzCk+8RS2LDCi2xu1x4/eSwPmyncRpuvgKxJObDwh/B
	 +MDNKRKoR8Ksg==
Date: Tue, 18 Feb 2025 17:08:35 -0800
Subject: [PATCH 6/7] generic/331,xfs/240: support files that skip delayed
 allocation
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591863.4081089.12040886084163242816.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
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
is no delalloc on realtime when the rt extent size > 1 fsblock (or on
any file with extent size hints), so the aio write allocates an
unwritten extent to stage the write.  The allocation fails due to EIO,
so it's the write call that fails.  Therefore, all we need to do is to
detect an IO error at any point between the write and the fdatasync call
to be satisfied that the test does what we want to do.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/331     |   13 +++++++++++--
 tests/generic/331.out |    2 +-
 tests/xfs/240         |   12 ++++++++++--
 tests/xfs/240.out     |    2 +-
 4 files changed, 23 insertions(+), 6 deletions(-)


diff --git a/tests/generic/331 b/tests/generic/331
index 704bb1283ecb85..a079ba297c201b 100755
--- a/tests/generic/331
+++ b/tests/generic/331
@@ -58,10 +58,19 @@ echo "CoW and unmount"
 $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
 _scratch_sync
+
+# If the filesystem supports delalloc, then the fdatasync will report an IO
+# error.  If the write goes directly to disk, then aiocp will return nonzero.
+unset write_failed
 _dmerror_load_error_table
-$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full 2>&1
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full 2>&1 || \
+	write_failed=1
 $XFS_IO_PROG -c "fdatasync" $testdir/file2 |& \
-		_filter_flakey_EIO "fdatasync: Input/output error"
+		_filter_flakey_EIO "fdatasync: Input/output error" | \
+		grep -q 'Input.output error' && \
+		write_failed=1
+test -n $write_failed && echo "write failed"
+
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/generic/331.out b/tests/generic/331.out
index adbf841d00c9d1..d8ccea704b8532 100644
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
index 8916828a8c1958..6b26620f883378 100755
--- a/tests/xfs/240
+++ b/tests/xfs/240
@@ -64,9 +64,17 @@ $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
 _scratch_sync
 _dmerror_load_error_table
-$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full 2>&1
+# If the filesystem supports delalloc, then the fdatasync will report an IO
+# error.  If the write goes directly to disk, then aiocp will return nonzero.
+unset write_failed
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full 2>&1 || \
+	write_failed=1
 $XFS_IO_PROG -c "fdatasync" $testdir/file2 |& \
-		_filter_flakey_EIO "fdatasync: Input/output error"
+		_filter_flakey_EIO "fdatasync: Input/output error" | \
+		grep -q 'Input.output error' && \
+		write_failed=1
+test -n $write_failed && echo "write failed"
+
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/xfs/240.out b/tests/xfs/240.out
index 1a22e8a389ffda..00bb116e5c1613 100644
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

