Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E51DDA1B;
	Wed, 12 Feb 2025 03:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331151; cv=none; b=eUIv6W135wPiSOcRMzFYspsVfK1ugKWjzMBZ3X7/FFra6Sf+k3vPhng4eOTWGwx5ElVP02aOJL4nzR/ml/cEcl3+AJbXYIBLBh0fj7bmYW4zhtzr7oarXVUVfUHz8bhbDyCQ01r9dsZXA2ckqK33jhAEwN+i7O8TkAjitDNbdi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331151; c=relaxed/simple;
	bh=8Se6yxokSnj6EWTqOripk2jIabIyG0rLTCS0st/KCkY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pc5g3fLW6ZrZrTkkuebMc6HCcgUdjtcN7c9n6yh2lSsrGDe5bcml3u8myawTkwele6eL4LBNMI7qECyR6G4M1hbYf/YF5zFE9t2lSGkv/weoimCoTpezl61N8dOlR8GcvMOp24BHnLipexuFXeCPthKEHkqV+6Zqhe8louHLUC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIN0smgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIN0smgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CA8C4CEE4;
	Wed, 12 Feb 2025 03:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331151;
	bh=8Se6yxokSnj6EWTqOripk2jIabIyG0rLTCS0st/KCkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AIN0smgPU19daiQxtDZacniEV48MKZn8Mkz6QuyHLYD3QKL76klniHpOpXEWSTsAW
	 AZ8ti0sHBeHko6VgCJZHmw2r5M4K8dZxwmrutTknxzXlXFmKtGWOlyNkOMnex7+FUK
	 H0dUaiPUcvAKPESLoxQqioG5QrWRR2MaI2vSZCN3yiAWkV2gPzf1TFxyo7GW1GkT3M
	 uq0wi1c051xWZcXKx21UpRU5+N05ePfV4qsgzOsJH3tkhsxJFkM6QCvJ1BLSs6T8sJ
	 Y8Rh2VWD23dHSE/pXyy3hF83meSO6Cew/8W3QqblBnwUx551eDMh4Jf9TMIpcsLVHb
	 E5+pG8lKtyu1A==
Date: Tue, 11 Feb 2025 19:32:30 -0800
Subject: [PATCH 07/34] common/dump: don't replace pids arbitrarily
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094462.1758477.11155194081302898676.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the next patch we'll run tests in a pid namespace, which means that
the test process will have a very low pid.  This low pid situation
causes problems with the dump tests because they unconditionally replace
it with the word "PID", which causes unnecessary test failures.

Initially I was going to fix it by bracketing the regexp with a
whitespace/punctuation/eol/sol detector, but then I decided to remove it
see how many sheep came barreling through.  None did, so I removed it
entirely.  The commit adding it (linked below) was not insightful at
all.

Fixes: 19beb54c96e363 ("Extra filtering as part of IRIX/Linux xfstests reconciliation for dump.")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/dump |    1 -
 1 file changed, 1 deletion(-)


diff --git a/common/dump b/common/dump
index 3761c16100d808..6dcd6250c33147 100644
--- a/common/dump
+++ b/common/dump
@@ -907,7 +907,6 @@ _dir_filter()
     -e "s#$SCRATCH_MNT#SCRATCH_MNT#g"       \
     -e "s#$dump_sdir#DUMP_SUBDIR#g"   \
     -e "s#$restore_sdir#RESTORE_SUBDIR#g" \
-    -e "s#$$#PID#g" \
     -e "/Only in SCRATCH_MNT: .use_space/d" \
     -e "s#$RESULT_DIR/##g" \
 

