Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4931323D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300984; cv=none; b=nljtGNDYG84Br1X9kN5npqXy2vBbSPBl+LUGpQpGqu3Vqrl5mj+eQd/T2MV0shjxXzuNL2OK50LT9DDKExWK2RcpUabjmnLzZzQACgldWZ1noz9wprGgzdWsqpNCzqK2J1sStF6Wo4zwCMJq3G5CUwUCAgU8hjG1IZKMklP5yiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300984; c=relaxed/simple;
	bh=bKpFVeEdQ/4WiLcBiw4mHejnETOEopdYGH4ZRY6wUjk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bfb/nVD8Fb7gKvunQ651+njLpGoI+pFD3QL0dfrZhIcrQU0p7c3PKg/KdUxA9iMW1t0b6ZYj7E1fKcs8LmLK3llCcK7CnSApfkSdSplqZGt/REbhSxVEaLFDajsk6M1/sCjYyP81S5wvcxaznrZLd1MnyR6c9hypCGwnOlIdW+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Spe0Lb/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Spe0Lb/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67742C32786;
	Tue, 30 Jul 2024 00:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300983;
	bh=bKpFVeEdQ/4WiLcBiw4mHejnETOEopdYGH4ZRY6wUjk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Spe0Lb/bwTBbmPmUwnBFVia8NfOMlSgf3t6AHHiidEsiwU4o2u9m/567pIRPJDKjY
	 gywPBsXu6iJZbNADy98Fv+8hSzTlHZJBko+1Jq/+9dq6Mye+Ow8hPu9NrmvWOlzjBr
	 aGnAIiI2bQAzZhyJIeIhNEJ7l+q4S1/1YoSHSOdvVOhnlidJPOu9lHLtqA+je7gVWi
	 wVPGAWxxr4ha/aW0g4f0YReXe5nxp8YzHvKlsSWlEsbcasdflRySGTSx2LSY4/rBR0
	 rTFPr/KnZrBQvjqVGE4dDxXS3kdWgfA0BXAovjx54O5i+sVk5FxZgcmm4ByRxAzCdP
	 nYMtTaFDjfxyA==
Date: Mon, 29 Jul 2024 17:56:22 -0700
Subject: [PATCH 10/12] libfrog: advertise exchange-range support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844534.1344699.3298170994004880868.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Report the presence of exchange range for a given filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 6980d3ffa..71a8e4bb9 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -31,6 +31,7 @@ xfs_report_geom(
 	int			bigtime_enabled;
 	int			inobtcount;
 	int			nrext64;
+	int			exchangerange;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -49,12 +50,14 @@ xfs_report_geom(
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
+	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 "         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
+"         =%-22s exchange=%-3u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -65,6 +68,7 @@ xfs_report_geom(
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
 		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
+		"", exchangerange,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,

