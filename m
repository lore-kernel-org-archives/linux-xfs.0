Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07D3BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+eugcSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1A6C433C8;
	Sun, 31 Dec 2023 21:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058824;
	bh=DdPduB72BynKanXiNEeS3gMgZnmD8MUGewOs/zaEVY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R+eugcSWmHBGtO7xi/X6S6O4j0ayFIF6572HL+J6pq3Yq24c28xqkIFsnMvErMh1C
	 8gQNW0MasRvKpIgU2Vx9sIIyqUSkTTcUrRZiYmHhvyJxwhQvmgYWvMw1LKu2xuiZ6G
	 cSmHX28X5kqsYxmSVBHW3qwkfKsoGEBkKjbrL1yZqvqIPHJTBgv1uF6slkpai5+NFz
	 q4wE7i4iWqyNhfq+XAwLY8XGdLDdbjOqE9uQ8hDCL9OzU+9oh1ilTTHSPOV6C/8RYt
	 +uXeQxj4+65METWppdU8WWbBpdWqriTUw5A0sm8Q0JTpq5MTiXPEusJRycnHUgvmml
	 HYCnWPmD5zzrg==
Date: Sun, 31 Dec 2023 13:40:23 -0800
Subject: [PATCH 33/39] xfs: repair rmap btree inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850431.1764998.13516823120574789010.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Teach the inode repair code how to deal with realtime rmap btree inodes
that won't load properly.  This is most likely moot since the filesystem
generally won't mount without the rtrmapbt inodes being usable, but
we'll add this for completeness.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 45ad78d1e5404..f4f6ed6ef5120 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -895,6 +895,37 @@ xrep_dinode_bad_bmbt_fork(
 	return false;
 }
 
+/* Return true if this rmap-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_rmapbt_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size,
+	int			whichfork)
+{
+	struct xfs_rtrmap_root	*dfp;
+	unsigned int		nrecs;
+	unsigned int		level;
+
+	if (whichfork != XFS_DATA_FORK)
+		return true;
+	if (dfork_size < sizeof(struct xfs_rtrmap_root))
+		return true;
+
+	dfp = XFS_DFORK_PTR(dip, whichfork);
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
 /*
  * Check the data fork for things that will fail the ifork verifiers or the
  * ifork formatters.
@@ -975,6 +1006,11 @@ xrep_dinode_check_dfork(
 				XFS_DATA_FORK))
 			return true;
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (xrep_dinode_bad_rmapbt_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
 	default:
 		return true;
 	}
@@ -1095,6 +1131,11 @@ xrep_dinode_check_afork(
 					XFS_ATTR_FORK))
 			return true;
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (xrep_dinode_bad_rmapbt_fork(sc, dip, afork_size,
+				XFS_ATTR_FORK))
+			return true;
+		break;
 	default:
 		return true;
 	}
@@ -1142,6 +1183,7 @@ xrep_dinode_ensure_forkoff(
 	uint16_t		mode)
 {
 	struct xfs_bmdr_block	*bmdr;
+	struct xfs_rtrmap_root	*rmdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
 	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
@@ -1248,6 +1290,10 @@ xrep_dinode_ensure_forkoff(
 		bmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 		dfork_min = xfs_bmap_broot_space(sc->mp, bmdr);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		rmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+		dfork_min = xfs_rtrmap_broot_space(sc->mp, rmdr);
+		break;
 	default:
 		dfork_min = 0;
 		break;

