Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5F447CB2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 10:29:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A2DCAC007
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 08:29:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jsyEGsth7TMnDooQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 08:29:07 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id D19CB372569
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 16:29:06 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_quota: modify commands which can't handle multiple types
Date: Sat, 13 Feb 2016 00:28:58 +0800
Message-Id: <1455294538-31583-1-git-send-email-zlang@redhat.com>
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
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>

Some xfs_quota commands can't deal with multiple types together.
For example, if we run "limit -ug ...", one type will overwrite
the other. I find below commands can't handle multiple types:

  [quota, limit, timer, warn, dump, restore and quot]

(Although timer and warn command can't support -ugp types until
now, it will in one day.)

For every single $command, I change their ${command}_f function,
${command}_help() function, ${command}_cmd structure and man page.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 man/man8/xfs_quota.8 | 96 +++++++++++++++++++++++++++++++++++++++++++++-------
 quota/edit.c         | 78 ++++++++++++++++++++++++++----------------
 quota/quot.c         | 21 +++++++-----
 quota/quota.c        | 21 +++++++-----
 quota/report.c       | 26 +++++++++-----
 5 files changed, 175 insertions(+), 67 deletions(-)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 3bee145..4652dfe 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -169,7 +169,11 @@ command.
 .HP
 .B quota
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ] [
 .B \-bir
 ] [
@@ -188,6 +192,12 @@ Show individual usage and limits, for a single user
 or numeric user
 .IR ID .
 The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't used together. The
 .B \-h
 option reports in a "human-readable" format similar to the
 .BR df (1)
@@ -398,7 +408,11 @@ option reports state on all filesystems and not just the current path.
 .B
 limit
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ]
 .BI bsoft= N
 |
@@ -426,11 +440,21 @@ that will be used, otherwise a specific
 .I name
 or numeric
 .IR id entifier
-must be specified.
+must be specified. The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't be used together for this command.
 .HP
 .B timer
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ] [
 .B \-bir
 ]
@@ -442,11 +466,21 @@ be modified. The current timeout setting can be displayed using the
 .B state
 command. The value argument is a number of seconds, but units of
 \&'minutes', 'hours', 'days', and 'weeks' are also understood
-(as are their abbreviations 'm', 'h', 'd', and 'w').
+(as are their abbreviations 'm', 'h', 'd', and 'w'). The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't be used together for this command.
 .HP
 .B warn
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ] [
 .B \-bir
 ]
@@ -466,7 +500,13 @@ that will be used, otherwise a specific
 .I name
 or numeric
 .IR id entifier
-must be specified.
+must be specified. The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't be used together for this command.
 .B NOTE: this feature is not currently implemented.
 .TP
 .BR enable " [ " \-gpu " ] [ " \-v " ]"
@@ -497,7 +537,11 @@ report an error.
 .B
 dump
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ] [
 .B \-f
 .I file
@@ -506,11 +550,21 @@ dump
 Dump out quota limit information for backup utilities, either to
 standard output (default) or to a
 .IR file .
-This is only the limits, not the usage information, of course.
+This is only the limits, not the usage information, of course. The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't be used together for this command.
 .HP
 .B restore
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ] [
 .B \-f
 .I file
@@ -520,12 +574,22 @@ Restore quota limits from a backup
 .IR file .
 The file must be in the format produced by the
 .B dump
-command.
+command. The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't be used together for this command.
 .HP
 .B
 quot
 [
-.B \-gpu
+.B \-g
+|
+.B \-p
+|
+.B \-u
 ] [
 .B \-bir
 ] [
@@ -551,7 +615,13 @@ option displays verbose information. The
 .B \-f
 option send the output to
 .I file
-instead of stdout.
+instead of stdout. The
+.B \-u
+,
+.B \-g
+and
+.B \-p
+types can't be used together for this command.
 .HP
 .B project
 [
diff --git a/quota/edit.c b/quota/edit.c
index 6146f7e..9dab4c3 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -43,9 +43,9 @@ limit_help(void)
 " block limits that are currently being used for the specified user, group,\n"
 " or project.  The filesystem identified by the current path is modified.\n"
 " -d -- set the default values, used the first time a file is created\n"
-" -g -- modify group quota limits\n"
-" -p -- modify project quota limits\n"
-" -u -- modify user quota limits\n"
+" -g -- modify group quota limits, can't coexist with -p, -u\n"
+" -p -- modify project quota limits, can't coexist with -g, -u\n"
+" -u -- modify user quota limits, can't coexist with -g, -p\n"
 " The block limit values can be specified with a units suffix - accepted\n"
 " units are: k (kilobytes), m (megabytes), g (gigabytes), and t (terabytes).\n"
 " The user/group/project can be specified either by name or by number.\n"
@@ -71,9 +71,9 @@ timer_help(void)
 " still over the soft limit, the soft limit is enforced as the hard limit.\n"
 " The default timeout is 7 days.\n"
 " -d -- set the default values, used the first time a file is created\n"
-" -g -- modify group quota timer\n"
-" -p -- modify project quota timer\n"
-" -u -- modify user quota timer\n"
+" -g -- modify group quota timer, can't coexist with -p, -u\n"
+" -p -- modify project quota timer, can't coexist with -g, -u\n"
+" -u -- modify user quota timer, can't coexist with -g, -p\n"
 " -b -- modify the blocks-used timer\n"
 " -i -- modify the inodes-used timer\n"
 " -r -- modify the blocks-used timer for the (optional) realtime subvolume\n"
@@ -103,9 +103,9 @@ warn_help(void)
 " number of warnings issued to people, and they are penalised if the warnings\n"
 " are ignored.\n"
 " -d -- set maximum warning count, which triggers soft limit enforcement\n"
-" -g -- set group quota warning count\n"
-" -p -- set project quota warning count\n"
-" -u -- set user quota warning count\n"
+" -g -- set group quota warning count, can't coexist with -p, -u\n"
+" -p -- set project quota warning count, can't coexist with -g, -u\n"
+" -u -- set user quota warning count, can't coexist with -g, -p\n"
 " -b -- set the blocks-used warning count\n"
 " -i -- set the inodes-used warning count\n"
 " -r -- set the blocks-used warn count for the (optional) realtime subvolume\n"
@@ -282,13 +282,13 @@ limit_f(
 			flags |= DEFAULTS_FLAG;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		default:
 			return command_usage(&limit_cmd);
@@ -343,8 +343,13 @@ limit_f(
 
 	name = (flags & DEFAULTS_FLAG) ? "0" : argv[optind++];
 
-	if (!type)
+	if (!type) {
 		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&limit_cmd);
+	}
 
 	switch (type) {
 	case XFS_USER_QUOTA:
@@ -422,13 +427,13 @@ restore_f(
 			fname = optarg;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		default:
 			return command_usage(&restore_cmd);
@@ -438,8 +443,13 @@ restore_f(
 	if (argc < optind)
 		return command_usage(&restore_cmd);
 
-	if (!type)
+	if (!type) {
 		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&restore_cmd);
+	}
 
 	if (fname) {
 		if ((fp = fopen(fname, "r")) == NULL) {
@@ -501,13 +511,13 @@ timer_f(
 			mask |= FS_DQ_RTBTIMER;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		default:
 			return command_usage(&timer_cmd);
@@ -522,8 +532,13 @@ timer_f(
 	if (!mask)
 		mask = FS_DQ_TIMER_MASK;
 
-	if (!type)
+	if (!type) {
 		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&timer_cmd);
+	}
 
 	set_timer(type, mask, fs_path->fs_name, value);
 	return 0;
@@ -630,13 +645,13 @@ warn_f(
 			mask |= FS_DQ_RTBWARNS;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		default:
 			return command_usage(&warn_cmd);
@@ -661,8 +676,13 @@ warn_f(
 	if (!mask)
 		mask = FS_DQ_WARNS_MASK;
 
-	if (!type)
+	if (!type) {
 		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&warn_cmd);
+	}
 
 	switch (type) {
 	case XFS_USER_QUOTA:
@@ -686,7 +706,7 @@ edit_init(void)
 	limit_cmd.argmin = 2;
 	limit_cmd.argmax = -1;
 	limit_cmd.args = \
-	_("[-gpu] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
+	_("[-g|-p|-u] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
 	limit_cmd.oneline = _("modify quota limits");
 	limit_cmd.help = limit_help;
 
@@ -694,14 +714,14 @@ edit_init(void)
 	restore_cmd.cfunc = restore_f;
 	restore_cmd.argmin = 0;
 	restore_cmd.argmax = -1;
-	restore_cmd.args = _("[-gpu] [-f file]");
+	restore_cmd.args = _("[-g|-p|-u] [-f file]");
 	restore_cmd.oneline = _("restore quota limits from a backup file");
 
 	timer_cmd.name = "timer";
 	timer_cmd.cfunc = timer_f;
 	timer_cmd.argmin = 2;
 	timer_cmd.argmax = -1;
-	timer_cmd.args = _("[-bir] [-gpu] value");
+	timer_cmd.args = _("[-bir] [-g|-p|-u] value");
 	timer_cmd.oneline = _("set quota enforcement timeouts");
 	timer_cmd.help = timer_help;
 
@@ -709,7 +729,7 @@ edit_init(void)
 	warn_cmd.cfunc = warn_f;
 	warn_cmd.argmin = 2;
 	warn_cmd.argmax = -1;
-	warn_cmd.args = _("[-bir] [-gpu] value -d|id|name");
+	warn_cmd.args = _("[-bir] [-g|-p|-u] value -d|id|name");
 	warn_cmd.oneline = _("get/set enforcement warning counter");
 	warn_cmd.help = warn_help;
 
diff --git a/quota/quot.c b/quota/quot.c
index 9116e48..5588a25 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -62,9 +62,9 @@ quot_help(void)
 "       total of all files greater than 500 kilobytes.\n"
 " -v -- display three columns containing the number of kilobytes not\n"
 "       accessed in the last 30, 60, and 90 days.\n"
-" -g -- display group summary\n"
-" -p -- display project summary\n"
-" -u -- display user summary\n"
+" -g -- display group summary, can't coexist with -p, -u\n"
+" -p -- display project summary, can't coexist with -g, -u\n"
+" -u -- display user summary, can't coexist with -g, -p\n"
 " -b -- display number of blocks used\n"
 " -i -- display number of inodes used\n"
 " -r -- display number of realtime blocks used\n"
@@ -361,13 +361,13 @@ quot_f(
 			form |= XFS_RTBLOCK_QUOTA;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		case 'a':
 			flags |= ALL_MOUNTS_FLAG;
@@ -389,8 +389,13 @@ quot_f(
 	if (!form)
 		form = XFS_BLOCK_QUOTA;
 
-	if (!type)
+	if (!type) {
 		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&quot_cmd);
+	}
 
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;
@@ -416,7 +421,7 @@ quot_init(void)
 	quot_cmd.cfunc = quot_f;
 	quot_cmd.argmin = 0;
 	quot_cmd.argmax = -1;
-	quot_cmd.args = _("[-bir] [-gpu] [-acv] [-f file]");
+	quot_cmd.args = _("[-bir] [-g|-p|-u] [-acv] [-f file]");
 	quot_cmd.oneline = _("summarize filesystem ownership");
 	quot_cmd.help = quot_help;
 
diff --git a/quota/quota.c b/quota/quota.c
index f6b24c3..9ba0bc9 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -32,9 +32,9 @@ quota_help(void)
 "\n"
 " display usage and quota information\n"
 "\n"
-" -g -- display group quota information\n"
-" -p -- display project quota information\n"
-" -u -- display user quota information\n"
+" -g -- display group quota information, can't coexist with -p, -u\n"
+" -p -- display project quota information, can't coexist with -g, -u\n"
+" -u -- display user quota information, can't coexist with -g, -p\n"
 " -b -- display number of blocks used\n"
 " -i -- display number of inodes used\n"
 " -r -- display number of realtime blocks used\n"
@@ -409,13 +409,13 @@ quota_f(
 			form |= XFS_RTBLOCK_QUOTA;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		case 'h':
 			flags |= HUMAN_FLAG;
@@ -437,8 +437,13 @@ quota_f(
 	if (!form)
 		form = XFS_BLOCK_QUOTA;
 
-	if (!type)
+	if (!type) {
 		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&quota_cmd);
+	}
 
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;
@@ -461,7 +466,7 @@ quota_init(void)
 	quota_cmd.cfunc = quota_f;
 	quota_cmd.argmin = 0;
 	quota_cmd.argmax = -1;
-	quota_cmd.args = _("[-bir] [-gpu] [-hnNv] [-f file] [id|name]...");
+	quota_cmd.args = _("[-bir] [-g|-p|-u] [-hnNv] [-f file] [id|name]...");
 	quota_cmd.oneline = _("show usage and limits");
 	quota_cmd.help = quota_help;
 
diff --git a/quota/report.c b/quota/report.c
index 8653134..2e7ec15 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -30,14 +30,14 @@ static cmdinfo_t report_cmd;
 static void
 dump_help(void)
 {
-	dump_cmd.args = _("[-gpu] [-f file]");
+	dump_cmd.args = _("[-g|-p|-u] [-f file]");
 	dump_cmd.oneline = _("dump quota information for backup utilities");
 	printf(_(
 "\n"
 " create a backup file which contains quota limits information\n"
-" -g -- dump out group quota limits\n"
-" -p -- dump out project quota limits\n"
-" -u -- dump out user quota limits (default)\n"
+" -g -- dump out group quota limits, can't coexist with -p, -u\n"
+" -p -- dump out project quota limits, can't coexist with -g, -u\n"
+" -u -- dump out user quota limits (default), cant coexist with -g, -p\n"
 " -f -- write the dump out to the specified file\n"
 "\n"));
 }
@@ -199,7 +199,7 @@ dump_f(
 	FILE		*fp;
 	char		*fname = NULL;
 	uint		lower = 0, upper = 0;
-	int		c, type = XFS_USER_QUOTA;
+	int		c, type = 0;
 
 	while ((c = getopt(argc, argv, "f:gpuL:U:")) != EOF) {
 		switch(c) {
@@ -207,13 +207,13 @@ dump_f(
 			fname = optarg;
 			break;
 		case 'g':
-			type = XFS_GROUP_QUOTA;
+			type |= XFS_GROUP_QUOTA;
 			break;
 		case 'p':
-			type = XFS_PROJ_QUOTA;
+			type |= XFS_PROJ_QUOTA;
 			break;
 		case 'u':
-			type = XFS_USER_QUOTA;
+			type |= XFS_USER_QUOTA;
 			break;
 		case 'L':
 			lower = (uint)atoi(optarg);
@@ -229,6 +229,14 @@ dump_f(
 	if (argc != optind)
 		return command_usage(&dump_cmd);
 
+	if (!type) {
+		type = XFS_USER_QUOTA;
+	} else if (type != XFS_GROUP_QUOTA
+	           && type != XFS_PROJ_QUOTA
+	           && type != XFS_USER_QUOTA) {
+		return command_usage(&dump_cmd);
+	}
+
 	if ((fp = fopen_write_secure(fname)) == NULL)
 		return 0;
 
@@ -725,7 +733,7 @@ report_init(void)
 	dump_cmd.cfunc = dump_f;
 	dump_cmd.argmin = 0;
 	dump_cmd.argmax = -1;
-	dump_cmd.args = _("[-gpu] [-f file]");
+	dump_cmd.args = _("[-g|-p|-u] [-f file]");
 	dump_cmd.oneline = _("dump quota information for backup utilities");
 	dump_cmd.help = dump_help;
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
