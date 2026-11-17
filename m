Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926054;
	b=fWr6bP2nqHf88naYp+moYjZXDhvbiy48Cr5ijWiptlXOhmHM9qlBlBVBjv2jkN19+LlA
	 oBR7+ipKTpD5scb+KXyJ0Y/SG4bfbAZJoWqA53iSYw5V5qkzJ7kXXQTYHvaB06oHcA7Ce
	 KGuDstksPe7td+8l60vENQj0D5a37oT4ErPJ43+Qjp6X93N5Fkg5aFCaHhfjRK3DRiXGy
	 z+UjgE6CVm9mmolpqL7mrG2oA9o1hlU3phFJoQtubDGyNMFUn20j3cG7n3ALFjg96LYGq
	 Isnybks/3pn//8w0MJ9uQoWIaXJCPLDmi4UV68/sXWGrK89Telcj3RogjGXFjkl+o1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926054;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=Lwx5zFX1Q48jMbIRnAQ6FkYyC3hzO7w2JiOQ12MFv7k=;
	b=5sW3scTwKjiUFDEHOCJFSg2wA5i5pvmtel0URdcpaR85Ohe5h3M5mb9ejOoTWy21wkI9
	 0B9n2ENisldh3GJo9DeRyIt6gtWR0aOwqquxkM3anrjTIvobZwjjpMQiAnN1VYdRSnZXq
	 Acd5Q/KdOn76XbbGwYdDeVdU8SLaJL+xGVPpMUR3v0Crkp+NcqOLWFeioTVqdX2iHOT+h
	 dBQcEl6QiAG4DFP3lWxCpSbYe2nyqLNwMOpkIzCIx4eO6Y50UrfOGr1Gn5T/ltRvaGVU1
	 +aI1frJkjt7tpXRgU+xZIRJmGhdJZ+mc5XZOxfFx/7B/20i1OffmNSpJ6q/GcspdleA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=AwUDQQTD;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8B606A882;
	Tue, 17 Nov 2026 14:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DA8B606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=AwUDQQTD
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Lwx5zFX1Q48jMbIRnAQ6FkYyC3hzO7w2JiOQ12MFv7k=;
	b=AwUDQQTDJsHVV3oKdMK84allb55iL2G19/ig2IfgY7Z4CDYxUsa1tfU8cgNPRjGAzkmMinZDx
	2sI/uy7UFwCRCtB24fX01B4BXWJIr3xuuUEjeqzv+1npDSKRM8Dm8tdLPaqVNMACK0XEMLnALbc
	VYuwiJ53eJY+Z1G0GQQrgEo=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jTRzg5RBjzpSyl;
	Tue, 17 Nov 2026 22:33:19 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 3382F40579;
	Tue, 17 Nov 2026 22:34:08 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:02 +0800
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
Subject: [PATCH -next -v4 08/17] LSM: rename inode_setattr to path_setattr and pass struct path and file
Date: Tue, 17 Nov 2026 23:05:33 +0800
Message-ID: <20261117150542.1169451-9-caixinchen1@huawei.com>
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

The inode_setattr hook is called from notify_change(), which now holds a
struct path and a struct file.  Pass both, next to the target dentry and
the idmap: path-based checks must use the caller-supplied path, while
inode-based checks must authorize the target dentry, which can differ
when a filesystem forwards a change (NTFS named streams).

Rename the hook and security_inode_setattr() to path_setattr to follow
the path_* convention.  The rename cannot be deferred: BPF LSM programs
are not verified against the argument list, and the attr argument moves
from ctx slot 2 to slot 3 while slot 2 becomes a dentry whose d_flags is
a u32 at offset 0, so a program reading iattr->ia_valid would silently
read DCACHE_OP_HASH instead of failing to load.

do_fchmodat(), do_fchownat() and do_utimes_path() now dispatch an empty
path with AT_EMPTY_PATH to the file descriptor-based helpers, following
the vfs_fstatat() pattern, so that AT_EMPTY_PATH keeps accepting O_PATH
descriptors; vfs_utimes() audits the request once when it is given a
file.

Also make the new arguments usable from BPF: mark path->dentry trusted in
the verifier, name the file argument file__nullable in the strong stub,
and add the already-locked sleepable path hooks to d_inode_locked_hooks.
path_link, path_rename, path_rmdir and path_unlink stay out of it, as
their path and dentry arguments name different inodes.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/filesystems/porting.rst | 11 ++++-
 drivers/base/devtmpfs.c               |  4 +-
 fs/attr.c                             | 28 +++++++-----
 fs/bpf_fs_kfuncs.c                    | 54 +++++++++++++++++++++-
 fs/btrfs/volumes.c                    |  2 +-
 fs/ecryptfs/inode.c                   |  4 +-
 fs/exfat/file.c                       |  5 ++-
 fs/fat/file.c                         |  5 ++-
 fs/init.c                             |  6 +--
 fs/inode.c                            |  2 +-
 fs/internal.h                         |  6 ++-
 fs/nfsd/nfs4state.c                   |  4 +-
 fs/nfsd/vfs.c                         |  4 +-
 fs/ntfs/named_stream.c                |  3 +-
 fs/open.c                             | 64 ++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h              |  2 +-
 fs/smb/server/smb2pdu.c               |  2 +-
 fs/smb/server/smbacl.c                |  2 +-
 fs/utimes.c                           | 36 ++++++++++++---
 include/linux/fs.h                    |  9 ++--
 include/linux/lsm_hook_defs.h         | 17 ++++++-
 include/linux/security.h              | 13 +++---
 init/initramfs.c                      |  2 +-
 kernel/bpf/bpf_lsm.c                  |  2 +-
 kernel/bpf/bpf_lsm_proto.c            | 16 +++++++
 kernel/bpf/verifier.c                 | 13 ++++++
 security/integrity/evm/evm_main.c     | 13 +++---
 security/security.c                   | 16 ++++---
 security/selinux/hooks.c              |  8 ++--
 security/smack/smack_lsm.c            | 14 +++---
 30 files changed, 283 insertions(+), 84 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index f3feb27e898c..396e23af4c1f 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1446,7 +1446,16 @@ dentry must provide a struct path.  struct iattr has a new ia_path member,
 which notify_change() sets for the duration of the call; it must not be
 stored beyond that.  Filesystems that forward a change to another inode
 can use notify_change_target() to update the target dentry while keeping
