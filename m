Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9T0mVjM175064 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 19:48:31 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CD90FD5357
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 17:48:29 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id C3iEx6WAB3ZCzaDc
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 17:48:29 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so1327068bkb.26
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 17:48:28 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/8] xfstests: fsstress dump inode info when possible
Date: Sat, 29 Oct 2011 04:48:10 +0400
Message-Id: <1319849297-3506-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, hch@lst.de, xfs@oss.sgi.com

Fsstress exec behaviour is not completely determinated in case of
low resources mode due to ENOMEM, ENOSPC, etc. In some places we
call stat(2). This information may be halpfull for future
investigations purposes. Let's dump stat info where possible.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   83 +++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index c37cddf..51ecda2 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1391,6 +1391,14 @@ zero_freq(void)
 		p->freq = 0;
 }
 
+void inode_info(char *str, size_t sz, struct stat64 *s, int verbose)
+{
+	if (verbose)
+		snprintf(str, sz, "[%ld %ld %d %d %lld %lld]", (long)s->st_ino,
+			 (long)s->st_nlink,  s->st_uid, s->st_gid,
+			 (long long) s->st_blocks, (long long) s->st_size);
+}
+
 void
 allocsp_f(int opno, long r)
 {
@@ -1402,6 +1410,7 @@ allocsp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1428,6 +1437,7 @@ allocsp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -1435,9 +1445,10 @@ allocsp_f(int opno, long r)
 	fl.l_start = off;
 	fl.l_len = 0;
 	e = xfsctl(f.path, fd, XFS_IOC_ALLOCSP64, &fl) < 0 ? errno : 0;
-	if (v)
-		printf("%d/%d: xfsctl(XFS_IOC_ALLOCSP64) %s %lld 0 %d\n",
-			procid, opno, f.path, (long long)off, e);
+	if (v) {
+		printf("%d/%d: xfsctl(XFS_IOC_ALLOCSP64) %s%s %lld 0 %d\n",
+		       procid, opno, f.path, st, (long long)off, e);
+	}
 	free_pathname(&f);
 	close(fd);
 }
@@ -1779,6 +1790,7 @@ dread_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1800,15 +1812,16 @@ dread_f(int opno, long r)
 	if (fstat64(fd, &stb) < 0) {
 		if (v)
 			printf("%d/%d: dread - fstat64 %s failed %d\n",
-				procid, opno, f.path, errno);
+			       procid, opno, f.path, errno);
 		free_pathname(&f);
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	if (stb.st_size == 0) {
 		if (v)
-			printf("%d/%d: dread - %s zero size\n", procid, opno,
-				f.path);
+			printf("%d/%d: dread - %s%s zero size\n", procid, opno,
+			       f.path, st);
 		free_pathname(&f);
 		close(fd);
 		return;
@@ -1816,8 +1829,8 @@ dread_f(int opno, long r)
 	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
 		if (v)
 			printf(
-			"%d/%d: dread - xfsctl(XFS_IOC_DIOINFO) %s failed %d\n",
-				procid, opno, f.path, errno);
+			"%d/%d: dread - xfsctl(XFS_IOC_DIOINFO) %s%s failed %d\n",
+				procid, opno, f.path, st, errno);
 		free_pathname(&f);
 		close(fd);
 		return;
@@ -1837,8 +1850,8 @@ dread_f(int opno, long r)
 	e = read(fd, buf, len) < 0 ? errno : 0;
 	free(buf);
 	if (v)
-		printf("%d/%d: dread %s [%lld,%d] %d\n",
-			procid, opno, f.path, (long long)off, (int)len, e);
+		printf("%d/%d: dread %s%s [%lld,%d] %d\n",
+		       procid, opno, f.path, st, (long long)off, (int)len, e);
 	free_pathname(&f);
 	close(fd);
 }
@@ -1857,6 +1870,7 @@ dwrite_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1883,11 +1897,12 @@ dwrite_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
 		if (v)
 			printf("%d/%d: dwrite - xfsctl(XFS_IOC_DIOINFO)"
-				" %s failed %d\n",
-				procid, opno, f.path, errno);
+				" %s%s failed %d\n",
+			       procid, opno, f.path, st, errno);
 		free_pathname(&f);
 		close(fd);
 		return;
@@ -1910,8 +1925,8 @@ dwrite_f(int opno, long r)
 	e = write(fd, buf, len) < 0 ? errno : 0;
 	free(buf);
 	if (v)
-		printf("%d/%d: dwrite %s [%lld,%d] %d\n",
-			procid, opno, f.path, (long long)off, (int)len, e);
+		printf("%d/%d: dwrite %s%s [%lld,%d] %d\n",
+		       procid, opno, f.path, st, (long long)off, (int)len, e);
 	free_pathname(&f);
 	close(fd);
 }
