Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 20:50:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T4oJa3029143
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 20:50:23 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA04929 for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:50:47 +1100
Date: Fri, 29 Feb 2008 15:52:41 +1100
Subject: [REVIEW #3] bad_features2 support in user-space
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------6Y3jMCVBM1ktkx0oqEJIaa
MIME-Version: 1.0
Message-ID: <op.t69rt3bp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------6Y3jMCVBM1ktkx0oqEJIaa
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

Ok, xfs_repair will leave bad_features2 in place just in case it is
being run with an older kernel that expects features2 in the bad
location. But, it will make sure the correct and bad features2 are
consistent if bad_features2 in non-zero.

If bad_features2 is zero, it is left alone (eg. new mkfs or new
kernel with fixes it during mount time).

This seems to be the best solution to the problem.

Barry.

--

Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c	2008-02-29 15:03:16.010345197 +1100
+++ ci/xfsprogs/db/check.c	2008-02-29 15:45:06.116663285 +1100
@@ -869,6 +869,13 @@
  				mp->m_sb.sb_frextents, frextents);
  		error++;
  	}
+	if (mp->m_sb.sb_bad_features2 !=3D 0 &&
+			mp->m_sb.sb_bad_features2 !=3D mp->m_sb.sb_features2) {
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
--- ci.orig/xfsprogs/db/sb.c	2008-02-29 15:03:16.010345197 +1100
+++ ci/xfsprogs/db/sb.c	2008-02-29 15:03:32.412245912 +1100
@@ -108,6 +108,7 @@
  	{ "logsectsize", FLDT_UINT16D, OI(OFF(logsectsize)), C1, 0, TYP_NONE },
  	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
  	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
+	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)), C1, 0, TYP_NONE=
=20=20
},
  	{ NULL }
  };

Index: ci/xfsprogs/include/xfs_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_sb.h	2008-02-29 15:03:16.018344173 +1100
+++ ci/xfsprogs/include/xfs_sb.h	2008-02-29 15:03:32.420244888 +1100
@@ -151,6 +151,7 @@
  	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
  	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
  	__uint32_t	sb_features2;	/* additional feature bits */
+	__uint32_t	sb_bad_features2; /* unusable space */
  } xfs_sb_t;

  /*
@@ -169,7 +170,7 @@
  	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
  	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
  	XFS_SBS_FIELDCOUNT
  } xfs_sb_field_t;

Index: ci/xfsprogs/libxfs/xfs_mount.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_mount.c	2008-02-29 15:03:16.022343662 +1100
+++ ci/xfsprogs/libxfs/xfs_mount.c	2008-02-29 15:03:32.436242841 +1100
@@ -140,6 +140,7 @@
      { offsetof(xfs_sb_t, sb_logsectsize),0 },
      { offsetof(xfs_sb_t, sb_logsunit),	 0 },
      { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
      { sizeof(xfs_sb_t),			 0 }
  };

Index: ci/xfsprogs/repair/phase1.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase1.c	2008-02-29 15:03:16.034342126 +1100
+++ ci/xfsprogs/repair/phase1.c	2008-02-29 15:43:47.834622965 +1100
@@ -91,6 +91,23 @@
  		primary_sb_modified =3D 1;
  	}

+	/*
+	 * Check bad_features2, if set, make sure features2 the same as
+	 * bad_features (ORing the two together). Leave bad_features2
+	 * set so older kernels can still use it.
+	 *
+	 * Linux kernels >=3D 2.6.25 will zero bad_features2 when
+	 * encountered during mount time.
+	 */
+	if (sb->sb_bad_features2 !=3D 0 &&
+			sb->sb_bad_features2 !=3D sb->sb_features2) {
+		sb->sb_features2 |=3D sb->sb_bad_features2;
+		sb->sb_bad_features2 =3D sb->sb_features2;
+		primary_sb_modified =3D 1;
+		do_warn(_("superblock's features2 field is in the wrong "
+			"location, correcting\n"));
+	}
+
  	if (primary_sb_modified)  {
  		if (!no_modify)  {
  			do_warn(_("writing modified primary superblock\n"));
------------6Y3jMCVBM1ktkx0oqEJIaa
Content-Disposition: attachment; filename=bad_features2.patch
Content-Type: text/x-patch; name=bad_features2.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c	2008-02-29 15:03:16.010345197 +1100
+++ ci/xfsprogs/db/check.c	2008-02-29 15:45:06.116663285 +1100
@@ -869,6 +869,13 @@
 				mp->m_sb.sb_frextents, frextents);
 		error++;
 	}
+	if (mp->m_sb.sb_bad_features2 !=3D 0 &&
+			mp->m_sb.sb_bad_features2 !=3D mp->m_sb.sb_features2) {
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
--- ci.orig/xfsprogs/db/sb.c	2008-02-29 15:03:16.010345197 +1100
+++ ci/xfsprogs/db/sb.c	2008-02-29 15:03:32.412245912 +1100
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
--- ci.orig/xfsprogs/include/xfs_sb.h	2008-02-29 15:03:16.018344173 +1100
+++ ci/xfsprogs/include/xfs_sb.h	2008-02-29 15:03:32.420244888 +1100
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
--- ci.orig/xfsprogs/libxfs/xfs_mount.c	2008-02-29 15:03:16.022343662 +1100
+++ ci/xfsprogs/libxfs/xfs_mount.c	2008-02-29 15:03:32.436242841 +1100
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
--- ci.orig/xfsprogs/repair/phase1.c	2008-02-29 15:03:16.034342126 +1100
+++ ci/xfsprogs/repair/phase1.c	2008-02-29 15:43:47.834622965 +1100
@@ -91,6 +91,23 @@
 		primary_sb_modified =3D 1;
 	}
=20
+	/*
+	 * Check bad_features2, if set, make sure features2 the same as
+	 * bad_features (ORing the two together). Leave bad_features2
+	 * set so older kernels can still use it.
+	 *
+	 * Linux kernels >=3D 2.6.25 will zero bad_features2 when
+	 * encountered during mount time.
+	 */
+	if (sb->sb_bad_features2 !=3D 0 &&
+			sb->sb_bad_features2 !=3D sb->sb_features2) {
+		sb->sb_features2 |=3D sb->sb_bad_features2;
+		sb->sb_bad_features2 =3D sb->sb_features2;
+		primary_sb_modified =3D 1;
+		do_warn(_("superblock's features2 field is in the wrong "
+			"location, correcting\n"));
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));

------------6Y3jMCVBM1ktkx0oqEJIaa--
