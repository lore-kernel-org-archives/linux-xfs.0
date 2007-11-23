Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 06:31:17 -0800 (PST)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANEV5lW001190
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 06:31:06 -0800
Message-ID: <4746E41C.7090803@linworks.de>
Date: Fri, 23 Nov 2007 15:30:52 +0100
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com> <20071120013651.GR995458@sgi.com>
In-Reply-To: <20071120013651.GR995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

David Chinner schrieb:
> On Thu, Oct 04, 2007 at 02:25:16PM +1000, Barry Naujok wrote:
>   
>> A couple changes from the first xfs_reno:
>>
>>  - Major one is that symlinks are now supported, but only
>>    owner, group and extended attributes are copied for them
>>    (not times or inode attributes).
>>
>>  - Man page!
>>
>>
>> To make this better, ideally we need some form of
>> "swap inodes" function in the kernel, where the entire
>> contents of the inode themselves are swapped. This form
>> can handle any inode and without any of the dir/file/attr/etc
>> copy/swap mechanisms we have in xfs_reno.
>>     
>
> Something like the attached patch?
>
> This is proof-of-concept. I've compiled it but I haven't tested
> it. Your mission, Barry, should you choose to accept it, it to
> make it work ;)
>
> Cheers,
>
> Dave.
>   
Great!

Inline are changes to xfs_reno to make it use the new ioctl. It is also 
a proof-of-concept. I've compiled it but I haven't tested it ;)

Now process_(dir|file|slink) do more or less the same, should be a good 
idea to mix them in one function as I did with them inside the "recover" 
function.

I also did s/sx/si/ on the xfs_swapino_t to make the notation consistent 
with xfs_swapext_t.

Some questions,

why do we use ftruncate on files?

before moving file inodes, XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND are 
checked. I extended the check also for directories but not for symlinks. 
Under which conditions are these flags setted. Can't we skip the test no 
that we do struct copy of the inode?

Have a nice weekend.

-- 
Rubén Porras
LinWorks GmbH

--
xfs_reno.c |  737 +++++++++++++++++--------------------------------------------
 1 file changed, 212 insertions(+), 525 deletions(-)

--- xfs_reno_old.c	2007-11-22 18:55:36.276029053 +0100
+++ xfs_reno.c	2007-11-23 15:00:53.283564811 +0100
@@ -50,30 +50,24 @@
 #include <xfs/xfs_dfrag.h>
 #include <xfs/xfs_inum.h>
 
-#define ATTRBUFSIZE	1024
-
 #define SCAN_PHASE	0x00
 #define DIR_PHASE	0x10	/* nothing done or all done */
-#define DIR_PHASE_1	0x11	/* target dir created */
-#define DIR_PHASE_2	0x12	/* temp dir created */
-#define DIR_PHASE_3	0x13	/* attributes backed up to temp */
-#define DIR_PHASE_4	0x14	/* dirents moved to target dir */
-#define DIR_PHASE_5	0x15	/* attributes applied to target dir */
-#define DIR_PHASE_6	0x16	/* src dir removed */
-#define DIR_PHASE_7	0x17	/* temp dir removed */
-#define DIR_PHASE_MAX	0x17
+#define DIR_PHASE_1	0x11	/* temp dir created */
+#define DIR_PHASE_2	0x12	/* swapped extents and inodes */
+#define DIR_PHASE_3	0x13	/* src dir removed */
+#define DIR_PHASE_MAX	0x13	/* renamed temp to source name */
 #define FILE_PHASE	0x20	/* nothing done or all done */
 #define FILE_PHASE_1	0x21	/* temp file created */
-#define FILE_PHASE_2	0x22	/* swapped extents */
+#define FILE_PHASE_2	0x22	/* swapped extents and inodes */
 #define FILE_PHASE_3	0x23	/* unlinked source */
-#define FILE_PHASE_4	0x24	/* renamed temp to source name */
-#define FILE_PHASE_MAX	0x24
+#define FILE_PHASE_4	0x24	/* hard links copied */
+#define FILE_PHASE_MAX	0x24	/* renamed temp to source name */
 #define SLINK_PHASE	0x30	/* nothing done or all done */
 #define SLINK_PHASE_1	0x31	/* temp symlink created */
 #define SLINK_PHASE_2	0x32	/* symlink attrs copied */
 #define SLINK_PHASE_3	0x33	/* unlinked source */
-#define SLINK_PHASE_4	0x34	/* renamed temp to source name */
-#define SLINK_PHASE_MAX	0x34
+#define SLINK_PHASE_4	0x34	/* hard links copied */
+#define SLINK_PHASE_MAX	0x34	/* renamed temp to source name */
 
 static void update_recoverfile(void);
 #define SET_PHASE(x)	(cur_phase = x, update_recoverfile())
@@ -117,7 +111,6 @@
 static time_t		starttime;
 static bignode_t	*cur_node;
 static char		*cur_target;
