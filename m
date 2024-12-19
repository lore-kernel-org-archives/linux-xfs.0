Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDAD1990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637330; cv=none; b=rY+hr1tOOWS45dXMCJwwTb76KPQJOyiilGE5ok+l8wPhrjNS1IOPCcaLRp69wKFcBgQur4vMNFcwq7ySd0dJ8A2uINSet4bO2nHla7tbN5Vm22dyQjFGi2XNiKib5dTt+dNIj7KKBLcZ6EuTe9A8PUeosNI5pbJUgsK1BpJ5HVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637330; c=relaxed/simple;
	bh=MOsOqB63rNQe8LNxWFKoqHLkh5o4DkoYQF0NnrjRxlI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntPKWl6PpR8DhqCNLp5y9fYhiLrmjYdICxLr4Oap5+gFyB9bRnV2S+z905kRAiDvsWqMwBKM4PxPFINNCN7Q3UYjz+gCBOiQJVVia+QIB6onxUTI65K4v7oySuxu2F6BJaawL7gv5S3FtGwxkvkYLh06RpOGGQTVM2FEerqXDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdxTbZDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdxTbZDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20E0C4CECE;
	Thu, 19 Dec 2024 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637329;
	bh=MOsOqB63rNQe8LNxWFKoqHLkh5o4DkoYQF0NnrjRxlI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SdxTbZDFxcY1Rugd3w897YZVfsgEaqUtJHHBhokYlg/L4Aq5yhzVYmj+XdfI/zsfi
	 pooGf6Lx/9FaCTNtuplfzKUJZvI5kiUveCk88Kn2v1Ommju60gCgL/oyPxQjV2YUCZ
	 5w2WEuVKWCIilLUEftIDp0vnub3312yi0O5U8VbL3UEM7ZeI+a5AmX2Cn14KSv2fRm
	 3OIsym0TkUfbBvs1+M0e+Nz0MrQ/xSZ9E+/pdnktBuGpB+U9oETIS1EdTCnw/aDrdS
	 MjapM3gTvNhxrUhysG7+mmsimLrpdjzEGSPVHrBQHPWPcgcd3SlETbXUV07e6Qpj2x
	 NE1fs3W/1aUXg==
Date: Thu, 19 Dec 2024 11:42:09 -0800
Subject: [PATCH 35/43] xfs: don't flag quota rt block usage on rtreflink
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581577.1572761.702217096620909486.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

