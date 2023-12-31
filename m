Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62471C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpRsGyV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F4AC433C7;
	Sun, 31 Dec 2023 23:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066876;
	bh=6URvZpwYSla3U76t0rFhzkRUG1Jxe2optJ18MT7fPs0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dpRsGyV9BWPPXVGwoTK6gzXiUw8jKBxXezqAmz5Gv8qPym59BqbkXyvNb/cPcRGoB
	 pUcEh9jefa8JZ+oAplaP7eTygnB8lYixRm4EzDy2hpzyZ4Prs/ZEANcZc7VC6pU7V1
	 QLRDJ8e9djq85JTUgRYuYX0umk8CBDcpWNop1WWi8u9VE6x8KV9c+o4CxupUM17JPk
	 vAkeco8yza7QVPoJTjq/dVqwjFJjZ9jtTJPxiFKqFg1QS8gJBC5up+27+5d4pwaVhb
	 kuCIQKbQTG4hwRnxmug6qPc5Gaw0TJx0zxFQzDlCY+T2AdiKdQs6SxHKRfPloNVirZ
	 hSlGCsIGmq46A==
Date: Sun, 31 Dec 2023 15:54:36 -0800
Subject: [PATCH 27/52] xfs_repair: repair rtsummary block headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012527.1811243.411179633383211721.stgit@frogsfrogsfrogs>
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

Check and repair the new block headers attached to rtsummary blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   18 +++++++++++++++---
 repair/rt.c     |   24 +++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 4 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index f3d687732b5..63a2768d9c6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -932,6 +932,7 @@ fill_rsumino(xfs_mount_t *mp)
 			.tp		= tp,
 		};
 		union xfs_suminfo_raw	*ondisk;
+		xfs_daddr_t		daddr;
 
 		/*
 		 * fill the file one block at a time
@@ -946,9 +947,8 @@ fill_rsumino(xfs_mount_t *mp)
 
 		ASSERT(map.br_startblock != HOLESTARTBLOCK);
 
-		error = -libxfs_trans_read_buf(
-				mp, tp, mp->m_dev,
-				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		daddr = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		error = -libxfs_trans_read_buf(mp, tp, mp->m_dev, daddr,
 				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
 
 		if (error) {
@@ -963,6 +963,18 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 		ondisk = xfs_rsumblock_infoptr(&args, 0);
 		memcpy(ondisk, smp, mp->m_blockwsize << XFS_WORDLOG);
 
+		if (xfs_has_rtgroups(mp)) {
+			struct xfs_rtbuf_blkinfo *hdr = bp->b_addr;
+
+			bp->b_ops = &xfs_rtsummary_buf_ops;
+			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+			hdr->rt_owner = cpu_to_be64(ip->i_ino);
+			hdr->rt_lsn = 0;
+			hdr->rt_blkno = cpu_to_be64(daddr);
+			platform_uuid_copy(&hdr->rt_uuid,
+					&mp->m_sb.sb_meta_uuid);
+		}
+
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
 		smp += mp->m_blockwsize;
diff --git a/repair/rt.c b/repair/rt.c
index ecf86099b47..0c282e36bf6 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -261,6 +261,24 @@ check_rtfile_contents(
 			ondisk = xfs_rbmblock_wordptr(&args, 0);
 			check_rtwords(mp, filename, bno, ondisk, incore);
 			buf += mp->m_blockwsize << XFS_WORDLOG;
+		} else if (buf_ops == &xfs_rtsummary_buf_ops) {
+			struct xfs_rtalloc_args		args = {
+				.mp			= mp,
+			};
+			struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+			union xfs_suminfo_raw		*incore = buf;
+			union xfs_suminfo_raw		*ondisk;
+
+			if (hdr->rt_owner != cpu_to_be64(ino)) {
+				do_warn(
+ _("corrupt owner in %s at dblock 0x%llx\n"),
+					filename, (unsigned long long)bno);
+			}
+
+			args.sumbp = bp;
+			ondisk = xfs_rsumblock_infoptr(&args, 0);
+			check_rtwords(mp, filename, bno, ondisk, incore);
+			buf += mp->m_blockwsize << XFS_WORDLOG;
 		} else {
 			check_rtwords(mp, filename, bno, bp->b_addr, buf);
 			buf += XFS_FSB_TO_B(mp, map.br_blockcount);
@@ -292,11 +310,15 @@ void
 check_rtsummary(
 	struct xfs_mount	*mp)
 {
+	const struct xfs_buf_ops *buf_ops = NULL;
+
 	if (need_rsumino)
 		return;
+	if (xfs_has_rtgroups(mp))
+		buf_ops = &xfs_rtsummary_buf_ops;
 
 	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			XFS_B_TO_FSB(mp, mp->m_rsumsize), NULL);
+			XFS_B_TO_FSB(mp, mp->m_rsumsize), buf_ops);
 }
 
 void

