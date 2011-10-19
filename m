Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JAU5rK178137 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 05:30:05 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 199D51D98CF
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:30:02 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id qvC7DDKgHsP9SrNX
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:30:02 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id 11so2102080bke.26
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:30:02 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/8] xfstests: Dump inode info when possible
Date: Wed, 19 Oct 2011 14:29:46 +0400
Message-Id: <1319020189-13584-6-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org, aelder@sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>

Fsstress exec behaviour is not completely determinated in case of
low resources mode due to ENOMEM, ENOSPC, etc. In some places we
call stat(2). This information may be halpfull for future
investigations purposes. Let's dump stat info where possible.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   92 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 756bdd6..baccbbd 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1482,6 +1482,14 @@ zero_freq(void)
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
@@ -1493,6 +1501,7 @@ allocsp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1519,6 +1528,8 @@ allocsp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -1526,9 +1537,10 @@ allocsp_f(int opno, long r)
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
@@ -1918,6 +1930,7 @@ dread_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1939,15 +1952,17 @@ dread_f(int opno, long r)
 	if (fstat64(fd, &stb) < 0) {
 		if (v)
 			printf("%d/%d: dread - fstat64 %s failed %d\n",
-				procid, opno, f.path, errno);
+			       procid, opno, f.path, errno);
 		free_pathname(&f);
 		close(fd);
 		return;
 	}
+
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
@@ -1955,8 +1970,8 @@ dread_f(int opno, long r)
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
@@ -1976,8 +1991,8 @@ dread_f(int opno, long r)
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
@@ -1996,6 +2011,7 @@ dwrite_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2022,11 +2038,12 @@ dwrite_f(int opno, long r)
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
@@ -2049,8 +2066,8 @@ dwrite_f(int opno, long r)
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
@@ -2067,6 +2084,7 @@ fallocate_f(int opno, long r)
 	off64_t		len;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 	int mode = 0;
 
 	init_pathname(&f);
@@ -2094,6 +2112,8 @@ fallocate_f(int opno, long r)
 		close(fd);
 		return;
 	}
+
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2101,9 +2121,9 @@ fallocate_f(int opno, long r)
 	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
 	if (v)
-		printf("%d/%d: fallocate(%d) %s %lld %lld %d\n",
+		printf("%d/%d: fallocate(%d) %s %st %lld %lld %d\n",
 		       procid, opno, mode,
-		       f.path, (long long)off, (long long)len, e);
+		       f.path, st, (long long)off, (long long)len, e);
 	free_pathname(&f);
 	close(fd);
 #endif
@@ -2154,6 +2174,7 @@ freesp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2180,6 +2201,7 @@ freesp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2188,8 +2210,8 @@ freesp_f(int opno, long r)
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
@@ -2392,6 +2414,7 @@ punch_f(int opno, long r)
 	off64_t		len;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 	int mode = FALLOC_FL_PUNCH_HOLE;
 
 	init_pathname(&f);
@@ -2419,6 +2442,7 @@ punch_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2426,9 +2450,9 @@ punch_f(int opno, long r)
 	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
 	if (v)
-		printf("%d/%d: punch hole(%d) %s %lld %lld %d\n",
+		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
 		       procid, opno, mode,
-		       f.path, (long long)off, (long long)len, e);
+		       f.path, st, (long long)off, (long long)len, e);
 	free_pathname(&f);
 	close(fd);
 #endif
@@ -2446,6 +2470,7 @@ read_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2472,10 +2497,11 @@ read_f(int opno, long r)
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
@@ -2488,8 +2514,8 @@ read_f(int opno, long r)
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
@@ -2596,6 +2622,7 @@ resvsp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2622,6 +2649,7 @@ resvsp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2630,8 +2658,8 @@ resvsp_f(int opno, long r)
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
@@ -2822,6 +2850,7 @@ unresvsp_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2848,6 +2877,7 @@ unresvsp_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2856,8 +2886,8 @@ unresvsp_f(int opno, long r)
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
@@ -2875,6 +2905,7 @@ write_f(int opno, long r)
 	off64_t		off;
 	struct stat64	stb;
 	int		v;
+	char		st[1024];
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGm, r, &f, NULL, NULL, &v)) {
@@ -2901,6 +2932,7 @@ write_f(int opno, long r)
 		close(fd);
 		return;
 	}
+	inode_info(st, sizeof(st), &stb, v);
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
@@ -2911,8 +2943,8 @@ write_f(int opno, long r)
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
