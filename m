Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE7A433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992532; cv=none; b=sGVaUOeb2n7e1Sq+tb/2GjAXERGce7/eyedD8vFmMhtR3qISbv1H//zQSUXheiB58WdBGNibhDuTYaE0nA/rh+hkLpTH+A9P4IjIyk8VkumZ8OPWow7u/wiyXQWaxHaGG1pgLn8oJanSPdvQtzkHQS5DG4OYODITeyJEbx2EcC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992532; c=relaxed/simple;
	bh=tPh2IZbz5whf7Hat1J/yDmol/gL1I0GDaN4qz6njuGg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HzW5vqRNASMk1VIEu1nKMU2EK8IZups8KFtuhBuvi7yHd1ldJXvE0irGg/hTsiqXYaXeB9zkMVwHNl79c7Bkh6y21h66UR6HSaEcSmHXmtWymJDOW538wd1KQ7CmEVxywhyTIt/Wx4+Ji5h/GqaAW8lewQDBzYd8N7GaCCuLSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKhrbhdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKhrbhdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BFC4CED3;
	Mon, 23 Dec 2024 22:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992532;
	bh=tPh2IZbz5whf7Hat1J/yDmol/gL1I0GDaN4qz6njuGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lKhrbhdT5IjkEoyvuYsF/TbQzUyE18JGnltTXTeEhcX1hPgMmlXiFTryB8O9EHtKH
	 zuXdPCD7C6eOiPLJ/TD3qNPgWnILmueA24SdtYRS02T4feSOAfj1fg8kGAbBnm6lsY
	 rXVYpdf4T7AAvBYCg39MRS2usKIHw/8nLH8Oy9ai7yHBl2eoRt2tRhTvKGTjNzoW04
	 5w4l6L0ArmEzs1xiyr9/nEpRpJQ/G2PuM/hWW7095fHTx1zO3k5LpygaZKbb89LZRE
	 Pz2pliXRbtIskagSNO0afblB0m4Sbb0VZFRpMR7tGe9UxaYnDy8DoPYoKs3UcL2+x0
	 WIwMhJmYBPIDg==
Date: Mon, 23 Dec 2024 14:22:12 -0800
Subject: [PATCH 40/51] xfs_io: display rt group in verbose fsmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944416.2297565.1994591832292422331.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Display the rt group number in the fsmap output, just like we do for
regular data files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/fsmap.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index bf1196390cf35d..6de720f238bb44 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -14,6 +14,7 @@
 
 static cmdinfo_t	fsmap_cmd;
 static dev_t		xfs_data_dev;
+static dev_t		xfs_rt_dev;
 
 static void
 fsmap_help(void)
@@ -170,7 +171,7 @@ dump_map_verbose(
 	unsigned long long	i;
 	struct fsmap		*p;
 	int			agno;
-	off_t			agoff, bperag;
+	off_t			agoff, bperag, bperrtg;
 	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
 	int			nr_w, dev_w;
 	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
@@ -185,6 +186,7 @@ dump_map_verbose(
 	tot_w = MINTOT_WIDTH;
 	bperag = (off_t)fsgeo->agblocks *
 		  (off_t)fsgeo->blocksize;
+	bperrtg = bytes_per_rtgroup(fsgeo);
 	sunit = (fsgeo->sunit * fsgeo->blocksize);
 	swidth = (fsgeo->swidth * fsgeo->blocksize);
 
@@ -243,6 +245,13 @@ dump_map_verbose(
 				"(%lld..%lld)",
 				(long long)BTOBBT(agoff),
 				(long long)BTOBBT(agoff + p->fmr_length - 1));
+		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
+			agno = p->fmr_physical / bperrtg;
+			agoff = p->fmr_physical % bperrtg;
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fmr_length - 1));
 		} else
 			abuf[0] = 0;
 		aoff_w = max(aoff_w, strlen(abuf));
@@ -315,6 +324,16 @@ dump_map_verbose(
 			snprintf(gbuf, sizeof(gbuf),
 				"%lld",
 				(long long)agno);
+		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
+			agno = p->fmr_physical / bperrtg;
+			agoff = p->fmr_physical % bperrtg;
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fmr_length - 1));
+			snprintf(gbuf, sizeof(gbuf),
+				"%lld",
+				(long long)agno);
 		} else {
 			abuf[0] = 0;
 			gbuf[0] = 0;
@@ -501,6 +520,7 @@ fsmap_f(
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
 	xfs_data_dev = fs ? fs->fs_datadev : 0;
+	xfs_rt_dev = fs ? fs->fs_rtdev : 0;
 
 	head->fmh_count = map_size;
 	do {

