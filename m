Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701E52114
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052465; cv=none; b=fNtVTrACdEPuhAHMKfbLY1OpZMu9ReGlQ0XWJ2ij6IAdzr2ytWdGlgz4gylEBRYRLN0gte9w4gICN1Dp/jUfNMSjaX8xrYfK7ys2wvz1tPPt5vm8yTAI7eNIOSTtg7CJk9VkDJNcYDUH94BuyY/b8ljbhz83KnsxQ/iPRSLkV7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052465; c=relaxed/simple;
	bh=t8vtilBEFqjf3+SJtmTPb8dNFughLeEGoXQoZOHeEz0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRZ0v4cfoI1lOe0hNqeAL/Id7rgL9pGq9aJqY1XYjqeCpE9PQ8sM82bm5aVJif4eQAMXx4jHNV//UXnh87sUcJ3wDxgYoPFeae+AfikSVO0mUiK+WVRu2psjleG6BV64l2u29gklz53Tx2paY/+tSitV2bz8qgmlptZLjzqZswY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s12VW+Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s12VW+Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48829C4CECE;
	Fri, 13 Dec 2024 01:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052465;
	bh=t8vtilBEFqjf3+SJtmTPb8dNFughLeEGoXQoZOHeEz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s12VW+VhBCVv7GKDZtTt1vqs8V0tIOy3qYZpcPMmpkIy9WE/pTqXW1AWokV4HX0Pb
	 Bd2YGt/jGXUNdavmYUIGeOV4nRRCuZH0/7ibqJ7QzebMt9cbbjQT35uVfe2AkVhOKo
	 Mm/tUMGyOCd35EuFA8zrr/kHNzcttprFmutbS0omL7hVJ61JSTjhhjXSk6jTV0Q3YB
	 mtWpq2bBLLesK72CbuiZl5NpWmAxb9HvhhavXF0gQeH0RooH2g6AlVEeZKaTJIWTUE
	 5R5zGGtDAyaP27cEtD2I2NBheo5XeUdsxculxAQQLW1HrztxRN7zDQesUQpizh8AtZ
	 SHDeGH4y2MxPA==
Date: Thu, 12 Dec 2024 17:14:24 -0800
Subject: [PATCH 16/43] xfs: update rmap to allow cow staging extents in the rt
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124842.1182620.13179868316310661730.stgit@frogsfrogsfrogs>
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

Don't error out on CoW staging extent records when realtime reflink is
enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f8415fd96cc2aa..3cdf50563fecb9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -285,6 +285,13 @@ xfs_rtrmap_check_meta_irec(
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

