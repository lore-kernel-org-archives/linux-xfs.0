Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751884AbeEGOUe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 10:20:34 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7A2E2C9708
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 14:20:33 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D38B2010DB2
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 14:20:29 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: check and repair quota metadata
Message-ID: <9e494d70-53bd-db81-c118-73ef7eaad667@redhat.com>
Date: Mon, 7 May 2018 09:20:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today, quota inodes are not checked at all in xfs_repair.  (This is
a little odd, because xfs_check used to do it in process_quota()).

The kernel has quota inode validation and repair routines, but it is
out of the ordinary for the kernel to be doing metadata repair.  And
now that we have metadata verifiers, this also yields a surprisingly
noisy mount if quota inodes are corrupted, even immediately after an
xfs_repair.

So this patch allows xfs_repair to fix the quota inode metadata.

Quotacheck is still left for the kernel.  After a few more releases,
I'll propose removing the repair calls from the kernel, and move the
repair functions from libxfs/ into the repair code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This will need a bit of adjustment when my other quota patches land
in 4.18, but that should be no big deal.

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ab195f5f..e5eb3de1 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -196,8 +196,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 # define barrier() __memory_barrier()
 #endif
 
-#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
-
 /* miscellaneous kernel routines not in user space */
 #define down_read(a)		((void) 0)
 #define up_read(a)		((void) 0)
diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index bb1b13a9..067475e2 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -30,6 +30,8 @@
 typedef uint64_t	xfs_qcnt_t;
 typedef uint16_t	xfs_qwarncnt_t;
 
+#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
+
 /*
  * flags for q_flags field in the dquot.
  */
diff --git a/repair/dinode.c b/repair/dinode.c
index 9af4f058..a4887f8c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1277,6 +1277,118 @@ null_check(char *name, int length)
 	return(0);
 }
 
