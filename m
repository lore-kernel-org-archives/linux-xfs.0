Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 232F47F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 09:51:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10DDA304043
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 07:51:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VCTURWXD6ISr8ASh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 07:51:52 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1NFppHJ009426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:52 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1NFppXG019008
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfsprogs: remove bitfield based superblock updates
Date: Mon, 23 Feb 2015 10:51:48 -0500
Message-Id: <1424706709-21594-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
References: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
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

This is a backport of the following kernel commit:

4d11a4023940 xfs: remove bitfield based superblock updates

... which kills the per-field superblock logging mechanism in shared
libxfs code. Also update the callers of the old code throughout xfsprogs
to no longer pass the associated bitfield logging parameter to the
updated libxfs_sb_to_disk() and xfs_mod_sb() functions.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/sb.c                   |   9 +-
 libxfs/support/trans.c    |   2 +-
 libxfs/xfs_attr_leaf.c    |   2 +-
 libxfs/xfs_bmap.c         |  14 +--
 libxfs/xfs_sb.c           | 277 ++++++++++++++++------------------------------
 libxfs/xfs_sb.h           |  10 +-
 mdrestore/xfs_mdrestore.c |   2 +-
 mkfs/proto.c              |   6 +-
 mkfs/xfs_mkfs.c           |   4 +-
 repair/phase5.c           |   2 +-
 repair/sb.c               |   2 +-
 repair/scan.c             |   2 +-
 12 files changed, 121 insertions(+), 211 deletions(-)

diff --git a/db/sb.c b/db/sb.c
index 38f74f8..1b8b6d5 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -335,7 +335,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 	}
 	/* set uuid */
 	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
-	libxfs_sb_to_disk(iocur_top->data, &tsb, XFS_SB_UUID);
+	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
 	return uuid;
 }
@@ -488,7 +488,7 @@ do_label(xfs_agnumber_t agno, char *label)
 	memset(&tsb.sb_fname, 0, sizeof(tsb.sb_fname));
 	memcpy(&tsb.sb_fname, label, len);
 	memcpy(&lbl[0], &tsb.sb_fname, sizeof(tsb.sb_fname));
-	libxfs_sb_to_disk(iocur_top->data, &tsb, XFS_SB_FNAME);
+	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
 	return &lbl[0];
 }
@@ -569,7 +569,6 @@ static int
 do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
 {
 	xfs_sb_t	tsb;
-	__int64_t	fields = 0;
 
 	if (!get_sb(agno, &tsb))
 		return 0;
@@ -583,14 +582,12 @@ do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
 	if ((version & XFS_SB_VERSION_LOGV2BIT) &&
 					!xfs_sb_version_haslogv2(&tsb)) {
 		tsb.sb_logsunit = 1;
-		fields |= (1LL << XFS_SBS_LOGSUNIT);
 	}
 
 	tsb.sb_versionnum = version;
 	tsb.sb_features2 = features;
 	tsb.sb_bad_features2 = features;
-	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
-	libxfs_sb_to_disk(iocur_top->data, &tsb, fields);
+	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
 	return 1;
 }
diff --git a/libxfs/support/trans.c b/libxfs/support/trans.c
index 2447764..bf13127 100644
--- a/libxfs/support/trans.c
+++ b/libxfs/support/trans.c
@@ -845,7 +845,7 @@ libxfs_trans_commit(
 			sbp->sb_fdblocks += tp->t_fdblocks_delta;
 		if (tp->t_frextents_delta)
 			sbp->sb_frextents += tp->t_frextents_delta;
-		xfs_mod_sb(tp, XFS_SB_ALL_BITS);
+		xfs_mod_sb(tp);
 	}
 
 #ifdef XACT_DEBUG
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 714c257..8d38a04 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -399,7 +399,7 @@ xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
 			xfs_sb_version_addattr2(&mp->m_sb);
 			spin_unlock(&mp->m_sb_lock);
