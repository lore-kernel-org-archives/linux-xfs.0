Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A6947F50
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:16:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0BCAC8F8035
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:16:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KT0aWbJPoBjD9zOW for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:16:40 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006PJ-88
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002Gh-7C
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 21/32] db: indicate if the CRC on a buffer is correct or not
Date: Mon, 30 Sep 2013 13:15:33 +1000
Message-Id: <1380510944-8571-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

When dumping metadata that has a CRC in it, output not only the CRC
but text to tell us whether the value is correct or not. Hence we
can see at a glance if there's something wrong or not.

Do this by peeking at the buffer attached to the current IO
contexted. If there was a CRC error, then it will be marked with a
EFSCORRUPTED error. Use this to determine what to output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/agf.c     |  2 +-
 db/agfl.c    |  2 +-
 db/agi.c     |  2 +-
 db/btblock.c | 10 +++++-----
 db/dir2.c    |  4 ++--
 db/dquot.c   |  2 +-
 db/field.c   |  5 +++++
 db/field.h   |  4 ++++
 db/fprint.c  | 39 +++++++++++++++++++++++++++++++++++++++
 db/fprint.h  |  2 ++
 db/inode.c   |  2 +-
 db/io.h      |  6 ++++++
 db/sb.c      |  2 +-
 db/symlink.c |  2 +-
 14 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/db/agf.c b/db/agf.c
