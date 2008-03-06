Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 21:59:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m265xJUp026311
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 21:59:23 -0800
Date: Thu, 06 Mar 2008 17:02:07 +1100
Subject: Final call for review of sb_bad_features2 in userspace
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Message-ID: <op.t7ky1txm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

I think the attached patch maybe the least offensive for past
kernels, and XFSQA!

xfs_check and xfs_repair will ignore sb_bad_features2 if it is
zero, and if not, makes sure it's the same as sb_features2.

mkfs.xfs will set sb_bad_features2 to be the same. Maybe if
we change the behaviour of the kernel mount code with
respects of sb_bad_features2, this can be revisited.

(An intermediate solution I has was if "xfs_repair -n" is
run AND sb_bad_features is zero, then ignore it to let
xfs_repair continue, otherwise duplicate it, but doing
that requires a golden output change to QA 030 and 033
unless the kernel mount code is changed... ARGH!)

--

===========================================================================
xfsprogs/db/check.c
===========================================================================

--- a/xfsprogs/db/check.c	2008-03-06 16:59:31.000000000 +1100
+++ b/xfsprogs/db/check.c	2008-03-06 12:32:54.664882390 +1100
@@ -869,6 +869,15 @@ blockget_f(
  				mp->m_sb.sb_frextents, frextents);
  		error++;
  	}
+	if (mp->m_sb.sb_bad_features2 != 0 &&
+			mp->m_sb.sb_bad_features2 != mp->m_sb.sb_features2) {
+		if (!sflag)
+			dbprintf("sb_features2 (0x%x) not same as "
+				"sb_bad_features2 (0x%x)\n",
+				mp->m_sb.sb_features2,
+				mp->m_sb.sb_bad_features2);
+		error++;
+	}
  	if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
  	    !XFS_SB_VERSION_HASATTR(&mp->m_sb)) {
  		if (!sflag)

===========================================================================
xfsprogs/db/sb.c
===========================================================================

--- a/xfsprogs/db/sb.c	2008-03-06 16:59:31.000000000 +1100
+++ b/xfsprogs/db/sb.c	2008-02-29 17:16:33.770423296 +1100
@@ -108,6 +108,7 @@ const field_t	sb_flds[] = {
  	{ "logsectsize", FLDT_UINT16D, OI(OFF(logsectsize)), C1, 0, TYP_NONE },
  	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
  	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
+	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)), C1, 0, TYP_NONE  
},
  	{ NULL }
  };


===========================================================================
xfsprogs/include/xfs_sb.h
===========================================================================

--- a/xfsprogs/include/xfs_sb.h	2008-03-06 16:59:31.000000000 +1100
+++ b/xfsprogs/include/xfs_sb.h	2008-02-29 17:16:33.814417687 +1100
@@ -151,6 +151,7 @@ typedef struct xfs_sb
  	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
  	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
  	__uint32_t	sb_features2;	/* additional feature bits */
+	__uint32_t	sb_bad_features2; /* unusable space */
  } xfs_sb_t;

  /*
@@ -169,7 +170,7 @@ typedef enum {
  	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
  	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
  	XFS_SBS_FIELDCOUNT
  } xfs_sb_field_t;


===========================================================================
xfsprogs/libxfs/xfs_mount.c
===========================================================================

--- a/xfsprogs/libxfs/xfs_mount.c	2008-03-06 16:59:31.000000000 +1100
+++ b/xfsprogs/libxfs/xfs_mount.c	2008-02-29 17:16:33.834415138 +1100
@@ -140,6 +140,7 @@ static struct {
      { offsetof(xfs_sb_t, sb_logsectsize),0 },
      { offsetof(xfs_sb_t, sb_logsunit),	 0 },
      { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
      { sizeof(xfs_sb_t),			 0 }
  };


===========================================================================
xfsprogs/mkfs/xfs_mkfs.c
===========================================================================

--- a/xfsprogs/mkfs/xfs_mkfs.c	2008-03-06 16:59:31.000000000 +1100
+++ b/xfsprogs/mkfs/xfs_mkfs.c	2008-03-05 15:27:37.568461787 +1100
@@ -2103,6 +2103,13 @@ an AG size that is one stripe unit small
  			dirversion == 2, logversion == 2, attrversion == 1,
  			(sectorsize != BBSIZE || lsectorsize != BBSIZE),
  			sbp->sb_features2 != 0);
+	/*
+	 * Due to a structure alignment issue, sb_features2 ended up in one
+	 * of two locations, the second "incorrect" location represented by
+	 * the sb_bad_features2 field. To avoid older kernels mounting
+	 * filesystems they shouldn't, set both field to the same value.
+	 */
+	sbp->sb_bad_features2 = sbp->sb_features2;

  	if (force_overwrite)
  		zero_old_xfs_structures(&xi, sbp);

===========================================================================
xfsprogs/repair/phase1.c
===========================================================================

--- a/xfsprogs/repair/phase1.c	2008-03-06 16:59:31.000000000 +1100
+++ b/xfsprogs/repair/phase1.c	2008-03-06 16:57:40.021125442 +1100
@@ -91,6 +91,20 @@ phase1(xfs_mount_t *mp)
  		primary_sb_modified = 1;
  	}

+	/*
+	 * Check bad_features2 and make sure features2 the same as
+	 * bad_features (ORing the two together). Leave bad_features2
+	 * set so older kernels can still use it and not mount unsupported
+	 * filesystems when it reads bad_features2.
+	 */
+	if (sb->sb_bad_features2 != 0 &&
+			sb->sb_bad_features2 != sb->sb_features2) {
+		sb->sb_features2 |= sb->sb_bad_features2;
+		sb->sb_bad_features2 = sb->sb_features2;
+		primary_sb_modified = 1;
+		do_warn(_("superblock has a features2 mismatch, correcting\n"));
+	}
+
  	if (primary_sb_modified)  {
  		if (!no_modify)  {
  			do_warn(_("writing modified primary superblock\n"));
