Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27ED37F60
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 167898F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Zi1i9bmdRfPTzNrV for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVz-0003vl-T8
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:47 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVy-0001Li-Hu
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/48] xfsprogs: add crc format support to db
Date: Fri,  7 Jun 2013 10:25:53 +1000
Message-Id: <1370564771-4929-31-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/agf.c      |    3 ++
 db/agfl.c     |   16 +++++++
 db/agfl.h     |    2 +
 db/agi.c      |    3 ++
 db/btblock.c  |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/btblock.h  |   10 ++++
 db/field.c    |   16 +++++++
 db/field.h    |    8 ++++
 db/freesp.c   |    6 ++-
 db/init.c     |    4 ++
 db/inode.c    |   27 +++++++++++
 db/inode.h    |    3 ++
 db/type.c     |   34 +++++++++++++-
 db/type.h     |    3 +-
 libxfs/util.c |    1 -
 15 files changed, 276 insertions(+), 5 deletions(-)

diff --git a/db/agf.c b/db/agf.c
index 668637a..389cb43 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -69,6 +69,9 @@ const field_t	agf_flds[] = {
 	{ "freeblks", FLDT_EXTLEN, OI(OFF(freeblks)), C1, 0, TYP_NONE },
 	{ "longest", FLDT_EXTLEN, OI(OFF(longest)), C1, 0, TYP_NONE },
 	{ "btreeblks", FLDT_UINT32D, OI(OFF(btreeblks)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/agfl.c b/db/agfl.c
index 72dca23..e2340e6 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -41,8 +41,24 @@ const field_t	agfl_hfld[] = { {
 	{ NULL }
 };
 
+const field_t	agfl_crc_hfld[] = { {
+	"", FLDT_AGFL_CRC, OI(0), C1, 0, TYP_NONE, },
+	{ NULL }
+};
+
 #define	OFF(f)	bitize(offsetof(xfs_agfl_t, agfl_ ## f))
 const field_t	agfl_flds[] = {
+	{ "bno", FLDT_AGBLOCKNZ, OI(OFF(magicnum)), agfl_bno_size,
+	  FLD_ARRAY|FLD_COUNT, TYP_DATA },
+	{ NULL }
+};
+
+const field_t	agfl_crc_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magicnum)), C1, 0, TYP_NONE },
+	{ "seqno", FLDT_AGNUMBER, OI(OFF(seqno)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "bno", FLDT_AGBLOCKNZ, OI(OFF(bno)), agfl_bno_size,
 	  FLD_ARRAY|FLD_COUNT, TYP_DATA },
 	{ NULL }
diff --git a/db/agfl.h b/db/agfl.h
index 7b7631b..177ad41 100644
--- a/db/agfl.h
+++ b/db/agfl.h
@@ -18,6 +18,8 @@
 
 extern const struct field	agfl_flds[];
 extern const struct field	agfl_hfld[];
+extern const struct field	agfl_crc_flds[];
+extern const struct field	agfl_crc_hfld[];
 
 extern void	agfl_init(void);
 extern int	agfl_size(void *obj, int startoff, int idx);
diff --git a/db/agi.c b/db/agi.c
index 02d5d30..6b2e889 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -54,6 +54,9 @@ const field_t	agi_flds[] = {
 	{ "dirino", FLDT_AGINO, OI(OFF(dirino)), C1, 0, TYP_INODE },
 	{ "unlinked", FLDT_AGINONN, OI(OFF(unlinked)),
 	  CI(XFS_AGI_UNLINKED_BUCKETS), FLD_ARRAY, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/btblock.c b/db/btblock.c
index 2c199b2..37b9903 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -60,6 +60,31 @@ struct xfs_db_btree {
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
+	[/*0x424d415*/8] = { /* BMAP_CRC */
+		XFS_BTREE_LBLOCK_CRC_LEN,
+		sizeof(xfs_bmbt_key_t),
+		sizeof(xfs_bmbt_rec_t),
+		sizeof(__be64),
+	},
+	[/*0x4142544*/0xa] = { /* ABTB_CRC */
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		sizeof(xfs_alloc_key_t),
+		sizeof(xfs_alloc_rec_t),
+		sizeof(__be32),
+	},
+	[/*0x414254*/0xb] = { /* ABTC_CRC */
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		sizeof(xfs_alloc_key_t),
+		sizeof(xfs_alloc_rec_t),
+		sizeof(__be32),
+	},
+	[/*0x4941425*/0xc] = { /* IABT_CRC */
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		sizeof(xfs_inobt_key_t),
+		sizeof(xfs_inobt_rec_t),
+		sizeof(__be32),
+	},
+
 };
 
 /*
@@ -208,6 +233,15 @@ const field_t	bmapbtd_hfld[] = {
 	{ NULL }
 };
 
+const field_t	bmapbta_crc_hfld[] = {
+	{ "", FLDT_BMAPBTA_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+const field_t	bmapbtd_crc_hfld[] = {
+	{ "", FLDT_BMAPBTD_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 #define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
 const field_t	bmapbta_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
@@ -237,6 +271,45 @@ const field_t	bmapbtd_flds[] = {
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTD },
 	{ NULL }
 };
+/* crc enabled versions */
+const field_t	bmapbta_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.l.bb_leftsib)), C1, 0, TYP_BMAPBTA },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.l.bb_rightsib)), C1, 0, TYP_BMAPBTA },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.l.bb_blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.l.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(u.l.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_BMAPBTAREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_BMAPBTAKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_BMAPBTAPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTA },
+	{ NULL }
+};
+const field_t	bmapbtd_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.l.bb_leftsib)), C1, 0, TYP_BMAPBTD },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.l.bb_rightsib)), C1, 0, TYP_BMAPBTD },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.l.bb_blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.l.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(u.l.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_BMAPBTDREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_BMAPBTDKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_BMAPBTDPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BMAPBTD },
+	{ NULL }
+};
 #undef OFF
 
 #define	KOFF(f)	bitize(offsetof(xfs_bmbt_key_t, br_ ## f))
