Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B026AC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8757D2076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1a6qrSs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgEXJSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgEXJSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70AEC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=NzINLswjMRkQH0OzEq72AlXPauN7/jOfZE/ead6PNpY=; b=B1a6qrSsULJaemyYctObYYqw4z
        VomZBQp8l1hw4dRQHlK4nh+4uRK0BWPN7MtSiP7fMFZakf82qTMRd843tS9zT3bKNH1MlTVR7X1Fr
        NAyeuhyDW+du0Y3aO+luSxVPQxxDp6Z7xvyt9/wxAx3NflILg8n3eDtsTBnletg1/rRWGVfzPtdK9
        Et8T6NBfNl3yZjvFbRr5G8mWKBb1VIZpTo2hYcxXEBnFZOrysFcOh4VxCtz3rzphhUuPec5wravDT
        Yo4Ek87plQfwZL9wx5WZ1VGP/9A/2+rP8P4wOe6qectQ6lNdZGiP9dkSp0vfQHa2e/PrIEfUS4mhj
        cosZoIHA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmln-0004r0-87
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/14] xfs: move the di_nblocks field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:47 +0200
Message-Id: <20200524091757.128995-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524091757.128995-1-hch@lst.de>
References: <20200524091757.128995-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the nblocks
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       | 12 ++++++------
 fs/xfs/libxfs/xfs_bmap_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_da_btree.c   |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/xfs_bmap_util.c         |  8 ++++----
 fs/xfs/xfs_icache.c            |  4 ++--
 fs/xfs/xfs_inode.c             |  8 ++++----
 fs/xfs/xfs_inode.h             |  1 +
 fs/xfs/xfs_inode_item.c        |  2 +-
 fs/xfs/xfs_iops.c              |  3 +--
 fs/xfs/xfs_itable.c            |  2 +-
 fs/xfs/xfs_qm.c                | 10 +++++-----
 fs/xfs/xfs_quotaops.c          |  2 +-
 15 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7f77d1c1208b0..9af2c51a450ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -623,7 +623,7 @@ xfs_bmap_btree_to_extents(
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
-	ip->i_d.di_nblocks--;
+	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_bufs[0] == cbp)
@@ -725,7 +725,7 @@ xfs_bmap_extents_to_btree(
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
 	tp->t_firstblock = args.fsbno;
 	cur->bc_ino.allocated++;
-	ip->i_d.di_nblocks++;
+	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, args.fsbno),
@@ -907,7 +907,7 @@ xfs_bmap_local_to_extents(
 	xfs_iext_insert(ip, &icur, &rec, 0);
 
 	ifp->if_nextents = 1;
-	ip->i_d.di_nblocks = 1;
+	ip->i_nblocks = 1;
 	xfs_trans_mod_dquot_byino(tp, ip,
 		XFS_TRANS_DQ_BCOUNT, 1L);
 	flags |= xfs_ilog_fext(whichfork);
@@ -3448,7 +3448,7 @@ xfs_bmap_btalloc_accounting(
 	}
 
 	/* data/attr fork only */
-	ap->ip->i_d.di_nblocks += args->len;
+	ap->ip->i_nblocks += args->len;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= args->len;
@@ -4654,7 +4654,7 @@ xfs_bmapi_remap(
 		ASSERT(got.br_startoff - bno >= len);
 	}
 
-	ip->i_d.di_nblocks += len;
+	ip->i_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
@@ -5220,7 +5220,7 @@ xfs_bmap_del_extent_real(
 	 * Adjust inode # blocks in the file.
 	 */
 	if (nblks)
-		ip->i_d.di_nblocks -= nblks;
+		ip->i_nblocks -= nblks;
 	/*
 	 * Adjust quota data.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d9c63f17d2dec..9ad4c6a1eec51 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -260,7 +260,7 @@ xfs_bmbt_alloc_block(
 	ASSERT(args.len == 1);
 	cur->bc_tp->t_firstblock = args.fsbno;
 	cur->bc_ino.allocated++;
-	cur->bc_ino.ip->i_d.di_nblocks++;
+	cur->bc_ino.ip->i_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(args.tp, cur->bc_ino.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
@@ -287,7 +287,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
-	ip->i_d.di_nblocks--;
+	ip->i_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 897749c41f36e..55fadffb8752d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2139,7 +2139,7 @@ xfs_da_grow_inode_int(
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
-	xfs_rfsblock_t		nblks = dp->i_d.di_nblocks;
+	xfs_rfsblock_t		nblks = dp->i_nblocks;
 	struct xfs_bmbt_irec	map, *mapp;
 	int			nmap, error, got, i, mapi;
 
@@ -2205,7 +2205,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
-	args->total -= dp->i_d.di_nblocks - nblks;
+	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:
 	if (mapp != &map)
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c202de8bbdd42..d1a15778e86a3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -242,7 +242,7 @@ xfs_inode_from_disk(
 	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
 
 	ip->i_disk_size = be64_to_cpu(from->di_size);
-	to->di_nblocks = be64_to_cpu(from->di_nblocks);
+	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	to->di_extsize = be32_to_cpu(from->di_extsize);
 	to->di_forkoff = from->di_forkoff;
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
@@ -305,7 +305,7 @@ xfs_inode_to_disk(
 	to->di_mode = cpu_to_be16(inode->i_mode);
 
 	to->di_size = cpu_to_be64(ip->i_disk_size);
-	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f187127d50e01..a322e1adf0a34 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,6 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index d2029e12bda4d..391836dd4814e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -192,7 +192,7 @@ xfs_iformat_btree(
 		     nrecs == 0 ||
 		     XFS_BMDR_SPACE_CALC(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
-		     ifp->if_nextents > ip->i_d.di_nblocks) ||
+		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
 		xfs_warn(mp, "corrupt inode %Lu (btree).",
 					(unsigned long long) ip->i_ino);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d199ecddc1ab1..5eba039d72fb8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -154,7 +154,7 @@ xfs_bmap_rtalloc(
 		ap->blkno *= mp->m_sb.sb_rextsize;
 		ralen *= mp->m_sb.sb_rextsize;
 		ap->length = ralen;
-		ap->ip->i_d.di_nblocks += ralen;
+		ap->ip->i_nblocks += ralen;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
 			ap->ip->i_delayed_blks -= ralen;
@@ -1469,9 +1469,9 @@ xfs_swap_extent_forks(
 	/*
 	 * Fix the on-disk inode values
 	 */
-	tmp = (uint64_t)ip->i_d.di_nblocks;
-	ip->i_d.di_nblocks = tip->i_d.di_nblocks - taforkblks + aforkblks;
-	tip->i_d.di_nblocks = tmp + taforkblks - aforkblks;
+	tmp = (uint64_t)ip->i_nblocks;
+	ip->i_nblocks = tip->i_nblocks - taforkblks + aforkblks;
+	tip->i_nblocks = tmp + taforkblks - aforkblks;
 
 	/*
 	 * The extents in the source inode could still contain speculative
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cbab7852fbba4..e24f98712ee46 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -66,7 +66,7 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	ip->i_d.di_nblocks = 0;
+	ip->i_nblocks = 0;
 	ip->i_d.di_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
@@ -331,7 +331,7 @@ xfs_iget_check_free_state(
 			return -EFSCORRUPTED;
 		}
 
-		if (ip->i_d.di_nblocks != 0) {
+		if (ip->i_nblocks != 0) {
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
 				ip->i_ino);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0ec8f5773de7f..f893d732cc89a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -827,7 +827,7 @@ xfs_ialloc(
 
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
-	ASSERT(ip->i_d.di_nblocks == 0);
+	ASSERT(ip->i_nblocks == 0);
 
 	tv = current_time(inode);
 	inode->i_mtime = tv;
@@ -2728,7 +2728,7 @@ xfs_ifree(
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(ip->i_df.if_nextents == 0);
 	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
-	ASSERT(ip->i_d.di_nblocks == 0);
+	ASSERT(ip->i_nblocks == 0);
 
 	/*
 	 * Pull the on-disk inode from the AGI unlinked list.
@@ -3745,13 +3745,13 @@ xfs_iflush_int(
 		}
 	}
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
-				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
+				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %Lu, "
 			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
-			ip->i_d.di_nblocks, ip);
+			ip->i_nblocks, ip);
 		goto flush_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 61c41395536f0..828f49f109475 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -55,6 +55,7 @@ typedef struct xfs_inode {
 	unsigned long		i_flags;	/* see defined flags below */
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
 	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
+	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	uint32_t		i_projid;	/* owner's project id */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 179f1c2de6bd0..0980fa43472cf 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -324,7 +324,7 @@ xfs_inode_to_log_dinode(
 	to->di_mode = inode->i_mode;
 
 	to->di_size = ip->i_disk_size;
-	to->di_nblocks = from->di_nblocks;
+	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = from->di_extsize;
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1abee83d49cff..78159c57d8282 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -554,8 +554,7 @@ xfs_vn_getattr(
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
-	stat->blocks =
-		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
+	stat->blocks = XFS_FSB_TO_BB(mp, ip->i_nblocks + ip->i_delayed_blks);
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 9f92514301b33..7af144500bbfd 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -130,7 +130,7 @@ xfs_bulkstat_one_int(
 	case XFS_DINODE_FMT_BTREE:
 		buf->bs_rdev = 0;
 		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
+		buf->bs_blocks = ip->i_nblocks + ip->i_delayed_blks;
 		break;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec3222f71ae92..603b6928bd754 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -993,7 +993,7 @@ xfs_qm_reset_dqcounts_buf(
 	 * trans_reserve. But, this gets called during quotacheck, and that
 	 * happens only at mount time which is single threaded.
 	 */
-	if (qip->i_d.di_nblocks == 0)
+	if (qip->i_nblocks == 0)
 		return 0;
 
 	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
@@ -1175,7 +1175,7 @@ xfs_qm_dqusage_adjust(
 		xfs_bmap_count_leaves(ifp, &rtblks);
 	}
 
-	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
+	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1778,11 +1778,11 @@ xfs_qm_vop_chown(
 	ASSERT(prevdq);
 	ASSERT(prevdq != newdq);
 
-	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_d.di_nblocks));
+	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_nblocks));
 	xfs_trans_mod_dquot(tp, prevdq, XFS_TRANS_DQ_ICOUNT, -1);
 
 	/* the sparkling new dquot */
-	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
+	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_nblocks);
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
 	/*
@@ -1859,7 +1859,7 @@ xfs_qm_vop_chown_reserve(
 
 	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
 				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1,
+				ip->i_nblocks, 1,
 				flags | blkflags | prjflags);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index b5d10ecb54743..d0e8eceb93b66 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -35,7 +35,7 @@ xfs_qm_fill_state(
 		tempqip = true;
 	}
 	tstate->flags |= QCI_SYSFILE;
-	tstate->blocks = ip->i_d.di_nblocks;
+	tstate->blocks = ip->i_nblocks;
 	tstate->nextents = ip->i_df.if_nextents;
 	tstate->spc_timelimit = (u32)q->qi_btimelimit;
 	tstate->ino_timelimit = (u32)q->qi_itimelimit;
-- 
2.26.2

