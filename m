Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F340621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710896; cv=none; b=RC+WjEdAm4uOWaHcl2ajdJvz6tFESc0GK3FlAYEOv7oHsSKcxA+zjg07uWnJlIQUVtAilHtCwvNe9WoCDR4H+V10t2GmjviK4d1ga0nJGVwXAfpa/beev2oOSTH4HF9wIVTcjTZgM0pV5FjohPozXdGLp3m5YvYBrjp0bAEEt2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710896; c=relaxed/simple;
	bh=a44EIScXpHqAYmMge+z4VGTetNu72SJqVZnLBAQHNAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LDi4FLBNGNoIlJBcUydLAE9fHzKBuyYM6uDPootLaye4e6TjD4BNOLqHotEVxuWvZ/dATdCJRLHxI5QlUuDZPktmBKz0NIgcF+nJ03sKNG6DPJSpEuLybf1MiO0xS7mK3YaANwqi0VBNktnn+bSrtCvFbweDpvtDYlpz9Lz+Hz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YK+rTSEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YK+rTSEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44305C433F1;
	Wed, 10 Apr 2024 01:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710896;
	bh=a44EIScXpHqAYmMge+z4VGTetNu72SJqVZnLBAQHNAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YK+rTSEC4yIcmkO7j1iVolkFW9Zmklxe0Ps0+hudZg0HElDr+xAtYnqDtjlAW48QG
	 mNwxAG6zt0MirV5rw/uSM+8HwFUzK2dVCW9iDDJFrtbJi3RD4SmQnrrZ/uwFvi2hXV
	 ePSU18c0tlInZQzCXjjo+15IyMCRIF3G7jc5XSLHw9C0QCRZVtxixMLEfvyy+JDasc
	 mkgMwOH8kHExF+dZN6RTTdwNZTyzGocNYSkaEDabnRCCkL7pP1o1k0AHRLArtQGviQ
	 X0qnlGTfZwNBlSG8zfeHMkOwJaBRf6FVFmQIWL5OmdKmOMdLw/AGHABAWcDJ/ImN+3
	 jkb7OgiXvQA0A==
Date: Tue, 09 Apr 2024 18:01:35 -0700
Subject: [PATCH 31/32] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970075.3631889.13494808585016033882.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Let's also drop the oversized minimum log computations for reflink and
rmap that were the result of bugs introduced many years ago.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 3518d5e21df03..d3bd6a86c8fe9 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -24,6 +24,11 @@
  * because that can create the situation where a newer mkfs writes a new
  * filesystem that an older kernel won't mount.
  *
+ * Several years prior, we also discovered that the transaction reservations
+ * for rmap and reflink operations were unnecessarily large.  That was fixed,
+ * but the minimum log size computation was left alone to avoid the
+ * compatibility problems noted above.  Fix that too.
+ *
  * Therefore, we only may correct the computation starting with filesystem
  * features that didn't exist in 2023.  In other words, only turn this on if
  * the filesystem has parent pointers.
@@ -80,6 +85,15 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * If the feature set is new enough, drop the oversized minimum log
+	 * size computation introduced by the original reflink code.
+	 */
+	if (xfs_want_minlogsize_fixes(&mp->m_sb)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

