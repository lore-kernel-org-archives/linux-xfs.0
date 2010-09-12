Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8CGXghs018280 for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 11:33:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09D9114EF9D7
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 09:46:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HLKkwmbkHkNTzvIn for
	<xfs@oss.sgi.com>; Sun, 12 Sep 2010 09:46:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OupVc-0002px-PZ
	for xfs@oss.sgi.com; Sun, 12 Sep 2010 16:34:28 +0000
Date: Sun, 12 Sep 2010 12:34:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_fsr: use /proc/mounts if available
Message-ID: <20100912163428.GA10843@infradead.org>
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

Prefer /proc/mounts if it exists over /etc/mtab to get a correct picture
of the kernels mount table for this process.  This works arounds some
userspace like pam_mount polluting /etc/mtab with incorrect entries.

Also remove the "mtab" global variable and instead pass it explicitly
to fsrallfs, like we already do for other functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/fsr/xfs_fsr.c
===================================================================
--- xfsprogs-dev.orig/fsr/xfs_fsr.c	2010-09-11 20:06:15.000000000 +0000
+++ xfsprogs-dev/fsr/xfs_fsr.c	2010-09-12 16:28:17.000000000 +0000
@@ -42,7 +42,9 @@
 #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
 #endif
 
-#define _PATH_FSRLAST	"/var/tmp/.fsrlast_xfs"
+#define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
+
 
 char *progname;
 
@@ -79,7 +81,6 @@ static __int64_t	minimumfree = 2048;
 
 static time_t howlong = 7200;		/* default seconds of reorganizing */
 static char *leftofffile = _PATH_FSRLAST; /* where we left off last */
-static char *mtab = MOUNTED;
 static time_t endtime;
 static time_t starttime;
 static xfs_ino_t	leftoffino = 0;
@@ -94,7 +95,7 @@ static int  packfile(char *fname, char *
 static void fsrdir(char *dirname);
 static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
 static void initallfs(char *mtab);
-static void fsrallfs(int howlong, char *leftofffile);
+static void fsrallfs(char *mtab, int howlong, char *leftofffile);
 static void fsrall_cleanup(int timeout);
 static int  getnextents(int);
 int xfsrtextsize(int fd);
@@ -187,6 +188,7 @@ main(int argc, char **argv)
 	struct mntent mntpref;
 	register struct mntent *mntp;
 	struct mntent ment;
+	char *mtab = NULL;
 	register FILE *mtabp;
 
 	setlinebuf(stdout);
@@ -198,7 +200,7 @@ main(int argc, char **argv)
 
 	gflag = ! isatty(0);
 
-	while ((c = getopt(argc, argv, "C:p:e:MgsdnvTt:f:m:b:N:FV")) != -1 )
+	while ((c = getopt(argc, argv, "C:p:e:MgsdnvTt:f:m:b:N:FV")) != -1) {
 		switch (c) {
 		case 'M':
 			Mflag = 1;
@@ -250,6 +252,22 @@ main(int argc, char **argv)
 		default:
 			usage(1);
 		}
+	}
+
+	/*
+	 * If the user did not specify an explicit mount table, try to use
+	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
+	 * /proc/mounts because it is kernel controlled, while /etc/mtab
+	 * may contain garbage that userspace tools like pam_mounts wrote
+	 * into it.
+	 */
+	if (!mtab) {
+		if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
+			mtab = _PATH_PROC_MOUNTS;
+		else
+			mtab = _PATH_MOUNTED;
+	}
+
 	if (vflag)
 		setbuf(stdout, NULL);
 
@@ -330,7 +348,7 @@ main(int argc, char **argv)
 		}
 	} else {
 		initallfs(mtab);
-		fsrallfs(howlong, leftofffile);
+		fsrallfs(mtab, howlong, leftofffile);
 	}
 	return 0;
 }
@@ -447,7 +465,7 @@ initallfs(char *mtab)
 }
 
 static void
-fsrallfs(int howlong, char *leftofffile)
+fsrallfs(char *mtab, int howlong, char *leftofffile)
 {
 	int fd;
 	int error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
