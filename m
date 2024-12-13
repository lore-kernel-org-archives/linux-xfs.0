Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0473B192
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052715; cv=none; b=fsiqCmAqWv80TSq9V72ZAUlnEwHzVemYwBACbvDRF0RYnK86BS1T+2DXCtFpVO9lq3OKe78SVngGjEzRnouZm2sOL5OrXmC5RMfK3Orbt1gRzDwgKkL3513xz6syH0pFyR8XKuh88S8YrfkHquDNq3udjJ0z8b7LS3sRAYudH80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052715; c=relaxed/simple;
	bh=SZQSNHmPCNA+/vPRvGyi/JsGMaL1dVdectZ9n5cWIxk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7vZhjC647dFNcYY06ijK4TqDWDXI/gmbnjikHUALkrNL3dRrNh9Kq7OyHg8IZfWPLUSS5HhwEQ3J/c2ya4e6A0r19RHP9NNs/L1uz297OyLxE4a/FMMBI0eacWOKSJ2GejXLHd4IPZmx4sbzMYcXOCzHkrBcMIifkKb+aNeT/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSFCei45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSFCei45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71911C4CED3;
	Fri, 13 Dec 2024 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052715;
	bh=SZQSNHmPCNA+/vPRvGyi/JsGMaL1dVdectZ9n5cWIxk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CSFCei45YxK7LZacPrOJYvlQJJGnL3s/YLHTXBBdP/mObVunxR8FlfZnGnpgEOtmr
	 f8riYPlBEdy5QFXc5oZQY02U0CVszFgtj2BbeIfzmj0a6x3jTDyS9Q8SezGqJ9cWem
	 YrLtRRX1j7lD0sIT8BsbiIP/47xJLfOeN6eIQg+bESkPS8nJyL/Awyu2l0dhFMkTgl
	 s2Cnao1x01n4BubbTDZKm/2WSb50509cBonCTBKmARiwiflqtPPKxe1ypSKlTzkXga
	 mZ6Dlmx+krOtUyEFre+qCM4cXs44Ihb6DU2Tk7uQi/W9K24Qc9k9PVTSsL47iAnWWi
	 MPXi5qWZRE86A==
Date: Thu, 12 Dec 2024 17:18:34 -0800
Subject: [PATCH 32/43] xfs: allow dquot rt block count to exceed rt blocks on
 reflink fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125116.1182620.14390017275681061865.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

