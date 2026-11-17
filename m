Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926047;
	b=OGsv4cATJDvXIHgk5p3g4PVuUerY5RzusBzHwvZQZUdVMVKhj3okzOcZ2qCRBP0k2Jvt
	 yh1hPBct7J3Nawtet9hGw/5Mg/c1ZbW77/PRKTNreSTHEWvcVPAEyZvy7QTDxzqwTiCIe
	 uOOQZ12TfKP236/um1c8cdrtC2fq6rfxr5XWabCRhmNsz7uc7+aNUZUzbV9WaAwjqdO4O
	 +TA7C1Mwh9XjeMMMAI7wwNwX7mhzn0F8fi5pc4RT2m084Dh1o/Sfoacp4D8VGp0x1ZQ2v
	 SVJi0x7IYkySwgjXS+ZOIje95paL7XHGOLTm+YqovWigMePHiXWFhjmPC/TUoMJP6WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926047;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=a1+PtULtR5ptuNaD927TC+StOynUn+hwEdAd/eajbIA=;
	b=1cmKq1rP+46AKHRjVaPwmx8hdN9enwnr8M0HY5TxxdlJU6gNCxbur60ZofmlLYIcLPnM
	 HTFVmsvxp2XwK/pVqkp1U9lMQ6uOLGVLHryoDRDnLd3ngZgrkmLPLsjmk1sUvhmeIlWQe
	 PkjWf1ir5JXmSO/djjuCV+rGszwONIK1gSh2gk3XwoyE5M3UrioLIG+0VtyKyB6dGQu5T
	 WMTAfdKkA7TF4f7oCXDedbr/puBCXfayaUhUvldNX4Gd7YqYbZgu6azIM5Phr/t5EgIgs
	 pXovu0w75bq+6Kh6A3qyzVnaTXHAk3c+bkmLbkzTnIUwCGDMvI8P3vyrf4qXkkb/v2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=b1dOtoy4;
	arc=none smtp.remote-ip=113.46.200.219
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D090606B850;
	Tue, 17 Nov 2026 14:34:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D090606B850
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=b1dOtoy4
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a1+PtULtR5ptuNaD927TC+StOynUn+hwEdAd/eajbIA=;
	b=b1dOtoy4Sp0ygvicYyjyluMkf13E1U1wSBNxy4Iy47T8THwLx9nYUgfn+Gcui6aQrUB9VH2Oy
	0U/3Ydt8rfktfkB8lqL9UAREEYvTOMuqfj969p89bHM/PDUWlvajs+vXcPAK+RfcSednhz4E/nM
	nBikA8UTtC1JDkCmF0Foz38=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jTS0G1pTzz1prlx;
	Tue, 17 Nov 2026 22:33:50 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 967AD4057A;
	Tue, 17 Nov 2026 22:34:02 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:56 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <mic@digikod.net>, <gnoack@google.com>, <paul@paul-moore.com>,
	<brauner@kernel.org>, <jack@suse.cz>, <caixinchen1@huawei.com>
