Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE821171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390034; cv=none; b=cphUYzKr82sFOtrLj6qqoXbD5TET2tfAUaGZjbm0fII92KM35TxYhaQqOUuxyyrBoWvwwl4l/zg5WWCBYLPsYyUxryPuoE6e/PP/fxDTyOYbbMxycvolwzMNBAtRJEw51fdCDUbB4KZ0to37aRmAekw8eNxieeqq/HGN1Ye6bv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390034; c=relaxed/simple;
	bh=ZyKGosPztRbhz3cKB2Ce99cbEzgVsubIDVJF/c1KzlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9sBXkG3MkCieERGoaHOBOwRnrqubXmJOsnKjYP1Jg/XoynoG56Xo/4choFLNbdp2goUaoFNH9sbF56sbTXEkzX6F5euJnYfznHC57gF75h2cDxhasl+Wx8/3JAS1uac9KqPxgGvvBXpEqiyOIKZ6xkGXT7G8eILUucvJMuQv+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heAdl/9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heAdl/9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88926C072AA;
	Wed, 17 Apr 2024 21:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390034;
	bh=ZyKGosPztRbhz3cKB2Ce99cbEzgVsubIDVJF/c1KzlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=heAdl/9kKX6b7Qzd+muOV1vvXUTnxJ/zmZQEPvhN0Hh84qUThaLwOi1EXmCnXzhFS
	 0hE7IxWZD0PJWo9yA9e9I2NwJFMu2qRg3Iz341mjfNVdeGzYgJz6W5RgwbjSqG47z4
	 8Ayl09wleXjq07B9yQWegD22SyYLICsYl+/A3NZQNzZnBozLCzbWHic1AytP/shC8W
	 5WmiBA3rxtsbWS+fTTk5buj7fdCTfzzGS/u2s9qxt+RTI5UQen2tlRQSdgplXNOCUo
	 d2tWxJQE0cD8L8t71ffBLq7uGYg/Macw+r13o4W+NLfdmnwbjpwhMC002iPNViC2Jp
	 3PyFAF5PGT5uQ==
Date: Wed, 17 Apr 2024 14:40:33 -0700
Subject: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338844023.1855783.12171367969251823508.stgit@frogsfrogsfrogs>
In-Reply-To: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
References: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
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

If a filesystem has a realtime device or an external log device, the
media scan can start up a separate readverify controller (and workqueue)
to handle that.  Each of those controllers can call progress_add, so we
need to bump up nr_threads so that the progress reports controller knows
to make its ptvar big enough to handle all these threads.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase6.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 99a32bc79..393d9eaa8 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -743,7 +743,17 @@ phase6_estimate(
 
 	*items = cvt_off_fsb_to_b(&ctx->mnt,
 			(d_blocks - d_bfree) + (r_blocks - r_bfree));
+
+	/*
+	 * Each read-verify pool starts a thread pool, and each worker thread
+	 * can contribute to the progress counter.  Hence we need to set
+	 * nr_threads appropriately to handle that many threads.
+	 */
 	*nr_threads = disk_heads(ctx->datadev);
+	if (ctx->rtdev)
+		*nr_threads += disk_heads(ctx->rtdev);
+	if (ctx->logdev)
+		*nr_threads += disk_heads(ctx->logdev);
 	*rshift = 20;
 	return 0;
 }

