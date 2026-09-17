Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62CE4A4409;
	Thu, 17 Sep 2026 09:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636212; cv=none; b=lYxCImIBj6T3NgYa6a/Q2+Fpjrtn3cHbNAnr2GutrgCml8a/AffLcJw1gY81UJKBNYXalKoxs89q0jJ2Y7vuAL9Whgni8U4OWTA3mjhFG9vaqom13IIOme+MMMJr6KKYN4/cWxsoG9FS2ecOH1nf+8FPhPy1KsgHMyLyif7QQCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636212; c=relaxed/simple;
	bh=4TVATxkIdSojFG8h8ibaa3nhcXlk0rv552POIhYv3M4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QOsA8Hp1OF1Q+KRW8PTYOFK/X+lxzZuSFTckTl6D/g3vUrZwWdF2lPvXcXZOuj5ZNMrPBBas7La1Fx0A12Ozh+BSipVgB24YkH58bVnGKmy4AXQ5KJgcdiNqxIjD47vLevKSl16c3C0Xj0BfnLUNTH3pz4FELVgXpbSo1sF1xUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TU+vHQdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TU+vHQdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBED1F000FF;
	Thu, 17 Sep 2026 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636210;
	bh=QH2WDKb8N1csYIAwFwWTZJ+veVOResNI8NfDe/HwrVs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TU+vHQdZQFBVLHxYRqINdkcmjBoejnE/VDffiTWv+Kv0ML+iwy2Y+tKyasd6eZNpq
	 Ck2IUqodncPwUTEXsLZoJzMgTfRfhLR7DsFm2GcUdUjT/2lZWfH7ztoLl1UCDhTbkv
	 gLFkFO1WSeI0495U5lwO8kxpWovsLK+TF9XFdy5XIYfpMXSqEVla/FIXyRPp2k5dAN
	 dFh7T9VkaAP+4ZepAOOHB3VoqESKk/1BclxtaSO4Msqhmo5pYMcCmbbrzjjQJwSdPV
	 Gk1zhpUdM1ksiPoUhJD0naTEyyqMNCXIjnknl8nng0c8tK0y9mdRQIbsKjFbyeTCGA
	 IXqfi8QJ6WYfw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:09:45 +0200
Subject: [PATCH 4/4] file: make struct fd_prepare const and kill its err
 field
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-file-fd_prepare-v1-4-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
In-Reply-To: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, 
 wine-devel@list.winehq.org, linux-xfs@vger.kernel.org, 
 io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=19031; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4TVATxkIdSojFG8h8ibaa3nhcXlk0rv552POIhYv3M4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhdZ41vZpHLF51FP6LTChIeFL7vbmKVjdjH4/TBPs
 V3PpTq5o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIKcgz/0xeJLtmzKHxmOeui
 4KDnWxuk57UzZjk43Di8tvZzovPjLob/Ka9m8bpar2fZebD59WXH8jWM0YVMumx7dDb4XNjmcUm
 aDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

FD_PREPARE() releases the fd as soon as the file expression fails. The
fd either holds the descriptor or the error. The separate field is
redundant. Make fd and file plain members and struct fd_prepare simpler.

