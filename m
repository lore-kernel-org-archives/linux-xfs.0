Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11894C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B8961A1B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhCXOWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbhCXOV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD33C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=0ISq0OxAtX9PU+csZVmEwAO64HpPKFLQp3QbNAJZwEU=; b=rlH/Se8pYbZtTrShccGCZXwFZp
        PgMP6ueINFm5uO/G+omCvIWZ6m1fQe/dM5jGgj6UHsKOuA/fn7gbAJRZmRm2MiO8mO8Ev6YuvB6fh
        pnu9KhlDL36OzpIQJoIDkV++OykakfhVQtQZP+yNwcV4xQ9pZDG/+KiLP3QbCOUGS57tx6BuDQZYh
        0nemkXAStnB1ToQr2JVV3V6m+BddwnJGipdilKsYtdH3n0cMkoT9NwUVsYFW7Q7Mko656pQqt2ulb
        eFW6PXP5B1c0sZV0GOQCm+1xw8eLsglIueMv/7GUp8gwlDqv1YjZ2kK651rmePe1/7QMf6pgivcFG
        XN6jdD2g==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4OR-0045XQ-AU
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/18] xfs: move the di_nblocks field to struct xfs_inode
Date:   Wed, 24 Mar 2021 15:21:20 +0100
Message-Id: <20210324142129.1011766-10-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
 fs/xfs/xfs_qm.c                |  8 ++++----
 fs/xfs/xfs_quotaops.c          |  2 +-
 fs/xfs/xfs_trans.c             |  2 +-
 16 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f7da77a8c5bf9d..20c413a9b22ca9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -624,7 +624,7 @@ xfs_bmap_btree_to_extents(
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
-	ip->i_d.di_nblocks--;
+	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_bufs[0] == cbp)
@@ -726,7 +726,7 @@ xfs_bmap_extents_to_btree(
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
 	tp->t_firstblock = args.fsbno;
 	cur->bc_ino.allocated++;
-	ip->i_d.di_nblocks++;
+	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, args.fsbno),
@@ -908,7 +908,7 @@ xfs_bmap_local_to_extents(
 	xfs_iext_insert(ip, &icur, &rec, 0);
 
 	ifp->if_nextents = 1;
-	ip->i_d.di_nblocks = 1;
+	ip->i_nblocks = 1;
 	xfs_trans_mod_dquot_byino(tp, ip,
 		XFS_TRANS_DQ_BCOUNT, 1L);
 	flags |= xfs_ilog_fext(whichfork);
@@ -3444,7 +3444,7 @@ xfs_bmap_btalloc_accounting(
 	}
 
 	/* data/attr fork only */
-	ap->ip->i_d.di_nblocks += args->len;
+	ap->ip->i_nblocks += args->len;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= args->len;
@@ -4764,7 +4764,7 @@ xfs_bmapi_remap(
 		ASSERT(got.br_startoff - bno >= len);
 	}
 
-	ip->i_d.di_nblocks += len;
+	ip->i_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
@@ -5355,7 +5355,7 @@ xfs_bmap_del_extent_real(
 	 * Adjust inode # blocks in the file.
 	 */
 	if (nblks)
-		ip->i_d.di_nblocks -= nblks;
+		ip->i_nblocks -= nblks;
 	/*
 	 * Adjust quota data.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 976659190d2753..520db0c8f10a2d 100644
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
index e46bc03365db2d..83ac9771bfb581 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2145,7 +2145,7 @@ xfs_da_grow_inode_int(
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
-	xfs_rfsblock_t		nblks = dp->i_d.di_nblocks;
+	xfs_rfsblock_t		nblks = dp->i_nblocks;
 	struct xfs_bmbt_irec	map, *mapp;
 	int			nmap, error, got, i, mapi;
 
@@ -2211,7 +2211,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
-	args->total -= dp->i_d.di_nblocks - nblks;
+	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:
 	if (mapp != &map)
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 66a79e1dd26e88..b8c8ebf38d3f46 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -227,7 +227,7 @@ xfs_inode_from_disk(
 	inode->i_ctime = xfs_inode_from_disk_ts(from, from->di_ctime);
 
 	ip->i_disk_size = be64_to_cpu(from->di_size);
-	to->di_nblocks = be64_to_cpu(from->di_nblocks);
+	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	to->di_extsize = be32_to_cpu(from->di_extsize);
 	to->di_forkoff = from->di_forkoff;
 	to->di_flags	= be16_to_cpu(from->di_flags);
@@ -306,7 +306,7 @@ xfs_inode_to_disk(
 	to->di_mode = cpu_to_be16(inode->i_mode);
 
 	to->di_size = cpu_to_be64(ip->i_disk_size);
-	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index c93ed0bc5735e0..f4e1a9010b0a47 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,6 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 004252a2fad65a..589a4c835c6ac5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -194,7 +194,7 @@ xfs_iformat_btree(
 		     nrecs == 0 ||
 		     XFS_BMDR_SPACE_CALC(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
-		     ifp->if_nextents > ip->i_d.di_nblocks) ||
+		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
 		xfs_warn(mp, "corrupt inode %Lu (btree).",
 					(unsigned long long) ip->i_ino);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index eb99d6f1c5005d..ce1a32df01210e 100644
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
@@ -1476,9 +1476,9 @@ xfs_swap_extent_forks(
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
index d741ab2eee6849..d7952d5955ede5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -64,7 +64,7 @@ xfs_inode_alloc(
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
-	ip->i_d.di_nblocks = 0;
+	ip->i_nblocks = 0;
 	ip->i_d.di_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
@@ -309,7 +309,7 @@ xfs_iget_check_free_state(
 			return -EFSCORRUPTED;
 		}
 
-		if (ip->i_d.di_nblocks != 0) {
+		if (ip->i_nblocks != 0) {
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
 				ip->i_ino);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9946f6d7ff6488..c478b85a916f7b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -831,7 +831,7 @@ xfs_init_new_inode(
 
 	ip->i_disk_size = 0;
 	ip->i_df.if_nextents = 0;
-	ASSERT(ip->i_d.di_nblocks == 0);
+	ASSERT(ip->i_nblocks == 0);
 
 	tv = current_time(inode);
 	inode->i_mtime = tv;
@@ -2562,7 +2562,7 @@ xfs_ifree(
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(ip->i_df.if_nextents == 0);
 	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
-	ASSERT(ip->i_d.di_nblocks == 0);
+	ASSERT(ip->i_nblocks == 0);
 
 	/*
 	 * Pull the on-disk inode from the AGI unlinked list.
@@ -3412,13 +3412,13 @@ xfs_iflush(
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
index b11c7d6099191d..4fe208669540fe 100644
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
index e9b7853fb55ce0..07b68bd8fbb8da 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -370,7 +370,7 @@ xfs_inode_to_log_dinode(
 	to->di_mode = inode->i_mode;
 
 	to->di_size = ip->i_disk_size;
-	to->di_nblocks = from->di_nblocks;
+	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = from->di_extsize;
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0432bd9c5a0c75..7ce6e50ef6fc32 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -562,8 +562,7 @@ xfs_vn_getattr(
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
-	stat->blocks =
-		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
+	stat->blocks = XFS_FSB_TO_BB(mp, ip->i_nblocks + ip->i_delayed_blks);
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 21596fbb563eff..a94289fb5d61ee 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -132,7 +132,7 @@ xfs_bulkstat_one_int(
 	case XFS_DINODE_FMT_BTREE:
 		buf->bs_rdev = 0;
 		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
+		buf->bs_blocks = ip->i_nblocks + ip->i_delayed_blks;
 		break;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9599d40ff2ec49..7130a86ddd6578 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -992,7 +992,7 @@ xfs_qm_reset_dqcounts_buf(
 	 * trans_reserve. But, this gets called during quotacheck, and that
 	 * happens only at mount time which is single threaded.
 	 */
-	if (qip->i_d.di_nblocks == 0)
+	if (qip->i_nblocks == 0)
 		return 0;
 
 	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
@@ -1174,7 +1174,7 @@ xfs_qm_dqusage_adjust(
 		xfs_bmap_count_leaves(ifp, &rtblks);
 	}
 
-	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
+	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1779,11 +1779,11 @@ xfs_qm_vop_chown(
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
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index d27c0e852c0b0f..88d70c236a5445 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -35,7 +35,7 @@ xfs_qm_fill_state(
 		tempqip = true;
 	}
 	tstate->flags |= QCI_SYSFILE;
-	tstate->blocks = ip->i_d.di_nblocks;
+	tstate->blocks = ip->i_nblocks;
 	tstate->nextents = ip->i_df.if_nextents;
 	tstate->spc_timelimit = (u32)defq->blk.time;
 	tstate->ino_timelimit = (u32)defq->ino.time;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b22a09e9daeefd..1c5c720b4407b9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1197,7 +1197,7 @@ xfs_trans_alloc_ichange(
 		 * though that part is only semi-transactional.
 		 */
 		error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
-				pdqp, ip->i_d.di_nblocks + ip->i_delayed_blks,
+				pdqp, ip->i_nblocks + ip->i_delayed_blks,
 				1, qflags);
 		if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
 			xfs_trans_cancel(tp);
-- 
2.30.1

