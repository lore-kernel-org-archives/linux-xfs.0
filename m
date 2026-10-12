Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B0E35A38C;
	Mon, 12 Oct 2026 05:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784561; cv=none; b=BCyGcegJx8ebf2c6gtHz7nJilQj+7nCKn5JvM2SXmEzty9b6q1g8Qmq2a7f1Tmbtqfty+K5NR9J4Z//vG6P+1QDutevfUJq6aGmIXEUGFU4NkuZ96acfevs2GkyJdahaSPgranYtLzR3uCxBjt89KThvHmjkYid0EDTLVmhnI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784561; c=relaxed/simple;
	bh=KvVjtorY0BoV2ksfC7GuddVR56XWbVLCl4Ga7ZA5lmY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qnwco6LYJ90v2kbuVc2FQedbkWjruGOUbJToswuLNm3PbxAFMT6+vdB+vwTTKoXcD0AxN8uHKCRPE/zk9fxoQ5b5CnzvnEgMcnYP0x1yUL3Y2+f159Luewloj7ZkVqnqS+SamaFGHEVNNAqKk6zKw66cTTzR8HYzJd/pIl323Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mW+S+6B4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mW+S+6B4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 543671F0089B;
	Mon, 12 Oct 2026 05:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784560;
	bh=SXopcfPN86LsjhcbvxKqfC/gn+QEp4wvLXJFbbMSHA0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mW+S+6B4dpko2/THH89k1uZgJvbJie0PdaItI5D9Zps4Vc0UzeAR9fVfsnqSOOycD
	 wziPQDTYoJN7TJ/YeG0WLOMBpZKUfHVNcnF5q3hGhetpcEkW+uPkLH5tj3xuZL7CNS
	 s+M7TrsIv+Ms1SldMvIysHImLK85zOMj1pGR3tVZM+dM2mlPlEsM3BNpJpu99qCmwZ
	 IdL2t2kSiCMCJjD/gSfOO77pfS/A7q08oXjqH2u9k+OQdy3UXL0am0WIh7ztmWS2L6
	 cwgYASP7xsuG7kY4v6mCbP4Zo/1I1cZ07LgGVcJyHg1CiN7BsGlTz+O2GoXtTpb5xG
	 wiWz3H63/svvQ==
Date: Sun, 11 Oct 2026 22:55:59 -0700
Subject: [PATCH 01/12] xfs: don't overrun incore inode when cleaning attr
 forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065216.1058326.11136246616445475827.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dinode_check_afork doesn't check for a
di_forkoff value that is so large that the attr fork would begin after
the end of the inode space.  This causes afork_{ptr,size} to be
nonsense.  What we really ought to do here is zap the attr fork.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5b5116adcbf5e4..de3c915984290b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1243,6 +1243,8 @@ xrep_dinode_check_afork(
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
 		       xfs_dfork_attr_extents(dip) != 0;
+	if (XFS_DFORK_BOFF(dip) >= XFS_LITINO(sc->mp))
+		return true;
 
 	afork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	afork_ptr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);