-			xfs_mod_sb(tp, XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
+			xfs_mod_sb(tp);
 		} else
 			spin_unlock(&mp->m_sb_lock);
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c4e9da6..cf500a6 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1213,22 +1213,20 @@ xfs_bmap_add_attrfork(
 		goto bmap_cancel;
 	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
 	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
-		__int64_t sbfields = 0;
+		bool mod_sb = false;
 
 		spin_lock(&mp->m_sb_lock);
 		if (!xfs_sb_version_hasattr(&mp->m_sb)) {
 			xfs_sb_version_addattr(&mp->m_sb);
-			sbfields |= XFS_SB_VERSIONNUM;
+			mod_sb = true;
 		}
 		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
 			xfs_sb_version_addattr2(&mp->m_sb);
-			sbfields |= (XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
+			mod_sb = true;
 		}
-		if (sbfields) {
-			spin_unlock(&mp->m_sb_lock);
-			xfs_mod_sb(tp, sbfields);
-		} else
-			spin_unlock(&mp->m_sb_lock);
+		spin_unlock(&mp->m_sb_lock);
+		if (mod_sb)
+			xfs_mod_sb(tp);
 	}
 
 	error = xfs_bmap_finish(&tp, &flist, &committed);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 4d41d42..05f0c94 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -38,69 +38,6 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