-the caller-supplied path in ia_path.
+the caller-supplied path in ia_path; path-based LSM checks are performed
+on that path, and the setattr LSM hook receives both it and the target
+dentry, so inode-based LSMs keep authorizing the inode that is actually
+changed.  notify_change() also takes the struct file through which the
+change was requested, if any.  vfs_utimes() takes the same trailing struct
+file argument.  The inode_setattr LSM hook is renamed to
+path_setattr and now receives the struct path and the target dentry
+before struct iattr, plus a trailing struct file (NULL for path-based
+and kernel-internal callers); the security_inode_setattr() wrapper is
+renamed to security_path_setattr() accordingly.
 
 ---
 
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 410906a66ee9..00f2e3e7e27e 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -291,7 +291,7 @@ static int handle_create(const char *nodename, umode_t mode, kuid_t uid,
 		newattrs.ia_gid = gid;
 		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		inode_lock(d_inode(dentry));
-		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL);
+		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL, NULL);
 		inode_unlock(d_inode(dentry));
 
 		/* mark as kernel-created inode */
@@ -392,7 +392,7 @@ static int handle_remove(const char *nodename, struct device *dev)
 		newattrs.ia_valid =
 			ATTR_UID|ATTR_GID|ATTR_MODE;
 		inode_lock(d_inode(dentry));
-		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL);
+		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL, NULL);
 		inode_unlock(d_inode(dentry));
 		err = vfs_unlink(&nop_mnt_idmap, d_inode(parent.dentry),
 				 dentry, NULL);
diff --git a/fs/attr.c b/fs/attr.c
index f8fd0f061612..8d2495728b1b 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -401,7 +401,8 @@ static int do_notify_change(const struct path *const path,
 			    const struct mnt_idmap *const idmap,
 			    struct dentry *const dentry,
 			    struct iattr *attr,
-			    struct delegated_inode *delegated_inode)
+			    struct delegated_inode *delegated_inode,
+			    struct file *const file)
 {
 	struct inode *inode = dentry->d_inode;
 	umode_t mode = inode->i_mode;
@@ -513,7 +514,7 @@ static int do_notify_change(const struct path *const path,
 	    !vfsgid_valid(i_gid_into_vfsgid(idmap, inode)))
 		return -EOVERFLOW;
 
-	error = security_inode_setattr(idmap, dentry, attr);
+	error = security_path_setattr(idmap, path, dentry, attr, file);
 	if (error)
 		return error;
 
@@ -557,6 +558,7 @@ static int do_notify_change(const struct path *const path,
  * @path:	object affected
  * @attr:	new attributes
  * @delegated_inode: returns inode, if the inode is delegated
+ * @file:	file through which the attribute change is requested, if any
  *
  * The caller must hold the i_rwsem exclusively on the affected object.
  *
@@ -581,10 +583,11 @@ static int do_notify_change(const struct path *const path,
  * Return: 0 on success, or a negative error on failure.
  */
 int notify_change(const struct mnt_idmap *idmap, const struct path *path,
-		  struct iattr *attr, struct delegated_inode *delegated_inode)
+		  struct iattr *attr, struct delegated_inode *delegated_inode,
+		  struct file *file)
 {
 	return do_notify_change(path, idmap, path->dentry, attr,
-				delegated_inode);
+				delegated_inode, file);
 }
 EXPORT_SYMBOL(notify_change);
 
@@ -595,24 +598,29 @@ EXPORT_SYMBOL(notify_change);
  * @target: dentry of the inode whose attributes are changed
  * @attr: attributes to change
  * @delegated_inode: returns inode needing a delegation break
+ * @file: file through which the change was requested, if any
  *
  * This is for filesystems that apply a metadata change to an inode other
  * than the one the caller named (e.g. NTFS named streams).  The path the
  * change was requested through is recorded in @attr->ia_path so that the
- * caller can pass it back when it forwards the change; @target supplies
- * the inode to update.  @target must be the inode of the same file as
- * @path, e.g. the base inode of a named stream.  The caller must hold the
- * i_rwsem exclusively on @target.
+ * caller can pass it back when it forwards the change; path-based LSM
+ * checks are then performed on @path, while inode-based LSM checks and the
+ * update itself use @target.  @target must be the inode of the same file
+ * as @path, e.g. the base inode of a named stream.  The caller must hold
+ * the i_rwsem exclusively on @target, and on @path->dentry->d_inode, which
+ * ->setattr already holds: the LSM hook is called with both inodes locked.
  *
  * Return: 0 on success, or a negative error on failure.
  */
 int notify_change_target(const struct mnt_idmap *idmap,
 			 const struct path *path, struct dentry *target,
 			 struct iattr *attr,
-			 struct delegated_inode *delegated_inode)
+			 struct delegated_inode *delegated_inode,
+			 struct file *file)
 {
 	if (WARN_ON_ONCE(!target))
 		return -EINVAL;
-	return do_notify_change(path, idmap, target, attr, delegated_inode);
+	return do_notify_change(path, idmap, target, attr, delegated_inode,
+				file);
 }
 EXPORT_SYMBOL_GPL(notify_change_target);
diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index 35ccd98a4de6..a28a6eaaa145 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -527,6 +527,34 @@ BTF_SET_START(bpf_inode_init_xattr_hooks)
 BTF_ID(func, bpf_lsm_inode_init_security)
 BTF_SET_END(bpf_inode_init_xattr_hooks)
 
+/*
+ * Hooks that expose two dentries, only one of which is locked: the path
+ * argument names the parent directory, which the caller already write-locked,
+ * while the dentry argument is the victim, whose inode is only locked later
+ * by vfs_link(), vfs_rename(), vfs_rmdir() or vfs_unlink().
+ *
+ * The dentry xattr kfuncs cannot pick a correct variant for such a hook, and
+ * the verifier cannot tell which dentry a program passes: the locking variant
+ * would update the victim without i_rwsem, and the non-locking one would
+ * deadlock on the parent.  Reject both kfuncs for these hooks.
+ *
+ * inode_getattr() is also reached both with and without i_rwsem: path-based
+ * callers such as stat(2) hold no lock, while nfsd fills the pre-operation
+ * attributes from nfsd_setattr() with the inode already write-locked.
+ */
+BTF_ID_LIST_SINGLE(bpf_set_dentry_xattr_ids, func, bpf_set_dentry_xattr)
+BTF_ID_LIST_SINGLE(bpf_remove_dentry_xattr_ids, func, bpf_remove_dentry_xattr)
+
+BTF_SET_START(d_inode_ambiguous_hooks)
+BTF_ID(func, bpf_lsm_inode_getattr)
+#ifdef CONFIG_SECURITY_PATH
+BTF_ID(func, bpf_lsm_path_link)
+BTF_ID(func, bpf_lsm_path_rename)
+BTF_ID(func, bpf_lsm_path_rmdir)
+BTF_ID(func, bpf_lsm_path_unlink)
+#endif /* CONFIG_SECURITY_PATH */
+BTF_SET_END(d_inode_ambiguous_hooks)
+
 static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)
 {
 	if (!btf_id_set8_contains(&bpf_fs_kfunc_set_ids, kfunc_id))
@@ -539,8 +567,14 @@ static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)
 			return -EACCES;
 		return 0;
 	}
-	if (prog->type == BPF_PROG_TYPE_LSM)
+	if (prog->type == BPF_PROG_TYPE_LSM) {
+		if ((kfunc_id == bpf_set_dentry_xattr_ids[0] ||
+		     kfunc_id == bpf_remove_dentry_xattr_ids[0]) &&
+		    btf_id_set_contains(&d_inode_ambiguous_hooks,
+					prog->aux->attach_btf_id))
+			return -EACCES;
 		return 0;
+	}
 	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS)
 		return -EACCES;
 	/* ->st_ops is unset during the cfg pass; enforced once it is set. */
@@ -568,9 +602,25 @@ BTF_ID(func, bpf_lsm_inode_post_setattr)
 BTF_ID(func, bpf_lsm_inode_post_setxattr)
 BTF_ID(func, bpf_lsm_inode_removexattr)
 BTF_ID(func, bpf_lsm_inode_rmdir)
-BTF_ID(func, bpf_lsm_inode_setattr)
+BTF_ID(func, bpf_lsm_path_setattr)
 BTF_ID(func, bpf_lsm_inode_setxattr)
 BTF_ID(func, bpf_lsm_inode_unlink)
+/*
+ * Path hooks whose path argument is already locked by the caller.  They can
+ * run sleepable programs (see sleepable_lsm_hooks), so the dentry xattr
+ * kfuncs must use their _locked variants there.
+ *
+ * path_link, path_rename, path_rmdir and path_unlink hand over both a locked
+ * parent (the path) and an unlocked victim (the dentry), so the dentry xattr
+ * kfuncs are rejected for programs attached to them (see
+ * d_inode_ambiguous_hooks).
+ */
+#ifdef CONFIG_SECURITY_PATH
+BTF_ID(func, bpf_lsm_path_chmod)
+BTF_ID(func, bpf_lsm_path_chown)
+BTF_ID(func, bpf_lsm_path_mkdir)
+BTF_ID(func, bpf_lsm_path_symlink)
+#endif /* CONFIG_SECURITY_PATH */
 BTF_SET_END(d_inode_locked_hooks)
 
 bool bpf_lsm_has_d_inode_locked(const struct bpf_prog *prog)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3d4ef6725de0..a230f7c43c06 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2152,7 +2152,7 @@ static void update_dev_time(const char *device_path)
 	}
 
 	if (!err) {
-		vfs_utimes(&path, NULL);
+		vfs_utimes(&path, NULL, NULL);
 		path_put(&path);
 	}
 }
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 566fbcbbf7df..0f029435c6a6 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -822,7 +822,7 @@ static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 set_size:
 	lower_ia.ia_valid |= ATTR_SIZE;
 	inode_lock(d_inode(lower_dentry));
-	rc = notify_change(&nop_mnt_idmap, &lower_path, &lower_ia, NULL);
+	rc = notify_change(&nop_mnt_idmap, &lower_path, &lower_ia, NULL, NULL);
 	inode_unlock(d_inode(lower_dentry));
 out:
 	ecryptfs_put_lower_file(inode);
