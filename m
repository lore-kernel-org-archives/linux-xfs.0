Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B31FFC59;
	Tue, 14 Jul 2026 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009143; cv=none; b=DuFNxXF/LrrjSIzyauP6vnX01A7GO6VPwwkhTGFm6VkSyzSjbF1L2wFUW9FSZs82AzssWvjClnpMAgFIrCSyFuj7/jIZXA0hGZRxVYtd9QhT0r7C4i37Lg83yqf7F4boa3OwoMDhxXU+S1eUVyIEl3xxrZzjhAw0aar+OfXBo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009143; c=relaxed/simple;
	bh=tDGh5+YoE/BM+z0iC8Eg4A5HNeC8zdo1grvTH7S7VHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLJCyRgIDsPVl3SglpqXfhiCprvQHLQgOLUN4VLCwQZzq81cM57EiavWZmX1oDI/fSmrXQv/IdM1eMO5E1MKGRglau/0Fkf1Q6J3fZ1MutfG6qBpUN74f8NHsLaz0M+3bhnFfmrWSf0uY6VSaV59Y9+42UdvOYL8z8hTMQReTfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3L9yCRM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3L9yCRM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1B81E1F000E9;
	Tue, 14 Jul 2026 06:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009142;
	bh=chmOWx8M4Ei77ApQJYsRs1QTKYqgVzoy/VY8+WDl1O4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=k3L9yCRMzuBTq644dWPQ8Hk/ygQT76nyvWtHgIXH3x/R/LFvWUkF4hRIgj8+LCkGo
	 ctfBVIPGLG1cTkzPNuAX5hlbRHL4y1ojFV7XwvBomTknhATeSwuvM7dODcGQlEhrc+
	 cwN/0N/XpXZaNrFF8dtbUAD1Y+U5U44TqFadjZN9Y6gMj74COtFz0WWM/qhzHGSOT6
	 gVfqL0e92F53QGD7593OouN/mCrWeVJ8oNjkIcme9Xa6Hmew8iDcc8lIhFhmvAMs2d
	 mcFVyrhlTDK5fhopb1xvyeWGYoDZZp0N9mWKFfBS3p2gfzTNw0eqID1PHDhzGvfOO0
	 wwCid6WqNtB2w==
Date: Mon, 13 Jul 2026 23:05:41 -0700
Subject: [PATCH 7/8] xfs: write the rg superblock when fixing it
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716520.267810.4207769049642653378.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The rtgroup superblock fixer should write the rtgroup superblock.
LOLLM noticed this, oops. :/

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 1433f8f9cead37 ("xfs: repair realtime group superblock")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rgsuper.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 482f899a518a85..3dad6e5da74e55 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -80,9 +80,13 @@ int
 xrep_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_buf		*sb_bp;
+
 	ASSERT(rtg_rgno(sc->sr.rtg) == 0);
 
+	sb_bp = xfs_trans_getsb(sc->tp);
 	xfs_log_sb(sc->tp);
+	xfs_log_rtsb(sc->tp, sb_bp);
 	return 0;
 }
 #endif /* CONFIG_XFS_ONLINE_REPAIR */

