Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37C8C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbiLMTjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiLMTjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:39:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C952205D8
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 11:39:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CDB2616F0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 19:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBB1C433EF;
        Tue, 13 Dec 2022 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960389;
        bh=fCwQ10lXSWM3E2sn6qHBLEFCvAmyHSmxFZxRbZ4PV2U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dr4ZPknKSYAcEbgk9lrNSjSeIUhUvu4L7ZabraJF8c9HTodEVOrTmY5ALqUgE7fYv
         XiMAz1h9CNz/WjT0Ue1VVbBQG88wIfI/6EZ9BFYeHpA64UtVOAzk3ise2Q3Ri5tV5e
         wYt5bu+5Tk5zVcbR4AJKbgneZph1BvpMU4xaZqpWWdXHmLFRFy8ybZv02OQMU27UiN
         5TF1fFBBfPA6/3QWlw0Lv+RNvfMztM8ItePWBR2lfkXYBmtHhe8Jz4+NyJU2h8n1B2
         lF34HIb+56Roc9nxtQOz97VRD3wbD34nApmj0RSvMAooAjEy6LJ41ahJfmONpdkYEi
         wYcIu6YalIuRQ==
Subject: [PATCH 2/2] xfs_db: create separate struct and field definitions for
 finobts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 13 Dec 2022 11:39:48 -0800
Message-ID: <167096038863.1739636.8534584165287590294.stgit@magnolia>
In-Reply-To: <167096037742.1739636.10785934352963408920.stgit@magnolia>
References: <167096037742.1739636.10785934352963408920.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create separate field_t definitions for the free inode btree because db
needs to know that the interior block pointers point to finobt blocks,
not inobt blocks.  This is critical now because the buffer ops contain
magic numbers, the ->verify_struct routines use the magics listed in the
buffer ops, and the xfs_db iocursor calls the verifier functions.

Without this patch, xfs_db emits bizarre output like this:

# xfs_db -x /dev/sde -c 'agi 1' -c 'addr free_root' -c 'addr ptrs[1]' -c print 2>&1 | head
Metadata corruption detected at 0x55dda21258b0, xfs_inobt block 0x275c20/0x1000
magic = 0x46494233

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btblock.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/btblock.h |    6 +++++
 db/field.c   |    8 +++++++
 db/field.h   |    4 +++
 db/type.c    |    6 ++---
 5 files changed, 91 insertions(+), 3 deletions(-)


diff --git a/db/btblock.c b/db/btblock.c
index c563fb0389a..30f7b5ef955 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -491,6 +491,76 @@ const field_t	inobt_spcrc_flds[] = {
 	{ NULL }
 };
 
+/* free inode btree */
+
+const field_t	finobt_hfld[] = {
+	{ "", FLDT_FINOBT, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+const field_t	finobt_crc_hfld[] = {
+	{ "", FLDT_FINOBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+const field_t	finobt_spcrc_hfld[] = {
+	{ "", FLDT_FINOBT_SPCRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+const field_t	finobt_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_INOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_INOBT },
+	{ "recs", FLDT_INOBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_INOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_FINOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_FINOBT },
+	{ NULL }
+};
+const field_t	finobt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_INOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_INOBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_INOBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_INOBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_INOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_FINOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_FINOBT },
+	{ NULL }
+};
+const field_t	finobt_spcrc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_INOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_INOBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_INOBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_INOBTSPREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_INOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_FINOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_FINOBT },
+	{ NULL }
+};
+
 #undef OFF
 
 #define	KOFF(f)	bitize(offsetof(xfs_inobt_key_t, ir_ ## f))
diff --git a/db/btblock.h b/db/btblock.h
index 465acde7b88..4168c9e2e15 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -24,6 +24,12 @@ extern const struct field	inobt_crc_flds[];
 extern const struct field	inobt_spcrc_flds[];
 extern const struct field	inobt_crc_hfld[];
 extern const struct field	inobt_spcrc_hfld[];
