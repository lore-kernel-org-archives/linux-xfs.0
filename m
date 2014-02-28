Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8620A7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 10:11:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB393AC008
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6LoZrEagSNKqWkJ2 for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:17 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/8] xfstests: Add fallocate zero range operation to fsstress
Date: Fri, 28 Feb 2014 17:11:02 +0100
Message-Id: <1393603865-26198-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

This commit adds fzero operation support for fsstress, which is meant to
exercise fallocate FALLOC_FL_ZERO_RANGE support.

Also reorganise the common fallocate code into a single do_fallocate()
function and use flags use the right mode.

Also in order to make more obvious which fallocate mode fsstress is
testing translate fallocate flags into human readable strings.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 164 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 106 insertions(+), 58 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 7dec7c6..24864db 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -70,6 +70,7 @@ typedef enum {
 	OP_MKDIR,
 	OP_MKNOD,
 	OP_PUNCH,
+	OP_ZERO,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -114,6 +115,17 @@ typedef struct pathname {
 	char	*path;
 } pathname_t;
 
+struct print_flags {
+	unsigned long mask;
+	const char *name;
+};
+
+struct print_string {
+	char *buffer;
+	int len;
+	int max;
+};
+
 #define	FT_DIR	0
 #define	FT_DIRm	(1 << FT_DIR)
 #define	FT_REG	1
@@ -155,6 +167,7 @@ void	link_f(int, long);
 void	mkdir_f(int, long);
 void	mknod_f(int, long);
 void	punch_f(int, long);
+void	zero_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -192,6 +205,7 @@ opdesc_t	ops[] = {
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
+	{ OP_ZERO, "zero", zero_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -242,6 +256,7 @@ int		verbose = 0;
 sig_atomic_t	should_stop = 0;
 char		*execute_cmd = NULL;
 int		execute_freq = 1;
+struct print_string	flag_str = {0};
 
 void	add_to_flist(int, int, int);
 void	append_pathname(pathname_t *, char *);
@@ -543,6 +558,59 @@ int main(int argc, char **argv)
 	return 0;
 }
 
+int
+add_string(struct print_string *str, const char *add)
+{
+	int len = strlen(add);
+
+	if (len <= 0)
+		return 0;
+
+	if (len > (str->max - 1) - str->len) {
+		str->len = str->max - 1;
+		return 0;
+	}
+
+	memcpy(str->buffer + str->len, add, len);
+	str->len += len;
+	str->buffer[str->len] = '\0';
+
+	return len;
+}
+
+char *
+translate_flags(int flags, const char *delim,
+		const struct print_flags *flag_array)
+{
+	int i, mask, first = 1;
+	const char *add;
+
+	if (!flag_str.buffer) {
+		flag_str.buffer = malloc(4096);
+		flag_str.max = 4096;
+		flag_str.len = 0;
+	}
+	if (!flag_str.buffer)
+		return NULL;
+	flag_str.len = 0;
+	flag_str.buffer[0] = '\0';
+
+	for (i = 0;  flag_array[i].name && flags; i++) {
+		mask = flag_array[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		add = flag_array[i].name;
+		flags &= ~mask;
+		if (!first && delim)
+			add_string(&flag_str, delim);
+		else
+			first = 0;
+		add_string(&flag_str, add);
+	}
+	return flag_str.buffer;
+}
+
 void
 add_to_flist(int ft, int id, int parent)
 {
@@ -2075,8 +2143,23 @@ dwrite_f(int opno, long r)
 	close(fd);
 }
 
+
+#ifdef HAVE_LINUX_FALLOC_H
+struct print_flags falloc_flags [] = {
+	{ FALLOC_FL_KEEP_SIZE, "KEEP_SIZE"},
+	{ FALLOC_FL_PUNCH_HOLE, "PUNCH_HOLE"},
+	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
+	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
+	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
+	{ -1, NULL}
+};
+
+#define translate_falloc_flags(mode)	\
+	({translate_flags(mode, "|", falloc_flags);})
+#endif
+
 void
-fallocate_f(int opno, long r)
+do_fallocate(int opno, long r, int mode)
 {
 #ifdef HAVE_LINUX_FALLOC_H
 	int		e;
@@ -2088,28 +2171,26 @@ fallocate_f(int opno, long r)
 	struct stat64	stb;
 	int		v;
 	char		st[1024];
-	int mode = 0;
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
 		if (v)
-			printf("%d/%d: fallocate - no filename\n", procid, opno);
+			printf("%d/%d: do_fallocate - no filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
 	fd = open_path(&f, O_RDWR);
-	e = fd < 0 ? errno : 0;
-	check_cwd();
 	if (fd < 0) {
 		if (v)
-			printf("%d/%d: fallocate - open %s failed %d\n",
-				procid, opno, f.path, e);
+			printf("%d/%d: do_fallocate - open %s failed %d\n",
+				procid, opno, f.path, errno);
 		free_pathname(&f);
 		return;
 	}
+	check_cwd();
 	if (fstat64(fd, &stb) < 0) {
 		if (v)
-			printf("%d/%d: fallocate - fstat64 %s failed %d\n",
+			printf("%d/%d: do_fallocate - fstat64 %s failed %d\n",
 				procid, opno, f.path, errno);
 		free_pathname(&f);
 		close(fd);
@@ -2123,14 +2204,21 @@ fallocate_f(int opno, long r)
 	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
 	if (v)
-		printf("%d/%d: fallocate(%d) %s %st %lld %lld %d\n",
-		       procid, opno, mode,
+		printf("%d/%d: fallocate(%s) %s %st %lld %lld %d\n",
+		       procid, opno, translate_falloc_flags(mode),
 		       f.path, st, (long long)off, (long long)len, e);
 	free_pathname(&f);
 	close(fd);
 #endif
 }
 
+void
+fallocate_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, 0);
+#endif
+}
 
 void
 fdatasync_f(int opno, long r)
@@ -2501,55 +2589,15 @@ void
 punch_f(int opno, long r)
 {
 #ifdef HAVE_LINUX_FALLOC_H
-	int		e;
-	pathname_t	f;
-	int		fd;
-	__int64_t	lr;
-	off64_t		off;
-	off64_t		len;
-	struct stat64	stb;
-	int		v;
-	char		st[1024];
-	int mode = FALLOC_FL_PUNCH_HOLE;
+	do_fallocate(opno, r, FALLOC_FL_PUNCH_HOLE);
+#endif
+}
 
-	init_pathname(&f);
-	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
-		if (v)
-			printf("%d/%d: punch hole - no filename\n", procid, opno);
-		free_pathname(&f);
-		return;
-	}
-	fd = open_path(&f, O_RDWR);
-	e = fd < 0 ? errno : 0;
-	check_cwd();
-	if (fd < 0) {
-		if (v)
-			printf("%d/%d: punch hole - open %s failed %d\n",
-				procid, opno, f.path, e);
-		free_pathname(&f);
-		return;
-	}
-	if (fstat64(fd, &stb) < 0) {
-		if (v)
-			printf("%d/%d: punch hole - fstat64 %s failed %d\n",
-				procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
-	}
-	inode_info(st, sizeof(st), &stb, v);
-	lr = ((__int64_t)random() << 32) + random();
-	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
-	off %= maxfsize;
-	len = (off64_t)(random() % (1024 * 1024));
-	mode |= FALLOC_FL_KEEP_SIZE & random();
-	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
-	if (v)
-		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
-		       procid, opno, mode,
-		       f.path, st, (long long)off, (long long)len, e);
-	free_pathname(&f);
-	close(fd);
+void
+zero_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, FALLOC_FL_ZERO_RANGE);
 #endif
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
