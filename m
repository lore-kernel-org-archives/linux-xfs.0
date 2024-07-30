Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AEA79CC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302410; cv=none; b=assM1hREaeiqBZW8v+6lac/y0LQtIol4uy0lnHRBjhgZOSapN8gV6UB9N+7EnHruyh5kP1jWI4sf3aGUcpXBz80AfRPZqw89eKWHZdMZ90TrqMwp2pKtUAcT+0Mw5Uxii6aXRN0nMuRYF0hmIDB/kRSD2WXI8YKGduSAco/aXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302410; c=relaxed/simple;
	bh=cWbY3Cmc/YKBmRt2vT4R2/MqWtKqreHB+HfOd7PGe6k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R5cYlMJDi9SEkF6xjdksV9QFggG1Lsb+eC217e0eRTpjqqM6dCdVZWbyTRiXDHjCVm+64gMJdl4koTNxaqdfDDdBITOI5zw2l0/ZDmWLvMzWgFx6FJUWwg28hZllDwwLe47L7hJrYFSpaajf1FCrIeofUfB0mZtcL6K/jFoVz1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/4dD88d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/4dD88d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ED7C32786;
	Tue, 30 Jul 2024 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302409;
	bh=cWbY3Cmc/YKBmRt2vT4R2/MqWtKqreHB+HfOd7PGe6k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L/4dD88dfhrNcwOCEEB4nC4jZGnRr9EqBfo3XwPQJ54ILmK58k/JpMDUZVaUJ1Vki
	 0c9lNHMfSnyR5yNvvZ5LVbUMQ/NyeiGcrUTF50tb25KWpq5yA4p6ZZJpMPzdgcP+cE
	 8YEedZCDwBL/hAuKXDJrNP/A+zFvCEXVeK+gmB2yh/7V+gQP8AJQXPl5tAlXleN/PD
	 Ciud3WjOOFVp6Vdz1vZU+kC+hb2dqFJP28mc/StGT6EKXqoa2udfn68YAa+a/1nOSh
	 aFlg9bwpP7uwIIaSehdTXT+5Nj2vTO8NZSLi7DCYLb7tcR0yl/+UigEDAFOXwwsT5G
	 yZOmn0WWeOW3A==
Date: Mon, 29 Jul 2024 18:20:09 -0700
Subject: [PATCH 05/24] libfrog: report parent pointers to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850588.1350924.13958574921894441609.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 71a8e4bb9..597c38b11 100644
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

