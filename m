Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEE957F3F
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 10:25:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6EFF2AC00B
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:25:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uHIhqJ8oUCjCNvA4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:25:05 -0700 (PDT)
Subject: [RFC PATCH 2/2] VFS: Don't pass O_LARGEFILE when opening a file
	internally
From: David Howells <dhowells@redhat.com>
Date: Tue, 22 Sep 2015 16:25:00 +0100
Message-ID: <20150922152500.32539.4726.stgit@warthog.procyon.org.uk>
In-Reply-To: <20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
References: <20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
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

Don't pass O_LARGEFILE when opening a file internally within the kernel
because due to the preceeding commit, the flag is now assumed fixed on for
all arches, not just 64-bit ones.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/pci/cx25821/cx25821-audio-upstream.c |    4 ++--
 drivers/mtd/nand/nandsim.c                         |    2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    4 ++--
 drivers/target/target_core_file.c                  |    4 ++--
 drivers/usb/gadget/function/storage_common.c       |    4 ++--
 fs/block_dev.c                                     |    2 --
 fs/cachefiles/rdwr.c                               |    2 +-
 fs/coredump.c                                      |    3 +--
 fs/ecryptfs/kthread.c                              |    4 ++--
 fs/exec.c                                          |    4 ++--
 fs/nfsd/vfs.c                                      |    6 +++---
 kernel/acct.c                                      |    2 +-
 mm/shmem.c                                         |    2 +-
 mm/swapfile.c                                      |    4 ++--
 tools/lguest/lguest.c                              |    2 +-
 15 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 68dbc2dbc982..aa6011bb88cf 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -271,7 +271,7 @@ static int cx25821_get_audio_data(struct cx25821_dev *dev,
 	if (dev->_audiofile_status == END_OF_FILE)
 		return 0;
 
-	file = filp_open(dev->_audiofilename, O_RDONLY | O_LARGEFILE, 0);
+	file = filp_open(dev->_audiofilename, O_RDONLY, 0);
 	if (IS_ERR(file)) {
 		pr_err("%s(): ERROR opening file(%s) with errno = %ld!\n",
 		       __func__, dev->_audiofilename, -PTR_ERR(file));
@@ -326,7 +326,7 @@ static int cx25821_openfile_audio(struct cx25821_dev *dev,
 	loff_t offset;
 	int i, j;
 
-	file = filp_open(dev->_audiofilename, O_RDONLY | O_LARGEFILE, 0);
+	file = filp_open(dev->_audiofilename, O_RDONLY, 0);
 	if (IS_ERR(file)) {
 		pr_err("%s(): ERROR opening file(%s) with errno = %ld!\n",
 			__func__, dev->_audiofilename, PTR_ERR(file));
diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 95d0cc49cfc2..f932022e2ff0 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -575,7 +575,7 @@ static int alloc_device(struct nandsim *ns)
 	int i, err;
 
 	if (cache_file) {
-		cfile = filp_open(cache_file, O_CREAT | O_RDWR | O_LARGEFILE, 0600);
+		cfile = filp_open(cache_file, O_CREAT | O_RDWR, 0600);
 		if (IS_ERR(cfile))
 			return PTR_ERR(cfile);
 		if (!(cfile->f_mode & FMODE_CAN_READ)) {
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index effa2af58c13..a862b2f21111 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -683,7 +683,7 @@ int cfs_tracefile_dump_all_pages(char *filename)
 
 	cfs_tracefile_write_lock();
 
-	filp = filp_open(filename, O_CREAT|O_EXCL|O_WRONLY|O_LARGEFILE, 0600);
+	filp = filp_open(filename, O_CREAT|O_EXCL|O_WRONLY, 0600);
 	if (IS_ERR(filp)) {
 		rc = PTR_ERR(filp);
 		filp = NULL;
@@ -985,7 +985,7 @@ static int tracefiled(void *arg)
 		cfs_tracefile_read_lock();
 		if (cfs_tracefile[0] != 0) {
 			filp = filp_open(cfs_tracefile,
-					 O_CREAT | O_RDWR | O_LARGEFILE,
+					 O_CREAT | O_RDWR,
 					 0600);
 			if (IS_ERR(filp)) {
 				rc = PTR_ERR(filp);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e3195700211a..e7474fc79ea8 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -114,7 +114,7 @@ static int fd_configure_device(struct se_device *dev)
 	 * Use O_DSYNC by default instead of O_SYNC to forgo syncing
 	 * of pure timestamp updates.
 	 */
-	flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
+	flags = O_RDWR | O_CREAT | O_DSYNC;
 
 	/*
 	 * Optionally allow fd_buffered_io=1 to be enabled for people
@@ -732,7 +732,7 @@ static int fd_init_prot(struct se_device *dev)
 	struct fd_dev *fd_dev = FD_DEV(dev);
 	struct file *prot_file, *file = fd_dev->fd_file;
 	struct inode *inode;
-	int ret, flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
+	int ret, flags = O_RDWR | O_CREAT | O_DSYNC;
 	char buf[FD_MAX_DEV_PROT_NAME];
 
 	if (!file) {
diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index d62683017cf3..73d33930beb8 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -196,12 +196,12 @@ int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	/* R/W if we can, R/O if we must */
 	ro = curlun->initially_ro;
 	if (!ro) {
-		filp = filp_open(filename, O_RDWR | O_LARGEFILE, 0);
+		filp = filp_open(filename, O_RDWR, 0);
 		if (PTR_ERR(filp) == -EROFS || PTR_ERR(filp) == -EACCES)
 			ro = 1;
 	}
 	if (ro)
-		filp = filp_open(filename, O_RDONLY | O_LARGEFILE, 0);
+		filp = filp_open(filename, O_RDONLY, 0);
 	if (IS_ERR(filp)) {
 		LINFO(curlun, "unable to open backing file: %s\n", filename);
 		return PTR_ERR(filp);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 22ea424ee741..170abedc983a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1462,8 +1462,6 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	 * binary needs it. We might want to drop this workaround
 	 * during an unstable branch.
 	 */
-	filp->f_flags |= O_LARGEFILE;
-
 	if (filp->f_flags & O_NDELAY)
 		filp->f_mode |= FMODE_NDELAY;
 	if (filp->f_flags & O_EXCL)
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 3cbb0e834694..9b0c7348cf22 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -909,7 +909,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	 * own time */
 	path.mnt = cache->mnt;
 	path.dentry = object->backer;
-	file = dentry_open(&path, O_RDWR | O_LARGEFILE, cache->cache_cred);
+	file = dentry_open(&path, O_RDWR, cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 	} else {
diff --git a/fs/coredump.c b/fs/coredump.c
index a8f75640ac86..8e4a0feb145d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -667,8 +667,7 @@ void do_coredump(const siginfo_t *siginfo)
 		 * writes its coredump successfully, not which one.
 		 */
 		cprm.file = filp_open(cn.corename,
-				 O_CREAT | 2 | O_NOFOLLOW |
-				 O_LARGEFILE | O_EXCL,
+				 O_CREAT | 2 | O_NOFOLLOW | O_EXCL,
 				 0600);
 		if (IS_ERR(cprm.file))
 			goto fail_unlock;
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index 866bb18efefe..3fef39d3345f 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -74,7 +74,7 @@ static int ecryptfs_threadfn(void *ignored)
 					       kthread_ctl_list);
 			list_del(&req->kthread_ctl_list);
 			*req->lower_file = dentry_open(&req->path,
-				(O_RDWR | O_LARGEFILE), current_cred());
+						       O_RDWR, current_cred());
 			complete(&req->done);
 		}
 		mutex_unlock(&ecryptfs_kthread_ctl.mux);
@@ -133,7 +133,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 			     const struct cred *cred)
 {
 	struct ecryptfs_open_req req;
-	int flags = O_LARGEFILE;
+	int flags = 0;
 	int rc = 0;
 
 	init_completion(&req.done);
diff --git a/fs/exec.c b/fs/exec.c
index b06623a9347f..35668aaa3400 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -118,7 +118,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	struct filename *tmp = getname(library);
 	int error = PTR_ERR(tmp);
 	static const struct open_flags uselib_flags = {
-		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
+		.open_flag = O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_READ | MAY_EXEC | MAY_OPEN,
 		.intent = LOOKUP_OPEN,
 		.lookup_flags = LOOKUP_FOLLOW,
@@ -762,7 +762,7 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 	struct file *file;
 	int err;
 	struct open_flags open_exec_flags = {
-		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
+		.open_flag = O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC | MAY_OPEN,
 		.intent = LOOKUP_OPEN,
 		.lookup_flags = LOOKUP_FOLLOW,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 45c04979e7b3..41adbadf9a01 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -640,7 +640,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	struct path	path;
 	struct inode	*inode;
 	struct file	*file;
-	int		flags = O_RDONLY|O_LARGEFILE;
+	int		flags = O_RDONLY;
 	__be32		err;
 	int		host_err = 0;
 
@@ -690,9 +690,9 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 
 	if (may_flags & NFSD_MAY_WRITE) {
 		if (may_flags & NFSD_MAY_READ)
-			flags = O_RDWR|O_LARGEFILE;
+			flags = O_RDWR;
 		else
-			flags = O_WRONLY|O_LARGEFILE;
+			flags = O_WRONLY;
 	}
 
 	file = dentry_open(&path, flags, current_cred());
diff --git a/kernel/acct.c b/kernel/acct.c
index 74963d192c5d..c292fdf35757 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -201,7 +201,7 @@ static int acct_on(struct filename *pathname)
 		return -ENOMEM;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = file_open_name(pathname, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = file_open_name(pathname, O_WRONLY|O_APPEND, 0);
 	if (IS_ERR(file)) {
 		kfree(acct);
 		return PTR_ERR(file);
diff --git a/mm/shmem.c b/mm/shmem.c
index 48ce82926d93..4073e785cda4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2968,7 +2968,7 @@ SYSCALL_DEFINE2(memfd_create,
 	}
 	info = SHMEM_I(file_inode(file));
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
-	file->f_flags |= O_RDWR | O_LARGEFILE;
+	file->f_flags |= O_RDWR;
 	if (flags & MFD_ALLOW_SEALING)
 		info->seals &= ~F_SEAL_SEAL;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 58877312cf6b..53e854ab0960 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1863,7 +1863,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (IS_ERR(pathname))
 		return PTR_ERR(pathname);
 
-	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
+	victim = file_open_name(pathname, O_RDWR, 0);
 	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
 		goto out;
@@ -2419,7 +2419,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		name = NULL;
 		goto bad_swap;
 	}
-	swap_file = file_open_name(name, O_RDWR|O_LARGEFILE, 0);
+	swap_file = file_open_name(name, O_RDWR, 0);
 	if (IS_ERR(swap_file)) {
 		error = PTR_ERR(swap_file);
 		swap_file = NULL;
diff --git a/tools/lguest/lguest.c b/tools/lguest/lguest.c
index 80159e6811c2..a82e6bc0978e 100644
--- a/tools/lguest/lguest.c
+++ b/tools/lguest/lguest.c
@@ -3046,7 +3046,7 @@ static void setup_block_file(const char *filename)
 	vblk = dev->priv = malloc(sizeof(*vblk));
 
 	/* First we open the file and store the length. */
-	vblk->fd = open_or_die(filename, O_RDWR|O_LARGEFILE);
+	vblk->fd = open_or_die(filename, O_RDWR);
 	vblk->len = lseek64(vblk->fd, 0, SEEK_END);
 
 	/* Tell Guest how many sectors this device has. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
