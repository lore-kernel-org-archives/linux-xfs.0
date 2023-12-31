Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB4C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5A+eyNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF29C433C7;
	Sun, 31 Dec 2023 23:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066861;
	bh=O6ZVsdTVm718g5xszQhhMDzlnmM+sb0w/+XMaYpmLV0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E5A+eyNsutZmBDowTeyDvnqrzgHWas1Fe78EP/ZZQuvFV6tqejiKyRVPbdxxZiFpI
	 IBnGn4Zzi1a8qgYppxeQxK7V6PdR9VsIGt1gJbFpDWYPK8/LzPOsTGWrEAcsE9L8kl
	 pQPt7n6EGN+0qeJsF3QhNOdIlAO0jezSfGjt/b+zthQo1VUt6cK+4GYHcT4WlioEMr
	 gTU6W8KrSrfkEhblZ0ZkbJLJsl3XB+wNdz6MLuC1pJZXYWL+LBdBMenSdb3iFFJNhM
	 3GYD4iJA1hLidDKsrHcb00FAe+gPORpsMjUXWImTBm7/vrQIlAQk5LKQFbLHo0/43X
	 Z8czpheukVtkw==
Date: Sun, 31 Dec 2023 15:54:20 -0800
Subject: [PATCH 26/52] xfs_repair: repair rtbitmap block headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012514.1811243.4157121626242708938.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Check and repair the new block headers attached to rtbitmap blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   19 +++++++++++++++----
 repair/rt.c     |   47 +++++++++++++++++++++++++++++++++++------------
 repair/sb.c     |    8 +++++++-
 3 files changed, 57 insertions(+), 17 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index a99793b4d90..f3d687732b5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -843,6 +843,7 @@ fill_rbmino(xfs_mount_t *mp)
 			.tp		= tp,
 		};
 		union xfs_rtword_raw	*ondisk;
+		xfs_daddr_t		daddr;
 
 		/*
 		 * fill the file one block at a time
@@ -857,11 +858,9 @@ fill_rbmino(xfs_mount_t *mp)
 
 		ASSERT(map.br_startblock != HOLESTARTBLOCK);
 
-		error = -libxfs_trans_read_buf(
-				mp, tp, mp->m_dev,
-				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		daddr = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		error = -libxfs_trans_read_buf(mp, tp, mp->m_dev, daddr,
 				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
-
 		if (error) {
 			do_warn(
 _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %" PRIu64 "\n"),
@@ -873,6 +872,18 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		ondisk = xfs_rbmblock_wordptr(&args, 0);
 		memcpy(ondisk, bmp, mp->m_blockwsize << XFS_WORDLOG);
 
+		if (xfs_has_rtgroups(mp)) {
+			struct xfs_rtbuf_blkinfo *hdr = bp->b_addr;
+
+			bp->b_ops = &xfs_rtbitmap_buf_ops;
+			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+			hdr->rt_owner = cpu_to_be64(ip->i_ino);
+			hdr->rt_lsn = 0;
+			hdr->rt_blkno = cpu_to_be64(daddr);
+			platform_uuid_copy(&hdr->rt_uuid,
+					&mp->m_sb.sb_meta_uuid);
+		}
+
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
 		bmp += mp->m_blockwsize;
diff --git a/repair/rt.c b/repair/rt.c
index f73760e9cc9..ecf86099b47 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -194,7 +194,8 @@ check_rtfile_contents(
 	const char		*filename,
 	xfs_ino_t		ino,
 	void			*buf,
-	xfs_fileoff_t		filelen)
+	xfs_fileoff_t		filelen,
+	const struct xfs_buf_ops *buf_ops)
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_buf		*bp;
@@ -216,12 +217,10 @@ check_rtfile_contents(
 	}
 
 	while (bno < filelen)  {
-		xfs_filblks_t	maplen;
+		xfs_daddr_t	daddr;
 		int		nmap = 1;
 
-		/* Read up to 1MB at a time. */
-		maplen = min(filelen - bno, XFS_B_TO_FSBT(mp, 1048576));
-		error = -libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
+		error = -libxfs_bmapi_read(ip, bno, 1, &map, &nmap, 0);
 		if (error) {
 			do_warn(_("unable to read %s mapping, err %d\n"),
 					filename, error);
@@ -234,19 +233,39 @@ check_rtfile_contents(
 			break;
 		}
 
-		error = -libxfs_buf_read_uncached(mp->m_dev,
-				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		daddr = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		error = -libxfs_buf_read_uncached(mp->m_dev, daddr,
 				XFS_FSB_TO_BB(mp, map.br_blockcount),
-				0, &bp, NULL);
+				0, &bp, buf_ops);
 		if (error) {
 			do_warn(_("unable to read %s at dblock 0x%llx, err %d\n"),
 					filename, (unsigned long long)bno, error);
 			break;
 		}
 
-		check_rtwords(mp, filename, bno, bp->b_addr, buf);
+		if (buf_ops == &xfs_rtbitmap_buf_ops) {
+			struct xfs_rtalloc_args		args = {
+				.mp			= mp,
+			};
+			struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+			union xfs_rtword_raw		*incore = buf;
+			union xfs_rtword_raw		*ondisk;
+
+			if (hdr->rt_owner != cpu_to_be64(ino)) {
+				do_warn(
+ _("corrupt owner in %s at dblock 0x%llx\n"),
+					filename, (unsigned long long)bno);
+			}
+
+			args.rbmbp = bp;
+			ondisk = xfs_rbmblock_wordptr(&args, 0);
+			check_rtwords(mp, filename, bno, ondisk, incore);
+			buf += mp->m_blockwsize << XFS_WORDLOG;
+		} else {
+			check_rtwords(mp, filename, bno, bp->b_addr, buf);
+			buf += XFS_FSB_TO_B(mp, map.br_blockcount);
+		}
 
-		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
 		bno += map.br_blockcount;
 		libxfs_buf_relse(bp);
 	}
