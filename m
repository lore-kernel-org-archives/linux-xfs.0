Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24EDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357762AbiATAUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58248 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357760AbiATAUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AC2E6150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B2C004E1;
        Thu, 20 Jan 2022 00:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638030;
        bh=WvSJ2A/bUdHbRql1G/lzR/of/eKBec3ALRdnCOncu9E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D7HF3fkdXVKlBwHLULB+IpvI+jN9lrLjCqrgBJLMUx50jy7WdSI2Rs5Mhw/WH9Hfg
         hgJX308uZh+Wuojt2OfrDzBTQ901T1Eb9lmNog2TmvjvLHzobTL89MJhVspNR0twWn
         WEIi9tQh5mywQKrcZQ23zRoUAoDwRmhPe6CZ0pexmQWRwCtyzfj+OI/J00MDCerFZo
         AHW3YExisJNjHXwqOcHA0JeVKW6UaIqK5w6Osmk25lcxE3qZ1zl0/snxHg7qubW4s8
         fjqikRXPBCiB4svKXzr2p2UbEQPVOzZv5caEeUHvjTC0Lo99hkz9xwLWXMv2fQyPYM
         WEwFQpUUlqtSQ==
Subject: [PATCH 34/45] xfs_{copy,db,logprint,repair}: replace xfs_sb_version
 checks with feature flag checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:30 -0800
