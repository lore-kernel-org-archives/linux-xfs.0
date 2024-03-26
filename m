Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A0384D12
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425115; cv=none; b=HcC0Qpi4ZnPTk9uoAYKeFbiOgRmug5kzY8vmM8pXJQ/QglWl1XCQ6kbTFPozZDbouVHDyjOLFaP/YYOg9mF5kgVaP5Vx7QLklI4RQu0nng5+5XjN2faWeSOkqoHOkukIASpgrWjIrghnXijVhGtZvOkZRNLY6tSc6HXHykqC/Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425115; c=relaxed/simple;
	bh=9kckebAoksZHVNHiwhVFKFr+WBLYoqj0lOFWv0FjJ1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFzo0XHcr0ymHXEmiOt9/Ac1qA+ytYpUzOdIQIVcwxyMmqnlHCvKwaXKjR2Ni//lC91KfUx0T1NUjHUmKtgdUza3R2IZD9+ouybIQOXCXWtvKxsvP8J78PsT6Gc/bBpYI2yy2H/cRjTfGgs2SQStz4AzPt3T4q7cTiOHtOJf/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1of6AGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1of6AGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026F8C433F1;
	Tue, 26 Mar 2024 03:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425115;
	bh=9kckebAoksZHVNHiwhVFKFr+WBLYoqj0lOFWv0FjJ1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i1of6AGDlNfFoflGmpyvaPiU/WxPcSn7ME/SgSSMjDiMgka9c3iBSx3ZC8cZ4BdzB
	 izZYofSYfsbEqhZseY1l5UXytv0i/eqpiM7XwpKFRqzBf8yw7eYCL9VQC717zMZL+I
	 9Uo5lOnPOMA8NnyNlK5ak2NLlRGI+hvs5Iq2pbWAm2K9IBmpqNugkxTrJDOWdMhhUR
	 yHI1/naoVfefw+AoBlO5HIGkjrpYIvMijIYfBZmXgOr7zVbaSkUTVu7usRAIJ3NR6J
	 l5lqpAYh0oBsJXgScIVzoAWcysWNF4+GUcov0hDVC/lSZwrPbZInHudJIPvGX+bm8f
	 A0M5pvu1tGeLg==
Date: Mon, 25 Mar 2024 20:51:54 -0700
Subject: [PATCH 090/110] libxfs: partition memfd files to avoid using too many
 fds
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142132675.2215168.14207969384321311692.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Make it so that we can partition a memfd file to avoid running out of
file descriptors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfile.c |  199 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfile.h |   13 +++-
 2 files changed, 203 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index d4bb3c743b75..e160a4f409f7 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -109,6 +109,149 @@ xfile_create_fd(
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
+	uint64_t		maxpos,
+	loff_t			*posp,
+	struct xfile_fcb	**fcbp)
+{
+	struct xfile_fcb	*fcb;
+	int			ret;
+	int			error;
+
+	/* No maximum range means that the caller gets a private memfd. */
+	if (maxpos == 0) {
+		*posp = 0;
+		return xfile_fcb_create(description, fcbp);
+	}
+
+	/* round up to page granularity so we can do mmap */
+	maxpos = roundup_64(maxpos, PAGE_SIZE);
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
+		ret = ftruncate(fcb->fd, pos + maxpos);
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
+	ret = ftruncate(fcb->fd, maxpos);
+	if (ret) {
+		error = -errno;
+		xfile_fcb_irele(fcb, 0, maxpos);
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
@@ -116,6 +259,7 @@ xfile_create_fd(
 int
 xfile_create(
 	const char		*description,
+	unsigned long long	maxpos,
 	struct xfile		**xfilep)
 {
 	struct xfile		*xf;
@@ -125,13 +269,14 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->fd = xfile_create_fd(description);
-	if (xf->fd < 0) {
-		error = -errno;
+	error = xfile_fcb_find(description, maxpos, &xf->partition_pos,
+			&xf->fcb);
+	if (error) {
 		kfree(xf);
 		return error;
 	}
 
+	xf->partition_bytes = maxpos;
 	*xfilep = xf;
 	return 0;
 }
@@ -141,7 +286,7 @@ void
 xfile_destroy(
 	struct xfile		*xf)
 {
-	close(xf->fd);
+	xfile_fcb_irele(xf->fcb, xf->partition_pos, xf->partition_bytes);
 	kfree(xf);
 }
 
@@ -149,6 +294,9 @@ static inline loff_t
 xfile_maxbytes(
 	struct xfile		*xf)
 {
+	if (xf->partition_bytes > 0)
+		return xf->partition_bytes;
+
 	if (sizeof(loff_t) == 8)
 		return LLONG_MAX;
 	return LONG_MAX;
@@ -172,7 +320,7 @@ xfile_load(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -ENOMEM;
 
-	ret = pread(xf->fd, buf, count, pos);
+	ret = pread(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret < 0)
 		return -errno;
 	if (ret != count)
@@ -198,7 +346,7 @@ xfile_store(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -EFBIG;
 
-	ret = pwrite(xf->fd, buf, count, pos);
+	ret = pwrite(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret < 0)
 		return -errno;
 	if (ret != count)
@@ -214,6 +362,37 @@ xfile_bytes(
 	struct xfile_stat	xs;
 	int			ret;
 
+	if (xf->partition_bytes > 0) {
+		loff_t		data_pos = xf->partition_pos;
+		loff_t		stop_pos = data_pos + xf->partition_bytes;
+		loff_t		hole_pos;
+		unsigned long long bytes = 0;
+
+		data_pos = lseek(xf->fcb->fd, data_pos, SEEK_DATA);
+		while (data_pos >= 0 && data_pos < stop_pos) {
+			hole_pos = lseek(xf->fcb->fd, data_pos, SEEK_HOLE);
+			if (hole_pos < 0) {
+				/* save error, break */
+				data_pos = hole_pos;
+				break;
+			}
+			if (hole_pos >= stop_pos) {
+				bytes += stop_pos - data_pos;
+				return bytes;
+			}
+			bytes += hole_pos - data_pos;
+
+			data_pos = lseek(xf->fcb->fd, hole_pos, SEEK_DATA);
+		}
+		if (data_pos < 0) {
+			if (errno == ENXIO)
+				return bytes;
+			return xf->partition_bytes;
+		}
+
+		return bytes;
+	}
+
 	ret = xfile_stat(xf, &xs);
 	if (ret)
 		return 0;
@@ -230,7 +409,13 @@ xfile_stat(
 	struct stat		ks;
 	int			error;
 
-	error = fstat(xf->fd, &ks);
+	if (xf->partition_bytes > 0) {
+		statbuf->size = xf->partition_bytes;
+		statbuf->bytes = xf->partition_bytes;
+		return 0;
+	}
+
+	error = fstat(xf->fcb->fd, &ks);
 	if (error)
 		return -errno;
 
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index 906128775fad..62934130345b 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -6,11 +6,20 @@
 #ifndef __LIBXFS_XFILE_H__
 #define __LIBXFS_XFILE_H__
 
+struct xfile_fcb {
+	struct list_head	fcb_list;
+	int			fd;
+	unsigned int		refcount;
+};
+
 struct xfile {
-	int		fd;
+	struct xfile_fcb	*fcb;
+	loff_t			partition_pos;
+	uint64_t		partition_bytes;
 };
 
-int xfile_create(const char *description, struct xfile **xfilep);
+int xfile_create(const char *description, unsigned long long maxpos,
+		struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
 ssize_t xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);

