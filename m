Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB831A5B94
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881965; cv=none; b=NRuQC97XbZpSwTm9GPYzXEy/m8FODf3IEgfxolMMvPyfSZ0kdNTIJf/Fw1ExyAFCo9LbnLJbUrpEGXtpPe4iLsCn7M58dMeLUR7A8Rf1f4dELUCm7ibiuCDjWbP0gvCtGFlMu1G0lVe9aT9z0OWGvvB5zUjp5TTWtMjeyDp7g4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881965; c=relaxed/simple;
	bh=uexnMoCSNG6SmE0kPODlw7Fe6s8zK/UKlVcfA1jX20A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m7lCBkRJrqJRqM8dDB12sSHbunn1dX/Ch3REuu4XI/sSBIHyS30B5kI+V8IfWe5g3fcyRMEYyM9xoStwTwDVDZW5Yj5ELmUs5S8neksvCkfOuazRBo651moOtHDdwoiC5JwEFkJ5fUNLqla5ueewI4ez+eDHyMRkncSdBTLhifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzO8LkPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzO8LkPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CACBC4CEDD;
	Thu,  6 Feb 2025 22:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881965;
	bh=uexnMoCSNG6SmE0kPODlw7Fe6s8zK/UKlVcfA1jX20A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gzO8LkPToqVNgKT8hsXjVrPNDwtenBLHoLbZGh70dTfOxDXyY7oWzl2GCZHlkn3U6
	 WN5m9KLcljdjkAtV7HB+3NLvFNYpITlPGAQQY5I7j+bb2T9ewGljkw8iJ8XNmkheIr
	 stUrqenrOez+exzH2bnEnTTH5nBkcc6B1WKNUMKRHF6L8oRS5uukgoAcWzLYYixdjJ
	 CQtdof7lVTRktjMJ4EJ03pn3CvBbSi5LNxLlvWrWbRseNJDBI/ZHqz/XXpTTXOYe/1
	 cIJtVDZKAOPGnhmfaRSo4w0G0nkSCdFWRE7SSL4FMSFcFiMwu0zmjVZWJ1ktCFUV5Z
	 eTVdabA+IjH0A==
Date: Thu, 06 Feb 2025 14:46:05 -0800
Subject: [PATCH 42/56] xfs: update rmap to allow cow staging extents in the rt
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087435.2739176.2483204734738730021.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 0bada82331238bd366aaa0566d125c6338b42590

Don't error out on CoW staging extent records when realtime reflink is
enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 3748bfc7a9dfc1..8c0c22a3491df4 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -284,6 +284,13 @@ xfs_rtrmap_check_meta_irec(
 		if (irec->rm_blockcount != mp->m_sb.sb_rextsize)
 			return __this_address;
 		return NULL;
+	case XFS_RMAP_OWN_COW:
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
+		return NULL;
 	default:
 		return __this_address;
 	}