Callers of FD_PREPARE() get a const pointer to the guard. Simplify all
users as they can now easily access the trivial struct.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 12 +++---
 drivers/gpio/gpiolib-cdev.c               | 18 ++++-----
 drivers/gpu/drm/msm/msm_perfcntr.c        |  4 +-
 drivers/media/mc/mc-request.c             |  8 ++--
 drivers/misc/ntsync.c                     |  6 +--
 fs/eventfd.c                              |  4 +-
 fs/eventpoll.c                            |  6 +--
 fs/file.c                                 |  8 ++--
 fs/namespace.c                            | 12 +++---
 fs/nsfs.c                                 |  4 +-
 fs/xfs/xfs_handle.c                       |  6 +--
 include/linux/file.h                      | 66 +++++++++++++------------------
 io_uring/mock_file.c                      |  8 ++--
 kernel/bpf/bpf_iter.c                     |  6 +--
 kernel/bpf/token.c                        |  6 +--
 mm/userfaultfd.c                          |  6 +--
 net/core/scm.c                            |  8 ++--
 net/handshake/netlink.c                   |  8 ++--
 net/kcm/kcmsock.c                         |  6 +--
 19 files changed, 95 insertions(+), 107 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 2b54afb31529..5c06f69c9f7f 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -266,9 +266,9 @@ spufs_mkdir(struct inode *dir, struct dentry *dentry, unsigned int flags,
 static int spufs_context_open(const struct path *path)
 {
 	FD_PREPARE(fdf, 0, dentry_open(path, O_RDONLY, current_cred()));
-	if (fdf.err)
-		return fdf.err;
-	fd_prepare_file(fdf)->f_op = &spufs_context_fops;
+	if (fdf->fd < 0)
+		return fdf->fd;
+	fdf->file->f_op = &spufs_context_fops;
 	return fd_publish(fdf);
 }
 
@@ -499,9 +499,9 @@ static int spufs_gang_open(const struct path *path)
 	 * in error path of *_open().
 	 */
 	FD_PREPARE(fdf, 0, dentry_open(path, O_RDONLY, current_cred()));
-	if (fdf.err)
-		return fdf.err;
-	fd_prepare_file(fdf)->f_op = &spufs_gang_fops;
+	if (fdf->fd < 0)
+		return fdf->fd;
+	fdf->file->f_op = &spufs_gang_fops;
 	return fd_publish(fdf);
 }
 
diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 9f3b628d5793..6526ce27ea44 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -377,11 +377,11 @@ static int linehandle_create(struct gpio_device *gdev, void __user *ip)
 	FD_PREPARE(fdf, O_RDONLY | O_CLOEXEC,
 		   anon_inode_getfile("gpio-linehandle", &linehandle_fileops,
 				      lh, O_RDONLY | O_CLOEXEC));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 	retain_and_null_ptr(lh);
 
-	handlereq.fd = fd_prepare_fd(fdf);
+	handlereq.fd = fdf->fd;
 	if (copy_to_user(ip, &handlereq, sizeof(handlereq)))
 		return -EFAULT;
 
@@ -1715,11 +1715,11 @@ static int linereq_create(struct gpio_device *gdev, void __user *ip)
 	FD_PREPARE(fdf, O_RDONLY | O_CLOEXEC,
 		   anon_inode_getfile("gpio-line", &line_fileops, lr,
 				      O_RDONLY | O_CLOEXEC));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 	retain_and_null_ptr(lr);
 
-	ulr.fd = fd_prepare_fd(fdf);
+	ulr.fd = fdf->fd;
 	if (copy_to_user(ip, &ulr, sizeof(ulr)))
 		return -EFAULT;
 
@@ -2115,11 +2115,11 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 	FD_PREPARE(fdf, O_RDONLY | O_CLOEXEC,
 		   anon_inode_getfile("gpio-event", &lineevent_fileops, le,
 				      O_RDONLY | O_CLOEXEC));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 	retain_and_null_ptr(le);
 
