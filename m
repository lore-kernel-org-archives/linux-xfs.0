Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89308BE66
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSzNm+6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A3CC433C7;
	Sun, 31 Dec 2023 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061561;
	bh=794FA+V39E0M46yFqxl/d0PxLjzm0TngTxpJ2Quur5s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LSzNm+6/UjSUZPGHNKnfHhOtOuPdGCSEZeu1gJ1uzTkm64NcFmzfT6KNenfgEm02x
	 9mioxJiXat2QXejLAqKBw3a+bVmR+1urnSfQ/83ONPISjP8v62BesK/TkmuUhAqE7H
	 cEhrTIA11c2zO8C2NLs6O1F7xbsAPO73aWYpznpLQ300xMe+VX9MqnhmNtb7pRWno/
	 7yrOekdltjJZk80O+wX59s3kiGo66PQuBwty9/tZ1jd/fFEbMhPwhyn8JKmTIJy9lO
	 3IRTLpXmZd31QtdWthvdg06V9rlJnNr+RrQG+vlHxUCli2S15otwlSfMuYcLvxnNSD
	 bLPBrUdqRfA1Q==
Date: Sun, 31 Dec 2023 14:26:00 -0800
Subject: [PATCH 2/2] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995565.1795876.15927163763895154157.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995537.1795876.9859168140445827889.stgit@frogsfrogsfrogs>
References: <170404995537.1795876.9859168140445827889.stgit@frogsfrogsfrogs>
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

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b7a9f541d30..d6cb466d63f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6217,6 +6217,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);

