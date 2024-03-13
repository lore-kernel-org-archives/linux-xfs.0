Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B01118A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295659; cv=none; b=kvEctFp53iD4qMnCjD1HP8FbQGM2x9Qz8W4Jz3FemKFulNbzSBPHrskgSeBnT86iGpF8yzgcLMr2R5uRnkeEMe55USYL7qxY6LrjqEj0Eo71ZNHWK+nkXO3S2Y7nT0ZostpWetRl1I4EcG5QApmflkMp6wdpWEbT5FqvLG3OJbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295659; c=relaxed/simple;
	bh=mOw8CccvHbHCehi3U6VNsNfH48qL6QGyo7km5BG70ZE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVc4yYKPZ//la0ZK0WP1S1CQ5m+PNFbekll2a08vCW2I6QL69zhi3NR2OlIc/PoMDdXSUu/lNzIO7cNadHCbzDvK2DRnnudUzoJel7UtNrSiXCsXP2aclpsOHY5sYFrZ4Aq0I3rW8ixlOxM5Ifnxbp/heDjxsAUo4TkfweqJiEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fa5wypp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fa5wypp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD25C433F1;
	Wed, 13 Mar 2024 02:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295658;
	bh=mOw8CccvHbHCehi3U6VNsNfH48qL6QGyo7km5BG70ZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fa5wypp2p5r/fO5IPl42/FpZZRmLHRsm3X3fHNgg+OLxfT36P2xnT/LbIapitXZQx
	 eimzUzsdwmVGUZqmHoxDHn8kQ0zx8ZoKDqqwNMmG+mkks+lEM0+JjXmzzLtOlJl+em
	 G/F5xdG/dLrCmRx6DtZEaGQm2wYmtet8jaaUo0xmf8HJbhRNxap+ltGUd6VRHad0G+
	 oSVOogksQ6bR5agJulQktmAhWD+3Rdysa+Tf0P9lwJBOhnjvhD3mQBtOYwDM47092r
	 t/nyXp5jkrcVyJtXbla20fH7OuqFifikTRB86epmCAc+45qevOT+G1JtI8h6bFb5Go
	 73mUyRTZk8G/Q==
Date: Tue, 12 Mar 2024 19:07:38 -0700
Subject: [PATCH 56/67] xfs: move the xfs_attr_sf_lookup tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432002.2061787.337713190211374202.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: 14f2e4ab5d0310c2bb231941d9884fa5bae47fab

trace_xfs_attr_sf_lookup is currently only called by
xfs_attr_shortform_lookup, which despit it's name is a simple helper for
xfs_attr_shortform_addname, which has it's own tracing.  Move the
callsite to xfs_attr_shortform_getvalue, which is the closest thing to
a high level lookup we have for the Linux xattr API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr_leaf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a21740a87aea..10ed518f30ee 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -873,8 +873,6 @@ xfs_attr_shortform_lookup(
 	struct xfs_attr_sf_entry	*sfe;
 	int				i;
 
-	trace_xfs_attr_sf_lookup(args);
-
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
@@ -902,6 +900,9 @@ xfs_attr_shortform_getvalue(
 	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+
+	trace_xfs_attr_sf_lookup(args);
+
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {

