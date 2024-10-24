Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC31C1CF2B6;
	Thu, 24 Oct 2024 11:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769013; cv=none; b=Odbnx97yd9tEY9tCXYOEWbVPorRMgMC+ACNXM2MtnvypKhc3Aslpm7uZHD7u/kNCHpSPHI9gUZ3sghwq2jLBDtXozSBT9p+9LyA9qdk2cCAL7y2lD/fQz1d7eVFdrL6qaLrtOb+133Ryydk9+OYtCQ3gjPTfV8brLJslxcK5Kls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769013; c=relaxed/simple;
	bh=xjd0JkQl3cIa14sr08/ee2QTdXosFQBZjMFlrS9uD8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBRlWrLJnOW2tukxo0BvkhsY6rhvb1xOMFANb4j/lpQ8Ww2AENc+0e8iup/ZJ3Ajwycc+5f9lb091uTiTC8bnlgWIwhqUC4JTub8521Et1NJed+tuGudwD3Unj4TpnuTPpTtbgxPh5Zt4fJiXawtnN6eaI5M1do8Y7pw9g6ta4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4XZ3Sb1F5Zz9smB;
	Thu, 24 Oct 2024 13:23:27 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: fstests@vger.kernel.org,
	zlang@redhat.com
Cc: linux-xfs@vger.kernel.org,
	gost.dev@samsung.com,
	mcgrof@kernel.org,
	p.raghav@samsung.com,
	kernel@pankajraghav.com,
	david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH 2/2] generic: increase file size to match CoW delayed allocation for XFS 64k bs
Date: Thu, 24 Oct 2024 13:23:11 +0200
Message-ID: <20241024112311.615360-3-p.raghav@samsung.com>
In-Reply-To: <20241024112311.615360-1-p.raghav@samsung.com>
References: <20241024112311.615360-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

generic/305,326,328 have been failing for 32k and 64k blocksizes.

We do the following in the test 305 and 326 (highlighting only the part
that is related to failure):

- create a 1M test-1/file1
- reflink test-1/file2 and test-1/file3 based on test-1/file1
- Overwrite first half of test-1/file2 to do a CoW operation
- Expect the size of the test-1 dir to be 3M

The test is failing for 32k and 64k blocksizes as the number of blocks
(direct + delayed) is higher than number of blocks allocated for
blocksizes < 32k in XFS, resulting in size of test-1 to be more than 3M.
Though generic/328 has a different IO pattern, the reason for failure is
the same.

This is the failure output :
    --- tests/generic/305.out   2024-06-05 11:52:27.430262812 +0000
    +++ /root/results//64k_4ks/generic/305.out.bad      2024-10-23 10:56:57.643986870 +0000
    @@ -11,7 +11,7 @@
     CoW one of the files
     root 0 0 0
     nobody 0 0 0
    -fsgqa 3072 0 0
    +fsgqa 4608 0 0
     Remount the FS to see if accounting changes
     root 0 0 0

In these tests, XFS is doing a delayed allocation of
XFS_DEFAULT_COWEXTSIZE_HINT(32). Increase the size of the file so that
the CoW write(sz/2) matches the maximum size of the delayed allocation
for the max blocksize of 64k. This will ensure that all parts of the
delayed extents are converted to real extents for all blocksizes.

Even though this is not the most complete solution to fix these tests,
the objective of these tests are to test quota and not the effect of delayed
allocations.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 tests/generic/305     |  2 +-
 tests/generic/305.out | 12 ++++++------
 tests/generic/326     |  2 +-
 tests/generic/326.out | 12 ++++++------
 tests/generic/328     |  2 +-
 tests/generic/328.out | 16 +++++++++-------
 6 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/tests/generic/305 b/tests/generic/305
index c89bd821..6ccbb3d0 100755
--- a/tests/generic/305
+++ b/tests/generic/305
@@ -32,7 +32,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-sz=1048576
+sz=4194304
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
diff --git a/tests/generic/305.out b/tests/generic/305.out
index fbd4e241..1c348d1e 100644
--- a/tests/generic/305.out
+++ b/tests/generic/305.out
@@ -1,22 +1,22 @@
 QA output created by 305
 Format and mount
 Create the original files
-root 3072 0 0
+root 12288 0 0
 nobody 0 0 0
 fsgqa 0 0 0
 Change file ownership
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 CoW one of the files
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 Remount the FS to see if accounting changes
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 Chown one of the files
 root 0 0 0
-nobody 1024 0 0
-fsgqa 2048 0 0
+nobody 4096 0 0
+fsgqa 8192 0 0
diff --git a/tests/generic/326 b/tests/generic/326
index 1783fbf2..321e7dc6 100755
--- a/tests/generic/326
+++ b/tests/generic/326
@@ -33,7 +33,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-sz=1048576
+sz=4194304
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
diff --git a/tests/generic/326.out b/tests/generic/326.out
index de7f20b5..4ccb3250 100644
--- a/tests/generic/326.out
+++ b/tests/generic/326.out
@@ -1,22 +1,22 @@
 QA output created by 326
 Format and mount
 Create the original files
-root 3072 0 0
+root 12288 0 0
 nobody 0 0 0
 fsgqa 0 0 0
 Change file ownership
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 CoW one of the files
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 Remount the FS to see if accounting changes
 root 0 0 0
 nobody 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 Chown one of the files
 root 0 0 0
-nobody 1024 0 0
-fsgqa 2048 0 0
+nobody 4096 0 0
+fsgqa 8192 0 0
diff --git a/tests/generic/328 b/tests/generic/328
index 0c8e1986..25e1f2a0 100755
--- a/tests/generic/328
+++ b/tests/generic/328
@@ -32,7 +32,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-sz=1048576
+sz=4194304
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
 chown $qa_user $testdir/file1
diff --git a/tests/generic/328.out b/tests/generic/328.out
index b7fe9f8c..0167637e 100644
--- a/tests/generic/328.out
+++ b/tests/generic/328.out
@@ -2,24 +2,26 @@ QA output created by 328
 Format and mount
 Create the original files
 root 0 0 0
-fsgqa 3072 0 0
+fsgqa 12288 0 0
 Set hard quota to prevent rewrite
 root 0 0 0
-fsgqa 3072 0 1024
+fsgqa 12288 0 1024
 Try to dio write the whole file
 pwrite: Disk quota exceeded
 root 0 0 0
-fsgqa 3072 0 1024
+fsgqa 12288 0 1024
 Try to write the whole file
 pwrite: Disk quota exceeded
 root 0 0 0
-fsgqa 3072 0 1024
+fsgqa 12288 0 1024
 Set hard quota to allow rewrite
 root 0 0 0
-fsgqa 3072 0 8192
+fsgqa 12288 0 8192
 Try to dio write the whole file
+pwrite: Disk quota exceeded
 root 0 0 0
-fsgqa 3072 0 8192
+fsgqa 12288 0 8192
 Try to write the whole file
+pwrite: Disk quota exceeded
 root 0 0 0
-fsgqa 3072 0 8192
+fsgqa 12288 0 8192
-- 
2.44.1

