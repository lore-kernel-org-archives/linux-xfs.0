Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGi0ag006462 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 651CD1775789
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CS6asKDdaWeu4guk for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:59 -0800 (PST)
Message-Id: <20081222164357.420676000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/20] return error status from the xfs_quota tool
Content-Disposition: inline; filename=xfsprogs-quota-exitstatus.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Arkadiusz Miskiewicz <arekm@maven.pl>

xfs_quota doesn't report success/failure in exit status 
which prevents it from being used in automated scripts easily.

Add proper exit codes.


Reviewed-by: Christoph Hellwig <hch@lst.de>

diff -urN xfs-cmds/xfsprogs/quota.org/edit.c xfs-cmds/xfsprogs/quota/edit.c
--- xfs-cmds/xfsprogs/quota.org/edit.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/edit.c	2008-04-18 15:46:17.838170367 +0200
@@ -140,9 +140,11 @@
 	d.d_rtb_hardlimit = *rtbhard;
 	d.d_rtb_softlimit = *rtbsoft;
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0)
+	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set limits: %s\n"),
 				progname, strerror(errno));
+	}
 }
 
 static void
@@ -159,10 +161,11 @@
 {
 	uid_t		uid = uid_from_string(name);
 
-	if (uid == -1)
+	if (uid == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: invalid user name: %s\n"),
 				progname, name);
-	else
+	} else
 		set_limits(uid, type, mask, fs_path->fs_name,
 				bsoft, bhard, isoft, ihard, rtbsoft, rtbhard);
 }
@@ -181,10 +184,11 @@
 {
 	gid_t		gid = gid_from_string(name);
 
-	if (gid == -1)
+	if (gid == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: invalid group name: %s\n"),
 				progname, name);
-	else
+	} else
 		set_limits(gid, type, mask, fs_path->fs_name,
 				bsoft, bhard, isoft, ihard, rtbsoft, rtbhard);
 }
@@ -203,10 +207,11 @@
 {
 	prid_t		prid = prid_from_string(name);
 
-	if (prid == -1)
+	if (prid == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: invalid project name: %s\n"),
 				progname, name);
-	else
+	} else
 		set_limits(prid, type, mask, fs_path->fs_name,
 				bsoft, bhard, isoft, ihard, rtbsoft, rtbhard);
 }
@@ -315,12 +320,14 @@
 		else if (extractb(s, "rtbhard=", 7, bsize, ssize, &rtbhard))
 			mask |= FS_DQ_RTBHARD;
 		else {
+			exitcode = 1;
 			fprintf(stderr, _("%s: unrecognised argument %s\n"),
 				progname, s);
 			return 0;
 		}
 	}
 	if (!mask) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot find any valid arguments\n"),
 			progname);
 		return 0;
@@ -428,6 +435,7 @@
 
 	if (fname) {
 		if ((fp = fopen(fname, "r")) == NULL) {
+			exitcode = 1;
 			fprintf(stderr, _("%s: fopen on %s failed: %s\n"),
 				progname, fname, strerror(errno));
 			return 0;
@@ -458,9 +466,11 @@
 	d.d_btimer = value;
 	d.d_rtbtimer = value;
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, 0, (void *)&d) < 0)
+	if (xfsquotactl(XFS_SETQLIM, dev, type, 0, (void *)&d) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set timer: %s\n"),
 				progname, strerror(errno));
+	}
 }
 
 static int
@@ -530,9 +540,11 @@
 	d.d_bwarns = value;
 	d.d_rtbwarns = value;
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0)
+	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set warnings: %s\n"),
 				progname, strerror(errno));
+	}
 }
 
 static void
@@ -544,10 +556,11 @@
 {
 	uid_t		uid = uid_from_string(name);
 
-	if (uid == -1)
+	if (uid == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: invalid user name: %s\n"),
 				progname, name);
-	else
+	} else
 		set_warnings(uid, type, mask, fs_path->fs_name, value);
 }
 
@@ -560,10 +573,11 @@
 {
 	gid_t		gid = gid_from_string(name);
 
-	if (gid == -1)
+	if (gid == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: invalid group name: %s\n"),
 				progname, name);
-	else
+	} else
 		set_warnings(gid, type, mask, fs_path->fs_name, value);
 }
 
@@ -576,10 +590,11 @@
 {
 	prid_t		prid = prid_from_string(name);
 
-	if (prid == -1)
+	if (prid == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: invalid project name: %s\n"),
 				progname, name);
-	else
+	} else
 		set_warnings(prid, type, mask, fs_path->fs_name, value);
 }
 
diff -urN xfs-cmds/xfsprogs/quota.org/free.c xfs-cmds/xfsprogs/quota/free.c
--- xfs-cmds/xfsprogs/quota.org/free.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/free.c	2008-04-18 15:46:57.233387016 +0200
@@ -61,6 +61,7 @@
 	int			fd;
 
 	if ((fd = open(mount->fs_dir, O_RDONLY)) < 0) {
+		exitcode = 1;
 		fprintf(stderr, "%s: cannot open %s: %s\n",
 			progname, mount->fs_dir, strerror(errno));
 		return 0;
@@ -128,17 +129,20 @@
 		return 0;
 
 	if ((fd = open(path->fs_dir, O_RDONLY)) < 0) {
+		exitcode = 1;
 		fprintf(stderr, "%s: cannot open %s: %s\n",
 			progname, path->fs_dir, strerror(errno));
 		return 0;
 	}
 
 	if ((xfsctl(path->fs_dir, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+		exitcode = 1;
 		perror("XFS_IOC_FSGETXATTR");
 		close(fd);
 		return 0;
 	}
 	if (!(fsx.fsx_xflags & XFS_XFLAG_PROJINHERIT)) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: project quota flag not set on %s\n"),
 			progname, path->fs_dir);
 		close(fd);
@@ -146,6 +150,7 @@
 	}
 
 	if (path->fs_prid != fsx.fsx_projid) {
+		exitcode = 1;
 		fprintf(stderr,
 			_("%s: project ID %u (%s) doesn't match ID %u (%s)\n"),
 			progname, path->fs_prid, projects_file,
diff -urN xfs-cmds/xfsprogs/quota.org/project.c xfs-cmds/xfsprogs/quota/project.c
--- xfs-cmds/xfsprogs/quota.org/project.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/project.c	2008-04-18 15:49:06.202885828 +0200
@@ -91,6 +91,7 @@
 	int			fd;
 
 	if (flag == FTW_NS ){
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
 		return 0;
 	}
@@ -99,14 +100,16 @@
 		return 0;
 	}
 
-	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1)
+	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
-	else if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0)
+	} else if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
-	else {
-		if (fsx.fsx_projid != prid)
+	} else {
+		if (fsx.fsx_projid != prid)
 			printf(_("%s - project identifier is not set"
 				 " (inode=%u, tree=%u)\n"),
 				path, fsx.fsx_projid, (unsigned int)prid);
@@ -130,6 +133,7 @@
 	int			fd;
 
 	if (flag == FTW_NS ){
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
 		return 0;
 	}
@@ -139,10 +143,12 @@
 	}
 
 	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
 		return 0;
 	} else if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 		close(fd);
@@ -151,9 +157,11 @@
 
 	fsx.fsx_projid = 0;
 	fsx.fsx_xflags &= ~XFS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0)
+	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
 			progname, path, strerror(errno));
+	}
 	close(fd);
 	return 0;
 }
@@ -169,6 +177,7 @@
 	int			fd;
 
 	if (flag == FTW_NS ){
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
 		return 0;
 	}
@@ -178,10 +187,12 @@
 	}
 
 	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
 		return 0;
 	} else if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 		close(fd);
@@ -190,9 +201,11 @@
 
 	fsx.fsx_projid = prid;
 	fsx.fsx_xflags |= XFS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0)
