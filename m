Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 383467F6F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:43:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09F698F8081
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:43:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MNa8dvgZmCgomm7A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:43:14 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id E100E19F25C
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:43:13 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4Sq019888
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 12/28] db: support sparse inode chunk inobt record and sb
	fields
Date: Tue,  2 Jun 2015 14:41:45 -0400
Message-Id: <1433270521-62026-13-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The sparse inode feature uses a different on-disk inobt record format.
Define the new record format in the xfs_db type infrastructure and use
this definition for fs' that support sparse inodes.

Also update the superblock type structure with the sb_spino_align field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/btblock.c | 36 ++++++++++++++++++++++++++++++++++++
 db/btblock.h |  3 +++
 db/field.c   |  4 ++++
 db/field.h   |  2 ++
 db/init.c    |  4 +++-
 db/sb.c      |  1 +
 db/type.c    | 40 ++++++++++++++++++++++++++++++++++++++++
 db/type.h    |  1 +
 8 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/db/btblock.c b/db/btblock.c
index d87991d..982b52b 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -392,6 +392,11 @@ const field_t	inobt_crc_hfld[] = {
 	{ NULL }
 };
 
+const field_t	inobt_spcrc_hfld[] = {
+	{ "", FLDT_INOBT_SPCRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 #define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
 const field_t	inobt_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
@@ -426,6 +431,26 @@ const field_t	inobt_crc_flds[] = {
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_INOBT },
 	{ NULL }
 };
+const field_t	inobt_spcrc_flds[] = {
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
+	{ "ptrs", FLDT_INOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_INOBT },
+	{ NULL }
+};
+
 #undef OFF
 
 #define	KOFF(f)	bitize(offsetof(xfs_inobt_key_t, ir_ ## f))
@@ -443,6 +468,17 @@ const field_t	inobt_rec_flds[] = {
 	{ "free", FLDT_INOFREE, OI(ROFF(ir_free)), C1, 0, TYP_NONE },
 	{ NULL }
 };
+/* sparse inode on-disk format */
+const field_t	inobt_sprec_flds[] = {
+	{ "startino", FLDT_AGINO, OI(ROFF(ir_startino)), C1, 0, TYP_INODE },
+	{ "holemask", FLDT_UINT16X, OI(ROFF(ir_u.sp.ir_holemask)), C1, 0,
+	  TYP_NONE },
+	{ "count", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_count)), C1, 0, TYP_NONE },
+	{ "freecount", FLDT_INT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
+	  TYP_NONE },
+	{ "free", FLDT_INOFREE, OI(ROFF(ir_free)), C1, 0, TYP_NONE },
+	{ NULL }
+};
 #undef ROFF
 
 
diff --git a/db/btblock.h b/db/btblock.h
index daee060..228eb36 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -33,9 +33,12 @@ extern const struct field	bmapbtd_rec_flds[];
 extern const struct field	inobt_flds[];
 extern const struct field	inobt_hfld[];
 extern const struct field	inobt_crc_flds[];
+extern const struct field	inobt_spcrc_flds[];
 extern const struct field	inobt_crc_hfld[];
+extern const struct field	inobt_spcrc_hfld[];
 extern const struct field	inobt_key_flds[];
 extern const struct field	inobt_rec_flds[];
+extern const struct field	inobt_sprec_flds[];
 
 extern const struct field	bnobt_flds[];
 extern const struct field	bnobt_hfld[];
diff --git a/db/field.c b/db/field.c
index 816065e..52d9d9b 100644
--- a/db/field.c
+++ b/db/field.c
@@ -285,12 +285,16 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIZE, NULL, inobt_flds },
 	{ FLDT_INOBT_CRC, "inobt",  NULL, (char *)inobt_crc_flds, btblock_size,
 	  FTARG_SIZE, NULL, inobt_crc_flds },
+	{ FLDT_INOBT_SPCRC, "inobt",  NULL, (char *)inobt_spcrc_flds,
+	  btblock_size, FTARG_SIZE, NULL, inobt_spcrc_flds },
 	{ FLDT_INOBTKEY, "inobtkey", fp_sarray, (char *)inobt_key_flds,
 	  SI(bitsz(xfs_inobt_key_t)), 0, NULL, inobt_key_flds },
 	{ FLDT_INOBTPTR, "inobtptr", fp_num, "%u", SI(bitsz(xfs_inobt_ptr_t)),
 	  0, fa_agblock, NULL },
 	{ FLDT_INOBTREC, "inobtrec", fp_sarray, (char *)inobt_rec_flds,
 	  SI(bitsz(xfs_inobt_rec_t)), 0, NULL, inobt_rec_flds },