-	eventreq.fd = fd_prepare_fd(fdf);
+	eventreq.fd = fdf->fd;
 	if (copy_to_user(ip, &eventreq, sizeof(eventreq)))
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/msm/msm_perfcntr.c b/drivers/gpu/drm/msm/msm_perfcntr.c
index ce65b1160955..7fa2e858bd08 100644
--- a/drivers/gpu/drm/msm/msm_perfcntr.c
+++ b/drivers/gpu/drm/msm/msm_perfcntr.c
@@ -543,8 +543,8 @@ msm_ioctl_perfcntr_config(struct drm_device *dev, void *data, struct drm_file *f
 
 		FD_PREPARE(fdf, O_CLOEXEC,
 			   anon_inode_getfile("[msm_perfcntrs]", &stream_fops, stream, 0));
-		if (fdf.err)
-			return fdf.err;
+		if (fdf->fd < 0)
+			return fdf->fd;
 
 		INIT_WORK(&stream->sel_work, sel_worker);
 		kthread_init_work(&stream->sample_work, sample_worker);
diff --git a/drivers/media/mc/mc-request.c b/drivers/media/mc/mc-request.c
index 13e77648807c..e1387f039780 100644
--- a/drivers/media/mc/mc-request.c
+++ b/drivers/media/mc/mc-request.c
@@ -316,15 +316,15 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
 	FD_PREPARE(fdf, O_CLOEXEC,
 		   anon_inode_getfile("request", &request_fops, NULL,
 				      O_CLOEXEC));
-	if (fdf.err) {
-		ret = fdf.err;
+	if (fdf->fd < 0) {
+		ret = fdf->fd;
 		goto err_free_req;
 	}
 
-	fd_prepare_file(fdf)->private_data = req;
+	fdf->file->private_data = req;
 
 	snprintf(req->debug_str, sizeof(req->debug_str), "%u:%d",
-		 atomic_inc_return(&mdev->request_id), fd_prepare_fd(fdf));
+		 atomic_inc_return(&mdev->request_id), fdf->fd);
 	atomic_inc(&mdev->num_requests);
 	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
 
diff --git a/drivers/misc/ntsync.c b/drivers/misc/ntsync.c
index 4a805919bb0c..2857ae37d3c8 100644
--- a/drivers/misc/ntsync.c
+++ b/drivers/misc/ntsync.c
@@ -724,9 +724,9 @@ static int ntsync_obj_get_fd(struct ntsync_obj *obj)
 {
 	FD_PREPARE(fdf, O_CLOEXEC,
 		   anon_inode_getfile("ntsync", &ntsync_obj_fops, obj, O_RDWR));
-	if (fdf.err)
-		return fdf.err;
-	obj->file = fd_prepare_file(fdf);
+	if (fdf->fd < 0)
+		return fdf->fd;
+	obj->file = fdf->file;
 	return fd_publish(fdf);
 }
 
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 9d33a02757d5..52426795752e 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -403,8 +403,8 @@ static int do_eventfd(unsigned int count, int flags)
 	FD_PREPARE(fdf, flags,
 		   anon_inode_getfile_fmode("[eventfd]", &eventfd_fops, ctx,
 					    flags, FMODE_NOWAIT));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	ctx->id = ida_alloc(&eventfd_ida, GFP_KERNEL);
 	retain_and_null_ptr(ctx);
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e0c4bf88a838..f48b829a710f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2514,11 +2514,11 @@ static int do_epoll_create(int flags)
 	FD_PREPARE(fdf, O_RDWR | (flags & O_CLOEXEC),
 		   anon_inode_getfile("[eventpoll]", &eventpoll_fops, ep,
 				      O_RDWR | (flags & O_CLOEXEC)));
-	if (fdf.err) {
+	if (fdf->fd < 0) {
 		ep_clear_and_put(ep);
-		return fdf.err;
+		return fdf->fd;
 	}
-	ep->file = fd_prepare_file(fdf);
+	ep->file = fdf->file;
 	return fd_publish(fdf);
 }
 
diff --git a/fs/file.c b/fs/file.c
index 628ca07dc4b1..2a01b22eb65a 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1391,17 +1391,17 @@ int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 		return error;
 
 	FD_PREPARE(fdf, o_flags, file);
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 	get_file(file);
 
 	if (ufd) {
-		error = put_user(fd_prepare_fd(fdf), ufd);
+		error = put_user(fdf->fd, ufd);
 		if (error)
 			return error;
 	}
 
-	__receive_sock(fd_prepare_file(fdf));
+	__receive_sock(fdf->file);
 	return fd_publish(fdf);
 }
 EXPORT_SYMBOL_GPL(receive_fd);