index 389cb43..d9a07ca 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -71,7 +71,7 @@ const field_t	agf_flds[] = {
 	{ "btreeblks", FLDT_UINT32D, OI(OFF(btreeblks)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/agfl.c b/db/agfl.c
index e2340e6..b29538f 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -58,7 +58,7 @@ const field_t	agfl_crc_flds[] = {
 	{ "seqno", FLDT_AGNUMBER, OI(OFF(seqno)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "bno", FLDT_AGBLOCKNZ, OI(OFF(bno)), agfl_bno_size,
 	  FLD_ARRAY|FLD_COUNT, TYP_DATA },
 	{ NULL }
diff --git a/db/agi.c b/db/agi.c
index 6b2e889..398bdbb 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -56,7 +56,7 @@ const field_t	agi_flds[] = {
 	  CI(XFS_AGI_UNLINKED_BUCKETS), FLD_ARRAY, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/btblock.c b/db/btblock.c
index 34188db..1ea0cff 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -295,7 +295,7 @@ const field_t	bmapbta_crc_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(OFF(u.l.bb_lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
 	{ "owner", FLDT_INO, OI(OFF(u.l.bb_owner)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
 	{ "recs", FLDT_BMAPBTAREC, btblock_rec_offset, btblock_rec_count,
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "keys", FLDT_BMAPBTAKEY, btblock_key_offset, btblock_key_count,
@@ -314,7 +314,7 @@ const field_t	bmapbtd_crc_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(OFF(u.l.bb_lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(u.l.bb_uuid)), C1, 0, TYP_NONE },
 	{ "owner", FLDT_INO, OI(OFF(u.l.bb_owner)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.l.bb_crc)), C1, 0, TYP_NONE },
 	{ "recs", FLDT_BMAPBTDREC, btblock_rec_offset, btblock_rec_count,
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "keys", FLDT_BMAPBTDKEY, btblock_key_offset, btblock_key_count,
@@ -405,7 +405,7 @@ const field_t	inobt_crc_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
 	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
 	{ "recs", FLDT_INOBTREC, btblock_rec_offset, btblock_rec_count,
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "keys", FLDT_INOBTKEY, btblock_key_offset, btblock_key_count,
@@ -471,7 +471,7 @@ const field_t	bnobt_crc_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
 	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
 	{ "recs", FLDT_BNOBTREC, btblock_rec_offset, btblock_rec_count,
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "keys", FLDT_BNOBTKEY, btblock_key_offset, btblock_key_count,
@@ -533,7 +533,7 @@ const field_t	cntbt_crc_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(OFF(u.s.bb_lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(u.s.bb_uuid)), C1, 0, TYP_NONE },
 	{ "owner", FLDT_AGNUMBER, OI(OFF(u.s.bb_owner)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(u.s.bb_crc)), C1, 0, TYP_NONE },
 	{ "recs", FLDT_CNTBTREC, btblock_rec_offset, btblock_rec_count,
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "keys", FLDT_CNTBTKEY, btblock_key_offset, btblock_key_count,
diff --git a/db/dir2.c b/db/dir2.c
index 8b08d48..2ec64e0 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -922,7 +922,7 @@ const field_t	dir3_data_union_flds[] = {
 #define	DBH3OFF(f)	bitize(offsetof(struct xfs_dir3_blk_hdr, f))
 const field_t	dir3_blkhdr_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(DBH3OFF(magic)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(DBH3OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(DBH3OFF(crc)), C1, 0, TYP_NONE },
 	{ "bno", FLDT_DFSBNO, OI(DBH3OFF(blkno)), C1, 0, TYP_BMAPBTD },
 	{ "lsn", FLDT_UINT64X, OI(DBH3OFF(lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(DBH3OFF(uuid)), C1, 0, TYP_NONE },
@@ -959,7 +959,7 @@ const field_t	dir3_free_hdr_flds[] = {
 #define	DB3OFF(f)	bitize(offsetof(struct xfs_da3_blkinfo, f))
 const field_t	da3_blkinfo_flds[] = {
 	{ "hdr", FLDT_DA_BLKINFO, OI(DB3OFF(hdr)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(DB3OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(DB3OFF(crc)), C1, 0, TYP_NONE },
 	{ "bno", FLDT_DFSBNO, OI(DB3OFF(blkno)), C1, 0, TYP_BMAPBTD },
 	{ "lsn", FLDT_UINT64X, OI(DB3OFF(lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(DB3OFF(uuid)), C1, 0, TYP_NONE },
diff --git a/db/dquot.c b/db/dquot.c
index 6927956..2f7d463 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -48,7 +48,7 @@ const field_t	dqblk_flds[] = {
 	{ "diskdq", FLDT_DISK_DQUOT, OI(DDOFF(diskdq)), C1, 0, TYP_NONE },
 	{ "fill", FLDT_CHARS, OI(DDOFF(fill)), CI(DDSZC(fill)), FLD_SKIPALL,
 	  TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(DDOFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(DDOFF(crc)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(DDOFF(lsn)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(DDOFF(uuid)), C1, 0, TYP_NONE },
 	{ NULL }
diff --git a/db/field.c b/db/field.c
index c6d7404..4582097 100644
--- a/db/field.c
+++ b/db/field.c
@@ -163,6 +163,11 @@ const ftattr_t	ftattrtab[] = {
 	  0, fa_agblock, NULL },
 	{ FLDT_CNTBTREC, "cntbtrec", fp_sarray, (char *)cntbt_rec_flds,
 	  SI(bitsz(xfs_alloc_rec_t)), 0, NULL, cntbt_rec_flds },
+
+/* CRC field */
+	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(__uint32_t)),
+	  0, NULL, NULL },
+
 	{ FLDT_DEV, "dev", fp_num, "%#x", SI(bitsz(xfs_dev_t)), 0, NULL, NULL },
 	{ FLDT_DFILOFFA, "dfiloffa", fp_num, "%llu", SI(bitsz(xfs_dfiloff_t)),
 	  0, fa_dfiloffa, NULL },
diff --git a/db/field.h b/db/field.h
index aecdf9f..6343c9a 100644
--- a/db/field.h
+++ b/db/field.h
@@ -80,6 +80,10 @@ typedef enum fldt	{
 	FLDT_CNTBTKEY,
 	FLDT_CNTBTPTR,
 	FLDT_CNTBTREC,
+
+	/* CRC field type */
+	FLDT_CRC,
+
 	FLDT_DEV,
 	FLDT_DFILOFFA,
 	FLDT_DFILOFFD,
diff --git a/db/fprint.c b/db/fprint.c
index 1d2f29c..435d984 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -30,6 +30,7 @@
 #include "output.h"
 #include "sig.h"
 #include "malloc.h"
+#include "io.h"
 
 int
 fp_charns(
@@ -184,3 +185,41 @@ fp_uuid(
 	}
 	return 1;
 }
+
+/*
+ * CRC is correct is the current buffer it is being pulled out
+ * of is not marked with a EFSCORRUPTED error.
+ */
+int
+fp_crc(
+	void	*obj,
+	int	bit,
+	int	count,
+	char	*fmtstr,
+	int	size,
+	int	arg,
+	int	base,
+	int	array)
+{
+	int		bitpos;
+	int		i;
+	__int64_t	val;
+	char		*ok;
+
+	ok = iocur_crc_valid() ? "correct" : "bad";
+
+	for (i = 0, bitpos = bit;
+	     i < count && !seenint();
+	     i++, bitpos += size) {
+		if (array)
+			dbprintf("%d:", i + base);
+		val = getbitval(obj, bitpos, size, BVUNSIGNED);
+		if (size > 32)
+			dbprintf(fmtstr, val, ok);
+		else
+			dbprintf(fmtstr, (__int32_t)val, ok);
+		if (i < count - 1)
+			dbprintf(" ");
+	}
+	return 1;
+}
diff --git a/db/fprint.h b/db/fprint.h
index b032dbd..6a6d77e 100644
--- a/db/fprint.h
+++ b/db/fprint.h
@@ -29,3 +29,5 @@ extern int	fp_time(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
 extern int	fp_uuid(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
+extern int	fp_crc(void *obj, int bit, int count, char *fmtstr, int size,
+		       int arg, int base, int array);
diff --git a/db/inode.c b/db/inode.c
index 634dc30..ec533ee 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -168,7 +168,7 @@ const field_t	inode_core_flds[] = {
 };
 
 const field_t	inode_v3_flds[] = {
-	{ "crc", FLDT_UINT32X, OI(COFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(COFF(crc)), C1, 0, TYP_NONE },
 	{ "change_count", FLDT_UINT64D, OI(COFF(changecount)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
diff --git a/db/io.h b/db/io.h
index 2c47ccc..d647284 100644
--- a/db/io.h
+++ b/db/io.h
@@ -58,3 +58,9 @@ extern void     write_cur(void);
 extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
 			bbmap_t *bbmap);
 extern void     ring_add(void);
+
+static inline bool
+iocur_crc_valid()
+{
+	return (iocur_top->bp && iocur_top->bp->b_error != EFSCORRUPTED);
+}
diff --git a/db/sb.c b/db/sb.c
index d178f58..b36abf8 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -118,7 +118,7 @@ const field_t	sb_flds[] = {
 		C1, 0, TYP_NONE },
 	{ "features_log_incompat", FLDT_UINT32X, OI(OFF(features_log_incompat)),
 		C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ NULL }
diff --git a/db/symlink.c b/db/symlink.c
index 9f3d0b9..a4f420f 100644
--- a/db/symlink.c
+++ b/db/symlink.c
@@ -69,7 +69,7 @@ const struct field	symlink_crc_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
 	{ "offset", FLDT_UINT32D, OI(OFF(offset)), C1, 0, TYP_NONE },
 	{ "bytes", FLDT_UINT32D, OI(OFF(bytes)), C1, 0, TYP_NONE },
-	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
 	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
