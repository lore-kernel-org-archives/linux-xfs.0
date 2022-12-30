Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CBCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiLaAPH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiLaAPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:15:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAF560EF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18A3F61CF1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7389CC433D2;
        Sat, 31 Dec 2022 00:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445704;
        bh=WVLEsTCHeiM/tF4yytgpwss6yRYJ/1NuYQ50Nnx+Nj4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=frdp0q/nC5UhfyrRql5vywcYd/k3fqYGks+zBvFocWBAe2j0bZCb1ftH/DA4K4L39
         6QICLodjYb9kE1i5D9pfWRPj/PTh8fi206bxqtGa1vboetb5LNqqZo7dll1ew070z2
         RERN+M2l/6fbysJcqL5Lz1gysRLOpV1feY8TDC3FqpZ61ZcftpthJ8TZwEN+8kjgG/
         RYWmLHrxqvtVDJB6JqaGOSilPAb2sHlb7aMn0SmYg/VMmB571LvYHtzcqQQADxhHte
         THvsitvQ6II7uq/sDrx6ZtWQCDHXYZAp4mtJuU3/QYdJKuaRLX72VLK4JIyoA09ntA
         4mF20djDeYg7w==
Subject: [PATCH 1/6] libxfs: partition memfd files to avoid using too many fds
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866905.712584.180383149963743658.stgit@magnolia>
In-Reply-To: <167243866890.712584.9795710743681868714.stgit@magnolia>
References: <167243866890.712584.9795710743681868714.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that we can partition a memfd file to avoid running out of
file descriptors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfile.c |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfile.h |   10 ++-
 2 files changed, 167 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index c1b8b1c5928..dfe3c60a9b3 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -95,6 +95,146 @@ xfile_create_fd(
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
@@ -102,6 +242,7 @@ xfile_create_fd(
 int
 xfile_create(
 	struct xfs_mount	*mp,
+	unsigned long long	maxrange,
 	const char		*description,
 	struct xfile		**xfilep)
 {
@@ -117,13 +258,14 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->fd = xfile_create_fd(fname);
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
@@ -133,7 +275,7 @@ void
 xfile_destroy(
 	struct xfile		*xf)
 {
-	close(xf->fd);
+	xfile_fcb_irele(xf->fcb, xf->partition_pos, xf->partition_bytes);
 	kmem_free(xf);
 }
 
@@ -141,6 +283,9 @@ static inline loff_t
 xfile_maxbytes(
 	struct xfile		*xf)
 {
+	if (xf->partition_bytes > 0)
+		return xf->partition_bytes;
+
 	if (sizeof(loff_t) == 8)
 		return LLONG_MAX;
 	return LONG_MAX;
@@ -166,7 +311,7 @@ xfile_pread(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -EFBIG;
 
-	ret = pread(xf->fd, buf, count, pos);
+	ret = pread(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret >= 0)
 		return ret;
 	return -errno;
@@ -192,7 +337,7 @@ xfile_pwrite(
 	if (xfile_maxbytes(xf) - pos < count)
 		return -EFBIG;
 
-	ret = pwrite(xf->fd, buf, count, pos);
+	ret = pwrite(xf->fcb->fd, buf, count, pos + xf->partition_pos);
 	if (ret >= 0)
 		return ret;
 	return -errno;
@@ -207,7 +352,13 @@ xfile_stat(
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
 
@@ -234,7 +385,7 @@ xfile_dump(
 	}
 
 	/* reroute our xfile to stdin and shut everything else */
-	dup2(xf->fd, 0);
+	dup2(xf->fcb->fd, 0);
 	for (i = 3; i < 1024; i++)
 		close(i);
 
@@ -251,7 +402,7 @@ xfile_prealloc(
 	int		error;
 
 	count = min(count, xfile_maxbytes(xf) - pos);
-	error = fallocate(xf->fd, 0, pos, count);
+	error = fallocate(xf->fcb->fd, 0, pos + xf->partition_pos, count);
 	if (error)
 		return -errno;
 	return 0;
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index 9580de32864..9923fe8e5ec 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -6,14 +6,18 @@
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
 
-int xfile_create(struct xfs_mount *mp, const char *description,
-		struct xfile **xfilep);
+int xfile_create(struct xfs_mount *mp, unsigned long long maxrange,
+		const char *description, struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
 ssize_t xfile_pread(struct xfile *xf, void *buf, size_t count, loff_t pos);

