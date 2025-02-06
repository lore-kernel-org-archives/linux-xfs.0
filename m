Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1B92417CA
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882747; cv=none; b=ChbMNqe7LeJ4rhhGzTnN/CqbhDR/TspaGMMBUh9reO5kY+cEf5aq6PKKsWX28vU+11hMWtZCN5NFF+JQ6clIq7bbDDlsLdTd2ZT7HTRsYkDEc1RthpuyQLQT8YDjKq9VIJoSKd7mrMGmfKC8bapnszlKiAbAm1K4D02r7TDrpqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882747; c=relaxed/simple;
	bh=f6RldL/JDT0hNZNrxFZq+1iMC7iRtjXMKx3HL07lYxg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGyx7w6Be99Hk/H6mR1Cala2uBQ6qDspjPEZJe9hy+C2oEUlgkwQni439T9F7aAXCYsBx4dIXMVSJAFy/FJXLZZvlBqwfX7xhk9V8YJFCys8OgiIK2gxkyOps+kPdyvbzQtsPAxIDQUR+au4/7bjNM5Zkp1JGYf4R/22jLA0Jvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HR+RWwud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HR+RWwud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB2DC4CEDD;
	Thu,  6 Feb 2025 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882747;
	bh=f6RldL/JDT0hNZNrxFZq+1iMC7iRtjXMKx3HL07lYxg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HR+RWwudODRZIDAtS4X/NC3j0w9Tr10anainT6KDo45pthikH9D/VPFasGV/JZ5aU
	 HIWyatiUrgJo6cxfke9D3Mtnrk0F+mkE8lxcaJfXMbruBpHKX2iz8oMSRsKkj1vFPi
	 t+rkfMUsu8NwBvz+3b2qtyQkwAiiduhqCbSv1ElkodBwj6htudSyZqXICfmVUFWdmU
	 hE/oviN9gIi7qVXvsszyB4ej12Ato6r0QtRsz4anNIZsBykWFn14mKydbEh1gwclTK
	 k2kgFrmvGnCK9HJZSEGYHITqoqaTQS5ZOo0RMWzimUeFGLzXF9BeIitXxehHoPknNb
	 RZ6PqyBFgwoXg==
Date: Thu, 06 Feb 2025 14:59:06 -0800
Subject: [PATCH 09/22] xfs_db: add rtrefcount reservations to the rgresv
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089070.2741962.16480973892880802520.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report rt refcount btree reservations in the rgresv subcommand output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/info.c                |   13 +++++++++++++
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 14 insertions(+)


diff --git a/db/info.c b/db/info.c
index ce6f358420a79d..6ad3e23832faa3 100644
--- a/db/info.c
+++ b/db/info.c
@@ -202,6 +202,19 @@ print_rgresv_info(
 
 	ask += libxfs_rtrmapbt_calc_reserves(mp);
 
+	/* rtrefcount */
+	error = -libxfs_rtginode_load(rtg, XFS_RTGI_REFCOUNT, tp);
+	if (error) {
+		dbprintf(_("Cannot load rtgroup %u refcount inode, error %d\n"),
+			rtg_rgno(rtg), error);
+		goto out_rele_dp;
+	}
+	if (rtg_refcount(rtg))
+		used += rtg_refcount(rtg)->i_nblocks;
+	libxfs_rtginode_irele(&rtg->rtg_inodes[XFS_RTGI_REFCOUNT]);
+
+	ask += libxfs_rtrefcountbt_calc_reserves(mp);
+
 	printf(_("rtg %d: dblocks: %llu fdblocks: %llu reserved: %llu used: %llu"),
 			rtg_rgno(rtg),
 			(unsigned long long)mp->m_sb.sb_dblocks,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 87a598f346f86a..7ce10c408de1a0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -320,6 +320,7 @@
 #define xfs_rtgroup_get			libxfs_rtgroup_get
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 
+#define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs

