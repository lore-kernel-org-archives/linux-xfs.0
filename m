Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0P54SrR094702 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 23:04:29 -0600
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48555B555E
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 21:03:44 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com
	with ESMTP id Rh1AJihsL5GJa2pF for <xfs@oss.sgi.com>;
	Sat, 24 Jan 2009 21:03:44 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id
	n0P53gIF030164
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:03:42 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id n0P53gIb030162
	for xfs@oss.sgi.com; Sun, 25 Jan 2009 06:03:42 +0100
Date: Sun, 25 Jan 2009 06:03:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs_admin: exit gracefully for non-XFS fileststems
Message-ID: <20090125050342.GA30091@lst.de>
Mime-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Exit gracefully if the magic number doesn't match xfs in xfs_admin
and xfs_ncheck.  This is implemented by a new -C option to xfs_db
which makes it exit with a useful error message in case the filesystem
doesn't match the XFS superblock magic number.


Reported-by: Dick Middleton <dick@lingbrae.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/db/init.c
===================================================================
--- xfsprogs-dev.orig/db/init.c	2009-01-24 19:04:48.517429102 +0100
+++ xfsprogs-dev/db/init.c	2009-01-24 19:11:03.003555709 +0100
@@ -42,7 +42,7 @@ static void
 usage(void)
 {
 	fprintf(stderr, _(
-		"Usage: %s [-frxV] [-p prog] [-l logdev] [-c cmd]... device\n"),
+		"Usage: %s [-CfrxV] [-p prog] [-l logdev] [-c cmd]... device\n"),
 		progname);
 	exit(1);
 }
@@ -55,10 +55,14 @@ init(
 	xfs_sb_t	*sbp;
 	void		*bufp = NULL;
 	int		c;
+	int		check = 0;
 
 	progname = basename(argv[0]);
-	while ((c = getopt(argc, argv, "c:fip:rxVl:")) != EOF) {
+	while ((c = getopt(argc, argv, "c:Cfip:rxVl:")) != EOF) {
 		switch (c) {
+		case 'C':
+			check = 1;
+			break;
 		case 'c':
 			cmdline = xrealloc(cmdline, (ncmdline+1)*sizeof(char*));
 			cmdline[ncmdline++] = optarg;
@@ -118,6 +122,11 @@ init(
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+		if (check) {
+			fprintf(stderr, _("%s: not an XFS filesystem\n"),
+				progname);
+			exit(1);
+		}
 		fprintf(stderr, _("%s: unexpected XFS SB magic number 0x%08x\n"),
 			progname, sbp->sb_magicnum);
 	}
Index: xfsprogs-dev/db/xfs_admin.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_admin.sh	2009-01-24 19:11:26.867554445 +0100
+++ xfsprogs-dev/db/xfs_admin.sh	2009-01-24 19:13:55.950426543 +0100
@@ -30,7 +30,7 @@ shift $OPTIND
 case $# in
 	1)	if [ -n "$DB_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $DB_OPTS $1
+			eval xfs_db -x -p xfs_admin -C $DB_OPTS $1
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
Index: xfsprogs-dev/db/xfs_ncheck.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_ncheck.sh	2009-01-24 19:14:34.903429336 +0100
+++ xfsprogs-dev/db/xfs_ncheck.sh	2009-01-24 19:14:42.105429164 +0100
@@ -25,7 +25,7 @@ done
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	xfs_db$DBOPTS -r -p xfs_ncheck -c "blockget -ns" -c "ncheck$OPTS" $1
+	1)	xfs_db$DBOPTS -r -p xfs_ncheck -C -c "blockget -ns" -c "ncheck$OPTS" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
Index: xfsprogs-dev/db/xfs_ncheck64.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_ncheck64.sh	2009-01-24 19:14:34.924457708 +0100
+++ xfsprogs-dev/db/xfs_ncheck64.sh	2009-01-24 19:14:52.707429049 +0100
@@ -24,7 +24,7 @@ done
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	xfs_db64$DBOPTS -r -p xfs_ncheck64 -c "blockget -ns" -c "ncheck$OPTS" $1
+	1)	xfs_db64$DBOPTS -r -p xfs_ncheck64 -C -c "blockget -ns" -c "ncheck$OPTS" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
Index: xfsprogs-dev/man/man8/xfs_db.8
===================================================================
--- xfsprogs-dev.orig/man/man8/xfs_db.8	2009-01-24 19:15:16.855428751 +0100
+++ xfsprogs-dev/man/man8/xfs_db.8	2009-01-24 19:17:21.689554003 +0100
@@ -11,6 +11,8 @@ xfs_db \- debug an XFS filesystem
 ] [
 .B \-f
 ] [
+.B \-C
+] [
 .B \-l
 .I logdev
 ] [
@@ -32,6 +34,10 @@ that run
 .PP
 .SH OPTIONS
 .TP
+.B \-C
+Check the superblock magic number and exit gracefully if the filesystem is not
+an XFS filesystem.
+.TP
 .BI \-c " cmd"
 .B xfs_db
 commands may be run interactively (the default) or as arguments

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
