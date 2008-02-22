Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 22:43:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M6h4wa022325
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 22:43:10 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA16593 for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 17:43:31 +1100
Date: Fri, 22 Feb 2008 17:45:54 +1100
Subject: [REVIEW] Add lazy-counter conversion to xfs_repair
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------A0cu5dOyxzxPq92HFlWhQ4
MIME-Version: 1.0
Message-ID: <op.t6wyesz53jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------A0cu5dOyxzxPq92HFlWhQ4
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

In response to the thread "Differences in mkfs.xfs and xfs_info output.",=
=20=20
xfs_repair has been improved to allow version changes/conversion of=20=20
filesystems.

So, this patch introduces the first in an ongoing series of in-place=20=20
filesystem version changes with xfs_repair and the "-c" (convert) option.

To turn on/off the lazy-superblock feature, run the following xfs_repair=20=
=20
commmand on your filesystem:

# xfs_repair -c lazycount=3D[0|1] <device>

It is advised to run Dave Chinner's "detect and correct bad features2=20=20
superblock field" patch with this patch as lazy-counters are stored in the=
=20=20
features2 field in the superblock.


The next round of case-insensitive support patches will allow xfs_repair=20=
=20
to convert filesystems to different CI versions (ie. -c=20=20
name=3D[raw|ascii|unicode]).

Barry.
------------A0cu5dOyxzxPq92HFlWhQ4
Content-Disposition: attachment; filename=convert.patch
Content-Type: text/x-patch; name=convert.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/repair/globals.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/globals.h	2008-01-16 14:54:12.000000000 +1100
+++ ci/xfsprogs/repair/globals.h	2008-02-22 17:21:41.195651501 +1100
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
--- ci.orig/xfsprogs/repair/phase1.c	2008-01-16 14:54:12.000000000 +1100
+++ ci/xfsprogs/repair/phase1.c	2008-02-22 17:29:38.285953524 +1100
@@ -91,6 +91,26 @@
 		primary_sb_modified =3D 1;
 	}
=20
+	/*
+	 * apply any version changes or conversions after the primary
+	 * superblock has been verified or repaired
+	 */
+	if (convert_lazy_count) {
+		if (lazy_count && !xfs_sb_version_haslazysbcount(sb)) {
+			sbp->sb_versionnum |=3D XFS_SB_VERSION_MOREBITSBIT;
+			sbp->sb_features2 |=3D XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			primary_sb_modified =3D 1;
+			do_log(_("        - Enabling lazy-counters\n"));
+		} else
+		if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
+			sbp->sb_features2 &=3D ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			do_log(_("        - Disabling lazy-counters\n"));
+			primary_sb_modified =3D 1;
+		} else
+			do_log(_("        - Lazy-counters are already %s\n"),
+				lazy_count ? _("enabled") : _("disabled"));
+	}
+
 	if (primary_sb_modified)  {
 		if (!no_modify)  {
 			do_warn(_("writing modified primary superblock\n"));
Index: ci/xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/xfs_repair.c	2008-02-22 14:15:42.000000000 +1100
+++ ci/xfsprogs/repair/xfs_repair.c	2008-02-22 14:36:07.385247765 +1100
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
+				switch (getsubopt(&p, (constpp)c_opts, *val)) {
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

------------A0cu5dOyxzxPq92HFlWhQ4--
