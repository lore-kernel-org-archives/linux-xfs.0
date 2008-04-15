Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Apr 2008 01:51:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3F8pASN031946
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2008 01:51:13 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA10964 for <xfs@oss.sgi.com>; Tue, 15 Apr 2008 18:51:49 +1000
Date: Tue, 15 Apr 2008 18:53:37 +1000
Subject: Re: [REVIEW #2] bad_features2 fix and lazy-counter togging in xfs_admin
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t617a1yt3jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <op.t9m9nncu3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t617a1yt3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 25 Feb 2008 13:46:03 +1100, Barry Naujok <bnaujok@sgi.com> wrote:

> As per the previous reviews with comments applied.

Ping on xfs_admin lazy-counter support?

As a reminder: xfs_admin -c 0|1 to turn on/off lazy counters in
a filesystem.

> I have swapped the order of the patches - bad_features2.patch first,
> then convert.patch.
>
> I've added man page updates for xfs_admin and xfs_repair for the
> lazy-counter conversion.
>
> Barry.

---
  xfsprogs/db/xfs_admin.sh       |   42  
++++++++++++++++++++++++++++-------------
  xfsprogs/man/man8/xfs_admin.8  |    8 +++++++
  xfsprogs/man/man8/xfs_repair.8 |    8 +++++++
  xfsprogs/repair/globals.h      |    2 +
  xfsprogs/repair/phase1.c       |   26 +++++++++++++++++++++++++
  xfsprogs/repair/xfs_repair.c   |   38  
+++++++++++++++++++++++++++++++------
  6 files changed, 105 insertions(+), 19 deletions(-)

Index: ci/xfsprogs/db/xfs_admin.sh
===================================================================
--- ci.orig/xfsprogs/db/xfs_admin.sh
+++ ci/xfsprogs/db/xfs_admin.sh
@@ -3,20 +3,23 @@
  # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
  #

-OPTS=""
-USAGE="Usage: xfs_admin [-efjluV] [-L label] [-U uuid] special"
+status=0
+DB_OPTS=""
+REPAIR_OPTS=""
+USAGE="Usage: xfs_admin [-efjluV] [-c 0|1] [-L label] [-U uuid] special"

-while getopts "efjluL:U:V" c
+while getopts "efjluc:L:U:V" c
  do
  	case $c in
-	e)	OPTS=$OPTS" -c 'version extflg'";;
-	f)	OPTS=$OPTS" -f";;
-	j)	OPTS=$OPTS" -c 'version log2'";;
-	l)	OPTS=$OPTS" -r -c label";;
-	L)	OPTS=$OPTS" -c 'label "$OPTARG"'";;
-	u)	OPTS=$OPTS" -r -c uuid";;
-	U)	OPTS=$OPTS" -c 'uuid "$OPTARG"'";;
-	V)	OPTS=$OPTS" -V";;
+	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
+	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
+	f)	DB_OPTS=$DB_OPTS" -f";;
+	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
+	l)	DB_OPTS=$DB_OPTS" -r -c label";;
+	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
+	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
+	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
+	V)	DB_OPTS=$DB_OPTS" -V";;
  	\?)	echo $USAGE 1>&2
  		exit 2
  		;;
@@ -25,8 +28,21 @@ done
  set -- extra $@
  shift $OPTIND
  case $# in
-	1)	eval xfs_db -x -p xfs_admin $OPTS $1
-		status=$?
+	1)	if [ -n "$DB_OPTS" ]
+		then
+			eval xfs_db -x -p xfs_admin $DB_OPTS $1
+			status=$?
+		fi
+		if [ -n "$REPAIR_OPTS" ]
+		then
+			# Hide normal repair output which is sent to stderr
+			# assuming the filesystem is fine when a user is
+			# running xfs_admin.
+			# Ideally, we need to improve the output behaviour
+			# of repair for this purpose (say a "quiet" mode).
+			eval xfs_repair $REPAIR_OPTS $1 2> /dev/null
+			status=`expr $? + $status`
+		fi
  		;;
  	*)	echo $USAGE 1>&2
  		exit 2
Index: ci/xfsprogs/man/man8/xfs_admin.8
===================================================================
--- ci.orig/xfsprogs/man/man8/xfs_admin.8
+++ ci/xfsprogs/man/man8/xfs_admin.8
@@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS
  [
  .B \-eflu
  ] [
+.BR "\-c 0" | 1
+] [
  .B \-L
  .I label
  ] [
@@ -53,6 +55,11 @@ Print the current filesystem label.
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
@@ -90,4 +97,5 @@ rather than its block special device nam
  .BR mount (8),
  .BR xfs_db (8),
  .BR xfs_growfs (8),
+.BR xfs_repair (8),
  .BR xfs (5).
Index: ci/xfsprogs/man/man8/xfs_repair.8
===================================================================
--- ci.orig/xfsprogs/man/man8/xfs_repair.8
+++ ci/xfsprogs/man/man8/xfs_repair.8
@@ -6,6 +6,8 @@ xfs_repair \- repair an XFS filesystem
  [
  .B \-dfLnPv
  ] [
+.BI \-c " subopt" = value
+] [
  .B \-o
  .I subopt\c
  [\c
@@ -85,6 +87,11 @@ No modify mode. Specifies that
  .B xfs_repair
  should not modify the filesystem but should only scan the
  filesystem and indicate what repairs would have been made.
+.TP
+.BI \-c " subopt" = value
+Change filesystem parameters. Refer to
+.BR xfs_admin (8)
+for information on changing filesytem parameters.
  .HP
  .B \-o
  .I subopt\c
@@ -517,6 +524,7 @@ fixed and/or improved.
  .BR dd (1),
  .BR mkfs.xfs (8),
  .BR umount (8),
+.BR xfs_admin (8),
  .BR xfs_check (8),
  .BR xfs_metadump (8),
  .BR xfs (5).
Index: ci/xfsprogs/repair/globals.h
===================================================================
--- ci.orig/xfsprogs/repair/globals.h
+++ ci/xfsprogs/repair/globals.h
@@ -116,6 +116,8 @@ EXTERN char	*log_name;		/* Name of log d
  EXTERN int	log_spec;		/* Log dev specified as option */
  EXTERN char	*rt_name;		/* Name of realtime device */
  EXTERN int	rt_spec;		/* Realtime dev specified as option */
+EXTERN int	convert_lazy_count;	/* Convert lazy-count mode on/off */
+EXTERN int	lazy_count;		/* What to set if to if converting */

  /* misc status variables */

Index: ci/xfsprogs/repair/phase1.c
===================================================================
--- ci.orig/xfsprogs/repair/phase1.c
+++ ci/xfsprogs/repair/phase1.c
@@ -105,6 +105,32 @@ phase1(xfs_mount_t *mp)
  		do_warn(_("superblock has a features2 mismatch, correcting\n"));
  	}

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
+			sb->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+			sb->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			primary_sb_modified = 1;
+			printf(_("Enabling lazy-counters\n"));
+		} else
+		if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
+			sb->sb_features2 &= ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+			printf(_("Disabling lazy-counters\n"));
+			primary_sb_modified = 1;
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
===================================================================
--- ci.orig/xfsprogs/repair/xfs_repair.c
+++ ci/xfsprogs/repair/xfs_repair.c
@@ -47,7 +47,7 @@ extern void	incore_init(xfs_mount_t *);
   */

  /*
- * -o (user-supplied override options)
+ * -o: user-supplied override options
   */

  char *o_opts[] = {
@@ -64,15 +64,25 @@ char *o_opts[] = {
  	NULL
  };

+/*
+ * -c: conversion options
+ */
+
+char *c_opts[] = {
+#define CONVERT_LAZY_COUNT	0
+	"lazycount",
+	NULL
+};
+
+
  static int	ihash_option_used;
  static int	bhash_option_used;

  static void
  usage(void)
  {
-	do_warn(
-_("Usage: %s [-nLvV] [-o subopt[=value]] [-l logdev] [-r rtdev]  
devname\n"),
-		progname);
+	do_warn(_("Usage: %s [-nLPvV] [-c subopt=value] [-o subopt[=value]] "
+		"[-l logdev] [-r rtdev] devname\n"), progname);
  	exit(1);
  }

@@ -87,7 +97,7 @@ err_string(int err_code)
  		err_message[XR_BAD_MAGIC] = _("bad magic number");
  		err_message[XR_BAD_BLOCKSIZE] = _("bad blocksize field");
  		err_message[XR_BAD_BLOCKLOG] = _("bad blocksize log field");
-		err_message[XR_BAD_VERSION] = _("bad version number");
+		err_message[XR_BAD_VERSION] = _("bad or unsupported version");
  		err_message[XR_BAD_INPROGRESS] =
  			_("filesystem mkfs-in-progress bit set");
  		err_message[XR_BAD_FS_SIZE_DATA] =
@@ -191,7 +201,7 @@ process_args(int argc, char **argv)
  	 * XXX have to add suboption processing here
  	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
  	 */
-	while ((c = getopt(argc, argv, "o:fl:r:LnDvVdPMt:")) != EOF)  {
+	while ((c = getopt(argc, argv, "c:o:fl:r:LnDvVdPMt:")) != EOF)  {
  		switch (c) {
  		case 'D':
  			dumpcore = 1;
@@ -234,6 +244,22 @@ process_args(int argc, char **argv)
  				}
  			}
  			break;
+		case 'c':
+			p = optarg;
+			while (*p) {
+				char *val;
+
+				switch (getsubopt(&p, (constpp)c_opts, &val)) {
+				case CONVERT_LAZY_COUNT:
+					lazy_count = (int)strtol(val, 0, 0);
+					convert_lazy_count = 1;
+					break;
+				default:
+					unknown('c', val);
+					break;
+				}
+			}
+			break;
  		case 'l':
  			log_name = optarg;
  			log_spec = 1;
