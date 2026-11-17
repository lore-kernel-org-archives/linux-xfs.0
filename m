Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926036;
	b=cVC3qL8LAs0hqh+Aud/PcIOrVSrzb/qbPVEbT1jK6K0QaYsMX1hkxkw94INE60l5ZeiK
	 tAYSP3PIzgm6wePKumBdAvqMDfmtMdZB6xx2pZZjAIfqL5Qdmsi8k6AsHxWqgPudMHvlG
	 heRHh7WM160QKf/ypTsiYpvor/0Ez6cM+DuXnKnensVjceFbtk3O2glHEmw4JXjT49vE3
	 Ltrg8N7YtWmHMkKap92Jra6LN4KpHbh2onPi76EalWsQw5f+dU+OT7WMljDgrrqBu/O0E
	 QkYmW1XLzkwd4Mmx7MaVe+UojAZ/HWZfals7yVG6annIgzSlkKlJ+vOlS31cICOfDMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926036;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=qKSPHpCEFBbD662WV0kLPx6nWHeeW38aWmb9A32DgB4=;
	b=Hvv07tTiwP0abmsD//Nt6wW1MJQ03akerONg31DS7sUMgdDlaOkOughFEKzqMVyDZkGL
	 oWmyj0CKlC0Ll1k8DXsKuHG4fbgeJY7QTMZ+vZ7/EBN64ou5kBKRZ69d3N2n/wut43kfl
	 oPpAh0CpFHuXVCPpL1oFByDe2rSIlLm7zKUryGle9XB2isZT8sZM4+yvV/K4bugTzhrtf
	 v8GAHTOuldEGi/cpuYVGjMde2VYwxsPnMLF3bhCO5I0u4xobQJIYu41nY7OS0h4cTX9IQ
	 lCE81BCeUioRi8m1kBWKAuyOLY5Nwz+FTPAp6SBz+SQK2Bi2Wv7zaKCOqddmnSk4vug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=53sJFCZw;
	arc=none smtp.remote-ip=113.46.200.219
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA4D60A2600;
	Tue, 17 Nov 2026 14:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEA4D60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=53sJFCZw
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qKSPHpCEFBbD662WV0kLPx6nWHeeW38aWmb9A32DgB4=;
	b=53sJFCZwzZcI9d2UxiHQCnsfEzSvTrrRzJsKNrkAZRbGc/0tYwXAlVpdeUky6Wikc5Y46xlVK
	0AUMM/oSAjIlWhwig0rkRBkNm3rKzHM7Aq+LDUpzgRmqNsJM0aXSWAubVpBuDoIZBJhw1h1/+oy
	3kGVcutaRqLGgJ5dBqwUjDs=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jTRzx3pvtz1prjs;
	Tue, 17 Nov 2026 22:33:33 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id DF24040686;
	Tue, 17 Nov 2026 22:33:45 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:40 +0800
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
Subject: [PATCH -next -v4 04/17] fs: pass struct path to POSIX ACL helpers
Date: Tue, 17 Nov 2026 23:05:29 +0800
Message-ID: <20261117150542.1169451-5-caixinchen1@huawei.com>
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

vfs_set_acl(), vfs_get_acl(), vfs_remove_acl() and the
do_set_acl()/do_get_acl() helpers take a struct dentry even though their
callers either hold a struct path (or a struct file).  Pass a struct path
instead, with the idmap still as a separate first argument.

set_posix_acl() keeps taking a dentry, as it is called from
inode_operations->set_acl.  ecryptfs_set_acl() keeps passing
&nop_mnt_idmap because its ACLs have already been translated into global
ids, while ecryptfs_get_acl() threads the upper idmap down.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/filesystems/porting.rst | 11 +++++++
 fs/ecryptfs/inode.c                   | 11 +++----
 fs/internal.h                         | 11 +++----
 fs/overlayfs/inode.c                  |  5 ++--
 fs/overlayfs/overlayfs.h              | 14 +++++++--
 fs/posix_acl.c                        | 41 ++++++++++++++++++---------
 fs/smb/server/vfs.c                   |  2 +-
 fs/xattr.c                            |  9 +++---
 include/linux/posix_acl.h             | 15 ++++++----
 9 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 82be56207772..034252f0da77 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1447,3 +1447,14 @@ which notify_change() sets for the duration of the call; it must not be
 stored beyond that.  Filesystems that forward a change to another inode
 can use notify_change_target() to update the target dentry while keeping
 the caller-supplied path in ia_path.
