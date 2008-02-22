Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 23:49:46 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M7nbWw027243
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 23:49:40 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA18643 for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 18:50:03 +1100
Date: Fri, 22 Feb 2008 18:52:43 +1100
Subject: [REVIEW] User-space support for bad_features2 patch
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------MUqPBIdacO7Cq3AR5jfYpw
MIME-Version: 1.0
Message-ID: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------MUqPBIdacO7Cq3AR5jfYpw
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

The attached patch fixes mkfs.xfs writing the bad features2 in the first  
place (the change to xfs_sb.h does this).

Next xfs_db support printing of this superblock field and xfs_check can  
report the bad_features2 field is set.

xfs_repair can correct the error in the same fashion that David Chinner's  
mount code does it.

This patch applies to the lazy-count xfs_repair conversion code that I  
posted a short time before this patch.

Barry.
------------MUqPBIdacO7Cq3AR5jfYpw
Content-Disposition: attachment; filename=bad_features2.patch
Content-Type: text/x-patch; name=bad_features2.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c	2008-02-22 14:15:42.000000000 +1100
+++ ci/xfsprogs/db/check.c	2008-02-22 18:43:56.698852255 +1100
@@ -869,6 +869,12 @@
 				mp->m_sb.sb_frextents, frextents);
 		error++;
 	}
+	if (mp->m_sb.sb_bad_features2 !=3D 0) {
+		if (!sflag)
+			dbprintf("sb_bad_features2 is non-zero (%x)\n",
+				mp->m_sb.sb_bad_features2);
+		error++;
+	}
 	if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
 	    !XFS_SB_VERSION_HASATTR(&mp->m_sb)) {
 		if (!sflag)
Index: ci/xfsprogs/db/sb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/sb.c	2008-02-22 14:15:42.000000000 +1100
+++ ci/xfsprogs/db/sb.c	2008-02-22 18:30:10.742626136 +1100
@@ -108,6 +108,7 @@
 	{ "logsectsize", FLDT_UINT16D, OI(OFF(logsectsize)), C1, 0, TYP_NONE },
 	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
 	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
+	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)), C1, 0, TYP_NONE =
},
 	{ NULL }
 };
=20
Index: ci/xfsprogs/include/xfs_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_sb.h	2008-02-22 14:15:42.000000000 +1100
+++ ci/xfsprogs/include/xfs_sb.h	2008-02-22 18:11:58.816553959 +1100
@@ -151,6 +151,7 @@
 	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
 	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	__uint32_t	sb_features2;	/* additional feature bits */
+	__uint32_t	sb_bad_features2; /* unusable space */
 } xfs_sb_t;
=20
 /*
@@ -169,7 +170,7 @@
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
=20
Index: ci/xfsprogs/libxfs/xfs_mount.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_mount.c	2008-02-22 14:15:42.000000000 +1100
+++ ci/xfsprogs/libxfs/xfs_mount.c	2008-02-22 18:22:00.330489434 +1100
@@ -140,6 +140,7 @@
     { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
=20
Index: ci/xfsprogs/repair/phase1.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase1.c	2008-02-22 17:31:01.000000000 +1100
+++ ci/xfsprogs/repair/phase1.c	2008-02-22 18:44:23.347411378 +1100
@@ -92,6 +92,19 @@
 	}
=20
 	/*
+	 * Check bad_features2, if set and features2 is zero, copy
+	 * bad_features2 to features2 and zero bad_features2.
+	 */
+	if (sb->sb_bad_features2 !=3D 0) {
+		if (sb->sb_features2 =3D=3D 0)
+			sb->sb_features2 =3D sb->sb_bad_features2;
+		sb->sb_bad_features2 =3D 0;
+		primary_sb_modified =3D 1;
+		do_warn(_("superblock's features2 field is in the wrong "
+			"location, correcting\n"));
+	}
+
+	/*
 	 * apply any version changes or conversions after the primary
 	 * superblock has been verified or repaired
 	 */

------------MUqPBIdacO7Cq3AR5jfYpw--