@@ -289,6 +362,11 @@ const field_t	inobt_hfld[] = {
 	{ NULL }
 };
 
+const field_t	inobt_crc_hfld[] = {
+	{ "", FLDT_INOBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 #define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
 const field_t	inobt_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
@@ -304,6 +382,25 @@ const field_t	inobt_flds[] = {
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_INOBT },
 	{ NULL }
 };
+const field_t	inobt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_INOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_INOBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_INOBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_INOBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_INOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_INOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_INOBT },
+	{ NULL }
+};
 #undef OFF
 
 #define	KOFF(f)	bitize(offsetof(xfs_inobt_key_t, ir_ ## f))
@@ -331,6 +428,11 @@ const field_t	bnobt_hfld[] = {
 	{ NULL }
 };
 
+const field_t	bnobt_crc_hfld[] = {
+	{ "", FLDT_BNOBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 #define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
 const field_t	bnobt_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
@@ -346,6 +448,25 @@ const field_t	bnobt_flds[] = {
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BNOBT },
 	{ NULL }
 };
+const field_t	bnobt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_BNOBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_BNOBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_BNOBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_BNOBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_BNOBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_BNOBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_BNOBT },
+	{ NULL }
+};
 #undef OFF
 
 #define	KOFF(f)	bitize(offsetof(xfs_alloc_key_t, ar_ ## f))
@@ -369,6 +490,11 @@ const field_t	cntbt_hfld[] = {
 	{ NULL }
 };
 
+const field_t	cntbt_crc_hfld[] = {
+	{ "", FLDT_CNTBT_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 #define	OFF(f)	bitize(offsetof(struct xfs_btree_block, bb_ ## f))
 const field_t	cntbt_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
@@ -384,6 +510,25 @@ const field_t	cntbt_flds[] = {
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_CNTBT },
 	{ NULL }
 };
+const field_t	cntbt_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
+	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
+	{ "leftsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_CNTBT },
+	{ "rightsib", FLDT_AGBLOCK, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_CNTBT },
+	{ "bno", FLDT_DFSBNO, OI(OFF(u.s.bb_blkno)), C1, 0, TYP_CNTBT },
+	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "recs", FLDT_CNTBTREC, btblock_rec_offset, btblock_rec_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "keys", FLDT_CNTBTKEY, btblock_key_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ "ptrs", FLDT_CNTBTPTR, btblock_ptr_offset, btblock_key_count,
+	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_CNTBT },
+	{ NULL }
+};
 #undef OFF
 
 #define	KOFF(f)	bitize(offsetof(xfs_alloc_key_t, ar_ ## f))
diff --git a/db/btblock.h b/db/btblock.h
index 0631e66..daee060 100644
--- a/db/btblock.h
+++ b/db/btblock.h
@@ -18,26 +18,36 @@
 
 extern const struct field	bmapbta_flds[];
 extern const struct field	bmapbta_hfld[];
+extern const struct field	bmapbta_crc_flds[];
+extern const struct field	bmapbta_crc_hfld[];
 extern const struct field	bmapbta_key_flds[];
 extern const struct field	bmapbta_rec_flds[];
 
 extern const struct field	bmapbtd_flds[];
 extern const struct field	bmapbtd_hfld[];
+extern const struct field	bmapbtd_crc_flds[];
+extern const struct field	bmapbtd_crc_hfld[];
 extern const struct field	bmapbtd_key_flds[];
 extern const struct field	bmapbtd_rec_flds[];
 
 extern const struct field	inobt_flds[];
 extern const struct field	inobt_hfld[];
+extern const struct field	inobt_crc_flds[];
+extern const struct field	inobt_crc_hfld[];
 extern const struct field	inobt_key_flds[];
 extern const struct field	inobt_rec_flds[];
 
 extern const struct field	bnobt_flds[];
 extern const struct field	bnobt_hfld[];
+extern const struct field	bnobt_crc_flds[];
+extern const struct field	bnobt_crc_hfld[];
 extern const struct field	bnobt_key_flds[];
 extern const struct field	bnobt_rec_flds[];
 
 extern const struct field	cntbt_flds[];
 extern const struct field	cntbt_hfld[];
+extern const struct field	cntbt_crc_flds[];
+extern const struct field	cntbt_crc_hfld[];
 extern const struct field	cntbt_key_flds[];
 extern const struct field	cntbt_rec_flds[];
 
diff --git a/db/field.c b/db/field.c
index dc72563..510ad84 100644
--- a/db/field.c
+++ b/db/field.c
@@ -46,6 +46,8 @@ const ftattr_t	ftattrtab[] = {
 	  agf_flds },
 	{ FLDT_AGFL, "agfl", NULL, (char *)agfl_flds, agfl_size, FTARG_SIZE,
 	  NULL, agfl_flds },
+	{ FLDT_AGFL_CRC, "agfl", NULL, (char *)agfl_crc_flds, agfl_size,
+	  FTARG_SIZE, NULL, agfl_crc_flds },
 	{ FLDT_AGI, "agi", NULL, (char *)agi_flds, agi_size, FTARG_SIZE, NULL,
 	  agi_flds },
 	{ FLDT_AGINO, "agino", fp_num, "%u", SI(bitsz(xfs_agino_t)),
@@ -84,6 +86,8 @@ const ftattr_t	ftattrtab[] = {
 	  attrshort_size, FTARG_SIZE, NULL, attr_shortform_flds },
 	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbta_flds },
+	{ FLDT_BMAPBTA_CRC, "bmapbta", NULL, (char *)bmapbta_crc_flds,
+	  btblock_size, FTARG_SIZE, NULL, bmapbta_crc_flds },
 	{ FLDT_BMAPBTAKEY, "bmapbtakey", fp_sarray, (char *)bmapbta_key_flds,
 	  SI(bitsz(xfs_bmbt_key_t)), 0, NULL, bmapbta_key_flds },
 	{ FLDT_BMAPBTAPTR, "bmapbtaptr", fp_num, "%llu",
@@ -92,6 +96,8 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_bmbt_rec_t)), 0, NULL, bmapbta_rec_flds },
 	{ FLDT_BMAPBTD, "bmapbtd", NULL, (char *)bmapbtd_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbtd_flds },
+	{ FLDT_BMAPBTD_CRC, "bmapbtd", NULL, (char *)bmapbtd_crc_flds,
+	  btblock_size, FTARG_SIZE, NULL, bmapbtd_crc_flds },
 	{ FLDT_BMAPBTDKEY, "bmapbtdkey", fp_sarray, (char *)bmapbtd_key_flds,
 	  SI(bitsz(xfs_bmbt_key_t)), 0, NULL, bmapbtd_key_flds },
 	{ FLDT_BMAPBTDPTR, "bmapbtdptr", fp_num, "%llu",
@@ -112,6 +118,8 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_bmdr_ptr_t)), 0, fa_dfsbno, NULL },
 	{ FLDT_BNOBT, "bnobt", NULL, (char *)bnobt_flds, btblock_size, FTARG_SIZE,
 	  NULL, bnobt_flds },
+	{ FLDT_BNOBT_CRC, "bnobt", NULL, (char *)bnobt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, bnobt_crc_flds },
 	{ FLDT_BNOBTKEY, "bnobtkey", fp_sarray, (char *)bnobt_key_flds,
 	  SI(bitsz(xfs_alloc_key_t)), 0, NULL, bnobt_key_flds },
 	{ FLDT_BNOBTPTR, "bnobtptr", fp_num, "%u", SI(bitsz(xfs_alloc_ptr_t)),
@@ -133,6 +141,8 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },
 	{ FLDT_CNTBT, "cntbt", NULL, (char *)cntbt_flds, btblock_size, FTARG_SIZE,
 	  NULL, cntbt_flds },
+	{ FLDT_CNTBT_CRC, "cntbt", NULL, (char *)cntbt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, cntbt_crc_flds },
 	{ FLDT_CNTBTKEY, "cntbtkey", fp_sarray, (char *)cntbt_key_flds,
 	  SI(bitsz(xfs_alloc_key_t)), 0, NULL, cntbt_key_flds },
 	{ FLDT_CNTBTPTR, "cntbtptr", fp_num, "%u", SI(bitsz(xfs_alloc_ptr_t)),
@@ -154,6 +164,8 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(__int8_t)), 0, NULL, NULL },
 	{ FLDT_DINODE_U, "dinode_u", NULL, (char *)inode_u_flds, inode_u_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_u_flds },
+	{ FLDT_DINODE_V3, "dinode_v3", NULL, (char *)inode_v3_flds,
+	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_v3_flds },
 	{ FLDT_DIR2, "dir2", NULL, (char *)dir2_flds, dir2_size, FTARG_SIZE,
 	  NULL, dir2_flds },
 	{ FLDT_DIR2_BLOCK_TAIL, "dir2_block_tail", NULL,
@@ -224,6 +236,8 @@ const ftattr_t	ftattrtab[] = {
 	  fa_ino, NULL },
 	{ FLDT_INOBT, "inobt",  NULL, (char *)inobt_flds, btblock_size,
 	  FTARG_SIZE, NULL, inobt_flds },
+	{ FLDT_INOBT_CRC, "inobt",  NULL, (char *)inobt_crc_flds, btblock_size,
+	  FTARG_SIZE, NULL, inobt_crc_flds },
 	{ FLDT_INOBTKEY, "inobtkey", fp_sarray, (char *)inobt_key_flds,
 	  SI(bitsz(xfs_inobt_key_t)), 0, NULL, inobt_key_flds },
 	{ FLDT_INOBTPTR, "inobtptr", fp_num, "%u", SI(bitsz(xfs_inobt_ptr_t)),
@@ -232,6 +246,8 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_inobt_rec_t)), 0, NULL, inobt_rec_flds },
 	{ FLDT_INODE, "inode", NULL, (char *)inode_flds, inode_size, FTARG_SIZE,
 	  NULL, inode_flds },
