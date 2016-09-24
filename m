Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57200 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbcIXEBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 00:01:53 -0400
Date: Sat, 24 Sep 2016 05:01:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 11/12] switch generic_file_splice_read() to use of
 ->read_iter()
Message-ID: <20160924040150.GQ2356@ZenIV.linux.org.uk>
References: <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

... and kill the ->splice_read() instances that can be switched to it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/staging/lustre/lustre/llite/file.c         |  70 ++----
 .../staging/lustre/lustre/llite/llite_internal.h   |  15 +-
 drivers/staging/lustre/lustre/llite/vvp_internal.h |  14 --
 drivers/staging/lustre/lustre/llite/vvp_io.c       |  45 +---
 fs/coda/file.c                                     |  23 +-
 fs/gfs2/file.c                                     |  28 +--
 fs/nfs/file.c                                      |  25 +--
 fs/nfs/internal.h                                  |   2 -
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/ocfs2/file.c                                    |  34 +--
 fs/ocfs2/ocfs2_trace.h                             |   2 -
 fs/splice.c                                        | 244 +++------------------
 fs/xfs/xfs_file.c                                  |  41 +---
 fs/xfs/xfs_trace.h                                 |   1 -
 include/linux/fs.h                                 |   2 -
 mm/shmem.c                                         | 115 +---------
 16 files changed, 58 insertions(+), 605 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 57281b9..2567b09 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1153,36 +1153,21 @@ restart:
 		int write_mutex_locked = 0;
 
 		vio->vui_fd  = LUSTRE_FPRIVATE(file);
