Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 18:44:28 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P2iFik017193
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 18:44:19 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA11328 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 13:44:41 +1100
Date: Mon, 25 Feb 2008 13:46:03 +1100
Subject: [REVIEW #2] bad_features2 fix and lazy-counter togging in xfs_admin
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------MRooF3s5aKJvDLU78uWt5J
MIME-Version: 1.0
Message-ID: <op.t617a1yt3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------MRooF3s5aKJvDLU78uWt5J
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

As per the previous reviews with comments applied.

I have swapped the order of the patches - bad_features2.patch first,
then convert.patch.

I've added man page updates for xfs_admin and xfs_repair for the
lazy-counter conversion.

Barry.
------------MRooF3s5aKJvDLU78uWt5J
Content-Disposition: attachment; filename=bad_features2.patch
Content-Type: text/x-patch; name=bad_features2.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c	2008-02-25 11:21:58.000000000 +1100
+++ ci/xfsprogs/db/check.c	2008-02-25 11:50:54.040787253 +1100
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
--- ci.orig/xfsprogs/db/sb.c	2008-02-25 11:21:58.000000000 +1100
+++ ci/xfsprogs/db/sb.c	2008-02-25 11:50:54.040787253 +1100
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
--- ci.orig/xfsprogs/include/xfs_sb.h	2008-02-25 11:21:57.000000000 +1100
+++ ci/xfsprogs/include/xfs_sb.h	2008-02-25 11:50:54.108778503 +1100
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
--- ci.orig/xfsprogs/libxfs/xfs_mount.c	2008-02-25 11:21:58.000000000 +1100
+++ ci/xfsprogs/libxfs/xfs_mount.c	2008-02-25 11:50:54.176769752 +1100
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
--- ci.orig/xfsprogs/repair/phase1.c	2008-02-25 11:22:25.000000000 +1100
+++ ci/xfsprogs/repair/phase1.c	2008-02-25 13:44:10.591103786 +1100
@@ -91,6 +91,18 @@
 		primary_sb_modified =3D 1;
 	}
=20
+	/*
+	 * Check bad_features2, if set and features2 is zero, OR
+	 * bad_features2 to features2 and zero bad_features2.
+	 */
+	if (sb->sb_bad_features2 !=3D 0) {
+		sb->sb_features2 |=3D sb->sb_bad_features2;
+		sb->sb_bad_features2 =3D 0;
+		primary_sb_modified =3D 1;
+		do_warn(_("superblock's features2 field is in the wrong "
+			"location, correcting\n"));
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));

------------MRooF3s5aKJvDLU78uWt5J
Content-Disposition: attachment; filename=convert.patch
Content-Type: text/x-patch; name=convert.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/repair/globals.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/globals.h	2008-02-25 13:44:10.591103786 +1100
+++ ci/xfsprogs/repair/globals.h	2008-02-25 13:44:14.562591674 +1100
@@ -116,6 +116,8 @@
 EXTERN int	log_spec;		/* Log dev specified as option */
 EXTERN char	*rt_name;		/* Name of realtime device */
 EXTERN int	rt_spec;		/* Realtime dev specified as option */
+EXTERN int	convert_lazy_count;	/* Convert lazy-count mode on/off */
+EXTERN int	lazy_count;		/* What to set if to if converting */
=20
 /* misc status variables */
=20
Index: ci/xfsprogs/repair/phase1.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase1.c	2008-02-25 13:44:10.591103786 +1100
+++ ci/xfsprogs/repair/phase1.c	2008-02-25 13:44:14.562591674 +1100
@@ -103,6 +103,32 @@
 			"location, correcting\n"));
 	}