-static char		*cur_temp;
 static int		cur_phase;
 static int		highest_numpaths;
 static char		*recover_file;
@@ -189,6 +182,60 @@
 	err_message(_("Cannot stat %s: %s\n"), s, strerror(errno));
 }
 
+static void
+err_swapino(
+	    int err,
+	    const char *srcname)
+{
+	if (log_level >= LOG_DEBUG) {
+		switch (err) {
+		case EIO:
+			err_message(_("Filesystem is going down: %s: %s"),
+				srcname, strerror(err));
+			break;
+
+		default:
+			err_message(_("Swap inode failed: %s: %s"),
+				srcname, strerror(err));
+			break;
+		}
+	} else
+		err_message(_("Swap inode failed: %s: %s"),
+				srcname, strerror(err));
+}
+
+static void
+err_swapext(
+	    int err,
+	    const char *srcname,
+	    xfs_off_t bs_size)
+{
+	if (log_level >= LOG_DEBUG) {
+		switch (err) {
+		case ENOTSUP:
+			err_message("%s: file type not supported",
+				srcname);
+			break;
+		case EFAULT:
+			/* The file has changed since we started the copy */
+			err_message("%s: file modified, "
+				 "inode renumber aborted: %ld",
+				 srcname, bs_size);
+			break;
+		case EBUSY:
+			/* Timestamp has changed or mmap'ed file */
+			err_message("%s: file busy", srcname);
+			break;
+		default:
+			err_message(_("Swap extents failed: %s: %s"),
+				srcname, strerror(errno));
+			break;
+		}
+	} else
+		err_message(_("Swap extents failed: %s: %s"),
+				srcname, strerror(errno));
+}
+
 /*
  * usage message
  */
@@ -224,15 +271,15 @@
 }
 
 static int
-xfs_getxattr(int fd, struct fsxattr *attr)
+xfs_swapino(int fd, xfs_swapino_t *iu)
 {
-	return ioctl(fd, XFS_IOC_FSGETXATTR, attr);
+	return ioctl(fd, XFS_IOC_SWAPINO, iu);
 }
 
 static int
