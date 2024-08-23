Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82FF171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372361; cv=none; b=b0nroSDlGLCFmYpMxeVABgkSgOtPtYRj7sWgFEenGHm7Eqg26tQhjTT6JOEHCn401vRd0kzeCmuSiAqE6sR7Npsgu4JBepbARi70pqqxPAd2U2ZL7uB04/lmEtVOCjwcKhS7G6Ge8z/9NdPHSR24syvyBBimmBPxChJ4r8qUHbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372361; c=relaxed/simple;
	bh=vNTs4runLJBFVYw2QchsEk6/kHNxYCdZDs8RVkqEpuA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRcHaUsooIWFsqjqOuLmbt27dtZYWObF+GTuu77VRe1UFys0Pr7Q1f6zac5eqjpncx7vveM0D7i+RkFV5EG3PDPvQhi9ldA0ybc6H8e9V2CCQbrdenum+lVeWm4up+6meBmtRp+iqxPTw3bH/ZFQShuIkzRVfT3FfG20li7I4Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgVohfeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgVohfeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE79C32782;
	Fri, 23 Aug 2024 00:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372361;
	bh=vNTs4runLJBFVYw2QchsEk6/kHNxYCdZDs8RVkqEpuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XgVohfeCtl0KNddyZdo8DdxuTjI8y1qVvYvIJbZTmQw2qmxGZJw49FW73kDGn91wA
	 8lL9LSBRTMKZjImJqSMgsSdAHzCiYlAyUc1TsinCf7ofrEdrVUHm8gpFFCVrl27ao8
	 ui8rosmIiw5gy5IIlZLiCfZrhgYAtGpnxpdJ4WJhafM3HEullp6LIkQu4dpf1kfmuZ
	 LBw9n3TnsLESfedA1IQ/+UFiD3mzKLJOBKcO5jrqQKVMDHNMePlf8LIEigPkM7KiyP
	 2LvHChtDgOfGggNX1FWZiumr24f9AbKp+NQQ4SaqjFYzyqYNemnA/pgvXsSTsYsMmh
	 W/CefYkUO7suA==
Date: Thu, 22 Aug 2024 17:19:20 -0700
Subject: [PATCH 18/24] xfs: calculate RT bitmap and summary blocks based on
 sb_rextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087559.59588.9823973927107871792.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Use the on-disk rextents to calculate the bitmap and summary blocks
instead of the calculated one so that we can refactor the helpers for
calculating them.

As the RT bitmap and summary scrubbers already check that sb_rextents
match the block count this does not change coverage of the scrubber.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtbitmap.c  |    3 ++-
 fs/xfs/scrub/rtsummary.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 6551b4374b89f..4a3e9d0302b51 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -67,7 +67,8 @@ xchk_setup_rtbitmap(
 	if (mp->m_sb.sb_rblocks) {
 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
 		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
-		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
+		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp,
+				mp->m_sb.sb_rextents);
 	}
 
 	return 0;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 43d509422053c..a756fb2c4abf8 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -105,9 +105,10 @@ xchk_setup_rtsummary(
 		int		rextslog;
 
 		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
-		rextslog = xfs_compute_rextslog(rts->rextents);
+		rextslog = xfs_compute_rextslog(mp->m_sb.sb_rextents);
 		rts->rsumlevels = rextslog + 1;
-		rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
+		rts->rbmblocks = xfs_rtbitmap_blockcount(mp,
+				mp->m_sb.sb_rextents);
 		rts->rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
 				rts->rbmblocks);
 	}