=20
+	/*
+	 * apply any version changes or conversions after the primary
+	 * superblock has been verified or repaired
+	 *
+	 * Send output to stdout as do_log and everything else in repair
+	 * is sent to stderr and there is no "quiet" option. xfs_admin
+	 * will filter stderr but not stdout. This situation must be improved.
+	 */
+	if (convert_lazy_count) {
+		if (lazy_count && !xfs_sb_version_haslazysbcount(sb)) {
+			sb->sb_versionnum |=3D XFS_SB_VERSION_MOREBITSBIT;
+			sb->sb_features2 |=3D XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			primary_sb_modified =3D 1;
+			printf(_("Enabling lazy-counters\n"));
+		} else
+		if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
+			sb->sb_features2 &=3D ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			printf(_("Disabling lazy-counters\n"));
+			primary_sb_modified =3D 1;
+		} else {
+			printf(_("Lazy-counters are already %s\n"),
+				lazy_count ? _("enabled") : _("disabled"));
+			exit(0); /* no conversion required, exit */
+		}
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));
Index: ci/xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/xfs_repair.c	2008-02-25 13:44:10.599102754 +1100
+++ ci/xfsprogs/repair/xfs_repair.c	2008-02-25 13:44:14.562591674 +1100
@@ -47,7 +47,7 @@
  */
=20
 /*
- * -o (user-supplied override options)
+ * -o: user-supplied override options
  */
=20
 char *o_opts[] =3D {
@@ -64,15 +64,25 @@
 	NULL
 };
=20
+/*
+ * -c: conversion options
+ */
+
+char *c_opts[] =3D {
+#define CONVERT_LAZY_COUNT	0
+	"lazycount",
+	NULL
+};
+
+
 static int	ihash_option_used;
 static int	bhash_option_used;
=20
 static void
 usage(void)
 {
-	do_warn(
-_("Usage: %s [-nLvV] [-o subopt[=3Dvalue]] [-l logdev] [-r rtdev] devname\=
n"),
-		progname);
+	do_warn(_("Usage: %s [-nLPvV] [-c subopt=3Dvalue] [-o subopt[=3Dvalue]] "
+		"[-l logdev] [-r rtdev] devname\n"), progname);
 	exit(1);
 }
=20
@@ -191,7 +201,7 @@
 	 * XXX have to add suboption processing here
 	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
 	 */
-	while ((c =3D getopt(argc, argv, "o:fl:r:LnDvVdPMt:")) !=3D EOF)  {
+	while ((c =3D getopt(argc, argv, "c:o:fl:r:LnDvVdPMt:")) !=3D EOF)  {
 		switch (c) {
 		case 'D':
 			dumpcore =3D 1;
@@ -234,6 +244,22 @@
 				}
 			}
 			break;
+		case 'c':
+			p =3D optarg;
+			while (*p) {
+				char *val;
+
+				switch (getsubopt(&p, (constpp)c_opts, &val)) {
+				case CONVERT_LAZY_COUNT:
+					lazy_count =3D (int)strtol(val, 0, 0);
+					convert_lazy_count =3D 1;
+					break;
+				default:
+					unknown('c', val);
+					break;
+				}
+			}
+			break;
 		case 'l':
 			log_name =3D optarg;
 			log_spec =3D 1;
Index: ci/xfsprogs/db/xfs_admin.sh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/xfs_admin.sh	2008-02-25 13:44:10.623099660 +1100
+++ ci/xfsprogs/db/xfs_admin.sh	2008-02-25 13:44:14.650580328 +1100
@@ -3,20 +3,23 @@
 # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
 #
=20
-OPTS=3D""
-USAGE=3D"Usage: xfs_admin [-efjluV] [-L label] [-U uuid] special"
+status=3D0
+DB_OPTS=3D""
+REPAIR_OPTS=3D""
+USAGE=3D"Usage: xfs_admin [-efjluV] [-c 0|1] [-L label] [-U uuid] special"
=20
-while getopts "efjluL:U:V" c
+while getopts "efjluc:L:U:V" c
 do
 	case $c in
-	e)	OPTS=3D$OPTS" -c 'version extflg'";;
-	f)	OPTS=3D$OPTS" -f";;
-	j)	OPTS=3D$OPTS" -c 'version log2'";;
-	l)	OPTS=3D$OPTS" -r -c label";;
-	L)	OPTS=3D$OPTS" -c 'label "$OPTARG"'";;
-	u)	OPTS=3D$OPTS" -r -c uuid";;
-	U)	OPTS=3D$OPTS" -c 'uuid "$OPTARG"'";;
-	V)	OPTS=3D$OPTS" -V";;
+	c)	REPAIR_OPTS=3D$REPAIR_OPTS" -c lazycount=3D"$OPTARG;;
+	e)	DB_OPTS=3D$DB_OPTS" -c 'version extflg'";;
+	f)	DB_OPTS=3D$DB_OPTS" -f";;
+	j)	DB_OPTS=3D$DB_OPTS" -c 'version log2'";;
+	l)	DB_OPTS=3D$DB_OPTS" -r -c label";;
+	L)	DB_OPTS=3D$DB_OPTS" -c 'label "$OPTARG"'";;
+	u)	DB_OPTS=3D$DB_OPTS" -r -c uuid";;
+	U)	DB_OPTS=3D$DB_OPTS" -c 'uuid "$OPTARG"'";;
+	V)	DB_OPTS=3D$DB_OPTS" -V";;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
@@ -25,8 +28,21 @@
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	eval xfs_db -x -p xfs_admin $OPTS $1
-		status=3D$?
+	1)	if [ -n "$DB_OPTS" ]
+		then
+			eval xfs_db -x -p xfs_admin $DB_OPTS $1
+			status=3D$?
+		fi
+		if [ -n "$REPAIR_OPTS" ]
+		then
+			# Hide normal repair output which is sent to stderr
+			# assuming the filesystem is fine when a user is
+			# running xfs_admin.
+			# Ideally, we need to improve the output behaviour
+			# of repair for this purpose (say a "quiet" mode).
+			eval xfs_repair $REPAIR_OPTS $1 2> /dev/null
+			status=3D`expr $? + $status`
+		fi
 		;;
 	*)	echo $USAGE 1>&2
 		exit 2
Index: ci/xfsprogs/man/man8/xfs_admin.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/man/man8/xfs_admin.8	2008-02-25 13:44:10.679092440 +11=
00
+++ ci/xfsprogs/man/man8/xfs_admin.8	2008-02-25 13:44:14.698574139 +1100
@@ -6,6 +6,8 @@
 [
 .B \-eflu
 ] [
+.BR "\-c 0" | 1
+] [
 .B \-L
 .I label
 ] [
@@ -53,6 +55,11 @@
 .B \-u
 Print the current filesystem UUID (Universally Unique IDentifier).
 .TP
+.BR "\-c 0" | 1
+Enable (1) or disable (0) lazy-counters in the filesystem.
+This operation may take quite a bit of time on large filesystems as the
+entire filesystem needs to be scanned when this option is changed.
+.TP
 .BI \-L " label"
 Set the filesystem label to
 .IR label .
@@ -90,4 +97,5 @@
 .BR mount (8),
 .BR xfs_db (8),
 .BR xfs_growfs (8),
+.BR xfs_repair (8),
 .BR xfs (5).
Index: ci/xfsprogs/man/man8/xfs_repair.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/man/man8/xfs_repair.8	2008-02-25 13:44:10.707088830 +1=
100
+++ ci/xfsprogs/man/man8/xfs_repair.8	2008-02-25 13:44:14.698574139 +1100
@@ -6,6 +6,8 @@
 [
 .B \-dfLnPv
 ] [
+.BI \-c " subopt" =3D value
+] [
 .B \-o
 .I subopt\c
 [\c
@@ -85,6 +87,11 @@
 .B xfs_repair
 should not modify the filesystem but should only scan the
 filesystem and indicate what repairs would have been made.
+.TP
+.BI \-c " subopt" =3D value
+Change filesystem parameters. Refer to
+.BR xfs_admin (8)
+for information on changing filesytem parameters.
 .HP
 .B \-o
 .I subopt\c
@@ -517,6 +524,7 @@
 .BR dd (1),
 .BR mkfs.xfs (8),
 .BR umount (8),
+.BR xfs_admin (8),
 .BR xfs_check (8),
 .BR xfs_metadump (8),
 .BR xfs (5).

------------MRooF3s5aKJvDLU78uWt5J--
