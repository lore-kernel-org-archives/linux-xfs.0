Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832D6C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65D3D60EBB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhHBVuo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhHBVuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=spKTbDeH0Oe8em9YmGAL1NYnI03b6P0iCH+/D3pUack=;
        b=S+Leb82jHFZYzI+Ifb4YzSddefCBRwDRgZpGaUn1DHu3ShBdntNXS8a4OK2v0DrAQsbvyM
        ayp26xq62p6+7yQDKX8d9t9YKCZDEgCGoVXqHn9hj04TiUdJw0DCJZzYI/2H5TNCdTqVOs
        eXD90jfTUIKJWnvA16LrPXDxjJ/N53Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-xEMSE6gcPBuYC4mroBPMxg-1; Mon, 02 Aug 2021 17:50:32 -0400
X-MC-Unique: xEMSE6gcPBuYC4mroBPMxg-1
Received: by mail-wr1-f69.google.com with SMTP id q13-20020a05600000cdb02901545f1bdac1so3155940wrx.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=spKTbDeH0Oe8em9YmGAL1NYnI03b6P0iCH+/D3pUack=;
        b=gzBwHm1rQ0pHXDGC+wknu9pj1I7YiSlU3/QIwVhnXnSPhju/Xvlj59Ph/UTX3+Ihg2
         KR7o5lSk96URhwDA4WC5l2t/Q4/V63xiBbtYPYURrpoOBH4m8TyxyfiqffIKz4fCE/a2
         ZN8mCGKOde2xDOR1T6D94erE1QXKO6KxwSQHMNr70RAaXrRYuXfnB2yw23blELxSU+g6
         NCjAfj9CtpBsKK9RmjjGCqwXu2hqqeQTwV97WEc/UNun3Jj0ul3fwPxzsJNPZ7+hIQIX
         Kfa6U6zinuXcY4ekA+MeanayMp9vKxll2n5fkZJQIodPvhZzpbGHF7QfIRlqCxTjBXVd
         Xx1A==
X-Gm-Message-State: AOAM533f+2YHkg68qE2wGuFO0j/T0SSTM+sZhLwL8BZwYVbMoNhtqWCL
        H4JNxM2ysGhR04hpCYNnG9fLt871y6nVBxKeQjuPe0f+zEw+B/OjUduXeYV44F81J4J2bkrEdT7
        fI1WjCR5j1yFh4ijUiFT5OHQb0Hw5U3fo/SG5Idmt6YqC8std8bImJZ6NX9kzmWbzkqjtD3I=
X-Received: by 2002:adf:fc12:: with SMTP id i18mr19261339wrr.138.1627941031088;
        Mon, 02 Aug 2021 14:50:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvdvsina37Rmmap8LKF3aAmX3Vv0KGMUYn4PowpfrNRbdxDu4BGI4JtdFyQ89aEHDBPhHbQw==
X-Received: by 2002:adf:fc12:: with SMTP id i18mr19261320wrr.138.1627941030698;
        Mon, 02 Aug 2021 14:50:30 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.29
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:30 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfsprogs: remove all platform_ prefixes in linux.h
Date:   Mon,  2 Aug 2021 23:50:22 +0200
Message-Id: <20210802215024.949616-7-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c             | 10 +++++-----
 db/fprint.c                 |  2 +-
 db/sb.c                     | 12 ++++++------
 include/linux.h             | 30 ------------------------------
 libxfs/libxfs_priv.h        |  1 -
 libxfs/xfs_ag.c             |  6 +++---
 libxfs/xfs_attr_leaf.c      |  2 +-
 libxfs/xfs_attr_remote.c    |  2 +-
 libxfs/xfs_btree.c          |  4 ++--
 libxfs/xfs_da_btree.c       |  2 +-
 libxfs/xfs_dir2_block.c     |  2 +-
 libxfs/xfs_dir2_data.c      |  2 +-
 libxfs/xfs_dir2_leaf.c      |  2 +-
 libxfs/xfs_dir2_node.c      |  2 +-
 libxfs/xfs_dquot_buf.c      |  2 +-
 libxfs/xfs_ialloc.c         |  4 ++--
 libxfs/xfs_inode_buf.c      |  2 +-
 libxfs/xfs_sb.c             |  6 +++---
 libxfs/xfs_symlink_remote.c |  2 +-
 libxlog/util.c              |  6 +++---
 logprint/log_misc.c         |  2 +-
 mkfs/xfs_mkfs.c             | 12 ++++++------
 repair/agheader.c           | 12 ++++++------
 repair/dinode.c             |  2 +-
 repair/phase5.c             |  6 +++---
 25 files changed, 52 insertions(+), 83 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 4872621d..f06a1557 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -530,12 +530,12 @@ sb_update_uuid(
 		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
 		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
 		ag_hdr->xfs_sb->sb_features_incompat = cpu_to_be32(feat);
-		platform_uuid_copy(&ag_hdr->xfs_sb->sb_meta_uuid,
-				   &sb->sb_uuid);
+		uuid_copy(ag_hdr->xfs_sb->sb_meta_uuid,
+				   sb->sb_uuid);
 	}
 
 	/* Copy the (possibly new) fs-identifier UUID into sb_uuid */
