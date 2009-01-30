Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U7ltCL009150 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 01:47:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52832CB429
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 23:47:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HxwmYGGK62atkTTO for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 23:47:14 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LSo5q-0002Lq-3D
	for xfs@oss.sgi.com; Fri, 30 Jan 2009 07:47:14 +0000
Date: Fri, 30 Jan 2009 02:47:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_db: exit on invalid magic number
Message-ID: <20090130074714.GA30377@infradead.org>
MIME-Version: 1.0
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

Fail gracefully and with a useful error message when we detect an
invalid superblock magic in xfs_db.  Add a new -F flag to continue
when seeing the invalid magic number - that way xfs_check and
xfs_metadump can be used on a filesystem that has a corrupted primary
superblock.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/db/init.c
===================================================================
--- xfsprogs-dev.orig/db/init.c	2009-01-30 06:42:25.000000000 +0000
+++ xfsprogs-dev/db/init.c	2009-01-30 06:47:34.000000000 +0000
@@ -33,6 +33,7 @@
 int		blkbb;
 int		exitcode;
 int		expert_mode;
+int		force;
 xfs_mount_t	xmount;
 xfs_mount_t	*mp;
 libxfs_init_t	x;
@@ -42,8 +43,8 @@
 usage(void)
 {
 	fprintf(stderr, _(
-		"Usage: %s [-frxV] [-p prog] [-l logdev] [-c cmd]... device\n"),
-		progname);
+		"Usage: %s [-fFrxV] [-p prog] [-l logdev] [-c cmd]... device\n"
+		), progname);
 	exit(1);
 }
 
@@ -57,7 +58,7 @@
 	int		c;
 
 	progname = basename(argv[0]);
-	while ((c = getopt(argc, argv, "c:fip:rxVl:")) != EOF) {
+	while ((c = getopt(argc, argv, "c:fFip:rxVl:")) != EOF) {
 		switch (c) {
 		case 'c':
 			cmdline = xrealloc(cmdline, (ncmdline+1)*sizeof(char*));
@@ -66,6 +67,9 @@
 		case 'f':
 			x.disfile = 1;
 			break;
+		case 'F':
+			force = 1;
+			break;
 		case 'i':
 			x.isreadonly = (LIBXFS_ISREADONLY|LIBXFS_ISINACTIVE);
 			break;
@@ -118,8 +122,10 @@
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
-		fprintf(stderr, _("%s: unexpected XFS SB magic number 0x%08x\n"),
-			progname, sbp->sb_magicnum);
+		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
+			progname, fsdevice, sbp->sb_magicnum);
+		if (!force)
+			exit(EXIT_FAILURE);
 	}
 
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
Index: xfsprogs-dev/db/xfs_check.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_check.sh	2009-01-30 06:47:56.000000000 +0000
+++ xfsprogs-dev/db/xfs_check.sh	2009-01-30 06:48:06.000000000 +0000
@@ -26,7 +26,7 @@
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
+	1)	xfs_db$DBOPTS -F -i -p xfs_check -c "check$OPTS" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
Index: xfsprogs-dev/db/xfs_check64.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_check64.sh	2009-01-30 06:47:56.000000000 +0000
+++ xfsprogs-dev/db/xfs_check64.sh	2009-01-30 06:48:11.000000000 +0000
@@ -26,7 +26,7 @@
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	xfs_db64$DBOPTS -i -p xfs_check64 -c "check$OPTS" $1
+	1)	xfs_db64$DBOPTS -F -i -p xfs_check64 -c "check$OPTS" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
Index: xfsprogs-dev/db/xfs_metadump.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_metadump.sh	2009-01-30 06:48:14.000000000 +0000
+++ xfsprogs-dev/db/xfs_metadump.sh	2009-01-30 06:48:20.000000000 +0000
@@ -29,7 +29,7 @@
 set -- extra $@
 shift $OPTIND
 case $# in
-	2)	xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1
+	2)	xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$OPTS $2" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
Index: xfsprogs-dev/man/man8/xfs_db.8
===================================================================
--- xfsprogs-dev.orig/man/man8/xfs_db.8	2009-01-30 06:42:43.000000000 +0000
+++ xfsprogs-dev/man/man8/xfs_db.8	2009-01-30 06:49:13.000000000 +0000
@@ -7,7 +7,7 @@
 .B \-c
 .I cmd
 ] ... [
-.BR \-i | r | x
+.BR \-i | r | x | F
 ] [
 .B \-f
 ] [
@@ -53,6 +53,13 @@
 an ordinary file with
 .BR xfs_copy (8).
 .TP
+.B \-F
+Specifies that we want to continue even if the superblock magic is not
+correct.  For use in
+.BR xfs_check
+and
+.BR xfs_metadump .
+.TP
 .B \-i
 Allows execution on a mounted filesystem, provided it is mounted read-only.
 Useful for shell scripts such as

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
