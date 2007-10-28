Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Oct 2007 10:56:30 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9SHuLpj016960
	for <linux-xfs@oss.sgi.com>; Sun, 28 Oct 2007 10:56:23 -0700
From: Andreas Gruenbacher <agruen@suse.de>
Subject: acl and attr: Fix path walking code
Date: Sun, 28 Oct 2007 18:58:24 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_A3MJH2/pbEYYK1y"
Message-Id: <200710281858.24428.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>
Cc: Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

--Boundary-00=_A3MJH2/pbEYYK1y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

the tree walking code in acl and attr broke when resolve_symlinks() was 
introduced (by me, unfortunately). Following symlinks passed in on the 
command line is the intended behavior for the tools (unless in -P mode). The 
first version was buggy, and so someone "fixed" it by replacing readlink() 
with realpath() in resolve_symlinks().

The result is that the output of getfattr and getfacl will show pathnames that 
may point anywhere. When processing a directory tree it sometimes is helpful 
to treat symlinks as regular files, but resolving the pathnames is totally 
wrong.

After runnig into problem after problem with nftw and never ending up with 
even half-way clean code, I think it's time to ditch it altogether and 
replace it with sane code. So here are two patches, one for attr and one for 
acl, that does that.

Files include/walk_tree.h and libmisc/walk_tree.c are identical in both 
patches; that code is shared between the two packages.

Okay to apply?

Thanks,
Andreas

--Boundary-00=_A3MJH2/pbEYYK1y
Content-Type: text/x-diff;
  charset="us-ascii";
  name="walk-acl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="walk-acl.diff"

Index: acl-2.2.45/getfacl/getfacl.c
===================================================================
--- acl-2.2.45.orig/getfacl/getfacl.c
+++ acl-2.2.45/getfacl/getfacl.c
@@ -34,10 +34,10 @@
 #include <dirent.h>
 #include <libgen.h>
 #include <getopt.h>
-#include <ftw.h>
 #include <locale.h>
 #include "config.h"
 #include "user_group.h"
+#include "walk_tree.h"
 #include "misc.h"
 
 #define POSIXLY_CORRECT_STR "POSIXLY_CORRECT"
@@ -70,24 +70,22 @@ struct option long_options[] = {
 const char *progname;
 const char *cmd_line_options;
 
-int opt_recursive;  /* recurse into sub-directories? */
-int opt_walk_logical;  /* always follow symbolic links */
-int opt_walk_physical;  /* never follow symbolic links */
-int opt_print_acl = 0;
-int opt_print_default_acl = 0;
+int walk_flags = WALK_TREE_DEREFERENCE;
+int opt_print_acl;
+int opt_print_default_acl;
 int opt_strip_leading_slash = 1;
 int opt_comments = 1;  /* include comments */
-int opt_skip_base = 0;  /* skip files that only have the base entries */
-int opt_tabular = 0;  /* tabular output format (alias `showacl') */
+int opt_skip_base;  /* skip files that only have the base entries */
+int opt_tabular;  /* tabular output format (alias `showacl') */
 #if POSIXLY_CORRECT
 const int posixly_correct = 1;  /* Posix compatible behavior! */
 #else
-int posixly_correct = 0;  /* Posix compatible behavior? */
+int posixly_correct;  /* Posix compatible behavior? */
 #endif
-int had_errors = 0;
-int absolute_warning = 0;  /* Absolute path warning was issued */
+int had_errors;
+int absolute_warning;  /* Absolute path warning was issued */
 int print_options = TEXT_SOME_EFFECTIVE;
-int opt_numeric = 0;  /* don't convert id's to symbolic names */
+int opt_numeric;  /* don't convert id's to symbolic names */
 
 
 static const char *xquote(const char *str)
@@ -425,12 +423,23 @@ acl_get_file_mode(const char *path_p)
 	return acl_from_mode(st.st_mode);
 }
 
-int do_print(const char *path_p, const struct stat *st)
+int do_print(const char *path_p, const struct stat *st, int walk_flags, void *unused)
 {
 	const char *default_prefix = NULL;
 	acl_t acl = NULL, default_acl = NULL;
 	int error = 0;
 
+	if (walk_flags & WALK_TREE_FAILED) {
+		fprintf(stderr, "%s: %s: %s\n", progname, xquote(path_p),
+			strerror(errno));
+		return 1;
+	}
+
+	if ((walk_flags & WALK_TREE_SYMLINK) &&
+	    ((walk_flags & WALK_TREE_PHYSICAL) ||
+	     !(walk_flags & (WALK_TREE_TOPLEVEL | WALK_TREE_LOGICAL))))
+		return 0;
+
 	if (opt_print_acl) {
 		acl = acl_get_file(path_p, ACL_TYPE_ACCESS);
 		if (acl == NULL && (errno == ENOSYS || errno == ENOTSUP))
@@ -549,7 +558,7 @@ void help(void)
 "      --skip-base         skip files that only have the base entries\n"
 "  -R, --recursive         recurse into subdirectories\n"
 "  -L, --logical           logical walk, follow symbolic links\n"
-"  -P  --physical          physical walk, do not follow symbolic links\n"
+"  -P, --physical          physical walk, do not follow symbolic links\n"
 "      --tabular           use tabular output format\n"
 "      --numeric           print numeric user/group identifiers\n"
 "      --absolute-names    don't strip leading '/' in pathnames\n"));
@@ -560,75 +569,6 @@ void help(void)
 "      --help              this help text\n"));
 }
 
-
-static int __errors;
-int __do_print(const char *file, const struct stat *stat,
-               int flag, struct FTW *ftw)
-{
-	int saved_errno = errno;
-
-	/* Process the target of a symbolic link, and traverse the link,
-           only if doing a logical walk, or if the symbolic link was
-           specified on the command line. Always skip symbolic links if
-           doing a physical walk. */
-
-	if (S_ISLNK(stat->st_mode) &&
-	    (opt_walk_physical || (ftw->level > 0 && !opt_walk_logical)))
-		return 0;
-
-	if (do_print(file, stat))
-		__errors++;
-
-	if (flag == FTW_DNR && opt_recursive) {
-		/* Item is a directory which can't be read. */
-		fprintf(stderr, "%s: %s: %s\n",
-			progname, file, strerror(saved_errno));
-		return 0;
-	}
-
-	/* We also get here in non-recursive mode. In that case,
-	   return something != 0 to abort nftw. */
-
-	if (!opt_recursive)
-		return 1;
-
-	return 0;
-}
-
-char *resolve_symlinks(const char *file)
-{
-	static char buffer[4096];
-	struct stat stat;
-	char *path = NULL;
-
-	if (lstat(file, &stat) == -1)
-		return path;
-
-	if (S_ISLNK(stat.st_mode) && !opt_walk_physical)
-		path = realpath(file, buffer);
-	else
-		path = (char *)file; 	/* not a symlink, use given path */
-
-	return path;
-}
-
-int walk_tree(const char *file)
-{
-	const char *p;
-
-	__errors = 0;
-	if ((p = resolve_symlinks(file)) == NULL) {
-		fprintf(stderr, "%s: %s: %s\n", progname,
-			xquote(file), strerror(errno));
-		__errors++;
-	} else if (nftw(p, __do_print, 0, opt_walk_logical? 0 : FTW_PHYS) < 0) {
-		fprintf(stderr, "%s: %s: %s\n", progname, xquote(file),
-			strerror(errno));
-		__errors++;
-	}
-	return __errors;
-}
-
 int main(int argc, char *argv[])
 {
 	int opt;
@@ -691,21 +631,21 @@ int main(int argc, char *argv[])
 			case 'R':  /* recursive */
 				if (posixly_correct)
 					goto synopsis;
-				opt_recursive = 1;
+				walk_flags |= WALK_TREE_RECURSIVE;
 				break;
 
 			case 'L':  /* follow all symlinks */
 				if (posixly_correct)
 					goto synopsis;
-				opt_walk_logical = 1;
-				opt_walk_physical = 0;
+				walk_flags |= WALK_TREE_LOGICAL;
+				walk_flags &= ~WALK_TREE_PHYSICAL;
 				break;
 
 			case 'P':  /* skip all symlinks */
 				if (posixly_correct)
 					goto synopsis;
-				opt_walk_logical = 0;
-				opt_walk_physical = 1;
+				walk_flags |= WALK_TREE_PHYSICAL;
+				walk_flags &= ~WALK_TREE_LOGICAL;
 				break;
 
 			case 's':  /* skip files with only base entries */
@@ -762,7 +702,8 @@ int main(int argc, char *argv[])
 				if (*line == '\0')
 					continue;
 
-				had_errors += walk_tree(line);
+				had_errors += walk_tree(line, walk_flags, 0,
+							do_print, NULL);
 			}
 			if (!feof(stdin)) {
 				fprintf(stderr, _("%s: Standard input: %s\n"),
@@ -770,7 +711,8 @@ int main(int argc, char *argv[])
 				had_errors++;
 			}
 		} else
