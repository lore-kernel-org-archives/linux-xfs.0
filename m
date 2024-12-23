Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551CA1BEF82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990484; cv=none; b=hPenoJPv6wvAVLRyQfz9PWOQTNKRUevKeaFfVqr2JgtV26KAy1nMmvC3QZJz2AVKcB7AATTcSsmx10JsAGPmCKef7xk3YL8KZXwrZicBIwvLo5Zx/qDLo0Ngl+7gW7diWw0UIXNsWf/qcLCwpQiiOgh5p6VzuoCHa9i16LXN0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990484; c=relaxed/simple;
	bh=W8bhfVdWK9yKQzEud1e5pZ+bRh6V44J6gLhVwOguJoc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+0Ufwq0Gr+TxFpi9J/M3E7KMfpoowDeWjfWELSyGzPrMvZywKJhI/N25c8wBYbhiMvLaW39CdkEp/PeB3qZCslUiNBs+7cmMFOBb822NOTE6FxZ2/ajEvoiYUa8EDqJqgkKi/BioDCXwvgO9fF6N/A2H9ZIsG2hGjBtv4YkZbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEY6OEVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEY6OEVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A48BC4CED3;
	Mon, 23 Dec 2024 21:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990484;
	bh=W8bhfVdWK9yKQzEud1e5pZ+bRh6V44J6gLhVwOguJoc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MEY6OEVYwy8f9hxxjb6nuSV7yE5VgjJgIJCMAXl/YInENyJmMOaTdgamQ6c0xYa52
	 UsUwXlAHeMG0x1uVWZUl7A4x4u8HYAYJ27/3vTPhNmfLI6/LOuuyA0NNdTOArk3wi4
	 W7T1Quv6Wb5eiOPYmVyrBiKle9YkMyF2f/IpU5QEzHWZ6CUuG+vePh/Opwy4BA6d1D
	 YOHj19iOuqn2aXblFNkiygJ2YCMShtWlEQpdI7zC4iaO7MhYwwbYo9iKfBsaqcYlmI
	 7DwZTP7kD6ad8KDokB363kyuGEjsygw7k22RQfe+ZwDcmBZEijYvYUhulG8wymZc6p
	 fysaxtn+rrFww==
Date: Mon, 23 Dec 2024 13:48:03 -0800
Subject: [PATCH 06/41] libfrog: report metadata directories in the geometry
 report
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941059.2294268.4436654414999820175.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report the presence of a metadata directory tree in the geometry report.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 597c38b1140250..67b4e65713be5b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -33,6 +33,7 @@ xfs_report_geom(
 	int			nrext64;
 	int			exchangerange;
 	int			parent;
+	int			metadir;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -53,13 +54,14 @@ xfs_report_geom(
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
 	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
+	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 "         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
-"         =%-22s exchange=%-3u\n"
+"         =%-22s exchange=%-3u metadir=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
@@ -70,7 +72,7 @@ xfs_report_geom(
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
 		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
-		"", exchangerange,
+		"", exchangerange, metadir,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,

