Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F7833080
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347535; cv=none; b=HJWX9YE3zsUAQJsxA/J/WueQhLQ+77AlCYMdKoIBGPufeFxGmsK/tgVXkp23FR7niceQTm5S3rRvgZoN4Bmq5Q+vOPDUO2Dnhy4PDWkhNX2Zgo+fjjI/umH7D+RcN3bCQULFCGeENsdcrZYte4vuFANKJCrguGMtTcWJ/rp3Knk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347535; c=relaxed/simple;
	bh=PPeAEi/SgJc1HjAClBihmdjoMDBo0pUSlLXPvX/IkR8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzmyTNXqZNksA+O2+YcHjvj33aqF54zUfNZKklREuMASylIEAB+ewDQb65PNUSMuyUiH8qUqLOwU2CWfomDjxvLWk3YQ86h/rImoBqGY+XY6aYPFbk2dgEX1nc2ntTyirzy0OZJ1WDtilWbl4KkoPGRpmOp4gWoXoUJ0/PpJnUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVsDe0S1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVsDe0S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49986C2BD11;
	Wed, 22 May 2024 03:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347535;
	bh=PPeAEi/SgJc1HjAClBihmdjoMDBo0pUSlLXPvX/IkR8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fVsDe0S1M7BhpMkGtrZ3yFaPlYh0t7sSu7yUhTfygERdz0/R0AhFPOM8IISOeboVl
	 JghEqZef2gnUyRDX+cWvLBR0EX+NmjSoL71/PfcsJPsuJabe/fZeHsBWmqxM0s8jLx
	 oCxYwX+E0AlUO1zc7hyIURUnWGc1WvFsxADmH3ldRxgqu8scOCTYwPeMZN7+bkOH3H
	 b5kJcRwx2PWHF7XiN6zujGNQXjXFQVlKynWCkKaVB9FBREy74kdpbdJeOR243iuGXn
	 v8cAVx2QMd2YyFIPWU4tRbE9UPjHRpO0391S1xkWHB4bmFih2lCbs9dnoNH8GCDKna
	 WwfVmZvYs9GHg==
Date: Tue, 21 May 2024 20:12:14 -0700
Subject: [PATCH 090/111] libxfs: partition memfd files to avoid using too many
 fds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171634533050.2478931.6745973902518195395.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In a few patchsets from now, we'll transition xfs_repair to use
memfd-backed rmap and rcbag btrees for storing repair data instead of
heap allocations.  This allows repair to use libxfs code shared from the
online repair code, which reduces the size of the codebase.  It also
reduces heap fragmentation, which might be critical on 32-bit systems.

However, there's one hitch -- userspace xfiles naively allocate one
memfd per data structure, but there's only so many file descriptors that
a process can open.  If a filesystem has a lot of allocation groups, we
can run out of fds and fail.  xfs_repair already tries to increase
RLIMIT_NOFILE to the maximum (~1M) but this can fail due to system or
memory constraints.

Fortunately, it is possible to compute the upper bound of a memfd btree,
which implies that we can store multiple btrees per memfd.  Make it so
that we can partition a memfd file to avoid running out of file
descriptors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfile.c |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfile.h |   17 ++++-
 2 files changed, 205 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index cba173cc1..fdb76f406 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -97,6 +97,149 @@ xfile_create_fd(
 	return fd;
 }
 
