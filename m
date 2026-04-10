Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EFC29AAEA
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801452; cv=none; b=eEvkMTgifSiKkJ4+y3HUe3HiIKcdn2oD/5OF9oo3/aeY775SsGSt+V9hkmvMdpoFBHvQnssnuJuy09xAPqD2Uey8MdnSQpWvHz78bnHs8+eUvWk2PpVPtBe303pw7Zkhcn67g2V0M1YrHgMLO5K41KD48kBSSJo+8l1r9FxyY2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801452; c=relaxed/simple;
	bh=BBUwUsIhQbQ8cygT1u7F0umpf0CFhxBYmOn4B7ozmJ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kO19TAxnIWFcgjzFWPLRCcI7GUuEERWsEU27A0t6wlUgkWlAd07KIN0l3G7bIgAjKPpWB3WjnckMZgPAQeQhyjFHNzfSJTdOS/MYJBWTFx2Zku7HBBZx1Gfj3146p11vLQcQgR8NwlbfAGqIHD0p8AQi/fSs35GpXd4QUBuE8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIwfbh83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIwfbh83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B5AC19421;
	Fri, 10 Apr 2026 06:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801452;
	bh=BBUwUsIhQbQ8cygT1u7F0umpf0CFhxBYmOn4B7ozmJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cIwfbh837Uig6OUfkuINe4VE/LQ3DIMRLzLueUy+yxkjIFCQoYD2ajPai4WTlGEqJ
	 aV6ccePaSBTyQIAQuCmC/VOry61Fk4BsXjDA0CKML5pCSrf0+E3KGe/jUmA+OtwLwr
	 cOnOrKHqa4g/47lYnWDH8E8Ko4je6Edp5JAvsiTTUFclSHYnKaqFcOsTBfGo27bv0m
	 x0pmk7M4X2luQgbfMOqWaiN4f5Fhd6JaalqWRUIsXzvrebv9fm5lhhMYKbD5oqxB2g
	 W1inkef7HVOGTaRNQ99o9qY2swTaMfUaoV+p2N4jpzgYKDlacyv/rz5cgV3nQIOyfX
	 e19dzuQHEpuiw==
Date: Thu, 09 Apr 2026 23:10:51 -0700
Subject: [PATCH 01/26] libfrog: add a function to grab the path from an open
 fd and a file handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384249.2089237.7767356657496956062.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

handle_walk_paths operates on a file handle, but requires that the fs
has been registered with libhandle via path_to_fshandle.  For a normal
libhandle client this is the desirable behavior because the application
*should* maintain an open fd to the filesystem mount.

However for xfs_healer this isn't going to work well because the healer
mustn't pin the mount while it's running.  It's smart enough to know how
to find and reconnect to the mountpoint, but libhandle doesn't have any
such concept.

Therefore, alter the libfrog getparents code so that xfs_healer can pass
in the mountpoint and reconnected fd without needing libhandle.  All
we're really doing here is trying to obtain a user-visible path for a
file that encountered problems for logging purposes; if it fails, we'll
fall back to logging the inode number.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/getparents.h |    4 ++
 libfrog/getparents.c |   93 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 82 insertions(+), 15 deletions(-)


diff --git a/libfrog/getparents.h b/libfrog/getparents.h
index 8098d594219b4c..e1df30889c7606 100644
--- a/libfrog/getparents.h
+++ b/libfrog/getparents.h
@@ -39,4 +39,8 @@ int fd_to_path(int fd, size_t ioctl_bufsize, char *path, size_t pathlen);
 int handle_to_path(const void *hanp, size_t hlen, size_t ioctl_bufsize,
 		char *path, size_t pathlen);
 
+int handle_walk_paths_fd(const char *mntpt, int mntfd, const void *hanp,
+		size_t hanlen, size_t ioctl_bufsize, walk_path_fn fn,
+		void *arg);
+
 #endif /* __LIBFROG_GETPARENTS_H_ */
diff --git a/libfrog/getparents.c b/libfrog/getparents.c
index 9118b0ff32db0d..e8f545392634e4 100644
--- a/libfrog/getparents.c
+++ b/libfrog/getparents.c
@@ -112,9 +112,13 @@ fd_walk_parents(
 	return ret;
 }
 
