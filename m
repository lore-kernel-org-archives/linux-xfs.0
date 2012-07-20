Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KN4gBb165658 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 18:04:43 -0500
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id m5jkk4q9tgGGMSMB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Jul 2012 16:04:41 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 20 Jul 2012 19:04:31 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 9B01F6E8036
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 19:04:23 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q6KN4NZv252456 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 19:04:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q6L4Z6X1021862 for <xfs@oss.sgi.com>; Sat, 21 Jul 2012 00:35:06 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 20 Jul 2012 18:04:02 -0500
Message-Id: <20120720230402.20689.84149.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120720230350.20689.40213.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120720230350.20689.40213.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 2/4] xfsprogs: Add new field pquotaino to  on disk superblock
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Add a new field sb_pquotino to the on-disk superblock data structure
and add accompanying code.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 db/check.c          |   12 +++++++-----
 db/dquot.c          |    7 +++----
 db/frag.c           |    3 ++-
 db/inode.c          |    3 ++-
 db/metadump.c       |    5 ++++-
 db/sb.c             |    1 +
 include/xfs_sb.h    |    7 +++++--
 libxfs/xfs_mount.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/agheader.c   |   13 +++++++++++++
 repair/dinode.c     |    9 +++++++++
 repair/dir.c        |   22 ++++++++++++++++++++++
 repair/dir2.c       |    5 +++++
 repair/globals.h    |    1 +
 repair/phase4.c     |   29 ++++++++++++++++++++++-------
 repair/phase6.c     |    9 +++++++++
 repair/sb.c         |    3 +++
 repair/versions.c   |    5 +++++
 repair/xfs_repair.c |    2 +-
 18 files changed, 165 insertions(+), 22 deletions(-)

diff --git a/db/check.c b/db/check.c
index f00fae7..f5b8b9f 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1831,7 +1831,8 @@ init(
 	if (mp->m_sb.sb_inoalignmt)
 		sbversion |= XFS_SB_VERSION_ALIGNBIT;
 	if ((mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO) ||
-	    (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO))
+	    (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO) ||
+	    (mp->m_sb.sb_pquotino && mp->m_sb.sb_pquotino != NULLFSINO))
 		sbversion |= XFS_SB_VERSION_QUOTABIT;
 	quota_init();
 	return 1;
@@ -2764,7 +2765,8 @@ process_inode(
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
-			 id->ino == mp->m_sb.sb_gquotino) {
+			 id->ino == mp->m_sb.sb_gquotino ||
+			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
 			blkmap = blkmap_alloc(idic.di_nextents);
 			addlink_inode(id);
@@ -2885,7 +2887,7 @@ process_inode(
 			 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
 			 (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD))
 			process_quota(IS_GROUP_QUOTA, id, blkmap);
-		else if (id->ino == mp->m_sb.sb_gquotino &&
+		else if (id->ino == mp->m_sb.sb_pquotino &&
 			 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
 			 (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD))
 			process_quota(IS_PROJECT_QUOTA, id, blkmap);
@@ -3897,8 +3899,8 @@ quota_init(void)
 	       mp->m_sb.sb_gquotino != NULLFSINO &&
 	       (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
 	       (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD);
-	qpdo = mp->m_sb.sb_gquotino != 0 &&
-	       mp->m_sb.sb_gquotino != NULLFSINO &&
+	qpdo = mp->m_sb.sb_pquotino != 0 &&
+	       mp->m_sb.sb_pquotino != NULLFSINO &&
 	       (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
 	       (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD);
 	if (qudo)
diff --git a/db/dquot.c b/db/dquot.c
index daa47a3..201d9a8 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -130,10 +130,9 @@ dquot_f(
 		dbprintf(_("dquot command requires one %s id argument\n"), s);
 		return 0;
 	}
-	ino = (dogrp || doprj) ? mp->m_sb.sb_gquotino : mp->m_sb.sb_uquotino;
-	if (ino == 0 || ino == NULLFSINO ||
-	    (dogrp && (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT)) ||
-	    (doprj && (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))) {
+	ino = doprj ? mp->m_sb.sb_pquotino :
+			dogrp ? mp->m_sb.sb_gquotino : mp->m_sb.sb_uquotino;
+	if (ino == 0 || ino == NULLFSINO) {
 		dbprintf(_("no %s quota inode present\n"), s);
 		return 0;
 	}
diff --git a/db/frag.c b/db/frag.c
index 23ccfa5..2eb33d8 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -326,7 +326,8 @@ process_inode(
 			skipd = 1;
 		else if (!qflag &&
 			 (ino == mp->m_sb.sb_uquotino ||
-			  ino == mp->m_sb.sb_gquotino))
+			  ino == mp->m_sb.sb_gquotino ||
+			  ino == mp->m_sb.sb_pquotino))
 			skipd = 1;
 		else
 			skipd = !fflag;
diff --git a/db/inode.c b/db/inode.c
index 036717f..ef8bdee 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -413,7 +413,8 @@ inode_next_type(void)
 		else if (iocur_top->ino == mp->m_sb.sb_rsumino)
 			return TYP_RTSUMMARY;
 		else if (iocur_top->ino == mp->m_sb.sb_uquotino ||
-			 iocur_top->ino == mp->m_sb.sb_gquotino)
+			 iocur_top->ino == mp->m_sb.sb_gquotino ||
+			 iocur_top->ino == mp->m_sb.sb_pquotino)
 			return TYP_DQBLK;
 		else
 			return TYP_DATA;
diff --git a/db/metadump.c b/db/metadump.c
index c5ffddb..70aeb42 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1940,7 +1940,10 @@ copy_sb_inodes(void)
 	if (!copy_ino(mp->m_sb.sb_uquotino, TYP_DQBLK))
 		return 0;
 
-	return copy_ino(mp->m_sb.sb_gquotino, TYP_DQBLK);
+	if (!copy_ino(mp->m_sb.sb_gquotino, TYP_DQBLK))
+		return 0;
+
+	return copy_ino(mp->m_sb.sb_pquotino, TYP_DQBLK);
 }
 
 static int
diff --git a/db/sb.c b/db/sb.c
index 21f38c5..2bc96a9 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -109,6 +109,7 @@ const field_t	sb_flds[] = {
 	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
 	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
 	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)), C1, 0, TYP_NONE },