diff --git a/fs/namespace.c b/fs/namespace.c
index 1ecd96c918b3..0f5c00816775 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4544,16 +4544,16 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 
 	FD_PREPARE(fdf, (flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 		   dentry_open(&new_path, O_PATH, fc->cred));
-	if (fdf.err) {
+	if (fdf->fd < 0) {
 		dissolve_on_fput(new_path.mnt);
-		return fdf.err;
+		return fdf->fd;
 	}
 
 	/*
 	 * Attach to an apparent O_PATH fd with a note that we
 	 * need to unmount it, not just simply put it.
 	 */
-	fd_prepare_file(fdf)->f_mode |= FMODE_NEED_UNMOUNT;
+	fdf->file->f_mode |= FMODE_NEED_UNMOUNT;
 	return fd_publish(fdf);
 }
 
@@ -5198,12 +5198,12 @@ SYSCALL_DEFINE5(open_tree_attr, int, dfd, const char __user *, filename,
 		return -EINVAL;
 
 	FD_PREPARE(fdf, flags, vfs_open_tree(dfd, filename, flags));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	if (uattr) {
 		struct mount_kattr kattr = {};
-		struct file *file = fd_prepare_file(fdf);
+		struct file *file = fdf->file;
 		int ret;
 
 		if (flags & OPEN_TREE_CLONE)
diff --git a/fs/nsfs.c b/fs/nsfs.c
index c3b6ae76594a..56ea0bb9ef3a 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -348,8 +348,8 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 			return ret;
 
 		FD_PREPARE(fdf, O_CLOEXEC, dentry_open(&path, O_RDONLY, current_cred()));
-		if (fdf.err)
-			return fdf.err;
+		if (fdf->fd < 0)
+			return fdf->fd;
 		/*
 		 * If @uinfo is passed return all information about the
 		 * mount namespace as well.
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 0689cade8f74..303bcff64459 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -272,11 +272,11 @@ xfs_open_by_handle(
 	path.mnt = mntget(parfilp->f_path.mnt);
 
 	FD_PREPARE(fdf, 0, dentry_open(&path, hreq->oflags, cred));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	if (S_ISREG(inode->i_mode)) {
-		struct file *filp = fd_prepare_file(fdf);
+		struct file *filp = fdf->file;
 
 		filp->f_flags |= O_NOATIME;
 		filp->f_mode |= FMODE_NOCMTIME;
diff --git a/include/linux/file.h b/include/linux/file.h
index 926cc58d0b7f..41c3c0be1064 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -130,38 +130,26 @@ extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
 
 /*
  * fd_prepare: Combined fd + file allocation cleanup class.
- * @err: Error code to indicate if allocation succeeded.
- * @__fd: Allocated fd (may not be accessed directly)
- * @__file: Allocated struct file pointer (may not be accessed directly)
+ * @fd: Allocated fd
+ * @file: Allocated struct file pointer
  *
  * Allocates an fd and a file together. On error paths, automatically cleans
  * up whichever resource was successfully allocated. Allows flexible file
  * allocation with different functions per usage.
  *
- * Do not use directly.
+ * Do not declare directly, use FD_PREPARE().
  */
 struct fd_prepare {
-	s32 err;
-	s32 __fd; /* do not access directly */
-	struct file *__file; /* do not access directly */
+	int fd;
+	struct file *file;
 };
 
-/*
- * Accessors for fd_prepare class members.
- * _Generic() is used for zero-cost type safety.
- */
-#define fd_prepare_fd(_fdf) \
-	(_Generic((_fdf), struct fd_prepare: (_fdf).__fd))
-
-#define fd_prepare_file(_fdf) \
-	(_Generic((_fdf), struct fd_prepare: (_fdf).__file))
-
 /* Do not use directly. */
 static __always_inline void __fd_prepare_cleanup(const struct fd_prepare *fdf)
 {
-	if (unlikely(fdf->__fd >= 0)) {
-		put_unused_fd(fdf->__fd);
-		fput(fdf->__file);
+	if (unlikely(fdf->fd >= 0)) {
+		put_unused_fd(fdf->fd);
+		fput(fdf->file);
 	}
 }
 
@@ -175,11 +163,7 @@ static __always_inline struct fd_prepare __fd_prepare(int fd, struct file *file)
 		fd = err;
 		file = NULL;
 	}
-	return (struct fd_prepare){
-		.err = fd < 0 ? fd : 0,
-		.__fd = fd,
-		.__file = file,
-	};
+	return (struct fd_prepare){ .fd = fd, .file = file };
 }
 
 /*
@@ -191,35 +175,39 @@ static __always_inline struct fd_prepare __fd_prepare(int fd, struct file *file)
  * was allocated. If fd_publish() was called the fd and file are
  * published and cleanup becomes a nop.
  *
- * @_fdf: name of struct fd_prepare variable to define
+ * @_fdf: name of the const struct fd_prepare pointer to define
  * @_fd_flags: flags for get_unused_fd_flags()
  * @_file_owned: struct file to take ownership of (can be expression)
  */
-#define FD_PREPARE(_fdf, _fd_flags, _file_owned)			\
-	struct fd_prepare _fdf __cleanup(__fd_prepare_cleanup) = ({	\
+#define __FD_PREPARE(_guard, _fdf, _fd_flags, _file_owned)		\
+	struct fd_prepare _guard __cleanup(__fd_prepare_cleanup) = ({	\
 		int __fd = get_unused_fd_flags(_fd_flags);		\
 		__fd_prepare(__fd, __fd < 0 ? NULL : (_file_owned));	\
-	})
+	});								\
+	const struct fd_prepare *const _fdf = &_guard
 
-/* Do not use directly. */
-static __always_inline int __fd_publish(struct fd_prepare *fdf)
-{
-	VFS_WARN_ON_ONCE(fdf->__fd < 0);
-	fd_install(fdf->__fd, fdf->__file);
-	return take_fd(fdf->__fd);
-}
+#define FD_PREPARE(_fdf, _fd_flags, _file_owned) \
+	__FD_PREPARE(__UNIQUE_ID(fd_prepare), _fdf, _fd_flags, _file_owned)
 
 /*
  * fd_publish - Publish prepared fd and file to the fd table.
- * @_fdf: struct fd_prepare variable
+ * @fdf: struct fd_prepare pointer defined by FD_PREPARE()
  */
-#define fd_publish(_fdf) __fd_publish(&(_fdf))
+static __always_inline int fd_publish(const struct fd_prepare *fdf)
+{
+	/* Callers only get a const view, the guard itself is writable. */
+	struct fd_prepare *guard = (struct fd_prepare *)fdf;
+
+	VFS_WARN_ON_ONCE(guard->fd < 0);
+	fd_install(guard->fd, guard->file);
+	return take_fd(guard->fd);
+}
 
 /* Do not use directly. */
 #define __FD_ADD(_fdf, _fd_flags, _file_owned)			\
 	({							\
 		FD_PREPARE(_fdf, _fd_flags, _file_owned);	\
-		_fdf.err ?: fd_publish(_fdf);			\
+		_fdf->fd < 0 ? _fdf->fd : fd_publish(_fdf);	\
 	})
 
 /*
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index b318ed697998..9f0b4d850c12 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -257,17 +257,17 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	FD_PREPARE(fdf, O_RDWR | O_CLOEXEC,
 		   anon_inode_create_getfile("[io_uring_mock]", fops, mf,
 					     O_RDWR | O_CLOEXEC, NULL));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	retain_and_null_ptr(mf);
-	file = fd_prepare_file(fdf);
+	file = fdf->file;
 	file->f_mode |= FMODE_READ | FMODE_CAN_READ | FMODE_WRITE |
 			FMODE_CAN_WRITE | FMODE_LSEEK;
 	if (mc.flags & IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
 		file->f_mode |= FMODE_NOWAIT;
 
-	mc.out_fd = fd_prepare_fd(fdf);
+	mc.out_fd = fdf->fd;
 	if (copy_to_user(uarg, &mc, uarg_size))
 		return -EFAULT;
 
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 14a5fdfa0421..5f790d12f72e 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -643,11 +643,11 @@ int bpf_iter_new_fd(struct bpf_link *link)
 	flags = O_RDONLY | O_CLOEXEC;
 
 	FD_PREPARE(fdf, flags, anon_inode_getfile("bpf_iter", &bpf_iter_fops, NULL, flags));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	iter_link = container_of(link, struct bpf_iter_link, link);
-	err = prepare_seq_file(fd_prepare_file(fdf), iter_link);
+	err = prepare_seq_file(fdf->file, iter_link);
 	if (err)
 		return err; /* Automatic cleanup handles fput */
 
diff --git a/kernel/bpf/token.c b/kernel/bpf/token.c
index e85a179523f0..da915a4f972b 100644
--- a/kernel/bpf/token.c
+++ b/kernel/bpf/token.c
@@ -169,8 +169,8 @@ int bpf_token_create(union bpf_attr *attr)
 	FD_PREPARE(fdf, O_CLOEXEC,
 		   alloc_file_pseudo(inode, path.mnt, BPF_TOKEN_INODE_NAME,
 				     O_RDWR, &bpf_token_fops));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	token = kzalloc_obj(*token, GFP_USER);
 	if (!token)
@@ -190,7 +190,7 @@ int bpf_token_create(union bpf_attr *attr)
 		return err;
 
 	get_user_ns(token->userns);
-	fd_prepare_file(fdf)->private_data = no_free_ptr(token);
+	fdf->file->private_data = no_free_ptr(token);
 	return fd_publish(fdf);
 }
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 23fb68fce000..ea382aedfc90 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -4809,12 +4809,12 @@ static int new_userfaultfd(int flags)
 		   anon_inode_create_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
 					     O_RDONLY | (flags & UFFD_SHARED_FCNTL_FLAGS),
 					     NULL));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
 	/* prevent the mm struct to be freed */
 	mmgrab(ctx->mm);