-/* Walk all parent pointers of this handle.  Returns 0 or positive errno. */
-int
-handle_walk_parents(
+/*
+ * Walk all parent pointers of this handle using the given fd to query the
+ * filesystem.  Returns 0 or positive errno.
+ */
+static int
+handle_walk_parents_fd(
+	int			fd,
 	const void		*hanp,
 	size_t			hlen,
 	size_t			bufsize,
@@ -123,21 +127,11 @@ handle_walk_parents(
 {
 	struct xfs_getparents_by_handle	gph = { };
 	void			*buf;
-	char			*mntpt;
-	int			fd;
 	int			ret;
 
 	if (hlen != sizeof(struct xfs_handle))
 		return EINVAL;
 
-	/*
-	 * This function doesn't modify the handle, but we don't want to have
-	 * to bump the libhandle major version just to change that.
-	 */
-	fd = handle_to_fsfd((void *)hanp, &mntpt);
-	if (fd < 0)
-		return errno;
-
 	buf = alloc_records(&gph.gph_request, bufsize);
 	if (!buf)
 		return errno;
@@ -158,6 +152,29 @@ handle_walk_parents(
 	return ret;
 }
 
+/* Walk all parent pointers of this handle.  Returns 0 or positive errno. */
+int
+handle_walk_parents(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			bufsize,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	char			*mntpt;
+	int			fd;
+
+	/*
+	 * This function doesn't modify the handle, but we don't want to have
+	 * to bump the libhandle major version just to change that.
+	 */
+	fd = handle_to_fsfd((void *)hanp, &mntpt);
+	if (fd < 0)
+		return errno;
+
+	return handle_walk_parents_fd(fd, hanp, hlen, bufsize, fn, arg);
+}
+
 struct walk_ppaths_info {
 	/* Callback */
 	walk_path_fn		fn;
@@ -169,7 +186,11 @@ struct walk_ppaths_info {
 	/* Path that we're constructing. */
 	struct path_list	*path;
 
+	/* Use this much memory per call. */
 	size_t			ioctl_bufsize;
+
+	/* Use this fd for calling the getparents ioctl. */
+	int			mntfd;
 };
 
 /*
@@ -200,8 +221,14 @@ find_parent_component(
 		return errno;
 	path_list_add_parent_component(wpi->path, pc);
 
-	ret = handle_walk_parents(&rec->p_handle, sizeof(rec->p_handle),
-			wpi->ioctl_bufsize, find_parent_component, wpi);
+	if (wpi->mntfd >= 0)
+		ret = handle_walk_parents_fd(wpi->mntfd, &rec->p_handle,
+				sizeof(rec->p_handle), wpi->ioctl_bufsize,
+				find_parent_component, wpi);
+	else
+		ret = handle_walk_parents(&rec->p_handle,
+				sizeof(rec->p_handle), wpi->ioctl_bufsize,
+				find_parent_component, wpi);
 
 	path_list_del_component(wpi->path, pc);
 	path_component_free(pc);
@@ -222,6 +249,7 @@ handle_walk_paths(
 {
 	struct walk_ppaths_info	wpi = {
 		.ioctl_bufsize	= ioctl_bufsize,
+		.mntfd		= -1,
 	};
 	int			ret;
 
@@ -246,6 +274,41 @@ handle_walk_paths(
 	return ret;
 }
 
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * described in the handle using an already open mountpoint and fd.  Returns 0
+ * for success or positive errno.
+ */
+int
+handle_walk_paths_fd(
+	const char		*mntpt,
+	int			mntfd,
+	const void		*hanp,
+	size_t			hlen,
+	size_t			ioctl_bufsize,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi = {
+		.ioctl_bufsize	= ioctl_bufsize,
+		.mntfd		= mntfd,
+		.mntpt		= (char *)mntpt,
+	};
+	int			ret;
+
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return errno;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parents_fd(mntfd, hanp, hlen, ioctl_bufsize,
+			find_parent_component, &wpi);
+
+	path_list_free(wpi.path);
+	return ret;
+}
+
 /*
  * Call the given function on all known paths from the vfs root to the inode
  * referred to by the file description.  Returns 0 or positive errno.