+extern const struct field	finobt_flds[];
+extern const struct field	finobt_hfld[];
+extern const struct field	finobt_crc_flds[];
+extern const struct field	finobt_spcrc_flds[];
+extern const struct field	finobt_crc_hfld[];
+extern const struct field	finobt_spcrc_hfld[];
 extern const struct field	inobt_key_flds[];
 extern const struct field	inobt_rec_flds[];
 extern const struct field	inobt_sprec_flds[];
diff --git a/db/field.c b/db/field.c
index 77cab902239..a3e47ee81cc 100644
--- a/db/field.c
+++ b/db/field.c
@@ -308,10 +308,18 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIZE, NULL, inobt_crc_flds },
 	{ FLDT_INOBT_SPCRC, "inobt",  NULL, (char *)inobt_spcrc_flds,
 	  btblock_size, FTARG_SIZE, NULL, inobt_spcrc_flds },
+	{ FLDT_FINOBT, "finobt",  NULL, (char *)finobt_flds, btblock_size,
+	  FTARG_SIZE, NULL, finobt_flds },
+	{ FLDT_FINOBT_CRC, "finobt",  NULL, (char *)finobt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, finobt_crc_flds },
+	{ FLDT_FINOBT_SPCRC, "finobt",  NULL, (char *)finobt_spcrc_flds,
+	  btblock_size, FTARG_SIZE, NULL, finobt_spcrc_flds },
 	{ FLDT_INOBTKEY, "inobtkey", fp_sarray, (char *)inobt_key_flds,
 	  SI(bitsz(xfs_inobt_key_t)), 0, NULL, inobt_key_flds },
 	{ FLDT_INOBTPTR, "inobtptr", fp_num, "%u", SI(bitsz(xfs_inobt_ptr_t)),
 	  0, fa_agblock, NULL },
+	{ FLDT_FINOBTPTR, "finobtptr", fp_num, "%u", SI(bitsz(xfs_inobt_ptr_t)),
+	  0, fa_agblock, NULL },
 	{ FLDT_INOBTREC, "inobtrec", fp_sarray, (char *)inobt_rec_flds,
 	  SI(bitsz(xfs_inobt_rec_t)), 0, NULL, inobt_rec_flds },
 	{ FLDT_INOBTSPREC, "inobtsprec", fp_sarray, (char *) inobt_sprec_flds,
diff --git a/db/field.h b/db/field.h
index 614fd0ab414..634742a572c 100644
--- a/db/field.h
+++ b/db/field.h
@@ -147,8 +147,12 @@ typedef enum fldt	{
 	FLDT_INOBT,
 	FLDT_INOBT_CRC,
 	FLDT_INOBT_SPCRC,
+	FLDT_FINOBT,
+	FLDT_FINOBT_CRC,
+	FLDT_FINOBT_SPCRC,
 	FLDT_INOBTKEY,
 	FLDT_INOBTPTR,
+	FLDT_FINOBTPTR,
 	FLDT_INOBTREC,
 	FLDT_INOBTSPREC,
 	FLDT_INODE,
diff --git a/db/type.c b/db/type.c
index f8d8b5551d3..efe7044569d 100644
--- a/db/type.c
+++ b/db/type.c
@@ -63,7 +63,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_FINOBT, "finobt", handle_struct, inobt_hfld, NULL,
+	{ TYP_FINOBT, "finobt", handle_struct, finobt_hfld, NULL,
 		TYP_F_NO_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
@@ -107,7 +107,7 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
 		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
+	{ TYP_FINOBT, "finobt", handle_struct, finobt_crc_hfld,
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
@@ -151,7 +151,7 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
 		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
-	{ TYP_FINOBT, "finobt", handle_struct, inobt_spcrc_hfld,
+	{ TYP_FINOBT, "finobt", handle_struct, finobt_spcrc_hfld,
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_NONE, NULL }
 };