-		vio->vui_io_subtype = args->via_io_subtype;
-
-		switch (vio->vui_io_subtype) {
-		case IO_NORMAL:
-			vio->vui_iter = args->u.normal.via_iter;
-			vio->vui_iocb = args->u.normal.via_iocb;
-			if ((iot == CIT_WRITE) &&
-			    !(vio->vui_fd->fd_flags & LL_FILE_GROUP_LOCKED)) {
-				if (mutex_lock_interruptible(&lli->
-							       lli_write_mutex)) {
-					result = -ERESTARTSYS;
-					goto out;
-				}
-				write_mutex_locked = 1;
+		vio->vui_iter = args->u.normal.via_iter;
+		vio->vui_iocb = args->u.normal.via_iocb;
+		if ((iot == CIT_WRITE) &&
+		    !(vio->vui_fd->fd_flags & LL_FILE_GROUP_LOCKED)) {
+			if (mutex_lock_interruptible(&lli->lli_write_mutex)) {
+				result = -ERESTARTSYS;
+				goto out;
 			}
-			down_read(&lli->lli_trunc_sem);
-			break;
-		case IO_SPLICE:
-			vio->u.splice.vui_pipe = args->u.splice.via_pipe;
-			vio->u.splice.vui_flags = args->u.splice.via_flags;
-			break;
-		default:
-			CERROR("Unknown IO type - %u\n", vio->vui_io_subtype);
-			LBUG();
+			write_mutex_locked = 1;
 		}
+		down_read(&lli->lli_trunc_sem);
 		ll_cl_add(file, env, io);
 		result = cl_io_loop(env, io);
 		ll_cl_remove(file, env);
-		if (args->via_io_subtype == IO_NORMAL)
-			up_read(&lli->lli_trunc_sem);
+		up_read(&lli->lli_trunc_sem);
 		if (write_mutex_locked)
 			mutex_unlock(&lli->lli_write_mutex);
 	} else {
@@ -1237,7 +1222,7 @@ static ssize_t ll_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (IS_ERR(env))
 		return PTR_ERR(env);
 
-	args = ll_env_args(env, IO_NORMAL);
+	args = ll_env_args(env);
 	args->u.normal.via_iter = to;
 	args->u.normal.via_iocb = iocb;
 
@@ -1261,7 +1246,7 @@ static ssize_t ll_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (IS_ERR(env))
 		return PTR_ERR(env);
 
-	args = ll_env_args(env, IO_NORMAL);
+	args = ll_env_args(env);
 	args->u.normal.via_iter = from;
 	args->u.normal.via_iocb = iocb;
 
@@ -1271,31 +1256,6 @@ static ssize_t ll_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return result;
 }
 
-/*
- * Send file content (through pagecache) somewhere with helper
- */
-static ssize_t ll_file_splice_read(struct file *in_file, loff_t *ppos,
-				   struct pipe_inode_info *pipe, size_t count,
-				   unsigned int flags)
-{
-	struct lu_env      *env;
-	struct vvp_io_args *args;
-	ssize_t	     result;
-	int		 refcheck;
-
-	env = cl_env_get(&refcheck);
-	if (IS_ERR(env))
-		return PTR_ERR(env);
-
-	args = ll_env_args(env, IO_SPLICE);
-	args->u.splice.via_pipe = pipe;
-	args->u.splice.via_flags = flags;
-
-	result = ll_file_io_generic(env, args, in_file, CIT_READ, ppos, count);
-	cl_env_put(env, &refcheck);
-	return result;
-}
-
 static int ll_lov_recreate(struct inode *inode, struct ost_id *oi, u32 ost_idx)
 {
 	struct obd_export *exp = ll_i2dtexp(inode);
@@ -3173,7 +3133,7 @@ struct file_operations ll_file_operations = {
 	.release	= ll_file_release,
 	.mmap	   = ll_file_mmap,
 	.llseek	 = ll_file_seek,
-	.splice_read    = ll_file_splice_read,
+	.splice_read    = generic_file_splice_read,
 	.fsync	  = ll_fsync,
 	.flush	  = ll_flush
 };
@@ -3186,7 +3146,7 @@ struct file_operations ll_file_operations_flock = {
 	.release	= ll_file_release,
 	.mmap	   = ll_file_mmap,
 	.llseek	 = ll_file_seek,
-	.splice_read    = ll_file_splice_read,
+	.splice_read    = generic_file_splice_read,
 	.fsync	  = ll_fsync,
 	.flush	  = ll_flush,
 	.flock	  = ll_file_flock,
@@ -3202,7 +3162,7 @@ struct file_operations ll_file_operations_noflock = {
 	.release	= ll_file_release,
 	.mmap	   = ll_file_mmap,
 	.llseek	 = ll_file_seek,
-	.splice_read    = ll_file_splice_read,
+	.splice_read    = generic_file_splice_read,
 	.fsync	  = ll_fsync,
 	.flush	  = ll_flush,
 	.flock	  = ll_file_noflock,
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 4d6d589..0e738c8 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -800,17 +800,11 @@ void vvp_write_complete(struct vvp_object *club, struct vvp_page *page);
  */
 struct vvp_io_args {
 	/** normal/splice */
-	enum vvp_io_subtype via_io_subtype;
-
 	union {
 		struct {
 			struct kiocb      *via_iocb;
 			struct iov_iter   *via_iter;
 		} normal;
-		struct {
-			struct pipe_inode_info  *via_pipe;
-			unsigned int       via_flags;
-		} splice;
 	} u;
 };
 
@@ -838,14 +832,9 @@ static inline struct ll_thread_info *ll_env_info(const struct lu_env *env)
 	return lti;
 }
 
-static inline struct vvp_io_args *ll_env_args(const struct lu_env *env,
-					      enum vvp_io_subtype type)
+static inline struct vvp_io_args *ll_env_args(const struct lu_env *env)
 {
-	struct vvp_io_args *via = &ll_env_info(env)->lti_args;
-
-	via->via_io_subtype = type;
-
-	return via;
+	return &ll_env_info(env)->lti_args;
 }
 
 void ll_queue_done_writing(struct inode *inode, unsigned long flags);
diff --git a/drivers/staging/lustre/lustre/llite/vvp_internal.h b/drivers/staging/lustre/lustre/llite/vvp_internal.h
index 79fc428..2fa49cc 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_internal.h
+++ b/drivers/staging/lustre/lustre/llite/vvp_internal.h
@@ -49,14 +49,6 @@ struct obd_device;
 struct obd_export;
 struct page;
 
-/* specific architecture can implement only part of this list */
-enum vvp_io_subtype {
-	/** normal IO */
-	IO_NORMAL,
-	/** io started from splice_{read|write} */
-	IO_SPLICE
-};
-
 /**
  * IO state private to IO state private to VVP layer.
  */
@@ -99,10 +91,6 @@ struct vvp_io {
 			bool		ft_flags_valid;
 		} fault;
 		struct {
-			struct pipe_inode_info	*vui_pipe;
-			unsigned int		 vui_flags;
-		} splice;
-		struct {
 			struct cl_page_list vui_queue;
 			unsigned long vui_written;
 			int vui_from;
@@ -110,8 +98,6 @@ struct vvp_io {
 		} write;
 	} u;
 
-	enum vvp_io_subtype	vui_io_subtype;
-
 	/**
 	 * Layout version when this IO is initialized
 	 */
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 94916dc..4864600 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -55,18 +55,6 @@ static struct vvp_io *cl2vvp_io(const struct lu_env *env,
 }
 
 /**
- * True, if \a io is a normal io, False for splice_{read,write}
- */
-static int cl_is_normalio(const struct lu_env *env, const struct cl_io *io)
-{
-	struct vvp_io *vio = vvp_env_io(env);
-
-	LASSERT(io->ci_type == CIT_READ || io->ci_type == CIT_WRITE);
-
-	return vio->vui_io_subtype == IO_NORMAL;
-}
-
-/**
  * For swapping layout. The file's layout may have changed.
  * To avoid populating pages to a wrong stripe, we have to verify the
  * correctness of layout. It works because swapping layout processes
@@ -391,9 +379,6 @@ static int vvp_mmap_locks(const struct lu_env *env,
 
 	LASSERT(io->ci_type == CIT_READ || io->ci_type == CIT_WRITE);
 
-	if (!cl_is_normalio(env, io))
-		return 0;
-
 	if (!vio->vui_iter) /* nfs or loop back device write */
 		return 0;
 
@@ -462,15 +447,10 @@ static void vvp_io_advance(const struct lu_env *env,
 			   const struct cl_io_slice *ios,
 			   size_t nob)
 {
-	struct vvp_io    *vio = cl2vvp_io(env, ios);
-	struct cl_io     *io  = ios->cis_io;
 	struct cl_object *obj = ios->cis_io->ci_obj;
-
+	struct vvp_io	 *vio = cl2vvp_io(env, ios);
 	CLOBINVRNT(env, obj, vvp_object_invariant(obj));
 
-	if (!cl_is_normalio(env, io))
-		return;
-
 	iov_iter_reexpand(vio->vui_iter, vio->vui_tot_count  -= nob);
 }
 
@@ -479,7 +459,7 @@ static void vvp_io_update_iov(const struct lu_env *env,
 {
 	size_t size = io->u.ci_rw.crw_count;
 
-	if (!cl_is_normalio(env, io) || !vio->vui_iter)
+	if (!vio->vui_iter)
 		return;
 
 	iov_iter_truncate(vio->vui_iter, size);
@@ -716,25 +696,8 @@ static int vvp_io_read_start(const struct lu_env *env,
 
 	/* BUG: 5972 */
 	file_accessed(file);
-	switch (vio->vui_io_subtype) {
-	case IO_NORMAL:
-		LASSERT(vio->vui_iocb->ki_pos == pos);
-		result = generic_file_read_iter(vio->vui_iocb, vio->vui_iter);
-		break;
-	case IO_SPLICE:
-		result = generic_file_splice_read(file, &pos,
-						  vio->u.splice.vui_pipe, cnt,
-						  vio->u.splice.vui_flags);
-		/* LU-1109: do splice read stripe by stripe otherwise if it
-		 * may make nfsd stuck if this read occupied all internal pipe
-		 * buffers.
-		 */
-		io->ci_continue = 0;
-		break;
-	default:
-		CERROR("Wrong IO type %u\n", vio->vui_io_subtype);
-		LBUG();
-	}
+	LASSERT(vio->vui_iocb->ki_pos == pos);
+	result = generic_file_read_iter(vio->vui_iocb, vio->vui_iter);
 
 out:
 	if (result >= 0) {
diff --git a/fs/coda/file.c b/fs/coda/file.c
index f47c748..8415d4f 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -38,27 +38,6 @@ coda_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 }
 
 static ssize_t
-coda_file_splice_read(struct file *coda_file, loff_t *ppos,
-		      struct pipe_inode_info *pipe, size_t count,
-		      unsigned int flags)
-{
-	ssize_t (*splice_read)(struct file *, loff_t *,
-			       struct pipe_inode_info *, size_t, unsigned int);
-	struct coda_file_info *cfi;
-	struct file *host_file;
-
-	cfi = CODA_FTOC(coda_file);
-	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
-	host_file = cfi->cfi_container;
-
-	splice_read = host_file->f_op->splice_read;
-	if (!splice_read)
-		splice_read = default_file_splice_read;
-
-	return splice_read(host_file, ppos, pipe, count, flags);
-}
-
-static ssize_t
 coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *coda_file = iocb->ki_filp;
@@ -225,6 +204,6 @@ const struct file_operations coda_file_operations = {
 	.open		= coda_open,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
-	.splice_read	= coda_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 };
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 320e65e..7016a6a7 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -954,30 +954,6 @@ out_uninit:
 	return ret;
 }
 
-static ssize_t gfs2_file_splice_read(struct file *in, loff_t *ppos,
-				     struct pipe_inode_info *pipe, size_t len,
-				     unsigned int flags)
-{
-	struct inode *inode = in->f_mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
-	int ret;
-
-	inode_lock(inode);
-
-	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	if (ret) {
-		inode_unlock(inode);
-		return ret;
-	}
-
-	gfs2_glock_dq_uninit(&gh);
-	inode_unlock(inode);
-
-	return generic_file_splice_read(in, ppos, pipe, len, flags);
-}
-
-
 static ssize_t gfs2_file_splice_write(struct pipe_inode_info *pipe,
 				      struct file *out, loff_t *ppos,
 				      size_t len, unsigned int flags)
@@ -1140,7 +1116,7 @@ const struct file_operations gfs2_file_fops = {
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
 	.flock		= gfs2_flock,
-	.splice_read	= gfs2_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= gfs2_file_splice_write,
 	.setlease	= simple_nosetlease,
 	.fallocate	= gfs2_fallocate,
@@ -1168,7 +1144,7 @@ const struct file_operations gfs2_file_fops_nolock = {
 	.open		= gfs2_open,
 	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
-	.splice_read	= gfs2_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= gfs2_file_splice_write,
 	.setlease	= generic_setlease,
 	.fallocate	= gfs2_fallocate,
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 7d62097..5048585 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -182,29 +182,6 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 }
 EXPORT_SYMBOL_GPL(nfs_file_read);
 
-ssize_t
-nfs_file_splice_read(struct file *filp, loff_t *ppos,
-		     struct pipe_inode_info *pipe, size_t count,
-		     unsigned int flags)
-{
-	struct inode *inode = file_inode(filp);
-	ssize_t res;
-
-	dprintk("NFS: splice_read(%pD2, %lu@%Lu)\n",
-		filp, (unsigned long) count, (unsigned long long) *ppos);
-
-	nfs_start_io_read(inode);
-	res = nfs_revalidate_mapping(inode, filp->f_mapping);
-	if (!res) {
-		res = generic_file_splice_read(filp, ppos, pipe, count, flags);
-		if (res > 0)
-			nfs_add_stats(inode, NFSIOS_NORMALREADBYTES, res);
-	}
-	nfs_end_io_read(inode);
-	return res;
-}
-EXPORT_SYMBOL_GPL(nfs_file_splice_read);
-
 int
 nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
 {
@@ -868,7 +845,7 @@ const struct file_operations nfs_file_operations = {
 	.fsync		= nfs_file_fsync,
 	.lock		= nfs_lock,
 	.flock		= nfs_flock,
-	.splice_read	= nfs_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.check_flags	= nfs_check_flags,
 	.setlease	= simple_nosetlease,
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 74935a1..d7b062b 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -365,8 +365,6 @@ int nfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *)
 int nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 loff_t nfs_file_llseek(struct file *, loff_t, int);
 ssize_t nfs_file_read(struct kiocb *, struct iov_iter *);
-ssize_t nfs_file_splice_read(struct file *, loff_t *, struct pipe_inode_info *,
-			     size_t, unsigned int);
 int nfs_file_mmap(struct file *, struct vm_area_struct *);
 ssize_t nfs_file_write(struct kiocb *, struct iov_iter *);
 int nfs_file_release(struct inode *, struct file *);
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index d085ad7..89a7795 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -248,7 +248,7 @@ const struct file_operations nfs4_file_operations = {
 	.fsync		= nfs_file_fsync,
 	.lock		= nfs_lock,
 	.flock		= nfs_flock,
-	.splice_read	= nfs_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.check_flags	= nfs_check_flags,
 	.setlease	= simple_nosetlease,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4e7b0dc..6596e41 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2307,36 +2307,6 @@ out_mutex:
 	return ret;
 }
 
-static ssize_t ocfs2_file_splice_read(struct file *in,
-				      loff_t *ppos,
-				      struct pipe_inode_info *pipe,
-				      size_t len,
-				      unsigned int flags)
-{
-	int ret = 0, lock_level = 0;
-	struct inode *inode = file_inode(in);
-
-	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			in->f_path.dentry->d_name.len,
-			in->f_path.dentry->d_name.name, len);
-
-	/*
-	 * See the comment in ocfs2_file_read_iter()
-	 */
-	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto bail;
-	}
-	ocfs2_inode_unlock(inode, lock_level);
-
-	ret = generic_file_splice_read(in, ppos, pipe, len, flags);
-
-bail:
-	return ret;
-}
-
 static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 				   struct iov_iter *to)
 {
@@ -2495,7 +2465,7 @@ const struct file_operations ocfs2_fops = {
 #endif
 	.lock		= ocfs2_lock,
 	.flock		= ocfs2_flock,
-	.splice_read	= ocfs2_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ocfs2_fallocate,
 };
@@ -2540,7 +2510,7 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
 	.flock		= ocfs2_flock,
-	.splice_read	= ocfs2_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ocfs2_fallocate,
 };
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index f8f5fc5..0b58abc 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1314,8 +1314,6 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_write);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_read);
-
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_read);
 
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
diff --git a/fs/splice.c b/fs/splice.c
index 589a1d5..58c322a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -281,207 +281,6 @@ void splice_shrink_spd(struct splice_pipe_desc *spd)
 	kfree(spd->partial);
 }
 
