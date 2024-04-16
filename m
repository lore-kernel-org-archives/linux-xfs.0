Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E7B523D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231232; cv=none; b=DQEKypbJdGzSPm47/JTzNG0+KLlz3PRrrfRpfZS0OwTUnOZjUUVi1AyNDF7hwRCYgiqU/1cK5KVP6G4zEKT1bNmX+B7GeuDzfUNBKIOEDoNV5GMvAGui8hYmxic3+xDYMZZcPFfYB22s/US91KzrvmWZamWkfotA+VaMJwzVw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231232; c=relaxed/simple;
	bh=QBz6Y6gUxBJPPEXqMW074d6TU2FZcuDe5YBQIbrVbP0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BxDC5vBWh9E6q0J4YsZyy0cFnj6BhXpgzyJQkjD0yeNbIT/wlAtM3KNTXkutcoaMRU7dNH1GpPuzLMOF1e2P/7EaW/AhHRfJ8Fn0wCX2VeaWGxwVBgpwz5HWEVY/7F0aquO62CdbT3FDGxpA1c9zzFBiFy80vf+8X5rwdaB+m0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AluHsxAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AluHsxAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEAAC113CC;
	Tue, 16 Apr 2024 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231232;
	bh=QBz6Y6gUxBJPPEXqMW074d6TU2FZcuDe5YBQIbrVbP0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AluHsxAjqM5OckwqGXuTIoe0IRavA8g6soKOBVmoh8KLdoK/qu4UXL1t9/CqXQirx
	 S7dG/r26qML7g32Q78OITk0wZrVj8Vjo8LzQaHOw+2w7T2g4cgMxQ9yabthpqQwvCa
	 PSEq+/9Wz99XlYvvhErisLhd8Yxd1DpxUOn63wcJZ8JyD2FD/BkLJQA/8z0WfXKFLs
	 AUNLDu6BD7sf3m6wrNKCJSK0Ucw/kU6WGEK8+YWg7rUFHVEbPjwiDTlKrXQcAmezmv
	 Xw4AXqam39gPIv59szJLGGejbmiQQkRjtfq9eMeBQLrycvBaWLfGvCibXfmoK5CrZ0
	 TCH1lOHPimYnQ==
Date: Mon, 15 Apr 2024 18:33:51 -0700
Subject: [PATCH 30/31] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028278.251715.13862449184176657069.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