Message-ID: <164263803029.860211.854355789042037468.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c      |   19 ++++++++----------
 db/btblock.c         |    2 +-
 db/btdump.c          |    4 ++--
 db/check.c           |   18 ++++++++---------
 db/crc.c             |    2 +-
 db/frag.c            |    2 +-
 db/fsmap.c           |    2 +-
 db/fuzz.c            |    4 ++--
 db/init.c            |    6 +++---
 db/inode.c           |    6 +++---
 db/io.c              |    4 ++--
 db/logformat.c       |    4 ++--
 db/metadump.c        |   22 ++++++++++----------
 db/namei.c           |    2 +-
 db/sb.c              |   54 +++++++++++++++++++++++++-------------------------
 db/timelimit.c       |    2 +-
 db/write.c           |    4 ++--
 libxfs/init.c        |    4 ++--
 libxfs/rdwr.c        |    4 ++--
 libxfs/util.c        |   10 +++++----
 logprint/logprint.c  |    2 +-
 repair/agbtree.c     |   10 +++++----
 repair/agheader.c    |    6 +++---
 repair/attr_repair.c |    2 +-
 repair/dino_chunks.c |    2 +-
 repair/dinode.c      |   24 +++++++++++-----------
 repair/incore.h      |    4 ++--
 repair/incore_ino.c  |    2 +-
 repair/phase2.c      |   20 +++++++++----------
 repair/phase4.c      |    2 +-
 repair/phase5.c      |   30 ++++++++++++++--------------
 repair/phase6.c      |   14 ++++++-------
 repair/quotacheck.c  |    4 ++--
 repair/rmap.c        |   16 +++++++--------
 repair/scan.c        |   32 +++++++++++++++---------------
 repair/versions.c    |   18 ++++++++---------
 repair/xfs_repair.c  |    8 ++++---
 37 files changed, 185 insertions(+), 186 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 94faa6db..2642114f 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -526,8 +526,7 @@ sb_update_uuid(
 	 * we must copy the original sb_uuid to the sb_meta_uuid slot and set
 	 * the incompat flag for the feature on this copy.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_sb_version_hasmetauuid(&mp->m_sb) &&
+	if (xfs_has_crc(mp) && !xfs_has_metauuid(mp) &&
 	    !uuid_equal(&tcarg->uuid, &mp->m_sb.sb_uuid)) {
 		uint32_t feat;
 
@@ -542,7 +541,7 @@ sb_update_uuid(
 	platform_uuid_copy(&ag_hdr->xfs_sb->sb_uuid, &tcarg->uuid);
 
 	/* We may have changed the UUID, so update the superblock CRC */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		xfs_update_cksum((char *)ag_hdr->xfs_sb, mp->m_sb.sb_sectsize,
 				XFS_SB_CRC_OFF);
 }
@@ -1043,7 +1042,7 @@ main(int argc, char **argv)
 				  pos - btree_buf.position);
 
 			if (be32_to_cpu(block->bb_magic) !=
-			    (xfs_sb_version_hascrc(&mp->m_sb) ?
+			    (xfs_has_crc(mp) ?
 			     XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC)) {
 				do_log(_("Bad btree magic 0x%x\n"),
 				        be32_to_cpu(block->bb_magic));
@@ -1281,7 +1280,7 @@ write_log_header(int fd, wbuf *buf, xfs_mount_t *mp)
 	}
 
 	offset = libxfs_log_header(p, &buf->owner->uuid,
-			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
+			xfs_has_logv2(mp) ? 2 : 1,
 			mp->m_sb.sb_logsunit, XLOG_FMT, NULLCOMMITLSN,
 			NULLCOMMITLSN, next_log_chunk, buf);
 	do_write(buf->owner, NULL);
@@ -1366,7 +1365,7 @@ format_log(
 	 * all existing metadata LSNs are valid (behind the current LSN) on the
 	 * target fs.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cycle = mp->m_log->l_curr_cycle + 1;
 
 	/*
@@ -1374,7 +1373,7 @@ format_log(
 	 * write fails, mark the target inactive so the failure is reported.
 	 */
 	libxfs_log_clear(NULL, buf->data, logstart, length, &buf->owner->uuid,
-			 xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
+			 xfs_has_logv2(mp) ? 2 : 1,
 			 mp->m_sb.sb_logsunit, XLOG_FMT, cycle, true);
 	if (do_write(buf->owner, buf))
 		target[tcarg->id].state = INACTIVE;
@@ -1389,7 +1388,7 @@ format_logs(
 	wbuf			logbuf;
 	int			logsize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		logsize = XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks);
 		if (!wbuf_init(&logbuf, logsize, w_buf.data_align,
 			       w_buf.min_io_size, w_buf.id))
@@ -1397,14 +1396,14 @@ format_logs(
 	}
 
 	for (i = 0, tcarg = targ; i < num_targets; i++)  {
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			format_log(mp, tcarg, &logbuf);
 		else
 			clear_log(mp, tcarg);
 		tcarg++;
 	}
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		free(logbuf.data);
 
 	return 0;
diff --git a/db/btblock.c b/db/btblock.c
index e57d5f46..24c65669 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -120,7 +120,7 @@ block_to_bt(
 	}
 
 	/* Magic is invalid/unknown.  Guess based on iocur type */
-	crc = xfs_sb_version_hascrc(&mp->m_sb);
+	crc = xfs_has_crc(mp);
 	switch (iocur_top->typ->typnm) {
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
diff --git a/db/btdump.c b/db/btdump.c
index 920f595b..cb9ca082 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -159,7 +159,7 @@ dump_inode(
 
 	if (attrfork)
 		prefix = "a.bmbt";
-	else if (xfs_sb_version_hascrc(&mp->m_sb))
+	else if (xfs_has_crc(mp))
 		prefix = "u3.bmbt";
 	else
 		prefix = "u.bmbt";
@@ -448,7 +448,7 @@ btdump_f(
 {
 	bool		aflag = false;
 	bool		iflag = false;
-	bool		crc = xfs_sb_version_hascrc(&mp->m_sb);
+	bool		crc = xfs_has_crc(mp);
 	int		c;
 
 	if (cur_typ == NULL) {
diff --git a/db/check.c b/db/check.c
index 485e855e..a078e948 100644
--- a/db/check.c
+++ b/db/check.c
@@ -891,21 +891,21 @@ blockget_f(
 		error++;
 	}
 	if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
-					!xfs_sb_version_hasattr(&mp->m_sb)) {
+					!xfs_has_attr(mp)) {
 		if (!sflag)
 			dbprintf(_("sb versionnum missing attr bit %x\n"),
 				XFS_SB_VERSION_ATTRBIT);
 		error++;
 	}
 	if ((sbversion & XFS_SB_VERSION_QUOTABIT) &&
-					!xfs_sb_version_hasquota(&mp->m_sb)) {
+					!xfs_has_quota(mp)) {
 		if (!sflag)
 			dbprintf(_("sb versionnum missing quota bit %x\n"),
 				XFS_SB_VERSION_QUOTABIT);
 		error++;
 	}
 	if (!(sbversion & XFS_SB_VERSION_ALIGNBIT) &&
-					xfs_sb_version_hasalign(&mp->m_sb)) {
+					xfs_has_align(mp)) {
 		if (!sflag)
 			dbprintf(_("sb versionnum extra align bit %x\n"),
 				XFS_SB_VERSION_ALIGNBIT);
@@ -1628,7 +1628,7 @@ static bool
 is_reflink(
 	dbm_t		type2)
 {
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return false;
 	if (type2 == DBM_DATA || type2 == DBM_RLDATA)
 		return true;
@@ -1988,7 +1988,7 @@ init(
 	 * at least one full inode record per block. Check this case explicitly.
 	 */
 	if (mp->m_sb.sb_inoalignmt ||
-	    (xfs_sb_version_hasalign(&mp->m_sb) &&
+	    (xfs_has_align(mp) &&
 	     mp->m_sb.sb_inopblock >= XFS_INODES_PER_CHUNK))
 		sbversion |= XFS_SB_VERSION_ALIGNBIT;
 	if ((mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO) ||
@@ -2814,7 +2814,7 @@ process_inode(
 	uid = be32_to_cpu(dip->di_uid);
 	gid = be32_to_cpu(dip->di_gid);
 	diflags = be16_to_cpu(dip->di_flags);
-	if (xfs_sb_version_has_v3inode(&mp->m_sb))
+	if (xfs_has_v3inodes(mp))
 		diflags2 = be64_to_cpu(dip->di_flags2);
 	if (isfree) {
 		if (be64_to_cpu(dip->di_nblocks) != 0) {
@@ -4497,7 +4497,7 @@ scanfunc_ino(
 	int			ioff;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		blks_per_buf = igeo->blocks_per_cluster;
 	else
 		blks_per_buf = igeo->ialloc_blks;
@@ -4586,7 +4586,7 @@ scanfunc_ino(
 				ioff += inodes_per_buf;
 			}
 
-			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+			if (xfs_has_sparseinodes(mp))
 				freecount = rp[i].ir_u.sp.ir_freecount;
 			else
 				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
@@ -4641,7 +4641,7 @@ scanfunc_fino(
 	int			ioff;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		blks_per_buf = igeo->blocks_per_cluster;
 	else
 		blks_per_buf = igeo->ialloc_blks;
diff --git a/db/crc.c b/db/crc.c
index b23417a1..7428b916 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -29,7 +29,7 @@ static const cmdinfo_t crc_cmd =
 void
 crc_init(void)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		add_command(&crc_cmd);
 }
 
diff --git a/db/frag.c b/db/frag.c
index cc00672e..9bc63614 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -474,7 +474,7 @@ scanfunc_ino(
 	int			ioff;
 	struct xfs_ino_geometry *igeo = M_IGEO(mp);
 
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		blks_per_buf = igeo->blocks_per_cluster;
 	else
 		blks_per_buf = igeo->ialloc_blks;
diff --git a/db/fsmap.c b/db/fsmap.c
index d30b832c..8e130f5b 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -112,7 +112,7 @@ fsmap_f(
 	xfs_fsblock_t		start_fsb = 0;
 	xfs_fsblock_t		end_fsb = NULLFSBLOCK;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (!xfs_has_rmapbt(mp)) {
 		dbprintf(_("Filesystem does not support reverse mapping btree.\n"));
 		return 0;
 	}
diff --git a/db/fuzz.c b/db/fuzz.c
index 65157bd0..ba64bad7 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -116,7 +116,7 @@ fuzz_f(
 
 	if (invalid_data &&
 	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
-	    xfs_sb_version_hascrc(&mp->m_sb)) {
+	    xfs_has_crc(mp)) {
 		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
 		return 0;
 	}
@@ -140,7 +140,7 @@ fuzz_f(
 	local_ops.verify_read = stashed_ops->verify_read;
 	iocur_top->bp->b_ops = &local_ops;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		local_ops.verify_write = xfs_dummy_verify;
 	} else if (corrupt) {
 		local_ops.verify_write = xfs_dummy_verify;
diff --git a/db/init.c b/db/init.c
index 19f0900a..eec65d08 100644
--- a/db/init.c
+++ b/db/init.c
@@ -152,7 +152,7 @@ init(
 	 * xfs_check needs corrected incore superblock values
 	 */
 	if (sbp->sb_rootino != NULLFSINO &&
-	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+	    xfs_has_lazysbcount(mp)) {
 		int error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
 		if (error) {
 			fprintf(stderr,
@@ -161,9 +161,9 @@ init(
 		}
 	}
 
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		type_set_tab_spcrc();
-	else if (xfs_sb_version_hascrc(&mp->m_sb))
+	else if (xfs_has_crc(mp))
 		type_set_tab_crc();
 
 	push_cur();
diff --git a/db/inode.c b/db/inode.c
index 3453c089..22bc63a8 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -560,7 +560,7 @@ inode_u_sfdir2_count(
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
 	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR &&
-	       !xfs_sb_version_hasftype(&mp->m_sb);
+	       !xfs_has_ftype(mp);
 }
 
 static int
@@ -576,7 +576,7 @@ inode_u_sfdir3_count(
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
 	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR &&
-	       xfs_sb_version_hasftype(&mp->m_sb);
+	       xfs_has_ftype(mp);
 }
 
 int
@@ -691,7 +691,7 @@ set_cur_inode(
 	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
 		iocur_top->dirino = ino;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		iocur_top->ino_crc_ok = libxfs_verify_cksum((char *)dip,
 						    mp->m_sb.sb_inodesize,
 						    XFS_DINODE_CRC_OFF);
diff --git a/db/io.c b/db/io.c
index c79cf105..98f4e605 100644
--- a/db/io.c
+++ b/db/io.c
@@ -477,7 +477,7 @@ write_cur(void)
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	if (!xfs_has_crc(mp) ||
 	    !iocur_top->bp->b_ops ||
 	    iocur_top->bp->b_ops->verify_write == xfs_dummy_verify)
 		skip_crc = true;
@@ -494,7 +494,7 @@ write_cur(void)
 		write_cur_buf();
 
 	/* If we didn't write the crc automatically, re-check inode validity */
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    skip_crc && iocur_top->ino_buf) {
 		iocur_top->ino_crc_ok = libxfs_verify_cksum(iocur_top->data,
 						mp->m_sb.sb_inodesize,
diff --git a/db/logformat.c b/db/logformat.c
index 3374c29b..38b0af11 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -24,7 +24,7 @@ logformat_f(int argc, char **argv)
 	int		error;
 	int		c;
 
-	logversion = xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1;
+	logversion = xfs_has_logv2(mp) ? 2 : 1;
 
 	while ((c = getopt(argc, argv, "c:s:")) != EOF) {
 		switch (c) {
@@ -64,7 +64,7 @@ logformat_f(int argc, char **argv)
 	mp->m_log->l_logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	mp->m_log->l_logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	mp->m_log->l_sectBBsize = BBSIZE;
-	if (xfs_sb_version_hassector(&mp->m_sb))
+	if (xfs_has_sector(mp))
 		mp->m_log->l_sectBBsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 	mp->m_log->l_sectBBsize = BTOBB(mp->m_log->l_sectBBsize);
 
diff --git a/db/metadump.c b/db/metadump.c
index 96b098b0..2c649c15 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -574,7 +574,7 @@ copy_rmap_btree(
 	xfs_agblock_t	root;
 	int		levels;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 1;
 
 	root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
@@ -646,7 +646,7 @@ copy_refcount_btree(
 	xfs_agblock_t	root;
 	int		levels;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 1;
 
 	root = be32_to_cpu(agf->agf_refcount_root);
@@ -1536,13 +1536,13 @@ process_dir_data_block(
 			blp = (xfs_dir2_leaf_entry_t *)btp;
 
 		end_of_data = (char *)blp - block;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			wantmagic = XFS_DIR3_BLOCK_MAGIC;
 		else
 			wantmagic = XFS_DIR2_BLOCK_MAGIC;
 	} else { /* leaf/node format */
 		end_of_data = mp->m_dir_geo->fsbcount << mp->m_sb.sb_blocklog;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			wantmagic = XFS_DIR3_DATA_MAGIC;
 		else
 			wantmagic = XFS_DIR2_DATA_MAGIC;
@@ -1664,7 +1664,7 @@ process_symlink_block(
 	}
 	link = iocur_top->data;
 
-	if (xfs_sb_version_hascrc(&(mp)->m_sb))
+	if (xfs_has_crc((mp)))
 		link += sizeof(struct xfs_dsymlink_hdr);
 
 	if (obfuscate)
@@ -1675,7 +1675,7 @@ process_symlink_block(
 
 		linklen = strlen(link);
 		zlen = mp->m_sb.sb_blocksize - linklen;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			zlen -= sizeof(struct xfs_dsymlink_hdr);
 		if (zlen < mp->m_sb.sb_blocksize)
 			memset(link + linklen, 0, zlen);
@@ -2476,7 +2476,7 @@ copy_inode_chunk(
 	 * Also make sure that that we don't process more than the single record
 	 * we've been passed (large block sizes can hold multiple inode chunks).
 	 */
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		blks_per_buf = igeo->blocks_per_cluster;
 	else
 		blks_per_buf = igeo->ialloc_blks;
@@ -2509,7 +2509,7 @@ copy_inode_chunk(
 	if ((mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK && off != 0) ||
 			(mp->m_sb.sb_inopblock > XFS_INODES_PER_CHUNK &&
 					off % XFS_INODES_PER_CHUNK != 0) ||
-			(xfs_sb_version_hasalign(&mp->m_sb) &&
+			(xfs_has_align(mp) &&
 					mp->m_sb.sb_inoalignmt != 0 &&
 					agbno % mp->m_sb.sb_inoalignmt != 0)) {
 		if (show_warnings)
@@ -2660,7 +2660,7 @@ copy_inodes(
 	if (!scan_btree(agno, root, levels, TYP_INOBT, &finobt, scanfunc_ino))
 		return 0;
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		root = be32_to_cpu(agi->agi_free_root);
 		levels = be32_to_cpu(agi->agi_free_level);
 
@@ -2891,8 +2891,8 @@ copy_log(void)
 
 		logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 		logblocks = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-		logversion = xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		logversion = xfs_has_logv2(mp) ? 2 : 1;
+		if (xfs_has_crc(mp))
 			cycle = log.l_curr_cycle + 1;
 
 		libxfs_log_clear(NULL, iocur_top->data, logstart, logblocks,
diff --git a/db/namei.c b/db/namei.c
index 4e2047b2..e44667a9 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -231,7 +231,7 @@ get_dstr(
 	struct xfs_mount	*mp,
 	uint8_t			filetype)
 {
-	if (!xfs_sb_version_hasftype(&mp->m_sb))
+	if (!xfs_has_ftype(mp))
 		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
 
 	if (filetype >= XFS_DIR3_FT_MAX)
diff --git a/db/sb.c b/db/sb.c
index 94001943..7510e00f 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -266,7 +266,7 @@ sb_logzero(uuid_t *uuidp)
 	 * The log must always move forward on v5 superblocks. Bump it to the
 	 * next cycle.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cycle = mp->m_log->l_curr_cycle + 1;
 
 	dbprintf(_("Clearing log and setting UUID\n"));
@@ -275,7 +275,7 @@ sb_logzero(uuid_t *uuidp)
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			uuidp,
-			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
+			xfs_has_logv2(mp) ? 2 : 1,
 			mp->m_sb.sb_logsunit, XLOG_FMT, cycle, true);
 	if (error) {
 		dbprintf(_("ERROR: cannot clear the log\n"));
@@ -652,57 +652,57 @@ version_string(
 	 * We assume the state of these features now, so macros don't exist for
 	 * them any more.
 	 */
-	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)
+	if (xfs_has_nlink(mp))
 		strcat(s, ",NLINK");
 	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_SHAREDBIT)
 		strcat(s, ",SHARED");
 	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT)
 		strcat(s, ",DIRV2");
 
-	if (xfs_sb_version_hasattr(&mp->m_sb))
+	if (xfs_has_attr(mp))
 		strcat(s, ",ATTR");
-	if (xfs_sb_version_hasquota(&mp->m_sb))
+	if (xfs_has_quota(mp))
 		strcat(s, ",QUOTA");
-	if (xfs_sb_version_hasalign(&mp->m_sb))
+	if (xfs_has_align(mp))
 		strcat(s, ",ALIGN");
-	if (xfs_sb_version_hasdalign(&mp->m_sb))
+	if (xfs_has_dalign(mp))
 		strcat(s, ",DALIGN");
-	if (xfs_sb_version_haslogv2(&mp->m_sb))
+	if (xfs_has_logv2(mp))
 		strcat(s, ",LOGV2");
 	/* This feature is required now as well */
-	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_EXTFLGBIT)
+	if (xfs_has_extflg(mp))
 		strcat(s, ",EXTFLG");
-	if (xfs_sb_version_hassector(&mp->m_sb))
+	if (xfs_has_sector(mp))
 		strcat(s, ",SECTOR");
-	if (xfs_sb_version_hasasciici(&mp->m_sb))
+	if (xfs_has_asciici(mp))
 		strcat(s, ",ASCII_CI");
-	if (xfs_sb_version_hasmorebits(&mp->m_sb))
+	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_MOREBITSBIT)
 		strcat(s, ",MOREBITS");
-	if (xfs_sb_version_hasattr2(&mp->m_sb))
+	if (xfs_has_attr2(mp))
 		strcat(s, ",ATTR2");
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+	if (xfs_has_lazysbcount(mp))
 		strcat(s, ",LAZYSBCOUNT");
-	if (xfs_sb_version_hasprojid32(&mp->m_sb))
+	if (xfs_has_projid32(mp))
 		strcat(s, ",PROJID32BIT");
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		strcat(s, ",CRC");
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		strcat(s, ",FTYPE");
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		strcat(s, ",FINOBT");
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		strcat(s, ",SPARSE_INODES");
-	if (xfs_sb_version_hasmetauuid(&mp->m_sb))
+	if (xfs_has_metauuid(mp))
 		strcat(s, ",META_UUID");
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		strcat(s, ",RMAPBT");
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		strcat(s, ",REFLINK");
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+	if (xfs_has_inobtcounts(mp))
 		strcat(s, ",INOBTCNT");
-	if (xfs_sb_version_hasbigtime(&mp->m_sb))
+	if (xfs_has_bigtime(mp))
 		strcat(s, ",BIGTIME");
-	if (xfs_sb_version_needsrepair(&mp->m_sb))
+	if (xfs_has_needsrepair(mp))
 		strcat(s, ",NEEDSREPAIR");
 	return s;
 }
@@ -769,7 +769,7 @@ version_f(
 				version = 0x0034 | XFS_SB_VERSION_LOGV2BIT;
 				break;
 			case XFS_SB_VERSION_4:
-				if (xfs_sb_version_haslogv2(&mp->m_sb))
+				if (xfs_has_logv2(mp))
 					dbprintf(
 		_("version 2 log format is already in use\n"));
 				else
@@ -788,7 +788,7 @@ version_f(
 			return 0;
 		} else if (!strcasecmp(argv[1], "attr1")) {
 
-			if (xfs_sb_version_hasattr2(&mp->m_sb)) {
+			if (xfs_has_attr2(mp)) {
 				if (!(mp->m_sb.sb_features2 &=
 						~XFS_SB_VERSION2_ATTR2BIT))
 					mp->m_sb.sb_versionnum &=
diff --git a/db/timelimit.c b/db/timelimit.c
index 53a0a399..7b61e980 100644
--- a/db/timelimit.c
+++ b/db/timelimit.c
@@ -113,7 +113,7 @@ timelimit_f(
 	}
 
 	if (whatkind == SHOW_AUTO) {
-		if (xfs_sb_version_hasbigtime(&mp->m_sb))
+		if (xfs_has_bigtime(mp))
 			whatkind = SHOW_BIGTIME;
 		else
 			whatkind = SHOW_CLASSIC;
diff --git a/db/write.c b/db/write.c
index 0592a099..70cb0518 100644
--- a/db/write.c
+++ b/db/write.c
@@ -127,7 +127,7 @@ write_f(
 
 	if (invalid_data &&
 	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
-	    xfs_sb_version_hascrc(&mp->m_sb)) {
+	    xfs_has_crc(mp)) {
 		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
 		return 0;
 	}
@@ -151,7 +151,7 @@ write_f(
 	local_ops.verify_read = stashed_ops->verify_read;
 	iocur_top->bp->b_ops = &local_ops;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		local_ops.verify_write = xfs_dummy_verify;
 	} else if (corrupt) {
 		local_ops.verify_write = xfs_dummy_verify;
diff --git a/libxfs/init.c b/libxfs/init.c
index 8fe2f963..ee49aeb8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -743,7 +743,7 @@ libxfs_mount(
 	/*
 	 * Set whether we're using stripe alignment.
 	 */
-	if (xfs_sb_version_hasdalign(&mp->m_sb)) {
+	if (xfs_has_dalign(mp)) {
 		mp->m_dalign = sbp->sb_unit;
 		mp->m_swidth = sbp->sb_width;
 	}
@@ -796,7 +796,7 @@ libxfs_mount(
 
 	xfs_da_mount(mp);
 
-	if (xfs_sb_version_hasattr2(&mp->m_sb))
+	if (xfs_has_attr2(mp))
 		mp->m_flags |= LIBXFS_MOUNT_ATTR2;
 
 	/* Initialize the precomputed transaction reservations values */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index a5fd0596..5086bdbc 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1019,7 +1019,7 @@ xfs_verify_magic(
 	struct xfs_mount	*mp = bp->b_mount;
 	int			idx;
 
-	idx = xfs_sb_version_hascrc(&mp->m_sb);
+	idx = xfs_has_crc(mp);
 	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx])))
 		return false;
 	return dmagic == bp->b_ops->magic[idx];
@@ -1038,7 +1038,7 @@ xfs_verify_magic16(
 	struct xfs_mount	*mp = bp->b_mount;
 	int			idx;
 
-	idx = xfs_sb_version_hascrc(&mp->m_sb);
+	idx = xfs_has_crc(mp);
 	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx])))
 		return false;
 	return dmagic == bp->b_ops->magic16[idx];
diff --git a/libxfs/util.c b/libxfs/util.c
index 905f1784..9c8230cd 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -44,7 +44,7 @@ xfs_log_calc_unit_res(
 	int			iclog_size;
 	uint			num_headers;
 
-	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+	if (xfs_has_logv2(mp)) {
 		iclog_size = XLOG_MAX_RECORD_BSIZE;
 		iclog_header_size = BBTOB(iclog_size / XLOG_HEADER_CYCLE_SIZE);
 	} else {
@@ -125,7 +125,7 @@ xfs_log_calc_unit_res(
 	unit_bytes += iclog_header_size;
 
 	/* for roundoff padding for transaction data and one for commit record */
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1) {
 		/* log su roundoff */
 		unit_bytes += 2 * mp->m_sb.sb_logsunit;
 	} else {
@@ -226,7 +226,7 @@ xfs_inode_propagate_flags(
 		}
 	} else {
 		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
+		    xfs_has_realtime(ip->i_mount))
 			di_flags |= XFS_DIFLAG_REALTIME;
 		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSIZE;
@@ -282,7 +282,7 @@ libxfs_init_new_inode(
 	ip->i_extsize = pip ? 0 : fsx->fsx_extsize;
 	ip->i_diflags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
 
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = pip ? ip->i_mount->m_ino_geo.new_diflags2 :
 				xfs_flags2diflags2(ip, fsx->fsx_xflags);
@@ -360,7 +360,7 @@ libxfs_iflush_int(
 	ASSERT(ip->i_forkoff <= mp->m_sb.sb_inodesize);
 
 	/* bump the change count on v3 inodes */
-	if (xfs_sb_version_has_v3inode(&mp->m_sb))
+	if (xfs_has_v3inodes(mp))
 		VFS_I(ip)->i_version++;
 
 	/*
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 430961ff..3514d013 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -86,7 +86,7 @@ logstat(xfs_mount_t *mp)
 		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
 		x.logBBstart = XFS_FSB_TO_DADDR(mp, sb->sb_logstart);
 		x.lbsize = BBSIZE;
-		if (xfs_sb_version_hassector(&mp->m_sb))
+		if (xfs_has_sector(mp))
 			x.lbsize <<= (sb->sb_logsectlog - BBSHIFT);
 
 		if (!x.logname && sb->sb_logstart == 0) {
diff --git a/repair/agbtree.c b/repair/agbtree.c
index f20dc9ba..0fd7ef5d 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -401,7 +401,7 @@ get_inobt_record(
 	irec->ir_count = inocnt;
 	irec->ir_freecount = finocnt;
 
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		uint64_t		sparse;
 		int			spmask;
 		uint16_t		holemask;
@@ -452,7 +452,7 @@ init_ino_cursors(
 	bool			finobt;
 	int			error;
 
-	finobt = xfs_sb_version_hasfinobt(&sc->mp->m_sb);
+	finobt = xfs_has_finobt(sc->mp);
 	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_ino);
 
 	/* Compute inode statistics. */
@@ -543,7 +543,7 @@ _("Error %d while creating inobt btree for AG %u.\n"), error, agno);
 	/* Since we're not writing the AGI yet, no need to commit the cursor */
 	libxfs_btree_del_cursor(btr_ino->cur, 0);
 
-	if (!xfs_sb_version_hasfinobt(&sc->mp->m_sb))
+	if (!xfs_has_finobt(sc->mp))
 		return;
 
 	/* Add all observed finobt records. */
@@ -583,7 +583,7 @@ init_rmapbt_cursor(
 	xfs_agnumber_t		agno = pag->pag_agno;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb))
+	if (!xfs_has_rmapbt(sc->mp))
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
@@ -654,7 +654,7 @@ init_refc_cursor(
 	xfs_agnumber_t		agno = pag->pag_agno;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb))
+	if (!xfs_has_reflink(sc->mp))
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, free_space, btr);
diff --git a/repair/agheader.c b/repair/agheader.c
index fc62c03a..d8f912f2 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -97,7 +97,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 
 	/* don't check freespace btrees -- will be checked by caller */
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return retval;
 
 	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid)) {
@@ -176,7 +176,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 
 	/* don't check inode btree -- will be checked by caller */
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return retval;
 
 	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid)) {
@@ -376,7 +376,7 @@ secondary_sb_whack(
 	 * superblocks. If it is anything other than 0 it is considered garbage
 	 * data beyond the valid sb and explicitly zeroed above.
 	 */
-	if (xfs_sb_version_haspquotino(&mp->m_sb) &&
+	if (xfs_has_pquotino(mp) &&
 	    sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
 		if (!no_modify) {
 			sb->sb_pquotino = 0;
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index bc3c2bef..df1b519f 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -393,7 +393,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 	int		hdrsize = 0;
 	int		error;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		hdrsize = sizeof(struct xfs_attr3_rmt_hdr);
 
 	/* ASSUMPTION: valuelen is a valid number, so use it for looping */
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index c87a435d..6d494f2d 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -628,7 +628,7 @@ process_inode_chunk(
 	if (cluster_count == 0)
 		cluster_count = 1;
 
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	if (xfs_has_sparseinodes(mp) &&
 	    M_IGEO(mp)->inodes_per_cluster >= XFS_INODES_PER_HOLEMASK_BIT)
 		can_punch_sparse = true;
 
diff --git a/repair/dinode.c b/repair/dinode.c
index f39ab2dc..3a79e18e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -110,7 +110,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 {
 	memset(dinoc, 0, sizeof(*dinoc));
 	dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		dinoc->di_version = 3;
 	else
 		dinoc->di_version = 2;
@@ -556,7 +556,7 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				if (type == XR_INO_DATA &&
-				    xfs_sb_version_hasreflink(&mp->m_sb))
+				    xfs_has_reflink(mp))
 					break;
 				do_warn(
 _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
@@ -725,7 +725,7 @@ get_agino_buf(
 	}
 
 	*dipp = xfs_make_iptr(mp, bp, agino - cluster_agino);
-	ASSERT(!xfs_sb_version_hascrc(&mp->m_sb) ||
+	ASSERT(!xfs_has_crc(mp) ||
 			XFS_AGINO_TO_INO(mp, agno, agino) ==
 			be64_to_cpu((*dipp)->di_ino));
 	return bp;
@@ -771,7 +771,7 @@ process_btinode(
 	*tot = 0;
 	*nex = 0;
 
-	magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_BMAP_CRC_MAGIC
+	magic = xfs_has_crc(mp) ? XFS_BMAP_CRC_MAGIC
 						 : XFS_BMAP_MAGIC;
 
 	level = be16_to_cpu(dib->bb_level);
@@ -1164,7 +1164,7 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
 			int		bad_dqb = 0;
 
 			/* We only print the first problem we find */
-			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			if (xfs_has_crc(mp)) {
 				if (!libxfs_verify_cksum((char *)dqb,
 							sizeof(*dqb),
 							XFS_DQUOT_CRC_OFF)) {
@@ -1288,7 +1288,7 @@ _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
 		byte_cnt = min(pathlen, byte_cnt);
 
 		src = bp->b_addr;
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			if (!libxfs_symlink_hdr_ok(lino, offset,
 						   byte_cnt, bp)) {
 				do_warn(
@@ -2297,7 +2297,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * Of course if we make any modifications after this, the inode gets
 	 * rewritten, and the CRC is updated automagically.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !libxfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
 				XFS_DINODE_CRC_OFF)) {
 		retval = 1;
@@ -2339,7 +2339,7 @@ process_dinode_int(xfs_mount_t *mp,
 			if (!no_modify) {
 				do_warn(_(" resetting version number\n"));
 				dino->di_version =
-					xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
+					xfs_has_crc(mp) ? 3 : 2;
 				*dirty = 1;
 			} else
 				do_warn(_(" would reset version number\n"));
@@ -2368,7 +2368,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * we are called here that the inode has not already been modified in
 	 * memory and hence invalidated the CRC.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (be64_to_cpu(dino->di_ino) != lino) {
 			if (!uncertain)
 				do_warn(
@@ -2573,7 +2573,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
-		    !xfs_sb_version_hasreflink(&mp->m_sb)) {
+		    !xfs_has_reflink(mp)) {
 			if (!uncertain) {
 				do_warn(
 	_("inode %" PRIu64 " is marked reflinked but file system does not support reflink\n"),
@@ -2605,7 +2605,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-		    !xfs_sb_version_hasreflink(&mp->m_sb)) {
+		    !xfs_has_reflink(mp)) {
 			if (!uncertain) {
 				do_warn(
 	_("inode %" PRIu64 " has CoW extent size hint but file system does not support reflink\n"),
@@ -2637,7 +2637,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if (xfs_dinode_has_bigtime(dino) &&
-		    !xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		    !xfs_has_bigtime(mp)) {
 			if (!uncertain) {
 				do_warn(
 	_("inode %" PRIu64 " is marked bigtime but file system does not support large timestamps\n"),
diff --git a/repair/incore.h b/repair/incore.h
index d64315fd..65c03dde 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -647,7 +647,7 @@ inorec_get_freecount(
 	struct xfs_mount	*mp,
 	struct xfs_inobt_rec	*rp)
 {
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		return rp->ir_u.sp.ir_freecount;
 	return be32_to_cpu(rp->ir_u.f.ir_freecount);
 }
@@ -658,7 +658,7 @@ inorec_set_freecount(
 	struct xfs_inobt_rec	*rp,
 	int			freecount)
 {
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		rp->ir_u.sp.ir_freecount = freecount;
 	else
 		rp->ir_u.f.ir_freecount = cpu_to_be32(freecount);
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 299e4f94..0dd7a2f0 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -211,7 +211,7 @@ alloc_ftypes_array(
 {
 	uint8_t		*ptr;
 
-	if (!xfs_sb_version_hasftype(&mp->m_sb))
+	if (!xfs_has_ftype(mp))
 		return NULL;
 
 	ptr = calloc(XFS_INODES_PER_CHUNK, sizeof(*ptr));
diff --git a/repair/phase2.c b/repair/phase2.c
index f13f785b..bda834de 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -34,7 +34,7 @@ zero_log(
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	x.lbsize = BBSIZE;
-	if (xfs_sb_version_hassector(&mp->m_sb))
+	if (xfs_has_sector(mp))
 		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
 	log->l_dev = mp->m_logdev_targp;
@@ -42,13 +42,13 @@ zero_log(
 	log->l_logBBstart = x.logBBstart;
 	log->l_sectBBsize  = BTOBB(x.lbsize);
 	log->l_mp = mp;
-	if (xfs_sb_version_hassector(&mp->m_sb)) {
+	if (xfs_has_sector(mp)) {
 		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
 		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
 		/* for larger sector sizes, must have v2 or external log */
 		ASSERT(log->l_sectbb_log == 0 ||
 			log->l_logBBstart == 0 ||
-			xfs_sb_version_haslogv2(&mp->m_sb));
+			xfs_has_logv2(mp));
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
 	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
@@ -111,7 +111,7 @@ zero_log(
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			&mp->m_sb.sb_uuid,
-			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
+			xfs_has_logv2(mp) ? 2 : 1,
 			mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE, true);
 
 		/* update the log data structure with new state */
@@ -127,7 +127,7 @@ zero_log(
 	 * Finally, seed the max LSN from the current state of the log if this
 	 * is a v5 filesystem.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		libxfs_max_lsn = atomic64_read(&log->l_last_sync_lsn);
 }
 
@@ -135,19 +135,19 @@ static bool
 set_inobtcount(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		printf(
 	_("Inode btree count feature only supported on V5 filesystems.\n"));
 		exit(0);
 	}
 
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (!xfs_has_finobt(mp)) {
 		printf(
 	_("Inode btree count feature requires free inode btree.\n"));
 		exit(0);
 	}
 
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+	if (xfs_has_inobtcounts(mp)) {
 		printf(_("Filesystem already has inode btree counts.\n"));
 		exit(0);
 	}
@@ -162,13 +162,13 @@ static bool
 set_bigtime(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		printf(
 	_("Large timestamp feature only supported on V5 filesystems.\n"));
 		exit(0);
 	}
 
-	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+	if (xfs_has_bigtime(mp)) {
 		printf(_("Filesystem already supports large timestamps.\n"));
 		exit(0);
 	}
diff --git a/repair/phase4.c b/repair/phase4.c
index eb043002..2260f6a3 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -240,7 +240,7 @@ process_rmap_data(
 		queue_work(&wq, check_rmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return;
 
 	create_work_queue(&wq, mp, platform_nproc());
diff --git a/repair/phase5.c b/repair/phase5.c
index 79a8dbc2..74b1dcb9 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -162,17 +162,17 @@ build_agi(
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
 		agi->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		agi->agi_free_root =
 				cpu_to_be32(btr_fino->newbt.afake.af_root);
 		agi->agi_free_level =
 				cpu_to_be32(btr_fino->newbt.afake.af_levels);
 	}
 
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+	if (xfs_has_inobtcounts(mp)) {
 		agi->agi_iblocks = cpu_to_be32(btr_ino->newbt.afake.af_blocks);
 		agi->agi_fblocks = cpu_to_be32(btr_fino->newbt.afake.af_blocks);
 	}
@@ -265,7 +265,7 @@ build_agf_agfl(
 			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
 	agf->agf_freeblks = cpu_to_be32(btr_bno->freeblks);
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		agf->agf_roots[XFS_BTNUM_RMAP] =
 				cpu_to_be32(btr_rmap->newbt.afake.af_root);
 		agf->agf_levels[XFS_BTNUM_RMAP] =
@@ -274,7 +274,7 @@ build_agf_agfl(
 				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		agf->agf_refcount_root =
 				cpu_to_be32(btr_refc->newbt.afake.af_root);
 		agf->agf_refcount_level =
@@ -286,7 +286,7 @@ build_agf_agfl(
 	/*
 	 * Count and record the number of btree blocks consumed if required.
 	 */
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+	if (xfs_has_lazysbcount(mp)) {
 		unsigned int blks;
 		/*
 		 * Don't count the root blocks as they are already
@@ -294,7 +294,7 @@ build_agf_agfl(
 		 */
 		blks = btr_bno->newbt.afake.af_blocks +
 			btr_cnt->newbt.afake.af_blocks - 2;
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		if (xfs_has_rmapbt(mp))
 			blks += btr_rmap->newbt.afake.af_blocks - 1;
 		agf->agf_btreeblks = cpu_to_be32(blks);
 #ifdef XR_BLD_FREE_TRACE
@@ -311,7 +311,7 @@ build_agf_agfl(
 			XFS_BTNUM_CNT);
 #endif
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* initialise the AGFL, then fill it if there are blocks left over. */
@@ -327,7 +327,7 @@ build_agf_agfl(
 	/* setting to 0xff results in initialisation to NULLAGBLOCK */
 	memset(agfl, 0xff, mp->m_sb.sb_sectsize);
 	freelist = xfs_buf_to_agfl_bno(agfl_buf);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
 		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
@@ -340,7 +340,7 @@ build_agf_agfl(
 	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 	fill_agfl(btr_bno, freelist, &agfl_idx);
 	fill_agfl(btr_cnt, freelist, &agfl_idx);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		fill_agfl(btr_rmap, freelist, &agfl_idx);
 
 	/* Set the AGF counters for the AGFL. */
@@ -538,12 +538,12 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 #endif
 	ASSERT(btr_bno.freeblks == btr_cnt.freeblks);
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		build_rmap_tree(&sc, agno, &btr_rmap);
 		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		build_refcount_tree(&sc, agno, &btr_refc);
 
 	/*
@@ -563,11 +563,11 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	finish_rebuild(mp, &btr_bno, lost_blocks);
 	finish_rebuild(mp, &btr_cnt, lost_blocks);
 	finish_rebuild(mp, &btr_ino, lost_blocks);
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		finish_rebuild(mp, &btr_fino, lost_blocks);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		finish_rebuild(mp, &btr_rmap, lost_blocks);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		finish_rebuild(mp, &btr_refc, lost_blocks);
 
 	/*
diff --git a/repair/phase6.c b/repair/phase6.c
index 696a6427..647dc1c5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -505,7 +505,7 @@ mk_rbmino(xfs_mount_t *mp)
 	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
@@ -745,7 +745,7 @@ mk_rsumino(xfs_mount_t *mp)
 	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
@@ -844,7 +844,7 @@ mk_root_dir(xfs_mount_t *mp)
 	set_nlink(VFS_I(ip), 2);	/* account for . and .. */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
@@ -1474,13 +1474,13 @@ longform_dir2_entry_check_data(
 		endptr = (char *)blp;
 		if (endptr > (char *)btp)
 			endptr = (char *)btp;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			wantmagic = XFS_DIR3_BLOCK_MAGIC;
 		else
 			wantmagic = XFS_DIR2_BLOCK_MAGIC;
 	} else {
 		endptr = (char *)d + mp->m_dir_geo->blksize;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			wantmagic = XFS_DIR3_DATA_MAGIC;
 		else
 			wantmagic = XFS_DIR2_DATA_MAGIC;
@@ -1787,7 +1787,7 @@ longform_dir2_entry_check_data(
 			continue;
 
 		/* validate ftype field if supported */
-		if (xfs_sb_version_hasftype(&mp->m_sb)) {
+		if (xfs_has_ftype(mp)) {
 			uint8_t dir_ftype;
 			uint8_t ino_ftype;
 
@@ -2684,7 +2684,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 		}
 
 		/* validate ftype field if supported */
-		if (xfs_sb_version_hasftype(&mp->m_sb)) {
+		if (xfs_has_ftype(mp)) {
 			uint8_t dir_ftype;
 			uint8_t ino_ftype;
 
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 5e007a18..758160d3 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -252,7 +252,7 @@ qc_dquot_check_type(
 	 * expect an exact match for user dquots and for non-root group and
 	 * project dquots.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb) || type == XFS_DQTYPE_USER || id)
+	if (xfs_has_crc(mp) || type == XFS_DQTYPE_USER || id)
 		return ddq_type == type;
 
 	/*
@@ -325,7 +325,7 @@ qc_check_dquot(
 	}
 
 	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
-	    !xfs_sb_version_hasbigtime(&mp->m_sb)) {
+	    !xfs_has_bigtime(mp)) {
 		do_warn(
 	_("%s id %u is marked bigtime but file system does not support large timestamps\n"),
 				qflags_typestr(dquots->type), id);
diff --git a/repair/rmap.c b/repair/rmap.c
index 12fe7442..e48f6c1e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -49,8 +49,8 @@ bool
 rmap_needs_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_sb_version_hasreflink(&mp->m_sb) ||
-	       xfs_sb_version_hasrmapbt(&mp->m_sb);
+	return xfs_has_reflink(mp) ||
+	       xfs_has_rmapbt(mp);
 }
 
 /*
@@ -387,7 +387,7 @@ rmap_add_fixed_ag_rec(
 	/* inodes */
 	ino_rec = findfirst_inode_rec(agno);
 	for (; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec)) {
-		if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+		if (xfs_has_sparseinodes(mp)) {
 			startidx = find_first_zero_bit(ino_rec->ir_sparse);
 			nr = XFS_INODES_PER_CHUNK - popcnt(ino_rec->ir_sparse);
 		} else {
@@ -455,7 +455,7 @@ rmap_store_ag_btree_rec(
 	struct bitmap		*own_ag_bitmap = NULL;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	/* Release the ar_rmaps; they were put into the rmapbt during p5. */
@@ -761,7 +761,7 @@ compute_refcounts(
 	size_t			old_stack_nr;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	rmaps = ag_rmaps[agno].ar_rmaps;
@@ -988,7 +988,7 @@ rmaps_verify_btree(
 	int			have;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (rmapbt_suspect) {
 		if (no_modify && agno == 0)
@@ -1025,7 +1025,7 @@ rmaps_verify_btree(
 		 * the regular lookup doesn't find anything or if it doesn't
 		 * match the observed rmap.
 		 */
-		if (xfs_sb_version_hasreflink(&bt_cur->bc_mp->m_sb) &&
+		if (xfs_has_reflink(bt_cur->bc_mp) &&
 				(!have || !rmap_is_good(rm_rec, &tmp))) {
 			error = rmap_lookup_overlapped(bt_cur, rm_rec,
 					&tmp, &have);
@@ -1350,7 +1350,7 @@ check_refcounts(
 	int				i;
 	int				error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 	if (refcbt_suspect) {
 		if (no_modify && agno == 0)
diff --git a/repair/scan.c b/repair/scan.c
index 52de8a04..909c4494 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -806,7 +806,7 @@ ino_issparse(
 	struct xfs_inobt_rec	*rp,
 	int			offset)
 {
-	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (!xfs_has_sparseinodes(mp))
 		return false;
 
 	return xfs_inobt_is_sparse_disk(rp, offset);
@@ -908,7 +908,7 @@ _("in use block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
 		 * multiple inode owners are ok with
 		 * reflink enabled
 		 */
-		if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+		if (xfs_has_reflink(mp) &&
 		    !XFS_RMAP_NON_INODE_OWNER(owner))
 			break;
 		fallthrough;
@@ -1125,7 +1125,7 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			} else {
 				bool bad;
 
-				if (xfs_sb_version_hasreflink(&mp->m_sb))
+				if (xfs_has_reflink(mp))
 					bad = !rmap_in_order(b, laststartblock,
 							owner, lastowner,
 							offset, lastoffset);
@@ -1762,7 +1762,7 @@ _("ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
 	}
 
 	/* verify sparse record formats have a valid inode count */
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	if (xfs_has_sparseinodes(mp) &&
 	    ninodes != rp->ir_u.sp.ir_count) {
 		do_warn(
 _("invalid inode count, inode chunk %d/%u, count %d ninodes %d\n"),
@@ -1938,7 +1938,7 @@ _("finobt record with no free inodes, inode chunk %d/%u\n"), agno, ino);
 	}
 
 	/* verify sparse record formats have a valid inode count */
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	if (xfs_has_sparseinodes(mp) &&
 	    ninodes != rp->ir_u.sp.ir_count) {
 		do_warn(
 _("invalid inode count, inode chunk %d/%u, count %d ninodes %d\n"),
@@ -2104,7 +2104,7 @@ _("%sbt btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				 * ir_count holds the inode count for all
 				 * records on fs' with sparse inode support
 				 */
-				if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+				if (xfs_has_sparseinodes(mp))
 					icount = rp[i].ir_u.sp.ir_count;
 
 				agcnts->agicount += icount;
@@ -2264,7 +2264,7 @@ validate_agf(
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
-		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_ABTB_CRC_MAGIC
+		magic = xfs_has_crc(mp) ? XFS_ABTB_CRC_MAGIC
 							 : XFS_ABTB_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
 			    agno, 0, scan_allocbt, 1, magic, agcnts,
@@ -2276,7 +2276,7 @@ validate_agf(
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
-		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_ABTC_CRC_MAGIC
+		magic = xfs_has_crc(mp) ? XFS_ABTC_CRC_MAGIC
 							 : XFS_ABTC_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
 			    agno, 0, scan_allocbt, 1, magic, agcnts,
@@ -2286,7 +2286,7 @@ validate_agf(
 			bno, agno);
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		struct rmap_priv	priv;
 		unsigned int		levels;
 
@@ -2319,7 +2319,7 @@ validate_agf(
 		}
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		unsigned int	levels;
 
 		levels = be32_to_cpu(agf->agf_refcount_level);
@@ -2358,7 +2358,7 @@ validate_agf(
 			be32_to_cpu(agf->agf_longest), agcnts->agflongest, agno);
 	}
 
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	if (xfs_has_lazysbcount(mp) &&
 	    be32_to_cpu(agf->agf_btreeblks) != agcnts->agfbtreeblks) {
 		do_warn(_("agf_btreeblks %u, counted %" PRIu64 " in ag %u\n"),
 			be32_to_cpu(agf->agf_btreeblks), agcnts->agfbtreeblks, agno);
@@ -2381,7 +2381,7 @@ validate_agi(
 
 	bno = be32_to_cpu(agi->agi_root);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
-		magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_IBT_CRC_MAGIC
+		magic = xfs_has_crc(mp) ? XFS_IBT_CRC_MAGIC
 							 : XFS_IBT_MAGIC;
 		scan_sbtree(bno, be32_to_cpu(agi->agi_level),
 			    agno, 0, scan_inobt, 1, magic, &priv,
@@ -2391,10 +2391,10 @@ validate_agi(
 			be32_to_cpu(agi->agi_root), agno);
 	}
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		bno = be32_to_cpu(agi->agi_free_root);
 		if (libxfs_verify_agbno(mp, agno, bno)) {
-			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
+			magic = xfs_has_crc(mp) ?
 					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
 			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),
 				    agno, 0, scan_inobt, 1, magic, &priv,
@@ -2405,7 +2405,7 @@ validate_agi(
 		}
 	}
 
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+	if (xfs_has_inobtcounts(mp)) {
 		if (be32_to_cpu(agi->agi_iblocks) != priv.ino_blocks)
 			do_warn(_("bad inobt block count %u, saw %u\n"),
 					be32_to_cpu(agi->agi_iblocks),
@@ -2426,7 +2426,7 @@ validate_agi(
 			be32_to_cpu(agi->agi_freecount), agcnts->agifreecount, agno);
 	}
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	if (xfs_has_finobt(mp) &&
 	    be32_to_cpu(agi->agi_freecount) != agcnts->fibtfreecount) {
 		do_warn(_("agi_freecount %u, counted %u in ag %u finobt\n"),
 			be32_to_cpu(agi->agi_freecount), agcnts->fibtfreecount,
diff --git a/repair/versions.c b/repair/versions.c
index 0b5376d7..b24965b2 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -33,10 +33,10 @@ void
 update_sb_version(
 	struct xfs_mount	*mp)
 {
-	if (fs_attributes && !xfs_sb_version_hasattr(&mp->m_sb))
+	if (fs_attributes && !xfs_has_attr(mp))
 		xfs_sb_version_addattr(&mp->m_sb);
 
-	if (fs_attributes2 && !xfs_sb_version_hasattr2(&mp->m_sb))
+	if (fs_attributes2 && !xfs_has_attr2(mp))
 		xfs_sb_version_addattr2(&mp->m_sb);
 
 	/* V2 inode conversion is now always going to happen */
@@ -49,7 +49,7 @@ update_sb_version(
 	 * have quotas.
 	 */
 	if (fs_quotas)  {
-		if (!xfs_sb_version_hasquota(&mp->m_sb))
+		if (!xfs_has_quota(mp))
 			xfs_sb_version_addquota(&mp->m_sb);
 
 		/*
@@ -74,13 +74,13 @@ update_sb_version(
 	} else  {
 		mp->m_sb.sb_qflags = 0;
 
-		if (xfs_sb_version_hasquota(&mp->m_sb))  {
+		if (xfs_has_quota(mp))  {
 			lost_quotas = 1;
 			mp->m_sb.sb_versionnum &= ~XFS_SB_VERSION_QUOTABIT;
 		}
 	}
 
-	if (!fs_aligned_inodes && xfs_sb_version_hasalign(&mp->m_sb))
+	if (!fs_aligned_inodes && xfs_has_align(mp))
 		mp->m_sb.sb_versionnum &= ~XFS_SB_VERSION_ALIGNBIT;
 
 	mp->m_features &= ~(XFS_FEAT_QUOTA | XFS_FEAT_ALIGN);
@@ -142,10 +142,10 @@ _("Superblock has unknown compat/rocompat/incompat features (0x%x/0x%x/0x%x).\n"
 		return 1;
 	}
 
-	if (xfs_sb_version_hasattr(&mp->m_sb))
+	if (xfs_has_attr(mp))
 		fs_attributes = 1;
 
-	if (xfs_sb_version_hasattr2(&mp->m_sb))
+	if (xfs_has_attr2(mp))
 		fs_attributes2 = 1;
 
 	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
@@ -162,7 +162,7 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 		}
 	}
 
-	if (xfs_sb_version_hasquota(&mp->m_sb))  {
+	if (xfs_has_quota(mp))  {
 		fs_quotas = 1;
 
 		if (mp->m_sb.sb_uquotino != 0 && mp->m_sb.sb_uquotino != NULLFSINO)
@@ -175,7 +175,7 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 			have_pquotino = 1;
 	}
 
-	if (xfs_sb_version_hasalign(&mp->m_sb))  {
+	if (xfs_has_align(mp))  {
 		fs_aligned_inodes = 1;
 		fs_ino_alignment = mp->m_sb.sb_inoalignmt;
 	}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 7a142ceb..abde6fe8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -640,7 +640,7 @@ format_log_max_lsn(
 	xfs_daddr_t		logblocks;
 	int			logversion;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	/*
@@ -660,7 +660,7 @@ format_log_max_lsn(
 	new_cycle = max_cycle + 3;
 	logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	logblocks = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-	logversion = xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1;
+	logversion = xfs_has_logv2(mp) ? 2 : 1;
 
 	do_warn(_("Maximum metadata LSN (%d:%d) is ahead of log (%d:%d).\n"),
 		max_cycle, max_block, log->l_curr_cycle, log->l_curr_block);
@@ -793,7 +793,7 @@ force_needsrepair(
 	struct xfs_buf		*bp;
 	int			error;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	if (!xfs_has_crc(mp) ||
 	    xfs_sb_version_needsrepair(&mp->m_sb))
 		return;
 
@@ -982,7 +982,7 @@ main(int argc, char **argv)
 		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
 
 	/* Capture the first writeback so that we can set needsrepair. */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		mp->m_buf_writeback_fn = repair_capture_writeback;
 
 	/*

