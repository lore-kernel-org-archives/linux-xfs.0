Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395487AbeKWEjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:39:11 -0500
Subject: [PATCH 02/12] fsstress: check system call return values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Nov 2018 09:58:40 -0800
Message-ID: <154290952081.1218.5326269464784776136.stgit@magnolia>
In-Reply-To: <154290950237.1218.9937108728673485814.stgit@magnolia>
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the return values of various system calls and blow up if something
went wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsstress.c |   56 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 8d0734fc..af5d125f 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -733,7 +733,7 @@ append_pathname(pathname_t *name, char *str)
 	/* attempting to append to a dir a zero length path */
 	if (len && *str == '/' && name->len == 0) {
 		fprintf(stderr, "fsstress: append_pathname failure\n");
-		chdir(homedir);
+		assert(chdir(homedir) == 0);
 		abort();
 		/* NOTREACHED */
 	}
@@ -765,7 +765,7 @@ attr_list_path(pathname_t *name,
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = attr_list_path(&newname, buffer, buffersize, flags, cursor);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -784,7 +784,7 @@ attr_remove_path(pathname_t *name, const char *attrname, int flags)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = attr_remove_path(&newname, attrname, flags);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -805,7 +805,7 @@ attr_set_path(pathname_t *name, const char *attrname, const char *attrvalue,
 	if (chdir(buf) == 0) {
 		rval = attr_set_path(&newname, attrname, attrvalue, valuelength,
 			flags);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -819,7 +819,7 @@ check_cwd(void)
 
 	if (stat64(".", &statbuf) == 0 && statbuf.st_ino == top_ino)
 		return;
-	chdir(homedir);
+	assert(chdir(homedir) == 0);
 	fprintf(stderr, "fsstress: check_cwd failure\n");
 	abort();
 	/* NOTREACHED */
@@ -858,7 +858,7 @@ creat_path(pathname_t *name, mode_t mode)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = creat_path(&newname, mode);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -996,11 +996,15 @@ doproc(void)
 		}
 	}
 errout:
-	chdir("..");
+	assert(chdir("..") == 0);
 	free(homedir);
 	if (cleanup) {
+		int ret;
+
 		sprintf(cmd, "rm -rf %s", buf);
-		system(cmd);
+		ret = system(cmd);
+		if (ret != 0)
+			perror("cleaning up");
 		cleanup_flist();
 	}
 }
@@ -1216,7 +1220,7 @@ lchown_path(pathname_t *name, uid_t owner, gid_t group)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = lchown_path(&newname, owner, group);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1240,7 +1244,7 @@ link_path(pathname_t *name1, pathname_t *name2)
 	if (strcmp(buf1, buf2) == 0) {
 		if (chdir(buf1) == 0) {
 			rval = link_path(&newname1, &newname2);
-			chdir("..");
+			assert(chdir("..") == 0);
 		}
 	} else {
 		if (strcmp(buf1, "..") == 0)
@@ -1260,7 +1264,7 @@ link_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
 				rval = link_path(&newname1, &newname2);
-				chdir("..");
+				assert(chdir("..") == 0);
 			}
 		} else {
 			free_pathname(&newname1);
@@ -1268,7 +1272,7 @@ link_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
 				rval = link_path(&newname1, &newname2);
-				chdir("..");
+				assert(chdir("..") == 0);
 			}
 		}
 	}
@@ -1290,7 +1294,7 @@ lstat64_path(pathname_t *name, struct stat64 *sbuf)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = lstat64_path(&newname, sbuf);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1326,7 +1330,7 @@ mkdir_path(pathname_t *name, mode_t mode)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = mkdir_path(&newname, mode);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1345,7 +1349,7 @@ mknod_path(pathname_t *name, mode_t mode, dev_t dev)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = mknod_path(&newname, mode, dev);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1386,7 +1390,7 @@ open_path(pathname_t *name, int oflag)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = open_path(&newname, oflag);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1405,7 +1409,7 @@ opendir_path(pathname_t *name)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = opendir_path(&newname);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1446,7 +1450,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = readlink_path(&newname, lbuf, lbufsiz);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1470,7 +1474,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 	if (strcmp(buf1, buf2) == 0) {
 		if (chdir(buf1) == 0) {
 			rval = rename_path(&newname1, &newname2);
-			chdir("..");
+			assert(chdir("..") == 0);
 		}
 	} else {
 		if (strcmp(buf1, "..") == 0)
@@ -1490,7 +1494,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
 				rval = rename_path(&newname1, &newname2);
-				chdir("..");
+				assert(chdir("..") == 0);
 			}
 		} else {
 			free_pathname(&newname1);
@@ -1498,7 +1502,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
 				rval = rename_path(&newname1, &newname2);
-				chdir("..");
+				assert(chdir("..") == 0);
 			}
 		}
 	}
@@ -1520,7 +1524,7 @@ rmdir_path(pathname_t *name)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = rmdir_path(&newname);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1603,7 +1607,7 @@ stat64_path(pathname_t *name, struct stat64 *sbuf)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = stat64_path(&newname, sbuf);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1627,7 +1631,7 @@ symlink_path(const char *name1, pathname_t *name)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = symlink_path(name1, &newname);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1646,7 +1650,7 @@ truncate64_path(pathname_t *name, off64_t length)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = truncate64_path(&newname, length);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
@@ -1665,7 +1669,7 @@ unlink_path(pathname_t *name)
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
 		rval = unlink_path(&newname);
-		chdir("..");
+		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
 	return rval;