@@ -258,11 +277,15 @@ void
 check_rtbitmap(
 	struct xfs_mount	*mp)
 {
+	const struct xfs_buf_ops *buf_ops = NULL;
+
 	if (need_rbmino)
 		return;
+	if (xfs_has_rtgroups(mp))
+		buf_ops = &xfs_rtbitmap_buf_ops;
 
 	check_rtfile_contents(mp, "rtbitmap", mp->m_sb.sb_rbmino, btmcompute,
-			mp->m_sb.sb_rbmblocks);
+			mp->m_sb.sb_rbmblocks, buf_ops);
 }
 
 void
@@ -273,7 +296,7 @@ check_rtsummary(
 		return;
 
 	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			XFS_B_TO_FSB(mp, mp->m_rsumsize));
+			XFS_B_TO_FSB(mp, mp->m_rsumsize), NULL);
 }
 
 void
diff --git a/repair/sb.c b/repair/sb.c
index b0f85e9cff8..4e39c40370d 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -504,6 +504,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_frextents != 0)
 			return(XR_BAD_RT_GEO_DATA);
 	} else  {
+		unsigned int	rbmblock_bytes = sb->sb_blocksize;
+
 		/*
 		 * if we have a real-time partition, sanity-check geometry
 		 */
@@ -517,8 +519,12 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 							sb->sb_rextents))
 			return(XR_BAD_RT_GEO_DATA);
 
+		if (xfs_sb_is_v5(sb) &&
+		    (sb->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS))
+			rbmblock_bytes -= sizeof(struct xfs_rtbuf_blkinfo);
+
 		if (sb->sb_rbmblocks != (xfs_extlen_t) howmany(sb->sb_rextents,
-						NBBY * sb->sb_blocksize))
+						NBBY * rbmblock_bytes))
 			return(XR_BAD_RT_GEO_DATA);
 	}
 

