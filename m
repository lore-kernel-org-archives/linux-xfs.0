Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF6D67F3F
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 10:25:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B604AC005
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:25:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6HwrDbgY3mFfhrf1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:24:55 -0700 (PDT)
Subject: [RFC PATCH 1/2] VFS: Kill use of O_LARGEFILE inside the kernel
From: David Howells <dhowells@redhat.com>
Date: Tue, 22 Sep 2015 16:24:50 +0100
Message-ID: <20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

We don't need to use O_LARGEFILE anymore inside the kernel and can for the
most part just let it sit in the UAPI headers and ignore it everywhere else.
Indeed on 64-bit arches, we enforce the use of O_LARGEFILE.

Quite a few places turn it on, but only the following places actually take
any notice of it directly:

 (1) fs/9p/vfs_inode_dotl.c.  Converts O_LARGEFILE to P9_DOTL_LARGEFILE but
     otherwise seems to ignore it.  Possibly it gets sent to a server.

 (2) fs/notify/fanotify/fanotify_user.c.  Pass in event_f_flags.

 (3) fs/hfsplus/inode.c.  Length check in hfsplus_file_open().

 (4) fs/open.c:  Length check in ftruncate().

 (5) fs/open.c:  Length check in generic_file_open().

 (6) fs/xfs/xfs_file.c:  Length check in xfs_file_open().

 (7) mm/filemap.c:  Length check in generic_write_checks().

All but the first two are just making length checks that are waived
unconditionally on a 64-bit system.  Just skip the length checks, assuming
that O_LARGEFILE is actually set.

There's also things like fcntl(F_GETFL) and fuse that pass it to userspace.
NFS may be in the same boat, but if it is, I can't see where the
flag->protocol translation takes place for it.  For F_GETFL, fuse and
fanotify, just set it unconditionally in the places that then pass it to
userspace.

We don't actually then set it in file->f_flags - except when userspace
passes it in - since nothing then examines the bit in f_flags.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c                        |    9 +++------
 fs/fcntl.c                         |    2 +-
 fs/fhandle.c                       |    8 +-------
 fs/fuse/file.c                     |    7 ++++---
 fs/hfsplus/inode.c                 |    2 --
 fs/notify/fanotify/fanotify_user.c |    3 +--
 fs/open.c                          |   28 ++++------------------------
 fs/xfs/xfs_file.c                  |    2 --
 fs/xfs/xfs_ioctl.c                 |    4 ----
 mm/filemap.c                       |   10 ----------
 10 files changed, 14 insertions(+), 61 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6fd272d455e4..51579f09a135 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1084,8 +1084,7 @@ COMPAT_SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 #endif /* __ARCH_WANT_COMPAT_SYS_GETDENTS64 */
 
 /*
- * Exactly like fs/open.c:sys_open(), except that it doesn't set the
- * O_LARGEFILE flag.
+ * Exactly like fs/open.c:sys_open().
  */
 COMPAT_SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 {
@@ -1093,8 +1092,7 @@ COMPAT_SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t,
 }
 
 /*
- * Exactly like fs/open.c:sys_openat(), except that it doesn't set the
- * O_LARGEFILE flag.
+ * Exactly like fs/open.c:sys_openat().
  */
 COMPAT_SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags, umode_t, mode)
 {
@@ -1470,8 +1468,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
 
 #ifdef CONFIG_FHANDLE
 /*
- * Exactly like fs/open.c:sys_open_by_handle_at(), except that it
- * doesn't set the O_LARGEFILE flag.
+ * Exactly like fs/open.c:sys_open_by_handle_at().
  */
 COMPAT_SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
 			     struct file_handle __user *, handle, int, flags)
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ee85cd4e136a..a7a8e07e0d59 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -260,7 +260,7 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		set_close_on_exec(fd, arg & FD_CLOEXEC);
 		break;
 	case F_GETFL:
-		err = filp->f_flags;
+		err = filp->f_flags | O_LARGEFILE;
 		break;
 	case F_SETFL:
 		err = setfl(fd, filp, arg);
diff --git a/fs/fhandle.c b/fs/fhandle.c
index d59712dfa3e7..93948172d186 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -256,11 +256,5 @@ SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
 		struct file_handle __user *, handle,
 		int, flags)
 {
-	long ret;
-
-	if (force_o_largefile())
-		flags |= O_LARGEFILE;
-
-	ret = do_handle_open(mountdirfd, handle, flags);
-	return ret;
+	return do_handle_open(mountdirfd, handle, flags);
 }
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f523f2f04c19..680bcbb9613b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -28,6 +28,7 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
+	inarg.flags |= O_LARGEFILE;
 	if (!fc->atomic_o_trunc)
 		inarg.flags &= ~O_TRUNC;
 	args.in.h.opcode = opcode;
@@ -235,7 +236,7 @@ static void fuse_prepare_release(struct fuse_file *ff, int flags, int opcode)
 	wake_up_interruptible_all(&ff->poll_wait);
 
 	inarg->fh = ff->fh;
-	inarg->flags = flags;
+	inarg->flags = flags | O_LARGEFILE;
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = ff->nodeid;
 	req->in.numargs = 1;