+/*
+ * This does /not/ do quotacheck, it validates the basic quota
+ * inode metadata, checksums, etc.
+ */
+#define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
+static int
+process_quota_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		lino,
+	struct xfs_dinode	*dino,
+	uint			ino_type,
+	struct blkmap		*blkmap)
+{
+	xfs_fsblock_t		fsbno;
+	struct xfs_buf		*bp;
+	xfs_filblks_t		dqchunklen;
+	uint			dqperchunk;
+	int			quota_type;
+	char			*quota_string;
+	xfs_dqid_t		dqid;
+	xfs_fileoff_t		qbno;
+	int			i;
+	int			t = 0;
+
+	switch (ino_type) {
+		case XR_INO_UQUOTA:
+			quota_type = XFS_DQ_USER;
+			quota_string = _("User quota");
+			break;
+		case XR_INO_GQUOTA:
+			quota_type = XFS_DQ_GROUP;
+			quota_string = _("Group quota");
+			break;
+		case XR_INO_PQUOTA:
+			quota_type = XFS_DQ_PROJ;
+			quota_string = _("Project quota");
+			break;
+		default:
+			ASSERT(0);
+	}
+
+	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
+	dqperchunk = xfs_calc_dquots_per_chunk(dqchunklen);
+	dqid = 0;
+	qbno = NULLFILEOFF;
+
+	while ((qbno = blkmap_next_off(blkmap, qbno, &t)) != NULLFILEOFF) {
+		xfs_dqblk_t	*dqb;
+		int		writebuf = 0;
+
+		fsbno = blkmap_get(blkmap, qbno);
+		dqid = (xfs_dqid_t)qbno * dqperchunk;
+
+		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+				    dqchunklen, 0, &xfs_dquot_buf_ops);
+		if (!bp) {
+			do_warn(
+_("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "\n"),
+				lino, qbno, fsbno);
+			return 1;
+		}
+
+		dqb = bp->b_addr;
+		for (i = 0; i < dqperchunk; i++, dqid++, dqb++) {
+			xfs_failaddr_t	fa;
+			int		bad_dqb = 0;
+
+			/* We only print the first problem we find */
+			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+				if (!xfs_verify_cksum((char *)dqb, sizeof(*dqb),
+							XFS_DQUOT_CRC_OFF)) {
+					do_warn(_("%s: bad CRC for id %u. "),
+							quota_string, dqid);
+					bad_dqb = 1;
+					goto bad;
+				}
+
+				if (!uuid_equal(&dqb->dd_uuid,
+						&mp->m_sb.sb_meta_uuid)) {
+					do_warn(_("%s: bad UUID for id %u. "),
+							quota_string, dqid);
+					bad_dqb = 1;
+					goto bad;
+				}
+			}
+			fa = xfs_dquot_verify(mp, &dqb->dd_diskdq, dqid, quota_type, 0);
+			if (fa) {
+				do_warn(_("%s: Corrupt quota for id %u. "),
+						quota_string, dqid);
+				bad_dqb = 1;
+			}
+
+bad:
+			if (bad_dqb) {
+				if (no_modify)
+					do_warn(_("Would correct.\n"));
+				else {
+					do_warn(_("Corrected.\n"));
+					xfs_dquot_repair(mp, &dqb->dd_diskdq, dqid, quota_type);
+					writebuf = 1;
+				}
+			}
+		}
+
+		if (writebuf && !no_modify)
+			libxfs_writebuf(bp, 0);
+		else
+			libxfs_putbuf(bp);
+	}
+	return 0;
+}
+
 static int
 process_symlink_remote(
 	struct xfs_mount	*mp,
@@ -1479,6 +1591,13 @@ _("size of socket inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
 _("size of fifo inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
 				(int64_t)be64_to_cpu(dino->di_size));
 			break;
+		case XR_INO_UQUOTA:
+		case XR_INO_GQUOTA:
+		case XR_INO_PQUOTA:
+			do_warn(
+_("size of quota inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
+				(int64_t)be64_to_cpu(dino->di_size));
+			break;
 		default:
 			do_warn(_("Internal error - process_misc_ino_types, "
 				  "illegal type %d\n"), type);
@@ -1599,7 +1718,7 @@ process_check_sb_inodes(
 	int		*dirty)
 {
 	if (lino == mp->m_sb.sb_rootino) {
-	 	if (*type != XR_INO_DIR)  {
+		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			*type = XR_INO_DIR;
@@ -1613,7 +1732,7 @@ process_check_sb_inodes(
 		return 0;
 	}
 	if (lino == mp->m_sb.sb_uquotino)  {
-		if (*type != XR_INO_DATA)  {
+		if (*type != XR_INO_UQUOTA)  {
 			do_warn(_("user quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			mp->m_sb.sb_uquotino = NULLFSINO;
@@ -1622,7 +1741,7 @@ process_check_sb_inodes(
 		return 0;
 	}
 	if (lino == mp->m_sb.sb_gquotino)  {
-		if (*type != XR_INO_DATA)  {
+		if (*type != XR_INO_GQUOTA)  {
 			do_warn(_("group quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			mp->m_sb.sb_gquotino = NULLFSINO;
@@ -1631,7 +1750,7 @@ process_check_sb_inodes(
 		return 0;
 	}
 	if (lino == mp->m_sb.sb_pquotino)  {
-		if (*type != XR_INO_DATA)  {
+		if (*type != XR_INO_PQUOTA)  {
 			do_warn(_("project quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			mp->m_sb.sb_pquotino = NULLFSINO;
@@ -1738,6 +1857,14 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
 			return 1;
 		break;
 
+	case XR_INO_UQUOTA:
+	case XR_INO_GQUOTA:
+	case XR_INO_PQUOTA:
+		/* Quota inodes have same restrictions as above types */
+		if (process_misc_ino_types(mp, dino, lino, type))
+			return 1;
+		break;
+
 	case XR_INO_RTDATA:
 		/*
 		 * if we have no realtime blocks, any inode claiming
@@ -2620,6 +2747,12 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_RTBITMAP;
 		else if (lino == mp->m_sb.sb_rsumino)
 			type = XR_INO_RTSUM;
+		else if (lino == mp->m_sb.sb_uquotino)
+			type = XR_INO_UQUOTA;
+		else if (lino == mp->m_sb.sb_gquotino)
+			type = XR_INO_GQUOTA;
+		else if (lino == mp->m_sb.sb_pquotino)
+			type = XR_INO_PQUOTA;
 		else
 			type = XR_INO_DATA;
 		break;
@@ -2784,6 +2917,15 @@ _("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
 			goto clear_bad_out;
 		}
 		break;
+	case XR_INO_UQUOTA:
+	case XR_INO_GQUOTA:
+	case XR_INO_PQUOTA:
+		if (process_quota_inode(mp, lino, dino, type, dblkmap) != 0) {
+			do_warn(
+	_("problem with quota inode %" PRIu64 "\n"), lino);
+			goto clear_bad_out;
+		}
+		break;
 	default:
 		break;
 	}
diff --git a/repair/incore.h b/repair/incore.h
index fd66084f..78a0ed30 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -222,13 +222,16 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_RTDATA	2		/* realtime file */
 #define XR_INO_RTBITMAP	3		/* realtime bitmap inode */
 #define XR_INO_RTSUM	4		/* realtime summary inode */
-#define XR_INO_DATA	5		/* regular file */
-#define XR_INO_SYMLINK	6		/* symlink */
-#define XR_INO_CHRDEV	7		/* character device */
-#define XR_INO_BLKDEV	8		/* block device */
-#define XR_INO_SOCK	9		/* socket */
-#define XR_INO_FIFO	10		/* fifo */
-#define XR_INO_MOUNTPOINT 11		/* mountpoint */
+#define XR_INO_UQUOTA	5		/* user quota inode */
+#define XR_INO_GQUOTA	6		/* group quota inode */
+#define XR_INO_PQUOTA	7		/* project quota inode */
+#define XR_INO_DATA	8		/* regular file */
+#define XR_INO_SYMLINK	9		/* symlink */
+#define XR_INO_CHRDEV	10		/* character device */
+#define XR_INO_BLKDEV	11		/* block device */
+#define XR_INO_SOCK	12		/* socket */
+#define XR_INO_FIFO	13		/* fifo */
+#define XR_INO_MOUNTPOINT 14		/* mountpoint */
 
 /* inode allocation tree */
 