-static const struct {
-	short offset;
-	short type;	/* 0 = integer
-			 * 1 = binary / string (no translation)
-			 */
-} xfs_sb_info[] = {
-	{ offsetof(xfs_sb_t, sb_magicnum),	0 },
-	{ offsetof(xfs_sb_t, sb_blocksize),	0 },
-	{ offsetof(xfs_sb_t, sb_dblocks),	0 },
-	{ offsetof(xfs_sb_t, sb_rblocks),	0 },
-	{ offsetof(xfs_sb_t, sb_rextents),	0 },
-	{ offsetof(xfs_sb_t, sb_uuid),		1 },
-	{ offsetof(xfs_sb_t, sb_logstart),	0 },
-	{ offsetof(xfs_sb_t, sb_rootino),	0 },
-	{ offsetof(xfs_sb_t, sb_rbmino),	0 },
-	{ offsetof(xfs_sb_t, sb_rsumino),	0 },
-	{ offsetof(xfs_sb_t, sb_rextsize),	0 },
-	{ offsetof(xfs_sb_t, sb_agblocks),	0 },
-	{ offsetof(xfs_sb_t, sb_agcount),	0 },
-	{ offsetof(xfs_sb_t, sb_rbmblocks),	0 },
-	{ offsetof(xfs_sb_t, sb_logblocks),	0 },
-	{ offsetof(xfs_sb_t, sb_versionnum),	0 },
-	{ offsetof(xfs_sb_t, sb_sectsize),	0 },
-	{ offsetof(xfs_sb_t, sb_inodesize),	0 },
-	{ offsetof(xfs_sb_t, sb_inopblock),	0 },
-	{ offsetof(xfs_sb_t, sb_fname[0]),	1 },
-	{ offsetof(xfs_sb_t, sb_blocklog),	0 },
-	{ offsetof(xfs_sb_t, sb_sectlog),	0 },
-	{ offsetof(xfs_sb_t, sb_inodelog),	0 },
-	{ offsetof(xfs_sb_t, sb_inopblog),	0 },
-	{ offsetof(xfs_sb_t, sb_agblklog),	0 },
-	{ offsetof(xfs_sb_t, sb_rextslog),	0 },
-	{ offsetof(xfs_sb_t, sb_inprogress),	0 },
-	{ offsetof(xfs_sb_t, sb_imax_pct),	0 },
-	{ offsetof(xfs_sb_t, sb_icount),	0 },
-	{ offsetof(xfs_sb_t, sb_ifree),		0 },
-	{ offsetof(xfs_sb_t, sb_fdblocks),	0 },
-	{ offsetof(xfs_sb_t, sb_frextents),	0 },
-	{ offsetof(xfs_sb_t, sb_uquotino),	0 },
-	{ offsetof(xfs_sb_t, sb_gquotino),	0 },
-	{ offsetof(xfs_sb_t, sb_qflags),	0 },
-	{ offsetof(xfs_sb_t, sb_flags),		0 },
-	{ offsetof(xfs_sb_t, sb_shared_vn),	0 },
-	{ offsetof(xfs_sb_t, sb_inoalignmt),	0 },
-	{ offsetof(xfs_sb_t, sb_unit),		0 },
-	{ offsetof(xfs_sb_t, sb_width),		0 },
-	{ offsetof(xfs_sb_t, sb_dirblklog),	0 },
-	{ offsetof(xfs_sb_t, sb_logsectlog),	0 },
-	{ offsetof(xfs_sb_t, sb_logsectsize),	0 },
-	{ offsetof(xfs_sb_t, sb_logsunit),	0 },
-	{ offsetof(xfs_sb_t, sb_features2),	0 },
-	{ offsetof(xfs_sb_t, sb_bad_features2),	0 },
-	{ offsetof(xfs_sb_t, sb_features_compat),	0 },
-	{ offsetof(xfs_sb_t, sb_features_ro_compat),	0 },
-	{ offsetof(xfs_sb_t, sb_features_incompat),	0 },
-	{ offsetof(xfs_sb_t, sb_features_log_incompat),	0 },
-	{ offsetof(xfs_sb_t, sb_crc),		0 },
-	{ offsetof(xfs_sb_t, sb_pad),		0 },
-	{ offsetof(xfs_sb_t, sb_pquotino),	0 },
-	{ offsetof(xfs_sb_t, sb_lsn),		0 },
-	{ sizeof(xfs_sb_t),			0 }
-};
-
 /*
  * Reference counting access wrappers to the perag structures.
  * Because we never free per-ag structures, the only thing we
@@ -444,58 +381,49 @@ xfs_sb_from_disk(
 	__xfs_sb_from_disk(to, from, true);
 }
 
-static inline void
+static void
 xfs_sb_quota_to_disk(
-	xfs_dsb_t	*to,
-	xfs_sb_t	*from,
-	__int64_t	*fields)
+	struct xfs_dsb	*to,
+	struct xfs_sb	*from)
 {
 	__uint16_t	qflags = from->sb_qflags;
 
+	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
+	if (xfs_sb_version_has_pquotino(from)) {
+		to->sb_qflags = cpu_to_be16(from->sb_qflags);
+		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
+		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
+		return;
+	}
+
 	/*
-	 * We need to do these manipilations only if we are working
-	 * with an older version of on-disk superblock.
+	 * The in-core version of sb_qflags do not have XFS_OQUOTA_*
+	 * flags, whereas the on-disk version does.  So, convert incore
+	 * XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
 	 */
-	if (xfs_sb_version_has_pquotino(from))
-		return;
+	qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+			XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
 
