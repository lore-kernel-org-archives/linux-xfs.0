Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4641373
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609266; cv=none; b=PWpfb9XXmvIlwqJfIRldZqmfl8znQFJmF8a6ZLufcuH6kgf5Y7iponBP14yS20jPIzknyZiaWGhqa7IzF4zIMnxVUrhJzhgMvcmVMeYmLApoNFM2hVIM7ygkfH3++YctA85FNxu4MnxnA4azr289psdkwiI3RV9oahsDuhrLmJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609266; c=relaxed/simple;
	bh=k6mnIx9dVwW8RLLyfgTl0iEhIMm0HV7cdgqET+RelyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgVmtxLVXAOcSAE1DkEn3pVd61rGdJzKWJx32n5DhCgsLLZx45dZGzvqy0KTC+8thp/G4kjX/Cp7JPjJZQkTxBO5J00QQYAt/1QTtcE+CUQGL/TbQoOcEv6c3TA5EXpFcdCy8FUep4gB7pFAfMiozjNNc+ZThuQJBUl4lgGeq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N65/kq6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N65/kq6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BF6C4CEC5;
	Fri, 11 Oct 2024 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609266;
	bh=k6mnIx9dVwW8RLLyfgTl0iEhIMm0HV7cdgqET+RelyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N65/kq6kfXNKY9fY1wihDiPQqQwutjmKaZRgt6jnJjAXkNmiRP1A6K0tByicn3Jnn
	 A9Z7pHNT8CMjS7QeiJR5aNwM8CshU6R2ZaCE6j/Z5nSkzDgsr8ZD8kXIg6v85pk3Fw
	 EpbEGBvHIJ9UA9GeylnEAN5+cvcws5UtkUxaPw693cNoIA27Fcx6PWFzDNqgyBVtgp
	 kkoWf6Vlu3qN3I9kUcka6CgM9EmtfN3aP8CDrwYr/8XnNx+3qrYKH8xX5LJV0RqxOF
	 RIYvptDUCK9Qmk9vZ7/n9+bkrGO5CFVjOgBC8ECqMStStou4uE5r/0j0r0rzBJ1UZx
	 ErmxCT7FGbgFQ==
Date: Thu, 10 Oct 2024 18:14:25 -0700
Subject: [PATCH 01/38] libfrog: report metadata directories in the geometry
 report
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860653993.4183231.5439809537198316883.stgit@frogsfrogsfrogs>
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

Report the presence of a metadata directory tree in the geometry report.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

