Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF26C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTaTytir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2D1C433C7;
	Sun, 31 Dec 2023 23:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065735;
	bh=3DT7IoWfIRhiyFfPAgoW7O41WYRFKeirmoIb3shkogA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mTaTytirWbnPA23jVssYjuwIRXstDe/Z3cYECt6jQc7so4nWlflSa0I72j6fkyem3
	 q/IMKNjCai3tcpQsaGDNGkuK5h57gird+g0Hi+P6vy9jcC9pxLBoG9dDN5GCztJLrK
	 N1CIEkGnbyaSRHszRC4A8qnM2JAgr/jcCEowVe68gD9vuJjg3ajQFDPOhK4IeC5Ro/
	 sIWm76PbBYvD5BXGBdun7lqLYoQxHaRzdEU/xbJVypm9IRVDc1nQj5BKMKG3Kw4Em9
	 slXSq599Z+7OfB+QfFDdOyb9eyjf4OxTFY3FZQ52OpDp7aRIhzwN7Jkoe4za87Nmb3
	 Fk14cuMcgPAUQ==
Date: Sun, 31 Dec 2023 15:35:34 -0800
Subject: [PATCH 23/58] libfrog: report metadata directories in the geometry
 report
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010254.1809361.9550201092255962244.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 libfrog/fsgeom.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 061995fa2c7..e2732fb7a09 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -32,6 +32,7 @@ xfs_report_geom(
 	int			inobtcount;
 	int			nrext64;
 	int			parent;
+	int			metadir;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -51,12 +52,14 @@ xfs_report_geom(
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
+	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 "         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
+"         =%-22s metadir=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
@@ -67,6 +70,7 @@ xfs_report_geom(
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
 		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
+		"", metadir,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,

