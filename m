Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Aug 2008 19:19:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7B2JQaK008209
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 19:19:26 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1495B1BC2F13
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 19:20:42 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 7eoBY9lDgUGutN1R for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 19:20:42 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m7B2KgIF021148
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 04:20:43 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m7B2KgEp021146
	for xfs@oss.sgi.com; Mon, 11 Aug 2008 04:20:42 +0200
Date: Mon, 11 Aug 2008 04:20:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfsprogs: fix some trivial sparse warnings
Message-ID: <20080811022042.GB21003@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Fix some trivial not endianess related sparse warnings in xfsprogs:

 - change the ASSERT defintion to avoid too deep token expansion
   warnings
 - fix 0 vs NULL noise
 - make sure functions without paramter are declared with a void
   pseudo-paramter so that they are proper ANSI declarations and
   can't be confused with a K&R declaration.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs/include/platform_defs.h.in
===================================================================
--- xfsprogs.orig/include/platform_defs.h.in	2008-08-08 14:42:18.000000000 -0300
+++ xfsprogs/include/platform_defs.h.in	2008-08-08 14:58:12.000000000 -0300
@@ -130,7 +132,7 @@ typedef unsigned long long __psunsigned_
 #include <locale.h>
 
 #ifdef DEBUG
-# define ASSERT		assert
+# define ASSERT(EX)		assert(EX)
 #else
 # define ASSERT(EX)	((void) 0)
 #endif
Index: xfsprogs/io/parent.c
===================================================================
--- xfsprogs.orig/io/parent.c	2008-08-08 15:11:20.000000000 -0300
+++ xfsprogs/io/parent.c	2008-08-08 15:11:36.000000000 -0300
@@ -242,7 +242,7 @@ parent_check(void)
         fsfd = file->fd;
 
 	fshandlep = jdm_getfshandle(mntpt);