+
+---
+
+**mandatory**
+
+vfs_set_acl(), vfs_get_acl() and vfs_remove_acl(), along with
+do_set_acl() and do_get_acl(), now take a const struct path * instead of a
+struct dentry *, keeping the mnt_idmap as a separate first argument.  The
+idmap is not derived from the path: it must be the idmap of the mount the
+operation is performed through, which for a stacking filesystem may belong
+to a different mount than the one the passed path was built from.
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index c1be27e1f7eb..7db6fa6e5274 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1095,8 +1095,9 @@ static int ecryptfs_fileattr_set(const struct mnt_idmap *idmap,
 static struct posix_acl *ecryptfs_get_acl(const struct mnt_idmap *idmap,
 					  struct dentry *dentry, int type)
 {
-	return vfs_get_acl(idmap, ecryptfs_dentry_to_lower(dentry),
-			   posix_acl_xattr_name(type));
+	struct path lower_path = ecryptfs_lower_path(dentry);
+
+	return vfs_get_acl(idmap, &lower_path, posix_acl_xattr_name(type));
 }
 
 static int ecryptfs_set_acl(const struct mnt_idmap *idmap,
@@ -1104,10 +1105,10 @@ static int ecryptfs_set_acl(const struct mnt_idmap *idmap,
 			    int type)
 {
 	int rc;
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	struct inode *lower_inode = d_inode(lower_dentry);
+	struct path lower_path = ecryptfs_lower_path(dentry);
+	struct inode *lower_inode = d_inode(lower_path.dentry);
 
-	rc = vfs_set_acl(&nop_mnt_idmap, lower_dentry,
+	rc = vfs_set_acl(&nop_mnt_idmap, &lower_path,
 			 posix_acl_xattr_name(type), acl);
 	if (!rc)
 		fsstack_copy_attr_all(d_inode(dentry), lower_inode);
diff --git a/fs/internal.h b/fs/internal.h
index 9580afef293e..734cd922475a 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -305,20 +305,21 @@ int import_xattr_name(struct xattr_name *kname, const char __user *name);
 int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
 
 #ifdef CONFIG_FS_POSIX_ACL
-int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+int do_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 	       const char *acl_name, const void *kvalue, size_t size);
-ssize_t do_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+ssize_t do_get_acl(const struct mnt_idmap *idmap, const struct path *path,
 		   const char *acl_name, void *kvalue, size_t size);
 #else
 static inline int do_set_acl(const struct mnt_idmap *idmap,
-			     struct dentry *dentry, const char *acl_name,
+			     const struct path *path, const char *acl_name,
 			     const void *kvalue, size_t size)
 {
 	return -EOPNOTSUPP;
 }
 static inline ssize_t do_get_acl(const struct mnt_idmap *idmap,
-				 struct dentry *dentry, const char *acl_name,
-				 void *kvalue, size_t size)
+				 const struct path *path,
+				 const char *acl_name, void *kvalue,
+				 size_t size)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f1c6df39d0ae..95666163075c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -414,7 +414,7 @@ struct posix_acl *ovl_get_acl_path(const struct path *path,
 	if (noperm)
 		real_acl = get_inode_acl(realinode, posix_acl_type(acl_name));
 	else
-		real_acl = vfs_get_acl(idmap, path->dentry, acl_name);
+		real_acl = vfs_get_acl(idmap, path, acl_name);
 	if (IS_ERR_OR_NULL(real_acl))
 		return real_acl;
 
@@ -502,7 +502,8 @@ static int ovl_set_or_remove_acl(struct dentry *dentry, struct inode *inode,
 
 		ovl_path_lower(dentry, &realpath);
 		with_ovl_creds(dentry->d_sb)
-			real_acl = vfs_get_acl(mnt_idmap(realpath.mnt), realdentry, acl_name);
+			real_acl = vfs_get_acl(mnt_idmap(realpath.mnt),
+					       &realpath, acl_name);
 		if (IS_ERR(real_acl)) {
 			err = PTR_ERR(real_acl);
 			goto out;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2c7beb041ef0..413f1214b1bb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -377,13 +377,23 @@ static inline int ovl_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 static inline int ovl_do_set_acl(struct ovl_fs *ofs, struct dentry *dentry,
 				 const char *acl_name, struct posix_acl *acl)
 {
-	return vfs_set_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name, acl);
+	struct path path = {
+		.mnt = ovl_upper_mnt(ofs),
+		.dentry = dentry,
+	};
+
+	return vfs_set_acl(ovl_upper_mnt_idmap(ofs), &path, acl_name, acl);
 }
 
 static inline int ovl_do_remove_acl(struct ovl_fs *ofs, struct dentry *dentry,
 				    const char *acl_name)
 {
-	return vfs_remove_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name);
+	struct path path = {
+		.mnt = ovl_upper_mnt(ofs),
+		.dentry = dentry,
+	};
+
+	return vfs_remove_acl(ovl_upper_mnt_idmap(ofs), &path, acl_name);
 }
 
 static inline int ovl_do_rename_rd(struct renamedata *rd)
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index fe77934ea8f2..c0f835192191 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -1081,8 +1081,11 @@ static int vfs_set_acl_idmapped_mnt(const struct mnt_idmap *idmap,
 
 /**
  * vfs_set_acl - set posix acls
- * @idmap: idmap of the mount
- * @dentry: the dentry based on which to set the posix acls
+ * @idmap: idmap of the mount the posix acls are set through; it is not
+ *         derived from @path->mnt, which for a stacking filesystem may
+ *         belong to a different mount than the operation was requested
+ *         through
+ * @path: the path the posix acls are set on
  * @acl_name: the name of the posix acl
  * @kacl: the posix acls in the appropriate VFS format
  *
@@ -1091,9 +1094,10 @@ static int vfs_set_acl_idmapped_mnt(const struct mnt_idmap *idmap,
  *
  * Return: On success 0, on error negative errno.
  */
-int vfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 		const char *acl_name, struct posix_acl *kacl)
 {
+	struct dentry *dentry = path->dentry;
 	int acl_type;
 	int error;
 	struct inode *inode = d_inode(dentry);
@@ -1159,8 +1163,11 @@ EXPORT_SYMBOL_GPL(vfs_set_acl);
 
 /**
  * vfs_get_acl - get posix acls
- * @idmap: idmap of the mount
- * @dentry: the dentry based on which to retrieve the posix acls
+ * @idmap: idmap of the mount the posix acls are retrieved through; it is
+ *         not derived from @path->mnt, which for a stacking filesystem may
+ *         belong to a different mount than the operation was requested
+ *         through
+ * @path: the path the posix acls are retrieved from
  * @acl_name: the name of the posix acl
  *
  * This function retrieves @kacl from the filesystem. The caller must all
@@ -1169,8 +1176,10 @@ EXPORT_SYMBOL_GPL(vfs_set_acl);
  * Return: On success POSIX ACLs in VFS format, on error negative errno.
  */
 struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
-			      struct dentry *dentry, const char *acl_name)
+			      const struct path *path,
+			      const char *acl_name)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	struct posix_acl *acl;
 	int acl_type, error;
@@ -1204,17 +1213,21 @@ EXPORT_SYMBOL_GPL(vfs_get_acl);
 
 /**
  * vfs_remove_acl - remove posix acls
- * @idmap: idmap of the mount
- * @dentry: the dentry based on which to retrieve the posix acls
+ * @idmap: idmap of the mount the posix acls are removed through; it is
+ *         not derived from @path->mnt, which for a stacking filesystem may
+ *         belong to a different mount than the operation was requested
+ *         through
+ * @path: the path the posix acls are removed from
  * @acl_name: the name of the posix acl
  *
  * This function removes posix acls.
  *
  * Return: On success 0, on error negative errno.
  */
-int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
 		   const char *acl_name)
 {
+	struct dentry *dentry = path->dentry;
 	int acl_type;
 	int error;
 	struct inode *inode = d_inode(dentry);
@@ -1265,7 +1278,7 @@ int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 }
 EXPORT_SYMBOL_GPL(vfs_remove_acl);
 
-int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+int do_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 	       const char *acl_name, const void *kvalue, size_t size)
 {
 	int error;
@@ -1281,22 +1294,22 @@ int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 			return PTR_ERR(acl);
 	}
 