-			had_errors += walk_tree(argv[optind]);
+			had_errors += walk_tree(argv[optind], walk_flags, 0,
+						do_print, NULL);
 		optind++;
 	} while (optind < argc);
 
Index: acl-2.2.45/libmisc/Makefile
===================================================================
--- acl-2.2.45.orig/libmisc/Makefile
+++ acl-2.2.45/libmisc/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTLIBRARY = libmisc.la
 LTLDFLAGS =
 
-CFILES = quote.c unquote.c high_water_alloc.c next_line.c
+CFILES = quote.c unquote.c high_water_alloc.c next_line.c walk_tree.c
 
 default: $(LTLIBRARY)
 install install-dev install-lib:
Index: acl-2.2.45/setfacl/do_set.c
===================================================================
--- acl-2.2.45.orig/setfacl/do_set.c
+++ acl-2.2.45/setfacl/do_set.c
@@ -36,10 +36,10 @@
 #include "sequence.h"
 #include "parse.h"
 #include "config.h"
+#include "walk_tree.h"
 
 
 extern const char *progname;
-extern int opt_recursive;
 extern int opt_recalculate;
 extern int opt_test;
 extern int print_options;
@@ -259,8 +259,10 @@ int
 do_set(
 	const char *path_p,
 	const struct stat *st,
-	const seq_t seq)
+	int walk_flags,
+	void *arg)
 {
+	const seq_t seq = (const seq_t)arg;
 	acl_t old_acl = NULL, old_default_acl = NULL;
 	acl_t acl = NULL, default_acl = NULL;
 	acl_t *xacl, *old_xacl;
@@ -272,6 +274,16 @@ do_set(
 	int acl_modified = 0, default_acl_modified = 0;
 	int acl_mask_provided = 0, default_acl_mask_provided = 0;
 
+	if (walk_flags & WALK_TREE_FAILED) {
+		fprintf(stderr, "%s: %s: %s\n", progname, path_p, strerror(errno));
+		return 1;
+	}
+
+        if ((walk_flags & WALK_TREE_SYMLINK) &&
+	    ((walk_flags & WALK_TREE_PHYSICAL) ||
+	     !(walk_flags & (WALK_TREE_TOPLEVEL | WALK_TREE_LOGICAL))))
+		return 0;
+
 	/* Execute the commands in seq (read ACLs on demand) */
 	error = seq_get_cmd(seq, SEQ_FIRST_CMD, &cmd);
 	if (error == 0)
@@ -426,7 +438,7 @@ do_set(
 	}
 
 	/* Only directores can have default ACLs */
-	if (default_acl && !S_ISDIR(st->st_mode) && opt_recursive) {
+	if (default_acl && !S_ISDIR(st->st_mode) && (walk_flags & WALK_TREE_RECURSIVE)) {
 		/* In recursive mode, ignore default ACLs for files */
 		acl_free(default_acl);
 		default_acl = NULL;
Index: acl-2.2.45/setfacl/setfacl.c
===================================================================
--- acl-2.2.45.orig/setfacl/setfacl.c
+++ acl-2.2.45/setfacl/setfacl.c
@@ -28,20 +28,15 @@
 #include <sys/stat.h>
 #include <dirent.h>
 #include <libgen.h>
-#include <ftw.h>
 #include <getopt.h>
 #include <locale.h>
 #include "config.h"
 #include "sequence.h"
 #include "parse.h"
+#include "walk_tree.h"
 #include "misc.h"
 
-extern int
-do_set(
-        const char *path_p,
-        const struct stat *stat_p,
-	const seq_t seq);
-
+extern int do_set(const char *path_p, const struct stat *stat_p, int flags, void *arg);
 
 #define POSIXLY_CORRECT_STR "POSIXLY_CORRECT"
 
@@ -82,9 +77,7 @@ struct option long_options[] = {
 const char *progname;
 const char *cmd_line_options, *cmd_line_spec;
 
-int opt_recursive;  /* recurse into sub-directories? */
-int opt_walk_logical;  /* always follow symbolic links */
-int opt_walk_physical;  /* never follow symbolic links */
+int walk_flags = WALK_TREE_DEREFERENCE;
 int opt_recalculate;  /* recalculate mask entry (0=default, 1=yes, -1=no) */
 int opt_promote;  /* promote access ACL to default ACL */
 int opt_test;  /* do not write to the file system.
@@ -188,7 +181,7 @@ restore(
 		stat.st_uid = uid;
 		stat.st_gid = gid;
 
-		error = do_set(path_p, &stat, seq);
+		error = do_set(path_p, &stat, 0, seq);
 		if (error != 0) {
 			status = 1;
 			goto resume;
@@ -275,77 +268,6 @@ void help(void)
 }
 
 
-static int __errors;
-static seq_t __seq;
-
-int __do_set(const char *file, const struct stat *stat,
-             int flag, struct FTW *ftw)
-{
-	int saved_errno = errno;
-	
-	/* Process the target of a symbolic link, and traverse the link,
-	   only if doing a logical walk, or if the symbolic link was
-	   specified on the command line. Always skip symbolic links if
-	   doing a physical walk. */
-
-	if (S_ISLNK(stat->st_mode) &&
-	    (opt_walk_physical || (ftw->level > 0 && !opt_walk_logical)))
-		return 0;
-
-	if (do_set(file, stat, __seq))
-		__errors++;
-
-	if (flag == FTW_DNR && opt_recursive) {
-		/* Item is a directory which can't be read. */
-		fprintf(stderr, "%s: %s: %s\n",
-			progname, file, strerror(saved_errno));
-		return 0;
-	}
-
-	/* We also get here in non-recursive mode. In that case,
-	   return something != 0 to abort nftw. */
-
-	if (!opt_recursive)
-		return 1;
-
-	return 0;
-}
-
-char *resolve_symlinks(const char *file)
-{
-	static char buffer[4096];
-	struct stat stat;
-	char *path = NULL;
-
-	if (lstat(file, &stat) == -1)
-		return path;
-
-	if (S_ISLNK(stat.st_mode) && !opt_walk_physical)
-		path = realpath(file, buffer);
-	else
-		path = (char *)file;    /* not a symlink, use given path */
-
-	return path;
-}
-
-int walk_tree(const char *file, seq_t seq)
-{
-	const char *p;
-
-	__errors = 0;
-	__seq = seq;
-	if ((p = resolve_symlinks(file)) == NULL) {
-		fprintf(stderr, "%s: %s: %s\n", progname,
-			xquote(file), strerror(errno));
-		__errors++;
-	} else if (nftw(p, __do_set, 0, opt_walk_logical ? 0 : FTW_PHYS) < 0) {
-		fprintf(stderr, "%s: %s: %s\n", progname,
-			xquote(file), strerror(errno));
-		__errors++;
-	}
-	return __errors;
-}
-
 int next_file(const char *arg, seq_t seq)
 {
 	char *line;
@@ -353,14 +275,14 @@ int next_file(const char *arg, seq_t seq
 
 	if (strcmp(arg, "-") == 0) {
 		while ((line = next_line(stdin)))
-			errors = walk_tree(line, seq);
+			errors = walk_tree(line, walk_flags, 0, do_set, seq);
 		if (!feof(stdin)) {
 			fprintf(stderr, _("%s: Standard input: %s\n"),
 				progname, strerror(errno));
 			errors = 1;
 		}
 	} else {
-		errors = walk_tree(arg, seq);
+		errors = walk_tree(arg, walk_flags, 0, do_set, seq);
 	}
 	return errors ? 1 : 0;
 }
@@ -627,17 +549,17 @@ int main(int argc, char *argv[])
 				break;
 
 			case 'R':  /* recursive */
-				opt_recursive = 1;
+				walk_flags |= WALK_TREE_RECURSIVE;
 				break;
 
 			case 'L':  /* follow symlinks */
-				opt_walk_logical = 1;
-				opt_walk_physical = 0;
+				walk_flags |= WALK_TREE_LOGICAL;
+				walk_flags &= ~WALK_TREE_PHYSICAL;
 				break;
 
 			case 'P':  /* do not follow symlinks */
-				opt_walk_logical = 0;
-				opt_walk_physical = 1;
+				walk_flags |= WALK_TREE_PHYSICAL;
+				walk_flags &= ~WALK_TREE_LOGICAL;
 				break;
 
 			case 't':  /* test mode */
Index: acl-2.2.45/include/walk_tree.h
===================================================================
--- /dev/null
+++ acl-2.2.45/include/walk_tree.h
@@ -0,0 +1,19 @@
+#ifndef __WALK_TREE_H
+#define __WALK_TREE_H
+
+#define WALK_TREE_RECURSIVE	0x1
+#define WALK_TREE_PHYSICAL	0x2
+#define WALK_TREE_LOGICAL	0x4
+#define WALK_TREE_DEREFERENCE	0x8
+
+#define WALK_TREE_TOPLEVEL	0x100
+#define WALK_TREE_SYMLINK	0x200
+#define WALK_TREE_FAILED	0x400
+
+struct stat;
+
+extern int walk_tree(const char *path, int walk_flags, unsigned int num,
+		     int (*func)(const char *, const struct stat *, int,
+				 void *), void *arg);
+
+#endif
Index: acl-2.2.45/libmisc/walk_tree.c
===================================================================
--- /dev/null
+++ acl-2.2.45/libmisc/walk_tree.c
@@ -0,0 +1,188 @@
+/*
+  File: walk_tree.c
+
+  Copyright (C) 2007 Andreas Gruenbacher <a.gruenbacher@computer.org>
+
+  This program is free software; you can redistribute it and/or
+  modify it under the terms of the GNU Library General Public
+  License as published by the Free Software Foundation; either
+  version 2 of the License, or (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  Library General Public License for more details.
+
+  You should have received a copy of the GNU Library General Public
+  License along with this library; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+*/
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <dirent.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+
+#include "walk_tree.h"
+
+struct entry_handle {
+	struct entry_handle *prev, *next;
+	struct stat st;
+	DIR *stream;
+	off_t pos;
+};
+
+struct entry_handle head = {
+	.next = &head,
+	.prev = &head,
+	/* The other fields are unused. */
+};
+struct entry_handle *closed = &head;
+unsigned int num_dir_handles;
+
+static int walk_tree_rec(const char *path, int walk_flags,
+			 int (*func)(const char *, const struct stat *, int,
+			 	     void *), void *arg, int depth)
+{
+	int (*xstat)(const char *, struct stat *) = lstat;
+	int flags = walk_flags, err;
+	struct entry_handle dir;
+
+	/*
+	 * If (walk_flags & WALK_TREE_PHYSICAL), do not traverse symlinks.
+	 * If (walk_flags & WALK_TREE_LOGICAL), traverse all symlinks.
+	 * Otherwise, traverse only top-level symlinks.
+	 */
+	if (depth == 0)
+		flags |= WALK_TREE_TOPLEVEL;
+
+follow_symlink:
+	if (xstat(path, &dir.st) != 0)
+		return func(path, NULL, flags | WALK_TREE_FAILED, arg);
+	if (S_ISLNK(dir.st.st_mode)) {
+		flags |= WALK_TREE_SYMLINK;
+		if (flags & WALK_TREE_DEREFERENCE) {
+			xstat = stat;
+			goto follow_symlink;
+		}
+	}
+	err = func(path, &dir.st, flags, arg);
+	if ((flags & WALK_TREE_RECURSIVE) &&
+	    (S_ISDIR(dir.st.st_mode) || (S_ISLNK(dir.st.st_mode))) &&
+	    (!(flags & WALK_TREE_PHYSICAL) || !(flags & WALK_TREE_SYMLINK)) &&
+	    (flags & (WALK_TREE_LOGICAL | WALK_TREE_TOPLEVEL))) {
+		struct entry_handle *i;
+		struct dirent *entry;
+
+		/* Check if we have already visited this directory. */
+		for (i = head.next; i != &head; i = i->next)
+			if (i->st.st_dev == dir.st.st_dev &&
+			    i->st.st_ino == dir.st.st_ino)
+				return err;
+
+		if (num_dir_handles == 0 && closed->prev != &head) {
+close_another_dir:
+			/* Close the topmost directory handle still open. */
+			closed = closed->prev;
+			closed->pos = telldir(closed->stream);
+			closedir(closed->stream);
+			closed->stream = NULL;
+			num_dir_handles++;
+		}
+
+		dir.stream = opendir(path);
+		if (!dir.stream) {
+			if (errno == ENFILE && closed->prev != &head) {
+				/* Ran out of file descriptors. */
+				num_dir_handles = 0;
+				goto close_another_dir;
+			}
+
+			/*
+			 * PATH may be a symlink to a regular file, or a dead
+			 * symlink which we didn't follow above.
+			 */
+			if (errno != ENOTDIR && errno != ENOENT)
+				err += func(path, &dir.st,
+					    flags | WALK_TREE_FAILED, arg);
+			return err;
+		}
+
+		/* Insert into the list of handles. */
+		dir.next = head.next;
+		dir.prev = &head;
+		dir.prev->next = &dir;
+		dir.next->prev = &dir;
+		num_dir_handles--;
+
+		while ((entry = readdir(dir.stream)) != NULL) {
+			char *path_end;
+
+			if (!strcmp(entry->d_name, ".") ||
+			    !strcmp(entry->d_name, ".."))
+				continue;
+			path_end = strchr(path, 0);
+			if ((path_end - path) + strlen(entry->d_name) + 1 >=
+			    FILENAME_MAX) {
+				errno = ENAMETOOLONG;
+				err += func(path, NULL,
+					    flags | WALK_TREE_FAILED, arg);
+				continue;
+			}
+			*path_end++ = '/';
+			strcpy(path_end, entry->d_name);
+			err += walk_tree_rec(path, walk_flags, func, arg,
+					     depth + 1);
+			*--path_end = 0;
+			if (!dir.stream) {
+				/* Reopen the directory handle. */
+				dir.stream = opendir(path);
+				if (!dir.stream)
+					return err + func(path, &dir.st, flags |
+						    WALK_TREE_FAILED, arg);
+				seekdir(dir.stream, dir.pos);
+
+				closed = closed->next;
+				num_dir_handles--;
+			}
+		}
+
+		if (closedir(dir.stream) != 0)
+			err += func(path, &dir.st, flags | WALK_TREE_FAILED,
+				    arg);
+
+		/* Remove from the list of handles. */
+		dir.prev->next = dir.next;
+		dir.next->prev = dir.prev;
+		num_dir_handles++;
+	}
+	return err;
+}
+
+int walk_tree(const char *path, int walk_flags, unsigned int num,
+	      int (*func)(const char *, const struct stat *, int, void *),
+	      void *arg)
+{
+	char path_copy[FILENAME_MAX];
+
+	num_dir_handles = num;
+	if (num_dir_handles < 1) {
+		struct rlimit rlimit;
+
+		num_dir_handles = 1;
+		if (getrlimit(RLIMIT_NOFILE, &rlimit) == 0 &&
+		    rlimit.rlim_cur >= 2)
+			num_dir_handles = rlimit.rlim_cur / 2;
+	}
+	if (strlen(path) >= FILENAME_MAX) {
+		errno = ENAMETOOLONG;
+		return func(path, NULL, WALK_TREE_FAILED, arg);
+	}
+	strcpy(path_copy, path);
+	return walk_tree_rec(path_copy, walk_flags, func, arg, 0);
+}

--Boundary-00=_A3MJH2/pbEYYK1y
Content-Type: text/x-diff;
  charset="us-ascii";
  name="walk-attr.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="walk-attr.diff"

SW5kZXg6IGF0dHItMi40LjM5L2dldGZhdHRyL2dldGZhdHRyLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gYXR0ci0yLjQuMzkub3JpZy9nZXRmYXR0
ci9nZXRmYXR0ci5jCisrKyBhdHRyLTIuNC4zOS9nZXRmYXR0ci9nZXRmYXR0
ci5jCkBAIC0yOCwxMSArMjgsMTEgQEAKICNpbmNsdWRlIDxjdHlwZS5oPgog
I2luY2x1ZGUgPGdldG9wdC5oPgogI2luY2x1ZGUgPHJlZ2V4Lmg+Ci0jaW5j
bHVkZSA8ZnR3Lmg+CiAjaW5jbHVkZSA8bG9jYWxlLmg+CiAKICNpbmNsdWRl
IDxhdHRyL3hhdHRyLmg+CiAjaW5jbHVkZSAiY29uZmlnLmgiCisjaW5jbHVk
ZSAid2Fsa190cmVlLmgiCiAjaW5jbHVkZSAibWlzYy5oIgogCiAjZGVmaW5l
IENNRF9MSU5FX09QVElPTlMgIm46ZGU6bTpoUkxQIgpAQCAtNTQsMTEgKzU0
LDggQEAgc3RydWN0IG9wdGlvbiBsb25nX29wdGlvbnNbXSA9IHsKIAl7IE5V
TEwsCQkJMCwgMCwgMCB9CiB9OwogCi1pbnQgb3B0X3JlY3Vyc2l2ZTsgIC8q
IHJlY3Vyc2UgaW50byBzdWItZGlyZWN0b3JpZXM/ICovCi1pbnQgb3B0X3dh
bGtfbG9naWNhbDsgIC8qIGFsd2F5cyBmb2xsb3cgc3ltYm9saWMgbGlua3Mg
Ki8KLWludCBvcHRfd2Fsa19waHlzaWNhbDsgIC8qIG5ldmVyIGZvbGxvdyBz
eW1ib2xpYyBsaW5rcyAqLworaW50IHdhbGtfZmxhZ3MgPSBXQUxLX1RSRUVf
REVSRUZFUkVOQ0U7CiBpbnQgb3B0X2R1bXA7ICAvKiBkdW1wIGF0dHJpYnV0
ZSB2YWx1ZXMgKG9yIG9ubHkgbGlzdCB0aGUgbmFtZXMpICovCi1pbnQgb3B0
X2RlcmVmID0gMTsgIC8qIGRlcmVmZXJlbmNlIHN5bWJvbGljIGxpbmtzICov
CiBjaGFyICpvcHRfbmFtZTsgIC8qIGR1bXAgbmFtZWQgYXR0cmlidXRlcyAq
LwogY2hhciAqb3B0X25hbWVfcGF0dGVybiA9ICJedXNlclxcLiI7ICAvKiBp
bmNsdWRlIG9ubHkgbWF0Y2hpbmcgbmFtZXMgKi8KIGNoYXIgKm9wdF9lbmNv
ZGluZzsgIC8qIGVuY29kZSB2YWx1ZXMgYXV0b21hdGljYWxseSAoTlVMTCks
IG9yIGFzICJ0ZXh0IiwKQEAgLTg0LDEyICs4MSwxNCBAQCBzdGF0aWMgY29u
c3QgY2hhciAqeHF1b3RlKGNvbnN0IGNoYXIgKnN0CiAKIGludCBkb19nZXR4
YXR0cihjb25zdCBjaGFyICpwYXRoLCBjb25zdCBjaGFyICpuYW1lLCB2b2lk
ICp2YWx1ZSwgc2l6ZV90IHNpemUpCiB7Ci0JcmV0dXJuIChvcHRfZGVyZWYg
PyBnZXR4YXR0ciA6IGxnZXR4YXR0cikocGF0aCwgbmFtZSwgdmFsdWUsIHNp
emUpOworCXJldHVybiAoKHdhbGtfZmxhZ3MgJiBXQUxLX1RSRUVfREVSRUZF
UkVOQ0UpID8KKwkJZ2V0eGF0dHIgOiBsZ2V0eGF0dHIpKHBhdGgsIG5hbWUs
IHZhbHVlLCBzaXplKTsKIH0KIAogaW50IGRvX2xpc3R4YXR0cihjb25zdCBj
aGFyICpwYXRoLCBjaGFyICpsaXN0LCBzaXplX3Qgc2l6ZSkKIHsKLQlyZXR1
cm4gKG9wdF9kZXJlZiA/IGxpc3R4YXR0ciA6IGxsaXN0eGF0dHIpKHBhdGgs
IGxpc3QsIHNpemUpOworCXJldHVybiAoKHdhbGtfZmxhZ3MgJiBXQUxLX1RS
RUVfREVSRUZFUkVOQ0UpID8KKwkJbGlzdHhhdHRyIDogbGxpc3R4YXR0ciko
cGF0aCwgbGlzdCwgc2l6ZSk7CiB9CiAKIGNvbnN0IGNoYXIgKnN0cmVycm9y
X2VhKGludCBlcnIpCkBAIC0zNDcsMjEgKzM0NiwxOSBAQCBpbnQgbGlzdF9h
dHRyaWJ1dGVzKGNvbnN0IGNoYXIgKnBhdGgsIGluCiAJcmV0dXJuIDA7CiB9
CiAKLWludCBkb19wcmludChjb25zdCBjaGFyICpwYXRoLCBjb25zdCBzdHJ1
Y3Qgc3RhdCAqc3RhdCwKLSAgICAgICAgICAgICBpbnQgZmxhZywgc3RydWN0
IEZUVyAqZnR3KQoraW50IGRvX3ByaW50KGNvbnN0IGNoYXIgKnBhdGgsIGNv
bnN0IHN0cnVjdCBzdGF0ICpzdGF0LCBpbnQgd2Fsa19mbGFncywgdm9pZCAq
dW51c2VkKQogewotCWludCBzYXZlZF9lcnJubyA9IGVycm5vOwogCWludCBo
ZWFkZXJfcHJpbnRlZCA9IDA7CiAKLQkvKgotCSAqIFByb2Nlc3MgdGhlIHRh
cmdldCBvZiBhIHN5bWJvbGljIGxpbmssIGFuZCB0cmF2ZXJzZSB0aGUKLQkg
KiBsaW5rLCBvbmx5IGlmIGRvaW5nIGEgbG9naWNhbCB3YWxrLCBvciBpZiB0
aGUgc3ltYm9saWMgbGluawotCSAqIHdhcyBzcGVjaWZpZWQgb24gdGhlIGNv
bW1hbmQgbGluZS4gQWx3YXlzIHNraXAgc3ltYm9saWMKLQkgKiBsaW5rcyBp
ZiBkb2luZyBhIHBoeXNpY2FsIHdhbGsuCi0JICovCisJaWYgKHdhbGtfZmxh
Z3MgJiBXQUxLX1RSRUVfRkFJTEVEKSB7CisJCWZwcmludGYoc3RkZXJyLCAi
JXM6ICVzOiAlc1xuIiwgcHJvZ25hbWUsIHhxdW90ZShwYXRoKSwgc3RyZXJy
b3IoZXJybm8pKTsKKwkJcmV0dXJuIDE7CisJfQogCi0JaWYgKFNfSVNMTkso
c3RhdC0+c3RfbW9kZSkgJiYKLQkgICAgKG9wdF93YWxrX3BoeXNpY2FsIHx8
IChmdHctPmxldmVsID4gMCAmJiAhb3B0X3dhbGtfbG9naWNhbCkpKQorCWlm
ICgod2Fsa19mbGFncyAmIFdBTEtfVFJFRV9TWU1MSU5LKSAmJgorCSAgICAo
d2Fsa19mbGFncyAmIFdBTEtfVFJFRV9ERVJFRkVSRU5DRSkgJiYKKwkgICAg
KCh3YWxrX2ZsYWdzICYgV0FMS19UUkVFX1BIWVNJQ0FMKSB8fAorCSAgICAh
KHdhbGtfZmxhZ3MgJiAoV0FMS19UUkVFX1RPUExFVkVMIHwgV0FMS19UUkVF
X0xPR0lDQUwpKSkpCiAJCXJldHVybiAwOwogCiAJaWYgKG9wdF9uYW1lKQpA
QCAtMzcxLDIxICszNjgsNiBAQCBpbnQgZG9fcHJpbnQoY29uc3QgY2hhciAq
cGF0aCwgY29uc3Qgc3RyCiAKIAlpZiAoaGVhZGVyX3ByaW50ZWQpCiAJCXB1
dHMoIiIpOwotCi0JaWYgKGZsYWcgPT0gRlRXX0ROUiAmJiBvcHRfcmVjdXJz
aXZlKSB7Ci0JCS8qIEl0ZW0gaXMgYSBkaXJlY3Rvcnkgd2hpY2ggY2FuJ3Qg
YmUgcmVhZC4gKi8KLQkJZnByaW50ZihzdGRlcnIsICIlczogJXM6ICVzXG4i
LCBwcm9nbmFtZSwgeHF1b3RlKHBhdGgpLAotCQkJc3RyZXJyb3Ioc2F2ZWRf
ZXJybm8pKTsKLQkJcmV0dXJuIDA7Ci0JfQotCi0JLyoKLQkgKiBXZSBhbHNv
IGdldCBoZXJlIGluIG5vbi1yZWN1cnNpdmUgbW9kZS4gSW4gdGhhdCBjYXNl
LAotCSAqICByZXR1cm4gc29tZXRoaW5nICE9IDAgdG8gYWJvcnQgbmZ0dy4K
LQkgKi8KLQotCWlmICghb3B0X3JlY3Vyc2l2ZSkKLQkJcmV0dXJuIDE7CiAJ
cmV0dXJuIDA7CiB9CiAKQEAgLTQxMCwzOSArMzkyLDYgQEAgdm9pZCBoZWxw
KHZvaWQpCiAiICAgICAgLS1oZWxwICAgICAgICAgICAgICB0aGlzIGhlbHAg
dGV4dFxuIikpOwogfQogCi1jaGFyICpyZXNvbHZlX3N5bWxpbmtzKGNvbnN0
IGNoYXIgKmZpbGUpCi17Ci0Jc3RhdGljIGNoYXIgYnVmZmVyWzQwOTZdOwot
CXN0cnVjdCBzdGF0IHN0YXQ7Ci0JY2hhciAqcGF0aCA9IE5VTEw7Ci0KLQlp
ZiAobHN0YXQoZmlsZSwgJnN0YXQpID09IC0xKQotCQlyZXR1cm4gcGF0aDsK
LQotCWlmIChTX0lTTE5LKHN0YXQuc3RfbW9kZSkgJiYgIW9wdF93YWxrX3Bo
eXNpY2FsKQotCQlwYXRoID0gcmVhbHBhdGgoZmlsZSwgYnVmZmVyKTsKLQll
bHNlCi0JCXBhdGggPSAoY2hhciAqKWZpbGU7ICAgIC8qIG5vdCBhIHN5bWxp
bmssIHVzZSBnaXZlbiBwYXRoICovCi0KLQlyZXR1cm4gcGF0aDsKLX0KLQot
aW50IHdhbGtfdHJlZShjb25zdCBjaGFyICpmaWxlKQotewotCWNvbnN0IGNo
YXIgKnA7Ci0KLQlpZiAoKHAgPSByZXNvbHZlX3N5bWxpbmtzKGZpbGUpKSA9
PSBOVUxMKSB7Ci0JCWZwcmludGYoc3RkZXJyLCAiJXM6ICVzOiAlc1xuIiwg
cHJvZ25hbWUsCi0JCQl4cXVvdGUoZmlsZSksIHN0cmVycm9yKGVycm5vKSk7
Ci0JCXJldHVybiAxOwotCX0gZWxzZSBpZiAobmZ0dyhwLCBkb19wcmludCwg
MCwgb3B0X3dhbGtfbG9naWNhbD8gMCA6IEZUV19QSFlTKSA8IDApIHsKLQkJ
ZnByaW50ZihzdGRlcnIsICIlczogJXM6ICVzXG4iLCBwcm9nbmFtZSwgeHF1
b3RlKGZpbGUpLAotCQkJc3RyZXJyb3IoZXJybm8pKTsKLQkJcmV0dXJuIDE7
Ci0JfQotCXJldHVybiAwOwotfQotCiBpbnQgbWFpbihpbnQgYXJnYywgY2hh
ciAqYXJndltdKQogewogCWludCBvcHQ7CkBAIC00NzgsNyArNDI3LDcgQEAg
aW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkKIAkJCQlyZXR1cm4g
MDsKIAogCQkJY2FzZSAnaCc6IC8qIGRvIG5vdCBkZXJlZmVyZW5jZSBzeW1s
aW5rcyAqLwotCQkJCW9wdF9kZXJlZiA9IDA7CisJCQkJd2Fsa19mbGFncyAm
PSB+V0FMS19UUkVFX0RFUkVGRVJFTkNFOwogCQkJCWJyZWFrOwogCiAJCQlj
YXNlICduJzogIC8qIGdldCBuYW1lZCBhdHRyaWJ1dGUgKi8KQEAgLTQ5Nywx
NyArNDQ2LDE3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10p
CiAJCQkJYnJlYWs7CiAKIAkJCWNhc2UgJ0wnOgotCQkJCW9wdF93YWxrX2xv
Z2ljYWwgPSAxOwotCQkJCW9wdF93YWxrX3BoeXNpY2FsID0gMDsKKwkJCQl3
YWxrX2ZsYWdzIHw9IFdBTEtfVFJFRV9MT0dJQ0FMOworCQkJCXdhbGtfZmxh
Z3MgJj0gfldBTEtfVFJFRV9QSFlTSUNBTDsKIAkJCQlicmVhazsKIAogCQkJ
Y2FzZSAnUCc6Ci0JCQkJb3B0X3dhbGtfbG9naWNhbCA9IDA7Ci0JCQkJb3B0
X3dhbGtfcGh5c2ljYWwgPSAxOworCQkJCXdhbGtfZmxhZ3MgfD0gV0FMS19U
UkVFX1BIWVNJQ0FMOworCQkJCXdhbGtfZmxhZ3MgJj0gfldBTEtfVFJFRV9M
T0dJQ0FMOwogCQkJCWJyZWFrOwogCiAJCQljYXNlICdSJzoKLQkJCQlvcHRf
cmVjdXJzaXZlID0gMTsKKwkJCQl3YWxrX2ZsYWdzIHw9IFdBTEtfVFJFRV9S
RUNVUlNJVkU7CiAJCQkJYnJlYWs7CiAKIAkJCWNhc2UgJ1YnOgpAQCAtNTMx
LDcgKzQ4MCw4IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10p
CiAJfQogCiAJd2hpbGUgKG9wdGluZCA8IGFyZ2MpIHsKLQkJaGFkX2Vycm9y
cyArPSB3YWxrX3RyZWUoYXJndltvcHRpbmRdKTsKKwkJaGFkX2Vycm9ycyAr
PSB3YWxrX3RyZWUoYXJndltvcHRpbmRdLCB3YWxrX2ZsYWdzLCAwLAorCQkJ
CQlkb19wcmludCwgTlVMTCk7CiAJCW9wdGluZCsrOwogCX0KIApJbmRleDog
YXR0ci0yLjQuMzkvbGlibWlzYy9NYWtlZmlsZQo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09Ci0tLSBhdHRyLTIuNC4zOS5vcmlnL2xpYm1pc2MvTWFrZWZpbGUK
KysrIGF0dHItMi40LjM5L2xpYm1pc2MvTWFrZWZpbGUKQEAgLTgsNyArOCw3
IEBAIGluY2x1ZGUgJChUT1BESVIpL2luY2x1ZGUvYnVpbGRkZWZzCiBMVExJ
QlJBUlkgPSBsaWJtaXNjLmxhCiBMVExERkxBR1MgPQogCi1DRklMRVMgPSBx
dW90ZS5jIHVucXVvdGUuYyBoaWdoX3dhdGVyX2FsbG9jLmMgbmV4dF9saW5l
LmMKK0NGSUxFUyA9IHF1b3RlLmMgdW5xdW90ZS5jIGhpZ2hfd2F0ZXJfYWxs
b2MuYyBuZXh0X2xpbmUuYyB3YWxrX3RyZWUuYwogCiBkZWZhdWx0OiAkKExU
TElCUkFSWSkKIGluc3RhbGwgaW5zdGFsbC1kZXYgaW5zdGFsbC1saWI6Cklu
ZGV4OiBhdHRyLTIuNC4zOS90ZXN0L2F0dHIudGVzdAo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09Ci0tLSBhdHRyLTIuNC4zOS5vcmlnL3Rlc3QvYXR0ci50ZXN0
CisrKyBhdHRyLTIuNC4zOS90ZXN0L2F0dHIudGVzdApAQCAtMTAsNiArMTAs
OSBAQCBFeGVjdXRlIHRoaXMgdGVzdCB1c2luZyB0aGUgYHJ1bicgc2NyaXB0
CiAKIFRyeSB2YXJpb3VzIHZhbGlkIGFuZCBpbnZhbGlkIG5hbWVzCiAJCisJ
JCBta2RpciBkCisJJCBjZCBkCisKIAkkIHRvdWNoIGYKIAkkIHNldGZhdHRy
IC1uIHVzZXIgLXYgdmFsdWUgZgogCT4gc2V0ZmF0dHI6IGY6IE9wZXJhdGlv
biBub3Qgc3VwcG9ydGVkCkBAIC0yOSw4ICszMiw4IEBAIFRyeSB2YXJpb3Vz
IHZhbGlkIGFuZCBpbnZhbGlkIG5hbWVzCiBTaXplIGNoZWNrcywgZm9yIGFu
IGV4dDIvZXh0MyBmaWxlIHN5c3RlbSB3aXRoIGEgYmxvY2sgc2l6ZSBvZiA0
SwogCiAJJCB0b3VjaCBmCi0JJCBzZXRmYXR0ciAtbiB1c2VyLm5hbWUgLXYg
NDA0MCsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysgZgotCSQgc2V0ZmF0
dHIgLW4gdXNlci5uYW1lIC12IDQwNDErKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKyBmCisJJCBzZXRmYXR0ciAtbiB1c2VyLm5hbWUgLXYgNDA0MCsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrIGYKKwkkIHNldGZhdHRyIC1u
IHVzZXIubmFtZSAtdiA0MDQxKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysgZgogCT4gc2V0ZmF0dHI6IGY6IE5vIHNwYWNlIGxlZnQgb24gZGV2
aWNlCiAJCiAJJCBybSBmCkBAIC04NiwxMyArODksNiBAQCBWYWx1ZSBlbmNv
ZGluZ3MKIAk+IHVzZXIubmFtZTM9MHMzdnJPCiAJPiAKIAkKLQkkIGdldGZh
dHRyIC1kIC1lIHRleHQgZgotCT4gIyBmaWxlOiBmCi0JPiB1c2VyLm5hbWU9
Irq+IgotCT4gdXNlci5uYW1lMj0i3q2+7yIKLQk+IHVzZXIubmFtZTM9It76
ziIKLQk+IAotCQogCSQgcm0gZgogCiBFdmVyeXRoaW5nIHdpdGggb25lIGZp
bGUKQEAgLTEwNSw3ICsxMDEsNyBAQCBFdmVyeXRoaW5nIHdpdGggb25lIGZp
bGUKIAkkIHNldGZhdHRyIC1uIHVzZXIuc2hvcnQgLXYgdmFsdWUgZgogCSQg
c2V0ZmF0dHIgLW4gdXNlci5ub3ZhbHVlLXlldCBmCiAJJCBscyAtcyBmCi0J
PiAgICA0IGYKKwk+IDQgZgogCQogCSQgZ2V0ZmF0dHIgLWQgZgogCT4gIyBm
aWxlOiBmCkBAIC0xNDMsNyArMTM5LDcgQEAgRXZlcnl0aGluZyB3aXRoIG9u
ZSBmaWxlCiAJJCBzZXRmYXR0ciAteCB1c2VyLm5vdmFsdWUteWV0IGYKIAkk
IGdldGZhdHRyIC1kIGYKIAkkIGxzIC1zIGYKLQk+ICAgIDAgZgorCT4gMCBm
CiAJCiAJJCBybSBmCiAKQEAgLTE1MiwxNSArMTQ4LDE1IEBAIFRlc3QgZXh0
ZW5kZWQgYXR0cmlidXRlIGJsb2NrIHNoYXJpbmcKIAkkIHRvdWNoIGYgZyBo
CiAJJCBzZXRmYXR0ciAtbiB1c2VyLm5vdmFsdWUgZiBnIGgKIAkkIGxzIC1z
IGYgZyBoCi0JPiAgICA0IGYKLQk+ICAgIDQgZwotCT4gICAgNCBoCisJPiA0
IGYKKwk+IDQgZworCT4gNCBoCiAJCiAJJCBzZXRmYXR0ciAtbiB1c2VyLm5h
bWUgLXYgdmFsdWUgZgogCSQgbHMgLXMgZiBnIGgKLQk+ICAgIDQgZgotCT4g
ICAgNCBnCi0JPiAgICA0IGgKKwk+IDQgZgorCT4gNCBnCisJPiA0IGgKIAkK
IAkkIGdldGZhdHRyIC1kIGYgZyBoCiAJPiAjIGZpbGU6IGYKQEAgLTE3Niwx
NSArMTcyLDE1IEBAIFRlc3QgZXh0ZW5kZWQgYXR0cmlidXRlIGJsb2NrIHNo
YXJpbmcKIAkKIAkkIHNldGZhdHRyIC1uIHVzZXIubmFtZSAtdiB2YWx1ZSBn
CiAJJCBscyAtcyBmIGcgaAotCT4gICAgNCBmCi0JPiAgICA0IGcKLQk+ICAg
IDQgaAorCT4gNCBmCisJPiA0IGcKKwk+IDQgaAogCQogCSQgc2V0ZmF0dHIg
LXggdXNlci5ub3ZhbHVlIGgKIAkkIGxzIC1zIGYgZyBoCi0JPiAgICA0IGYK
LQk+ICAgIDQgZwotCT4gICAgMCBoCisJPiA0IGYKKwk+IDQgZworCT4gMCBo
CiAJCiAJJCBnZXRmYXR0ciAtZCBmIGcgaAogCT4gIyBmaWxlOiBmCkBAIC0y
MDEsOSArMTk3LDkgQEAgVGVzdCBleHRlbmRlZCBhdHRyaWJ1dGUgYmxvY2sg
c2hhcmluZwogCSQgc2V0ZmF0dHIgLXggdXNlci5uYW1lIGYgZwogCSQgc2V0
ZmF0dHIgLXggdXNlci5ub3ZhbHVlIGYgZwogCSQgbHMgLXMgZiBnIGgKLQk+
ICAgIDAgZgotCT4gICAgMCBnCi0JPiAgICAwIGgKKwk+IDAgZgorCT4gMCBn
CisJPiAwIGgKIAkKIAkkIHJtIGYgZyBoCiAKQEAgLTI2MCw2ICsyNTYsNSBA
QCBUZXN0cyBmb3IgYXR0cmlidXRlIG5hbWVzIHRoYXQgY29udGFpbnMgCiAJ
JCBzZXRmYXR0ciAteCAidXNlci5zcGVjaWFsXFwwMDciIGYKIAkkIHJtIGYK
IAotU29tZSBQT1NJWCBBQ0wgdGVzdHMuLi4KLQotCSQgdG91Y2ggZgorCSQg
Y2QgLi4KKwkkIHJtIC1yZiBkCkluZGV4OiBhdHRyLTIuNC4zOS9pbmNsdWRl
L3dhbGtfdHJlZS5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIC9kZXYv
bnVsbAorKysgYXR0ci0yLjQuMzkvaW5jbHVkZS93YWxrX3RyZWUuaApAQCAt
MCwwICsxLDE5IEBACisjaWZuZGVmIF9fV0FMS19UUkVFX0gKKyNkZWZpbmUg
X19XQUxLX1RSRUVfSAorCisjZGVmaW5lIFdBTEtfVFJFRV9SRUNVUlNJVkUJ
MHgxCisjZGVmaW5lIFdBTEtfVFJFRV9QSFlTSUNBTAkweDIKKyNkZWZpbmUg
V0FMS19UUkVFX0xPR0lDQUwJMHg0CisjZGVmaW5lIFdBTEtfVFJFRV9ERVJF
RkVSRU5DRQkweDgKKworI2RlZmluZSBXQUxLX1RSRUVfVE9QTEVWRUwJMHgx
MDAKKyNkZWZpbmUgV0FMS19UUkVFX1NZTUxJTksJMHgyMDAKKyNkZWZpbmUg
V0FMS19UUkVFX0ZBSUxFRAkweDQwMAorCitzdHJ1Y3Qgc3RhdDsKKworZXh0
ZXJuIGludCB3YWxrX3RyZWUoY29uc3QgY2hhciAqcGF0aCwgaW50IHdhbGtf
ZmxhZ3MsIHVuc2lnbmVkIGludCBudW0sCisJCSAgICAgaW50ICgqZnVuYyko
Y29uc3QgY2hhciAqLCBjb25zdCBzdHJ1Y3Qgc3RhdCAqLCBpbnQsCisJCQkJ
IHZvaWQgKiksIHZvaWQgKmFyZyk7CisKKyNlbmRpZgpJbmRleDogYXR0ci0y
LjQuMzkvbGlibWlzYy93YWxrX3RyZWUuYwo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09Ci0tLSAvZGV2L251bGwKKysrIGF0dHItMi40LjM5L2xpYm1pc2Mvd2Fs
a190cmVlLmMKQEAgLTAsMCArMSwxODggQEAKKy8qCisgIEZpbGU6IHdhbGtf
dHJlZS5jCisKKyAgQ29weXJpZ2h0IChDKSAyMDA3IEFuZHJlYXMgR3J1ZW5i
YWNoZXIgPGEuZ3J1ZW5iYWNoZXJAY29tcHV0ZXIub3JnPgorCisgIFRoaXMg
cHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0
ZSBpdCBhbmQvb3IKKyAgbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0
aGUgR05VIExpYnJhcnkgR2VuZXJhbCBQdWJsaWMKKyAgTGljZW5zZSBhcyBw
dWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0
aGVyCisgIHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIg
b3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KKworICBUaGlzIHByb2dyYW0g
aXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVz
ZWZ1bCwKKyAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2
ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAgTUVSQ0hBTlRBQklMSVRZ
IG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRo
ZSBHTlUKKyAgTGlicmFyeSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBt
b3JlIGRldGFpbHMuCisKKyAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEg
Y29weSBvZiB0aGUgR05VIExpYnJhcnkgR2VuZXJhbCBQdWJsaWMKKyAgTGlj
ZW5zZSBhbG9uZyB3aXRoIHRoaXMgbGlicmFyeTsgaWYgbm90LCB3cml0ZSB0
byB0aGUgRnJlZSBTb2Z0d2FyZQorICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBU
ZW1wbGUgUGxhY2UgLSBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMw
NywgVVNBLgorKi8KKworI2luY2x1ZGUgPHN5cy90eXBlcy5oPgorI2luY2x1
ZGUgPHN5cy9zdGF0Lmg+CisjaW5jbHVkZSA8dW5pc3RkLmg+CisjaW5jbHVk
ZSA8c3lzL3RpbWUuaD4KKyNpbmNsdWRlIDxzeXMvcmVzb3VyY2UuaD4KKyNp
bmNsdWRlIDxkaXJlbnQuaD4KKyNpbmNsdWRlIDxzdGRpby5oPgorI2luY2x1
ZGUgPHN0cmluZy5oPgorI2luY2x1ZGUgPGVycm5vLmg+CisKKyNpbmNsdWRl
ICJ3YWxrX3RyZWUuaCIKKworc3RydWN0IGVudHJ5X2hhbmRsZSB7CisJc3Ry
dWN0IGVudHJ5X2hhbmRsZSAqcHJldiwgKm5leHQ7CisJc3RydWN0IHN0YXQg
c3Q7CisJRElSICpzdHJlYW07CisJb2ZmX3QgcG9zOworfTsKKworc3RydWN0
IGVudHJ5X2hhbmRsZSBoZWFkID0geworCS5uZXh0ID0gJmhlYWQsCisJLnBy
ZXYgPSAmaGVhZCwKKwkvKiBUaGUgb3RoZXIgZmllbGRzIGFyZSB1bnVzZWQu
ICovCit9Oworc3RydWN0IGVudHJ5X2hhbmRsZSAqY2xvc2VkID0gJmhlYWQ7
Cit1bnNpZ25lZCBpbnQgbnVtX2Rpcl9oYW5kbGVzOworCitzdGF0aWMgaW50
IHdhbGtfdHJlZV9yZWMoY29uc3QgY2hhciAqcGF0aCwgaW50IHdhbGtfZmxh
Z3MsCisJCQkgaW50ICgqZnVuYykoY29uc3QgY2hhciAqLCBjb25zdCBzdHJ1
Y3Qgc3RhdCAqLCBpbnQsCisJCQkgCSAgICAgdm9pZCAqKSwgdm9pZCAqYXJn
LCBpbnQgZGVwdGgpCit7CisJaW50ICgqeHN0YXQpKGNvbnN0IGNoYXIgKiwg
c3RydWN0IHN0YXQgKikgPSBsc3RhdDsKKwlpbnQgZmxhZ3MgPSB3YWxrX2Zs
YWdzLCBlcnI7CisJc3RydWN0IGVudHJ5X2hhbmRsZSBkaXI7CisKKwkvKgor
CSAqIElmICh3YWxrX2ZsYWdzICYgV0FMS19UUkVFX1BIWVNJQ0FMKSwgZG8g
bm90IHRyYXZlcnNlIHN5bWxpbmtzLgorCSAqIElmICh3YWxrX2ZsYWdzICYg
V0FMS19UUkVFX0xPR0lDQUwpLCB0cmF2ZXJzZSBhbGwgc3ltbGlua3MuCisJ
ICogT3RoZXJ3aXNlLCB0cmF2ZXJzZSBvbmx5IHRvcC1sZXZlbCBzeW1saW5r
cy4KKwkgKi8KKwlpZiAoZGVwdGggPT0gMCkKKwkJZmxhZ3MgfD0gV0FMS19U
UkVFX1RPUExFVkVMOworCitmb2xsb3dfc3ltbGluazoKKwlpZiAoeHN0YXQo
cGF0aCwgJmRpci5zdCkgIT0gMCkKKwkJcmV0dXJuIGZ1bmMocGF0aCwgTlVM
TCwgZmxhZ3MgfCBXQUxLX1RSRUVfRkFJTEVELCBhcmcpOworCWlmIChTX0lT
TE5LKGRpci5zdC5zdF9tb2RlKSkgeworCQlmbGFncyB8PSBXQUxLX1RSRUVf
U1lNTElOSzsKKwkJaWYgKGZsYWdzICYgV0FMS19UUkVFX0RFUkVGRVJFTkNF
KSB7CisJCQl4c3RhdCA9IHN0YXQ7CisJCQlnb3RvIGZvbGxvd19zeW1saW5r
OworCQl9CisJfQorCWVyciA9IGZ1bmMocGF0aCwgJmRpci5zdCwgZmxhZ3Ms
IGFyZyk7CisJaWYgKChmbGFncyAmIFdBTEtfVFJFRV9SRUNVUlNJVkUpICYm
CisJICAgIChTX0lTRElSKGRpci5zdC5zdF9tb2RlKSB8fCAoU19JU0xOSyhk
aXIuc3Quc3RfbW9kZSkpKSAmJgorCSAgICAoIShmbGFncyAmIFdBTEtfVFJF
RV9QSFlTSUNBTCkgfHwgIShmbGFncyAmIFdBTEtfVFJFRV9TWU1MSU5LKSkg
JiYKKwkgICAgKGZsYWdzICYgKFdBTEtfVFJFRV9MT0dJQ0FMIHwgV0FMS19U
UkVFX1RPUExFVkVMKSkpIHsKKwkJc3RydWN0IGVudHJ5X2hhbmRsZSAqaTsK
KwkJc3RydWN0IGRpcmVudCAqZW50cnk7CisKKwkJLyogQ2hlY2sgaWYgd2Ug
aGF2ZSBhbHJlYWR5IHZpc2l0ZWQgdGhpcyBkaXJlY3RvcnkuICovCisJCWZv
ciAoaSA9IGhlYWQubmV4dDsgaSAhPSAmaGVhZDsgaSA9IGktPm5leHQpCisJ
CQlpZiAoaS0+c3Quc3RfZGV2ID09IGRpci5zdC5zdF9kZXYgJiYKKwkJCSAg
ICBpLT5zdC5zdF9pbm8gPT0gZGlyLnN0LnN0X2lubykKKwkJCQlyZXR1cm4g
ZXJyOworCisJCWlmIChudW1fZGlyX2hhbmRsZXMgPT0gMCAmJiBjbG9zZWQt
PnByZXYgIT0gJmhlYWQpIHsKK2Nsb3NlX2Fub3RoZXJfZGlyOgorCQkJLyog
Q2xvc2UgdGhlIHRvcG1vc3QgZGlyZWN0b3J5IGhhbmRsZSBzdGlsbCBvcGVu
LiAqLworCQkJY2xvc2VkID0gY2xvc2VkLT5wcmV2OworCQkJY2xvc2VkLT5w
b3MgPSB0ZWxsZGlyKGNsb3NlZC0+c3RyZWFtKTsKKwkJCWNsb3NlZGlyKGNs
b3NlZC0+c3RyZWFtKTsKKwkJCWNsb3NlZC0+c3RyZWFtID0gTlVMTDsKKwkJ
CW51bV9kaXJfaGFuZGxlcysrOworCQl9CisKKwkJZGlyLnN0cmVhbSA9IG9w
ZW5kaXIocGF0aCk7CisJCWlmICghZGlyLnN0cmVhbSkgeworCQkJaWYgKGVy
cm5vID09IEVORklMRSAmJiBjbG9zZWQtPnByZXYgIT0gJmhlYWQpIHsKKwkJ
CQkvKiBSYW4gb3V0IG9mIGZpbGUgZGVzY3JpcHRvcnMuICovCisJCQkJbnVt
X2Rpcl9oYW5kbGVzID0gMDsKKwkJCQlnb3RvIGNsb3NlX2Fub3RoZXJfZGly
OworCQkJfQorCisJCQkvKgorCQkJICogUEFUSCBtYXkgYmUgYSBzeW1saW5r
IHRvIGEgcmVndWxhciBmaWxlLCBvciBhIGRlYWQKKwkJCSAqIHN5bWxpbmsg
d2hpY2ggd2UgZGlkbid0IGZvbGxvdyBhYm92ZS4KKwkJCSAqLworCQkJaWYg
KGVycm5vICE9IEVOT1RESVIgJiYgZXJybm8gIT0gRU5PRU5UKQorCQkJCWVy
ciArPSBmdW5jKHBhdGgsICZkaXIuc3QsCisJCQkJCSAgICBmbGFncyB8IFdB
TEtfVFJFRV9GQUlMRUQsIGFyZyk7CisJCQlyZXR1cm4gZXJyOworCQl9CisK
KwkJLyogSW5zZXJ0IGludG8gdGhlIGxpc3Qgb2YgaGFuZGxlcy4gKi8KKwkJ
ZGlyLm5leHQgPSBoZWFkLm5leHQ7CisJCWRpci5wcmV2ID0gJmhlYWQ7CisJ
CWRpci5wcmV2LT5uZXh0ID0gJmRpcjsKKwkJZGlyLm5leHQtPnByZXYgPSAm
ZGlyOworCQludW1fZGlyX2hhbmRsZXMtLTsKKworCQl3aGlsZSAoKGVudHJ5
ID0gcmVhZGRpcihkaXIuc3RyZWFtKSkgIT0gTlVMTCkgeworCQkJY2hhciAq
cGF0aF9lbmQ7CisKKwkJCWlmICghc3RyY21wKGVudHJ5LT5kX25hbWUsICIu
IikgfHwKKwkJCSAgICAhc3RyY21wKGVudHJ5LT5kX25hbWUsICIuLiIpKQor
CQkJCWNvbnRpbnVlOworCQkJcGF0aF9lbmQgPSBzdHJjaHIocGF0aCwgMCk7
CisJCQlpZiAoKHBhdGhfZW5kIC0gcGF0aCkgKyBzdHJsZW4oZW50cnktPmRf
bmFtZSkgKyAxID49CisJCQkgICAgRklMRU5BTUVfTUFYKSB7CisJCQkJZXJy
bm8gPSBFTkFNRVRPT0xPTkc7CisJCQkJZXJyICs9IGZ1bmMocGF0aCwgTlVM
TCwKKwkJCQkJICAgIGZsYWdzIHwgV0FMS19UUkVFX0ZBSUxFRCwgYXJnKTsK
KwkJCQljb250aW51ZTsKKwkJCX0KKwkJCSpwYXRoX2VuZCsrID0gJy8nOwor
CQkJc3RyY3B5KHBhdGhfZW5kLCBlbnRyeS0+ZF9uYW1lKTsKKwkJCWVyciAr
PSB3YWxrX3RyZWVfcmVjKHBhdGgsIHdhbGtfZmxhZ3MsIGZ1bmMsIGFyZywK
KwkJCQkJICAgICBkZXB0aCArIDEpOworCQkJKi0tcGF0aF9lbmQgPSAwOwor
CQkJaWYgKCFkaXIuc3RyZWFtKSB7CisJCQkJLyogUmVvcGVuIHRoZSBkaXJl
Y3RvcnkgaGFuZGxlLiAqLworCQkJCWRpci5zdHJlYW0gPSBvcGVuZGlyKHBh
dGgpOworCQkJCWlmICghZGlyLnN0cmVhbSkKKwkJCQkJcmV0dXJuIGVyciAr
IGZ1bmMocGF0aCwgJmRpci5zdCwgZmxhZ3MgfAorCQkJCQkJICAgIFdBTEtf
VFJFRV9GQUlMRUQsIGFyZyk7CisJCQkJc2Vla2RpcihkaXIuc3RyZWFtLCBk
aXIucG9zKTsKKworCQkJCWNsb3NlZCA9IGNsb3NlZC0+bmV4dDsKKwkJCQlu
dW1fZGlyX2hhbmRsZXMtLTsKKwkJCX0KKwkJfQorCisJCWlmIChjbG9zZWRp
cihkaXIuc3RyZWFtKSAhPSAwKQorCQkJZXJyICs9IGZ1bmMocGF0aCwgJmRp
ci5zdCwgZmxhZ3MgfCBXQUxLX1RSRUVfRkFJTEVELAorCQkJCSAgICBhcmcp
OworCisJCS8qIFJlbW92ZSBmcm9tIHRoZSBsaXN0IG9mIGhhbmRsZXMuICov
CisJCWRpci5wcmV2LT5uZXh0ID0gZGlyLm5leHQ7CisJCWRpci5uZXh0LT5w
cmV2ID0gZGlyLnByZXY7CisJCW51bV9kaXJfaGFuZGxlcysrOworCX0KKwly
ZXR1cm4gZXJyOworfQorCitpbnQgd2Fsa190cmVlKGNvbnN0IGNoYXIgKnBh
dGgsIGludCB3YWxrX2ZsYWdzLCB1bnNpZ25lZCBpbnQgbnVtLAorCSAgICAg
IGludCAoKmZ1bmMpKGNvbnN0IGNoYXIgKiwgY29uc3Qgc3RydWN0IHN0YXQg
KiwgaW50LCB2b2lkICopLAorCSAgICAgIHZvaWQgKmFyZykKK3sKKwljaGFy
IHBhdGhfY29weVtGSUxFTkFNRV9NQVhdOworCisJbnVtX2Rpcl9oYW5kbGVz
ID0gbnVtOworCWlmIChudW1fZGlyX2hhbmRsZXMgPCAxKSB7CisJCXN0cnVj
dCBybGltaXQgcmxpbWl0OworCisJCW51bV9kaXJfaGFuZGxlcyA9IDE7CisJ
CWlmIChnZXRybGltaXQoUkxJTUlUX05PRklMRSwgJnJsaW1pdCkgPT0gMCAm
JgorCQkgICAgcmxpbWl0LnJsaW1fY3VyID49IDIpCisJCQludW1fZGlyX2hh
bmRsZXMgPSBybGltaXQucmxpbV9jdXIgLyAyOworCX0KKwlpZiAoc3RybGVu
KHBhdGgpID49IEZJTEVOQU1FX01BWCkgeworCQllcnJubyA9IEVOQU1FVE9P
TE9ORzsKKwkJcmV0dXJuIGZ1bmMocGF0aCwgTlVMTCwgV0FMS19UUkVFX0ZB
SUxFRCwgYXJnKTsKKwl9CisJc3RyY3B5KHBhdGhfY29weSwgcGF0aCk7CisJ
cmV0dXJuIHdhbGtfdHJlZV9yZWMocGF0aF9jb3B5LCB3YWxrX2ZsYWdzLCBm
dW5jLCBhcmcsIDApOworfQpJbmRleDogYXR0ci0yLjQuMzkvdGVzdC9nZXRm
YXR0ci50ZXN0Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIC9kZXYvbnVs
bAorKysgYXR0ci0yLjQuMzkvdGVzdC9nZXRmYXR0ci50ZXN0CkBAIC0wLDAg
KzEsNTIgQEAKKwkkIG1rZGlyIGQKKwkkIGNkIGQKKworCSQgdG91Y2ggZgor
CSQgc2V0ZmF0dHIgLW4gdXNlci50ZXN0IC12IHRlc3QgZgorCSQgbG4gLXMg
ZiBsCisKK1RoaXMgY2FzZSBzaG91bGQgYmUgb2J2aW91czoKKwkkIGdldGZh
dHRyIC1kIGYKKwk+ICMgZmlsZTogZgorCT4gdXNlci50ZXN0PSJ0ZXN0Igor
CT4KKworSWYgYSBzeW1saW5rIGlzIGV4cGxpY2l0bHkgc3BlY2lmaWVkIG9u
IHRoZSBjb21tYW5kIGxpbmUsIGZvbGxvdyBpdAorKC1IIGJlaGF2aW9yKToK
KwkkIGdldGZhdHRyIC1kIGwKKwk+ICMgZmlsZTogbAorCT4gdXNlci50ZXN0
PSJ0ZXN0IgorCT4KKworVW5sZXNzIHdlIGFyZSBleHBsaWNpdGx5IHRvbGQg
bm90IHRvIGRlcmVmZXJlbmNlIHN5bWxpbmtzOgorCSQgZ2V0ZmF0dHIgLWhk
IGwKKworV2hlbiB3YWxraW5nIGEgdHJlZSwgaXQgZG9lcyBub3QgbWFrZSBz
ZW5zZSB0byBmb2xsb3cgc3ltbGlua3MuIFdlIHNob3VsZAorb25seSBzZWUg
ZidzIGF0dHJpYnV0ZXMgaGVyZSAtLSB0aGF0J3MgYSBidWc6CisJJCBnZXRm
YXR0ciAtUmQgLgorCT4gIyBmaWxlOiBmCisJPiB1c2VyLnRlc3Q9InRlc3Qi
CisJPgorCitUaGlzIGNhc2Ugd29ya3MgYXMgZXhwZWN0ZWQ6CisJJCBnZXRm
YXR0ciAtUmhkIC4KKwk+ICMgZmlsZTogZgorCT4gdXNlci50ZXN0PSJ0ZXN0
IgorCT4KKworSW4gdGhlc2UgdHdvIGNhc2VzLCBnZXRmYXR0ciBzaG91bGQg
ZGVyZWZlcmVuY2UgdGhlIHN5bWxpbmsgcGFzc2VkIG9uIHRoZQorY29tbWFu
ZCBsaW5lLCBidXQgbm90IGwuIFRoaXMgZG9lc24ndCB3b3JrIGNvcnJlY3Rs
eSwgZWl0aGVyOyBpdCdzIHRoZSBzYW1lCitidWc6CisJJCBsbiAtcyAuIGhl
cmUKKwkkIGdldGZhdHRyIC1SZCBoZXJlCisJPiAjIGZpbGU6IGhlcmUvZgor
CT4gdXNlci50ZXN0PSJ0ZXN0IgorCT4KKworCSQgZ2V0ZmF0dHIgLVJoZCBo
ZXJlCisJPiAjIGZpbGU6IGhlcmUvZgorCT4gdXNlci50ZXN0PSJ0ZXN0Igor
CT4KKworCSQgY2QgLi4KKwkkIHJtIC1yZiBkCg==

--Boundary-00=_A3MJH2/pbEYYK1y--
