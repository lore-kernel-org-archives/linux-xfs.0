Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926042;
	b=N2U0/etSCgDssi4K8XXux+DRFU/CxSUfo6upqlb5CqvzP3X/pgv/SFEnE+RXWJ/duwsy
	 46IMo2eylPq6Q+ctxeOngr90SPGdBA3UFlfR3aPhxjfD4xObm1V6oZd8ymSdvPsEyqbVE
	 l0h0fpktxAtI3sR7TEJwk0+hACmoWP+jCrcIfjo+PQUhfYPoP6SJ2IN0Dh5C3L2Dy+DHn
	 kWM3YXUThufLAogHWOmJ1QCA5InGZlg1UFp3q8hJ8GWnd9QDTlp2fCfAMWvvCjSeXGEqy
	 ZN//LlgaXZ/n/pGGHnD9ZwL6WeKnG8aPrsN668J5D+oU1d+VfSxN7gc9XH+RjWveq6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926042;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=iid6+A0bHhQ6quljTxRKfijgZRj/kRg0WFASG0GQphI=;
	b=pyDq9KbIV/Kuo0IvQPnDqjnciN2pR6bjgr4IcXMIYnMSqUlK1GXTjfvjkAlnjgdQhpOq
	 BUGuXiMwpiJtm0k0Hspll2/kkKCTDbVCiGtwtD2b+a0SsAqLHZQf8O/2LnGqXh1jqvMtn
	 iOE7R318mDFz1KJXjiy8+uMWMFY5Hczg4EEg66FsmskVL6XCMpyuWUgBon+tA14LAD7mr
	 o0otzvM7dV1URyiep/jglFS8dulSxlOC6JCdfzPjSIw5yTGjC/HXbs9Bn6vwMnoPeumcA
	 s6I4d48cl78E3r1NhpyBfiyTyPLwcpQltvkq/UyG5HIkNkzLy9eNfFor4nyw+UGsaCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Km+ZMbga;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F6560A6F75;
	Tue, 17 Nov 2026 14:34:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95F6560A6F75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Km+ZMbga
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iid6+A0bHhQ6quljTxRKfijgZRj/kRg0WFASG0GQphI=;
	b=Km+ZMbgaqj/o7hZlL+XKZUmKwce0UED/+HTaC5gzf2i6nIhS4B5L8txJjvZg2WDR+tdVm+8Na
	9Vjs8KpG3t5bThUy3iQWqZf3/rJogJG0MXMjI160voaoqZg6skTEnxUEatIdkcCG17hA5GH4Tml
	wgE/6a4mP1dX0B4dToYTcU0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jTS015vs7z1cypX;
	Tue, 17 Nov 2026 22:33:37 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 1656040572;
	Tue, 17 Nov 2026 22:33:57 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:51 +0800
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
Subject: [PATCH -next -v4 06/17] LSM: pass struct path and struct file to the inode posix acl hooks
Date: Tue, 17 Nov 2026 23:05:31 +0800
Message-ID: <20261117150542.1169451-7-caixinchen1@huawei.com>
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

Convert the inode_set_acl, inode_get_acl and inode_remove_acl hooks and
their SELinux, Smack, EVM and IMA implementations to take a const struct
path instead of a dentry.  The implementations derive the dentry they
still need from the path, and the idmap stays a separate argument.

Also pass the struct file through which the operation is requested, when
there is one, for the same reason as for the xattr hooks, and add strong
definitions of the three bpf_lsm_* stubs naming it file__nullable.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/filesystems/porting.rst |  3 ++
 fs/ecryptfs/inode.c                   |  5 ++--
 fs/internal.h                         | 11 ++++---
 fs/overlayfs/inode.c                  |  4 +--
 fs/overlayfs/overlayfs.h              |  6 ++--
 fs/posix_acl.c                        | 26 ++++++++++-------
 fs/smb/server/vfs.c                   |  2 +-
 fs/xattr.c                            |  7 +++--
 include/linux/lsm_hook_defs.h         |  9 ++++--
 include/linux/posix_acl.h             | 14 +++++----
 include/linux/security.h              | 25 +++++++++-------
 kernel/bpf/bpf_lsm_proto.c            | 29 ++++++++++++++++++
 security/integrity/evm/evm_main.c     | 22 +++++++++-----
 security/integrity/ima/ima_appraise.c | 15 ++++++----
 security/security.c                   | 42 +++++++++++++++++----------
 security/selinux/hooks.c              | 17 ++++++-----
 security/smack/smack_lsm.c            | 41 ++++++++++++++++----------
 17 files changed, 183 insertions(+), 95 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 973f3650f8b5..01890bda8479 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1471,3 +1471,6 @@ struct dentry *, keeping the mnt_idmap as a separate first argument.  The
 idmap is not derived from the path: it must be the idmap of the mount the
 operation is performed through, which for a stacking filesystem may belong
 to a different mount than the one the passed path was built from.
+vfs_set_acl(), vfs_get_acl() and vfs_remove_acl() also take a trailing
+struct file through which the operation is requested, or NULL for
+path-based callers.
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 76abf142ab59..e4a1e2f346c8 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1097,7 +1097,8 @@ static struct posix_acl *ecryptfs_get_acl(const struct mnt_idmap *idmap,
 {
 	struct path lower_path = ecryptfs_lower_path(dentry);
 
-	return vfs_get_acl(idmap, &lower_path, posix_acl_xattr_name(type));
+	return vfs_get_acl(idmap, &lower_path, posix_acl_xattr_name(type),
+			   NULL);
 }
 
 static int ecryptfs_set_acl(const struct mnt_idmap *idmap,
@@ -1109,7 +1110,7 @@ static int ecryptfs_set_acl(const struct mnt_idmap *idmap,
 	struct inode *lower_inode = d_inode(lower_path.dentry);
 
 	rc = vfs_set_acl(&nop_mnt_idmap, &lower_path,
-			 posix_acl_xattr_name(type), acl);
+			 posix_acl_xattr_name(type), acl, NULL);
 	if (!rc)
 		fsstack_copy_attr_all(d_inode(dentry), lower_inode);
 	return rc;
diff --git a/fs/internal.h b/fs/internal.h
index 734cd922475a..d6a3b48f1633 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -306,20 +306,23 @@ int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
 int do_set_acl(const struct mnt_idmap *idmap, const struct path *path,
-	       const char *acl_name, const void *kvalue, size_t size);
+	       const char *acl_name, const void *kvalue, size_t size,
+	       struct file *file);
 ssize_t do_get_acl(const struct mnt_idmap *idmap, const struct path *path,
-		   const char *acl_name, void *kvalue, size_t size);
+		   const char *acl_name, void *kvalue, size_t size,
+		   struct file *file);
 #else
 static inline int do_set_acl(const struct mnt_idmap *idmap,
 			     const struct path *path, const char *acl_name,
-			     const void *kvalue, size_t size)
+			     const void *kvalue, size_t size,
+			     struct file *file)
 {
 	return -EOPNOTSUPP;
 }
 static inline ssize_t do_get_acl(const struct mnt_idmap *idmap,
 				 const struct path *path,
 				 const char *acl_name, void *kvalue,
-				 size_t size)
+				 size_t size, struct file *file)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 95666163075c..1700cc74ef01 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -414,7 +414,7 @@ struct posix_acl *ovl_get_acl_path(const struct path *path,
 	if (noperm)
 		real_acl = get_inode_acl(realinode, posix_acl_type(acl_name));
 	else
-		real_acl = vfs_get_acl(idmap, path, acl_name);
+		real_acl = vfs_get_acl(idmap, path, acl_name, NULL);
 	if (IS_ERR_OR_NULL(real_acl))
 		return real_acl;
 
@@ -503,7 +503,7 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 		ovl_path_lower(dentry, &realpath);
 		with_ovl_creds(dentry->d_sb)
 			real_acl = vfs_get_acl(mnt_idmap(realpath.mnt),
-					       &realpath, acl_name);
+					       &realpath, acl_name, NULL);
 		if (IS_ERR(real_acl)) {
 			err = PTR_ERR(real_acl);
 			goto out;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fb603044b59f..71885794421e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -384,7 +384,8 @@ static inline int ovl_do_set_acl(struct ovl_fs *ofs, struct dentry *dentry,
 		.dentry = dentry,
 	};
 
-	return vfs_set_acl(ovl_upper_mnt_idmap(ofs), &path, acl_name, acl);
+	return vfs_set_acl(ovl_upper_mnt_idmap(ofs), &path, acl_name, acl,
+			   NULL);
 }
 
 static inline int ovl_do_remove_acl(struct ovl_fs *ofs, struct dentry *dentry,
@@ -395,7 +396,8 @@ static inline int ovl_do_remove_acl(struct ovl_fs *ofs, struct dentry *dentry,
 		.dentry = dentry,
 	};
 
-	return vfs_remove_acl(ovl_upper_mnt_idmap(ofs), &path, acl_name);
+	return vfs_remove_acl(ovl_upper_mnt_idmap(ofs), &path, acl_name,
+			      NULL);
 }
 
 static inline int ovl_do_rename_rd(struct renamedata *rd)
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index c0f835192191..4de0ad023df8 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -1088,6 +1088,7 @@ static int vfs_set_acl_idmapped_mnt(const struct mnt_idmap *idmap,
  * @path: the path the posix acls are set on
  * @acl_name: the name of the posix acl
  * @kacl: the posix acls in the appropriate VFS format
+ * @file: file through which the posix acls are set, or NULL
  *
  * This function sets @kacl. The caller must all posix_acl_release() on @kacl
  * afterwards.
@@ -1095,7 +1096,8 @@ static int vfs_set_acl_idmapped_mnt(const struct mnt_idmap *idmap,
  * Return: On success 0, on error negative errno.
  */
 int vfs_set_acl(const struct mnt_idmap *idmap, const struct path *path,
-		const char *acl_name, struct posix_acl *kacl)
+		const char *acl_name, struct posix_acl *kacl,
+		struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	int acl_type;
@@ -1131,7 +1133,7 @@ int vfs_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 	if (error)
 		goto out_inode_unlock;
 
-	error = security_inode_set_acl(idmap, dentry, acl_name, kacl);
+	error = security_inode_set_acl(idmap, path, acl_name, kacl, file);
 	if (error)
 		goto out_inode_unlock;
 
@@ -1169,6 +1171,7 @@ EXPORT_SYMBOL_GPL(vfs_set_acl);
  *         through
  * @path: the path the posix acls are retrieved from
  * @acl_name: the name of the posix acl
+ * @file: file through which the posix acls are retrieved, or NULL
  *
  * This function retrieves @kacl from the filesystem. The caller must all
  * posix_acl_release() on @kacl.
@@ -1177,7 +1180,7 @@ EXPORT_SYMBOL_GPL(vfs_set_acl);
  */
 struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 			      const struct path *path,
-			      const char *acl_name)
+			      const char *acl_name, struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
@@ -1192,7 +1195,7 @@ struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 	 * The VFS has no restrictions on reading POSIX ACLs so calling
 	 * something like xattr_permission() isn't needed. Only LSMs get a say.
 	 */
-	error = security_inode_get_acl(idmap, dentry, acl_name);
+	error = security_inode_get_acl(idmap, path, acl_name, file);
 	if (error)
 		return ERR_PTR(error);
 
@@ -1219,13 +1222,14 @@ EXPORT_SYMBOL_GPL(vfs_get_acl);
  *         through
  * @path: the path the posix acls are removed from
  * @acl_name: the name of the posix acl
+ * @file: file through which the posix acls are removed, or NULL
  *
  * This function removes posix acls.
  *
  * Return: On success 0, on error negative errno.
  */
 int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
-		   const char *acl_name)
+		   const char *acl_name, struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	int acl_type;
@@ -1248,7 +1252,7 @@ int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
 	if (error)
 		goto out_inode_unlock;
 
-	error = security_inode_remove_acl(idmap, dentry, acl_name);
+	error = security_inode_remove_acl(idmap, path, acl_name, file);
 	if (error)
 		goto out_inode_unlock;
 
