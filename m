Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 167D17F76
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:15:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90D77AC002
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9UXrZcoiGfNGpF0C for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:41 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/6] xfstests: Add fallocate zero range operation to fsstress
Date: Tue, 25 Feb 2014 20:15:24 +0100
Message-Id: <1393355728-12056-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index c56f168..4c3368f 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -33,6 +33,9 @@
 /* Copy-paste from linux/falloc.h */
 #define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
 #endif
+#ifndef FALLOC_FL_ZERO_RANGE
+#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
+#endif
 #endif
 #ifndef HAVE_ATTR_LIST
 #define attr_list(path, buf, size, flags, cursor) (errno = -ENOSYS, -1)
@@ -77,6 +80,7 @@ typedef enum {
 	OP_MKDIR,
 	OP_MKNOD,
 	OP_PUNCH,
+	OP_ZERO,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -162,6 +166,7 @@ void	link_f(int, long);
 void	mkdir_f(int, long);
 void	mknod_f(int, long);
 void	punch_f(int, long);
+void	zero_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -199,6 +204,7 @@ opdesc_t	ops[] = {
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
+	{ OP_ZERO, "zero", zero_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -2561,6 +2567,62 @@ punch_f(int opno, long r)
 }
 
 void
+zero_f(int opno, long r)
+{
+#ifdef FALLOCATE
+	int		e;
+	pathname_t	f;
+	int		fd;
+	__int64_t	lr;
+	off64_t		off;
+	off64_t		len;
+	struct stat64	stb;
+	int		v;
+	char		st[1024];
+	int mode = FALLOC_FL_ZERO_RANGE;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+		if (v)
+			printf("%d/%d: zero range - no filename\n", procid, opno);
+		free_pathname(&f);
+		return;
+	}
+	fd = open_path(&f, O_RDWR);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+	if (fd < 0) {
+		if (v)
+			printf("%d/%d: zero range - open %s failed %d\n",
+				procid, opno, f.path, e);
+		free_pathname(&f);
+		return;
+	}
+	if (fstat64(fd, &stb) < 0) {
+		if (v)
+			printf("%d/%d: zero range - fstat64 %s failed %d\n",
+				procid, opno, f.path, errno);
+		free_pathname(&f);
+		close(fd);
+		return;
+	}
+	inode_info(st, sizeof(st), &stb, v);
+	lr = ((__int64_t)random() << 32) + random();
+	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
+	off %= maxfsize;
+	len = (off64_t)(random() % (1024 * 1024));
+	mode |= FALLOC_FL_KEEP_SIZE & random();
+	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
+	if (v)
+		printf("%d/%d: zero range(%d) %s %s %lld %lld %d\n",
+		       procid, opno, mode,
+		       f.path, st, (long long)off, (long long)len, e);
+	free_pathname(&f);
+	close(fd);
+#endif
+}
+
+void
 read_f(int opno, long r)
 {
 	char		*buf;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