@@ -932,7 +932,7 @@ static int ecryptfs_setattr(const struct mnt_idmap *idmap,
 
 		inode_lock(d_inode(lower_path.dentry));
 		rc = notify_change(&nop_mnt_idmap, &lower_path, &lower_ia,
-				   NULL);
+				   NULL, NULL);
 		inode_unlock(d_inode(lower_path.dentry));
 	}
 out:
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 18ac88c979fc..ddf5c47176bd 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -551,8 +551,9 @@ static int exfat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 	 * out the RO attribute for checking by the security
 	 * module, just because it maps to a file mode.
 	 */
-	err = security_inode_setattr(file_mnt_idmap(file),
-				     file->f_path.dentry, &ia);
+	err = security_path_setattr(file_mnt_idmap(file),
+				    &file->f_path, file->f_path.dentry,
+				    &ia, file);
 	if (err)
 		goto out_unlock_inode;
 
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 70583e791bdc..4ca635cd2bd4 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -92,8 +92,9 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 	 * out the RO attribute for checking by the security
 	 * module, just because it maps to a file mode.
 	 */
-	err = security_inode_setattr(file_mnt_idmap(file),
-				     file->f_path.dentry, &ia);
+	err = security_path_setattr(file_mnt_idmap(file),
+				    &file->f_path, file->f_path.dentry,
+				    &ia, file);
 	if (err)
 		goto out_unlock_inode;
 
diff --git a/fs/init.c b/fs/init.c
index 33e312d74f58..b65e47e59ee0 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -107,7 +107,7 @@ int __init init_chown(const char *filename, uid_t user, gid_t group, int flags)
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = chown_common(&path, user, group);
+		error = chown_common(&path, user, group, NULL);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -122,7 +122,7 @@ int __init init_chmod(const char *filename, umode_t mode)
 	error = kern_path(filename, LOOKUP_FOLLOW, &path);
 	if (error)
 		return error;
-	error = chmod_common(&path, mode);
+	error = chmod_common(&path, mode, NULL);
 	path_put(&path);
 	return error;
 }
@@ -201,7 +201,7 @@ int __init init_utimes(char *filename, struct timespec64 *ts)
 	error = kern_path(filename, 0, &path);
 	if (error)
 		return error;
-	error = vfs_utimes(&path, ts);
+	error = vfs_utimes(&path, ts, NULL);
 	path_put(&path);
 	return error;
 }
diff --git a/fs/inode.c b/fs/inode.c
index e4af8a44932b..ff4a6b50ee84 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2388,7 +2388,7 @@ static int __remove_privs(const struct mnt_idmap *idmap,
 	 * Note we call this on write, so notify_change will not
 	 * encounter any conflicting delegations:
 	 */
-	return notify_change(idmap, path, &newattrs, NULL);
+	return notify_change(idmap, path, &newattrs, NULL, NULL);
 }
 
 static int file_remove_privs_flags(struct file *file, unsigned int flags)
diff --git a/fs/internal.h b/fs/internal.h
index d6a3b48f1633..79a18e8ad29e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -201,10 +201,12 @@ struct file *file_close_fd_locked(struct files_struct *files, unsigned fd);
 int filp_close_sync(struct file *filp, fl_owner_t id);
 
 int do_ftruncate(struct file *file, loff_t length, unsigned int flags);
-int chmod_common(const struct path *path, umode_t mode);
+int chmod_common(const struct path *path, umode_t mode,
+		  struct file *file);
 int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		int flag);
-int chown_common(const struct path *path, uid_t user, gid_t group);
+int chown_common(const struct path *path, uid_t user, gid_t group,
+		  struct file *file);
 extern int vfs_open(const struct path *, struct file *);
 int vfs_open_consume(struct path *, struct file *);
 struct file *task_path_open(const struct path *path);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b89898fe6323..844942c5dd8a 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -10550,7 +10550,7 @@ static int cb_getattr_update_times(const struct path *path,
 
 	attrs.ia_valid |= ATTR_DELEG;
 	inode_lock(inode);
-	ret = notify_change(&nop_mnt_idmap, path, &attrs, NULL);
+	ret = notify_change(&nop_mnt_idmap, path, &attrs, NULL, NULL);
 	inode_unlock(inode);
 	return ret;
 }
@@ -10831,7 +10831,7 @@ void nfsd_update_cmtime_attr(struct file *f, unsigned int flags)
 	};
 
 	inode_lock(inode);
-	ret = notify_change(&nop_mnt_idmap, &f->f_path, &attr, NULL);
+	ret = notify_change(&nop_mnt_idmap, &f->f_path, &attr, NULL, NULL);
 	inode_unlock(inode);
 	if (ret)
 		pr_notice_ratelimited("nfsd: Unable to update timestamps on "
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 371c3d716112..9eae731ecb26 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -478,7 +478,7 @@ static int __nfsd_setattr(const struct path *path, struct iattr *iap)
 			return -EFBIG;
 
 		host_err = notify_change(&nop_mnt_idmap, path, &size_attr,
-					  NULL);
+					  NULL, NULL);
 		if (host_err)
 			return host_err;
 		iap->ia_valid &= ~ATTR_SIZE;
@@ -504,7 +504,7 @@ static int __nfsd_setattr(const struct path *path, struct iattr *iap)
 	if (!(iap->ia_valid & ATTR_DELEG))
 		iap->ia_valid |= ATTR_CTIME;
 
-	return notify_change(&nop_mnt_idmap, path, iap, NULL);
+	return notify_change(&nop_mnt_idmap, path, iap, NULL, NULL);
 }
 
 /**
diff --git a/fs/ntfs/named_stream.c b/fs/ntfs/named_stream.c
index 1c55588df5ba..05cac62fca1d 100644
--- a/fs/ntfs/named_stream.c
+++ b/fs/ntfs/named_stream.c
@@ -901,7 +901,8 @@ static int ntfs_stream_setattr_common(const struct mnt_idmap *idmap,
 				err = -EINVAL;
 			} else {
 				err = notify_change_target(idmap, attr->ia_path,
-							   base_dentry, &base_attr, NULL);
+							   base_dentry, &base_attr,
+							   NULL, NULL);
 			}
 		} else {
 			err = 0;
diff --git a/fs/open.c b/fs/open.c
index a96d490915f6..52301fb3536c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -65,8 +65,13 @@ int do_truncate(const struct mnt_idmap *idmap, const struct path *path,
 	if (ret)
 		return ret;
 
-	/* Note any delegations or leases have already been broken: */
-	ret = notify_change(idmap, path, &newattrs, NULL);
+	/*
+	 * Note any delegations or leases have already been broken.  The
+	 * truncate hooks authorize the size change on the syscall paths
+	 * (truncate(2), ftruncate(2) and open(O_TRUNC)) before they get
+	 * here, so no struct file is passed to the setattr hook.
+	 */
+	ret = notify_change(idmap, path, &newattrs, NULL, NULL);
 	inode_unlock(dentry->d_inode);
 	return ret;
 }
@@ -665,7 +670,7 @@ SYSCALL_DEFINE2(fchroot, int, fd, unsigned int, flags)
 	return error;
 }
 
-int chmod_common(const struct path *path, umode_t mode)
+int chmod_common(const struct path *path, umode_t mode, struct file *file)
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct delegated_inode delegated_inode = { };
@@ -685,7 +690,7 @@ int chmod_common(const struct path *path, umode_t mode)
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(mnt_idmap(path->mnt), path, &newattrs,
-			      &delegated_inode);
+			      &delegated_inode, file);
 out_unlock:
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
@@ -701,7 +706,7 @@ int chmod_common(const struct path *path, umode_t mode)
 int vfs_fchmod(struct file *file, umode_t mode)
 {
 	audit_file(file);
-	return chmod_common(&file->f_path, mode);
+	return chmod_common(&file->f_path, mode, file);
 }
 
 SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
@@ -723,13 +728,30 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 
 	if (unlikely(flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)))
 		return -EINVAL;
+	/*
+	 * A NULL pathname is rejected with EFAULT for these system calls,
+	 * even with AT_EMPTY_PATH: getname_maybe_null() would otherwise
+	 * treat it like an empty path and act on the file descriptor.
+	 */
+	if (!filename)
+		return -EFAULT;
+
+	CLASS(filename_maybe_null, name)(filename, flags);
+
+	if (!name && dfd >= 0) {
+		CLASS(fd_raw, f)(dfd);
+
+		if (fd_empty(f))
+			return -EBADF;
+
+		return vfs_fchmod(fd_file(f), mode);
+	}
 
 	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (!error) {
-		error = chmod_common(&path, mode);
+		error = chmod_common(&path, mode, NULL);
 		path_put(&path);
 		if (retry_estale(error, lookup_flags)) {
 			lookup_flags |= LOOKUP_REVAL;
@@ -786,7 +808,8 @@ static inline bool setattr_vfsgid(struct iattr *attr, kgid_t kgid)
 	return true;
 }
 
-int chown_common(const struct path *path, uid_t user, gid_t group)
+int chown_common(const struct path *path, uid_t user, gid_t group,
+		 struct file *file)
 {
 	const struct mnt_idmap *idmap;
 	struct user_namespace *fs_userns;
@@ -824,7 +847,7 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 		from_vfsgid(idmap, fs_userns, newattrs.ia_vfsgid));
 	if (!error)
 		error = notify_change(idmap, path, &newattrs,
-				      &delegated_inode);
+				      &delegated_inode, file);
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
 		error = break_deleg_wait(&delegated_inode);
@@ -843,15 +866,32 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
+	/*
+	 * A NULL pathname is rejected with EFAULT for these system calls,
+	 * even with AT_EMPTY_PATH: getname_maybe_null() would otherwise
+	 * treat it like an empty path and act on the file descriptor.
+	 */
+	if (!filename)
+		return -EFAULT;
+
+	CLASS(filename_maybe_null, name)(filename, flag);
+
+	if (!name && dfd >= 0) {
+		CLASS(fd_raw, f)(dfd);
+
+		if (fd_empty(f))
+			return -EBADF;
+
+		return vfs_fchown(fd_file(f), user, group);
+	}
 
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	CLASS(filename_uflags, name)(filename, flag);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = mnt_want_write(path.mnt);
 		if (!error) {
-			error = chown_common(&path, user, group);
+			error = chown_common(&path, user, group, NULL);
 			mnt_drop_write(path.mnt);
 		}
 		path_put(&path);
@@ -888,7 +928,7 @@ int vfs_fchown(struct file *file, uid_t user, gid_t group)
 	if (error)
 		return error;
 	audit_file(file);
-	error = chown_common(&file->f_path, user, group);
+	error = chown_common(&file->f_path, user, group, file);
 	mnt_drop_write_file(file);
 	return error;
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 71885794421e..d8b16b3a51b4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -219,7 +219,7 @@ static inline int ovl_do_notify_change(struct ovl_fs *ofs,
 		.dentry = upperdentry,
 	};
 