+	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ NULL }
 };
 
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 69c6822..735c5eb 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -161,6 +161,7 @@ typedef struct xfs_sb {
 	 * it for anything else.
 	 */
 	__uint32_t	sb_bad_features2;
+	xfs_ino_t	sb_pquotino;	/* project quota inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -231,6 +232,7 @@ typedef struct xfs_dsb {
 	 * it for anything else.
 	 */
 	__be32	sb_bad_features2;
+	__be64	sb_pquotino;		/* project quota inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -251,7 +253,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_PQUOTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -277,6 +279,7 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -284,7 +287,7 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2)
+	 XFS_SB_BAD_FEATURES2 | XFS_SB_PQUOTINO)
 
 
 /*
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index 32d2255..dd193ba 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -70,6 +70,7 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_pquotino),   0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -156,6 +157,23 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+
+	if (xfs_sb_version_hasnooquota(to))
+		to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
+	else {
+		if (to->sb_qflags & XFS_OQUOTA_ENFD)
+			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+						XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+		if (to->sb_qflags & XFS_OQUOTA_CHKD)
+			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+						XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+		to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+			
+		if (to->sb_qflags & XFS_PQUOTA_ACCT) {
+			to->sb_pquotino = to->sb_gquotino;
+			to->sb_gquotino = 0;
+		}
+	}
 }
 
 /*
@@ -174,11 +192,36 @@ xfs_sb_to_disk(
 	xfs_sb_field_t	f;
 	int		first;
 	int		size;
+	__be16		saved_qflags = 0;
 
 	ASSERT(fields);
 	if (!fields)
 		return;
 
+	if (!xfs_sb_version_hasnooquota(from) &&
+		    (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD))) {
+
+		if (from->sb_qflags & XFS_PQUOTA_ACCT) {
+			from->sb_gquotino = from->sb_pquotino;
+			from->sb_pquotino = 0;
+		}
+		/*
+		 * in-core version of qflags do not have XFS_OQUOTA.*, whereas
+		 * the on-disk version does. So, save the in-core sb_qflags
+		 * and restore it after we modify and copy it to the buffer
+		 * to be copied to disk.
+		 */
+		saved_qflags = from->sb_qflags;
+
+		if (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
+			from->sb_qflags |= XFS_OQUOTA_ENFD;
+		if (from->sb_qflags & (XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
+			from->sb_qflags |= XFS_OQUOTA_CHKD;
+		from->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
+ 	}
+
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -209,6 +252,14 @@ xfs_sb_to_disk(
 
 		fields &= ~(1LL << f);
 	}
+	/* Revert to the old saved values */
+	if (saved_qflags) {
+		from->sb_qflags = saved_qflags;
+		if (from->sb_qflags & XFS_PQUOTA_ACCT) {
+			from->sb_pquotino = from->sb_gquotino;
+			from->sb_gquotino = 0;
+		}
+	}
 }
 
 /*
diff --git a/repair/agheader.c b/repair/agheader.c
index 6081b68..04474e3 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -331,6 +331,19 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (sb->sb_inprogress == 1 && sb->sb_pquotino)  {
+		if (!no_modify)
+			sb->sb_pquotino = 0;
+		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
+			rval |= XR_AG_SB;
+			do_warn(
+		_("non-null project quota inode field in superblock %d\n"),
+				i);
+
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
 	if (sb->sb_inprogress == 1 && sb->sb_qflags)  {
 		if (!no_modify)
 			sb->sb_qflags = 0;
diff --git a/repair/dinode.c b/repair/dinode.c
index 9c5db99..533f287 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1813,6 +1813,15 @@ process_check_sb_inodes(
 		}
 		return 0;
 	}
+	if (lino == mp->m_sb.sb_pquotino)  {
+		if (*type != XR_INO_DATA)  {
+			do_warn(_("project quota inode %" PRIu64 " has bad type 0x%x\n"),
+				lino, dinode_fmt(dinoc));
+			mp->m_sb.sb_pquotino = NULLFSINO;
+			return 1;
+		}
+		return 0;
+	}
 	if (lino == mp->m_sb.sb_rsumino) {
 		if (*type != XR_INO_RTSUM) {
 			do_warn(
diff --git a/repair/dir.c b/repair/dir.c
index 5a58b94..892c86a 100644
--- a/repair/dir.c
+++ b/repair/dir.c
@@ -173,6 +173,11 @@ process_shortform_dir(
 	_("entry in shortform dir %" PRIu64 " references group quota inode %" PRIu64 "\n"),
 				ino, lino);
 			junkit = 1;
+		} else if (lino == mp->m_sb.sb_pquotino)  {
+			do_warn(
+	_("entry in shortform dir %" PRIu64 " references project quota inode %" PRIu64 "\n"),
+				ino, lino);
+			junkit = 1;
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL)  {
@@ -1659,6 +1664,23 @@ _("entry #%d, bno %d in directory %" PRIu64 " references group quota inode %" PR
 				_("\twould clear ino number in entry %d...\n"),
 					i);
 			}
+		} else if (lino == mp->m_sb.sb_pquotino)  {
+			do_warn(
+_("entry #%d, bno %d in directory %" PRIu64 " references project quota inode %" PRIu64 "\n"),
+				i, da_bno, ino, lino);
+			if (!no_modify)  {
+				do_warn(
+				_("\tclearing ino number in entry %d...\n"),
+					i);
+
+				lino = NULLFSINO;
+				xfs_dir_sf_put_dirino(&lino, &namest->inumber);
+				*buf_dirty = 1;
+			} else  {
+				do_warn(
+				_("\twould clear ino number in entry %d...\n"),
+					i);
+			}
 		} else if ((irec_p = find_inode_rec(mp,
 				XFS_INO_TO_AGNO(mp, lino),
 				XFS_INO_TO_AGINO(mp, lino))) != NULL)  {
diff --git a/repair/dir2.c b/repair/dir2.c
index 7164f7f..a8a957b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -932,6 +932,9 @@ process_sf_dir2(
 		} else if (lino == mp->m_sb.sb_gquotino)  {
 			junkit = 1;
 			junkreason = _("group quota");
+		} else if (lino == mp->m_sb.sb_pquotino)  {
+			junkit = 1;
+			junkreason = _("project quota");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -1448,6 +1451,8 @@ process_dir2_data(
 			clearreason = _("user quota");
 		} else if (ent_ino == mp->m_sb.sb_gquotino) {
 			clearreason = _("group quota");
+		} else if (ent_ino == mp->m_sb.sb_pquotino) {
+			clearreason = _("project quota");
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),
diff --git a/repair/globals.h b/repair/globals.h
index 5fb8149..3d3b885 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -137,6 +137,7 @@ EXTERN int		need_rsumino;
 EXTERN int		lost_quotas;
 EXTERN int		have_uquotino;
 EXTERN int		have_gquotino;
+EXTERN int		have_pquotino;
 EXTERN int		lost_uquotino;
 EXTERN int		lost_gquotino;
 EXTERN int		lost_pquotino;
diff --git a/repair/phase4.c b/repair/phase4.c
index 9f08486..392a864 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -72,12 +72,25 @@ quotino_check(xfs_mount_t *mp)
 		if (irec == NULL || is_inode_free(irec,
 				mp->m_sb.sb_gquotino - irec->ino_startnum))  {
 			mp->m_sb.sb_gquotino = NULLFSINO;
-			if (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT)
-				lost_gquotino = 1;
-			else
-				lost_pquotino = 1;
+			lost_gquotino = 1;
 		} else
-			lost_gquotino = lost_pquotino = 0;
+			lost_gquotino = 0;
+	}
+
+	if (mp->m_sb.sb_pquotino != NULLFSINO && mp->m_sb.sb_pquotino != 0)  {
+		if (verify_inum(mp, mp->m_sb.sb_pquotino))
+			irec = NULL;
+		else
+			irec = find_inode_rec(mp,
+				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_pquotino),
+				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
+
+		if (irec == NULL || is_inode_free(irec,
+				mp->m_sb.sb_pquotino - irec->ino_startnum))  {
+			mp->m_sb.sb_pquotino = NULLFSINO;
+			lost_pquotino = 1;
+		} else
+			lost_pquotino = 0;
 	}
 }
 
@@ -105,11 +118,13 @@ quota_sb_check(xfs_mount_t *mp)
 
 	if (fs_quotas &&
 	    (mp->m_sb.sb_uquotino == NULLFSINO || mp->m_sb.sb_uquotino == 0) &&
-	    (mp->m_sb.sb_gquotino == NULLFSINO || mp->m_sb.sb_gquotino == 0))  {
+	    (mp->m_sb.sb_gquotino == NULLFSINO || mp->m_sb.sb_gquotino == 0) &&
+	    (mp->m_sb.sb_pquotino == NULLFSINO || mp->m_sb.sb_pquotino == 0))  {
 		lost_quotas = 1;
 		fs_quotas = 0;
 	} else if (!verify_inum(mp, mp->m_sb.sb_uquotino) &&
-			!verify_inum(mp, mp->m_sb.sb_gquotino)) {
+			!verify_inum(mp, mp->m_sb.sb_gquotino) &&
+			!verify_inum(mp, mp->m_sb.sb_pquotino)) {
 		fs_quotas = 1;
 	}
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 5b27cb4..17e0eb6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3564,6 +3564,15 @@ mark_standalone_inodes(xfs_mount_t *mp)
 					- irec->ino_startnum;
 			add_inode_reached(irec, offset);
 		}
+		if (mp->m_sb.sb_pquotino
+				&& mp->m_sb.sb_pquotino != NULLFSINO)  {
+			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
+						mp->m_sb.sb_pquotino),
+				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
+			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino)
+					- irec->ino_startnum;
+			add_inode_reached(irec, offset);
+		}
 	}
 }
 
diff --git a/repair/sb.c b/repair/sb.c
index 004319f..c07a63d 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -40,6 +40,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	xfs_ino_t	rsumino;
 	xfs_ino_t	uquotino;
 	xfs_ino_t	gquotino;
+	xfs_ino_t	pquotino;
 	__uint16_t	versionnum;
 
 	rootino = dest->sb_rootino;
@@ -47,6 +48,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	rsumino = dest->sb_rsumino;
 	uquotino = dest->sb_uquotino;
 	gquotino = dest->sb_gquotino;
+	pquotino = dest->sb_pquotino;
 
 	versionnum = dest->sb_versionnum;
 
@@ -57,6 +59,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	dest->sb_rsumino = rsumino;
 	dest->sb_uquotino = uquotino;
 	dest->sb_gquotino = gquotino;
+	dest->sb_pquotino = pquotino;
 
 	dest->sb_versionnum = versionnum;
 
diff --git a/repair/versions.c b/repair/versions.c
index e37eb10..991c05e 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -117,6 +117,7 @@ parse_sb_version(xfs_sb_t *sb)
 	fs_has_extflgbit = 0;
 	have_uquotino = 0;
 	have_gquotino = 0;
+	have_pquotino = 0;
 	issue_warning = 0;
 
 	/*
@@ -253,6 +254,10 @@ _("WARNING:  you have disallowed quotas but this filesystem\n"
 			if (sb->sb_gquotino != 0 &&
 					sb->sb_gquotino != NULLFSINO)
 				have_gquotino = 1;
+
+			if (sb->sb_pquotino != 0 &&
+					sb->sb_pquotino != NULLFSINO)
+				have_pquotino = 1;
 		}
 	}
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 0b82e8e..edc63ed 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -779,7 +779,7 @@ main(int argc, char **argv)
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
 	}
 
-	if (lost_quotas && !have_uquotino && !have_gquotino)  {
+	if (lost_quotas && !have_uquotino && !have_gquotino && !have_pquotino) {
 		if (!no_modify)  {
 			do_warn(
 _("Warning:  no quota inodes were found.  Quotas disabled.\n"));
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
