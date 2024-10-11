Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FB41373
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609282; cv=none; b=L51v5uJptlWg8BdQbqf8yn86pbkXImXcDX1m3P306bveL23fRDsqAo7A6+tQ7FHtzi32YSu9ncU8aIz48FHtiwgLUudHNFWwTAwzCS+KougHrksCaIpoPIeedSaIhIAkOcCaLLXqucsY2gRUDA3cAz4Fjwf74WgycLax0dl+qvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609282; c=relaxed/simple;
	bh=zltbO3X/L1RB+MCbASNfBrawTYTBXYKZvrHu7qFLhY0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSyRmso6KMMUwS/PL0K536UMaNqQvdaa5bJQG09w/zxEw2RDRi/q5MiOiqBD/XpCnIc909v5sxBKL3l7jLkn5ZQtmndUabDPoqsPpnVunNPH4xau6WmFsGp6JEOn5LfCbHTzZyyU5/cuiK2WD9y8dWXLK/CoDwqNCCT8o547BMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8/3mdz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8/3mdz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6045C4CEC5;
	Fri, 11 Oct 2024 01:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609281;
	bh=zltbO3X/L1RB+MCbASNfBrawTYTBXYKZvrHu7qFLhY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b8/3mdz7HLgsCZf3vh2BunuBtNmmKRcSFRLRQByPkXQmyHChzTjwgcAgGc9HsuTJ/
	 DyEXUHNYBvXts0+0u+j/Upc5P5v4jQtdn5jlYYlM4OMN4vvBx0YiQgf/mFNFm0ikht
	 LtKb5JdumeSrf0JTvKggwYrZ9UMqIXnuknMxjWj7x1qsYgQ45iXS3i42tYzT1kktcf
	 4RYgqGJ4Hnei3aqIxIl/B4zI6/bHePITxLw+VBu9OtZlwCeM/WiQPCfyBHyly0YY9L
	 1ejYbPeHOTS25RD+WWIxUxAaNcNJpUKH7RQrML+4AFHAedoPe1sCxB/DOG5YEK9yLB
	 1JPtRGoS4FETQ==
Date: Thu, 10 Oct 2024 18:14:41 -0700
Subject: [PATCH 02/38] libfrog: allow METADIR in xfrog_bulkstat_single5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654008.4183231.13533828459928536728.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

This is a valid flag for a single-file bulkstat, so add that to the
filter.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/bulkstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index c863bcb6bf89b8..6eceef2a8fa6b9 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -53,7 +53,8 @@ xfrog_bulkstat_single5(
 	struct xfs_bulkstat_req		*req;
 	int				ret;
 
-	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64 |
+		      XFS_BULK_IREQ_METADIR))
 		return -EINVAL;
 
 	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)

