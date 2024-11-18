Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA471E6DC2;
	Mon, 18 Nov 2024 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970962; cv=none; b=nwymCCKU0i9VJ0Dnc6kGbrs/RJl10BZZydAZ1DZsEqMKlyYRwfiUv5ZlqMKu/TF1bLwoPATo3yicHzpqAuA4biWbJ/IZjxBcIXeHKC9dCGgz0PcLLmf3zsPSHXTM8zTIBVhfvz/2rJQngAWnYgcFG12J8Y/Mw4e6L2AiNYXa2As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970962; c=relaxed/simple;
	bh=+MawB7cwzzMb3BL0woY87nFbUmAX4umDudmAGod8v2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNu6T8W2haWocAJCNpeVOsEAoVi98Wxsgxtptn0ebdB8PZU1DXgI8ZW1mobS/MEUfkulUBP+3QBXjiHxMT+6JS4EI5q5Gs/29uvGvF5Ut+4lj4NIHEQcYS7NXB7hRj4pnC+XA8pmSCNMard2QEUk5Y5qjeWtT2+KcMbS7rursNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugQuk9Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugQuk9Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8A5C4CECC;
	Mon, 18 Nov 2024 23:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970961;
	bh=+MawB7cwzzMb3BL0woY87nFbUmAX4umDudmAGod8v2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugQuk9LkpX83Ltrbu7ZpNdqpJgQ7SgbVTr1IV/Fx9neJ/+cheG1N7HNlrOFP6Yzq2
	 6b1YIhK/u16SpDQgTSUYgY1L20jwlwXqnSptJjaAGNSaK1EdZUqGT1aLQECP2IvNZ3
	 5GU+LMRNu48tOglcD+oM7ZOiXrBEIHulwxmQ8WOO9fx+HUe9sSMjqW1tgy102FP8+4
	 YrIZ1hVOTIQe4ulrwJjI7XnAFR2XExAPawiYKaYCC9lzr+VZl4SscdOdO8y5PxpRqO
	 5Ui5CmXGMc2rAiYEsxPcQ/BSAlrsCETCWICvRKeAE6APjkZexKlHmHoZWyhSrUPJ6k
	 +OCIau6aBbMxw==
Date: Mon, 18 Nov 2024 15:02:41 -0800
Subject: [PATCH 05/12] generic/562: handle ENOSPC while cloning gracefully
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064501.904310.1505759730439532159.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

This test creates a couple of patterned files on a tiny filesystem,
fragments the free space, clones one patterned file to the other, and
checks that the entire file was cloned.

However, this test doesn't work on a 64k fsblock filesystem because
we've used up all the free space reservation for the rmapbt, and that
causes the FICLONE to error out with ENOSPC partway through.  Hence we
need to detect the ENOSPC and _notrun the test.

That said, it turns out that XFS has been silently dropping error codes
if we managed to make some progress cloning extents.  That's ok if the
operation has REMAP_FILE_CAN_SHORTEN like copy_file_range does, but
FICLONE/FICLONERANGE do not permit partial results, so the dropped error
codes is actually an error.

Therefore, this testcase now becomes a regression test for the patch to
fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/562 |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/tests/generic/562 b/tests/generic/562
index 91360c4154a6a2..62899945003513 100755
--- a/tests/generic/562
+++ b/tests/generic/562
@@ -15,6 +15,9 @@ _begin_fstest auto clone punch
 . ./common/filter
 . ./common/reflink
 
+test "$FSTYP" = "xfs" && \
+	_fixed_by_kernel_commit XXXXXXXXXX "xfs: don't drop errno values when we fail to ficlone the entire range"
+
 _require_scratch_reflink
 _require_test_program "punch-alternating"
 _require_xfs_io_command "fpunch"
@@ -48,8 +51,11 @@ while true; do
 done
 
 # Now clone file bar into file foo. This is supposed to succeed and not fail
-# with ENOSPC for example.
-_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full
+# with ENOSPC for example.  However, XFS will sometimes run out of space.
+_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
+cat $tmp.err
+grep -q 'No space left on device' $tmp.err && \
+	_notrun "ran out of space while cloning"
 
 # Unmount and mount the filesystem again to verify the operation was durably
 # persisted.

