Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF237462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995725; cv=none; b=RNHhIFGpJoxk+XzCeAEPqPA10tjiNvOwrjog8ztJ8TVCj8ekuZsxXAl4AGmeGuhEDobPMeyPZ9cwW4HSLB9Dj5PSJv3kuAVUpxLXnpItD18dHM6CNQfPobnVYwpx8hk5gNumsDKbAWx6F4h7NPx3Qe/UWA/dcIKLlNnP400U2T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995725; c=relaxed/simple;
	bh=MOsOqB63rNQe8LNxWFKoqHLkh5o4DkoYQF0NnrjRxlI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ENy8w9G3eEOTqTtJHub0hvLKMfHFsh6g0uFMPRvw+KKTljdmtIzt1ovqVYtZRNIOZYtxz9vGP/PjaK0s1ylEz77tQEMICpWlmMLljPGmiD2p7EWScFbrvyUssNbn4WEGXZLkzFyFQVqzuEkzfg5zODD/ULUXFCKPBSOUqkQs7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gCilpNc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gCilpNc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC11C4CED3;
	Mon, 23 Dec 2024 23:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995724;
	bh=MOsOqB63rNQe8LNxWFKoqHLkh5o4DkoYQF0NnrjRxlI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gCilpNc7ZDEqS9fRu4r2U9nSxjm6rUFW/LSkKnqoGec0QaaDdiSn04H4JsshHmT/9
	 Z22c58N9FzKEB38FHaXGC1p5utUi6FHNXeZFUOhmimbmKhC4LTWcdnMSaMVLdXwWsC
	 QeO3Nipd4otfkOlkrEosOROQ76aGKkB3WiGqdRdXw9IlORiqYLINn/LKq0S/4DHg/M
	 1Z5pZcSQxq8T9d7yjtOAMmo0zBLraCdh8waGEs9deUHs7B1JtjF8tbjBdcDj66aSHb
	 au2lL5eYZdNvLM6HyBduvjGe+FYAfxzYRyVf3eBBbdZA/T2rYsQYghZiLs72HznlNO
	 zMhezcwXVxSAQ==
Date: Mon, 23 Dec 2024 15:15:24 -0800
Subject: [PATCH 35/43] xfs: don't flag quota rt block usage on rtreflink
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420538.2381378.10745935561821867502.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Quota space usage is allowed to exceed the size of the physical storage
when reflink is enabled.  Now that we have reflink for the realtime
volume, apply this same logic to the rtb repair logic.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index cd51f10f29209e..8f4c8d41f3083a 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -233,7 +233,7 @@ xrep_quota_item(
 		rqi->need_quotacheck = true;
 		dirty = true;
 	}
-	if (dq->q_rtb.count > mp->m_sb.sb_rblocks) {
+	if (!xfs_has_reflink(mp) && dq->q_rtb.count > mp->m_sb.sb_rblocks) {
 		dq->q_rtb.reserved -= dq->q_rtb.count;
 		dq->q_rtb.reserved += mp->m_sb.sb_rblocks;
 		dq->q_rtb.count = mp->m_sb.sb_rblocks;

