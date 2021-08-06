Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9C6C4320A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECFE611C5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbhHFVXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239864AbhHFVXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ivoHi3gr1mOJlfI7FCUjafE/bV7R234d2NTAWy4CEg=;
        b=VHSVw5QbbamwYwMHCYFTNU/A1ZpxH34azczDE9T+ThcUTTjtKLDFo5tgGd5yfl4gPrCey0
        Bpj6hlwisrb6NUZLeNRu5RGKUFpi5/iTRgje5g0Q0BrG3Z1tzwpEpAI/iAvdeyEgHRZLk4
        8a1wjvUE23LIsxugwU5xMTJwIOAprfU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-1WAKcadNPEGNP_oMYnJSow-1; Fri, 06 Aug 2021 17:23:31 -0400
X-MC-Unique: 1WAKcadNPEGNP_oMYnJSow-1
Received: by mail-ej1-f69.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so3557803ejc.8
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ivoHi3gr1mOJlfI7FCUjafE/bV7R234d2NTAWy4CEg=;
        b=RDqjWgENy06PTqh7vRIDPpf/M+5F47FCRlY1PRV2b0WXxbefuK7fqlbUAcOgZoYKuP
         N81K1eUwT9V0wPKzXvfgg+U2ij1XOxV4NTl1E+61hj+kMnz64cr0VzxDzRtQ2L1uR4y1
         vQxQxOSOdDAwGRCwM5qjr5ORLGSOjIkEpCdMK003gxC7A7Q62UTE0eh/D8kdrB0FWOVI
         1QakjdLXXQVMZKnRGTqGo78oEFJ+UzjxnZvvxy/UetQZ1o0s61S5tGp0VIlimBvoqjgp
         w/CTg241nvC2+XQbxloz9bsoLuguPi93re7auKl3QQSRToeMK5L7VuF5Vrf527aTbx0c
         gN6g==
X-Gm-Message-State: AOAM533A5VAd1ECh3zYtQXswj8v9IQ0547b1CQgWjZQopFEDGRYOzfuv
        UgjafNFqtczSlwjrcU1UWjDT4rZicGGzcG9g9SUdIGongOnscNyHtK5PRYohFCHaFfbCju2zgHa
        9c9T5L6QOSWtfkkdh9JbdGGnDc9BoItqMmPwAhuyUXnopZEXCiOoCV/o3/VlAcEz3MdKlJro=
X-Received: by 2002:a05:6402:289b:: with SMTP id eg27mr15883893edb.90.1628285009618;
        Fri, 06 Aug 2021 14:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeJIiR6X2kYjSxO/VoM0nsE7LuG70OzQk5qwzAZa0eh+BhpFQ9kvjwH1+EnxdK5mJQ070rDA==
X-Received: by 2002:a05:6402:289b:: with SMTP id eg27mr15883870edb.90.1628285009315;
        Fri, 06 Aug 2021 14:23:29 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.28
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:28 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 06/29] xfsprogs: Stop using platform_uuid_copy()
Date:   Fri,  6 Aug 2021 23:22:55 +0200
Message-Id: <20210806212318.440144-7-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c             | 8 ++++----
 libxfs/libxfs_priv.h        | 1 -
 libxfs/xfs_ag.c             | 6 +++---
 libxfs/xfs_attr_leaf.c      | 2 +-
 libxfs/xfs_attr_remote.c    | 2 +-
 libxfs/xfs_btree.c          | 4 ++--
 libxfs/xfs_da_btree.c       | 2 +-
 libxfs/xfs_dir2_block.c     | 2 +-
 libxfs/xfs_dir2_data.c      | 2 +-
 libxfs/xfs_dir2_leaf.c      | 2 +-
 libxfs/xfs_dir2_node.c      | 2 +-
 libxfs/xfs_dquot_buf.c      | 2 +-
 libxfs/xfs_ialloc.c         | 4 ++--
 libxfs/xfs_inode_buf.c      | 2 +-
 libxfs/xfs_sb.c             | 6 +++---
 libxfs/xfs_symlink_remote.c | 2 +-
 mkfs/xfs_mkfs.c             | 6 +++---
 repair/agheader.c           | 8 ++++----
 repair/dinode.c             | 2 +-
 repair/phase5.c             | 6 +++---
 20 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index a7cbae02..1f57399a 100644
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
@@ -948,7 +948,7 @@ main(int argc, char **argv)
 		if (!duplicate)
 			platform_uuid_generate(&tcarg->uuid);
 		else
-			platform_uuid_copy(&tcarg->uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(tcarg->uuid, mp->m_sb.sb_uuid);
 
 		if (pthread_mutex_init(&tcarg->wait, NULL) != 0)  {
 			do_log(_("Error creating thread mutex %d\n"), i);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 782bb006..d4fd7bcd 100644
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
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f84a42f9..c4e3e054 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2192,7 +2192,7 @@ _("cowextsize not supported without reflink support\n"));
 	 */
 	cfg->sb_feat = cli->sb_feat;
 	if (!platform_uuid_is_null(&cli->uuid))
-		platform_uuid_copy(&cfg->uuid, &cli->uuid);
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
diff --git a/repair/agheader.c b/repair/agheader.c
index 1c4138e4..b13b7323 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -108,8 +108,8 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 		do_warn(_("bad uuid %s for agf %d\n"), uu, i);
 
 		if (!no_modify)
-			platform_uuid_copy(&agf->agf_uuid,
-					   &mp->m_sb.sb_meta_uuid);
+			uuid_copy(agf->agf_uuid,
+				   mp->m_sb.sb_meta_uuid);
 	}
 	return retval;
 }
@@ -187,8 +187,8 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
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