-	return notify_change(ovl_upper_mnt_idmap(ofs), &path, attr, NULL);
+	return notify_change(ovl_upper_mnt_idmap(ofs), &path, attr, NULL, NULL);
 }
 
 static inline int ovl_do_rmdir(struct ovl_fs *ofs,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9ba1ae94b283..5be89216f5f6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9079,7 +9079,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		}
 
 		inode_lock(inode);
-		rc = notify_change(idmap, &filp->f_path, &attrs, NULL);
+		rc = notify_change(idmap, &filp->f_path, &attrs, NULL, filp);
 		inode_unlock(inode);
 	}
 out:
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 9fcc7f412e45..a491e32e1e7b 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1975,7 +1975,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	}
 
 	inode_lock(inode);
-	rc = notify_change(idmap, path, &newattrs, NULL);
+	rc = notify_change(idmap, path, &newattrs, NULL, NULL);
 	inode_unlock(inode);
 	if (get_write)
 		mnt_drop_write(path->mnt);
diff --git a/fs/utimes.c b/fs/utimes.c
index 5193d504d289..94a3946a41ce 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -7,6 +7,7 @@
 #include <linux/uaccess.h>
 #include <linux/compat.h>
 #include <asm/unistd.h>
+#include <linux/audit.h>
 #include <linux/filelock.h>
 #include "internal.h"
 
@@ -18,7 +19,8 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-int vfs_utimes(const struct path *path, struct timespec64 *times)
+int vfs_utimes(const struct path *path, struct timespec64 *times,
+	       struct file *file)
 {
 	int error;
 	struct iattr newattrs;
@@ -34,6 +36,13 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 			times = NULL;
 	}
 
+	/*
+	 * Like vfs_fchmod(), audit the request once for the file
+	 * descriptor based spellings; path based callers pass no file.
+	 */
+	if (file)
+		audit_file(file);
+
 	error = mnt_want_write(path->mnt);
 	if (error)
 		goto out;
@@ -65,7 +74,7 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 retry_deleg:
 	inode_lock(inode);
 	error = notify_change(mnt_idmap(path->mnt), path, &newattrs,
-			      &delegated_inode);
+			      &delegated_inode, file);
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
 		error = break_deleg_wait(&delegated_inode);
@@ -87,16 +96,33 @@ static int do_utimes_path(int dfd, const char __user *filename,
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
 		return -EINVAL;
+	/*
+	 * A NULL pathname is rejected with EFAULT for these system calls,
+	 * even with AT_EMPTY_PATH: getname_maybe_null() would otherwise
+	 * treat it like an empty path and act on the file descriptor.
+	 */
+	if (!filename)
+		return -EFAULT;
+
+	CLASS(filename_maybe_null, name)(filename, flags);
+
+	if (!name && dfd >= 0) {
+		CLASS(fd_raw, f)(dfd);
+
+		if (fd_empty(f))
+			return -EBADF;
+
+		return vfs_utimes(&fd_file(f)->f_path, times, fd_file(f));
+	}
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
 
-	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = vfs_utimes(&path, times);
+	error = vfs_utimes(&path, times, NULL);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -113,7 +139,7 @@ static int do_utimes_fd(int fd, struct timespec64 *times, int flags)
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
-	return vfs_utimes(&fd_file(f)->f_path, times);
+	return vfs_utimes(&fd_file(f)->f_path, times, fd_file(f));
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cd19aa264a98..d501d3d9ef0d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1831,7 +1831,8 @@ int vfs_mkobj(struct dentry *, umode_t,
 
 int vfs_fchown(struct file *file, uid_t user, gid_t group);
 int vfs_fchmod(struct file *file, umode_t mode);
-int vfs_utimes(const struct path *path, struct timespec64 *times);
+int vfs_utimes(const struct path *path, struct timespec64 *times,
+		struct file *file);
 
 #ifdef CONFIG_COMPAT
 extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
@@ -2730,11 +2731,13 @@ static inline int bmap(struct inode *inode,  sector_t *block)
 #endif
 
 int notify_change(const struct mnt_idmap *, const struct path *,
-		  struct iattr *, struct delegated_inode *);
+		  struct iattr *, struct delegated_inode *,
+		  struct file *);
 int notify_change_target(const struct mnt_idmap *idmap,
 			 const struct path *path, struct dentry *target,
 			 struct iattr *attr,
-			 struct delegated_inode *delegated_inode);
+			 struct delegated_inode *delegated_inode,
+			 struct file *file);
 int inode_permission(const struct mnt_idmap *, struct inode *, int);
 int generic_permission(const struct mnt_idmap *, struct inode *, int);
 static inline int file_permission(struct file *file, int mask)
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 81a304ce87a3..180d2427e5f9 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -147,8 +147,21 @@ LSM_HOOK(int, 0, inode_follow_link, struct dentry *dentry, struct inode *inode,
 	 bool rcu)
 LSM_HOOK(int, 0, inode_permission, const struct mnt_idmap *idmap,
 	 struct inode *inode, int mask)
-LSM_HOOK(int, 0, inode_setattr, const struct mnt_idmap *idmap, struct dentry *dentry,
-	 struct iattr *attr)
+/*
+ * The struct file argument of the hooks below is NULL when the operation
+ * is not performed through a file descriptor.  It is a borrowed reference
+ * that is only valid for the duration of the hook call: implementations
+ * must neither take a reference on it nor use it after the hook returns.
+ *
+ * path_setattr runs with the i_rwsem held exclusively on the inode of both
+ * @dentry and @path->dentry: the VFS locks the inode named by @path before
+ * calling ->setattr, and a filesystem forwarding the change locks the target
+ * inode before notify_change_target() invokes the hook.  BPF LSM programs
+ * attached to this hook therefore use the locked dentry xattr kfuncs.
+ */
+LSM_HOOK(int, 0, path_setattr, const struct mnt_idmap *idmap,
+	 const struct path *path, struct dentry *dentry,
+	 struct iattr *attr, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_setattr, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, int ia_valid)
 LSM_HOOK(int, 0, inode_getattr, const struct path *path)
diff --git a/include/linux/security.h b/include/linux/security.h
index 3c52a5d2c708..e929ef320888 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -430,8 +430,9 @@ int security_inode_follow_link(struct dentry *dentry, struct inode *inode,
 			       bool rcu);
 int security_inode_permission(const struct mnt_idmap *idmap,
 			      struct inode *inode, int mask);
-int security_inode_setattr(const struct mnt_idmap *idmap,
-			   struct dentry *dentry, struct iattr *attr);
+int security_path_setattr(const struct mnt_idmap *idmap,
+			  const struct path *path, struct dentry *dentry,
+			  struct iattr *attr, struct file *file);
 void security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 				 int ia_valid);
 int security_inode_getattr(const struct path *path);
@@ -1002,9 +1003,11 @@ static inline int security_inode_permission(const struct mnt_idmap *idmap,
 	return 0;
 }
 
-static inline int security_inode_setattr(const struct mnt_idmap *idmap,
-					 struct dentry *dentry,
-					 struct iattr *attr)
+static inline int security_path_setattr(const struct mnt_idmap *idmap,
+					const struct path *path,
+					struct dentry *dentry,
+					struct iattr *attr,
+					struct file *file)
 {
 	return 0;
 }
diff --git a/init/initramfs.c b/init/initramfs.c
index ebddde9c8f0d..c8172440276e 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -144,7 +144,7 @@ static void __init do_utime(char *filename, time64_t mtime)
 static void __init do_utime_path(const struct path *path, time64_t mtime)
 {
 	struct timespec64 t[2] = { { .tv_sec = mtime }, { .tv_sec = mtime } };
-	vfs_utimes(path, t);
+	vfs_utimes(path, t, NULL);
 }
 
 static __initdata LIST_HEAD(dir_list);
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 25b65557731d..c8d25b7ba2ea 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -352,7 +352,7 @@ BTF_ID(func, bpf_lsm_inode_readlink)
 BTF_ID(func, bpf_lsm_inode_removexattr)
 BTF_ID(func, bpf_lsm_inode_rename)
 BTF_ID(func, bpf_lsm_inode_rmdir)
-BTF_ID(func, bpf_lsm_inode_setattr)
+BTF_ID(func, bpf_lsm_path_setattr)
 BTF_ID(func, bpf_lsm_inode_setxattr)
 BTF_ID(func, bpf_lsm_inode_symlink)
 BTF_ID(func, bpf_lsm_inode_unlink)
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index 814a30a7959e..5d4e9ccd0078 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -33,6 +33,22 @@ noinline int bpf_lsm_inode_init_security(struct inode *inode, struct inode *dir,
 	return -EOPNOTSUPP;
 }
 
+/*
+ * Strong definition of the path_setattr() BPF LSM hook.  @dentry is the
+ * inode whose attributes are changed and can differ from @path->dentry for
+ * filesystems that forward the change.  The file argument is only set for
+ * file descriptor-based operations and is NULL for path-based and in-kernel
+ * callers, so mark it as PTR_MAYBE_NULL.
+ */
+noinline int bpf_lsm_path_setattr(const struct mnt_idmap *idmap,
+				  const struct path *path,
+				  struct dentry *dentry,
+				  struct iattr *attr,
+				  struct file *file__nullable)
+{
+	return 0;
+}
+
 /*
  * Strong definitions of the inode xattr BPF LSM hooks.  The file argument is
  * only set for file descriptor-based operations and is NULL for path-based
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 72a4372ad814..d08e95823dd6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6687,6 +6687,18 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
 	struct inode *f_inode;
 };
 
+/*
+ * LSM hooks that take a struct path hand over a path that is valid for the
+ * duration of the hook, so that BPF LSM programs can safely reach its dentry
+ * (e.g. to call the dentry xattr kfuncs).  Only the dentry is marked as
+ * trusted: the template applies to every trusted struct path, and some
+ * callers (e.g. the Landlock tracepoints) build one with mnt left NULL, which
+ * a trusted pointer would make dereferenceable without a fault check.
+ */
+BTF_TYPE_SAFE_TRUSTED(struct path) {
+	struct dentry *dentry;
+};
+
 /*
  * The pointer fields in the sched_ext ops argument containers are pinned by the
  * callers for the duration of the ops calls and are never NULL.
@@ -6757,6 +6769,7 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct file));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct path));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_init_task_args));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_cpu_release_args));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_sub_attach_args));
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 963a1bc89a7d..8a7a150e180c 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -982,16 +982,19 @@ static int evm_attr_change(const struct mnt_idmap *idmap,
 }
 
 /**
- * evm_inode_setattr - prevent updating an invalid EVM extended attribute
+ * evm_path_setattr - prevent updating an invalid EVM extended attribute
  * @idmap: idmap of the mount
- * @dentry: pointer to the affected dentry
+ * @path: pointer to the affected object
+ * @dentry: inode whose attributes are changed
  * @attr: iattr structure containing the new file attributes
+ * @file: file through which the attribute change is requested, if any
  *
  * Permit update of file attributes when files have a valid EVM signature,
  * except in the case of them having an immutable portable signature.
  */