-	platform_uuid_copy(&ag_hdr->xfs_sb->sb_uuid, &tcarg->uuid);
+	uuid_copy(ag_hdr->xfs_sb->sb_uuid, tcarg->uuid);
 
 	/* We may have changed the UUID, so update the superblock CRC */
 	if (xfs_sb_version_hascrc(sb))
@@ -946,9 +946,9 @@ main(int argc, char **argv)
 
 	for (i = 0, tcarg = targ; i < num_targets; i++, tcarg++)  {
 		if (!duplicate)
-			platform_uuid_generate(&tcarg->uuid);
+			uuid_generate(tcarg->uuid);
 		else
-			platform_uuid_copy(&tcarg->uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(tcarg->uuid, mp->m_sb.sb_uuid);
 
 		if (pthread_mutex_init(&tcarg->wait, NULL) != 0)  {
 			do_log(_("Error creating thread mutex %d\n"), i);
diff --git a/db/fprint.c b/db/fprint.c
index 65accfda..f2f42c28 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -273,7 +273,7 @@ fp_uuid(
 	     i++, p++) {
 		if (array)
 			dbprintf("%d:", i + base);
-		platform_uuid_unparse(p, bp);
+		uuid_unparse(*p, bp);
 		dbprintf("%s", bp);
 		if (i < count - 1)
 			dbprintf(" ");
diff --git a/db/sb.c b/db/sb.c
index 7017e1e5..63f43ea4 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -386,9 +386,9 @@ uuid_f(
 		}
 
 		if (!strcasecmp(argv[1], "generate")) {
-			platform_uuid_generate(&uu);
+			uuid_generate(uu);
 		} else if (!strcasecmp(argv[1], "nil")) {
-			platform_uuid_clear(&uu);
+			uuid_clear(uu);
 		} else if (!strcasecmp(argv[1], "rewrite")) {
 			uup = do_uuid(0, NULL);
 			if (!uup) {
@@ -396,7 +396,7 @@ uuid_f(
 				return 0;
 			}
 			memcpy(&uu, uup, sizeof(uuid_t));
-			platform_uuid_unparse(&uu, bp);
+			uuid_unparse(uu, bp);
 			dbprintf(_("old UUID = %s\n"), bp);
 		} else if (!strcasecmp(argv[1], "restore")) {
 			xfs_sb_t	tsb;
@@ -410,7 +410,7 @@ uuid_f(
 
 			memcpy(&uu, mp->m_sb.sb_meta_uuid, sizeof(uuid_t));
 		} else {
-			if (platform_uuid_parse(argv[1], &uu)) {
+			if (uuid_parse(argv[1], uu)) {
 				dbprintf(_("invalid UUID\n"));
 				return 0;
 			}
@@ -427,7 +427,7 @@ uuid_f(
 				break;
 			}
 
-		platform_uuid_unparse(&uu, bp);
+		uuid_unparse(uu, bp);
 		dbprintf(_("new UUID = %s\n"), bp);
 		return 0;
 
@@ -460,7 +460,7 @@ uuid_f(
 				 "for FS with an external log\n"));
 		}
 
-		platform_uuid_unparse(&uu, bp);
+		uuid_unparse(uu, bp);
 		dbprintf(_("UUID = %s\n"), bp);
 	}
 
diff --git a/include/linux.h b/include/linux.h
index 1905640f..a12ccee1 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -80,36 +80,6 @@ static __inline__ void getoptreset(void)
 	optind = 0;
 }
 
-static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
-{
-	uuid_unparse(*uu, buffer);
-}
-
-static __inline__ int platform_uuid_parse(const char *buffer, uuid_t *uu)
-{
-	return uuid_parse(buffer, *uu);
-}
-
-static __inline__ int platform_uuid_is_null(uuid_t *uu)
-{
-	return uuid_is_null(*uu);
-}
-
-static __inline__ void platform_uuid_generate(uuid_t *uu)
-{
-	uuid_generate(*uu);
-}
-
-static __inline__ void platform_uuid_clear(uuid_t *uu)
-{
-	uuid_clear(*uu);
-}
-
-static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	uuid_copy(*dst, *src);
-}
-
 #ifndef BLKDISCARD
 #define BLKDISCARD	_IO(0x12,119)
 #endif
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 22b4f606..454df465 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -504,7 +504,6 @@ static inline int retzero(void) { return 0; }
 #define xfs_quota_reserve_blkres(i,b)		(0)
 #define xfs_qm_dqattach(i)			(0)
 
-#define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(uuid_compare((*s),(*d)) == 0)
 
 #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index af8a0afd..7c70aa4c 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -268,7 +268,7 @@ xfs_agfblock_init(
 	agf->agf_freeblks = cpu_to_be32(tmpsize);
 	agf->agf_longest = cpu_to_be32(tmpsize);
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(agf->agf_uuid, mp->m_sb.sb_meta_uuid);
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		agf->agf_refcount_root = cpu_to_be32(
 				xfs_refc_block(mp));
@@ -298,7 +298,7 @@ xfs_agflblock_init(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(id->agno);
-		uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(agfl->agfl_uuid, mp->m_sb.sb_meta_uuid);
 	}
 
 	agfl_bno = xfs_buf_to_agfl_bno(bp);
@@ -326,7 +326,7 @@ xfs_agiblock_init(
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(agi->agi_uuid, mp->m_sb.sb_meta_uuid);
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
 		agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
 		agi->agi_free_level = cpu_to_be32(1);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a59660f2..70fa7b2f 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1272,7 +1272,7 @@ xfs_attr3_leaf_create(
 
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(hdr3->uuid, mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
 	} else {
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 3807cd3d..ed459290 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -251,7 +251,7 @@ xfs_attr3_rmt_hdr_set(
 	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
 	rmt->rm_offset = cpu_to_be32(offset);
 	rmt->rm_bytes = cpu_to_be32(size);
-	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid);
+	uuid_copy(rmt->rm_uuid, mp->m_sb.sb_meta_uuid);
 	rmt->rm_owner = cpu_to_be64(ino);
 	rmt->rm_blkno = cpu_to_be64(bno);
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index d52fdc00..59fb4223 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1097,7 +1097,7 @@ xfs_btree_init_block_int(
 		if (crc) {
 			buf->bb_u.l.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
-			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid);
+			uuid_copy(buf->bb_u.l.bb_uuid, mp->m_sb.sb_meta_uuid);
 			buf->bb_u.l.bb_pad = 0;
 			buf->bb_u.l.bb_lsn = 0;
 		}
@@ -1110,7 +1110,7 @@ xfs_btree_init_block_int(
 		if (crc) {
 			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
-			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid);
+			uuid_copy(buf->bb_u.s.bb_uuid, mp->m_sb.sb_meta_uuid);
 			buf->bb_u.s.bb_lsn = 0;
 		}
 	}
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 7448ee6c..8c3deca6 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -446,7 +446,7 @@ xfs_da3_node_create(
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
-		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(hdr3->info.uuid, mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
 	}
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index eaa2b47a..2ee95a4f 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -173,7 +173,7 @@ xfs_dir3_block_init(
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(hdr3->uuid, mp->m_sb.sb_meta_uuid);
 		return;
 
 	}
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index ddd5e885..c11b718b 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -721,7 +721,7 @@ xfs_dir3_data_init(
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(hdr3->uuid, mp->m_sb.sb_meta_uuid);
 
 	} else
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 0cecd698..25edf4c8 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -312,7 +312,7 @@ xfs_dir3_leaf_init(
 					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
 		leaf3->info.owner = cpu_to_be64(owner);
-		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(leaf3->info.uuid, mp->m_sb.sb_meta_uuid);
 	} else {
 		memset(leaf, 0, sizeof(*leaf));
 		leaf->hdr.info.magic = cpu_to_be16(type);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index ab156a8e..c1d4a18b 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -345,7 +345,7 @@ xfs_dir3_free_get_buf(
 
 		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(hdr3->hdr.uuid, mp->m_sb.sb_meta_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
 	xfs_dir2_free_hdr_to_disk(mp, bp->b_addr, &hdr);
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 0a5a237d..2f5fd03e 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -133,7 +133,7 @@ xfs_dqblk_repair(
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		uuid_copy(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(dqb->dd_uuid, mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c8e2125d..b42fe37a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -345,8 +345,8 @@ xfs_ialloc_inode_init(
 			if (version == 3) {
 				free->di_ino = cpu_to_be64(ino);
 				ino++;
-				uuid_copy(&free->di_uuid,
-					  &mp->m_sb.sb_meta_uuid);
+				uuid_copy(free->di_uuid,
+					  mp->m_sb.sb_meta_uuid);
 				xfs_dinode_calc_crc(mp, free);
 			} else if (tp) {
 				/* just log the inode core */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index c9bde7ee..c492d892 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -340,7 +340,7 @@ xfs_inode_to_disk(
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
+		uuid_copy(to->di_uuid, ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
 		to->di_version = 2;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 8037b369..cab092af 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -513,9 +513,9 @@ __xfs_sb_from_disk(
 	 * feature flag is set; if not set we keep it only in memory.
 	 */
 	if (xfs_sb_version_hasmetauuid(to))
-		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+		uuid_copy(to->sb_meta_uuid, from->sb_meta_uuid);
 	else
-		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
+		uuid_copy(to->sb_meta_uuid, from->sb_uuid);
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
@@ -658,7 +658,7 @@ xfs_sb_to_disk(
 		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
 		if (xfs_sb_version_hasmetauuid(from))
-			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+			uuid_copy(to->sb_meta_uuid, from->sb_meta_uuid);
 	}
 }
 
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 8eb3d59f..0e1f3596 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -46,7 +46,7 @@ xfs_symlink_hdr_set(
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
-	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid);
+	uuid_copy(dsl->sl_uuid, mp->m_sb.sb_meta_uuid);
 	dsl->sl_owner = cpu_to_be64(ino);
 	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
 	bp->b_ops = &xfs_symlink_buf_ops;
diff --git a/libxlog/util.c b/libxlog/util.c
index b4dfeca0..84c6f99a 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -79,8 +79,8 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
     if (!uuid_compare(mp->m_sb.sb_uuid, head->h_fs_uuid))
 		return 0;
 
-    platform_uuid_unparse(&mp->m_sb.sb_uuid, uu_sb);
-    platform_uuid_unparse(&head->h_fs_uuid, uu_log);
+    uuid_unparse(mp->m_sb.sb_uuid, uu_sb);
+    uuid_unparse(head->h_fs_uuid, uu_log);
 
     printf(_("* ERROR: mismatched uuid in log\n"
 	     "*            SB : %s\n*            log: %s\n"),
@@ -130,7 +130,7 @@ xlog_header_check_recover(xfs_mount_t *mp, xlog_rec_header_t *head)
 int
 xlog_header_check_mount(xfs_mount_t *mp, xlog_rec_header_t *head)
 {
-    if (platform_uuid_is_null(&head->h_fs_uuid)) return 0;
+    if (uuid_is_null(head->h_fs_uuid)) return 0;
     if (header_check_uuid(mp, head)) {
 	/* bail out now or just carry on regardless */
 	if (print_exit)
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index afcd2cee..c593c828 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1082,7 +1082,7 @@ xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
 	printf("\n");
     }
 
-    platform_uuid_unparse(&head->h_fs_uuid, uub);
+    uuid_unparse(head->h_fs_uuid, uub);
     printf(_("uuid: %s   format: "), uub);
     switch (be32_to_cpu(head->h_fmt)) {
 	case XLOG_FMT_UNKNOWN:
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f84a42f9..c6929a83 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1656,7 +1656,7 @@ meta_opts_parser(
 	case M_UUID:
 		if (!value || *value == '\0')
 			reqval('m', opts->subopts, subopt);
-		if (platform_uuid_parse(value, &cli->uuid))
+		if (uuid_parse(value, cli->uuid))
 			illegal(value, "m uuid");
 		break;
 	case M_RMAPBT:
@@ -2191,8 +2191,8 @@ _("cowextsize not supported without reflink support\n"));
 	 * Copy features across to config structure now.
 	 */
 	cfg->sb_feat = cli->sb_feat;
-	if (!platform_uuid_is_null(&cli->uuid))
-		platform_uuid_copy(&cfg->uuid, &cli->uuid);
+	if (!uuid_is_null(cli->uuid))
+		uuid_copy(cfg->uuid, cli->uuid);
 }
 
 static void
@@ -3452,9 +3452,9 @@ finish_superblock_setup(
 
 	sbp->sb_dblocks = cfg->dblocks;
 	sbp->sb_rextents = cfg->rtextents;
-	platform_uuid_copy(&sbp->sb_uuid, &cfg->uuid);
+	uuid_copy(sbp->sb_uuid, cfg->uuid);
 	/* Only in memory; libxfs expects this as if read from disk */
-	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
+	uuid_copy(sbp->sb_meta_uuid, cfg->uuid);
 	sbp->sb_logstart = cfg->logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
@@ -3859,7 +3859,7 @@ main(
 	struct list_head	buffer_list;
 	int			error;
 
-	platform_uuid_generate(&cli.uuid);
+	uuid_generate(cli.uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
diff --git a/repair/agheader.c b/repair/agheader.c
index 1c4138e4..7e596a66 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -104,12 +104,12 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 		char uu[64];
 
 		retval = XR_AG_AGF;
-		platform_uuid_unparse(&agf->agf_uuid, uu);
+		uuid_unparse(agf->agf_uuid, uu);
 		do_warn(_("bad uuid %s for agf %d\n"), uu, i);
 
 		if (!no_modify)
-			platform_uuid_copy(&agf->agf_uuid,
-					   &mp->m_sb.sb_meta_uuid);
+			uuid_copy(agf->agf_uuid,
+				   mp->m_sb.sb_meta_uuid);
 	}
 	return retval;
 }
@@ -183,12 +183,12 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 		char uu[64];
 
 		retval = XR_AG_AGI;
-		platform_uuid_unparse(&agi->agi_uuid, uu);
+		uuid_unparse(agi->agi_uuid, uu);
 		do_warn(_("bad uuid %s for agi %d\n"), uu, agno);
 
 		if (!no_modify)
-			platform_uuid_copy(&agi->agi_uuid,
-					   &mp->m_sb.sb_meta_uuid);
+			uuid_copy(agi->agi_uuid,
+					   mp->m_sb.sb_meta_uuid);
 	}
 
 	return retval;
diff --git a/repair/dinode.c b/repair/dinode.c
index a6156830..3206dd80 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -121,7 +121,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 	if (dinoc->di_version < 3)
 		return;
 	dinoc->di_ino = cpu_to_be64(ino_num);
-	platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid);
+	uuid_copy(dinoc->di_uuid, mp->m_sb.sb_meta_uuid);
 	return;
 }
 
diff --git a/repair/phase5.c b/repair/phase5.c
index fcdf757c..c98267a1 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -163,7 +163,7 @@ build_agi(
 		agi->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(agi->agi_uuid, mp->m_sb.sb_meta_uuid);
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
 		agi->agi_free_root =
@@ -312,7 +312,7 @@ build_agf_agfl(
 #endif
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(agf->agf_uuid, mp->m_sb.sb_meta_uuid);
 
 	/* initialise the AGFL, then fill it if there are blocks left over. */
 	error = -libxfs_buf_get(mp->m_dev,
@@ -330,7 +330,7 @@ build_agf_agfl(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
-		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(agfl->agfl_uuid, mp->m_sb.sb_meta_uuid);
 		for (agfl_idx = 0; agfl_idx < libxfs_agfl_size(mp); agfl_idx++)
 			freelist[agfl_idx] = cpu_to_be32(NULLAGBLOCK);
 	}
-- 
2.31.1