+	{ FLDT_INODE_CRC, "inode", NULL, (char *)inode_crc_flds, inode_size,
+	  FTARG_SIZE, NULL, inode_crc_flds },
 	{ FLDT_INOFREE, "inofree", fp_num, "%#llx", SI(bitsz(xfs_inofree_t)), 0,
 	  NULL, NULL },
 	{ FLDT_INT16D, "int16d", fp_num, "%d", SI(bitsz(__int16_t)),
diff --git a/db/field.h b/db/field.h
index 72c225b..9b332f5 100644
--- a/db/field.h
+++ b/db/field.h
@@ -22,6 +22,7 @@ typedef enum fldt	{
 	FLDT_AGBLOCKNZ,
 	FLDT_AGF,
 	FLDT_AGFL,
+	FLDT_AGFL_CRC,
 	FLDT_AGI,
 	FLDT_AGINO,
 	FLDT_AGINONN,
@@ -39,10 +40,12 @@ typedef enum fldt	{
 	FLDT_ATTRBLOCK,
 	FLDT_ATTRSHORT,
 	FLDT_BMAPBTA,
+	FLDT_BMAPBTA_CRC,
 	FLDT_BMAPBTAKEY,
 	FLDT_BMAPBTAPTR,
 	FLDT_BMAPBTAREC,
 	FLDT_BMAPBTD,
+	FLDT_BMAPBTD_CRC,
 	FLDT_BMAPBTDKEY,
 	FLDT_BMAPBTDPTR,
 	FLDT_BMAPBTDREC,
@@ -53,6 +56,7 @@ typedef enum fldt	{
 	FLDT_BMROOTDKEY,
 	FLDT_BMROOTDPTR,
 	FLDT_BNOBT,
+	FLDT_BNOBT_CRC,
 	FLDT_BNOBTKEY,
 	FLDT_BNOBTPTR,
 	FLDT_BNOBTREC,
@@ -64,6 +68,7 @@ typedef enum fldt	{
 	FLDT_CHARNS,
 	FLDT_CHARS,
 	FLDT_CNTBT,
+	FLDT_CNTBT_CRC,
 	FLDT_CNTBTKEY,
 	FLDT_CNTBTPTR,
 	FLDT_CNTBTREC,
@@ -75,6 +80,7 @@ typedef enum fldt	{
 	FLDT_DINODE_CORE,
 	FLDT_DINODE_FMT,
 	FLDT_DINODE_U,
+	FLDT_DINODE_V3,
 	FLDT_DIR2,
 	FLDT_DIR2_BLOCK_TAIL,
 	FLDT_DIR2_DATA_FREE,
@@ -107,10 +113,12 @@ typedef enum fldt	{
 	FLDT_FSIZE,
 	FLDT_INO,
 	FLDT_INOBT,
+	FLDT_INOBT_CRC,
 	FLDT_INOBTKEY,
 	FLDT_INOBTPTR,
 	FLDT_INOBTREC,
 	FLDT_INODE,
+	FLDT_INODE_CRC,
 	FLDT_INOFREE,
 	FLDT_INT16D,
 	FLDT_INT32D,
diff --git a/db/freesp.c b/db/freesp.c
index 228ca07..6f69eba 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -301,7 +301,8 @@ scanfunc_bno(
 	xfs_alloc_ptr_t		*pp;
 	xfs_alloc_rec_t		*rp;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC)
+	if (!(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC ||
+	      be32_to_cpu(block->bb_magic) == XFS_ABTB_CRC_MAGIC))
 		return;
 
 	if (level == 0) {
@@ -328,7 +329,8 @@ scanfunc_cnt(
 	xfs_alloc_ptr_t		*pp;
 	xfs_alloc_rec_t		*rp;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC)
+	if (!(be32_to_cpu(block->bb_magic) == XFS_ABTC_MAGIC ||
+	      be32_to_cpu(block->bb_magic) == XFS_ABTC_CRC_MAGIC))
 		return;
 
 	if (level == 0) {
diff --git a/db/init.c b/db/init.c
index 1033f3a..2932e51 100644
--- a/db/init.c
+++ b/db/init.c
@@ -26,6 +26,7 @@
 #include "sig.h"
 #include "output.h"
 #include "malloc.h"
+#include "type.h"
 
 static char	**cmdline;
 static int	ncmdline;
@@ -160,6 +161,9 @@ init(
 	}
 	blkbb = 1 << mp->m_blkbb_log;
 
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		type_set_tab_crc();
+
 	push_cur();
 	init_commands();
 	init_sig();
diff --git a/db/inode.c b/db/inode.c
index c8cb7ac..68ef564 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -57,6 +57,10 @@ const field_t	inode_hfld[] = {
 	{ "", FLDT_INODE, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
 };
+const field_t	inode_crc_hfld[] = {
+	{ "", FLDT_INODE_CRC, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
 
 /* XXX: fix this up! */
 #define	OFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
@@ -69,6 +73,17 @@ const field_t	inode_flds[] = {
 	  FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
 };
+const field_t	inode_crc_flds[] = {
+	{ "core", FLDT_DINODE_CORE, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
+	  TYP_INODE },
+	{ "v3", FLDT_DINODE_V3, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "u", FLDT_DINODE_U, inode_u_offset, C1, FLD_OFFSET, TYP_NONE },
+	{ "a", FLDT_DINODE_A, inode_a_offset, inode_a_count,
+	  FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ NULL }
+};
+
 
 #define	COFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
 const field_t	inode_core_flds[] = {
@@ -151,6 +166,18 @@ const field_t	inode_core_flds[] = {
 	{ NULL }
 };
 
+const field_t	inode_v3_flds[] = {
+	{ "crc", FLDT_UINT32X, OI(COFF(crc)), C1, 0, TYP_NONE },
+	{ "change_count", FLDT_UINT64D, OI(COFF(changecount)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
+	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
+	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
+	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+
 #define	TOFF(f)	bitize(offsetof(xfs_timestamp_t, t_ ## f))
 const field_t	timestamp_flds[] = {
 	{ "sec", FLDT_TIME, OI(TOFF(sec)), C1, 0, TYP_NONE },
diff --git a/db/inode.h b/db/inode.h
index 6c1ac5c..1624f1d 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -18,8 +18,11 @@
 
 extern const struct field	inode_a_flds[];
 extern const struct field	inode_core_flds[];
+extern const struct field	inode_v3_flds[];
 extern const struct field	inode_flds[];
+extern const struct field	inode_crc_flds[];
 extern const struct field	inode_hfld[];
+extern const struct field	inode_crc_hfld[];
 extern const struct field	inode_u_flds[];
 extern const struct field	timestamp_flds[];
 
diff --git a/db/type.c b/db/type.c
index 529c9e7..97f3548 100644
--- a/db/type.c
+++ b/db/type.c
@@ -48,7 +48,7 @@ static const cmdinfo_t	type_cmd =
 	{ "type", NULL, type_f, 0, 1, 1, N_("[newtype]"),
 	  N_("set/show current data type"), NULL };
 
-const typ_t	typtab[] = {
+static const typ_t	__typtab[] = {
 	{ TYP_AGF, "agf", handle_struct, agf_hfld },
 	{ TYP_AGFL, "agfl", handle_struct, agfl_hfld },
 	{ TYP_AGI, "agi", handle_struct, agi_hfld },
@@ -72,6 +72,38 @@ const typ_t	typtab[] = {
 	{ TYP_NONE, NULL }
 };
 
+static const typ_t	__typtab_crc[] = {
+	{ TYP_AGF, "agf", handle_struct, agf_hfld },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld },
+	{ TYP_ATTR, "attr", handle_struct, attr_hfld },
+	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld },
+	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld },
+	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld },
+	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld },
+	{ TYP_DATA, "data", handle_block, NULL },
+	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld },
+	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld },
+	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld },
+	{ TYP_INODATA, "inodata", NULL, NULL },
+	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld },
+	{ TYP_LOG, "log", NULL, NULL },
+	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL },
+	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL },
+	{ TYP_SB, "sb", handle_struct, sb_hfld },
+	{ TYP_SYMLINK, "symlink", handle_string, NULL },
+	{ TYP_TEXT, "text", handle_text, NULL },
+	{ TYP_NONE, NULL }
+};
+
+const typ_t	*typtab = __typtab;
+
+void
+type_set_tab_crc(void)
+{
+	typtab = __typtab_crc;
+}
+
 static const typ_t *
 findtyp(
 	char		*name)
diff --git a/db/type.h b/db/type.h
index 4a1d328..c41aca4 100644
--- a/db/type.h
+++ b/db/type.h
@@ -43,9 +43,10 @@ typedef struct typ
 	pfunc_t			pfunc;
 	const struct field	*fields;
 } typ_t;
-extern const typ_t	typtab[], *cur_typ;
+extern const typ_t	*typtab, *cur_typ;
 
 extern void	type_init(void);
+extern void	type_set_tab_crc(void);
 extern void	handle_block(int action, const struct field *fields, int argc,
 			     char **argv);
 extern void	handle_string(int action, const struct field *fields, int argc,
diff --git a/libxfs/util.c b/libxfs/util.c
index abe16cf..1d3113a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -79,7 +79,6 @@ libxfs_ialloc(
 	xfs_inode_t	*ip;
 	uint		flags;
 	int		error;
-	int		times;
 
 	/*
 	 * Call the space management code to pick
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
