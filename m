Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F16A7F74
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2DF28F8059
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CSLR3aeAmfMvYu1A for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002yp-Rr
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007ep-Qp
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/30] db: introduce verifier support into set_cur
Date: Wed, 30 Oct 2013 15:31:09 +1100
Message-Id: <1383107481-28937-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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

To be able to use read and write verifiers, we need to pass the
verifier to the IO routines. We do this via the set_cur() function
used to trigger reading the buffer.

For most metadata types, there is only one type of verifier needed.
For these, we can simply add the verifier to the type table entry
for the given type and use that directly. This type entry is already
carried around by the IO context, so if we ever need to get it again
we have direct access to it in the context we'll be doing IO.

Only attach the verifiers to the v5 filesystem type table; there is
not need for them on v4 filesystems as we don't have to verify or
calculate CRCs for them.

There are some metadata types that have more than one buffer format,
or aren't based in directly in buffers. For these, leave the type
table verifier NULL for now - these will need to be addressed
individually.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c   | 13 +++++++---
 db/type.c | 88 ++++++++++++++++++++++++++++++++++-----------------------------
 db/type.h |  1 +
 3 files changed, 59 insertions(+), 43 deletions(-)

diff --git a/db/io.c b/db/io.c
index 9129963..c9452f2 100644
--- a/db/io.c
+++ b/db/io.c
@@ -480,12 +480,14 @@ set_cur(
 	xfs_ino_t	dirino;
 	xfs_ino_t	ino;
 	__uint16_t	mode;
+	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
 
 	if (iocur_sp < 0) {
 		dbprintf(_("set_cur no stack element to set\n"));
 		return;
 	}
 
+
 	ino = iocur_top->ino;
 	dirino = iocur_top->dirino;
 	mode = iocur_top->mode;
@@ -507,12 +509,17 @@ set_cur(
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
 		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
-					bbmap->nmaps, 0, NULL);
+					bbmap->nmaps, 0, ops);
 	} else {
-		bp = libxfs_readbuf(mp->m_ddev_targp, d, c, 0, NULL);
+		bp = libxfs_readbuf(mp->m_ddev_targp, d, c, 0, ops);
 		iocur_top->bbmap = NULL;
 	}
-	if (!bp || bp->b_error)
+
+	/*
+	 * keep the buffer even if the verifier says it is corrupted.
+	 * We're a diagnostic tool, after all.
+	 */
+	if (!bp || (bp->b_error && bp->b_error != EFSCORRUPTED))
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;
diff --git a/db/type.c b/db/type.c
index 64e2ef4..b3f3d87 100644
--- a/db/type.c
+++ b/db/type.c
@@ -50,50 +50,58 @@ static const cmdinfo_t	type_cmd =
 	  N_("set/show current data type"), NULL };
 
 static const typ_t	__typtab[] = {
-	{ TYP_AGF, "agf", handle_struct, agf_hfld },
-	{ TYP_AGFL, "agfl", handle_struct, agfl_hfld },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld },
-	{ TYP_ATTR, "attr", handle_struct, attr_hfld },
-	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_hfld },
-	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld },
-	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld },
-	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld },
-	{ TYP_DATA, "data", handle_block, NULL },
-	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld },
-	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld },
-	{ TYP_INOBT, "inobt", handle_struct, inobt_hfld },
-	{ TYP_INODATA, "inodata", NULL, NULL },
-	{ TYP_INODE, "inode", handle_struct, inode_hfld },
-	{ TYP_LOG, "log", NULL, NULL },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL },
-	{ TYP_SB, "sb", handle_struct, sb_hfld },
-	{ TYP_SYMLINK, "symlink", handle_string, NULL },
-	{ TYP_TEXT, "text", handle_text, NULL },
+	{ TYP_AGF, "agf", handle_struct, agf_hfld, NULL },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_hfld, NULL },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, NULL },
+	{ TYP_ATTR, "attr", handle_struct, attr_hfld, NULL },
+	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_hfld, NULL },
+	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld, NULL },
+	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL },
+	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL },
+	{ TYP_DATA, "data", handle_block, NULL, NULL },
+	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL },
+	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld, NULL },
+	{ TYP_INOBT, "inobt", handle_struct, inobt_hfld, NULL },
+	{ TYP_INODATA, "inodata", NULL, NULL, NULL },
+	{ TYP_INODE, "inode", handle_struct, inode_hfld, NULL },
+	{ TYP_LOG, "log", NULL, NULL, NULL },
+	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL },
+	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL },
+	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL },
+	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL },
+	{ TYP_TEXT, "text", handle_text, NULL, NULL },
 	{ TYP_NONE, NULL }
 };
 
 static const typ_t	__typtab_crc[] = {
-	{ TYP_AGF, "agf", handle_struct, agf_hfld },
-	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld },
-	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld },
-	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld },
-	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld },
-	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld },
-	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld },
-	{ TYP_DATA, "data", handle_block, NULL },
-	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld },
-	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld },
-	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld },
-	{ TYP_INODATA, "inodata", NULL, NULL },
-	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld },
-	{ TYP_LOG, "log", NULL, NULL },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL },
-	{ TYP_SB, "sb", handle_struct, sb_hfld },
-	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld },
-	{ TYP_TEXT, "text", handle_text, NULL },
+	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
+	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld, NULL },
+	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
+		&xfs_bmbt_buf_ops },
+	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
+		&xfs_bmbt_buf_ops },
+	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld,
+		&xfs_allocbt_buf_ops },
+	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
+		&xfs_allocbt_buf_ops },
+	{ TYP_DATA, "data", handle_block, NULL, NULL },
+	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld, NULL },
+	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
+		&xfs_dquot_buf_ops },
+	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld,
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
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index c41aca4d..3bb26f1 100644
--- a/db/type.h
+++ b/db/type.h
@@ -42,6 +42,7 @@ typedef struct typ
 	char			*name;
 	pfunc_t			pfunc;
 	const struct field	*fields;
+	const struct xfs_buf_ops *bops;
 } typ_t;
 extern const typ_t	*typtab, *cur_typ;
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