@@ -1279,7 +1283,8 @@ int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
 EXPORT_SYMBOL_GPL(vfs_remove_acl);
 
 int do_set_acl(const struct mnt_idmap *idmap, const struct path *path,
-	       const char *acl_name, const void *kvalue, size_t size)
+	       const char *acl_name, const void *kvalue, size_t size,
+	       struct file *file)
 {
 	int error;
 	struct posix_acl *acl = NULL;
@@ -1294,18 +1299,19 @@ int do_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 			return PTR_ERR(acl);
 	}
 
-	error = vfs_set_acl(idmap, path, acl_name, acl);
+	error = vfs_set_acl(idmap, path, acl_name, acl, file);
 	posix_acl_release(acl);
 	return error;
 }
 
 ssize_t do_get_acl(const struct mnt_idmap *idmap, const struct path *path,
-		   const char *acl_name, void *kvalue, size_t size)
+		   const char *acl_name, void *kvalue, size_t size,
+		   struct file *file)
 {
 	ssize_t error;
 	struct posix_acl *acl;
 
-	acl = vfs_get_acl(idmap, path, acl_name);
+	acl = vfs_get_acl(idmap, path, acl_name, file);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index af7aef0c89fc..efb66a914a8e 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1569,7 +1569,7 @@ int ksmbd_vfs_remove_acl_xattrs(const struct mnt_idmap *idmap,
 			     sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1) ||
 		    !strncmp(name, XATTR_NAME_POSIX_ACL_DEFAULT,
 			     sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1)) {
-			err = vfs_remove_acl(idmap, path, name);
+			err = vfs_remove_acl(idmap, path, name, NULL);
 			if (err)
 				ksmbd_debug(SMB,
 					    "remove acl xattr failed : %s\n", name);
diff --git a/fs/xattr.c b/fs/xattr.c
index 5256372e0fe9..a07d03a0502f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -670,7 +670,7 @@ static int do_setxattr(const struct mnt_idmap *idmap, const struct path *path,
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
 		return do_set_acl(idmap, path, ctx->kname->name,
-				  ctx->kvalue, ctx->size);
+				  ctx->kvalue, ctx->size, file);
 
 	return vfs_setxattr(idmap, path, ctx->kname->name,
 			ctx->kvalue, ctx->size, ctx->flags, file);
@@ -816,7 +816,8 @@ do_getxattr(const struct mnt_idmap *idmap, const struct path *path,
 	}
 
 	if (is_posix_acl_xattr(kname))
-		error = do_get_acl(idmap, path, kname, kvalue, ctx->size);
+		error = do_get_acl(idmap, path, kname, kvalue,
+				   ctx->size, file);
 	else
 		error = vfs_getxattr(idmap, path, kname, kvalue,
 				     ctx->size, file);
@@ -1048,7 +1049,7 @@ removexattr(const struct mnt_idmap *idmap, const struct path *path,
 	    const char *name, struct file *file)
 {
 	if (is_posix_acl_xattr(name))
-		return vfs_remove_acl(idmap, path, name);
+		return vfs_remove_acl(idmap, path, name, file);
 	return vfs_removexattr(idmap, path, name, file);
 }
 
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index b1fffff5b3e0..229eaee0a0dd 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -169,13 +169,16 @@ LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
 LSM_HOOK(int, 0, inode_file_setattr, struct dentry *dentry, struct file_kattr *fa)
 LSM_HOOK(int, 0, inode_file_getattr, struct dentry *dentry, struct file_kattr *fa)
 LSM_HOOK(int, 0, inode_set_acl, const struct mnt_idmap *idmap,
-	 struct dentry *dentry, const char *acl_name, struct posix_acl *kacl)
+	 const struct path *path, const char *acl_name,
+	 struct posix_acl *kacl, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_set_acl, struct dentry *dentry,
 	 const char *acl_name, struct posix_acl *kacl)
 LSM_HOOK(int, 0, inode_get_acl, const struct mnt_idmap *idmap,
-	 struct dentry *dentry, const char *acl_name)
+	 const struct path *path, const char *acl_name,
+	 struct file *file)
 LSM_HOOK(int, 0, inode_remove_acl, const struct mnt_idmap *idmap,
-	 struct dentry *dentry, const char *acl_name)
+	 const struct path *path, const char *acl_name,
+	 struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, const char *acl_name)
 LSM_HOOK(int, 0, inode_need_killpriv, struct dentry *dentry)
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 5a9c743dbab5..c3c926b3fdeb 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -107,12 +107,13 @@ static inline void cache_no_acl(struct inode *inode)
 }
 
 int vfs_set_acl(const struct mnt_idmap *idmap, const struct path *path,
-		const char *acl_name, struct posix_acl *kacl);
+		const char *acl_name, struct posix_acl *kacl,
+		struct file *file);
 struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 			      const struct path *path,
