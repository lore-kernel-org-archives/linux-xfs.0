Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54392C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiLaCi5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiLaCix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:38:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22082DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71CC161CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABB9C433D2;
        Sat, 31 Dec 2022 02:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454331;
        bh=vH6blYqox946kruNcp57vOlcDZLfgcxfA7k6IFmypg4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HsjQ+Xp/hITiYa0DhW1jh/JfES/bKuWn3fad1z8jKoqNOGqKOTAhUa3MR2G3fQT+f
         ApckbUieRHS06F+sxGHl8qrqnN5HwHTNi6Bvc+XbLfhFmP86rreOdgvNcK0wzIJOE9
         ztWRf0qdGie5Ahtj7dRocAvfQZcgTsI1R8nU00tSXWSNZOqBz3bTA7/oVdBMgdSB8D
         xgMTXmvWYWlP44umq/gM6nDpsuKX/o2GAgDbB+dlV8+DmUpg1VJ+I1ji42/Dme+r55
         ZMWSonIojmaerV6dwxZ+HpWxlESdmElXJVA2TAkMJokXlUtEh7PhJK6vW1WDs8kylF
         Rsjm/2hYRyeig==
Subject: [PATCH 34/45] xfs_db: dump rt summary blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878811.731133.9363750288930278535.stgit@magnolia>
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

Now that rtsummary blocks have a header, make it so that xfs_db can
analyze the structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/field.c   |    5 +++++
 db/field.h   |    3 +++
 db/inode.c   |    5 ++++-
 db/rtgroup.c |   20 ++++++++++++++++++++
 db/rtgroup.h |    3 +++
 db/type.c    |    5 +++++
 db/type.h    |    1 +
 7 files changed, 41 insertions(+), 1 deletion(-)


diff --git a/db/field.c b/db/field.c
index 7dee8c3735c..4a6a4cf51c3 100644
--- a/db/field.c
+++ b/db/field.c
@@ -397,6 +397,11 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_LE, NULL, NULL },
 	{ FLDT_RGBITMAP, "rgbitmap", NULL, (char *)rgbitmap_flds, btblock_size,
 	  FTARG_SIZE, NULL, rgbitmap_flds },
+	{ FLDT_SUMINFO, "suminfo", fp_num, "%u", SI(bitsz(xfs_suminfo_t)),
+	  0, NULL, NULL },
+	{ FLDT_RGSUMMARY, "rgsummary", NULL, (char *)rgsummary_flds,
+	  btblock_size, FTARG_SIZE, NULL, rgsummary_flds },
+
 	{ FLDT_ZZZ, NULL }
 };
 
diff --git a/db/field.h b/db/field.h
index ce7e7297afa..e9c6142f282 100644
--- a/db/field.h
+++ b/db/field.h
@@ -194,6 +194,9 @@ typedef enum fldt	{
 
 	FLDT_RTWORD,
 	FLDT_RGBITMAP,
+	FLDT_SUMINFO,
+	FLDT_RGSUMMARY,
+
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
 
diff --git a/db/inode.c b/db/inode.c
index 663487f8b14..0b9dc617ba9 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -646,8 +646,11 @@ inode_next_type(void)
 			if (xfs_has_rtgroups(mp))
 				return TYP_RGBITMAP;
 			return TYP_RTBITMAP;
-		} else if (iocur_top->ino == mp->m_sb.sb_rsumino)
+		} else if (iocur_top->ino == mp->m_sb.sb_rsumino) {
+			if (xfs_has_rtgroups(mp))
+				return TYP_RGSUMMARY;
 			return TYP_RTSUMMARY;
+		}
 		else if (iocur_top->ino == mp->m_sb.sb_uquotino ||
 			 iocur_top->ino == mp->m_sb.sb_gquotino ||
 			 iocur_top->ino == mp->m_sb.sb_pquotino)
diff --git a/db/rtgroup.c b/db/rtgroup.c
index 350677d4687..db1b9b595d5 100644
--- a/db/rtgroup.c
+++ b/db/rtgroup.c
@@ -147,3 +147,23 @@ const field_t	rgbitmap_hfld[] = {
 	{ "", FLDT_RGBITMAP, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
 };
+
+#define	OFF(f)	bitize(offsetof(struct xfs_rtbuf_blkinfo, rt_ ## f))
+const field_t	rgsummary_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	/* the suminfo array is after the actual structure */
+	{ "suminfo", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
+	  rtwords_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
+	{ NULL }
+};
+#undef OFF
+
+const field_t	rgsummary_hfld[] = {
+	{ "", FLDT_RGSUMMARY, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
diff --git a/db/rtgroup.h b/db/rtgroup.h
index 3c9b16146fc..2e85d3587fe 100644
--- a/db/rtgroup.h
+++ b/db/rtgroup.h
@@ -12,6 +12,9 @@ extern const struct field	rtsb_hfld[];
 extern const struct field	rgbitmap_flds[];
 extern const struct field	rgbitmap_hfld[];
 
+extern const struct field	rgsummary_flds[];
+extern const struct field	rgsummary_hfld[];
+
 extern void	rtsb_init(void);
 extern int	rtsb_size(void *obj, int startoff, int idx);
 
diff --git a/db/type.c b/db/type.c
index 65e7b24146f..2091b4ac8b1 100644
--- a/db/type.c
+++ b/db/type.c
@@ -68,6 +68,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_FINOBT, "finobt", handle_struct, finobt_hfld, NULL,
 		TYP_F_NO_CRC_OFF },
 	{ TYP_RGBITMAP, NULL },
+	{ TYP_RGSUMMARY, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -116,6 +117,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
+		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
@@ -164,6 +167,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
+		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index e2148c6351d..e7f0ecc1768 100644
--- a/db/type.h
+++ b/db/type.h
@@ -36,6 +36,7 @@ typedef enum typnm
 	TYP_TEXT,
 	TYP_FINOBT,
 	TYP_RGBITMAP,
+	TYP_RGSUMMARY,
 	TYP_NONE
 } typnm_t;
 

