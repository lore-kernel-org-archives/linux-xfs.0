Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57155 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754594AbdLOCHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 21:07:36 -0500
Date: Thu, 14 Dec 2017 18:07:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 6/8] fsstress: implement the clonerange/deduperange ioctls
Message-ID: <20171215020731.GM6896@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314503583.18893.15475795025536691678.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Mix it up a bit by reflinking and deduping data blocks when possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: don't disable broken commands, just ignore them
---
 ltp/fsstress.c |  391 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 391 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 96f48b1..b02cb0c 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -68,7 +68,9 @@ typedef enum {
 	OP_BULKSTAT,
 	OP_BULKSTAT1,
 	OP_CHOWN,
+	OP_CLONERANGE,
 	OP_CREAT,
+	OP_DEDUPERANGE,
 	OP_DREAD,
 	OP_DWRITE,
 	OP_FALLOCATE,
@@ -174,7 +176,9 @@ void	awrite_f(int, long);
 void	bulkstat_f(int, long);
 void	bulkstat1_f(int, long);
 void	chown_f(int, long);
+void	clonerange_f(int, long);
 void	creat_f(int, long);
+void	deduperange_f(int, long);
 void	dread_f(int, long);
 void	dwrite_f(int, long);
 void	fallocate_f(int, long);
@@ -221,7 +225,9 @@ opdesc_t	ops[] = {
 	{ OP_BULKSTAT, "bulkstat", bulkstat_f, 1, 0 },
 	{ OP_BULKSTAT1, "bulkstat1", bulkstat1_f, 1, 0 },
 	{ OP_CHOWN, "chown", chown_f, 3, 1 },
+	{ OP_CLONERANGE, "clonerange", clonerange_f, 4, 1 },
 	{ OP_CREAT, "creat", creat_f, 4, 1 },
+	{ OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
 	{ OP_DREAD, "dread", dread_f, 4, 0 },
 	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
 	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
@@ -2189,6 +2195,391 @@ chown_f(int opno, long r)
 	free_pathname(&f);
 }
 
+/* reflink some arbitrary range of f1 to f2. */
+void
+clonerange_f(
+	int			opno,
+	long			r)
+{
+#ifdef FICLONERANGE
+	struct file_clone_range	fcr;
+	struct pathname		fpath1;
+	struct pathname		fpath2;
+	struct stat64		stat1;
+	struct stat64		stat2;
+	char			inoinfo1[1024];
+	char			inoinfo2[1024];
+	off64_t			lr;
+	off64_t			off1;
+	off64_t			off2;
+	size_t			len;
+	int			v1;
+	int			v2;
+	int			fd1;
+	int			fd2;
+	int			ret;
+	int			e;
+
+	/* Load paths */
+	init_pathname(&fpath1);
+	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
+		if (v1)
+			printf("%d/%d: clonerange read - no filename\n",
+				procid, opno);
+		goto out_fpath1;
+	}
+
+	init_pathname(&fpath2);
+	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
+		if (v2)
+			printf("%d/%d: clonerange write - no filename\n",
+				procid, opno);
+		goto out_fpath2;
+	}
+
+	/* Open files */
+	fd1 = open_path(&fpath1, O_RDONLY);
+	e = fd1 < 0 ? errno : 0;
+	check_cwd();
+	if (fd1 < 0) {
+		if (v1)
+			printf("%d/%d: clonerange read - open %s failed %d\n",
+				procid, opno, fpath1.path, e);
+		goto out_fpath2;
+	}
+
+	fd2 = open_path(&fpath2, O_WRONLY);
+	e = fd2 < 0 ? errno : 0;
+	check_cwd();
+	if (fd2 < 0) {
+		if (v2)
+			printf("%d/%d: clonerange write - open %s failed %d\n",
+				procid, opno, fpath2.path, e);
+		goto out_fd1;
+	}
+
+	/* Get file stats */
+	if (fstat64(fd1, &stat1) < 0) {
+		if (v1)
+			printf("%d/%d: clonerange read - fstat64 %s failed %d\n",
+				procid, opno, fpath1.path, errno);
+		goto out_fd2;
+	}
+	inode_info(inoinfo1, sizeof(inoinfo1), &stat1, v1);
+
+	if (fstat64(fd2, &stat2) < 0) {
+		if (v2)
+			printf("%d/%d: clonerange write - fstat64 %s failed %d\n",
+				procid, opno, fpath2.path, errno);
+		goto out_fd2;
+	}
+	inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v1);
+
+	/* Calculate offsets */
+	len = (random() % FILELEN_MAX) + 1;
+	len &= ~(stat1.st_blksize - 1);
+	if (len == 0)
+		len = stat1.st_blksize;
+	if (len > stat1.st_size)
+		len = stat1.st_size;
+
+	lr = ((__int64_t)random() << 32) + random();
+	if (stat1.st_size == len)
+		off1 = 0;
+	else
+		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
+	off1 %= maxfsize;
+	off1 &= ~(stat1.st_blksize - 1);
+
+	/*
+	 * If srcfile == destfile, randomly generate destination ranges
+	 * until we find one that doesn't overlap the source range.
+	 */
+	do {
+		lr = ((__int64_t)random() << 32) + random();
+		off2 = (off64_t)(lr % MIN(stat2.st_size + (1024 * 1024), MAXFSIZE));
+		off2 %= maxfsize;
+		off2 &= ~(stat2.st_blksize - 1);
+	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
+
+	/* Clone data blocks */
+	fcr.src_fd = fd1;
+	fcr.src_offset = off1;
+	fcr.src_length = len;
+	fcr.dest_offset = off2;
+
+	ret = ioctl(fd2, FICLONERANGE, &fcr);
+	e = ret < 0 ? errno : 0;
+	if (v1 || v2) {
+		printf("%d/%d: clonerange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
+			procid, opno,
+			fpath1.path, inoinfo1, (long long)off1, (long long)len,
+			fpath2.path, inoinfo2, (long long)off2, (long long)len);
+
+		if (ret < 0)
+			printf(" error %d", e);
+		printf("\n");
+	}
+
+out_fd2:
+	close(fd2);
+out_fd1:
+	close(fd1);
+out_fpath2:
+	free_pathname(&fpath2);
+out_fpath1:
+	free_pathname(&fpath1);
+#endif
+}
+
+/* dedupe some arbitrary range of f1 to f2...fn. */
+void
+deduperange_f(
+	int			opno,
+	long			r)
+{
+#ifdef FIDEDUPERANGE
+#define INFO_SZ			1024
+	struct file_dedupe_range *fdr;
+	struct pathname		*fpath;
+	struct stat64		*stat;
+	char			*info;
+	off64_t			*off;
+	int			*v;
+	int			*fd;
+	int			nr;
+	off64_t			lr;
+	size_t			len;
+	int			ret;
+	int			i;
+	int			e;
+
+	if (flist[FT_REG].nfiles < 2)
+		return;
+
+	/* Pick somewhere between 2 and 128 files. */
+	do {
+		nr = random() % (flist[FT_REG].nfiles + 1);
+	} while (nr < 2 || nr > 128);
+
+	/* Alloc memory */
+	fdr = malloc(nr * sizeof(struct file_dedupe_range_info) +
+		     sizeof(struct file_dedupe_range));
+	if (!fdr) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		return;
+	}
+	memset(fdr, 0, (nr * sizeof(struct file_dedupe_range_info) +
+			sizeof(struct file_dedupe_range)));
+
+	fpath = calloc(nr, sizeof(struct pathname));
+	if (!fpath) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		goto out_fdr;
+	}
+
+	stat = calloc(nr, sizeof(struct stat64));
+	if (!stat) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		goto out_paths;
+	}
+
+	info = calloc(nr, INFO_SZ);
+	if (!info) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		goto out_stats;
+	}
+
+	off = calloc(nr, sizeof(off64_t));
+	if (!off) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		goto out_info;
+	}
+
+	v = calloc(nr, sizeof(int));
+	if (!v) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		goto out_offsets;
+	}
+	fd = calloc(nr, sizeof(int));
+	if (!fd) {
+		printf("%d/%d: line %d error %d\n",
+			procid, opno, __LINE__, errno);
+		goto out_v;
+	}
+	memset(fd, 0xFF, nr * sizeof(int));
+
+	/* Get paths for all files */
+	for (i = 0; i < nr; i++)
+		init_pathname(&fpath[i]);
+
+	if (!get_fname(FT_REGm, r, &fpath[0], NULL, NULL, &v[0])) {
+		if (v[0])
+			printf("%d/%d: deduperange read - no filename\n",
+				procid, opno);
+		goto out_pathnames;
+	}
+
+	for (i = 1; i < nr; i++) {
+		if (!get_fname(FT_REGm, random(), &fpath[i], NULL, NULL, &v[i])) {
+			if (v[i])
+				printf("%d/%d: deduperange write - no filename\n",
+					procid, opno);
+			goto out_pathnames;
+		}
+	}
+
+	/* Open files */
+	fd[0] = open_path(&fpath[0], O_RDONLY);
+	e = fd[0] < 0 ? errno : 0;
+	check_cwd();
+	if (fd[0] < 0) {
+		if (v[0])
+			printf("%d/%d: deduperange read - open %s failed %d\n",
+				procid, opno, fpath[0].path, e);
+		goto out_pathnames;
+	}
+
+	for (i = 1; i < nr; i++) {
+		fd[i] = open_path(&fpath[i], O_WRONLY);
+		e = fd[i] < 0 ? errno : 0;
+		check_cwd();
+		if (fd[i] < 0) {
+			if (v[i])
+				printf("%d/%d: deduperange write - open %s failed %d\n",
+					procid, opno, fpath[i].path, e);
+			goto out_fds;
+		}
+	}
+
+	/* Get file stats */
+	if (fstat64(fd[0], &stat[0]) < 0) {
+		if (v[0])
+			printf("%d/%d: deduperange read - fstat64 %s failed %d\n",
+				procid, opno, fpath[0].path, errno);
+		goto out_fds;
+	}
+
+	inode_info(&info[0], INFO_SZ, &stat[0], v[0]);
+
+	for (i = 1; i < nr; i++) {
+		if (fstat64(fd[i], &stat[i]) < 0) {
+			if (v[i])
+				printf("%d/%d: deduperange write - fstat64 %s failed %d\n",
+					procid, opno, fpath[i].path, errno);
+			goto out_fds;
+		}
+		inode_info(&info[i * INFO_SZ], INFO_SZ, &stat[i], v[i]);
+	}
+
+	/* Never try to dedupe more than half of the src file. */
+	len = (random() % FILELEN_MAX) + 1;
+	len &= ~(stat[0].st_blksize - 1);
+	if (len == 0)
+		len = stat[0].st_blksize / 2;
+	if (len > stat[0].st_size / 2)
+		len = stat[0].st_size / 2;
+
+	/* Calculate offsets */
+	lr = ((__int64_t)random() << 32) + random();
+	if (stat[0].st_size == len)
+		off[0] = 0;
+	else
+		off[0] = (off64_t)(lr % MIN(stat[0].st_size - len, MAXFSIZE));
+	off[0] %= maxfsize;
+	off[0] &= ~(stat[0].st_blksize - 1);
+
+	/*
+	 * If srcfile == destfile[i], randomly generate destination ranges
+	 * until we find one that doesn't overlap the source range.
+	 */
+	for (i = 1; i < nr; i++) {
+		int	tries = 0;
+
+		do {
+			lr = ((__int64_t)random() << 32) + random();
+			if (stat[i].st_size <= len)
+				off[i] = 0;
+			else
+				off[i] = (off64_t)(lr % MIN(stat[i].st_size - len, MAXFSIZE));
+			off[i] %= maxfsize;
+			off[i] &= ~(stat[i].st_blksize - 1);
+		} while (stat[0].st_ino == stat[i].st_ino &&
+			 llabs(off[i] - off[0]) < len &&
+			 tries++ < 10);
+	}
+
+	/* Clone data blocks */
+	fdr->src_offset = off[0];
+	fdr->src_length = len;
+	fdr->dest_count = nr - 1;
+	for (i = 1; i < nr; i++) {
+		fdr->info[i - 1].dest_fd = fd[i];
+		fdr->info[i - 1].dest_offset = off[i];
+	}
+
+	ret = ioctl(fd[0], FIDEDUPERANGE, fdr);
+	e = ret < 0 ? errno : 0;
+	if (v[0]) {
+		printf("%d/%d: deduperange from %s%s [%lld,%lld]",
+			procid, opno,
+			fpath[0].path, &info[0], (long long)off[0],
+			(long long)len);
+		if (ret < 0)
+			printf(" error %d", e);
+		printf("\n");
+	}
+	if (ret < 0)
+		goto out_fds;
+
+	for (i = 1; i < nr; i++) {
+		e = fdr->info[i - 1].status < 0 ? fdr->info[i - 1].status : 0;
+		if (v[i]) {
+			printf("%d/%d: ...to %s%s [%lld,%lld]",
+				procid, opno,
+				fpath[i].path, &info[i * INFO_SZ],
+				(long long)off[i], (long long)len);
+			if (fdr->info[i - 1].status < 0)
+				printf(" error %d", e);
+			if (fdr->info[i - 1].status == FILE_DEDUPE_RANGE_SAME)
+				printf(" %llu bytes deduplicated",
+					fdr->info[i - 1].bytes_deduped);
+			if (fdr->info[i - 1].status == FILE_DEDUPE_RANGE_DIFFERS)
+				printf(" differed");
+			printf("\n");
+		}
+	}
+
+out_fds:
+	for (i = 0; i < nr; i++)
+		if (fd[i] >= 0)
+			close(fd[i]);
+out_pathnames:
+	for (i = 0; i < nr; i++)
+		free_pathname(&fpath[i]);
+
+	free(fd);
+out_v:
+	free(v);
+out_offsets:
+	free(off);
+out_info:
+	free(info);
+out_stats:
+	free(stat);
+out_paths:
+	free(fpath);
+out_fdr:
+	free(fdr);
+#endif
+}
+
 void
 setxattr_f(int opno, long r)
 {
