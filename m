Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C08495CB
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388782; cv=none; b=YqQrFTh6mG4hkV0gMFM4ccRu/kbTyM7juCH8mfr8acEPzHskXYCl/G+3JW7CQENCvTMykCTn9rG73C19jNPJkJ4kGJXKaBXl7lDsjoikeaM0++J69jWFeh/OGUQGIuYYZFE2dMlh2q5y+dL+5fOkCCjXmrTzkcjzXdrljU1RMMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388782; c=relaxed/simple;
	bh=m6jwf7ujFUi4aKQ26HiCr8W+UxQwXoCY5oYbGOLzubQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJoqcmKpfFYMzd7c/HLmBE1FoSyq7A1szrRlY+UVuh9dvr+GeEH1bD8FtuNu8AEHJf8AvpUb/Z2DI16RLQ0fy2HmQcunPgZN5y5c7etDfKXWzFLBQwqwj0LgT2a5HYmAJ/ihLY6yPnjEkP+jEyd1DrcUiXm9FuzoPPO+ub7OH54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FveeVpFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FveeVpFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA3FC116B1;
	Wed, 17 Apr 2024 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388781;
	bh=m6jwf7ujFUi4aKQ26HiCr8W+UxQwXoCY5oYbGOLzubQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FveeVpFadPdn7baol7WZAhvNSf6jfYafNofH2dfUqP8WzHUGOwVAXPKEbtlNBbHxt
	 BmkMis32xWMKydhkrmpOhBX5zkjNSYSDQt8kgfa0GpUR1otuGqGdZXgVPFSEsShN7Y
	 mft4xQr9v4KEUXLKiB5qlScVh4jHATCSFfeg8Gd0bXdEUYtLe2g8TB+/nzLFPMg3Ul
	 Qf0W214r/Xj59ughzEHIz8bUIObUDfFFqIqmqUlRyHoo+DtfYWTd7tldllYUy2rIpC
	 Vvzsdqf9B3DvVC+I+WIBljgj0y+M4Yo85UzVDgpDcsxmv/RncQTPIXDGSQpK4kLmeF
	 R3LMHJy2jtb9A==
Date: Wed, 17 Apr 2024 14:19:40 -0700
Subject: [PATCH 03/11] libxfs: use helpers to convert rt block numbers to rt
 extent numbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841782.1853034.1273705464985699451.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
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

Now that we have helpers to do unit conversions of rt block numbers to
rt extent numbers, plug that into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/trans.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index a05111bf6..bd1186b24 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -19,6 +19,7 @@
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_trace.h"
+#include "xfs_rtbitmap.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
@@ -1131,7 +1132,7 @@ libxfs_trans_alloc_inode(
 	int			error;
 
 	error = libxfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_rtb_to_rtx(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

