Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4C1F95E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052090; cv=none; b=W7WZpYEpSZazUZOtv3ToRaZtNz0ledCRmhFNhgrDMUPo22VMQCJheRldpUKpJhHPtDBb4CsWHJoHsL9CEiZW3UUxpN+3H0VX8ieo/tgMyAesNGqzzNRjE9XQHlT+ay1AhRiaJwWg7fApnVFs4u4C/jFCVSKnG/20XUUdk7ctdec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052090; c=relaxed/simple;
	bh=opOSw4IhEP/teePD0uASdn6mtV9l3jRGqKVc55qXqUg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EmnMdaCBVacDCge4oo5L8VRNAyLfi9PJndEIr6J87LJ6g6588CqSNfKJZR1IGi4YjLbIe0huHLB6MQlxka5ofuqvbK2tCSmwmcC6ZKd2cpjmtkWmxq5uIGQC0JqHOb1orzZrpwS82Hzo+G90LEX191pWfKfcvSX6+L0MhUyxKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1tSovRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1tSovRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37010C4CECE;
	Fri, 13 Dec 2024 01:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052090;
	bh=opOSw4IhEP/teePD0uASdn6mtV9l3jRGqKVc55qXqUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q1tSovRo7TcqBRlmquZ7mccwazSfWeSGouRP5y9LNkxbv0Pzcz85+WaR4J1M9ISOG
	 mWr/yOGVwf2pC6dAUgmB8eA5wVtVVl//7v6ZiVULMo8NB+Vplwr7L9vZnbimKLinyr
	 1p8+FkNbWg7ajud6v7J7AX3xnpokejItfT7742cG8MbZ3LcFJcV+EJypF2HHJMET9p
	 J+PrrJ46JiqFMZjBfyOX71Xb0RoftbnhzRrr6c5sufgHhppcKRiOA381A/e9bfIhe9
	 8Pgcg0XsQs5ffoNw7mbkrVzQnQnZucEyfPc14+0u4G1R7XIRYlXK0wVYsdV3GOLPj+
	 tvguPiuacHUDw==
Date: Thu, 12 Dec 2024 17:08:09 -0800
Subject: [PATCH 29/37] xfs: repair rmap btree inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123812.1181370.1385680244042469564.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the inode repair code how to deal with realtime rmap btree inodes
that won't load properly.  This is most likely moot since the filesystem
generally won't mount without the rtrmapbt inodes being usable, but
we'll add this for completeness.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 816e81330ffc99..d7e3f033b16073 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -944,6 +944,34 @@ xrep_dinode_bad_bmbt_fork(
 	return false;
 }
 
+/* Return true if this rmap-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_rtrmapbt_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size)
+{
+	struct xfs_rtrmap_root	*dfp;
+	unsigned int		nrecs;
+	unsigned int		level;
+
+	if (dfork_size < sizeof(struct xfs_rtrmap_root))
+		return true;
+
+	dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	nrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (level > sc->mp->m_rtrmap_maxlevels)
+		return true;
+	if (xfs_rtrmap_droot_space_calc(level, nrecs) > dfork_size)
+		return true;
+	if (level > 0 && nrecs == 0)
+		return true;
+
+	return false;
+}
+
 /* Check a metadata-btree fork. */
 STATIC bool
 xrep_dinode_bad_metabt_fork(
@@ -956,6 +984,8 @@ xrep_dinode_bad_metabt_fork(
 		return true;
 
 	switch (be16_to_cpu(dip->di_metatype)) {
+	case XFS_METAFILE_RTRMAP:
+		return xrep_dinode_bad_rtrmapbt_fork(sc, dip, dfork_size);
 	default:
 		return true;
 	}
@@ -1220,6 +1250,7 @@ xrep_dinode_ensure_forkoff(
 	uint16_t		mode)
 {
 	struct xfs_bmdr_block	*bmdr;
+	struct xfs_rtrmap_root	*rmdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
 	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
@@ -1328,6 +1359,10 @@ xrep_dinode_ensure_forkoff(
 		break;
 	case XFS_DINODE_FMT_META_BTREE:
 		switch (be16_to_cpu(dip->di_metatype)) {
+		case XFS_METAFILE_RTRMAP:
+			rmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+			dfork_min = xfs_rtrmap_broot_space(sc->mp, rmdr);
+			break;
 		default:
 			dfork_min = 0;
 			break;

