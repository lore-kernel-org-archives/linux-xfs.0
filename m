Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5HCkUY2211945 for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 07:46:31 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF41492F554
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 05:54:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2H45bw01AMEAK0TC for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2009 05:54:39 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: acl: Preserving the setuid/setgid/sticky bits
Date: Wed, 17 Jun 2009 14:46:07 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QWOOKGDS7msUVQp"
Message-Id: <200906171446.08032.agruen@suse.de>
Reply-To: acl-devel@nongnu.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: acl-devel@nongnu.org
Cc: Brandon Philips <brandon@ifup.org>, xfs@oss.sgi.com

--Boundary-00=_QWOOKGDS7msUVQp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

(Copying the xfs list for a wider audience while moving to the new list;
 please reply to acl-devel@nongnu.org.)

in a recent bug report, we found out that setfacl --restore sometimes destroys 
the suid/sgid bits. This has been fixed [1], but problem that setfacl
--restore cannot restore the setuid/setgid/sticky bits still remains: getfacl 
simply does not include this information in its output.

[1] Avoid unnecessary but destructive chown calls,
    http://git.savannah.gnu.org/cgit/acl.git/commit/?id=45833cc

Based on an earlier version from Brandon, I have created a patch which causes 
getfacl to include the special bits in its output, and setfacl to restore the 
bits when possible. The proposed format for special flags in the getfacl 
output would be:

	$ cd /
	$ getfacl bin/ping tmp
	# file: bin/ping
	# owner: root
	# group: root
	# flags: s--
	user::rwx
	group::r-x
	other::r-x

	# file: tmp
	# owner: root
	# group: root
	# flags: --t
	user::rwx
	group::rwx
	other::rwx

In the current version, getfacl only includes the new flags: comment for files 
which have any of the special set. Setfacl --restore clears all special bits 
if there is no flags: comment, and sets them accordingly otherwise. (Without 
--restore, setfacl disregards such comments, just like it disregards the other 
comments.)

Does this extension look reasonable?

Any objections to changing the behavior of --restore to clear the special 
flags in case there is no flags: comment? (And if so, wow would you like this 
solved instead?)

Thanks,
Andreas

--Boundary-00=_QWOOKGDS7msUVQp
Content-Type: text/x-patch;
  charset="us-ascii";
  name="flags.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="flags.diff"

commit 5f60ceef5ed39872207cb52528ccc98f40ef76f7
Author: Andreas Gruenbacher <agruen@suse.de>
Date:   Mon Jun 8 17:04:48 2009 +0200

    Include the S_ISUID, S_ISGID, S_ISVTX flags in the getfacl output, and restore them with "setfacl --restore=file".

diff --git a/getfacl/getfacl.c b/getfacl/getfacl.c
index ab050ba..ba03686 100644
--- a/getfacl/getfacl.c
+++ b/getfacl/getfacl.c
@@ -423,6 +423,18 @@ acl_get_file_mode(const char *path_p)
 	return acl_from_mode(st.st_mode);
 }
 
