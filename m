Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 494DD29DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 14:26:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E751304066
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 12:25:59 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id QUpseXecSwx4zY0j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 12:25:51 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 1 Aug 2013 13:25:50 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id E17B71FF001C
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 13:20:23 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r71JPOHn157618 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 13:25:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r71JPKdR019006
	for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 13:25:20 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/2] xfsprogs: Start using pquotaino from on-disk superblock
Date: Thu,  1 Aug 2013 14:25:01 -0500
Message-Id: <1375385101-3673-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Start using the new field sb_pquotino from the on-disk superblock if the
version of the superblock supports separate pquotino.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 db/check.c          |   12 +++++++-----
 db/dquot.c          |   11 +++++++----
 db/frag.c           |    3 ++-
 db/inode.c          |    3 ++-
 db/metadump.c       |    5 ++++-
 include/xfs_sb.h    |    5 +++++
 libxfs/xfs_mount.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c     |    2 +-
 repair/agheader.c   |   13 +++++++++++++
 repair/dinode.c     |    9 +++++++++
 repair/dir2.c       |    5 +++++
 repair/globals.h    |    1 +
 repair/phase4.c     |   29 ++++++++++++++++++++++-------
 repair/phase6.c     |    9 +++++++++
 repair/sb.c         |    3 +++
 repair/versions.c   |    5 +++++
 repair/xfs_repair.c |    2 +-
 17 files changed, 138 insertions(+), 21 deletions(-)

diff --git a/db/check.c b/db/check.c
index d66dc68..cbe55ba 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1835,7 +1835,8 @@ init(
 	if (mp->m_sb.sb_inoalignmt)
 		sbversion |= XFS_SB_VERSION_ALIGNBIT;
 	if ((mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO) ||
-	    (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO))
+	    (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO) ||
+	    (mp->m_sb.sb_pquotino && mp->m_sb.sb_pquotino != NULLFSINO))
 		sbversion |= XFS_SB_VERSION_QUOTABIT;
 	quota_init();
 	return 1;
