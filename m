Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189F92837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995678; cv=none; b=oVDbFDK1Kbk12jZyyZXWg0SFTGUQ+c241K2a1sqT3sGD4JCwRDnmCRSLU2RBCtJJ1Wc+LT75C4Io9WjL2iptZinS3ak+uUZNQ9k9TMuDLmfmJujqIQiNR6Skme9LNTTPmIECeKHtwpHkGEl+Coz8ga511B2LyR6A1Z7+6xX3shc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995678; c=relaxed/simple;
	bh=arbOWgl3Veh440k50ZM4W7xCfpC2MznMhe6f/fM1NqA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S3Kodz3kWe5ws703RW4oW2Qq1pO8x8qkCzOtv9xMeRXI4q/fra1WeLC6Lml41E4ESdZACA0pdDO1oJI7L3q03mCsJ4/Mq04U9CzVFIwK4TGRf9Msf83CviLkwDG9f+Mp3Zw2YNwNLXp0s/iqEtqWsOCCnek4Wa/oaHeeAI9YGpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5waKMai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5waKMai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EC2C4CED3;
	Mon, 23 Dec 2024 23:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995677;
	bh=arbOWgl3Veh440k50ZM4W7xCfpC2MznMhe6f/fM1NqA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U5waKMai44DHM+I3lWnWljJ4aPmH7NnI9BFVtodjNacMky9kMzOPVHp4kggXKTOMX
	 uDWh0in1mn5cmKbe4ZTQNrOrn8YA3zN2sif6G5ehlPmuFPVg+l6VLQ5n7Eh4Slpi7f
	 FQcyZXu4StGEdQldJ8n8tZZMiy4D8pYwVFu+z68pIA2Gq1W/t/6slqqh5yJVQHjhGu
	 0rv/u2QN12RTtoaSl63LDXqmdg6wmFDG7fe/JvfbkkPDme6kctAblBxay1imKaaaET
	 vyI+uji9ie0j4GEyzhTgcH9Nq+Kl0RqZQuRnCdS1hQtbKiDCsz8N7Bnv9ZDWp0soIQ
	 1HhmudH8067/Q==
Date: Mon, 23 Dec 2024 15:14:37 -0800
Subject: [PATCH 32/43] xfs: allow dquot rt block count to exceed rt blocks on
 reflink fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420487.2381378.1854852637448736604.stgit@frogsfrogsfrogs>
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

Update the quota scrubber to allow dquots where the realtime block count
exceeds the block count of the rt volume if reflink is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 183d531875eae5..58d6d4ed2853b3 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -212,12 +212,18 @@ xchk_quota_item(
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
+					offset);
 	} else {
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					offset);
 	}
-	if (dq->q_ino.count > fs_icount || dq->q_rtb.count > mp->m_sb.sb_rblocks)
+	if (dq->q_ino.count > fs_icount)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/*