-			      const char *acl_name);
+			      const char *acl_name, struct file *file);
 int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
-		   const char *acl_name);
+		   const char *acl_name, struct file *file);
 int posix_acl_listxattr(struct inode *inode, char **buffer,
 			ssize_t *remaining_size);
 #else
@@ -145,21 +146,22 @@ static inline void forget_all_cached_acls(struct inode *inode)
 
 static inline int vfs_set_acl(const struct mnt_idmap *idmap,
 			      const struct path *path, const char *name,
-			      struct posix_acl *acl)
+			      struct posix_acl *acl, struct file *file)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 					    const struct path *path,
-					    const char *acl_name)
+					    const char *acl_name,
+					    struct file *file)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
 static inline int vfs_remove_acl(const struct mnt_idmap *idmap,
 				 const struct path *path,
-				 const char *acl_name)
+				 const char *acl_name, struct file *file)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/security.h b/include/linux/security.h
index d93492054c8d..cbd50cd38255 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -440,14 +440,16 @@ int security_inode_setxattr(const struct mnt_idmap *idmap,
 			    const void *value, size_t size, int flags,
 			    struct file *file);
 int security_inode_set_acl(const struct mnt_idmap *idmap,
-			   struct dentry *dentry, const char *acl_name,
-			   struct posix_acl *kacl);
+			   const struct path *path, const char *acl_name,
+			   struct posix_acl *kacl, struct file *file);
 void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
 				 struct posix_acl *kacl);
 int security_inode_get_acl(const struct mnt_idmap *idmap,
-			   struct dentry *dentry, const char *acl_name);
+			   const struct path *path, const char *acl_name,
+			   struct file *file);
 int security_inode_remove_acl(const struct mnt_idmap *idmap,
-			      struct dentry *dentry, const char *acl_name);
+			      const struct path *path, const char *acl_name,
+			      struct file *file);
 void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
 				    struct dentry *dentry,
 				    const char *acl_name);
@@ -1026,9 +1028,10 @@ static inline int security_inode_setxattr(const struct mnt_idmap *idmap,
 }
 
 static inline int security_inode_set_acl(const struct mnt_idmap *idmap,
-					 struct dentry *dentry,
+					 const struct path *path,
 					 const char *acl_name,
-					 struct posix_acl *kacl)
+					 struct posix_acl *kacl,
+					 struct file *file)
 {
 	return 0;
 }