CC: <amir73il@gmail.com>, <andrii@kernel.org>, <apparmor@lists.ubuntu.com>,
	<ast@kernel.org>, <axboe@kernel.dk>, <bpf@vger.kernel.org>,
	<casey@schaufler-ca.com>, <cel@kernel.org>, <cem@kernel.org>,
	<chenxiaosong@chenxiaosong.com>, <code@tyhicks.com>, <corbet@lwn.net>,
	<Dai.Ngo@oracle.com>, <dakr@kernel.org>, <daniel@iogearbox.net>,
	<dhowells@redhat.com>, <dlemoal@kernel.org>, <dmitry.kasatkin@gmail.com>,
	<driver-core@lists.linux.dev>, <dsterba@suse.com>,
	<ecryptfs@vger.kernel.org>, <eddyz87@gmail.com>, <emil@etsalapatis.com>,
	<eric.snowberg@oracle.com>, <exfat@lists.linux.dev>,
	<georgia.garcia@canonical.com>, <gregkh@linuxfoundation.org>, <hch@lst.de>,
	<hirofumi@mail.parknet.co.jp>, <hyc.lee@gmail.com>,
	<ihor.solodrai@linux.dev>, <jlayton@kernel.org>, <jmorris@namei.org>,
	<johan@kernel.org>, <john.fastabend@gmail.com>,
	<john.johansen@canonical.com>, <jolsa@kernel.org>, <kpsingh@kernel.org>,
	<linkinjeon@kernel.org>, <linux-api@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-integrity@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <liubaolin12138@163.com>,
	<martin.lau@linux.dev>, <mason@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<matt@bobrowski.net>, <memxor@gmail.com>, <mhiramat@kernel.org>,
	<miklos@szeredi.hu>, <neil@brown.name>, <netfs@lists.linux.dev>,
	<ntfs@lists.linux.dev>, <okorniev@redhat.com>, <omosnacek@gmail.com>,
	<penguin-kernel@I-love.SAKURA.ne.jp>, <rafael@kernel.org>,
	<rdunlap@infradead.org>, <roberto.sassu@huawei.com>, <rostedt@goodmis.org>,
	<selinux@vger.kernel.org>, <senozhatsky@chromium.org>, <serge@hallyn.com>,
	<sj1557.seo@samsung.com>, <skhan@linuxfoundation.org>, <song@kernel.org>,
	<stephen.smalley.work@gmail.com>, <takedakn@nttdata.co.jp>, <tom@talpey.com>,
	<viro@zeniv.linux.org.uk>, <yonghong.song@linux.dev>, <yuezhang.mo@sony.com>,
	<zohar@linux.ibm.com>, <utilityemal77@gmail.com>, <lujialin4@huawei.com>
Subject: [PATCH -next -v4 07/17] LSM: pass struct path and struct file to the inode fileattr hooks
Date: Tue, 17 Nov 2026 23:05:32 +0800
Message-ID: <20261117150542.1169451-8-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20261117150542.1169451-1-caixinchen1@huawei.com>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100010.china.huawei.com (7.152.184.41)

Switch vfs_fileattr_get(), vfs_fileattr_set(), the inode_file_getattr and
inode_file_setattr hooks and their SELinux implementations to take a
const struct path, and pass the struct file through which the operation
is requested when there is one.

vfs_fileattr_get() keeps checking i_op->fileattr_get before calling the
hook, so the -ENOIOCTLCMD fallback used by the ioctls is unchanged.  Add
an unchecked __vfs_fileattr_get() for the internal users: nfsd's casefold
probe, and the read of the current attributes in do_vfs_fileattr_set(),
which is authorized as a whole by the set hook.  ksmbd keeps using the
checked helpers, passing the file it holds or NULL for path-only probes;
stacking filesystems do the same, so overlayfs keeps its existing
file:ioctl/file:open workaround until the LSM semantics are agreed on.

Add strong definitions of the two bpf_lsm_* stubs naming the file
argument file__nullable.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/filesystems/porting.rst |  15 +++
 fs/ecryptfs/inode.c                   |  10 +-
 fs/file_attr.c                        | 136 +++++++++++++++++---------
 fs/nfsd/vfs.c                         |   2 +-
 fs/overlayfs/inode.c                  |  20 ++--
 fs/smb/server/smb2pdu.c               |   6 +-
 fs/smb/server/vfs.c                   |  15 +--
 fs/smb/server/vfs.h                   |   3 +-
 include/linux/fileattr.h              |  10 +-
 include/linux/lsm_hook_defs.h         |   6 +-
 include/linux/security.h              |  18 ++--
 kernel/bpf/bpf_lsm_proto.c            |  19 ++++
 security/security.c                   |  18 ++--
 security/selinux/hooks.c              |  14 +--
 14 files changed, 199 insertions(+), 93 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 01890bda8479..f3feb27e898c 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1474,3 +1474,18 @@ to a different mount than the one the passed path was built from.
 vfs_set_acl(), vfs_get_acl() and vfs_remove_acl() also take a trailing
 struct file through which the operation is requested, or NULL for
 path-based callers.