+static const char *
+flagstr(mode_t mode)
+{
+	static char str[4];
+
+	str[0] = (mode & S_ISUID) ? 's' : '-';
+	str[1] = (mode & S_ISGID) ? 's' : '-';
+	str[2] = (mode & S_ISVTX) ? 't' : '-';
+	str[3] = '\0';
+	return str;
+}
+
 int do_print(const char *path_p, const struct stat *st, int walk_flags, void *unused)
 {
 	const char *default_prefix = NULL;
@@ -498,6 +510,8 @@ int do_print(const char *path_p, const struct stat *st, int walk_flags, void *un
 			       xquote(user_name(st->st_uid, opt_numeric)));
 			printf("# group: %s\n",
 			       xquote(group_name(st->st_gid, opt_numeric)));
+			if (st->st_mode & (S_ISVTX | S_ISUID | S_ISGID))
+				printf("# flags: %s\n", flagstr(st->st_mode));
 		}
 		if (acl != NULL) {
 			char *acl_text = acl_to_any_text(acl, NULL, '\n',
diff --git a/setfacl/Makefile b/setfacl/Makefile
index 46b74d9..c44e7c0 100644
--- a/setfacl/Makefile
+++ b/setfacl/Makefile
@@ -21,7 +21,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = setfacl
 CFILES = setfacl.c do_set.c sequence.c parse.c
-HFILES = sequence.h parse.h
+HFILES = sequence.h parse.h do_set.h
 
 LLDLIBS = $(LIBMISC) $(LIBACL) $(LIBATTR)
 LTDEPENDENCIES = $(LIBMISC) $(LIBACL)
diff --git a/setfacl/do_set.c b/setfacl/do_set.c
index b9c0ce7..d518d76 100644
--- a/setfacl/do_set.c
+++ b/setfacl/do_set.c
@@ -34,6 +34,7 @@
 #include <dirent.h>
 #include <ftw.h>
 #include "sequence.h"
+#include "do_set.h"
 #include "parse.h"
 #include "config.h"
 #include "walk_tree.h"
@@ -262,7 +263,7 @@ do_set(
 	int walk_flags,
 	void *arg)
 {
-	const seq_t seq = (const seq_t)arg;
+	struct do_set_args *args = arg;
 	acl_t old_acl = NULL, old_default_acl = NULL;
 	acl_t acl = NULL, default_acl = NULL;
 	acl_t *xacl, *old_xacl;
@@ -290,7 +291,7 @@ do_set(
 		return 0;
 
 	/* Execute the commands in seq (read ACLs on demand) */
-	error = seq_get_cmd(seq, SEQ_FIRST_CMD, &cmd);
+	error = seq_get_cmd(args->seq, SEQ_FIRST_CMD, &cmd);
 	if (error == 0)
 		return 0;
 	while (error == 1) {
@@ -357,7 +358,7 @@ do_set(
 				goto fail;
 		}
 
-		error = seq_get_cmd(seq, SEQ_NEXT_CMD, &cmd);
+		error = seq_get_cmd(args->seq, SEQ_NEXT_CMD, &cmd);
 	}
 
 	if (error < 0)
@@ -467,19 +468,21 @@ do_set(
 		goto cleanup;
 	}
 	if (acl) {
+		mode_t mode = 0;
+		int equiv_mode;
+
+		equiv_mode = acl_equiv_mode(acl, &mode);
+
 		if (acl_set_file(path_p, ACL_TYPE_ACCESS, acl) != 0) {
 			if (errno == ENOSYS || errno == ENOTSUP) {
-				int saved_errno = errno;
-				mode_t mode;
-
-				if (acl_equiv_mode(acl, &mode) != 0) {
-					errno = saved_errno;
+				if (equiv_mode != 0)
 					goto fail;
-				} else if (chmod(path_p, mode) != 0)
+				else if (chmod(path_p, mode) != 0)
 					goto fail;
 			} else
 				goto fail;
 		}
+		args->mode = mode;
 	}
 	if (default_acl) {
 		if (S_ISDIR(st->st_mode)) {
diff --git a/setfacl/do_set.h b/setfacl/do_set.h
new file mode 100644
index 0000000..2ea25a8
--- /dev/null
+++ b/setfacl/do_set.h
@@ -0,0 +1,36 @@
+/*
+  File: do_set.h
+  (Linux Access Control List Management)
+
+  Copyright (C) 2009 by Andreas Gruenbacher
+  <a.gruenbacher@computer.org>
+
+  This program is free software; you can redistribute it and/or
+  modify it under the terms of the GNU Lesser General Public
+  License as published by the Free Software Foundation; either
+  version 2.1 of the License, or (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  Lesser General Public License for more details.
+
+  You should have received a copy of the GNU Lesser General Public
+  License along with this library; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+*/
+
+#ifndef __DO_SET_H
+#define __DO_SET_H
+
+#include "sequence.h"
+
+struct do_set_args {
+	seq_t seq;
+	mode_t mode;
+};
+
+extern int do_set(const char *path_p, const struct stat *stat_p, int flags,
+		  void *arg);
+
+#endif  /* __DO_SET_H */
diff --git a/setfacl/parse.c b/setfacl/parse.c
index daa32e2..4df1a19 100644
--- a/setfacl/parse.c
+++ b/setfacl/parse.c
@@ -410,7 +410,8 @@ read_acl_comments(
 	int *line,
 	char **path_p,
 	uid_t *uid_p,
-	gid_t *gid_p)
+	gid_t *gid_p,
+	mode_t *flags)
 {
 	int c;
 	/*
@@ -429,6 +430,8 @@ read_acl_comments(
 		*uid_p = ACL_UNDEFINED_ID;
 	if (gid_p)
 		*gid_p = ACL_UNDEFINED_ID;
+	if (flags)
+		*flags = 0;
 
 	for(;;) {
 		c = fgetc(file);
@@ -493,6 +496,29 @@ read_acl_comments(
 				if (get_gid(unquote(cp), gid_p) != 0)
 					continue;
 			}
+		} else if (strncmp(cp, "flags:", 6) == 0) {
+			mode_t f = 0;
+
+			cp += 6;
+			SKIP_WS(cp);
+
+			if (cp[0] == 's')
+				f |= S_ISUID;
+			else if (cp[0] != '-')
+				goto fail;
+			if (cp[1] == 's')
+				f |= S_ISGID;
+			else if (cp[1] != '-')
+				goto fail;
+			if (cp[2] == 't')
+				f |= S_ISVTX;
+			else if (cp[2] != '-')
+				goto fail;
+			if (cp[3] != '\0')
+				goto fail;
+
+			if (flags)
+				*flags = f;
 		}
 	}
 	if (ferror(file))
diff --git a/setfacl/parse.h b/setfacl/parse.h
index b6b7e01..b2e68b4 100644
--- a/setfacl/parse.h
+++ b/setfacl/parse.h
@@ -64,7 +64,8 @@ read_acl_comments(
 	int *line,
 	char **path_p,
 	uid_t *uid_p,
-	gid_t *gid_p);
+	gid_t *gid_p,
+	mode_t *flags);
 int
 read_acl_seq(
 	FILE *file,
diff --git a/setfacl/setfacl.c b/setfacl/setfacl.c
index 7d94350..74c8247 100644
--- a/setfacl/setfacl.c
+++ b/setfacl/setfacl.c
@@ -33,11 +33,10 @@
 #include "config.h"
 #include "sequence.h"
 #include "parse.h"
+#include "do_set.h"
 #include "walk_tree.h"
 #include "misc.h"
 
-extern int do_set(const char *path_p, const struct stat *stat_p, int flags, void *arg);
-
 #define POSIXLY_CORRECT_STR "POSIXLY_CORRECT"
 
 /* '-' stands for `process non-option arguments in loop' */
@@ -125,7 +124,8 @@ restore(
 	struct stat st;
 	uid_t uid;
 	gid_t gid;
-	seq_t seq = NULL;
+	mode_t mask, flags;
+	struct do_set_args args;
 	int line = 0, backup_line;
 	int error, status = 0;
 
@@ -133,7 +133,8 @@ restore(
 
 	for(;;) {
 		backup_line = line;
-		error = read_acl_comments(file, &line, &path_p, &uid, &gid);
+		error = read_acl_comments(file, &line, &path_p, &uid, &gid,
+					  &flags);
 		if (error < 0)
 			goto fail;
 		if (error == 0)
@@ -155,13 +156,13 @@ restore(
 			goto getout;
 		}
 
-		if (!(seq = seq_init()))
+		if (!(args.seq = seq_init()))
 			goto fail;
-		if (seq_append_cmd(seq, CMD_REMOVE_ACL, ACL_TYPE_ACCESS) ||
-		    seq_append_cmd(seq, CMD_REMOVE_ACL, ACL_TYPE_DEFAULT))
+		if (seq_append_cmd(args.seq, CMD_REMOVE_ACL, ACL_TYPE_ACCESS) ||
+		    seq_append_cmd(args.seq, CMD_REMOVE_ACL, ACL_TYPE_DEFAULT))
 			goto fail;
 
-		error = read_acl_seq(file, seq, CMD_ENTRY_REPLACE,
+		error = read_acl_seq(file, args.seq, CMD_ENTRY_REPLACE,
 		                     SEQ_PARSE_WITH_PERM |
 				     SEQ_PARSE_DEFAULT |
 				     SEQ_PARSE_MULTI,
@@ -181,7 +182,8 @@ restore(
 			status = 1;
 		}
 
-		error = do_set(path_p, &st, 0, seq);
+		args.mode = 0;
+		error = do_set(path_p, &st, 0, &args);
 		if (error != 0) {
 			status = 1;
 			goto resume;
@@ -205,14 +207,25 @@ restore(
 				status = 1;
 			}
 		}
+		mask = S_ISUID | S_ISGID | S_ISVTX;
+		if ((st.st_mode & mask) != (flags & mask)) {
+			args.mode &= (S_IRWXU | S_IRWXG | S_IRWXO);
+			if (chmod(path_p, flags | args.mode) != 0) {
+				fprintf(stderr, _("%s: %s: Cannot change "
+					          "mode: %s\n"),
+					progname, xquote(path_p),
+					strerror(errno));
+				status = 1;
+			}
+		}
 resume:
 		if (path_p) {
 			free(path_p);
 			path_p = NULL;
 		}
-		if (seq) {
-			seq_free(seq);
-			seq = NULL;
+		if (args.seq) {
+			seq_free(args.seq);
+			args.seq = NULL;
 		}
 	}
 
@@ -221,9 +234,9 @@ getout:
 		free(path_p);
 		path_p = NULL;
 	}
-	if (seq) {
-		seq_free(seq);
-		seq = NULL;
+	if (args.seq) {
+		seq_free(args.seq);
+		args.seq = NULL;
 	}
 	return status;
 
@@ -280,17 +293,20 @@ int next_file(const char *arg, seq_t seq)
 {
 	char *line;
 	int errors = 0;
+	struct do_set_args args;
+
+	args.seq = seq;
 
 	if (strcmp(arg, "-") == 0) {
 		while ((line = next_line(stdin)))
-			errors = walk_tree(line, walk_flags, 0, do_set, seq);
+			errors = walk_tree(line, walk_flags, 0, do_set, &args);
 		if (!feof(stdin)) {
 			fprintf(stderr, _("%s: Standard input: %s\n"),
 				progname, strerror(errno));
 			errors = 1;
 		}
 	} else {
-		errors = walk_tree(arg, walk_flags, 0, do_set, seq);
+		errors = walk_tree(arg, walk_flags, 0, do_set, &args);
 	}
 	return errors ? 1 : 0;
 }

--Boundary-00=_QWOOKGDS7msUVQp
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Boundary-00=_QWOOKGDS7msUVQp--
