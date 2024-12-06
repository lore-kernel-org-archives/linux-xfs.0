Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7521C548A
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528473; cv=none; b=Gou09AUxxrhcGVZBlB2vNndxEnKn5LDfFuUQPU94Kgy/oSBJtxHcPHtKWv6x6HcNVmTXfBwSKPiXb+fUHSHjOv6FM45W0DI2hQla4jbO+++pJNaFRY2RUEkXFeNISZRKtXO6GedknAevwurv+TodnDAnIlLWofz4cgqIdwBXQHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528473; c=relaxed/simple;
	bh=GDTgQMp3/cmAvObkeX1Y/yjruZKplL6uC0tEr6t4PAY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eyOhpK+mAOjdE07Y455z9UDasu/I8B/UEseMXpU2nKocGzdp/P1JOOs+EktGfftbJ80cD531lVMv0PfmDLvxO2kCJPMEUYGbUqCxbUAD13Ao37ITp95gtLeuf4b4t4r8q3QIcT0RQXsWGcVFaSeRceMrWaDsR986KPWxcgsdZw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EaVCevWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EaVCevWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022B6C4CED1;
	Fri,  6 Dec 2024 23:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528473;
	bh=GDTgQMp3/cmAvObkeX1Y/yjruZKplL6uC0tEr6t4PAY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EaVCevWKy/2nk0hrW+DZh8/Wv+Gz/r8+qlHEj1WINma4JV6WdfR3YGb0igjHhZMxL
	 bhGktgd9uzEhxIAWdMuAUGmJTMjKxXJWDjstLXu5C5PxoqZJFI8Plq3ZEdvwp7pATe
	 jlBEKhWt2J9xkZL2wkmL0gjOqOuZaMoKKL3wBEX1YqL1EoYCQ/2PA96scJf66vxSXp
	 Q1EpDcTwhi9iR5Y20OLUkAU+Ac931H7J6uANlDmmnTk2C+x7GiSix5TwbPOxVE9AhV
	 2hw+xKOYA98sf7ae8KJjt0uUfiJIDRbFnuEu9VFM5JYUJlD9xjVEVWvIDXaaiG1hGX
	 JDD1Udck5heCw==
Date: Fri, 06 Dec 2024 15:41:12 -0800
Subject: [PATCH 06/41] libfrog: report metadata directories in the geometry
 report
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748331.122992.4014549233561309416.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

