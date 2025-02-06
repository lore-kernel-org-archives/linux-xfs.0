Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85BF23AE65
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882325; cv=none; b=EDKVhWk+tdgCQRSkwbCHVv92nRfpASBq3hnDdC7vcWhMBn1mBXgdj7ZCsZ5F8reblVRVv2u8VI+CJHMOW1f4L7iGqb+hBw3sz+HL1nubTzoHjCJZy4F9hVhR8++wmlMLeK6OqQm7Qj3673txW7lo03PmdqpHDNeOxbzpaEsKUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882325; c=relaxed/simple;
	bh=I5x0kj5mYNwBHiI6Zx2ipHy0Qe6TDUrWEvkU86FeIrc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqYGNO2jQlfh5CpjrJCCQoLvAZIsJWM383uegl8n7czyDkrv4IGoCVaNRKsayE3R2CDgxg7WJ2qdRzyV5NuqdPX4iEV08gDitb36UFfrVY4BDR7Ifzym8D0Z0Fi6bpucCQLn3sEMtAMchEXiyWe+ubkrFdCUtpGPMAdI8ZXvxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMvduAmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMvduAmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7ADC4CEE0;
	Thu,  6 Feb 2025 22:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882325;
	bh=I5x0kj5mYNwBHiI6Zx2ipHy0Qe6TDUrWEvkU86FeIrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rMvduAmCGkn6Sz/AfW/8qGBnEA3HDfsPqVuW3ua3+oxrW3tjlkwlnb7qj9jHxceXy
	 yzpI4NOYV/T9ii911p1Z+cqg7iJJIddGmEkNKXqm10j3CYTLKXvMa+7kEy/GZmEe1i
	 P6kZFOprybXOVu7Bj23Er3A0+iGLu0yODa3PkV92qTgYVjbNHn1qBA2oelWDH5FDWX
	 RNSpz5ZSHatsxARuYE3M+j5EE06m739ZoEW8emFPgFmN1UAJvgeBRapqSkdJBEMhFK
	 BEzkdhT3VhXxrM5aVWj8+kYZCQmekOobpYFGmpAcGTKDagoMUetp9Rizxb+4NRd7E0
	 VRauPPGca9E0Q==
Date: Thu, 06 Feb 2025 14:52:04 -0800
Subject: [PATCH 09/27] xfs_db: copy the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088234.2741033.11666132944549575171.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Copy the realtime rmapbt when we're metadumping the filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/metadump.c |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index 4f4b4f8a39a551..aa946746cdfa68 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -589,6 +589,55 @@ copy_rmap_btree(
 	return scan_btree(agno, root, levels, TYP_RMAPBT, agf, scanfunc_rmapbt);
 }
 
+static int
+scanfunc_rtrmapbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_rtrmap_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rtrmap_mxr[1]) {
+		if (metadump.show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = xfs_rtrmap_ptr_addr(block, 1, mp->m_rtrmap_mxr[1]);
+	for (i = 0; i < numrecs; i++) {
+		xfs_agnumber_t	pagno;
+		xfs_agblock_t	pbno;
+
+		pagno = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		pbno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
+
+		if (pbno == 0 || pbno > mp->m_sb.sb_agblocks ||
+		    pagno > mp->m_sb.sb_agcount) {
+			if (metadump.show_warnings)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s block %u/%u",
+						pagno, pbno,
+						(unsigned long long)metadump.cur_ino,
+						typtab[btype].name, agno, agbno);
+			continue;
+		}
+		if (!scan_btree(pagno, pbno, level, btype, arg,
+				scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 scanfunc_refcntbt(
 	struct xfs_btree_block	*block,
@@ -2325,6 +2374,69 @@ process_exinode(
 			nex);
 }
 
+static int
+process_rtrmap(
+	struct xfs_dinode	*dip)
+{
+	int			whichfork = XFS_DATA_FORK;
+	struct xfs_rtrmap_root	*dib =
+		(struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	xfs_rtrmap_ptr_t	*pp;
+	int			level = be16_to_cpu(dib->bb_level);
+	int			nrecs = be16_to_cpu(dib->bb_numrecs);
+	typnm_t			btype = TYP_RTRMAPBT;
+	int			maxrecs;
+	int			i;
+
+	if (level > mp->m_rtrmap_maxlevels) {
+		if (metadump.show_warnings)
+			print_warning("invalid level (%u) in inode %lld %s "
+					"root", level,
+					(unsigned long long)metadump.cur_ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	if (level == 0)
+		return 1;
+
+	maxrecs = libxfs_rtrmapbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, whichfork),
+			false);
+	if (nrecs > maxrecs) {
+		if (metadump.show_warnings)
+			print_warning("invalid numrecs (%u) in inode %lld %s "
+					"root", nrecs,
+					(unsigned long long)metadump.cur_ino,
+					typtab[btype].name);
+		return 1;
+	}
+
+	pp = xfs_rtrmap_droot_ptr_addr(dib, 1, maxrecs);
+	for (i = 0; i < nrecs; i++) {
+		xfs_agnumber_t	ag;
+		xfs_agblock_t	bno;
+
+		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
+
+		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
+				ag > mp->m_sb.sb_agcount) {
+			if (metadump.show_warnings)
+				print_warning("invalid block number (%u/%u) "
+						"in inode %llu %s root", ag,
+						bno,
+						(unsigned long long)metadump.cur_ino,
+						typtab[btype].name);
+			continue;
+		}
+
+		if (!scan_btree(ag, bno, level, btype, NULL, scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 process_inode_data(
 	struct xfs_dinode	*dip)
@@ -2366,6 +2478,14 @@ process_inode_data(
 
 	case XFS_DINODE_FMT_BTREE:
 		return process_btinode(dip, XFS_DATA_FORK);
+
+	case XFS_DINODE_FMT_META_BTREE:
+		switch (be16_to_cpu(dip->di_metatype)) {
+		case XFS_METAFILE_RTRMAP:
+			return process_rtrmap(dip);
+		default:
+			return 1;
+		}
 	}
 	return 1;
 }

