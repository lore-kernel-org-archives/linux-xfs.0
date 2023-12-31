Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AFBBE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmsPnwuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D02C433C7;
	Sun, 31 Dec 2023 22:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061108;
	bh=BW4lM1dHTe3WjbyJXiFCE36d0Tvp51zowu2B76BoNzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BmsPnwuWPV2vKh5jIe/uo3NZycZsPU6ahnJnGUL+QA22uFmOKu5rw+I8WNxjAnURT
	 YtiP3JoCxKp+jMxOvNV2qwDpbo+8aaIALB50y4wWBvQor3cEbIVoKYThRnuBFBomCN
	 r60PKzjQcbaYguQe9JfxE0dWW7roMKFkWlcxNzF+M65DzQ1gR9KB7vupInZ+mXOuLC
	 aw4x8CdY9bDuMFdMQn+wrY2X515fa9Hpi2RZhHVyyogPL1jg2ZAeJ+YfVwrh23SYkd
	 aV1lNOQrsNCIx8AtLt3qIy8xqIcFtA62JP3kOglNbmI1pwmtDyy6VzXYblUJvfYxTg
	 Av/FqrksDEESg==
Date: Sun, 31 Dec 2023 14:18:27 -0800
Subject: [PATCH 1/6] libxfs: partition memfd files to avoid using too many fds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993601.1794934.8027575959399099755.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
References: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
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
 include/xfs_mount.h |    2 -
 libxfs/init.c       |    3 +
 libxfs/xfile.c      |  200 +++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfile.h      |    9 ++
 4 files changed, 201 insertions(+), 13 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8a2ffa4e7cc..ec63c525fd4 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -314,7 +314,7 @@ static inline void libxfs_buftarg_drain(struct xfs_buftarg *btp)
 void libxfs_buftarg_free(struct xfs_buftarg *btp);
 
 int xfile_alloc_buftarg(struct xfs_mount *mp, const char *descr,
-		struct xfs_buftarg **btpp);
+		unsigned long long maxrange, struct xfs_buftarg **btpp);
 void xfile_free_buftarg(struct xfs_buftarg *btp);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 72650447f1b..2e59ba0d0a2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -483,13 +483,14 @@ int
 xfile_alloc_buftarg(
 	struct xfs_mount	*mp,
 	const char		*descr,
+	unsigned long long	maxrange,
 	struct xfs_buftarg	**btpp)
 {
 	struct xfs_buftarg	*btp;
 	struct xfile		*xfile;
 	int			error;
 
-	error = xfile_create(descr, &xfile);
+	error = xfile_create(descr, maxrange, &xfile);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index b7199091f05..7f785feb125 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -127,6 +127,146 @@ xfile_create_fd(
 	return fd;
 }
 
+struct xfile_fcb {
+	struct list_head	fcb_list;
+	int			fd;
+	unsigned int		refcount;
+};
+
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
+	uint64_t		maxrange,
+	loff_t			*pos,
+	struct xfile_fcb	**fcbp)
+{
+	struct xfile_fcb	*fcb;
+	int			ret;
+	int			error;
+
+	/* No maximum range means that the caller gets a private memfd. */
+	if (maxrange == 0) {
+		*pos = 0;
+		return xfile_fcb_create(description, fcbp);
+	}
+
+	pthread_mutex_lock(&fcb_mutex);
+
+	/*
+	 * If we only need a certain number of byte range, look for one with
+	 * available file range.
+	 */
+	list_for_each_entry(fcb, &fcb_list, fcb_list) {
+		struct stat	statbuf;
+
+		ret = fstat(fcb->fd, &statbuf);
+		if (ret)
+			continue;
+
+		ret = ftruncate(fcb->fd, statbuf.st_size + maxrange);
+		if (ret)
+			continue;
+
+		fcb->refcount++;
+		*pos = statbuf.st_size;
+		*fcbp = fcb;
+		goto out_unlock;
+	}
+
+	/* Otherwise, open a new memfd and add it to our list. */
+	error = xfile_fcb_create(description, &fcb);
+	if (error)
+		return error;
+
+	ret = ftruncate(fcb->fd, maxrange);
+	if (ret) {
+		error = -errno;
+		xfile_fcb_irele(fcb, 0, maxrange);
+		return error;
+	}
+
+	list_add_tail(&fcb->fcb_list, &fcb_list);
+	*pos = 0;
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
@@ -134,6 +274,7 @@ xfile_create_fd(
 int
 xfile_create(
 	const char		*description,
+	unsigned long long	maxrange,
 	struct xfile		**xfilep)
 {
 	struct xfile		*xf;
@@ -143,13 +284,14 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->fd = xfile_create_fd(description);
-	if (xf->fd < 0) {
-		error = -errno;
+	error = xfile_fcb_find(description, maxrange, &xf->partition_pos,
+			&xf->fcb);
+	if (error) {
 		kmem_free(xf);
 		return error;
 	}
 
+	xf->partition_bytes = maxrange;
 	*xfilep = xf;
 	return 0;
 }
@@ -159,7 +301,7 @@ void
 xfile_destroy(
 	struct xfile		*xf)
 {
-	close(xf->fd);
+	xfile_fcb_irele(xf->fcb, xf->partition_pos, xf->partition_bytes);
 	kmem_free(xf);
 }
 
@@ -167,6 +309,9 @@ static inline loff_t
 xfile_maxbytes(
 	struct xfile		*xf)
 {
+	if (xf->partition_bytes > 0)
+		return xf->partition_bytes;
+
 	if (sizeof(loff_t) == 8)
 		return LLONG_MAX;
 	return LONG_MAX;
@@ -192,7 +337,7 @@ xfile_pread(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -EFBIG;
 
-	ret = pread(xf->fd, buf, count, pos);
+	ret = pread(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret >= 0)
 		return ret;
 	return -errno;
@@ -218,7 +363,7 @@ xfile_pwrite(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -EFBIG;
 
-	ret = pwrite(xf->fd, buf, count, pos);
+	ret = pwrite(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret >= 0)
 		return ret;
 	return -errno;
@@ -232,6 +377,37 @@ xfile_bytes(
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
@@ -248,7 +424,13 @@ xfile_stat(
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
 
@@ -275,7 +457,7 @@ xfile_dump(
 	}
 
 	/* reroute our xfile to stdin and shut everything else */
-	dup2(xf->fd, 0);
+	dup2(xf->fcb->fd, 0);
 	for (i = 3; i < 1024; i++)
 		close(i);
 
@@ -292,7 +474,7 @@ xfile_prealloc(
 	int		error;
 
 	count = min(count, xfile_maxbytes(xf) - pos);
-	error = fallocate(xf->fd, 0, pos, count);
+	error = fallocate(xf->fcb->fd, 0, pos + xf->partition_pos, count);
 	if (error)
 		return -errno;
 	return 0;
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index 0d15351d697..ac368432382 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -6,13 +6,18 @@
 #ifndef __LIBXFS_XFILE_H__
 #define __LIBXFS_XFILE_H__
 
+struct xfile_fcb;
+
 struct xfile {
-	int		fd;
+	struct xfile_fcb	*fcb;
+	loff_t			partition_pos;
+	uint64_t		partition_bytes;
 };
 
 void xfile_libinit(void);
 
-int xfile_create(const char *description, struct xfile **xfilep);
+int xfile_create(const char *description, unsigned long long maxrange,
+		struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
 ssize_t xfile_pread(struct xfile *xf, void *buf, size_t count, loff_t pos);