+
+---
+
+**mandatory**
+
+vfs_fileattr_get() and vfs_fileattr_set() now take a const struct path *
+instead of a struct dentry *, and vfs_fileattr_set() keeps its mnt_idmap
+as a separate first argument.  The idmap is not derived from the path: it
+must be the idmap of the mount the operation is performed through, which
+for a stacking filesystem may belong to a different mount than the one
+the passed path was built from.  Both also take a trailing struct file
+through which the operation is requested, or NULL for path-based
+callers.  The fileattr_get() and fileattr_set() inode operations they
+call are unchanged.  The new __vfs_fileattr_get() helper is their
+counterpart without the security hook, for kernel-internal readers.
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e4a1e2f346c8..566fbcbbf7df 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1077,17 +1077,19 @@ static int ecryptfs_removexattr(struct dentry *dentry, struct inode *inode,
 
 static int ecryptfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
-	return vfs_fileattr_get(ecryptfs_dentry_to_lower(dentry), fa);
+	struct path lower_path = ecryptfs_lower_path(dentry);
+
+	return vfs_fileattr_get(&lower_path, fa, NULL);
 }
 
 static int ecryptfs_fileattr_set(const struct mnt_idmap *idmap,
 				 struct dentry *dentry, struct file_kattr *fa)
 {
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	struct path lower_path = ecryptfs_lower_path(dentry);
 	int rc;
 
-	rc = vfs_fileattr_set(&nop_mnt_idmap, lower_dentry, fa);
-	fsstack_copy_attr_all(d_inode(dentry), d_inode(lower_dentry));
+	rc = vfs_fileattr_set(&nop_mnt_idmap, &lower_path, fa, NULL);
+	fsstack_copy_attr_all(d_inode(dentry), d_inode(lower_path.dentry));
 
 	return rc;
 }
diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..846847e64ad3 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -75,27 +75,65 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
 EXPORT_SYMBOL(fileattr_fill_flags);
 
 /**
- * vfs_fileattr_get - retrieve miscellaneous file attributes
+ * __vfs_fileattr_get - retrieve miscellaneous file attributes
  * @dentry:	the object to retrieve from
  * @fa:		fileattr pointer
  *
- * Call i_op->fileattr_get() callback, if exists.
+ * Call i_op->fileattr_get() callback, if exists.  Unlike
+ * vfs_fileattr_get(), no security hook is called.  This is for
+ * kernel-internal users that do not authorize the operation through the
+ * fileattr hooks themselves: nfsd's casefold probe, and the read of the
+ * current attributes performed as part of a user-facing change, which
+ * do_vfs_fileattr_set() authorizes as a whole through the file attribute
+ * set hook.
+ *
+ * Callers may or may not hold the inode lock: do_vfs_fileattr_set() calls
+ * this with the lock held, while nfsd_get_case_info() calls it without.
+ * ->fileattr_get() must cope with both, as documented in
+ * Documentation/filesystems/locking.rst.
  *
  * Return: 0 on success, or a negative error on failure.
  */
-int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
+int __vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
+
+	if (!inode->i_op->fileattr_get)
+		return -ENOIOCTLCMD;
+
+	return inode->i_op->fileattr_get(dentry, fa);
+}
+EXPORT_SYMBOL(__vfs_fileattr_get);
+
+/**
+ * vfs_fileattr_get - retrieve miscellaneous file attributes
+ * @path:	the object to retrieve from
+ * @fa:		fileattr pointer
+ * @file:	file through which the attributes are retrieved, if any
+ *
+ * Call i_op->fileattr_get() callback, if exists.
+ *
+ * Return: 0 on success, or a negative error on failure.
+ */
+int vfs_fileattr_get(const struct path *path, struct file_kattr *fa,
+		     struct file *file)
+{
+	struct inode *inode = d_inode(path->dentry);
 	int error;
 
+	/*
+	 * Keep the -ENOIOCTLCMD fallback for filesystems that do not
+	 * implement fileattr_get before running the security hook, as
+	 * ioctl_getflags() and friends rely on it.
+	 */
 	if (!inode->i_op->fileattr_get)
 		return -ENOIOCTLCMD;
 
-	error = security_inode_file_getattr(dentry, fa);
+	error = security_inode_file_getattr(path, fa, file);
 	if (error)
 		return error;
 
-	return inode->i_op->fileattr_get(dentry, fa);
+	return __vfs_fileattr_get(path->dentry, fa);
 }
 EXPORT_SYMBOL(vfs_fileattr_get);
 