-	if (*fields & XFS_SB_QFLAGS) {
-		/*
-		 * The in-core version of sb_qflags do not have
-		 * XFS_OQUOTA_* flags, whereas the on-disk version
-		 * does.  So, convert incore XFS_{PG}QUOTA_* flags
-		 * to on-disk XFS_OQUOTA_* flags.
-		 */
-		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
-				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
-
-		if (from->sb_qflags &
-				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
-			qflags |= XFS_OQUOTA_ENFD;
-		if (from->sb_qflags &
-				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
-			qflags |= XFS_OQUOTA_CHKD;
-		to->sb_qflags = cpu_to_be16(qflags);
-		*fields &= ~XFS_SB_QFLAGS;
-	}
+	if (from->sb_qflags &
+			(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
+		qflags |= XFS_OQUOTA_ENFD;
+	if (from->sb_qflags &
+			(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
+		qflags |= XFS_OQUOTA_CHKD;
+	to->sb_qflags = cpu_to_be16(qflags);
 
 	/*
-	 * GQUOTINO and PQUOTINO cannot be used together in versions of
-	 * superblock that do not have pquotino. from->sb_flags tells us which
-	 * quota is active and should be copied to disk. If neither are active,
-	 * make sure we write NULLFSINO to the sb_gquotino field as a quota
-	 * inode value of "0" is invalid when the XFS_SB_VERSION_QUOTA feature
-	 * bit is set.
+	 * GQUOTINO and PQUOTINO cannot be used together in versions
+	 * of superblock that do not have pquotino. from->sb_flags
+	 * tells us which quota is active and should be copied to
+	 * disk. If neither are active, we should NULL the inode.
 	 *
-	 * Note that we don't need to handle the sb_uquotino or sb_pquotino here
-	 * as they do not require any translation. Hence the main sb field loop
-	 * will write them appropriately from the in-core superblock.
+	 * In all cases, the separate pquotino must remain 0 because it
+	 * it beyond the "end" of the valid non-pquotino superblock.
 	 */
-	if ((*fields & XFS_SB_GQUOTINO) &&
-				(from->sb_qflags & XFS_GQUOTA_ACCT))
+	if (from->sb_qflags & XFS_GQUOTA_ACCT)
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
-	else if ((*fields & XFS_SB_PQUOTINO) &&
-				(from->sb_qflags & XFS_PQUOTA_ACCT))
+	else if (from->sb_qflags & XFS_PQUOTA_ACCT)
 		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
 	else {
 		/*
@@ -509,63 +437,72 @@ xfs_sb_quota_to_disk(
 			to->sb_gquotino = cpu_to_be64(NULLFSINO);
 	}
 
-	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
+	to->sb_pquotino = 0;
 }
 
-/*
- * Copy in core superblock to ondisk one.
- *
- * The fields argument is mask of superblock fields to copy.
- */
 void
 xfs_sb_to_disk(
-	xfs_dsb_t	*to,
-	xfs_sb_t	*from,
-	__int64_t	fields)
+	struct xfs_dsb	*to,
+	struct xfs_sb	*from)
 {
-	xfs_caddr_t	to_ptr = (xfs_caddr_t)to;
-	xfs_caddr_t	from_ptr = (xfs_caddr_t)from;
-	xfs_sb_field_t	f;
-	int		first;
-	int		size;
-
-	ASSERT(fields);
-	if (!fields)
-		return;
+	xfs_sb_quota_to_disk(to, from);
+
+	to->sb_magicnum = cpu_to_be32(from->sb_magicnum);
+	to->sb_blocksize = cpu_to_be32(from->sb_blocksize);
+	to->sb_dblocks = cpu_to_be64(from->sb_dblocks);
+	to->sb_rblocks = cpu_to_be64(from->sb_rblocks);
+	to->sb_rextents = cpu_to_be64(from->sb_rextents);
+	memcpy(&to->sb_uuid, &from->sb_uuid, sizeof(to->sb_uuid));
+	to->sb_logstart = cpu_to_be64(from->sb_logstart);
+	to->sb_rootino = cpu_to_be64(from->sb_rootino);
+	to->sb_rbmino = cpu_to_be64(from->sb_rbmino);
+	to->sb_rsumino = cpu_to_be64(from->sb_rsumino);
+	to->sb_rextsize = cpu_to_be32(from->sb_rextsize);
+	to->sb_agblocks = cpu_to_be32(from->sb_agblocks);
+	to->sb_agcount = cpu_to_be32(from->sb_agcount);
+	to->sb_rbmblocks = cpu_to_be32(from->sb_rbmblocks);
+	to->sb_logblocks = cpu_to_be32(from->sb_logblocks);
+	to->sb_versionnum = cpu_to_be16(from->sb_versionnum);
+	to->sb_sectsize = cpu_to_be16(from->sb_sectsize);
+	to->sb_inodesize = cpu_to_be16(from->sb_inodesize);
+	to->sb_inopblock = cpu_to_be16(from->sb_inopblock);
+	memcpy(&to->sb_fname, &from->sb_fname, sizeof(to->sb_fname));
+	to->sb_blocklog = from->sb_blocklog;
+	to->sb_sectlog = from->sb_sectlog;
+	to->sb_inodelog = from->sb_inodelog;
+	to->sb_inopblog = from->sb_inopblog;
+	to->sb_agblklog = from->sb_agblklog;
+	to->sb_rextslog = from->sb_rextslog;
+	to->sb_inprogress = from->sb_inprogress;
+	to->sb_imax_pct = from->sb_imax_pct;
+	to->sb_icount = cpu_to_be64(from->sb_icount);
+	to->sb_ifree = cpu_to_be64(from->sb_ifree);
+	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
+	to->sb_frextents = cpu_to_be64(from->sb_frextents);
 
-	/* We should never write the crc here, it's updated in the IO path */
-	fields &= ~XFS_SB_CRC;
-
-	xfs_sb_quota_to_disk(to, from, &fields);
-	while (fields) {
-		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
-		first = xfs_sb_info[f].offset;
-		size = xfs_sb_info[f + 1].offset - first;
-
-		ASSERT(xfs_sb_info[f].type == 0 || xfs_sb_info[f].type == 1);
-
-		if (size == 1 || xfs_sb_info[f].type == 1) {
-			memcpy(to_ptr + first, from_ptr + first, size);
-		} else {
-			switch (size) {
-			case 2:
-				*(__be16 *)(to_ptr + first) =
-				      cpu_to_be16(*(__u16 *)(from_ptr + first));
-				break;
-			case 4:
-				*(__be32 *)(to_ptr + first) =
-				      cpu_to_be32(*(__u32 *)(from_ptr + first));
-				break;
-			case 8:
-				*(__be64 *)(to_ptr + first) =
-				      cpu_to_be64(*(__u64 *)(from_ptr + first));
-				break;
-			default:
-				ASSERT(0);
-			}
-		}
 
-		fields &= ~(1LL << f);
+	to->sb_flags = from->sb_flags;
+	to->sb_shared_vn = from->sb_shared_vn;
+	to->sb_inoalignmt = cpu_to_be32(from->sb_inoalignmt);
+	to->sb_unit = cpu_to_be32(from->sb_unit);
+	to->sb_width = cpu_to_be32(from->sb_width);
+	to->sb_dirblklog = from->sb_dirblklog;
+	to->sb_logsectlog = from->sb_logsectlog;
+	to->sb_logsectsize = cpu_to_be16(from->sb_logsectsize);
+	to->sb_logsunit = cpu_to_be32(from->sb_logsunit);
+	to->sb_features2 = cpu_to_be32(from->sb_features2);
+	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
+
+	if (xfs_sb_version_hascrc(from)) {
+		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
+		to->sb_features_ro_compat =
+				cpu_to_be32(from->sb_features_ro_compat);
+		to->sb_features_incompat =
+				cpu_to_be32(from->sb_features_incompat);
+		to->sb_features_log_incompat =
+				cpu_to_be32(from->sb_features_log_incompat);
+		to->sb_pad = 0;
+		to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	}
 }
 
@@ -806,35 +743,13 @@ xfs_initialize_perag_data(
  * access.
  */
 void
-xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
+xfs_mod_sb(
+	struct xfs_trans	*tp)
 {
-	xfs_buf_t	*bp;
-	int		first;
-	int		last;
-	xfs_mount_t	*mp;
-	xfs_sb_field_t	f;
-
-	ASSERT(fields);
-	if (!fields)
-		return;
-	mp = tp->t_mountp;
-	bp = xfs_trans_getsb(tp, mp, 0);
-	first = sizeof(xfs_sb_t);
-	last = 0;
-
-	/* translate/copy */
-
-	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
-
-	/* find modified range */
-	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	last = xfs_sb_info[f + 1].offset - 1;
-
-	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	first = xfs_sb_info[f].offset;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
 
+	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
 }
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 8eb1c54..e193caa 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -27,11 +27,11 @@ extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
 extern void	xfs_perag_put(struct xfs_perag *pag);
 extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 
-extern void	xfs_sb_calc_crc(struct xfs_buf	*);
-extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
-extern void	xfs_sb_mount_common(struct xfs_mount *, struct xfs_sb *);
-extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
-extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
+extern void	xfs_sb_calc_crc(struct xfs_buf *bp);
+extern void	xfs_mod_sb(struct xfs_trans *tp);
+extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
+extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
+extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 
 #endif	/* __XFS_SB_H__ */
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index e57bdb2..f3c846e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -168,7 +168,7 @@ perform_restore(
 
 	memset(block_buffer, 0, sb.sb_sectsize);
 	sb.sb_inprogress = 0;
-	libxfs_sb_to_disk((xfs_dsb_t *)block_buffer, &sb, XFS_SB_ALL_BITS);
+	libxfs_sb_to_disk((xfs_dsb_t *)block_buffer, &sb);
 	if (xfs_sb_version_hascrc(&sb)) {
 		xfs_update_cksum(block_buffer, sb.sb_sectsize,
 				 offsetof(struct xfs_sb, sb_crc));
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0c8bd2f..18a2553 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -551,7 +551,7 @@ parseproto(
 		if (!pip) {
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
-			libxfs_mod_sb(tp, XFS_SB_ROOTINO);
+			libxfs_mod_sb(tp);
 			isroot = 1;
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
@@ -657,7 +657,7 @@ rtinit(
 	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
 	*(__uint64_t *)&rbmip->i_d.di_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
-	libxfs_mod_sb(tp, XFS_SB_RBMINO);
+	libxfs_mod_sb(tp);
 	mp->m_rbmip = rbmip;
 	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rsumip);
@@ -667,7 +667,7 @@ rtinit(
 	mp->m_sb.sb_rsumino = rsumip->i_ino;
 	rsumip->i_d.di_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
-	libxfs_mod_sb(tp, XFS_SB_RSUMINO);
+	libxfs_mod_sb(tp);
 	libxfs_trans_commit(tp, 0);
 	mp->m_rsumip = rsumip;
 	/*
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d4856b1..176a6b2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2651,7 +2651,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(XFS_BUF_PTR(buf), 0, sectorsize);
-	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
+	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	libxfs_purgebuf(buf);
 
@@ -2712,7 +2712,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 				XFS_FSS_TO_BB(mp, 1));
 		buf->b_ops = &xfs_sb_buf_ops;
 		memset(XFS_BUF_PTR(buf), 0, sectorsize);
-		libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
+		libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
diff --git a/repair/phase5.c b/repair/phase5.c
index 71bf751..1ce57a1 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1500,7 +1500,7 @@ sync_sb(xfs_mount_t *mp)
 
 	update_sb_version(mp);
 
-	libxfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
+	libxfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
 	libxfs_writebuf(bp, 0);
 }
 
diff --git a/repair/sb.c b/repair/sb.c
index 79f7882..c85b9e2 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -434,7 +434,7 @@ write_primary_sb(xfs_sb_t *sbp, int size)
 		do_error(_("couldn't seek to offset 0 in filesystem\n"));
 	}
 
-	libxfs_sb_to_disk(buf, sbp, XFS_SB_ALL_BITS);
+	libxfs_sb_to_disk(buf, sbp);
 
 	if (xfs_sb_version_hascrc(sbp))
 		xfs_update_cksum((char *)buf, size, XFS_SB_CRC_OFF);
diff --git a/repair/scan.c b/repair/scan.c
index ebc8535..259ab40 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1597,7 +1597,7 @@ scan_ag(
 	if (sb_dirty && !no_modify) {
 		if (agno == 0)
 			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
-		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb, XFS_SB_ALL_BITS);
+		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb);
 		libxfs_writebuf(sbbuf, 0);
 	} else
 		libxfs_putbuf(sbbuf);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