-static int
-__generic_file_splice_read(struct file *in, loff_t *ppos,
-			   struct pipe_inode_info *pipe, size_t len,
-			   unsigned int flags)
-{
-	struct address_space *mapping = in->f_mapping;
-	unsigned int loff, nr_pages, req_pages;
-	struct page *pages[PIPE_DEF_BUFFERS];
-	struct partial_page partial[PIPE_DEF_BUFFERS];
-	struct page *page;
-	pgoff_t index, end_index;
-	loff_t isize;
-	int error, page_nr;
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
-		.nr_pages_max = PIPE_DEF_BUFFERS,
-		.flags = flags,
-		.ops = &page_cache_pipe_buf_ops,
-		.spd_release = spd_release_page,
-	};
-
-	if (splice_grow_spd(pipe, &spd))
-		return -ENOMEM;
-
-	index = *ppos >> PAGE_SHIFT;
-	loff = *ppos & ~PAGE_MASK;
-	req_pages = (len + loff + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	nr_pages = min(req_pages, spd.nr_pages_max);
-
-	/*
-	 * Lookup the (hopefully) full range of pages we need.
-	 */
-	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, spd.pages);
-	index += spd.nr_pages;
-
-	/*
-	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * readahead/allocate the rest and fill in the holes.
-	 */
-	if (spd.nr_pages < nr_pages)
-		page_cache_sync_readahead(mapping, &in->f_ra, in,
-				index, req_pages - spd.nr_pages);
-
-	error = 0;
-	while (spd.nr_pages < nr_pages) {
-		/*
-		 * Page could be there, find_get_pages_contig() breaks on
-		 * the first hole.
-		 */
-		page = find_get_page(mapping, index);
-		if (!page) {
-			/*
-			 * page didn't exist, allocate one.
-			 */
-			page = page_cache_alloc_cold(mapping);
-			if (!page)
-				break;
-
-			error = add_to_page_cache_lru(page, mapping, index,
-				   mapping_gfp_constraint(mapping, GFP_KERNEL));
-			if (unlikely(error)) {
-				put_page(page);
-				if (error == -EEXIST)
-					continue;
-				break;
-			}
-			/*
-			 * add_to_page_cache() locks the page, unlock it
-			 * to avoid convoluting the logic below even more.
-			 */
-			unlock_page(page);
-		}
-
-		spd.pages[spd.nr_pages++] = page;
-		index++;
-	}
-
-	/*
-	 * Now loop over the map and see if we need to start IO on any
-	 * pages, fill in the partial map, etc.
-	 */
-	index = *ppos >> PAGE_SHIFT;
-	nr_pages = spd.nr_pages;
-	spd.nr_pages = 0;
-	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
-		unsigned int this_len;
-
-		if (!len)
-			break;
-
-		/*
-		 * this_len is the max we'll use from this page
-		 */
-		this_len = min_t(unsigned long, len, PAGE_SIZE - loff);
-		page = spd.pages[page_nr];
-
-		if (PageReadahead(page))
-			page_cache_async_readahead(mapping, &in->f_ra, in,
-					page, index, req_pages - page_nr);
-
-		/*
-		 * If the page isn't uptodate, we may need to start io on it
-		 */
-		if (!PageUptodate(page)) {
-			lock_page(page);
-
-			/*
-			 * Page was truncated, or invalidated by the
-			 * filesystem.  Redo the find/create, but this time the
-			 * page is kept locked, so there's no chance of another
-			 * race with truncate/invalidate.
-			 */
-			if (!page->mapping) {
-				unlock_page(page);
-retry_lookup:
-				page = find_or_create_page(mapping, index,
-						mapping_gfp_mask(mapping));
-
-				if (!page) {
-					error = -ENOMEM;
-					break;
-				}
-				put_page(spd.pages[page_nr]);
-				spd.pages[page_nr] = page;
-			}
-			/*
-			 * page was already under io and is now done, great
-			 */
-			if (PageUptodate(page)) {
-				unlock_page(page);
-				goto fill_it;
-			}
-
-			/*
-			 * need to read in the page
-			 */
-			error = mapping->a_ops->readpage(in, page);
-			if (unlikely(error)) {
-				/*
-				 * Re-lookup the page
-				 */
-				if (error == AOP_TRUNCATED_PAGE)
-					goto retry_lookup;
-
-				break;
-			}
-		}
-fill_it:
-		/*
-		 * i_size must be checked after PageUptodate.
-		 */
-		isize = i_size_read(mapping->host);
-		end_index = (isize - 1) >> PAGE_SHIFT;
-		if (unlikely(!isize || index > end_index))
-			break;
-
-		/*
-		 * if this is the last page, see if we need to shrink
-		 * the length and stop
-		 */
-		if (end_index == index) {
-			unsigned int plen;
-
-			/*
-			 * max good bytes in this page
-			 */
-			plen = ((isize - 1) & ~PAGE_MASK) + 1;
-			if (plen <= loff)
-				break;
-
-			/*
-			 * force quit after adding this page
-			 */
-			this_len = min(this_len, plen - loff);
-			len = this_len;
-		}
-
-		spd.partial[page_nr].offset = loff;
-		spd.partial[page_nr].len = this_len;
-		len -= this_len;
-		loff = 0;
-		spd.nr_pages++;
-		index++;
-	}
-
-	/*
-	 * Release any pages at the end, if we quit early. 'page_nr' is how far
-	 * we got, 'nr_pages' is how many pages are in the map.
-	 */
-	while (page_nr < nr_pages)
-		put_page(spd.pages[page_nr++]);
-	in->f_ra.prev_pos = (loff_t)index << PAGE_SHIFT;
-
-	if (spd.nr_pages)
-		error = splice_to_pipe(pipe, &spd);
-
-	splice_shrink_spd(&spd);
-	return error;
-}
-
 /**
  * generic_file_splice_read - splice data from file to a pipe
  * @in:		file to splice from
@@ -492,32 +291,46 @@ fill_it:
  *
  * Description:
  *    Will read pages from given file and fill them into a pipe. Can be
- *    used as long as the address_space operations for the source implements
- *    a readpage() hook.
+ *    used as long as it has more or less sane ->read_iter().
  *
  */
 ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