-	fd_prepare_file(fdf)->f_mode |= FMODE_NOWAIT;
+	fdf->file->f_mode |= FMODE_NOWAIT;
 	retain_and_null_ptr(ctx);
 	return fd_publish(fdf);
 }
diff --git a/net/core/scm.c b/net/core/scm.c
index f0d44ecdb11f..15c330784a69 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -364,14 +364,14 @@ int scm_recv_one_fd(struct file *f, int __user *ufd, unsigned int flags,
 		return notrunc ? put_user(error, ufd) : error;
 
 	FD_PREPARE(fdf, flags, get_file(f));
-	if (fdf.err)
-		return fdf.err;
+	if (fdf->fd < 0)
+		return fdf->fd;
 
-	error = put_user(fd_prepare_fd(fdf), ufd);
+	error = put_user(fdf->fd, ufd);
 	if (error)
 		return error;
 
-	__receive_sock(fd_prepare_file(fdf));
+	__receive_sock(fdf->file);
 	return fd_publish(fdf);
 }
 
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 3fd4fef9bab1..73b8314d9010 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -107,17 +107,17 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	req = handshake_req_next(hn, class);
 	if (req) {
 		FD_PREPARE(fdf, O_CLOEXEC, req->hr_file);
-		if (fdf.err) {
+		if (fdf->fd < 0) {
 			fput(req->hr_file); /* drop ref from handshake_req_next() */
-			err = fdf.err;
+			err = fdf->fd;
 			goto out_complete;
 		}
 
-		err = req->hr_proto->hp_accept(req, info, fd_prepare_fd(fdf));
+		err = req->hr_proto->hp_accept(req, info, fdf->fd);
 		if (err)
 			goto out_complete; /* Automatic cleanup handles fput */
 
-		trace_handshake_cmd_accept(net, req, req->hr_sk, fd_prepare_fd(fdf));
+		trace_handshake_cmd_accept(net, req, req->hr_sk, fdf->fd);
 		fd_publish(fdf);
 		return 0;
 	}
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 71af69d442f2..962ee2c4acd2 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1580,10 +1580,10 @@ static int kcm_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		struct kcm_clone info;
 
 		FD_PREPARE(fdf, 0, kcm_clone(sock));
-		if (fdf.err)
-			return fdf.err;
+		if (fdf->fd < 0)
+			return fdf->fd;
 
-		info.fd = fd_prepare_fd(fdf);
+		info.fd = fdf->fd;
 		if (copy_to_user((void __user *)arg, &info, sizeof(info)))
 			return -EFAULT;
 

-- 
2.53.0