@@ -254,25 +292,12 @@ static int fileattr_set_prepare(struct inode *inode,
 	return 0;
 }
 
-/**
- * vfs_fileattr_set - change miscellaneous file attributes
- * @idmap:	idmap of the mount
- * @dentry:	the object to change
- * @fa:		fileattr pointer
- *
- * After verifying permissions, call i_op->fileattr_set() callback, if
- * exists.
- *
- * Verifying attributes involves retrieving current attributes with
- * i_op->fileattr_get(), this also allows initializing attributes that have
- * not been set by the caller to current values.  Inode lock is held
- * thoughout to prevent racing with another instance.
- *
- * Return: 0 on success, or a negative error on failure.
- */
-int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
-		     struct file_kattr *fa)
+static int do_vfs_fileattr_set(const struct path *const path,
+			       const struct mnt_idmap *const idmap,
+			       struct file_kattr *const fa,
+			       struct file *const file)
 {
+	struct dentry *const dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	struct file_kattr old_ma = {};
 	int err;
@@ -284,7 +309,7 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		return -EPERM;
 
 	inode_lock(inode);
-	err = vfs_fileattr_get(dentry, &old_ma);
+	err = __vfs_fileattr_get(dentry, &old_ma);
 	if (!err) {
 		/* initialize missing bits from old_ma */
 		if (fa->flags_valid) {
@@ -300,7 +325,7 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		err = fileattr_set_prepare(inode, &old_ma, fa);
 		if (err)
 			goto out;
-		err = security_inode_file_setattr(dentry, fa);
+		err = security_inode_file_setattr(path, fa, file);
 		if (err)
 			goto out;
 		err = inode->i_op->fileattr_set(idmap, dentry, fa);
@@ -313,6 +338,24 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	inode_unlock(inode);
 	return err;
 }
+
+/**
+ * vfs_fileattr_set - change miscellaneous file attributes
+ * @idmap:	idmap of the mount
+ * @path:	the object to change
+ * @fa:		fileattr pointer
+ * @file:	file through which the attributes are set, if any
+ *
+ * After verifying permissions, call i_op->fileattr_set() callback, if
+ * exists.
+ *
+ * Return: 0 on success, or a negative error on failure.
+ */
+int vfs_fileattr_set(const struct mnt_idmap *idmap, const struct path *path,
+		     struct file_kattr *fa, struct file *file)
+{
+	return do_vfs_fileattr_set(path, idmap, fa, file);
+}
 EXPORT_SYMBOL(vfs_fileattr_set);
 
 int ioctl_getflags(struct file *file, unsigned int __user *argp)
@@ -320,7 +363,7 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
 	struct file_kattr fa = { .flags_valid = true }; /* hint only */
 	int err;
 
-	err = vfs_fileattr_get(file->f_path.dentry, &fa);
+	err = vfs_fileattr_get(&file->f_path, &fa, file);
 	if (!err)
 		err = put_user(fa.flags, argp);
 	return err;
@@ -329,7 +372,6 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
 int ioctl_setflags(struct file *file, unsigned int __user *argp)
 {
 	const struct mnt_idmap *idmap = file_mnt_idmap(file);
-	struct dentry *dentry = file->f_path.dentry;
 	struct file_kattr fa = {};
 	unsigned int flags;
 	int err;
@@ -339,7 +381,7 @@ int ioctl_setflags(struct file *file, unsigned int __user *argp)
 		err = mnt_want_write_file(file);
 		if (!err) {
 			fileattr_fill_flags(&fa, flags);
-			err = vfs_fileattr_set(idmap, dentry, &fa);
+			err = vfs_fileattr_set(idmap, &file->f_path, &fa, file);
 			mnt_drop_write_file(file);
 		}
 	}
@@ -351,7 +393,7 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
 	struct file_kattr fa = { .fsx_valid = true }; /* hint only */
 	int err;
 
-	err = vfs_fileattr_get(file->f_path.dentry, &fa);
+	err = vfs_fileattr_get(&file->f_path, &fa, file);
 	if (!err)
 		err = copy_fsxattr_to_user(&fa, argp);
 
@@ -361,7 +403,6 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
 int ioctl_fssetxattr(struct file *file, void __user *argp)
 {
 	const struct mnt_idmap *idmap = file_mnt_idmap(file);
-	struct dentry *dentry = file->f_path.dentry;
 	struct file_kattr fa = {};
 	int err;
 
@@ -369,7 +410,7 @@ int ioctl_fssetxattr(struct file *file, void __user *argp)
 	if (!err) {
 		err = mnt_want_write_file(file);
 		if (!err) {
-			err = vfs_fileattr_set(idmap, dentry, &fa);
+			err = vfs_fileattr_set(idmap, &file->f_path, &fa, file);
 			mnt_drop_write_file(file);
 		}
 	}
@@ -407,16 +448,16 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		if (fd_empty(f))
 			return -EBADF;
 
-		filepath = fd_file(f)->f_path;
-		path_get(&filepath);
+		error = vfs_fileattr_get(&fd_file(f)->f_path, &fa,
+					 fd_file(f));
 	} else {
 		error = filename_lookup(dfd, name, lookup_flags, &filepath,
 					NULL);
 		if (error)
 			return error;
-	}
 
-	error = vfs_fileattr_get(filepath.dentry, &fa);
+		error = vfs_fileattr_get(&filepath, &fa, NULL);
+	}
 	if (error == -ENOIOCTLCMD || error == -ENOTTY)
 		error = -EOPNOTSUPP;
 	if (error)
@@ -469,23 +510,28 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 		if (fd_empty(f))
 			return -EBADF;
 
-		filepath = fd_file(f)->f_path;
-		path_get(&filepath);
+		error = mnt_want_write_file(fd_file(f));
+		if (!error) {
+			error = vfs_fileattr_set(file_mnt_idmap(fd_file(f)),
+						 &fd_file(f)->f_path, &fa,
+						 fd_file(f));
+			mnt_drop_write_file(fd_file(f));
+		}
 	} else {
 		error = filename_lookup(dfd, name, lookup_flags, &filepath,
 					NULL);
 		if (error)
 			return error;
-	}
 