-	loff_t isize, left;
-	int ret;
-
-	if (IS_DAX(in->f_mapping->host))
-		return default_file_splice_read(in, ppos, pipe, len, flags);
+	struct iov_iter to;
+	struct kiocb kiocb;
+	loff_t isize;
+	int idx, ret;
 
 	isize = i_size_read(in->f_mapping->host);
 	if (unlikely(*ppos >= isize))
 		return 0;
 
-	left = isize - *ppos;
-	if (unlikely(left < len))
-		len = left;
-
-	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
+	iov_iter_pipe(&to, ITER_PIPE | READ, pipe, len);
+	idx = to.idx;
+	init_sync_kiocb(&kiocb, in);
+	kiocb.ki_pos = *ppos;
+	ret = in->f_op->read_iter(&kiocb, &to);
 	if (ret > 0) {
-		*ppos += ret;
+		*ppos = kiocb.ki_pos;
 		file_accessed(in);
+	} else if (ret < 0) {
+		if (WARN_ON(to.idx != idx || to.iov_offset)) {
+			/*
+			 * a bogus ->read_iter() has copied something and still
+			 * returned an error instead of a short read.
+			 */
+			to.idx = idx;
+			to.iov_offset = 0;
+			iov_iter_advance(&to, 0); /* to free what was emitted */
+		}
+		/*
+		 * callers of ->splice_read() expect -EAGAIN on
+		 * "can't put anything in there", rather than -EFAULT.
+		 */
+		if (ret == -EFAULT)
+			ret = -EAGAIN;
 	}
 
 	return ret;