-xfs_setxattr(int fd, struct fsxattr *attr)
+xfs_getxattr(int fd, struct fsxattr *attr)
 {
-	return ioctl(fd, XFS_IOC_FSSETXATTR, attr);
+	return ioctl(fd, XFS_IOC_FSGETXATTR, attr);
 }
 
 /*
@@ -461,253 +508,19 @@
 	return 0;
 }
 
-/*
- * Attribute cloning code - most of this is here because attr_copy does not
- * let us pick and choose which attributes we want to copy.
- */
-
-attr_multiop_t	attr_ops[ATTR_MAX_MULTIOPS];
-
-/*
- * Grab attributes specified in attr_ops from source file and write them
- * out on the destination file.
- */
-
-static int
-attr_replicate(
-	char		*source,
-	char		*target,
-	int		count)
-{
-	int		j, k;
-
-	if (attr_multi(source, attr_ops, count, ATTR_DONTFOLLOW) < 0)
-		return -1;
-
-	for (k = 0; k < count; k++) {
-		if (attr_ops[k].am_error) {
-			err_message(_("Error %d getting attribute"),
-					attr_ops[k].am_error);
-			break;
-		}
-		attr_ops[k].am_opcode = ATTR_OP_SET;
-	}
-	if (attr_multi(target, attr_ops, k, ATTR_DONTFOLLOW) < 0)
-		err_message("on attr_multif set");
-	for (j = 0; j < k; j++) {
-		if (attr_ops[j].am_error) {
-			err_message(_("Error %d setting attribute"),
-					attr_ops[j].am_error);
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Copy all the attributes specified from src to dst.
- */
-
-static int
-attr_clone_copy(
-	char		*source,
-	char		*target,
-	char		*list_buf,
-	char		*attr_buf,
-	int		buf_len,
-	int		flags)
-{
-        attrlist_t 	*alist;
-        attrlist_ent_t	*attr;
-        attrlist_cursor_t cursor;
-        int		space, i, j;
-	char		*ptr;
-
-        bzero((char *)&cursor, sizeof(cursor));
-        do {
-                if (attr_list(source, list_buf, ATTRBUFSIZE,
-                		flags | ATTR_DONTFOLLOW, &cursor) < 0) {
-			err_message("on attr_listf");
-                        return -1;
-		}
-
-                alist = (attrlist_t *)list_buf;
-
-		space = buf_len;
-		ptr = attr_buf;
-                for (j = 0, i = 0; i < alist->al_count; i++) {
-                        attr = ATTR_ENTRY(list_buf, i);
-			if (space < attr->a_valuelen) {
-				if (attr_replicate(source, target, j) < 0)
-					return -1;
-				j = 0;
-				space = buf_len;
-				ptr = attr_buf;
-			}
-			attr_ops[j].am_opcode = ATTR_OP_GET;
-			attr_ops[j].am_attrname = attr->a_name;
-			attr_ops[j].am_attrvalue = ptr;
-			attr_ops[j].am_length = (int) attr->a_valuelen;
-			attr_ops[j].am_flags = flags;
-			attr_ops[j].am_error = 0;
-			j++;
-			ptr += attr->a_valuelen;
-			space -= attr->a_valuelen;
-                }
-
-		log_message(LOG_NITTY, "copying attribute %d", i);
-
-		if (j) {
-			if (attr_replicate(source, target, j) < 0)
-				return -1;
-		}
-
-        } while (alist->al_more);
-
-        return 0;
-}
-
-static int
-clone_attribs(
-	char		*source,
-	char		*target)
-{
-	char		list_buf[ATTRBUFSIZE];
-	char		*attr_buf;
-	int		rval;
-
-	attr_buf = malloc(ATTR_MAX_VALUELEN * 2);
-	if (attr_buf == NULL) {
-		err_nomem();
-		return -1;
-	}
-	rval = attr_clone_copy(source, target, list_buf, attr_buf,
-			ATTR_MAX_VALUELEN * 2, 0);
-	if (rval == 0)
-		rval = attr_clone_copy(source, target, list_buf, attr_buf,
-				ATTR_MAX_VALUELEN * 2, ATTR_ROOT);
-	if (rval == 0)
-		rval = attr_clone_copy(source, target, list_buf, attr_buf,
-				ATTR_MAX_VALUELEN * 2, ATTR_SECURE);
-	free(attr_buf);
-	return rval;
-}
-
-static int
-dup_attributes(
-	char		*source,
-	int		sfd,
-	char		*target,
-	int		tfd)
-{
-	struct stat64	st;
-	struct timeval	tv[2];
-	struct fsxattr	fsx;
-
-	if (fstat64(sfd, &st) < 0) {
-		err_stat(source);
-		return -1;
-	}
-
-	if (xfs_getxattr(sfd, &fsx) < 0) {
-		err_stat(source);
-		return -1;
-	}
-
-	tv[0].tv_sec = st.st_atim.tv_sec;
-	tv[0].tv_usec = st.st_atim.tv_nsec / 1000;
-	tv[1].tv_sec = st.st_mtim.tv_sec;
-	tv[1].tv_usec = st.st_mtim.tv_nsec / 1000;
-
-	if (futimes(tfd, tv) < 0)
-		err_message(_("%s: Cannot update target times"), target);
-
-	if (fchown(tfd, st.st_uid, st.st_gid) < 0) {
-		err_message(_("%s: Cannot change target ownership to "
-				"uid(%d) gid(%d)"), target,
-				st.st_uid, st.st_gid);
-
-		if (fchmod(tfd, st.st_mode & ~(S_ISUID | S_ISGID)) < 0)
-			err_message(_("%s: Cannot change target mode "
-					"to (%o)"), target, st.st_mode);
-	} else if (fchmod(tfd, st.st_mode) < 0)
-		err_message(_("%s: Cannot change target mode to (%o)"),
-				target, st.st_mode);
-
-	if (xfs_setxattr(tfd, &fsx) < 0)
-		err_message(_("%s: Cannet set target extended "
-				"attributes"), target);
-
-	return clone_attribs(source, target);
-}
-
-static int
-move_dirents(
-	char		*srcpath,
-	char		*targetpath,
-	int		*move_count)
-{
-	int		rval = 0;
-	DIR		*srcd;
-	struct dirent64	*dp;
-	char		srcname[PATH_MAX];
-	char		targetname[PATH_MAX];
-
-	*move_count = 0;
-
-	srcd = opendir(srcpath);
-	if (srcd == NULL) {
-		err_open(srcpath);
-		return 1;
-	}
-
-	while ((dp = readdir64(srcd)) != NULL) {
-		if (dp->d_ino == 0 || !strcmp(dp->d_name, ".") ||
-				!strcmp(dp->d_name, ".."))
-			continue;
-
-		if (strlen(srcpath) + 1 + strlen(dp->d_name) >=
-				sizeof(srcname) - 1) {
-
-			err_message(_("%s/%s: Name too long"), srcpath,
-					dp->d_name);
-			rval = 1;
-			goto quit;
-		}
-
-		sprintf(srcname, "%s/%s", srcpath, dp->d_name);
-		sprintf(targetname, "%s/%s", targetpath, dp->d_name);
-
-		rval = rename(srcname, targetname);
-		if (rval != 0) {
-			err_message(_("failed to rename: \'%s\' to \'%s\'"),
-					srcname, targetname);
-			goto quit;
-		}
-
-		log_message(LOG_DEBUG, "rename %s -> %s", srcname, targetname);
-
-		(*move_count)++;
-	}
-
-quit:
-	closedir(srcd);
-	return rval;
-}
-
 static int
 process_dir(
 	bignode_t	*node)
 {
 	int		sfd = -1;
 	int		tfd = -1;
-	int		targetfd = -1;
 	int		rval = 0;
-	int		move_count = 0;
+	struct stat64	st;
 	char		*srcname = NULL;
 	char		*pname = NULL;
-	struct stat64	s1;
+	xfs_swapino_t	si;
+	xfs_swapext_t	sx;
+	xfs_bstat_t	bstatbuf;
 	struct fsxattr  fsx;
 	char		target[PATH_MAX] = "";
 
@@ -718,14 +531,19 @@
 	cur_node = node;
 	srcname = node->paths[0];
 
-	if (stat64(srcname, &s1) < 0) {
+	bzero(&st, sizeof(st));
+	bzero(&bstatbuf, sizeof(bstatbuf));
+	bzero(&si, sizeof(si));
+	bzero(&sx, sizeof(sx));
+
+	if (stat64(srcname, &st) < 0) {
 		if (errno != ENOENT) {
 			err_stat(srcname);
 			global_rval |= 2;
 		}
 		goto quit;
 	}
-	if (s1.st_ino <= XFS_MAXINUMBER_32 && !force_all) {
+	if (st.st_ino <= XFS_MAXINUMBER_32 && !force_all) {
 		/*
 		 * This directory has already changed ino's, probably due
 		 * to being moved during processing of a parent directory.
@@ -737,7 +555,7 @@
 	rval = 1;
 
 	sfd = open(srcname, O_RDONLY);
-	if (sfd < 0) {
+	if (sfd == -1) {
 		err_open(srcname);
 		goto quit;
 	}
@@ -754,7 +572,12 @@
 	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
 		err_message(_("%s: immutable/append, ignoring"), srcname);
 		global_rval |= 2;
-		rval = 0;
+		goto quit;
+	}
+
+	if (realuid != 0 && realuid != st.st_uid) {
+		errno = EACCES;
+		err_open(srcname);
 		goto quit;
 	}
 
@@ -770,7 +593,11 @@
 		err_message(_("Unable to create directory copy: %s"), srcname);
 		goto quit;
 	}
-	SET_PHASE(DIR_PHASE_1);
+	tfd = open(target, O_RDONLY);
+	if (tfd == -1) {
+		err_open(target);
+		goto quit;
+	}
 
 	cur_target = strdup(target);
 	if (!cur_target) {
@@ -778,81 +605,64 @@
 		goto quit;
 	}
 
-	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
-	if (mkdtemp(target) == NULL) {
-		err_message(_("unable to create tmp directory copy"));
-		goto quit;
-	}
-	SET_PHASE(DIR_PHASE_2);
+	SET_PHASE(DIR_PHASE_1);
 
-	cur_temp = strdup(target);
-	if (!cur_temp) {
-		err_nomem();
-		goto quit;
-	}
+	/* swapino src target */
+	si.si_version  = XFS_SI_VERSION;
+	si.si_fdtarget = tfd;
+	si.si_fdtmp    = sfd;
 
-	tfd = open(cur_temp, O_RDONLY);
-	if (tfd < 0) {
-		err_open(cur_temp);
-		goto quit;
+	/* swap the inodes */
+	rval = xfs_swapino(tfd, &si);
+	if (rval < 0) {
+		err_swapino(rval, srcname);
+		goto quit_unlink;
 	}
 
-	targetfd = open(cur_target, O_RDONLY);
-	if (tfd < 0) {
-		err_open(cur_target);
+	if (xfs_bulkstat_single(sfd, &st.st_ino, &bstatbuf) < 0) {
+		err_message(_("unable to bulkstat source file: %s"),
+				srcname);
+		unlink(target);
 		goto quit;
 	}
 
-
-	/* copy timestamps, attribs and EAs, to cur_temp */
-	rval = dup_attributes(srcname, sfd, cur_temp, tfd);
-	if (rval != 0) {
-		err_message(_("unable to duplicate directory attributes: %s"),
+	if (bstatbuf.bs_ino != st.st_ino) {
+		err_message(_("bulkstat of source file returned wrong inode: %s"),
 			    srcname);
-		goto quit_unlink;
+		unlink(target);
+		goto quit;
 	}
 
-	SET_PHASE(DIR_PHASE_3);
-
-	/* move src dirents to cur_target (this changes timestamps on src) */
-	rval = move_dirents(srcname, cur_target, &move_count);
-	if (rval != 0) {
-		err_message(_("unable to move directory contents: %s to %s"),
-				srcname, cur_target);
-		/* uh oh, move everything back... */
-		if (move_count > 0)
-			goto quit_undo;
-	}
+	ftruncate64(tfd, bstatbuf.bs_size);
 
-	SET_PHASE(DIR_PHASE_4);
+	/* swapextents src target */
+	sx.sx_stat     = bstatbuf; /* struct copy */
+	sx.sx_version  = XFS_SX_VERSION;
+	sx.sx_fdtarget = sfd;
+	sx.sx_fdtmp    = tfd;
+	sx.sx_offset   = 0;
+	sx.sx_length   = bstatbuf.bs_size;
 
-	/* copy timestamps, attribs and EAs from cur_temp to cur_target */
-	rval = dup_attributes(cur_temp, tfd, cur_target, targetfd);
-	if (rval != 0) {
-		err_message(_("unable to duplicate directory attributes: %s"),
-				cur_temp);
+	/* Swap the extents */
+	rval = xfs_swapext(sfd, &sx);
+	if (rval < 0) {
+		err_swapext(rval, srcname, bstatbuf.bs_size);
 		goto quit_unlink;
 	}
 
-	SET_PHASE(DIR_PHASE_5);
+	SET_PHASE(DIR_PHASE_2);
 
 	/* rmdir src */
 	rval = rmdir(srcname);
 	if (rval != 0) {
 		err_message(_("unable to remove directory: %s"), srcname);
-		goto quit_undo;
+		goto quit;
 	}
 
-	SET_PHASE(DIR_PHASE_6);
-
-	rval = rmdir(cur_temp);
-	if (rval != 0)
-		err_message(_("unable to remove tmp directory: %s"), cur_temp);
-
-	SET_PHASE(DIR_PHASE_7);
+	SET_PHASE(DIR_PHASE_3);
 
 	/* rename cur_target src */
-	rval = rename(cur_target, srcname);
+	rval = rename(target, srcname);
 	if (rval != 0) {
 		/*
 		 * we can't abort since the src dir is now gone.
@@ -863,18 +673,10 @@
 	}
 	goto quit;
 
- quit_undo:
-	if (move_dirents(cur_target, srcname, &move_count) != 0) {
-		/* oh, dear lord... let the admin clean this one up */
-		err_message(_("unable to move directory contents back: %s to %s"),
-				cur_target, srcname);
-		goto quit;
-	}
-	SET_PHASE(DIR_PHASE_3);
-
  quit_unlink:
-	rmdir(cur_target);
-	rmdir(cur_temp);
+	rval = rmdir(target);
+	if (rval != 0)
+		err_message(_("unable to remove directory: %s"), target);
 
  quit:
 
@@ -884,16 +686,13 @@
 		close(sfd);
 	if (tfd >= 0)
 		close(tfd);
-	if (targetfd >= 0)
-		close(targetfd);
 
 	free(pname);
 	free(cur_target);
-	free(cur_temp);
 
 	cur_target = NULL;
-	cur_temp = NULL;
 	cur_node = NULL;
+
 	numdirsdone++;
 	return rval;
 }
@@ -906,9 +705,10 @@
 	int		tfd = -1;
 	int		i = 0;
 	int		rval = 0;
-	struct stat64	s1;
+	struct stat64	st;
 	char		*srcname = NULL;
 	char		*pname = NULL;
+	xfs_swapino_t	si;
 	xfs_swapext_t	sx;
 	xfs_bstat_t	bstatbuf;
 	struct fsxattr  fsx;
@@ -921,37 +721,36 @@
 	cur_node = node;
 	srcname = node->paths[0];
 
-	bzero(&s1, sizeof(s1));
+	bzero(&st, sizeof(st));
 	bzero(&bstatbuf, sizeof(bstatbuf));
+	bzero(&si, sizeof(si));
 	bzero(&sx, sizeof(sx));
 
-	if (stat64(srcname, &s1) < 0) {
+	if (stat64(srcname, &st) < 0) {
 		if (errno != ENOENT) {
 			err_stat(srcname);
 			global_rval |= 2;
 		}
 		goto quit;
 	}
-	if (s1.st_ino <= XFS_MAXINUMBER_32 && !force_all)
+	if (st.st_ino <= XFS_MAXINUMBER_32 && !force_all)
 		/* this file has changed, and no longer needs processing */
 		goto quit;
 
+	rval = 1;
 	/* open and sync source */
 	sfd = open(srcname, O_RDWR | O_DIRECT);
 	if (sfd < 0) {
 		err_open(srcname);
-		rval = 1;
 		goto quit;
 	}
 	if (!platform_test_xfs_fd(sfd)) {
 		err_not_xfs(srcname);
-		rval = 1;
 		goto quit;
 	}
 	if (fsync(sfd) < 0) {
 		err_message(_("sync failed: %s: %s"),
 				srcname, strerror(errno));
-		rval = 1;
 		goto quit;
 	}
 
@@ -963,7 +762,7 @@
 	 * but before all reads have completed to block xfs_reno reads.
 	 * This change just closes the window a bit.
 	 */
-	if ((s1.st_mode & S_ISGID) && !(s1.st_mode & S_IXGRP)) {
+	if ((st.st_mode & S_ISGID) && !(st.st_mode & S_IXGRP)) {
 		struct flock fl;
 
 		fl.l_type = F_RDLCK;
@@ -988,7 +787,6 @@
 
 	if (xfs_getxattr(sfd, &fsx) < 0) {
 		err_message(_("failed to get inode attrs: %s"), srcname);
-		rval = 1;
 		goto quit;
 	}
 	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND)) {
@@ -997,9 +795,7 @@
 		goto quit;
 	}
 
-	rval = 1;
-
-	if (realuid != 0 && realuid != s1.st_uid) {
+	if (realuid != 0 && realuid != st.st_uid) {
 		errno = EACCES;
 		err_open(srcname);
 		goto quit;
@@ -1012,9 +808,10 @@
 		goto quit;
 	}
 	dirname(pname);
+
 	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
 	tfd = mkstemp(target);
-	if (tfd < 0) {
+	if (tfd == -1) {
 		err_message("unable to create file copy");
 		goto quit;
 	}
@@ -1026,30 +823,26 @@
 
 	SET_PHASE(FILE_PHASE_1);
 
-	/* Setup direct I/O */
-	if (fcntl(tfd, F_SETFL, O_DIRECT) < 0 ) {
-		err_message(_("could not set O_DIRECT for %s on tmp: %s"),
-				srcname, target);
-		unlink(target);
-		goto quit;
-	}
+	/* swapino src target */
+	si.si_version  = XFS_SI_VERSION;
+	si.si_fdtarget = sfd;
+	si.si_fdtmp    = tfd;
 
-	/* copy attribs & EAs to target */
-	if (dup_attributes(srcname, sfd, target, tfd) != 0) {
-		err_message(_("unable to duplicate file attributes: %s"),
-				srcname);
-		unlink(target);
-		goto quit;
+	/* swap the inodes */
+	rval = xfs_swapino(sfd, &si);
+	if (rval < 0) {
+		err_swapino(rval, srcname);
+		goto quit_unlink;
 	}
 
-	if (xfs_bulkstat_single(sfd, &s1.st_ino, &bstatbuf) < 0) {
+	if (xfs_bulkstat_single(sfd, &st.st_ino, &bstatbuf) < 0) {
 		err_message(_("unable to bulkstat source file: %s"),
 				srcname);
 		unlink(target);
 		goto quit;
 	}
 
-	if (bstatbuf.bs_ino != s1.st_ino) {
+	if (bstatbuf.bs_ino != st.st_ino) {
 		err_message(_("bulkstat of source file returned wrong inode: %s"),
 				srcname);
 		unlink(target);
@@ -1069,44 +862,8 @@
 	/* Swap the extents */
 	rval = xfs_swapext(sfd, &sx);
 	if (rval < 0) {
-		if (log_level >= LOG_DEBUG) {
-			switch (errno) {
-			case ENOTSUP:
-				err_message("%s: file type not supported",
-					srcname);
-				break;
-			case EFAULT:
-				/* The file has changed since we started the copy */
-				err_message("%s: file modified, "
-					 "inode renumber aborted: %ld",
-					 srcname, bstatbuf.bs_size);
-				break;
-			case EBUSY:
-				/* Timestamp has changed or mmap'ed file */
-				err_message("%s: file busy", srcname);
-				break;
-			default:
-				err_message(_("Swap extents failed: %s: %s"),
-					srcname, strerror(errno));
-				break;
-			}
-		} else
-			err_message(_("Swap extents failed: %s: %s"),
-					srcname, strerror(errno));
-		goto quit;
-	}
-
-	if (bstatbuf.bs_dmevmask | bstatbuf.bs_dmstate) {
-		struct fsdmidata fssetdm;
-
-		/* Set the DMAPI Fields. */
-		fssetdm.fsd_dmevmask = bstatbuf.bs_dmevmask;
-		fssetdm.fsd_padding = 0;
-		fssetdm.fsd_dmstate = bstatbuf.bs_dmstate;
-
-		if (ioctl(tfd, XFS_IOC_FSSETDM, (void *)&fssetdm ) < 0)
-			err_message(_("attempt to set DMI attributes "
-					"of %s failed"), target);
+		err_swapext(rval, srcname, bstatbuf.bs_size);
+		goto quit_unlink;
 	}
 
 	SET_PHASE(FILE_PHASE_2);
@@ -1152,8 +909,12 @@
 		numfilesdone++;
 	}
 
+ quit_unlink:
+	rval = unlink(target);
+	if (rval != 0)
+		err_message(_("unable to remove file: %s"), target);
+
  quit:
-	cur_node = NULL;
 
 	SET_PHASE(FILE_PHASE);
 
@@ -1166,6 +927,7 @@
 	free(cur_target);
 
 	cur_target = NULL;
+	cur_node = NULL;
 
 	numfilesdone++;
 	return rval;
@@ -1177,12 +939,15 @@
 	bignode_t	*node)
 {
 	int		i = 0;
+	int		sfd = -1;
+	int		tfd = -1;
 	int		rval = 0;
 	struct stat64	st;
 	char		*srcname = NULL;
 	char		*pname = NULL;
 	char		target[PATH_MAX] = "";
 	char		linkbuf[PATH_MAX];
+	xfs_swapino_t	si;
 
 	SET_PHASE(SLINK_PHASE);
 
@@ -1191,6 +956,9 @@
 	cur_node = node;
 	srcname = node->paths[0];
 
+	bzero(&st, sizeof(st));
+	bzero(&si, sizeof(si));
+
 	if (lstat64(srcname, &st) < 0) {
 		if (errno != ENOENT) {
 			err_stat(srcname);
@@ -1204,6 +972,13 @@
 
 	rval = 1;
 
+	/* open source */
+	sfd = open(srcname, O_RDWR | O_DIRECT);
+	if (sfd < 0) {
+		err_open(srcname);
+		goto quit;
+	}
+
 	i = readlink(srcname, linkbuf, sizeof(linkbuf) - 1);
 	if (i < 0) {
 		err_message(_("unable to read symlink: %s"), srcname);
@@ -1226,7 +1001,8 @@
 	dirname(pname);
 
 	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
-	if (mktemp(target) == NULL) {
+	tfd = mkstemp(target);
+	if (tfd == -1) {
 		err_message(_("unable to create temp symlink name"));
 		goto quit;
 	}
@@ -1243,19 +1019,15 @@
 
 	SET_PHASE(SLINK_PHASE_1);
 
-	/* copy ownership & EAs to target */
-	if (lchown(target, st.st_uid, st.st_gid) < 0) {
-		err_message(_("%s: Cannot change target ownership to "
-				"uid(%d) gid(%d)"), target,
-				st.st_uid, st.st_gid);
-		unlink(target);
-		goto quit;
-	}
+	/* swapino src target */
+	si.si_version  = XFS_SI_VERSION;
+	si.si_fdtarget = sfd;
+	si.si_fdtmp    = tfd;
 
-	if (clone_attribs(srcname, target) != 0) {
-		err_message(_("unable to duplicate symlink attributes: %s"),
-				srcname);
-		unlink(target);
+	/* swap the inodes */
+	rval = xfs_swapino(sfd, &si);
+	if (rval < 0) {
+		err_swapino(rval, srcname);
 		goto quit;
 	}
 
@@ -1374,8 +1146,8 @@
 	for (i = 0; i < cur_node->numpaths; i++)
 		len += sprintf(buf + len, "%s\n", cur_node->paths[i]);
 
-	len += sprintf(buf + len, "target: %s\ntemp: %s\nend\n",
-			cur_target, cur_temp);
+/*	len += sprintf(buf + len, "target: %s\ntemp: %s\nend\n", */
+/*			cur_target, cur_temp); */
 
 	ASSERT(len < buf_size);
 
@@ -1468,7 +1240,7 @@
 	ino_t		ino;
 	int		ftw_flags;
 	char		buf[PATH_MAX + 10]; /* path + "target: " */
-	struct stat64	s;
+	struct stat64	st;
 	int		first_path;
 
 	/*
@@ -1543,12 +1315,12 @@
 		log_message(LOG_DEBUG, "path: '%s'", buf);
 
 		if (buf[0] == '/') {
-			if (stat64(buf, &s) < 0) {
+			if (stat64(buf, &st) < 0) {
 				err_message(_("Recovery failed: cannot "
 						"stat '%s'"), buf);
 				goto quit;
 			}
-			if (s.st_ino != ino) {
+			if (st.st_ino != ino) {
 				err_message(_("Recovery failed: inode "
 						"number for '%s' does not "
 						"match recorded number"), buf);
@@ -1569,7 +1341,7 @@
 				err_nomem();
 				goto quit;
 			}
-			if (stat64(*target, &s) < 0) {
+			if (stat64(*target, &st) < 0) {
 				err_message(_("Recovery failed: cannot "
 						"stat '%s'"), *target);
 				goto quit;
@@ -1619,12 +1391,10 @@
 	char		*tname,
 	int		phase)
 {
-	int		tfd = -1;
-	int		targetfd = -1;
 	char		*srcname = NULL;
 	int		rval = 0;
 	int		i;
-	int		move_count = 0;
+	int		dir;
 
 	dump_node("recover", node);
 	log_message(LOG_DEBUG, "target: %s, phase: %x", target, phase);
@@ -1632,137 +1402,54 @@
 	if (node)
 		srcname = node->paths[0];
 
+	dir = (phase < DIR_PHASE || phase > DIR_PHASE_MAX);
+
 	switch (phase) {
 
-	case DIR_PHASE_2:
-rmtemps:
-		log_message(LOG_NORMAL, _("Removing temporary directory: '%s'"),
-				tname);
-		if (rmdir(tname) < 0 && errno != ENOENT) {
-			err_message(_("unable to remove directory: %s"), tname);
-			rval = 1;
-		}
-		/* FALL THRU */
 	case DIR_PHASE_1:
-		log_message(LOG_NORMAL, _("Removing target directory: '%s'"),
-				target);
-		if (rmdir(target) < 0 && errno != ENOENT) {
-			err_message(_("unable to remove directory: %s"),
-					target);
-			rval = 1;
-		}
-		break;
+	case FILE_PHASE_1:
+	case SLINK_PHASE_1:
+		log_message(LOG_NORMAL, _("Unlinking temporary %s: \'%s\'"),
+			    dir ? "directory" : "file", target);
 
-	case DIR_PHASE_3:
-		log_message(LOG_NORMAL, _("Completing moving directory "
-				"contents: '%s' to '%s'"), srcname, target);
-		if (move_dirents(srcname, target, &move_count) != 0) {
-			err_message(_("unable to move directory contents: "
-					"%s to %s"), srcname, target);
-			/* uh oh, move everything back... */
-			if (move_count > 0) {
-				if (move_dirents(target, srcname,
-						&move_count) != 0) {
-					/* oh, dear lord... let the admin
-					 * clean this one up */
-					err_message(_("unable to move directory "
-						"contents back: %s to %s"),
-						target, srcname);
-					exit(1);
-				}
-			}
-			goto rmtemps;
-		}
-		/* FALL THRU */
-	case DIR_PHASE_4:
-		log_message(LOG_NORMAL, _("Setting attributes for target "
-				"directory: \'%s\'"), target);
-		tfd = open(tname, O_RDONLY);
-		if (tfd < 0) {
-			err_open(tname);
-			rval = 1;
-			break;
-		}
-		targetfd = open(target, O_RDONLY);
-		if (targetfd < 0) {
-			err_open(target);
-			rval = 1;
-			break;
-		}
-		rval = dup_attributes(tname, tfd, target, targetfd);
-		if (rval != 0) {
-			err_message(_("unable to duplicate directory "
-					"attributes: %s"), tname);
-			break;
-		}
-		close(tfd);
-		close(targetfd);
-		/* FALL THRU */
-	case DIR_PHASE_6:
-		log_message(LOG_NORMAL, _("Removing temporary directory: \'%s\'"),
-				tname);
-		if (rmdir(tname) < 0 && errno != ENOENT) {
-			err_message(_("unable to remove directory: %s"),
-					tname);
-			rval = 1;
-			break;
-		}
-		/* FALL THRU */
-	case DIR_PHASE_5:
-		log_message(LOG_NORMAL, _("Removing old directory: \'%s\'"),
-				srcname);
-		if (rmdir(srcname) < 0 && errno != ENOENT) {
-			err_message(_("unable to remove directory: %s"),
-					srcname);
-			rval = 1;
-			break;
-		}
-		/* FALL THRU */
-	case DIR_PHASE_7:
-		log_message(LOG_NORMAL, _("Renaming new directory to old "
-			"directory: \'%s\' -> \'%s\'"), target, srcname);
-		rval = rename(target, srcname);
-		if (rval != 0) {
-			/* we can't abort since the src dir is now gone.
-			 * let the admin clean this one up
-			 */
-			err_message(_("unable to rename directory: %s to %s"),
-					target, srcname);
-			break;
-		}
-		break;
+		rval = dir ? rmdir(target) : unlink(target);
 
+		if ( rval < 0 && errno != ENOENT)
+			err_message(_("unable to remove %s: %s"),
+				    dir ? "directory" : "file", target);
 
-	case FILE_PHASE_1:
-	case SLINK_PHASE_1:
-		log_message(LOG_NORMAL, _("Unlinking temporary file: \'%s\'"),
-				target);
-		unlink(target);
 		break;
 
+	case DIR_PHASE_2:
 	case FILE_PHASE_2:
 	case SLINK_PHASE_2:
-		log_message(LOG_NORMAL, _("Unlinking old file: \'%s\'"),
-				srcname);
-		rval = unlink(srcname);
-		if (rval != 0) {
-			err_message(_("unable to remove file: %s"), srcname);
+		log_message(LOG_NORMAL, _("Unlinking old %s: \'%s\'"),
+				dir ? "directory" : "file", srcname);
+
+		rval = dir ? rmdir(target) : unlink(srcname);
+
+		if (rval < 0 && errno != ENOENT) {
+			err_message(_("unable to remove %s: %s"), 
+				    dir ? "directory" : "file", srcname);
 			break;
 		}
 		/* FALL THRU */
+	case DIR_PHASE_3:
 	case FILE_PHASE_3:
 	case SLINK_PHASE_3:
-		log_message(LOG_NORMAL, _("Renaming new file to old file: "
+		log_message(LOG_NORMAL, _("Renaming: "
 				"\'%s\' -> \'%s\'"), target, srcname);
 		rval = rename(target, srcname);
 		if (rval != 0) {
 			/* we can't abort since the src file is now gone.
 			 * let the admin clean this one up
 			 */
-			err_message(_("unable to rename file: %s to %s"),
+			err_message(_("unable to rename: %s to %s"),
 					target, srcname);
 			break;
 		}
+		if (dir)
+			break;
 		/* FALL THRU */
 	case FILE_PHASE_4:
 	case SLINK_PHASE_4:
