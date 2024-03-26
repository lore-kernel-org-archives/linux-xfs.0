Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C221353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425350; cv=none; b=Rbnb10dlPgYAk0m7lIH8d2txw5QIHPD0oSptpqbaaUZYF0xnyZ1JCA6lhZGZbWkMj42tXpO2foVWq9RnxVPSjryMBwMqDO4yNt/aiovhVJNFEjUTUs89Zew+KIGNejRBJHnF3H4v3y+Vbey8WOpHG2uYxtU1Zx+rlsa9dF/HEMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425350; c=relaxed/simple;
	bh=nL4Bef7LX7Xa2ektrRw8u3tQmIIkpXKkn5+bgSJ2tf0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFisIh/DGrCSAnZHqIyaMDk3j4crWIhl/WWZ77T83Abc9BOvLpsNSlCH2fXRiX9H/ObMBN5LfdV84L82Cie0kUC940YQxkSWLMxNztE0q6q62OhnqlBIUCrXrX9HZIVVVh9VoT/KFSCGauJQNLMkohLHDhygM5s5pvjU1TPre+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsxyXOjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsxyXOjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31082C433C7;
	Tue, 26 Mar 2024 03:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425350;
	bh=nL4Bef7LX7Xa2ektrRw8u3tQmIIkpXKkn5+bgSJ2tf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dsxyXOjNLkGNtyhyGsEJXkTu4F4fVjG5dPMiiGGVn6CW8fa7iJUPawGu0wPehpaYB
	 1Tt7n9fd3Immrac6ZC/A0IGpCemywfOZHXNSUYkgJsJsvoVGSv9xCGE9fY9+O0FfZh
	 /e6Lvgx49YYS3P8RYdKt/jFSRX+54aDWjmb+oh1rTglmjnjbRl/GuHqdlNy90Ts0Hq
	 rWYav3kJhXnzEASJf/KOl8FfVoyQth6exYEvbyhzraBkuFI0YBUvx5Lp1OxcxV4yqu
	 rCPqNZC5W1LKnxgziJi5Hfi8jeFvy4c+aFVFSrBnzRGTf78YtGzXCAyYgomrC+mjk+
	 MfHFHiiMxICWg==
Date: Mon, 25 Mar 2024 20:55:49 -0700
Subject: [PATCH 105/110] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132890.2215168.13861034094254308324.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6c8127e93e3ac9c2cf6a13b885dd2d057b7e7d50

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f09ec3dfe0c9..70476c54927a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6239,6 +6239,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);