+	{ FLDT_INOBTSPREC, "inobtsprec", fp_sarray, (char *) inobt_sprec_flds,
+	  SI(bitsz(xfs_inobt_rec_t)), 0, NULL, inobt_sprec_flds },
 	{ FLDT_INODE, "inode", NULL, (char *)inode_flds, inode_size, FTARG_SIZE,
 	  NULL, inode_flds },
 	{ FLDT_INODE_CRC, "inode", NULL, (char *)inode_crc_flds, inode_size,
diff --git a/db/field.h b/db/field.h
index 6343c9a..2546240 100644
--- a/db/field.h
+++ b/db/field.h
@@ -143,9 +143,11 @@ typedef enum fldt	{
 	FLDT_INO,
 	FLDT_INOBT,
 	FLDT_INOBT_CRC,
+	FLDT_INOBT_SPCRC,
 	FLDT_INOBTKEY,
 	FLDT_INOBTPTR,
 	FLDT_INOBTREC,
+	FLDT_INOBTSPREC,
 	FLDT_INODE,
 	FLDT_INODE_CRC,
 	FLDT_INOFREE,
diff --git a/db/init.c b/db/init.c
index e7f536a..f93ab15 100644
--- a/db/init.c
+++ b/db/init.c
@@ -169,7 +169,9 @@ init(
 		}
 	}
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		type_set_tab_spcrc();
+	else if (xfs_sb_version_hascrc(&mp->m_sb))
 		type_set_tab_crc();
 
 	push_cur();
diff --git a/db/sb.c b/db/sb.c
index cd12f83..4208569 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -119,6 +119,7 @@ const field_t	sb_flds[] = {
 	{ "features_log_incompat", FLDT_UINT32X, OI(OFF(features_log_incompat)),
 		C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "spino_align", FLDT_EXTLEN, OI(OFF(spino_align)), C1, 0, TYP_NONE },
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ NULL }
diff --git a/db/type.c b/db/type.c
index b29f2a4..28535de 100644
--- a/db/type.c
+++ b/db/type.c
@@ -107,6 +107,40 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_NONE, NULL }
 };
 
+static const typ_t	__typtab_spcrc[] = {
+	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
+	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
+		&xfs_attr3_db_buf_ops },
+	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
+		&xfs_bmbt_buf_ops },
+	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
+		&xfs_bmbt_buf_ops },
+	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld,
+		&xfs_allocbt_buf_ops },
+	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
+		&xfs_allocbt_buf_ops },
+	{ TYP_DATA, "data", handle_block, NULL, NULL },
+	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
+		&xfs_dir3_db_buf_ops },
+	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
+		&xfs_dquot_buf_ops },
+	{ TYP_INOBT, "inobt", handle_struct, inobt_spcrc_hfld,
+		&xfs_inobt_buf_ops },
+	{ TYP_INODATA, "inodata", NULL, NULL, NULL },
+	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
+		&xfs_inode_buf_ops },
+	{ TYP_LOG, "log", NULL, NULL, NULL },
+	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL },
+	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL },
+	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops },
+	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
+		&xfs_symlink_buf_ops },
+	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+	{ TYP_NONE, NULL }
+};
+
 const typ_t	*typtab = __typtab;
 
 void
@@ -115,6 +149,12 @@ type_set_tab_crc(void)
 	typtab = __typtab_crc;
 }
 
+void
+type_set_tab_spcrc(void)
+{
+	typtab = __typtab_spcrc;
+}
+
 static const typ_t *
 findtyp(
 	char		*name)
diff --git a/db/type.h b/db/type.h
index 3bb26f1..c9421d1 100644
--- a/db/type.h
+++ b/db/type.h
@@ -48,6 +48,7 @@ extern const typ_t	*typtab, *cur_typ;
 
 extern void	type_init(void);
 extern void	type_set_tab_crc(void);
+extern void	type_set_tab_spcrc(void);
 extern void	handle_block(int action, const struct field *fields, int argc,
 			     char **argv);
 extern void	handle_string(int action, const struct field *fields, int argc,
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
