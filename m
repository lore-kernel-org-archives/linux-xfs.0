Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7BF1368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfTolOI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A256C433C8;
	Mon,  1 Jan 2024 00:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069207;
	bh=56/qTPp6T7G8s4UJaVToZs98ILPBa4HEy6TViFfs6lc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GfTolOI43kCyjr22+AziTPqApOluUQLJx65FKhaaJ0ghMdO0Asti/0+35B2OQ9eHI
	 ylnuPRg9iMOE3Ej9wHjMCUpUg8qIS77QVszx0ftygKe40V+UIVq6DxyPkC80F1yLuv
	 C5gFcrJfed556P0kpjpX0wNN02/8kGNsPe2PKj1vLD7VaR/bGCuYoDms3vHfVyzhXh
	 Tlr2eTuBjLW4aWdt89XEazJafdMylToLXPg0VmwkFdLNme1Z7DiAmQS8Nh/NWAZXpm
	 F08HmNJV4qvv4NcofpA0gTNRtEnNOZdjFYcVk6HYoSIppSQpwHkJaKxGyi/hi75+JD
	 9tQMvBNInESfQ==
Date: Sun, 31 Dec 2023 16:33:27 +9900
Subject: [PATCH 28/42] xfs_db: copy the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017500.1817107.14196805252186384913.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Copy the realtime refcountbt when we're metadumping the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index c6f6bf1ea17..6a33335a15b 100644
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
@@ -2445,6 +2494,83 @@ process_rtrmap(
 	return 1;
 }
 
+static int
+process_rtrefc(
+	struct xfs_dinode	*dip,
+	typnm_t			itype)
+{
+	struct xfs_rtrefcount_root	*dib;
+	int			i;
+	xfs_rtrefcount_ptr_t	*pp;
+	int			level;
+	int			nrecs;
+	int			maxrecs;
+	int			whichfork;
+	typnm_t			btype;
+
+	if (itype == TYP_ATTR && metadump.show_warnings) {
+		print_warning("ignoring rtrefcbt root in inode %llu attr fork",
+				(unsigned long long)metadump.cur_ino);
+		return 1;
+	}
+
+	whichfork = XFS_DATA_FORK;
+	btype = TYP_RTREFCBT;
+
+	dib = (struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, whichfork);
+	level = be16_to_cpu(dib->bb_level);
+	nrecs = be16_to_cpu(dib->bb_numrecs);
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
+		if (!scan_btree(ag, bno, level, btype, &itype,
+				scanfunc_rtrefcbt))
+			return 0;
+	}
+	return 1;
+}
+
 static int
 process_inode_data(
 	struct xfs_dinode	*dip,
@@ -2492,6 +2618,9 @@ process_inode_data(
 
 		case XFS_DINODE_FMT_RMAP:
 			return process_rtrmap(dip, itype);
+
+		case XFS_DINODE_FMT_REFCOUNT:
+			return process_rtrefc(dip, itype);
 	}
 	return 1;
 }

