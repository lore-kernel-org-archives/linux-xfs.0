Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BF72417CA
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882732; cv=none; b=szQEXJYOzoBpq6klCTLDUnnooFLStZ4KC/4jJ6n/oMs2KN6uRw7VMv9dIN53zdonvEe5Y6W03DeNtifs5rRWyI2wTfMVVj7wZ1GeGe4lieVHI38lQg8ta0yApjZwfzMiUArYyCPXz4nkk9a19jvt+3MqvUoCJ0gI3gNE7KVVzF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882732; c=relaxed/simple;
	bh=qoy2NNl35N1xqgpuYFJXMBIkZv6ESGy/uF0yWBljZg4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2F/0EHJlkX/CrXPu4hnGIkxxnqnbaOUt8Tk8aMI6Xa1+AxfpD1e04mqx3MxK40cUC+0vF8lVzc4WBlAKl6t0FJRNpFqXnipSTsMVVnmny7vs18bSBeCOx92teKi9Q9QXzpblp0/JJdSezdN5COM6GbcEARW77j5ERID0kyt/d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZ78ZYNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZ78ZYNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B1C4CEDD;
	Thu,  6 Feb 2025 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882731;
	bh=qoy2NNl35N1xqgpuYFJXMBIkZv6ESGy/uF0yWBljZg4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MZ78ZYNLU1tIorGFNEathUtRcz6SJYLL9rHXxe71IygICTqmsRrA2cI3srtznZ1kX
	 fTISrDyg6sBVGYMYi/owj69vqIJAOvGDrPPU0ZIq6E3u2PMB6zfrF3C2foUcKvtcNF
	 6CZ3Dwl/cikC05LM66jaUQvRrjSFaxU4HBJNH+nTOg1b8Aw1wJgih5obfcJkkn586+
	 UmchhEhURqgcLf/tMWLEV7fIAfMGtju3zlU4YMFFuEI+K4Rclp3b/uFLFKmEIB+qws
	 Rjo7nQlPaxpf3JPFWKIL9iQKE5bzRoNJ0f3R657S7wauovAFRgyC5PLItMXrvLN4ge
	 Pf7rhdii72dHQ==
Date: Thu, 06 Feb 2025 14:58:51 -0800
Subject: [PATCH 08/22] xfs_db: copy the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089055.2741962.11135146687529271423.stgit@frogsfrogsfrogs>
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

Copy the realtime refcountbt when we're metadumping the filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/metadump.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index aa946746cdfa68..3e00e6de817752 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -710,6 +710,55 @@ copy_refcount_btree(
 	return scan_btree(agno, root, levels, TYP_REFCBT, agf, scanfunc_refcntbt);
 }
 
+static int
+scanfunc_rtrefcbt(
+	struct xfs_btree_block	*block,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	int			level,
+	typnm_t			btype,
+	void			*arg)
+{
+	xfs_rtrefcount_ptr_t	*pp;
+	int			i;
+	int			numrecs;
+
+	if (level == 0)
+		return 1;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs > mp->m_rtrefc_mxr[1]) {
+		if (metadump.show_warnings)
+			print_warning("invalid numrecs (%u) in %s block %u/%u",
+				numrecs, typtab[btype].name, agno, agbno);
+		return 1;
+	}
+
+	pp = xfs_rtrefcount_ptr_addr(block, 1, mp->m_rtrefc_mxr[1]);
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
+				scanfunc_rtrefcbt))
+			return 0;
+	}
+	return 1;
+}
+
 /* filename and extended attribute obfuscation routines */
 
 struct name_ent {
@@ -2437,6 +2486,69 @@ process_rtrmap(
 	return 1;
 }
 
+static int
+process_rtrefc(
+	struct xfs_dinode	*dip)
+{
+	int			whichfork = XFS_DATA_FORK;
+	struct xfs_rtrefcount_root *dib =
+		(struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, whichfork);
+	int			level = be16_to_cpu(dib->bb_level);
+	int			nrecs = be16_to_cpu(dib->bb_numrecs);
+	typnm_t			btype = TYP_RTREFCBT;
+	int			maxrecs;
+	xfs_rtrefcount_ptr_t	*pp;
+	int			i;
+
+	if (level > mp->m_rtrefc_maxlevels) {
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
+	maxrecs = libxfs_rtrefcountbt_droot_maxrecs(
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
+	pp = xfs_rtrefcount_droot_ptr_addr(dib, 1, maxrecs);
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
+		if (!scan_btree(ag, bno, level, btype, NULL, scanfunc_rtrefcbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 process_inode_data(
 	struct xfs_dinode	*dip)
@@ -2483,6 +2595,8 @@ process_inode_data(
 		switch (be16_to_cpu(dip->di_metatype)) {
 		case XFS_METAFILE_RTRMAP:
 			return process_rtrmap(dip);
+		case XFS_METAFILE_RTREFCOUNT:
+			return process_rtrefc(dip);
 		default:
 			return 1;
 		}

