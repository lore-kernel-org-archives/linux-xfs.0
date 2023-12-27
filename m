Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16724384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aT4n0518"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9800FC433C7;
	Mon,  1 Jan 2024 00:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068222;
	bh=ovGpr6HXSx1ZuyS7GEjXmiRAX2Szi/yziGmk6ES3pLE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aT4n0518IUX4qhC/O8WAECfGCqBsT90CqUD5isIU6wAyWNmN6fxDyiM1EmzuisOCl
	 SrPeMba7Ulst5XN3irwtD11GMcf//xppcC82K6DjKinlNX56eUcT0fcGYMQIzKFbgK
	 tdkQyohMVqbaw39t8C63aXzhG9PbmJgD1woaLmX6OhWkXTWMCmWwXLQQ+SzpgcYY4y
	 /fiHfWvl/qVFN9gXn5iQdYgyWHKHQj0bbMSdmdyQu+vn6Q8Id+jKiYKZ1l3+G5NUQv
	 QXo4szxa/myqJawh3KPuHi7sjlQt7aVLCXQdlTO5CWKEuyW0bXuXdPBhcKvaDYA+0F
	 yD+GmQkGw9qnw==
Date: Sun, 31 Dec 2023 16:17:02 +9900
Subject: [PATCH 25/47] xfs_db: copy the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015646.1815505.17570592286285852411.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Copy the realtime rmapbt when we're metadumping the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index ccf7b89ccd5..c6f6bf1ea17 100644
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
@@ -2319,6 +2368,83 @@ process_exinode(
 					whichfork), nex, itype, is_meta);
 }
 
+static int
+process_rtrmap(
+	struct xfs_dinode	*dip,
+	typnm_t			itype)
+{
+	struct xfs_rtrmap_root	*dib;
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			whichfork;
+	typnm_t			btype;
+
+	if (itype == TYP_ATTR && metadump.show_warnings) {
+		print_warning("ignoring rtrmapbt root in inode %llu attr fork",
+				(unsigned long long)metadump.cur_ino);
+		return 1;
+	}
+
+	whichfork = XFS_DATA_FORK;
+	btype = TYP_RTRMAPBT;
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	level = be16_to_cpu(dib->bb_level);
+	nrecs = be16_to_cpu(dib->bb_numrecs);
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
+		if (!scan_btree(ag, bno, level, btype, &itype,
+				scanfunc_rtrmapbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 process_inode_data(
 	struct xfs_dinode	*dip,
@@ -2363,6 +2489,9 @@ process_inode_data(
 
 		case XFS_DINODE_FMT_BTREE:
 			return process_btinode(dip, itype);
+
+		case XFS_DINODE_FMT_RMAP:
+			return process_rtrmap(dip, itype);
 	}
 	return 1;
 }

