Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B11DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845373; cv=none; b=Pel0qaYBJqvxJjavZVC5UI+3kHN6f1gZ3Ij2JeN8/myXik38d92h9Ca6HMQUdGtHAjSMuPEAuRCh+s57LesTVTzgPPyDc0kPBLeU2cg0nZMv2f0Ru39tm4CTzd1LZqKY3kDhN51lxpPhmKjLc5BHhsv91/FGOvFq9fAKMMFzd+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845373; c=relaxed/simple;
	bh=0bbihADssPhupXdxZBOd8smd4+M3g2gYH5Pqns9t4lo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6psyzAQKDcxyQ8ZBoCdKQAZUK2Jfm8aoXqdqUA6uHmHXMgXREJf/HZdAxi1nb0TC17YMTeD/u39634TqQLPZ9J+r54jfeXgryV/UFpXtdGAeK41N+Vyboc8ehIUD+819seqD/RNVOVmNZ5qg+WLNiRVJdit6DpaRcTCXuPCPnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chZOfTUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chZOfTUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54262C4CECF;
	Tue,  5 Nov 2024 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845373;
	bh=0bbihADssPhupXdxZBOd8smd4+M3g2gYH5Pqns9t4lo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=chZOfTUKlnfVGeJ3o0roIC7nISU5kWwqWlyiTdgRFmRCOSZ2Z/JDDsiBbzUwvq8ae
	 xmQdaC0niMX3+LNrvJLVl0SpRKpWMBtMtP0QfQ0ahHbEzPPILHFiieHKF6+F81tZvO
	 otX8pGkf7ksCaXWpIA0zXPoFu3zLSQbW339H++pwwLkNflWbY98fUGyBLV+RSVtdfo
	 0I7noJWpdKKFyPfV/vjh5pXtHdhiUhInQj8sh3cwFQ2U0g6uoHhbwFfkohqeBOPODv
	 ECjFhECEdg6sLcwNk9zVe78wjNzZzRz4iPZ+33pDoWNivhjIXXEas7ymVFol3b6Arn
	 L5Vq3wUUFwB7w==
Date: Tue, 05 Nov 2024 14:22:52 -0800
Subject: [PATCH 24/28] xfs: check the metadata directory inumber in
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396431.1870066.10045380845847414423.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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
filesystems, and the metadir root inumber is fixed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index f8e5b67128d25a..cad997f38a424c 100644
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
 