+static LIST_HEAD(fcb_list);
+static pthread_mutex_t fcb_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+/* Create a new memfd. */
+static inline int
+xfile_fcb_create(
+	const char		*description,
+	struct xfile_fcb	**fcbp)
+{
+	struct xfile_fcb	*fcb;
+	int			fd;
+
+	fd = xfile_create_fd(description);
+	if (fd < 0)
+		return -errno;
+
+	fcb = malloc(sizeof(struct xfile_fcb));
+	if (!fcb) {
+		close(fd);
+		return -ENOMEM;
+	}
+
+	list_head_init(&fcb->fcb_list);
+	fcb->fd = fd;
+	fcb->refcount = 1;
+
+	*fcbp = fcb;
+	return 0;
+}
+
+/* Release an xfile control block */
+static void
+xfile_fcb_irele(
+	struct xfile_fcb	*fcb,
+	loff_t			pos,
+	uint64_t		len)
+{
+	/*
+	 * If this memfd is linked only to itself, it's private, so we can
+	 * close it without taking any locks.
+	 */
+	if (list_empty(&fcb->fcb_list)) {
+		close(fcb->fd);
+		free(fcb);
+		return;
+	}
+
+	pthread_mutex_lock(&fcb_mutex);
+	if (--fcb->refcount == 0) {
+		/* If we're the last user of this memfd file, kill it fast. */
+		list_del(&fcb->fcb_list);
+		close(fcb->fd);
+		free(fcb);
+	} else if (len > 0) {
+		struct stat	statbuf;
+		int		ret;
+
+		/*
+		 * If we were using the end of a partitioned file, free the
+		 * address space.  IOWs, bonus points if you delete these in
+		 * reverse-order of creation.
+		 */
+		ret = fstat(fcb->fd, &statbuf);
+		if (!ret && statbuf.st_size == pos + len) {
+			ret = ftruncate(fcb->fd, pos);
+		}
+	}
+	pthread_mutex_unlock(&fcb_mutex);
+}
+
+/*
+ * Find an memfd that can accomodate the given amount of address space.
+ */
+static int
+xfile_fcb_find(
+	const char		*description,
+	uint64_t		maxbytes,
+	loff_t			*posp,
+	struct xfile_fcb	**fcbp)
+{
+	struct xfile_fcb	*fcb;
+	int			ret;
+	int			error;
+
+	/* No maximum range means that the caller gets a private memfd. */
+	if (maxbytes == 0) {
+		*posp = 0;
+		return xfile_fcb_create(description, fcbp);
+	}
+
+	/* round up to page granularity so we can do mmap */
+	maxbytes = roundup_64(maxbytes, PAGE_SIZE);
+
+	pthread_mutex_lock(&fcb_mutex);
+
+	/*
+	 * If we only need a certain number of byte range, look for one with
+	 * available file range.
+	 */
+	list_for_each_entry(fcb, &fcb_list, fcb_list) {
+		struct stat	statbuf;
+		loff_t		pos;
+
+		ret = fstat(fcb->fd, &statbuf);
+		if (ret)
+			continue;
+		pos = roundup_64(statbuf.st_size, PAGE_SIZE);
+
+		/*
+		 * Truncate up to ensure that the memfd can actually handle
+		 * writes to the end of the range.
+		 */
+		ret = ftruncate(fcb->fd, pos + maxbytes);
+		if (ret)
+			continue;
+
+		fcb->refcount++;
+		*posp = pos;
+		*fcbp = fcb;
+		goto out_unlock;
+	}
+
+	/* Otherwise, open a new memfd and add it to our list. */
+	error = xfile_fcb_create(description, &fcb);
+	if (error)
+		return error;
+
+	ret = ftruncate(fcb->fd, maxbytes);
+	if (ret) {
+		error = -errno;
+		xfile_fcb_irele(fcb, 0, maxbytes);
+		return error;
+	}
+
+	list_add_tail(&fcb->fcb_list, &fcb_list);
+	*posp = 0;
+	*fcbp = fcb;
+
+out_unlock:
+	pthread_mutex_unlock(&fcb_mutex);
+	return error;
+}
+
 /*
  * Create an xfile of the given size.  The description will be used in the
  * trace output.
@@ -104,6 +247,7 @@ xfile_create_fd(
 int
 xfile_create(
 	const char		*description,
+	unsigned long long	maxbytes,
 	struct xfile		**xfilep)
 {
 	struct xfile		*xf;
@@ -113,13 +257,14 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->fd = xfile_create_fd(description);
-	if (xf->fd < 0) {
-		error = -errno;
+	error = xfile_fcb_find(description, maxbytes, &xf->partition_pos,
+			&xf->fcb);
+	if (error) {
 		kfree(xf);
 		return error;
 	}
 
+	xf->maxbytes = maxbytes;
 	*xfilep = xf;
 	return 0;
 }
@@ -129,7 +274,7 @@ void
 xfile_destroy(
 	struct xfile		*xf)
 {
-	close(xf->fd);
+	xfile_fcb_irele(xf->fcb, xf->partition_pos, xf->maxbytes);
 	kfree(xf);
 }
 
@@ -137,6 +282,9 @@ static inline loff_t
 xfile_maxbytes(
 	struct xfile		*xf)
 {
+	if (xf->maxbytes > 0)
+		return xf->maxbytes;
+
 	if (sizeof(loff_t) == 8)
 		return LLONG_MAX;
 	return LONG_MAX;
@@ -160,7 +308,7 @@ xfile_load(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -ENOMEM;
 
-	ret = pread(xf->fd, buf, count, pos);
+	ret = pread(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret < 0)
 		return -errno;
 	if (ret != count)
@@ -186,7 +334,7 @@ xfile_store(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -EFBIG;
 
-	ret = pwrite(xf->fd, buf, count, pos);
+	ret = pwrite(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret < 0)
 		return -errno;
 	if (ret != count)
@@ -194,6 +342,38 @@ xfile_store(
 	return 0;
 }
 
+/* Compute the number of bytes used by a partitioned xfile. */
+static unsigned long long
+xfile_partition_bytes(
+	struct xfile		*xf)
+{
+	loff_t			data_pos = xf->partition_pos;
+	loff_t			stop_pos = data_pos + xf->maxbytes;
+	loff_t			hole_pos;
+	unsigned long long	bytes = 0;
+
+	data_pos = lseek(xf->fcb->fd, data_pos, SEEK_DATA);
+	while (data_pos >= 0 && data_pos < stop_pos) {
+		hole_pos = lseek(xf->fcb->fd, data_pos, SEEK_HOLE);
+		if (hole_pos < 0) {
+			/* save error, break */
+			data_pos = hole_pos;
+			break;
+		}
+		if (hole_pos >= stop_pos) {
+			bytes += stop_pos - data_pos;
+			return bytes;
+		}
+		bytes += hole_pos - data_pos;
+
+		data_pos = lseek(xf->fcb->fd, hole_pos, SEEK_DATA);
+	}
+	if (data_pos < 0 && errno != ENXIO)
+		return xf->maxbytes;
+
+	return bytes;
+}
+
 /* Compute the number of bytes used by a xfile. */
 unsigned long long
 xfile_bytes(
@@ -202,7 +382,10 @@ xfile_bytes(
 	struct stat		statbuf;
 	int			error;
 
-	error = fstat(xf->fd, &statbuf);
+	if (xf->maxbytes > 0)
+		return xfile_partition_bytes(xf);
+
+	error = fstat(xf->fcb->fd, &statbuf);
 	if (error)
 		return -errno;
 
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index d60084011..180a42bbb 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -6,11 +6,24 @@
 #ifndef __LIBXFS_XFILE_H__
 #define __LIBXFS_XFILE_H__
 
-struct xfile {
+struct xfile_fcb {
+	struct list_head	fcb_list;
 	int			fd;
+	unsigned int		refcount;
 };
 
-int xfile_create(const char *description, struct xfile **xfilep);
+struct xfile {
+	struct xfile_fcb	*fcb;
+
+	/* File position within fcb->fd where this partition starts */
+	loff_t			partition_pos;
+
+	/* Maximum number of bytes that can be written to the partition. */
+	uint64_t		maxbytes;
+};
+
+int xfile_create(const char *description, unsigned long long maxbytes,
+		struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
 ssize_t xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);

