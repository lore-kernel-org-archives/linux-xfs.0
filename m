Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C45EA4
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371674; cv=none; b=c6ir+5cD9REpRG6E+vFX3d2YSFi6bxjRj26U7pdTmHt52+G/6ucrcTegB/Lvlzcp61fp/fx4RHiPeFvUuQvFTw/sMkaxXYUC765h3B7AAPThh+eEKRNaPJmE4CqTaOD8HzfBqQM+chLtD6e3aMSW5jPMv0eZJhhKutUMEjg8v24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371674; c=relaxed/simple;
	bh=cTHW7jNg9j6Wmz+LtE7h8sKG47duyzVPCbdR0VOdmUg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dsa0FEuRABW+YzLR9pyaMB3Ult+RKzRM/TtxFi3iqu4yVC8tuq8/Z95VVVPwdhiPJcsvXfQDgrmm3ynJZiITSNYUfN26+UhUmpcpn06/Ux9MAsxeK6FuHRIqGpU8QNqizJL6jBfsET3nz1GP3l7ICmxNjl7/yrGb52YFZ02Zx8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCN/vQwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCN/vQwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0116C32782;
	Fri, 23 Aug 2024 00:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371673;
	bh=cTHW7jNg9j6Wmz+LtE7h8sKG47duyzVPCbdR0VOdmUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uCN/vQwY3CAeAhnCDAfbcchaIciWm43pICmnBgZP61qps7XijIKQNQ8MI1cU578jn
	 OyQsnoIq+LD16OETRmKxpLw4W3LzgwMct1RBk1PwOxUe9wLxb7W8IO8MHaxFO1rgYX
	 015VMt6tw0ddrLM3YGce0ybBt6rB7Rwp19gouLs1wntaLKERGFuqLM7g4kzjOaLXS6
	 nuE0/R7OXzezG7udOE69JaMXD+Ep4UAR8gcrVH++UFuCLaihqFDdmscfg+RHhKhvxA
	 j1CSvTcQwo5TX93M/a0WufoN2EEh0nNBpO8Goc/tl4zG92B/9eXMU6Dj0VkfIJoSch
	 QEX06uBwsLuQw==
Date: Thu, 22 Aug 2024 17:07:53 -0700
Subject: [PATCH 22/26] xfs: check the metadata directory inumber in
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085553.57482.15943448034882910022.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

When metadata directories are enabled, make sure that the secondary
superblocks point to the metadata directory.  This isn't strictly
required because the secondaries are only used to recover damaged
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index f8e5b67128d25..cad997f38a424 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -144,6 +144,11 @@ xchk_superblock(
 	if (sb->sb_rootino != cpu_to_be64(mp->m_sb.sb_rootino))
 		xchk_block_set_preen(sc, bp);
 
+	if (xfs_has_metadir(sc->mp)) {
+		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
+			xchk_block_set_preen(sc, bp);
+	}
+
 	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
 		xchk_block_set_preen(sc, bp);
 