@@ -2732,7 +2733,8 @@ process_inode(
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
-			 id->ino == mp->m_sb.sb_gquotino) {
+			 id->ino == mp->m_sb.sb_gquotino ||
+			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
 			blkmap = blkmap_alloc(idic.di_nextents);
 			addlink_inode(id);
@@ -2853,7 +2855,7 @@ process_inode(
 			 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
 			 (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD))
 			process_quota(IS_GROUP_QUOTA, id, blkmap);
-		else if (id->ino == mp->m_sb.sb_gquotino &&
+		else if (id->ino == mp->m_sb.sb_pquotino &&
 			 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
 			 (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD))
 			process_quota(IS_PROJECT_QUOTA, id, blkmap);
@@ -3624,8 +3626,8 @@ quota_init(void)
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
index 35eb0bd..6927956 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -133,10 +133,13 @@ dquot_f(
 		dbprintf(_("dquot command requires one %s id argument\n"), s);
 		return 0;
 	}
-	ino = (dogrp || doprj) ? mp->m_sb.sb_gquotino : mp->m_sb.sb_uquotino;
-	if (ino == 0 || ino == NULLFSINO ||
-	    (dogrp && (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT)) ||
-	    (doprj && (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))) {
+	ino = mp->m_sb.sb_uquotino;
+	if (doprj)
+		ino = mp->m_sb.sb_pquotino;
+	else if (dogrp)
+		ino = mp->m_sb.sb_gquotino;
+
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
index 68ef564..eafbbd5 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -438,7 +438,8 @@ inode_next_type(void)
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
index 1c8020b..a170bb5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1976,7 +1976,10 @@ copy_sb_inodes(void)
 	if (!copy_ino(mp->m_sb.sb_uquotino, TYP_DQBLK))
 		return 0;
 
-	return copy_ino(mp->m_sb.sb_gquotino, TYP_DQBLK);
+	if (!copy_ino(mp->m_sb.sb_gquotino, TYP_DQBLK))
+		return 0;
+
+	return copy_ino(mp->m_sb.sb_pquotino, TYP_DQBLK);
 }
 
 static int
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 51db6f2..4a710d6 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -625,6 +625,11 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index e7a9003..8b267bc 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -326,6 +326,13 @@ xfs_sb_from_disk(
 static void
 xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 {
+	/*
+	 * We need to do these manipilations only if we are working
+	 * with an older version of on-disk superblock.
+	 */
+	if (xfs_sb_version_has_pquotino(sbp))
+		return;
+
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
@@ -333,6 +340,18 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
 	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
+	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
+		/*
+		 * In older version of superblock, on-disk superblock only
+		 * has sb_gquotino, and in-core superblock has both sb_gquotino
+		 * and sb_pquotino. But, only one of them is supported at any
+		 * point of time. So, if PQUOTA is set in disk superblock,
+		 * copy over sb_gquotino to sb_pquotino.
+		 */
+		sbp->sb_pquotino = sbp->sb_gquotino;
+		sbp->sb_gquotino = NULLFSINO;
+	}
 }
 
 static inline void
@@ -343,6 +362,13 @@ xfs_sb_quota_to_disk(
 {
 	__uint16_t	qflags = from->sb_qflags;
 
+	/*
+	 * We need to do these manipilations only if we are working
+	 * with an older version of on-disk superblock.
+	 */
+	if (xfs_sb_version_has_pquotino(from))
+		return;
+
 	if (*fields & XFS_SB_QFLAGS) {
 		/*
 		 * The in-core version of sb_qflags do not have
@@ -362,6 +388,21 @@ xfs_sb_quota_to_disk(
 		to->sb_qflags = cpu_to_be16(qflags);
 		*fields &= ~XFS_SB_QFLAGS;
 	}
+
+	/*
+	 * GQUOTINO and PQUOTINO cannot be used together in versions
+	 * of superblock that do not have pquotino. from->sb_flags
+	 * tells us which quota is active and should be copied to
+	 * disk.
+	 */
+	if ((*fields & XFS_SB_GQUOTINO) &&
+				(from->sb_qflags & XFS_GQUOTA_ACCT))
+		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
+	else if ((*fields & XFS_SB_PQUOTINO) &&
+				(from->sb_qflags & XFS_PQUOTA_ACCT))
+		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
+
+	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
 }
 
 /*
@@ -386,6 +427,7 @@ xfs_sb_to_disk(
 		return;
 
 	xfs_sb_quota_to_disk(to, from, &fields);
+
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bb5d8d4..4bdacee 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2477,7 +2477,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
-	sbp->sb_uquotino = sbp->sb_gquotino = 0;
+	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = dsunit;
 	sbp->sb_width = dswidth;
diff --git a/repair/agheader.c b/repair/agheader.c
index bc8b1bf..76a2ce1 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -362,6 +362,19 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
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
index b0f1396..ed0ca37 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1812,6 +1812,15 @@ process_check_sb_inodes(
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
diff --git a/repair/dir2.c b/repair/dir2.c
index 2ca7fd1..05bd4b7 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -817,6 +817,9 @@ process_sf_dir2(
 		} else if (lino == mp->m_sb.sb_gquotino)  {
 			junkit = 1;
 			junkreason = _("group quota");
+		} else if (lino == mp->m_sb.sb_pquotino)  {
+			junkit = 1;
+			junkreason = _("project quota");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -1332,6 +1335,8 @@ process_dir2_data(
 			clearreason = _("user quota");
 		} else if (ent_ino == mp->m_sb.sb_gquotino) {
 			clearreason = _("group quota");
+		} else if (ent_ino == mp->m_sb.sb_pquotino) {
+			clearreason = _("project quota");
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),
diff --git a/repair/globals.h b/repair/globals.h
index e01e4e9..aef8b79 100644
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
index a6c7a5e..a822aaa 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -71,12 +71,25 @@ quotino_check(xfs_mount_t *mp)
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
 
@@ -104,11 +117,13 @@ quota_sb_check(xfs_mount_t *mp)
 
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
index 2905a1c..794753e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2783,6 +2783,15 @@ mark_standalone_inodes(xfs_mount_t *mp)
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
index c7786b5..e2f5933 100644
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
index b65747a..c1dff72 100644
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
index ab06201..820e7a2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -775,7 +775,7 @@ main(int argc, char **argv)
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
