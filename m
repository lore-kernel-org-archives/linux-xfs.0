Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3BB7464
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881766; cv=none; b=VyGjDch1XxXLz0e+2Ns4Ny6zbqZtiml9RZTwwG/NRTbvxzEqf0ecIkUHP73plmcM8lz/2MvAuBk55TcPiqKtIwOzNOXxxWdxLX/KtLYd2csGIBePdzXcLx1cXp9SdCzNMe6rfOD9y8dxkTYqiH5pugYIsOSpEZsohdV+8yETAj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881766; c=relaxed/simple;
	bh=hCIaWNVWJUOdrIjZxqUz7KdboLbT84wdBK3De7iRoPA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9LVv962aXJrVqtpyNKwzw6N/IaJNsD8IVS5Gm+4IM2HfOlMrXXwRqDP6a2al5faz8uh2AICvO7jX+pUGEJk6wl+w0FSo1Fpg3ZDGHbU5BqNlz7TQlqxzmauzu4ppozVD+lCrwq/eaYSCBn8DUbMEIoXXpj43fS4yEdihzZ/qVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bX57iwb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bX57iwb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4274C116B1;
	Tue,  2 Jul 2024 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881766;
	bh=hCIaWNVWJUOdrIjZxqUz7KdboLbT84wdBK3De7iRoPA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bX57iwb5LV8xlEdcZY6cEH5tFFeHGPIg7B6YSDQuPbpPyTOxKvfMn1VZaoUrav6tb
	 LZICUtRwNetLLGGWHxWU+/u+xIh7qvCK7sA4lP95gt2DLXwUTaRW4ZzTACMxvWF9/y
	 lq1MK8h/fMbaVTrAfwt/fQz9ypKAvZDloohZXywEdhQJQrCVarQOfF0idz4OJQL/uc
	 +zBUKYhcMjRbo5ZhMpppGQOmCVTs12oxrlJ08IwD29PDye/9x8givFZB/O+NTj5OHn
	 lW5QsyVcmqnZ3toi+FVKkUsb1w6oVt0R/uAVZvAJ+/dNBA6XIOhU9m+J9mXDbFjMjQ
	 V1q2F7GDWgDHA==
Date: Mon, 01 Jul 2024 17:56:05 -0700
Subject: [PATCH 10/12] libfrog: advertise exchange-range support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116862.2006519.2459746611478539000.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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
---
 libfrog/fsgeom.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 6980d3ffab69..71a8e4bb9980 100644
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