@@ -505,7 +506,7 @@ void fuse_read_fill(struct fuse_req *req, struct file *file, loff_t pos,
 	inarg->fh = ff->fh;
 	inarg->offset = pos;
 	inarg->size = count;
-	inarg->flags = file->f_flags;
+	inarg->flags = file->f_flags | O_LARGEFILE;
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = ff->nodeid;
 	req->in.numargs = 1;
@@ -947,7 +948,7 @@ static size_t fuse_send_write(struct fuse_req *req, struct fuse_io_priv *io,
 	struct fuse_write_in *inarg = &req->misc.write.in;
 
 	fuse_write_fill(req, ff, pos, count);
-	inarg->flags = file->f_flags;
+	inarg->flags = file->f_flags | O_LARGEFILE;
 	if (owner != NULL) {
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 6dd107d7421e..0d73a3732532 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -216,8 +216,6 @@ static int hfsplus_file_open(struct inode *inode, struct file *file)
 {
 	if (HFSPLUS_IS_RSRC(inode))
 		inode = HFSPLUS_I(inode)->rsrc_inode;
-	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EOVERFLOW;
 	atomic_inc(&HFSPLUS_I(inode)->opencnt);
 	return 0;
 }
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8e8e6bcd1d43..eaf202ef3d99 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -748,8 +748,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	}
 	group->overflow_event = &oevent->fse;
 
-	if (force_o_largefile())
-		event_f_flags |= O_LARGEFILE;
+	event_f_flags |= O_LARGEFILE;
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	spin_lock_init(&group->fanotify_data.access_lock);
diff --git a/fs/open.c b/fs/open.c
index b6f1e96a7c0b..d1fbb8ee69f6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -151,7 +151,7 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
 }
 #endif
 
-static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+static long do_sys_ftruncate(unsigned int fd, loff_t length)
 {
 	struct inode *inode;
 	struct dentry *dentry;
@@ -166,21 +166,12 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (!f.file)
 		goto out;
 
-	/* explicitly opened as large or we are on 64-bit box */
-	if (f.file->f_flags & O_LARGEFILE)
-		small = 0;
-
 	dentry = f.file->f_path.dentry;
 	inode = dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
 		goto out_putf;
 
-	error = -EINVAL;
-	/* Cannot ftruncate over 2^31 bytes without large file support */
-	if (small && length > MAX_NON_LFS)
-		goto out_putf;
-
 	error = -EPERM;
 	if (IS_APPEND(inode))
 		goto out_putf;
@@ -200,13 +191,13 @@ out:
 
 SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
 {
-	return do_sys_ftruncate(fd, length, 1);
+	return do_sys_ftruncate(fd, length);
 }
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(ftruncate, unsigned int, fd, compat_ulong_t, length)
 {
-	return do_sys_ftruncate(fd, length, 1);
+	return do_sys_ftruncate(fd, length);
 }
 #endif
 
@@ -219,7 +210,7 @@ SYSCALL_DEFINE2(truncate64, const char __user *, path, loff_t, length)
 
 SYSCALL_DEFINE2(ftruncate64, unsigned int, fd, loff_t, length)
 {
-	return do_sys_ftruncate(fd, length, 0);
+	return do_sys_ftruncate(fd, length);
 }
 #endif /* BITS_PER_LONG == 32 */
 
@@ -1037,18 +1028,12 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 {
-	if (force_o_largefile())
-		flags |= O_LARGEFILE;
-
 	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
 
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 		umode_t, mode)
 {
-	if (force_o_largefile())
-		flags |= O_LARGEFILE;
-
 	return do_sys_open(dfd, filename, flags, mode);
 }
 
@@ -1126,14 +1111,9 @@ SYSCALL_DEFINE0(vhangup)
 
 /*
  * Called when an inode is about to be open.
- * We use this to disallow opening large files on 32bit systems if
- * the caller didn't specify O_LARGEFILE.  On 64bit systems we force
- * on this flag in sys_open.
  */
 int generic_file_open(struct inode * inode, struct file * filp)
 {
-	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EOVERFLOW;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e78feb400e22..7c8d9b4e44eb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1031,8 +1031,6 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
-	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EFBIG;
 	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
 		return -EIO;
 	return 0;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea7d85af5310..0c5b4ae746c0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -218,10 +218,6 @@ xfs_open_by_handle(
 		goto out_dput;
 	}
 
-#if BITS_PER_LONG != 32
-	hreq->oflags |= O_LARGEFILE;
-#endif
-
 	permflag = hreq->oflags;
 	fmode = OPEN_FMODE(permflag);
 	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
diff --git a/mm/filemap.c b/mm/filemap.c
index 72940fb38666..1d1e75aa49cf 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2311,16 +2311,6 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/*
-	 * LFS rule
-	 */
-	if (unlikely(pos + iov_iter_count(from) > MAX_NON_LFS &&
-				!(file->f_flags & O_LARGEFILE))) {
-		if (pos >= MAX_NON_LFS)
-			return -EFBIG;
-		iov_iter_truncate(from, MAX_NON_LFS - (unsigned long)pos);
-	}
-
-	/*
 	 * Are we about to exceed the fs block limit ?
 	 *
 	 * If we have written data it becomes a short write.  If we have

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