@@ -580,7 +393,7 @@ ssize_t kernel_write(struct file *file, const char *buf, size_t count,
 }
 EXPORT_SYMBOL(kernel_write);
 
-ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
+static ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
@@ -675,7 +488,6 @@ err:
 	res = error;
 	goto shrink_ret;
 }
-EXPORT_SYMBOL(default_file_splice_read);
 
 /*
  * Send 'sd->len' bytes to socket from 'sd->file' at position 'sd->pos'
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e612a02..92f16cf 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -399,45 +399,6 @@ xfs_file_read_iter(
 	return ret;
 }
 
-STATIC ssize_t
-xfs_file_splice_read(
-	struct file		*infilp,
-	loff_t			*ppos,
-	struct pipe_inode_info	*pipe,
-	size_t			count,
-	unsigned int		flags)
-{
-	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
-	ssize_t			ret;
-
-	XFS_STATS_INC(ip->i_mount, xs_read_calls);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
-
-	trace_xfs_file_splice_read(ip, count, *ppos);
-
-	/*
-	 * DAX inodes cannot ues the page cache for splice, so we have to push
-	 * them through the VFS IO path. This means it goes through
-	 * ->read_iter, which for us takes the XFS_IOLOCK_SHARED. Hence we
-	 * cannot lock the splice operation at this level for DAX inodes.
-	 */
-	if (IS_DAX(VFS_I(ip))) {
-		ret = default_file_splice_read(infilp, ppos, pipe, count,
-					       flags);
-		goto out;
-	}
-
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
-out:
-	if (ret > 0)
-		XFS_STATS_ADD(ip->i_mount, xs_read_bytes, ret);
-	return ret;
-}
-
 /*
  * Zero any on disk space between the current EOF and the new, larger EOF.
  *
@@ -1652,7 +1613,7 @@ const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read_iter	= xfs_file_read_iter,
 	.write_iter	= xfs_file_write_iter,
-	.splice_read	= xfs_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.unlocked_ioctl	= xfs_file_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d303a66..f31db44 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1170,7 +1170,6 @@ DEFINE_RW_EVENT(xfs_file_dax_read);
 DEFINE_RW_EVENT(xfs_file_buffered_write);
 DEFINE_RW_EVENT(xfs_file_direct_write);
 DEFINE_RW_EVENT(xfs_file_dax_write);
-DEFINE_RW_EVENT(xfs_file_splice_read);
 
 DECLARE_EVENT_CLASS(xfs_page_class,
 	TP_PROTO(struct inode *inode, struct page *page, unsigned long off,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 901e25d..b04883e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2794,8 +2794,6 @@ extern void block_sync_page(struct page *page);
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
-extern ssize_t default_file_splice_read(struct file *, loff_t *,
-		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
diff --git a/mm/shmem.c b/mm/shmem.c
index fd8b2b5..84d7077 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2310,119 +2310,6 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return retval ? retval : error;
 }
 
-static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
-				struct pipe_inode_info *pipe, size_t len,
-				unsigned int flags)
-{
-	struct address_space *mapping = in->f_mapping;
-	struct inode *inode = mapping->host;
-	unsigned int loff, nr_pages, req_pages;
-	struct page *pages[PIPE_DEF_BUFFERS];
-	struct partial_page partial[PIPE_DEF_BUFFERS];
-	struct page *page;
-	pgoff_t index, end_index;
-	loff_t isize, left;
-	int error, page_nr;
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
-		.nr_pages_max = PIPE_DEF_BUFFERS,
-		.flags = flags,
-		.ops = &page_cache_pipe_buf_ops,
-		.spd_release = spd_release_page,
-	};
-
-	isize = i_size_read(inode);
-	if (unlikely(*ppos >= isize))
-		return 0;
-
-	left = isize - *ppos;
-	if (unlikely(left < len))
-		len = left;
-
-	if (splice_grow_spd(pipe, &spd))
-		return -ENOMEM;
-
-	index = *ppos >> PAGE_SHIFT;
-	loff = *ppos & ~PAGE_MASK;
-	req_pages = (len + loff + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	nr_pages = min(req_pages, spd.nr_pages_max);
-
-	spd.nr_pages = find_get_pages_contig(mapping, index,
-						nr_pages, spd.pages);
-	index += spd.nr_pages;
-	error = 0;
-
-	while (spd.nr_pages < nr_pages) {
-		error = shmem_getpage(inode, index, &page, SGP_CACHE);
-		if (error)
-			break;
-		unlock_page(page);
-		spd.pages[spd.nr_pages++] = page;
-		index++;
-	}
-
-	index = *ppos >> PAGE_SHIFT;
-	nr_pages = spd.nr_pages;
-	spd.nr_pages = 0;
-
-	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
-		unsigned int this_len;
-
-		if (!len)
-			break;
-
-		this_len = min_t(unsigned long, len, PAGE_SIZE - loff);
-		page = spd.pages[page_nr];
-
-		if (!PageUptodate(page) || page->mapping != mapping) {
-			error = shmem_getpage(inode, index, &page, SGP_CACHE);
-			if (error)
-				break;
-			unlock_page(page);
-			put_page(spd.pages[page_nr]);
-			spd.pages[page_nr] = page;
-		}
-
-		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_SHIFT;
-		if (unlikely(!isize || index > end_index))
-			break;
-
-		if (end_index == index) {
-			unsigned int plen;
-
-			plen = ((isize - 1) & ~PAGE_MASK) + 1;
-			if (plen <= loff)
-				break;
-
-			this_len = min(this_len, plen - loff);
-			len = this_len;
-		}
-
-		spd.partial[page_nr].offset = loff;
-		spd.partial[page_nr].len = this_len;
-		len -= this_len;
-		loff = 0;
-		spd.nr_pages++;
-		index++;
-	}
-
-	while (page_nr < nr_pages)
-		put_page(spd.pages[page_nr++]);
-
-	if (spd.nr_pages)
-		error = splice_to_pipe(pipe, &spd);
-
-	splice_shrink_spd(&spd);
-
-	if (error > 0) {
-		*ppos += error;
-		file_accessed(in);
-	}
-	return error;
-}
-
 /*
  * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
  */
@@ -3785,7 +3672,7 @@ static const struct file_operations shmem_file_operations = {
 	.read_iter	= shmem_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.fsync		= noop_fsync,
-	.splice_read	= shmem_file_splice_read,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= shmem_fallocate,
 #endif
-- 
2.9.3

