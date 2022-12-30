Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC816C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiLaCgF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiLaCgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:36:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEF039F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:36:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEAA1B81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAA0C433D2;
        Sat, 31 Dec 2022 02:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454160;
        bh=wNSjPrgXsfLbhhxGx6xr1U3T7rPZweKhVP9dVZN0Ab4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PHOZl6zJRmr2xvohwaEpxlggx6u/gfOl5nnWYyKKoaRKQndtk0lTlw32cSqgdRNJJ
         24jZhYAAMce7LQH9zEdDyTgWdcG5OoKzUBXnFc0xmAqUz5yIPRZQZcQZyqS+cC72PY
         wW1h0l9ySKMOMUX/x4HT09s2qNeaO9tjSdf6NIhB0m1vo2pa3N7MXYm4tOlhSCkepS
         V/cawEGaGztxMrfJG9IL9Czje38najmgwAdog7letcilKHdlnwwJXcMBsxbdZi5U/n
         sK09KX29t2MMFZSHjmnEi0yfJFxI3kR8FJ6R6hWCqPPONLpaeV4YE0/53AOhC3Dg5w
         66MBeQ9e+nd9A==
Subject: [PATCH 23/45] xfs_repair: repair rtbitmap block headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878666.731133.7939249717252358238.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check and repair the new block headers attached to rtbitmap blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   20 ++++++++++++++++----
 repair/rt.c     |   42 ++++++++++++++++++++++++++++++------------
 repair/sb.c     |    8 +++++++-
 3 files changed, 53 insertions(+), 17 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 31d42b9306b..ad70b22a953 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -803,6 +803,8 @@ fill_rbmino(xfs_mount_t *mp)
 	}
 
 	while (bno < mp->m_sb.sb_rbmblocks)  {
+		xfs_daddr_t	daddr;
+
 		/*
 		 * fill the file one block at a time
 		 */
@@ -816,11 +818,9 @@ fill_rbmino(xfs_mount_t *mp)
 
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
@@ -831,6 +831,18 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 		memcpy(xfs_rbmblock_wordptr(bp, 0), bmp,
 				mp->m_blockwsize << XFS_WORDLOG);
 
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
index ed0f744cb9f..e7190383da3 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -168,11 +168,13 @@ check_rtfile_contents(
 	const char		*filename,
 	xfs_ino_t		ino,
 	void			*buf,
-	xfs_fileoff_t		filelen)
+	xfs_fileoff_t		filelen,
+	const struct xfs_buf_ops *buf_ops)
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_buf		*bp;
 	struct xfs_inode	*ip;
+	union xfs_rtword_ondisk	*words = buf;
 	xfs_fileoff_t		bno = 0;
 	int			error;
 
@@ -190,12 +192,11 @@ check_rtfile_contents(
 	}
 
 	while (bno < filelen)  {
-		xfs_filblks_t	maplen;
+		union xfs_rtword_ondisk *ondisk;
+		xfs_daddr_t	daddr;
 		int		nmap = 1;
 
-		/* Read up to 1MB at a time. */
-		maplen = min(filelen - bno, XFS_B_TO_FSBT(mp, 1048576));
-		error = -libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
+		error = -libxfs_bmapi_read(ip, bno, 1, &map, &nmap, 0);
 		if (error) {
 			do_warn(_("unable to read %s mapping, err %d\n"),
 					filename, error);
@@ -208,19 +209,32 @@ check_rtfile_contents(
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
+		if (buf_ops) {
+			struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+			if (hdr->rt_owner != cpu_to_be64(ino)) {
+				do_warn(
+	_("corrupt owner in %s at dblock 0x%llx\n"),
+					filename, (unsigned long long)bno);
+			}
+			ondisk = xfs_rbmblock_wordptr(bp, 0);
+			check_rtwords(mp, filename, bno, ondisk, words);
+			words += mp->m_blockwsize;
+		} else {
+			check_rtwords(mp, filename, bno, bp->b_addr, buf);
+			buf += XFS_FSB_TO_B(mp, map.br_blockcount);
+		}
 
-		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
 		bno += map.br_blockcount;
 		libxfs_buf_relse(bp);
 	}
@@ -232,11 +246,15 @@ void
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
@@ -247,7 +265,7 @@ check_rtsummary(
 		return;
 
 	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			XFS_B_TO_FSB(mp, mp->m_rsumsize));
+			XFS_B_TO_FSB(mp, mp->m_rsumsize), NULL);
 }
 
 void
diff --git a/repair/sb.c b/repair/sb.c
index a1cfeff1e91..04b3d8cf9ce 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -506,6 +506,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_frextents != 0)
 			return(XR_BAD_RT_GEO_DATA);
 	} else  {
+		unsigned int	rbmblock_bytes = sb->sb_blocksize;
+
 		/*
 		 * if we have a real-time partition, sanity-check geometry
 		 */
@@ -516,8 +518,12 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 				libxfs_highbit32((unsigned int)sb->sb_rextents))
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
 