@@ -1039,15 +1042,17 @@ static inline void security_inode_post_set_acl(struct dentry *dentry,
 { }
 
 static inline int security_inode_get_acl(const struct mnt_idmap *idmap,
-					 struct dentry *dentry,
-					 const char *acl_name)
+					 const struct path *path,
+					 const char *acl_name,
+					 struct file *file)
 {
 	return 0;
 }
 
 static inline int security_inode_remove_acl(const struct mnt_idmap *idmap,
-					    struct dentry *dentry,
-					    const char *acl_name)
+					    const struct path *path,
+					    const char *acl_name,
+					    struct file *file)
 {
 	return 0;
 }
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index 921910e2a1c5..4454c1fdbe6b 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -65,3 +65,32 @@ noinline int bpf_lsm_inode_removexattr(const struct mnt_idmap *idmap,
 {
 	return 0;
 }
+
+/*
+ * Strong definitions of the inode POSIX ACL BPF LSM hooks.  The file argument
+ * is only set for file descriptor-based operations and is NULL for path-based
+ * and in-kernel callers, so mark it as PTR_MAYBE_NULL.
+ */
+noinline int bpf_lsm_inode_set_acl(const struct mnt_idmap *idmap,
+				   const struct path *path,
+				   const char *acl_name, struct posix_acl *kacl,
+				   struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_inode_get_acl(const struct mnt_idmap *idmap,
+				   const struct path *path,
+				   const char *acl_name,
+				   struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_inode_remove_acl(const struct mnt_idmap *idmap,
+				      const struct path *path,
+				      const char *acl_name,
+				      struct file *file__nullable)
+{
+	return 0;
+}
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index d5407ed88fdc..963a1bc89a7d 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -710,10 +710,11 @@ static inline int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
 
 /**
  * evm_inode_set_acl - protect the EVM extended attribute from posix acls
- * @idmap: idmap of the idmapped mount
- * @dentry: pointer to the affected dentry
+ * @idmap: idmap of the mount
+ * @path: pointer to the affected object
  * @acl_name: name of the posix acl
  * @kacl: pointer to the posix acls
+ * @file: file through which the posix acls are set, if any
  *
  * Prevent modifying posix acls causing the EVM HMAC to be re-calculated
  * and 'security.evm' xattr updated, unless the existing 'security.evm' is
@@ -721,10 +722,13 @@ static inline int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
  *
  * Return: zero on success, -EPERM on failure.
  */
-static int evm_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
-			     const char *acl_name, struct posix_acl *kacl)
+static int evm_inode_set_acl(const struct mnt_idmap *idmap,
+			     const struct path *path,
+			     const char *acl_name, struct posix_acl *kacl,
+			     struct file *file)
 {
 	enum integrity_status evm_status;
+	struct dentry *dentry = path->dentry;
 
 	/* Policy permits modification of the protected xattrs even though
 	 * there's no HMAC key loaded
@@ -764,8 +768,9 @@ static int evm_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentr
 /**
  * evm_inode_remove_acl - Protect the EVM extended attribute from posix acls
  * @idmap: idmap of the mount
- * @dentry: pointer to the affected dentry
+ * @path: pointer to the affected object
  * @acl_name: name of the posix acl
+ * @file: file through which the posix acls are removed, if any
  *
  * Prevent removing posix acls causing the EVM HMAC to be re-calculated
  * and 'security.evm' xattr updated, unless the existing 'security.evm' is
@@ -773,10 +778,11 @@ static int evm_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentr
  *
  * Return: zero on success, -EPERM on failure.
  */
-static int evm_inode_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
-				const char *acl_name)
+static int evm_inode_remove_acl(const struct mnt_idmap *idmap,
+				const struct path *path,
+				const char *acl_name, struct file *file)
 {
-	return evm_inode_set_acl(idmap, dentry, acl_name, NULL);
+	return evm_inode_set_acl(idmap, path, acl_name, NULL, file);
 }
 
 static void evm_reset_status(struct inode *inode)
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index ebf050195cf0..a231f1f419f7 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -795,11 +795,13 @@ static int ima_inode_setxattr(const struct mnt_idmap *idmap,
 	return result;
 }
 
-static int ima_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
-			     const char *acl_name, struct posix_acl *kacl)
+static int ima_inode_set_acl(const struct mnt_idmap *idmap,
+			     const struct path *path,
+			     const char *acl_name, struct posix_acl *kacl,
+			     struct file *file)
 {
 	if (evm_revalidate_status(acl_name))
-		ima_reset_appraise_flags(d_backing_inode(dentry), -1);
+		ima_reset_appraise_flags(d_backing_inode(path->dentry), -1);
 
 	return 0;
 }
@@ -821,10 +823,11 @@ static int ima_inode_removexattr(const struct mnt_idmap *idmap,
 	return result;
 }
 
-static int ima_inode_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
-				const char *acl_name)
+static int ima_inode_remove_acl(const struct mnt_idmap *idmap,
+				 const struct path *path,
+				 const char *acl_name, struct file *file)
 {
-	return ima_inode_set_acl(idmap, dentry, acl_name, NULL);
+	return ima_inode_set_acl(idmap, path, acl_name, NULL, file);
 }
 
 static struct security_hook_list ima_appraise_hooks[] __ro_after_init = {
diff --git a/security/security.c b/security/security.c
index e01969809ac5..b62a6e63dea1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1969,9 +1969,12 @@ int security_inode_setxattr(const struct mnt_idmap *idmap,
 /**
  * security_inode_set_acl() - Check if setting posix acls is allowed
  * @idmap: idmap of the mount
- * @dentry: file
+ * @path: the object the posix acls are set on (the VFS makes no guarantees
+ *        with regard to @path->mnt)
  * @acl_name: acl name
  * @kacl: acl struct
+ * @file: file through which the posix acls are set, if any; it refers to
+ *        the same object as @path
  *
  * Check permission before setting posix acls, the posix acls in @kacl are
  * identified by @acl_name.
@@ -1979,12 +1982,13 @@ int security_inode_setxattr(const struct mnt_idmap *idmap,
  * Return: Returns 0 if permission is granted.
  */
 int security_inode_set_acl(const struct mnt_idmap *idmap,
-			   struct dentry *dentry, const char *acl_name,
-			   struct posix_acl *kacl)
+			   const struct path *path, const char *acl_name,
+			   struct posix_acl *kacl, struct file *file)
 {
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_set_acl, idmap, dentry, acl_name, kacl);
+	return call_int_hook(inode_set_acl, idmap, path, acl_name, kacl,
+			       file);
 }
 
 /**
@@ -2007,27 +2011,34 @@ void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
 /**
  * security_inode_get_acl() - Check if reading posix acls is allowed
  * @idmap: idmap of the mount
- * @dentry: file
+ * @path: the object the posix acls are retrieved from (the VFS makes no
+ *        guarantees with regard to @path->mnt)
  * @acl_name: acl name
+ * @file: file through which the posix acls are retrieved, if any; it
+ *        refers to the same object as @path
  *
- * Check permission before getting osix acls, the posix acls are identified by
- * @acl_name.
+ * Check permission before getting posix acls, the posix acls are identified
+ * by @acl_name.
  *
  * Return: Returns 0 if permission is granted.
  */
 int security_inode_get_acl(const struct mnt_idmap *idmap,
-			   struct dentry *dentry, const char *acl_name)
+			   const struct path *path, const char *acl_name,
+			   struct file *file)
 {
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_get_acl, idmap, dentry, acl_name);
+	return call_int_hook(inode_get_acl, idmap, path, acl_name, file);
 }
 
 /**
  * security_inode_remove_acl() - Check if removing a posix acl is allowed
  * @idmap: idmap of the mount
- * @dentry: file
+ * @path: the object the posix acl is removed from (the VFS makes no
+ *        guarantees with regard to @path->mnt)
  * @acl_name: acl name
+ * @file: file through which the posix acl is removed, if any; it refers to
+ *        the same object as @path
  *
  * Check permission before removing posix acls, the posix acls are identified
  * by @acl_name.
@@ -2035,11 +2046,12 @@ int security_inode_get_acl(const struct mnt_idmap *idmap,
  * Return: Returns 0 if permission is granted.
  */
 int security_inode_remove_acl(const struct mnt_idmap *idmap,
-			      struct dentry *dentry, const char *acl_name)
+			      const struct path *path, const char *acl_name,
+			      struct file *file)
 {
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_remove_acl, idmap, dentry, acl_name);
+	return call_int_hook(inode_remove_acl, idmap, path, acl_name, file);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f38105ccc1fb..bd7ae5433575 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3476,22 +3476,25 @@ static int selinux_inode_setxattr(const struct mnt_idmap *idmap,
 }
 
 static int selinux_inode_set_acl(const struct mnt_idmap *idmap,
-				 struct dentry *dentry, const char *acl_name,
-				 struct posix_acl *kacl)
+				 const struct path *path,
+				 const char *acl_name, struct posix_acl *kacl,
+				 struct file *file)
 {
-	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
+	return dentry_has_perm(current_cred(), path->dentry, FILE__SETATTR);
 }
 
 static int selinux_inode_get_acl(const struct mnt_idmap *idmap,
-				 struct dentry *dentry, const char *acl_name)
+				 const struct path *path,
+				 const char *acl_name, struct file *file)
 {
-	return dentry_has_perm(current_cred(), dentry, FILE__GETATTR);
+	return dentry_has_perm(current_cred(), path->dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_remove_acl(const struct mnt_idmap *idmap,
-				    struct dentry *dentry, const char *acl_name)
+				    const struct path *path,
+				    const char *acl_name, struct file *file)
 {
-	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
+	return dentry_has_perm(current_cred(), path->dentry, FILE__SETATTR);
 }
 
 static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index be522c236dbf..74c4a40ef028 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1548,68 +1548,77 @@ static int smack_inode_removexattr(const struct mnt_idmap *idmap,
 /**
  * smack_inode_set_acl - Smack check for setting posix acls
  * @idmap: idmap of the mnt this request came from
- * @dentry: the object
+ * @path: the object
  * @acl_name: name of the posix acl
  * @kacl: the posix acls
+ * @file: file through which the posix acls are set, if any
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
 static int smack_inode_set_acl(const struct mnt_idmap *idmap,
-			       struct dentry *dentry, const char *acl_name,
-			       struct posix_acl *kacl)
+			       const struct path *path,
+			       const char *acl_name, struct posix_acl *kacl,
+			       struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
-	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
+	smk_ad_setfield_u_fs_path_dentry(&ad, path->dentry);
 
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_WRITE, &ad);
-	rc = smk_bu_inode(d_backing_inode(dentry), MAY_WRITE, rc);
+	rc = smk_curacc(smk_of_inode(d_backing_inode(path->dentry)),
+			MAY_WRITE, &ad);
+	rc = smk_bu_inode(d_backing_inode(path->dentry), MAY_WRITE, rc);
 	return rc;
 }
 
 /**
  * smack_inode_get_acl - Smack check for getting posix acls
  * @idmap: idmap of the mnt this request came from
- * @dentry: the object
+ * @path: the object
  * @acl_name: name of the posix acl
+ * @file: file through which the posix acls are retrieved, if any
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
 static int smack_inode_get_acl(const struct mnt_idmap *idmap,
-			       struct dentry *dentry, const char *acl_name)
+			       const struct path *path,
+			       const char *acl_name, struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
-	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
+	smk_ad_setfield_u_fs_path_dentry(&ad, path->dentry);
 
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_READ, &ad);
-	rc = smk_bu_inode(d_backing_inode(dentry), MAY_READ, rc);
+	rc = smk_curacc(smk_of_inode(d_backing_inode(path->dentry)),
+			MAY_READ, &ad);
+	rc = smk_bu_inode(d_backing_inode(path->dentry), MAY_READ, rc);
 	return rc;
 }
 
 /**
  * smack_inode_remove_acl - Smack check for getting posix acls
  * @idmap: idmap of the mnt this request came from
- * @dentry: the object
+ * @path: the object
  * @acl_name: name of the posix acl
+ * @file: file through which the posix acls are removed, if any
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
 static int smack_inode_remove_acl(const struct mnt_idmap *idmap,
-				  struct dentry *dentry, const char *acl_name)
+				  const struct path *path,
+				  const char *acl_name, struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
-	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
+	smk_ad_setfield_u_fs_path_dentry(&ad, path->dentry);
 
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_WRITE, &ad);
-	rc = smk_bu_inode(d_backing_inode(dentry), MAY_WRITE, rc);
+	rc = smk_curacc(smk_of_inode(d_backing_inode(path->dentry)),
+			MAY_WRITE, &ad);
+	rc = smk_bu_inode(d_backing_inode(path->dentry), MAY_WRITE, rc);
 	return rc;
 }
 
-- 
2.18.0.huawei.25