+	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
 			progname, path, strerror(errno));
+	}
 	close(fd);
 	return 0;
 }
@@ -272,6 +285,7 @@
 
 	setprfiles();
 	if (access(projects_file, F_OK) != 0) {
+		exitcode = 1;
 		fprintf(stderr, _("projects file \"%s\" doesn't exist\n"),
 			projects_file);
 		return 0;
@@ -279,10 +293,11 @@
 
         while (argc > optind) {
 		prid = prid_from_string(argv[optind]);
-		if (prid == -1)
+		if (prid == -1) {
+			exitcode = 1;
 			fprintf(stderr, _("%s - no such project in %s\n"),
 				argv[optind], projects_file);
-		else
+		} else
 	                project(argv[optind], type);
 		optind++;
 	}
diff -urN xfs-cmds/xfsprogs/quota.org/quota.c xfs-cmds/xfsprogs/quota/quota.c
--- xfs-cmds/xfsprogs/quota.org/quota.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/quota.c	2008-04-18 15:49:28.803966289 +0200
@@ -231,6 +231,7 @@
 			id = u->pw_uid;
 			name = u->pw_name;
 		} else {
+			exitcode = 1;
 			fprintf(stderr, _("%s: cannot find user %s\n"),
 				progname, name);
 			return;
@@ -280,6 +281,7 @@
 				gid = g->gr_gid;
 				name = g->gr_name;
 			} else {
+				exitcode = 1;
 				fprintf(stderr, _("%s: cannot find group %s\n"),
 					progname, name);
 				return;
@@ -336,6 +338,7 @@
 	prid_t		id;
 
 	if (!name) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: must specify a project name/ID\n"),
 			progname);
 		return;
@@ -348,6 +351,7 @@
 		id = p->pr_prid;
 		name = p->pr_name;
 	} else {
+		exitcode = 1;
 		fprintf(stderr, _("%s: cannot find project %s\n"),
 			progname, name);
 		return;
diff -urN xfs-cmds/xfsprogs/quota.org/report.c xfs-cmds/xfsprogs/quota/report.c
--- xfs-cmds/xfsprogs/quota.org/report.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/report.c	2008-04-18 15:49:40.684534248 +0200
@@ -115,6 +115,7 @@
 	uint		id;
 
 	if ((mount = fs_table_lookup(dir, FS_MOUNT_POINT)) == NULL) {
+		exitcode = 1;
 		fprintf(stderr, "%s: cannot find mount point %s\n",
 			progname, dir);
 		return;
diff -urN xfs-cmds/xfsprogs/quota.org/state.c xfs-cmds/xfsprogs/quota/state.c
--- xfs-cmds/xfsprogs/quota.org/state.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/state.c	2008-04-18 15:50:18.026319397 +0200
@@ -253,6 +253,7 @@
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
+		exitcode = 1;
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
@@ -274,6 +275,7 @@
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
+		exitcode = 1;
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
@@ -295,6 +297,7 @@
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
+		exitcode = 1;
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
@@ -327,6 +330,7 @@
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
+		exitcode = 1;
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
diff -urN xfs-cmds/xfsprogs/quota.org/util.c xfs-cmds/xfsprogs/quota/util.c
--- xfs-cmds/xfsprogs/quota.org/util.c	2007-09-11 04:01:20.000000000 +0200
+++ xfs-cmds/xfsprogs/quota/util.c	2008-04-18 15:50:29.823550039 +0200
@@ -413,11 +413,13 @@
 		return stdout;
 
 	if ((fd = open(fname, O_CREAT|O_WRONLY|O_EXCL, 0600)) < 0) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: open on %s failed: %s\n"),
 			progname, fname, strerror(errno));
 		return NULL;
 	}
 	if ((fp = fdopen(fd, "w")) == NULL) {
+		exitcode = 1;
 		fprintf(stderr, _("%s: fdopen on %s failed: %s\n"),
 			progname, fname, strerror(errno));
 		close(fd);

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