-	error = mnt_want_write(filepath.mnt);
-	if (!error) {
-		error = vfs_fileattr_set(mnt_idmap(filepath.mnt),
-					 filepath.dentry, &fa);
-		if (error == -ENOIOCTLCMD || error == -ENOTTY)
-			error = -EOPNOTSUPP;
-		mnt_drop_write(filepath.mnt);
+		error = mnt_want_write(filepath.mnt);
+		if (!error) {
+			error = vfs_fileattr_set(mnt_idmap(filepath.mnt),
+						 &filepath, &fa, NULL);
+			mnt_drop_write(filepath.mnt);
+		}
 	}
+	if (error == -ENOIOCTLCMD || error == -ENOTTY)
+		error = -EOPNOTSUPP;
 
 	return error;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 382bb24ddc9e..371c3d716112 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -3011,7 +3011,7 @@ nfsd_get_case_info(struct dentry *dentry, bool *case_insensitive,
 	}
 	saved = override_creds(probe);
 
-	err = vfs_fileattr_get(cd, &fa);
+	err = __vfs_fileattr_get(cd, &fa);
 
 	put_cred(revert_creds(saved));
 out:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1700cc74ef01..2f480ab05c88 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -609,12 +609,12 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 }
 
 /*
- * Work around the fact that security_file_ioctl() takes a file argument.
- * Introducing security_inode_fileattr_get/set() hooks would solve this issue
- * properly.
+ * The inode hooks only see the layer inode, while the operation was
+ * requested through an ioctl on the overlay file.  Run the file-based
+ * checks that an ioctl on the real file would have carried.
  */