@@ -1960,6 +1975,7 @@ freesp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1986,6 +2002,7 @@ freesp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -1994,8 +2011,8 @@ freesp_f(int opno, long r)
 	fl.l_len = 0;
 	e = xfsctl(f.path, fd, XFS_IOC_FREESP64, &fl) < 0 ? errno : 0;
 	if (v)
-		printf("%d/%d: xfsctl(XFS_IOC_FREESP64) %s %lld 0 %d\n",
-			procid, opno, f.path, (long long)off, e);
+		printf("%d/%d: xfsctl(XFS_IOC_FREESP64) %s%s %lld 0 %d\n",
+		       procid, opno, f.path, st, (long long)off, e);
 	free_pathname(&f);
 	close(fd);
 }
@@ -2198,6 +2215,7 @@ read_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2224,10 +2242,11 @@ read_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	if (stb.st_size == 0) {
 		if (v)
-			printf("%d/%d: read - %s zero size\n", procid, opno,
-				f.path);
+			printf("%d/%d: read - %s%s zero size\n", procid, opno,
+			       f.path, st);
 		free_pathname(&f);
 		close(fd);
 		return;
@@ -2240,8 +2259,8 @@ read_f(int opno, long r)
 	e = read(fd, buf, len) < 0 ? errno : 0;
 	free(buf);
 	if (v)
-		printf("%d/%d: read %s [%lld,%d] %d\n",
-			procid, opno, f.path, (long long)off, (int)len, e);
+		printf("%d/%d: read %s%s [%lld,%d] %d\n",
+		       procid, opno, f.path, st, (long long)off, (int)len, e);
 	free_pathname(&f);
 	close(fd);
 }
@@ -2348,6 +2367,7 @@ resvsp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2374,6 +2394,7 @@ resvsp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2382,8 +2403,8 @@ resvsp_f(int opno, long r)
 	fl.l_len = (off64_t)(random() % (1024 * 1024));
 	e = xfsctl(f.path, fd, XFS_IOC_RESVSP64, &fl) < 0 ? errno : 0;
 	if (v)
-		printf("%d/%d: xfsctl(XFS_IOC_RESVSP64) %s %lld %lld %d\n",
-			procid, opno, f.path,
+		printf("%d/%d: xfsctl(XFS_IOC_RESVSP64) %s%s %lld %lld %d\n",
+		       procid, opno, f.path, st,
 			(long long)off, (long long)fl.l_len, e);
 	free_pathname(&f);
 	close(fd);
@@ -2506,6 +2527,7 @@ truncate_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2523,14 +2545,15 @@ truncate_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
 	e = truncate64_path(&f, off) < 0 ? errno : 0;
 	check_cwd();
 	if (v)
-		printf("%d/%d: truncate %s %lld %d\n", procid, opno, f.path,
-			(long long)off, e);
+		printf("%d/%d: truncate %s%s %lld %d\n", procid, opno, f.path,
+		       st, (long long)off, e);
 	free_pathname(&f);
 }
 
@@ -2574,6 +2597,7 @@ unresvsp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2600,6 +2624,7 @@ unresvsp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2608,8 +2633,8 @@ unresvsp_f(int opno, long r)
 	fl.l_len = (off64_t)(random() % (1 << 20));
 	e = xfsctl(f.path, fd, XFS_IOC_UNRESVSP64, &fl) < 0 ? errno : 0;
 	if (v)
-		printf("%d/%d: xfsctl(XFS_IOC_UNRESVSP64) %s %lld %lld %d\n",
-			procid, opno, f.path,
+		printf("%d/%d: xfsctl(XFS_IOC_UNRESVSP64) %s%s %lld %lld %d\n",
+		       procid, opno, f.path, st,
 			(long long)off, (long long)fl.l_len, e);
 	free_pathname(&f);
 	close(fd);
@@ -2627,6 +2652,7 @@ write_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGm, r, &f, NULL, NULL, &v)) {
@@ -2653,6 +2679,7 @@ write_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2663,8 +2690,8 @@ write_f(int opno, long r)
 	e = write(fd, buf, len) < 0 ? errno : 0;
 	free(buf);
 	if (v)
-		printf("%d/%d: write %s [%lld,%d] %d\n",
-			procid, opno, f.path, (long long)off, (int)len, e);
+		printf("%d/%d: write %s%s [%lld,%d] %d\n",
+		       procid, opno, f.path, st, (long long)off, (int)len, e);
 	free_pathname(&f);
 	close(fd);
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
