Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2081E170A3E;
	Wed, 16 Oct 2024 23:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120533; cv=none; b=O5CU6zAz63q1sSTSFV0azlk5JkFA6hZsud7y+n6RSyT4xxHSZDqO5sxA/0nEa9+HwxGgAFHzn18zVu6grTewtmfMcnxj4iWly9oMvlr5uBKbNOCjf9PW2GQjZzwixhOpo9EcCBR9PuX/iU+D2VMmb6vWoPffHgvsP823WMYZC2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120533; c=relaxed/simple;
	bh=C5ydWRI+y/VaKF1JhhT87glGETint/k466bW9GRA2Qk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0dt52xLp9Di1vXRmuUk0qatVB1gLq95LiaYLJy3dbrUyd0bP2+8RL81fz5Vi5Ah+q74NIacHsWfNzbKw+RY72kk5+uosT5uavk6qOq8V9SVlLhe54Q6HMzdebFs6M7lmLYS0flqhgcntCiky16NILchp0Nkc3npu9IDpB5H2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POYLrxkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POYLrxkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE465C4CEC5;
	Wed, 16 Oct 2024 23:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729120533;
	bh=C5ydWRI+y/VaKF1JhhT87glGETint/k466bW9GRA2Qk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=POYLrxknEoBMprND0QkgJ+NuSFVT9iyDUjnZ4945aK8Q8oC1+rKKT9m92Ui+K/Wzh
	 sM5goNSpg0qghwWX2ebiKk2eXXDxAzkvV2Pv/gs5Apaux0ehCGSRGACFNNDHoR36Ul
	 xVPp6ZGPFj+AQZA5MGSxQfaOkbZ14msGKzfECRbuc6QbVHUgi/p6d3RxnTv/h98pZE
	 0ZC+gPC17nmySwf6fcoPHXzvfPL7OKztmxoyUwBdBGkQeYKEFh1v3liwx0bVygTEVK
	 Euw67oAeBN1H1wWWYcjkyYkrNfEfRr2cvjcsaleBtp2HJkGWap64P53n52JqjFhMyV
	 C2aVDFDkySy6g==
Date: Wed, 16 Oct 2024 16:15:32 -0700
Subject: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172912045624.2583984.16971966548333767345.stgit@frogsfrogsfrogs>
In-Reply-To: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Pankaj Raghav <p.raghav@samsung.com>

This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
system(see LBS efforts[1]). Adapt the blksz so that we create more than
one block for the testcase.

Cap the blksz to be at least 64k to retain the same behaviour as before
for smaller filesystem blocksizes.

[1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/161 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/161 b/tests/xfs/161
index 002ee7d800dcf1..948121c0569484 100755
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -37,7 +37,11 @@ _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
 _scratch_mount >> $seqres.full
 
 
-blksz=$(_get_file_block_size "$SCRATCH_MNT")
+min_blksz=65536
+file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
+blksz=$(( 2 * $file_blksz))
+
+blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
 # Write more than one block to exceed the soft block quota limit via
 # xfs_quota.
 filesz=$(( 2 * $blksz))