-	error = vfs_set_acl(idmap, dentry, acl_name, acl);
+	error = vfs_set_acl(idmap, path, acl_name, acl);
 	posix_acl_release(acl);
 	return error;
 }
 
-ssize_t do_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+ssize_t do_get_acl(const struct mnt_idmap *idmap, const struct path *path,
 		   const char *acl_name, void *kvalue, size_t size)
 {
 	ssize_t error;
 	struct posix_acl *acl;
 
-	acl = vfs_get_acl(idmap, dentry, acl_name);
+	acl = vfs_get_acl(idmap, path, acl_name);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 
-	error = vfs_posix_acl_to_xattr(idmap, d_inode(dentry),
+	error = vfs_posix_acl_to_xattr(idmap, d_inode(path->dentry),
 				       acl, kvalue, size);
 	posix_acl_release(acl);
 	return error;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 445fadd66f21..016510069b45 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1569,7 +1569,7 @@ int ksmbd_vfs_remove_acl_xattrs(const struct mnt_idmap *idmap,
 			     sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1) ||
 		    !strncmp(name, XATTR_NAME_POSIX_ACL_DEFAULT,
 			     sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1)) {
-			err = vfs_remove_acl(idmap, path->dentry, name);
+			err = vfs_remove_acl(idmap, path, name);
 			if (err)
 				ksmbd_debug(SMB,
 					    "remove acl xattr failed : %s\n", name);
diff --git a/fs/xattr.c b/fs/xattr.c
index 33bf97c3ac7f..f5b13a6402d3 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -661,8 +661,8 @@ static int do_setxattr(const struct mnt_idmap *idmap, const struct path *path,
 		       struct kernel_xattr_ctx *ctx)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
-		return do_set_acl(idmap, path->dentry,
-				  ctx->kname->name, ctx->kvalue, ctx->size);
+		return do_set_acl(idmap, path, ctx->kname->name,
+				  ctx->kvalue, ctx->size);
 
 	return vfs_setxattr(idmap, path, ctx->kname->name,
 			ctx->kvalue, ctx->size, ctx->flags);
@@ -808,8 +808,7 @@ do_getxattr(const struct mnt_idmap *idmap, const struct path *path,
 	}
 
 	if (is_posix_acl_xattr(kname))
-		error = do_get_acl(idmap, path->dentry,
-				   kname, kvalue, ctx->size);
+		error = do_get_acl(idmap, path, kname, kvalue, ctx->size);
 	else
 		error = vfs_getxattr(idmap, path, kname, kvalue, ctx->size);
 	if (error > 0) {
@@ -1039,7 +1038,7 @@ removexattr(const struct mnt_idmap *idmap, const struct path *path,
 	    const char *name)
 {
 	if (is_posix_acl_xattr(name))
-		return vfs_remove_acl(idmap, path->dentry, name);
+		return vfs_remove_acl(idmap, path, name);
 	return vfs_removexattr(idmap, path, name);
 }
 
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index caf500bed993..5a9c743dbab5 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -15,6 +15,7 @@
 #include <linux/refcount.h>
 #include <uapi/linux/posix_acl.h>
 
+struct path;
 struct user_namespace;
 
 struct posix_acl_entry {
@@ -105,11 +106,12 @@ static inline void cache_no_acl(struct inode *inode)
 	inode->i_default_acl = NULL;
 }
 
-int vfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+int vfs_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 		const char *acl_name, struct posix_acl *kacl);
 struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
-			      struct dentry *dentry, const char *acl_name);
-int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
+			      const struct path *path,
+			      const char *acl_name);
+int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
 		   const char *acl_name);
 int posix_acl_listxattr(struct inode *inode, char **buffer,
 			ssize_t *remaining_size);
@@ -142,21 +144,22 @@ static inline void forget_all_cached_acls(struct inode *inode)
 }
 
 static inline int vfs_set_acl(const struct mnt_idmap *idmap,
-			      struct dentry *dentry, const char *name,
+			      const struct path *path, const char *name,
 			      struct posix_acl *acl)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
-					    struct dentry *dentry,
+					    const struct path *path,
 					    const char *acl_name)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
 static inline int vfs_remove_acl(const struct mnt_idmap *idmap,
-				 struct dentry *dentry, const char *acl_name)
+				 const struct path *path,
+				 const char *acl_name)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.18.0.huawei.25