-	if (fshandlep == 0) {
+	if (fshandlep == NULL) {
 		fprintf(stderr, _("unable to open \"%s\" for jdm: %s\n"),
 		      mntpt,
 		      strerror(errno));
Index: xfsprogs/libdisk/fstype.c
===================================================================
--- xfsprogs.orig/libdisk/fstype.c	2008-08-08 15:08:48.000000000 -0300
+++ xfsprogs/libdisk/fstype.c	2008-08-08 15:09:47.000000000 -0300
@@ -199,11 +199,11 @@ fstype(const char *device) {
        to a block device or ordinary file */
     if (stat (device, &statbuf) ||
 	!(S_ISBLK(statbuf.st_mode) || S_ISREG(statbuf.st_mode)))
-      return 0;
+      return NULL;
 
     fd = open(device, O_RDONLY);
     if (fd < 0)
-      return 0;
+      return NULL;
 
     /* do seeks and reads in disk order, otherwise a very short
        partition may cause a failure because of read error */
@@ -409,5 +409,5 @@ fstype(const char *device) {
 
 io_error:
     close(fd);
-    return 0;
+    return NULL;
 }
Index: xfsprogs/libhandle/jdm.c
===================================================================
--- xfsprogs.orig/libhandle/jdm.c	2008-08-08 15:08:31.000000000 -0300
+++ xfsprogs/libhandle/jdm.c	2008-08-08 15:08:40.000000000 -0300
@@ -70,7 +70,7 @@ jdm_getfshandle( char *mntpnt )
 	ASSERT( sizeofmember( filehandle_t, fh_pad ) == FILEHANDLE_SZ_PAD );
 	ASSERT( FILEHANDLE_SZ_PAD == sizeof( int16_t ));
 
-	fshandlep = 0; /* for lint */
+	fshandlep = NULL; /* for lint */
 	fshandlesz = sizeof( *fshandlep );
 
 	if (!realpath( mntpnt, resolved ))
Index: xfsprogs/libxcmd/projects.c
===================================================================
--- xfsprogs.orig/libxcmd/projects.c	2008-08-08 15:08:14.000000000 -0300
+++ xfsprogs/libxcmd/projects.c	2008-08-08 15:08:23.000000000 -0300
@@ -44,14 +44,14 @@ setprfiles(void)
 }
 
 void
-setprent()
+setprent(void)
 {
 	setprfiles();
 	projects = fopen(projid_file, "r");
 }
 
 void
-setprpathent()
+setprpathent(void)
 {
 	setprfiles();
 	project_paths = fopen(projects_file, "r");
Index: xfsprogs/mdrestore/xfs_mdrestore.c
===================================================================
--- xfsprogs.orig/mdrestore/xfs_mdrestore.c	2008-08-08 15:12:55.000000000 -0300
+++ xfsprogs/mdrestore/xfs_mdrestore.c	2008-08-08 15:13:40.000000000 -0300
@@ -121,7 +121,7 @@ perform_restore(
 	} else  {
 		/* ensure device is sufficiently large enough */
 
-		char		*lb[XFS_MAX_SECTORSIZE] = { 0 };
+		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
Index: xfsprogs/mkfs/proto.c
===================================================================
--- xfsprogs.orig/mkfs/proto.c	2008-08-08 15:11:48.000000000 -0300
+++ xfsprogs/mkfs/proto.c	2008-08-08 15:24:13.000000000 -0300
@@ -255,7 +255,7 @@ newfile(
 			exit(1);
 		}
 		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		bp = libxfs_trans_get_buf(logit ? tp : 0, mp->m_dev, d,
+		bp = libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
 			nb << mp->m_blkbb_log, 0);
 		memmove(XFS_BUF_PTR(bp), buf, len);
 		if (len < XFS_BUF_COUNT(bp))
@@ -293,7 +293,7 @@ newregfile(
 			exit(1);
 		}
 	} else
-		buf = 0;
+		buf = NULL;
 	close(fd);
 	return buf;
 }
Index: xfsprogs/quota/quot.c
===================================================================
--- xfsprogs.orig/quota/quot.c	2008-08-08 15:12:30.000000000 -0300
+++ xfsprogs/quota/quot.c	2008-08-08 15:24:44.000000000 -0300
@@ -107,7 +107,7 @@ quot_bulkstat_add(
 		for (dp = *hp; dp; dp = dp->next)
 			if (dp->id == id)
 				break;
-		if (dp == 0) {
+		if (dp == NULL) {
 			if (ndu[i] >= NDU)
 				return;
 			dp = &du[i][(ndu[i]++)];
@@ -153,7 +153,7 @@ quot_bulkstat_mount(
 	overflow = 0;
 	for (i = 0; i < 3; i++)
 		for (dp = duhash[i]; dp < &duhash[i][DUHASH]; dp++)
-			*dp = 0;
+			*dp = NULL;
 	ndu[0] = ndu[1] = ndu[2] = 0;
 
 	fsfd = open(fsdir, O_RDONLY);
@@ -275,7 +275,7 @@ quot_report(
 	fs_cursor_t	cursor;
 	fs_path_t	*mount;
 
-	now = time(0);
+	now = time(NULL);
 	fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 	while ((mount = fs_cursor_next_entry(&cursor))) {
 		quot_bulkstat_mount(mount->fs_dir, flags);
Index: xfsprogs/repair/xfs_repair.c
===================================================================
--- xfsprogs.orig/repair/xfs_repair.c	2008-08-08 15:14:16.000000000 -0300
+++ xfsprogs/repair/xfs_repair.c	2008-08-08 15:15:16.000000000 -0300
@@ -245,18 +245,18 @@ process_args(int argc, char **argv)
 					pre_65_beta = 1;
 					break;
 				case IHASH_SIZE:
-					libxfs_ihash_size = (int) strtol(val, 0, 0);
+					libxfs_ihash_size = (int) strtol(val, NULL, 0);
 					ihash_option_used = 1;
 					break;
 				case BHASH_SIZE:
 					if (max_mem_specified)
 						do_abort(
 			_("-o bhash option cannot be used with -m option\n"));
-					libxfs_bhash_size = (int) strtol(val, 0, 0);
+					libxfs_bhash_size = (int) strtol(val, NULL, 0);
 					bhash_option_used = 1;
 					break;
 				case AG_STRIDE:
-					ag_stride = (int) strtol(val, 0, 0);
+					ag_stride = (int) strtol(val, NULL, 0);
 					break;
 				default:
 					unknown('o', val);
@@ -271,7 +271,7 @@ process_args(int argc, char **argv)
 
 				switch (getsubopt(&p, (constpp)c_opts, &val)) {
 				case CONVERT_LAZY_COUNT:
-					lazy_count = (int)strtol(val, 0, 0);
+					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
 					break;
 				default:
@@ -295,7 +295,7 @@ process_args(int argc, char **argv)
 			if (bhash_option_used)
 				do_abort(_("-m option cannot be used with "
 						"-o bhash option\n"));
-			max_mem_specified = strtol(optarg, 0, 0);
+			max_mem_specified = strtol(optarg, NULL, 0);
 			break;
 		case 'L':
 			zap_log = 1;
@@ -316,7 +316,7 @@ process_args(int argc, char **argv)
 			do_prefetch = 0;
 			break;
 		case 't':
-			report_interval = (int) strtol(optarg, 0, 0);
+			report_interval = (int) strtol(optarg, NULL, 0);
 			break;
 		case '?':
 			usage();
Index: xfsprogs/rtcp/xfs_rtcp.c
===================================================================
--- xfsprogs.orig/rtcp/xfs_rtcp.c	2008-08-08 15:15:26.000000000 -0300
+++ xfsprogs/rtcp/xfs_rtcp.c	2008-08-08 15:15:31.000000000 -0300
@@ -25,7 +25,7 @@ int pflag;
 char *progname;
 
 void
-usage()
+usage(void)
 {
 	fprintf(stderr, _("%s [-e extsize] [-p] source target\n"), progname);
 	exit(2);
Index: xfsprogs/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs.orig/mkfs/xfs_mkfs.c	2008-08-08 15:24:17.000000000 -0300
+++ xfsprogs/mkfs/xfs_mkfs.c	2008-08-08 15:24:29.000000000 -0300
@@ -1258,7 +1258,7 @@ main(
 			break;
 		case 'p':
 			if (protofile)
-				respec('p', 0, 0);
+				respec('p', NULL, 0);
 			protofile = optarg;
 			break;
 		case 'q':