-static int ovl_security_fileattr(const struct path *realpath, struct file_kattr *fa,
-				 bool set)
+static int ovl_security_fileattr(const struct path *realpath,
+				 struct file_kattr *fa, bool set)
 {
 	struct file *file;
 	unsigned int cmd;
@@ -648,7 +648,13 @@ int ovl_real_fileattr_set(const struct path *realpath, struct file_kattr *fa)
 	if (err)
 		return err;
 
-	return vfs_fileattr_set(mnt_idmap(realpath->mnt), realpath->dentry, fa);
+	/*
+	 * Run the security hook on the underlying path as well: the
+	 * lower/upper layer can carry a different security label than the
+	 * overlay inode, and the copy-up caller does not go through the
+	 * overlay path at all.
+	 */
+	return vfs_fileattr_set(mnt_idmap(realpath->mnt), realpath, fa, NULL);
 }
 
 int ovl_fileattr_set(const struct mnt_idmap *idmap,
@@ -730,7 +736,7 @@ int ovl_real_fileattr_get(const struct path *realpath, struct file_kattr *fa)
 	if (err)
 		return err;
 
-	err = vfs_fileattr_get(realpath->dentry, fa);
+	err = vfs_fileattr_get(realpath, fa, NULL);
 	if (err == -ENOIOCTLCMD)
 		err = -ENOTTY;
 	return err;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a36ad354b37b..9ba1ae94b283 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3840,7 +3840,7 @@ static bool smb2_parent_compressed(struct ksmbd_tree_connect *tcon,
 	bool compressed = false;
 	int rc;
 
-	rc = vfs_fileattr_get(parent, &fa);
+	rc = vfs_fileattr_get(&parent_path, &fa, NULL);
 	if (!rc && fa.flags & FS_COMPR_FL) {
 		compressed = true;
 		goto out;
@@ -5505,7 +5505,7 @@ int smb2_open(struct ksmbd_work *work)
 		smb2_new_xattrs(tcon, &path, fp);
 	}
 
-	ksmbd_vfs_update_compressed_fattr(path.dentry, &fp->f_ci->m_fattr);
+	ksmbd_vfs_update_compressed_fattr(&path, fp->filp, &fp->f_ci->m_fattr);
 
 	if (created) {
 		if (fp->coption & FILE_NO_COMPRESSION_LE) {
@@ -8227,7 +8227,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			FILE_SUPPORTS_SPARSE_FILES |
 			FILE_SUPPORTS_BLOCK_REFCOUNTING;
 
-		err = vfs_fileattr_get(path.dentry, &fa);
+		err = vfs_fileattr_get(&path, &fa, NULL);
 		/*
 		 * -EINVAL, -EOPNOTSUPP: ntfs-3g and other FUSE
 		 * filesystems that lack FS_IOC_FSGETXATTR support.
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index efb66a914a8e..c7052cd96d0c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -2390,12 +2390,13 @@ int ksmbd_vfs_inherit_posix_acl(const struct mnt_idmap *idmap,
 	return 0;
 }
 
-void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr)
+void ksmbd_vfs_update_compressed_fattr(const struct path *path,
+				       struct file *file, __le32 *fattr)
 {
 	int rc;
 	struct file_kattr fa = { .flags_valid = true };
 
-	rc = vfs_fileattr_get(dentry, &fa);
+	rc = vfs_fileattr_get(path, &fa, file);
 	if (rc)
 		return;
 
@@ -2408,7 +2409,7 @@ int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt)
 	struct file_kattr fa = { .flags_valid = true };
 	int rc;
 
-	rc = vfs_fileattr_get(fp->filp->f_path.dentry, &fa);
+	rc = vfs_fileattr_get(&fp->filp->f_path, &fa, fp->filp);
 	if (rc == -ENOIOCTLCMD || rc == -ENOTTY || rc == -EINVAL ||
 	    rc == -EOPNOTSUPP) {
 		if (fp->f_ci->m_fattr & FILE_ATTRIBUTE_COMPRESSED_LE)
@@ -2435,9 +2436,8 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
 				       bool check_access)
 {
 	const struct cred *saved_cred = NULL;
-	struct file_kattr fa;
-	struct dentry *dentry = fp->filp->f_path.dentry;
 	const struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
+	struct file_kattr fa;
 	u32 flags;
 	__le32 old_fattr;
 	int rc;
@@ -2455,7 +2455,7 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
 	}
 
 	saved_cred = override_creds(fp->filp->f_cred);
-	rc = vfs_fileattr_get(dentry, &fa);
+	rc = vfs_fileattr_get(&fp->filp->f_path, &fa, fp->filp);
 	if (rc == -ENOIOCTLCMD || rc == -ENOTTY || rc == -EINVAL ||
 	    rc == -EOPNOTSUPP)
 		goto update_fattr;
@@ -2476,7 +2476,8 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
 		if (rc)
 			goto out;
 
-		rc = vfs_fileattr_set(idmap, dentry, &fa);
+		rc = vfs_fileattr_set(idmap, &fp->filp->f_path, &fa,
+				      fp->filp);
 		mnt_drop_write_file(fp->filp);
 		if (rc == -ENOIOCTLCMD || rc == -ENOTTY || rc == -EINVAL ||
 		    rc == -EOPNOTSUPP)
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index c1ea94cf153f..257975036b94 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -182,7 +182,8 @@ int ksmbd_vfs_set_init_posix_acl(const struct mnt_idmap *idmap,
 int ksmbd_vfs_inherit_posix_acl(const struct mnt_idmap *idmap,
 				const struct path *path,
 				struct inode *parent_inode);
-void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr);
+void ksmbd_vfs_update_compressed_fattr(const struct path *path,
+				       struct file *file, __le32 *fattr);
 int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt);
 int ksmbd_vfs_set_compression(struct ksmbd_work *work, struct ksmbd_file *fp, u16 fmt);
 int ksmbd_vfs_set_compression_create(struct ksmbd_work *work,
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 09e32b84e02a..e16dcee8e8fd 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -3,6 +3,8 @@
 #ifndef _LINUX_FILEATTR_H
 #define _LINUX_FILEATTR_H
 
+struct path;
+
 /* Flags shared betwen flags/xflags */
 #define FS_COMMON_FL \
 	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
@@ -73,9 +75,11 @@ static inline bool fileattr_has_fsx(const struct file_kattr *fa)
 		 fa->fsx_projid != 0 ||	fa->fsx_cowextsize != 0);
 }
 
-int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
-int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
-		     struct file_kattr *fa);
+int __vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
+int vfs_fileattr_get(const struct path *path, struct file_kattr *fa,
+		     struct file *file);
+int vfs_fileattr_set(const struct mnt_idmap *idmap, const struct path *path,
+		     struct file_kattr *fa, struct file *file);
 int ioctl_getflags(struct file *file, unsigned int __user *argp);
 int ioctl_setflags(struct file *file, unsigned int __user *argp);
 int ioctl_fsgetxattr(struct file *file, void __user *argp);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 229eaee0a0dd..81a304ce87a3 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -166,8 +166,10 @@ LSM_HOOK(int, 0, inode_removexattr, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *name, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
 	 const char *name)
-LSM_HOOK(int, 0, inode_file_setattr, struct dentry *dentry, struct file_kattr *fa)
-LSM_HOOK(int, 0, inode_file_getattr, struct dentry *dentry, struct file_kattr *fa)
+LSM_HOOK(int, 0, inode_file_setattr, const struct path *path,
+	 struct file_kattr *fa, struct file *file)
+LSM_HOOK(int, 0, inode_file_getattr, const struct path *path,
+	 struct file_kattr *fa, struct file *file)
 LSM_HOOK(int, 0, inode_set_acl, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *acl_name,
 	 struct posix_acl *kacl, struct file *file)
diff --git a/include/linux/security.h b/include/linux/security.h
index cbd50cd38255..3c52a5d2c708 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -463,10 +463,10 @@ int security_inode_removexattr(const struct mnt_idmap *idmap,
 			       const struct path *path, const char *name,
 			       struct file *file);
 void security_inode_post_removexattr(struct dentry *dentry, const char *name);
-int security_inode_file_setattr(struct dentry *dentry,
-			      struct file_kattr *fa);
-int security_inode_file_getattr(struct dentry *dentry,
-			      struct file_kattr *fa);
+int security_inode_file_setattr(const struct path *path,
+				struct file_kattr *fa, struct file *file);
+int security_inode_file_getattr(const struct path *path,
+				struct file_kattr *fa, struct file *file);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(const struct mnt_idmap *idmap, struct dentry *dentry);
 int security_inode_getsecurity(const struct mnt_idmap *idmap,
@@ -1090,14 +1090,16 @@ static inline void security_inode_post_removexattr(struct dentry *dentry,
 						   const char *name)
 { }
 
-static inline int security_inode_file_setattr(struct dentry *dentry,
-					      struct file_kattr *fa)
+static inline int security_inode_file_setattr(const struct path *path,
+					      struct file_kattr *fa,
+					      struct file *file)
 {
 	return 0;
 }
 
-static inline int security_inode_file_getattr(struct dentry *dentry,
-					      struct file_kattr *fa)
+static inline int security_inode_file_getattr(const struct path *path,
+					      struct file_kattr *fa,
+					      struct file *file)
 {
 	return 0;
 }
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index 4454c1fdbe6b..814a30a7959e 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -94,3 +94,22 @@ noinline int bpf_lsm_inode_remove_acl(const struct mnt_idmap *idmap,
 {
 	return 0;
 }
+
+/*
+ * Strong definitions of the inode fileattr BPF LSM hooks.  The file argument
+ * is only set for file descriptor-based operations and is NULL for path-based
+ * and in-kernel callers, so mark it as PTR_MAYBE_NULL.
+ */
+noinline int bpf_lsm_inode_file_setattr(const struct path *path,
+					struct file_kattr *fa,
+					struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_inode_file_getattr(const struct path *path,
+					struct file_kattr *fa,
+					struct file *file__nullable)
+{
+	return 0;
+}
diff --git a/security/security.c b/security/security.c
index b62a6e63dea1..6d2bdfaf234d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2184,32 +2184,38 @@ void security_inode_post_removexattr(struct dentry *dentry, const char *name)
 
 /**
  * security_inode_file_setattr() - check if setting fsxattr is allowed
- * @dentry: file to set filesystem extended attributes on
+ * @path: file to set filesystem extended attributes on (the VFS makes no
+ *        guarantees with regard to @path->mnt)
  * @fa: extended attributes to set on the inode
+ * @file: file through which the file attributes are set, if any
  *
  * Called when file_setattr() syscall or FS_IOC_FSSETXATTR ioctl() is called on
  * inode
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_file_setattr(struct dentry *dentry, struct file_kattr *fa)
+int security_inode_file_setattr(const struct path *path,
+				struct file_kattr *fa, struct file *file)
 {
-	return call_int_hook(inode_file_setattr, dentry, fa);
+	return call_int_hook(inode_file_setattr, path, fa, file);
 }
 
 /**
  * security_inode_file_getattr() - check if retrieving fsxattr is allowed
- * @dentry: file to retrieve filesystem extended attributes from
+ * @path: file to retrieve filesystem extended attributes from (the VFS makes no
+ *        guarantees with regard to @path->mnt)
  * @fa: extended attributes to get
+ * @file: file through which the file attributes are retrieved, if any
  *
  * Called when file_getattr() syscall or FS_IOC_FSGETXATTR ioctl() is called on
  * inode
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_file_getattr(struct dentry *dentry, struct file_kattr *fa)
+int security_inode_file_getattr(const struct path *path,
+				struct file_kattr *fa, struct file *file)
 {
-	return call_int_hook(inode_file_getattr, dentry, fa);
+	return call_int_hook(inode_file_getattr, path, fa, file);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index bd7ae5433575..85b18c155a17 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3569,16 +3569,18 @@ static int selinux_inode_removexattr(const struct mnt_idmap *idmap,
 	return -EACCES;
 }
 
-static int selinux_inode_file_setattr(struct dentry *dentry,
-				      struct file_kattr *fa)
+static int selinux_inode_file_setattr(const struct path *path,
+				      struct file_kattr *fa,
+				      struct file *file)
 {
-	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
+	return dentry_has_perm(current_cred(), path->dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_file_getattr(struct dentry *dentry,
-				      struct file_kattr *fa)
+static int selinux_inode_file_getattr(const struct path *path,
+				      struct file_kattr *fa,
+				      struct file *file)
 {
-	return dentry_has_perm(current_cred(), dentry, FILE__GETATTR);
+	return dentry_has_perm(current_cred(), path->dentry, FILE__GETATTR);
 }
 
 static int selinux_path_notify(const struct path *path, u64 mask,
-- 
2.18.0.huawei.25