-static int evm_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
-			     struct iattr *attr)
+static int evm_path_setattr(const struct mnt_idmap *idmap,
+			    const struct path *path, struct dentry *dentry,
+			    struct iattr *attr, struct file *file)
 {
 	unsigned int ia_valid = attr->ia_valid;
 	enum integrity_status evm_status;
@@ -1229,7 +1232,7 @@ static int __init init_evm(void)
 }
 
 static struct security_hook_list evm_hooks[] __ro_after_init = {
-	LSM_HOOK_INIT(inode_setattr, evm_inode_setattr),
+	LSM_HOOK_INIT(path_setattr, evm_path_setattr),
 	LSM_HOOK_INIT(inode_post_setattr, evm_inode_post_setattr),
 	LSM_HOOK_INIT(inode_copy_up_xattr, evm_inode_copy_up_xattr),
 	LSM_HOOK_INIT(inode_setxattr, evm_inode_setxattr),
diff --git a/security/security.c b/security/security.c
index 6d2bdfaf234d..e27add36b0a6 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1866,10 +1866,13 @@ int security_inode_permission(const struct mnt_idmap *idmap,
 }
 
 /**
- * security_inode_setattr() - Check if setting file attributes is allowed
+ * security_path_setattr() - Check if setting file attributes is allowed
  * @idmap: idmap of the mount
- * @dentry: file
+ * @path: file (the VFS makes no guarantees with regard to @path->mnt)
+ * @dentry: inode whose attributes are changed; this can differ from
+ *          @path->dentry when a filesystem forwards the change
  * @attr: new attributes
+ * @file: file through which the attribute change is requested, if any
  *
  * Check permission before setting file attributes.  Note that the kernel call
  * to notify_change is performed from several locations, whenever file
@@ -1878,14 +1881,15 @@ int security_inode_permission(const struct mnt_idmap *idmap,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_setattr(const struct mnt_idmap *idmap,
-			   struct dentry *dentry, struct iattr *attr)
+int security_path_setattr(const struct mnt_idmap *idmap,
+			  const struct path *path, struct dentry *dentry,
+			  struct iattr *attr, struct file *file)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
 		return 0;
-	return call_int_hook(inode_setattr, idmap, dentry, attr);
+	return call_int_hook(path_setattr, idmap, path, dentry, attr, file);
 }
-EXPORT_SYMBOL_GPL(security_inode_setattr);
+EXPORT_SYMBOL_GPL(security_path_setattr);
 
 /**
  * security_inode_post_setattr() - Update the inode after a setattr operation
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 85b18c155a17..0d55906f62e5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3317,8 +3317,10 @@ static int selinux_inode_permission(const struct mnt_idmap *idmap,
 	return rc;
 }
 
-static int selinux_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
-				 struct iattr *iattr)
+static int selinux_path_setattr(const struct mnt_idmap *idmap,
+				const struct path *path,
+				struct dentry *dentry,
+				struct iattr *iattr, struct file *file)
 {
 	const struct cred *cred = current_cred();
 	struct inode *inode = d_backing_inode(dentry);
@@ -7737,7 +7739,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_readlink, selinux_inode_readlink),
 	LSM_HOOK_INIT(inode_follow_link, selinux_inode_follow_link),
 	LSM_HOOK_INIT(inode_permission, selinux_inode_permission),
-	LSM_HOOK_INIT(inode_setattr, selinux_inode_setattr),
+	LSM_HOOK_INIT(path_setattr, selinux_path_setattr),
 	LSM_HOOK_INIT(inode_getattr, selinux_inode_getattr),
 	LSM_HOOK_INIT(inode_xattr_skipcap, selinux_inode_xattr_skipcap),
 	LSM_HOOK_INIT(inode_setxattr, selinux_inode_setxattr),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 74c4a40ef028..c66cdb8a45d7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1265,15 +1265,19 @@ static int smack_inode_permission(const struct mnt_idmap *idmap, struct inode *i
 }
 
 /**
- * smack_inode_setattr - Smack check for setting attributes
+ * smack_path_setattr - Smack check for setting attributes
  * @idmap: idmap of the mount
- * @dentry: the object
+ * @path: the object
+ * @dentry: inode whose attributes are changed
  * @iattr: for the force flag
+ * @file: file through which the attribute change is requested, if any
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
-			       struct iattr *iattr)
+static int smack_path_setattr(const struct mnt_idmap *idmap,
+			      const struct path *path,
+			      struct dentry *dentry,
+			      struct iattr *iattr, struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
@@ -5200,7 +5204,7 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_rmdir, smack_inode_rmdir),
 	LSM_HOOK_INIT(inode_rename, smack_inode_rename),
 	LSM_HOOK_INIT(inode_permission, smack_inode_permission),
-	LSM_HOOK_INIT(inode_setattr, smack_inode_setattr),
+	LSM_HOOK_INIT(path_setattr, smack_path_setattr),
 	LSM_HOOK_INIT(inode_getattr, smack_inode_getattr),
 	LSM_HOOK_INIT(inode_xattr_skipcap, smack_inode_xattr_skipcap),
 	LSM_HOOK_INIT(inode_setxattr, smack_inode_setxattr),
-- 
2.18.0.huawei.25

