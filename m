Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E506FCB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882720; cv=none; b=jTIGIxoscRW6Xye5tM2wIn++HQwelReoWeqZOpP/djhrL2mo987CTFJp+OKm+bMySA6mm4ri+HfSt/cGs0mZZs2QVnCdGlpLaPZCUtKNP2pdskp5bCD6TlJYAOwJUtCr5GDpPi3SJrVElv7wz0admcOP4cfx6agAYb4Q12a9DqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882720; c=relaxed/simple;
	bh=4pH0F1o51RC20cQd9Vm1JxX247NMtnxtzYPiQgc2/YA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbSYOARozywiwwHFjxTY2zcoACu3zPa4Js5V6Gt9xWnzOZwT8wW6qP3kEI/ey4AzwzZ0EzKCQEqE0NcQ30H5nfnBkQUXgzd0FaRYh4uYVkJx2GqaANSpfHo0a/rQ9XOCt4e+iJLDhbwDDg5MFPmckTCr+FnyzUGXQ+GTI4aLu+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjoFvVN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjoFvVN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8FAC116B1;
	Tue,  2 Jul 2024 01:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882720;
	bh=4pH0F1o51RC20cQd9Vm1JxX247NMtnxtzYPiQgc2/YA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kjoFvVN6NkxaLxBQWp5Ckmkh9ZmLSsbgmeQt+x9mOI0YjZDLbkoeAN+Kku6YLHiW+
	 h4OvNANW9/ciTEjoZxwyvagzHkcH0EiQo35bbaHPzsJOGojhtx9lDyQcqjCf77eK0m
	 PbvG1sJMXcQKqQDUHDPiqvj/vdKPm6P+SRAofP2bOkcphihw3VHnAgtiKsoSx9ZlTB
	 FsXt5GI1Y3LscCTnfMPC3LrLImTF++5JnJFdv80SSPK2EiNe3oVua4FPcHrvuq2/Uo
	 4nSIsic2/jcI+tsya+AjH5D9Y77LfUPktKJlJ5xPWKkAapoSCgdOh2abak97thGDvc
	 tW5es6a2kdmNw==
Date: Mon, 01 Jul 2024 18:11:59 -0700
Subject: [PATCH 05/24] libfrog: report parent pointers to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121139.2009260.15042250941832877051.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Report the presence of parent pointer to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 71a8e4bb9980..597c38b11402 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -32,6 +32,7 @@ xfs_report_geom(
 	int			inobtcount;
 	int			nrext64;
 	int			exchangerange;
+	int			parent;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -51,6 +52,7 @@ xfs_report_geom(
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
+	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
@@ -60,7 +62,7 @@ xfs_report_geom(
 "         =%-22s exchange=%-3u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
-"naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
+"naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
@@ -72,7 +74,7 @@ xfs_report_geom(
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
-		dirversion, geo->dirblocksize, cimode, ftype_enabled,
+		dirversion, geo->dirblocksize, cimode, ftype_enabled, parent,
 		isint ? _("internal log") : logname ? logname : _("external"),
 			geo->blocksize, geo->logblocks, logversion,
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,

