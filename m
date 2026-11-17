Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926021;
	b=UVIFcXWOlprXyjJAtFWYeoTNy50ChAwR56QXzB+LZYYyU2sck1UD49JzyLJFTgym7qh2
	 OoMfgFwR1E/kR7Q7ykk+JTik0KXVwSDNpMdzwOgHTuZwhYMOCFHTvkaZ8bQG8KDw40iFE
	 MApWUoDGauauoK+jiyXnPpj1BK5+qx8NYrY/BjXRIgUXNet1iXLjual1HC3JZfbs4WmNJ
	 uPyQqks0N6o+K1BdqeG28iOyVqNCEYN1O00DnByB+gKoBlniaNTOZgNVw9Rrh0ZcQCsv9
	 rM2s4BHp1oDM8Kib2kGuDajY+6HGZS/Y6gZSR4fvUPLz2OzJ4nPqEfvP3CE2CiHouhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926021;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=7Iu36zyk0dhu5JdFz0ZSDVvyUyvAcGyZqh7eSJSsqAE=;
	b=r6hgt+vpFhcAE7fDjfz4LhEdMzQuKzK3XauR27A0ws7QzYwILmqAyS1jSepxNheD/7py
	 EnG7vk/Ym9fuziDHZvrDHRUe9RYllAyikwXMtrX0VQ2LXm+V4OdZ1shkcHCPw4om9Xyjk
	 BmuFJ/FqPkDoEo5mkcodHSNUedz/CTvnAQlljXb378RG5pBv1sa5DpgcffI5sTos5ljev
	 HtRvbuHEwtNxLgyxGptfbvL5c23Cvue8ppVABBNB8Nk65nEm/Mf3a4MVnfDAoZ71VDCXs
	 S3DMn1fa1fk9TRRMk1V4jN795LY/thp2qJcT2CBtGtPl//V+C8atYdY2QxnlrDzGErw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=CQKGUUAX;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87829606A333;
	Tue, 17 Nov 2026 14:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87829606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=CQKGUUAX
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7Iu36zyk0dhu5JdFz0ZSDVvyUyvAcGyZqh7eSJSsqAE=;
	b=CQKGUUAX+0iGYMOBYvA8rjfksQdGy38EAQYlpx3K2VktmL+leQT5/nqIlKibV0jZCTNiZABxw
	Fz6Zo8IcLu5Y0UgzoekQOTBNm7kUP4FrTEY/R+NLpQhTMOKOyQRdqwhADw0XLG+9frJM8gQoCZD
	QFm1PCvJ2+YSZSUWPm4WBNk=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jTRzV2xjRzmVXd;
	Tue, 17 Nov 2026 22:33:10 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 441EE40578;
	Tue, 17 Nov 2026 22:33:29 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:23 +0800
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
Subject: [PATCH -next -v4 01/17] fs: pass struct path to notify_change()
Date: Tue, 17 Nov 2026 23:05:26 +0800
Message-ID: <20261117150542.1169451-2-caixinchen1@huawei.com>
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

notify_change() and do_truncate() take a struct dentry even though their
callers either hold a struct path (or a struct file) or only need the
mount they already use to build one.  Pass a struct path instead; the
idmap stays a separate argument, as it must be taken from the mount when
the path is checked and passed down unchanged.

The NTFS named stream support forwards a change to the base inode.  Add a
notify_change_target() helper for it, and record the path the change was
requested through in the new iattr.ia_path field, which is only valid for
the duration of the notify_change() call and must not be stored.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/filesystems/porting.rst |  12 +++
 drivers/base/devtmpfs.c               |   6 +-
 fs/attr.c                             | 109 +++++++++++++++++++-------
 fs/coredump.c                         |   2 +-
 fs/ecryptfs/inode.c                   |  15 ++--
 fs/inode.c                            |   7 +-
 fs/namei.c                            |   5 +-
 fs/nfsd/nfs4state.c                   |  16 ++--
 fs/nfsd/nfs4xdr.c                     |   2 +-
 fs/nfsd/state.h                       |   2 +-
 fs/nfsd/vfs.c                         |  15 +++-
 fs/ntfs/named_stream.c                |  13 ++-
 fs/open.c                             |  17 ++--
 fs/overlayfs/overlayfs.h              |   7 +-
 fs/smb/server/smb2pdu.c               |   2 +-
 fs/smb/server/smbacl.c                |   2 +-
 fs/utimes.c                           |   2 +-
 include/linux/fs.h                    |  20 ++++-
 18 files changed, 177 insertions(+), 77 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 8623731e6b48..82be56207772 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1435,3 +1435,15 @@ directory has been created.  Filesystems that cannot do this, those
 that implement ->atomic_open() and those whose ->mkdir() drops the
 parent's i_rwsem, must set SB_I_NO_ATOMIC_MKDIR in sb->s_iflags, which
 makes that flag combination fail with -EOPNOTSUPP before any lookup.
+
+---
+
+**mandatory**
+
+notify_change() and do_truncate() now take a const struct path * instead
+of a struct dentry *.  They use path->dentry, so callers that only have a
+dentry must provide a struct path.  struct iattr has a new ia_path member,
+which notify_change() sets for the duration of the call; it must not be
+stored beyond that.  Filesystems that forward a change to another inode
+can use notify_change_target() to update the target dentry while keeping
+the caller-supplied path in ia_path.
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 11c70888f38b..410906a66ee9 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -284,13 +284,14 @@ static int handle_create(const char *nodename, umode_t mode, kuid_t uid,
 			dev->devt, NULL);
 	if (!err) {
 		struct iattr newattrs;
+		struct path attr_path = { .mnt = path.mnt, .dentry = dentry };
 
 		newattrs.ia_mode = mode;
 		newattrs.ia_uid = uid;
 		newattrs.ia_gid = gid;
 		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		inode_lock(d_inode(dentry));
-		notify_change(&nop_mnt_idmap, dentry, &newattrs, NULL);
+		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL);
 		inode_unlock(d_inode(dentry));
 
 		/* mark as kernel-created inode */
@@ -380,6 +381,7 @@ static int handle_remove(const char *nodename, struct device *dev)
 	inode = d_inode(dentry);
 	if (dev_mynode(dev, inode)) {
 		struct iattr newattrs;
+		struct path attr_path = { .mnt = parent.mnt, .dentry = dentry };
 		/*
 		 * before unlinking this node, reset permissions
 		 * of possible references like hardlinks
@@ -390,7 +392,7 @@ static int handle_remove(const char *nodename, struct device *dev)
 		newattrs.ia_valid =
 			ATTR_UID|ATTR_GID|ATTR_MODE;
 		inode_lock(d_inode(dentry));
-		notify_change(&nop_mnt_idmap, dentry, &newattrs, NULL);
+		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL);
 		inode_unlock(d_inode(dentry));
 		err = vfs_unlink(&nop_mnt_idmap, d_inode(parent.dentry),
 				 dentry, NULL);
diff --git a/fs/attr.c b/fs/attr.c
index 9706d370f34a..f8fd0f061612 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -397,35 +397,11 @@ int may_setattr(const struct mnt_idmap *idmap, struct inode *inode,
 }
 EXPORT_SYMBOL(may_setattr);
 
-/**
- * notify_change - modify attributes of a filesystem object
- * @idmap:	idmap of the mount the inode was found from
- * @dentry:	object affected
- * @attr:	new attributes
- * @delegated_inode: returns inode, if the inode is delegated
- *
- * The caller must hold the i_rwsem exclusively on the affected object.
- *
- * If notify_change discovers a delegation in need of breaking,
- * it will return -EWOULDBLOCK and return a reference to the inode in
- * delegated_inode.  The caller should then break the delegation and
- * retry.  Because breaking a delegation may take a long time, the
- * caller should drop the i_rwsem before doing so.
- *
- * Alternatively, a caller may pass NULL for delegated_inode.  This may
- * be appropriate for callers that expect the underlying filesystem not
- * to be NFS exported.  Also, passing NULL is fine for callers holding
- * the file open for write, as there can be no conflicting delegation in
- * that case.
- *
- * If the inode has been found through an idmapped mount the idmap of
- * the vfsmount must be passed through @idmap. This function will then
- * take care to map the inode according to @idmap before checking
- * permissions. On non-idmapped mounts or if permission checking is to be
- * performed on the raw inode simply pass @nop_mnt_idmap.
- */
-int notify_change(const struct mnt_idmap *idmap, struct dentry *dentry,
-		  struct iattr *attr, struct delegated_inode *delegated_inode)
+static int do_notify_change(const struct path *const path,
+			    const struct mnt_idmap *const idmap,
+			    struct dentry *const dentry,
+			    struct iattr *attr,
+			    struct delegated_inode *delegated_inode)
 {
 	struct inode *inode = dentry->d_inode;
 	umode_t mode = inode->i_mode;
@@ -552,11 +528,21 @@ int notify_change(const struct mnt_idmap *idmap, struct dentry *dentry,
 			return error;
 	}
 
+	/*
+	 * Filesystems that forward the change to another inode (e.g. NTFS
+	 * named streams) can pass @ia_path back to notify_change_target()
+	 * instead of losing the path the change was requested through.
+	 */
+	attr->ia_path = path;
+
 	if (inode->i_op->setattr)
 		error = inode->i_op->setattr(idmap, dentry, attr);
 	else
 		error = simple_setattr(idmap, dentry, attr);
 
+	/* @attr is caller-owned: do not leave a borrowed path behind. */
+	attr->ia_path = NULL;
+
 	if (!error) {
 		fsnotify_change(dentry, ia_valid);
 		security_inode_post_setattr(idmap, dentry, ia_valid);
@@ -564,4 +550,69 @@ int notify_change(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 	return error;
 }
+
+/**
+ * notify_change - modify attributes of a filesystem object
+ * @idmap:	idmap of the mount the inode was found from
+ * @path:	object affected
+ * @attr:	new attributes
+ * @delegated_inode: returns inode, if the inode is delegated
+ *
+ * The caller must hold the i_rwsem exclusively on the affected object.
+ *
+ * If notify_change discovers a delegation in need of breaking,
+ * it will return -EWOULDBLOCK and return a reference to the inode in
+ * delegated_inode.  The caller should then break the delegation and
+ * retry.  Because breaking a delegation may take a long time, the
+ * caller should drop the i_rwsem before doing so.
+ *
+ * Alternatively, a caller may pass NULL for delegated_inode.  This may
+ * be appropriate for callers that expect the underlying filesystem not
+ * to be NFS exported.  Also, passing NULL is fine for callers holding
+ * the file open for write, as there can be no conflicting delegation in
+ * that case.
+ *
+ * If the inode has been found through an idmapped mount the idmap of
+ * the vfsmount must be passed through @idmap. This function will then
+ * take care to map the inode according to @idmap before checking
+ * permissions. On non-idmapped mounts or if permission checking is to
+ * be performed on the raw inode simply pass @nop_mnt_idmap.
+ *
+ * Return: 0 on success, or a negative error on failure.
+ */
+int notify_change(const struct mnt_idmap *idmap, const struct path *path,
+		  struct iattr *attr, struct delegated_inode *delegated_inode)
+{
+	return do_notify_change(path, idmap, path->dentry, attr,
+				delegated_inode);
+}
 EXPORT_SYMBOL(notify_change);
+
+/**
+ * notify_change_target - change attributes of a target inode
+ * @idmap: idmap of the mount the inode was found from
+ * @path: path on which the change was requested
+ * @target: dentry of the inode whose attributes are changed
+ * @attr: attributes to change
+ * @delegated_inode: returns inode needing a delegation break
+ *
+ * This is for filesystems that apply a metadata change to an inode other
+ * than the one the caller named (e.g. NTFS named streams).  The path the
+ * change was requested through is recorded in @attr->ia_path so that the
+ * caller can pass it back when it forwards the change; @target supplies
+ * the inode to update.  @target must be the inode of the same file as
+ * @path, e.g. the base inode of a named stream.  The caller must hold the
+ * i_rwsem exclusively on @target.
+ *
+ * Return: 0 on success, or a negative error on failure.
+ */
+int notify_change_target(const struct mnt_idmap *idmap,
+			 const struct path *path, struct dentry *target,
+			 struct iattr *attr,
+			 struct delegated_inode *delegated_inode)
+{
+	if (WARN_ON_ONCE(!target))
+		return -EINVAL;
+	return do_notify_change(path, idmap, target, attr, delegated_inode);
+}
+EXPORT_SYMBOL_GPL(notify_change_target);
diff --git a/fs/coredump.c b/fs/coredump.c
index 82ef9d115999..3f6921e7fe60 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1060,7 +1060,7 @@ static bool coredump_file(struct core_name *cn, struct coredump_params *cprm,
 	}
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return false;
-	if (do_truncate(idmap, file->f_path.dentry, 0, 0, file))
+	if (do_truncate(idmap, &file->f_path, 0, 0, file))
 		return false;
 
 	cprm->file = no_free_ptr(file);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 48e520960d66..26967e4e4660 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -732,7 +732,8 @@ upper_size_to_lower_size(struct ecryptfs_crypt_stat *crypt_stat,
  */
 static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 {
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	struct path lower_path = ecryptfs_lower_path(dentry);
+	struct dentry *lower_dentry = lower_path.dentry;
 	struct inode *inode = d_inode(dentry);
 	struct ecryptfs_crypt_stat *crypt_stat;
 	loff_t i_size = i_size_read(inode);
@@ -821,7 +822,7 @@ static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 set_size:
 	lower_ia.ia_valid |= ATTR_SIZE;
 	inode_lock(d_inode(lower_dentry));
-	rc = notify_change(&nop_mnt_idmap, lower_dentry, &lower_ia, NULL);
+	rc = notify_change(&nop_mnt_idmap, &lower_path, &lower_ia, NULL);
 	inode_unlock(d_inode(lower_dentry));
 out:
 	ecryptfs_put_lower_file(inode);
@@ -873,7 +874,6 @@ static int ecryptfs_setattr(const struct mnt_idmap *idmap,
 			    struct dentry *dentry, struct iattr *ia)
 {
 	struct inode *inode = d_inode(dentry);
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct inode *lower_inode = ecryptfs_inode_to_lower(inode);
 	struct ecryptfs_crypt_stat *crypt_stat;
 	int rc;
@@ -925,14 +925,15 @@ static int ecryptfs_setattr(const struct mnt_idmap *idmap,
 	if (ia->ia_valid & ATTR_SIZE) {
 		rc = __ecryptfs_truncate(dentry, ia);
 	} else {
+		struct path lower_path = ecryptfs_lower_path(dentry);
 		struct iattr lower_ia;
 
 		ecryptfs_iattr_to_lower(&lower_ia, ia);
 
-		inode_lock(d_inode(lower_dentry));
-		rc = notify_change(&nop_mnt_idmap, lower_dentry, &lower_ia,
-				NULL);
-		inode_unlock(d_inode(lower_dentry));
+		inode_lock(d_inode(lower_path.dentry));
+		rc = notify_change(&nop_mnt_idmap, &lower_path, &lower_ia,
+				   NULL);
+		inode_unlock(d_inode(lower_path.dentry));
 	}
 out:
 	fsstack_copy_attr_all(inode, lower_inode);
diff --git a/fs/inode.c b/fs/inode.c
index f2003ae75374..e4af8a44932b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2379,7 +2379,7 @@ int dentry_needs_remove_privs(const struct mnt_idmap *idmap,
 }
 
 static int __remove_privs(const struct mnt_idmap *idmap,
-			  struct dentry *dentry, int kill)
+			  const struct path *path, int kill)
 {
 	struct iattr newattrs;
 
@@ -2388,7 +2388,7 @@ static int __remove_privs(const struct mnt_idmap *idmap,
 	 * Note we call this on write, so notify_change will not
 	 * encounter any conflicting delegations:
 	 */
-	return notify_change(idmap, dentry, &newattrs, NULL);
+	return notify_change(idmap, path, &newattrs, NULL);
 }
 
 static int file_remove_privs_flags(struct file *file, unsigned int flags)
@@ -2409,7 +2409,8 @@ static int file_remove_privs_flags(struct file *file, unsigned int flags)
 		if (flags & IOCB_NOWAIT)
 			return -EAGAIN;
 
-		error = __remove_privs(file_mnt_idmap(file), dentry, kill);
+		error = __remove_privs(file_mnt_idmap(file), &file->f_path,
+				       kill);
 	}
 
 	if (!error)
diff --git a/fs/namei.c b/fs/namei.c
index f573fd0aacaf..03d3d20b64e1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4391,9 +4391,8 @@ static int handle_truncate(const struct mnt_idmap *idmap, struct file *filp)
 
 	error = security_file_truncate(filp);
 	if (!error) {
-		error = do_truncate(idmap, path->dentry, 0,
-				    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
-				    filp);
+		error = do_truncate(idmap, path, 0,
+				    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN, filp);
 	}
 	put_write_access(inode);
 	return error;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 85da5776c0df..b89898fe6323 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -10517,8 +10517,10 @@ bool nfsd4_vet_deleg_time(struct timespec64 *req, const struct timespec64 *orig,
 	return true;
 }
 
-static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation *dp)
+static int cb_getattr_update_times(const struct path *path,
+				   struct nfs4_delegation *dp)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	struct nfs4_cb_fattr *ncf = &dp->dl_cb_fattr;
 	struct iattr attrs = { };
@@ -10548,7 +10550,7 @@ static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation
 
 	attrs.ia_valid |= ATTR_DELEG;
 	inode_lock(inode);
-	ret = notify_change(&nop_mnt_idmap, dentry, &attrs, NULL);
+	ret = notify_change(&nop_mnt_idmap, path, &attrs, NULL);
 	inode_unlock(inode);
 	return ret;
 }
@@ -10556,7 +10558,7 @@ static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation
 /**
  * nfsd4_deleg_getattr_conflict - Recall if GETATTR causes conflict
  * @rqstp: RPC transaction context
- * @dentry: dentry of inode to be checked for a conflict
+ * @path: path of inode to be checked for a conflict
  * @pdp: returned WRITE delegation, if one was found
  *
  * This function is called when there is a conflict between a write
@@ -10571,7 +10573,7 @@ static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation
  * caller must put the reference.
  */
 __be32
-nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
+nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, const struct path *path,
 			     struct nfs4_delegation **pdp)
 {
 	struct nfsd_thread_local_info *ntli = rqstp->rq_private;
@@ -10579,7 +10581,7 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 	struct nfs4_delegation *dp = NULL;
 	struct file_lease *fl;
 	struct nfs4_cb_fattr *ncf;
-	struct inode *inode = d_inode(dentry);
+	struct inode *inode = d_inode(path->dentry);
 	__be32 status;
 
 	ctx = locks_inode_context(inode);
@@ -10643,7 +10645,7 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 		 * not update the file's metadata with the client's
 		 * modified size
 		 */
-		err = cb_getattr_update_times(dentry, dp);
+		err = cb_getattr_update_times(path, dp);
 		if (err) {
 			status = nfserrno(err);
 			goto out_status;
@@ -10829,7 +10831,7 @@ void nfsd_update_cmtime_attr(struct file *f, unsigned int flags)
 	};
 
 	inode_lock(inode);
-	ret = notify_change(&nop_mnt_idmap, f->f_path.dentry, &attr, NULL);
+	ret = notify_change(&nop_mnt_idmap, &f->f_path, &attr, NULL);
 	inode_unlock(inode);
 	if (ret)
 		pr_notice_ratelimited("nfsd: Unable to update timestamps on "
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c4fd840da4d9..e32d69bd06d9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4083,7 +4083,7 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	    (attrmask[1] & (FATTR4_WORD1_TIME_ACCESS |
 			    FATTR4_WORD1_TIME_MODIFY |
 			    FATTR4_WORD1_TIME_METADATA))) {
-		status = nfsd4_deleg_getattr_conflict(rqstp, dentry, &dp);
+		status = nfsd4_deleg_getattr_conflict(rqstp, &path, &dp);
 		if (status)
 			goto out;
 	}
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 79dfa47b82db..a38943688ce2 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -1019,7 +1019,7 @@ static inline bool try_to_expire_client(struct nfs4_client *clp)
 }
 
 extern __be32 nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp,
-		struct dentry *dentry, struct nfs4_delegation **pdp);
+		const struct path *path, struct nfs4_delegation **pdp);
 
 struct nfsd4_get_dir_delegation;
 struct nfs4_delegation *nfsd_get_dir_deleg(struct nfsd4_compound_state *cstate,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index cf6c81d04df4..359277716fe8 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -455,7 +455,7 @@ nfsd_get_write_access(struct svc_fh *fhp)
 	return nfserrno(get_write_access(d_inode(fhp->fh_dentry)));
 }
 
-static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
+static int __nfsd_setattr(const struct path *path, struct iattr *iap)
 {
 	int host_err;
 
@@ -475,7 +475,8 @@ static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
 		if (iap->ia_size < 0)
 			return -EFBIG;
 
-		host_err = notify_change(&nop_mnt_idmap, dentry, &size_attr, NULL);
+		host_err = notify_change(&nop_mnt_idmap, path, &size_attr,
+					  NULL);
 		if (host_err)
 			return host_err;
 		iap->ia_valid &= ~ATTR_SIZE;
@@ -501,7 +502,7 @@ static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
 	if (!(iap->ia_valid & ATTR_DELEG))
 		iap->ia_valid |= ATTR_CTIME;
 
-	return notify_change(&nop_mnt_idmap, dentry, iap, NULL);
+	return notify_change(&nop_mnt_idmap, path, iap, NULL);
 }
 
 /**
@@ -522,6 +523,7 @@ __be32
 nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	     struct nfsd_attrs *attr, const struct timespec64 *guardtime)
 {
+	struct path	path;
 	struct dentry	*dentry;
 	struct inode	*inode;
 	struct iattr	*iap = attr->na_iattr;
@@ -569,6 +571,11 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	dentry = fhp->fh_dentry;
 	inode = d_inode(dentry);
 
+	path = (struct path){
+		.mnt	= fhp->fh_export->ex_path.mnt,
+		.dentry	= dentry,
+	};
+
 	nfsd_sanitize_attrs(inode, iap);
 
 	/*
@@ -612,7 +619,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		 * copy for every loop iteration.
 		 */
 		attrs = *iap;
-		host_err = __nfsd_setattr(dentry, &attrs);
+		host_err = __nfsd_setattr(&path, &attrs);
 		if (host_err != -EAGAIN || !retries--)
 			break;
 		if (!nfsd_wait_for_delegreturn(rqstp, inode))
diff --git a/fs/ntfs/named_stream.c b/fs/ntfs/named_stream.c
index 70c589207713..1c55588df5ba 100644
--- a/fs/ntfs/named_stream.c
+++ b/fs/ntfs/named_stream.c
@@ -896,11 +896,16 @@ static int ntfs_stream_setattr_common(const struct mnt_idmap *idmap,
 			inode_unlock(base_vi);
 			goto out;
 		}
-		if (base_attr.ia_valid)
-			err = notify_change(idmap, base_dentry, &base_attr,
-					NULL);
-		else
+		if (base_attr.ia_valid) {
+			if (WARN_ON_ONCE(!attr->ia_path)) {
+				err = -EINVAL;
+			} else {
+				err = notify_change_target(idmap, attr->ia_path,
+							   base_dentry, &base_attr, NULL);
+			}
+		} else {
 			err = 0;
+		}
 		if (!err)
 			ntfs_stream_inode_refresh(inode);
 		inode_unlock(base_vi);
diff --git a/fs/open.c b/fs/open.c
index 4dfbe87e7775..a96d490915f6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -36,10 +36,11 @@
 
 #include "internal.h"
 
-int do_truncate(const struct mnt_idmap *idmap, struct dentry *dentry,
+int do_truncate(const struct mnt_idmap *idmap, const struct path *path,
 		loff_t length, unsigned int time_attrs, struct file *filp)
 {
 	int ret;
+	struct dentry *dentry = path->dentry;
 	struct iattr newattrs;
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
@@ -65,7 +66,7 @@ int do_truncate(const struct mnt_idmap *idmap, struct dentry *dentry,
 		return ret;
 
 	/* Note any delegations or leases have already been broken: */
-	ret = notify_change(idmap, dentry, &newattrs, NULL);
+	ret = notify_change(idmap, path, &newattrs, NULL);
 	inode_unlock(dentry->d_inode);
 	return ret;
 }
@@ -115,7 +116,7 @@ int vfs_truncate(const struct path *path, loff_t length)
 
 	error = security_path_truncate(path);
 	if (!error)
-		error = do_truncate(idmap, path->dentry, length, 0, NULL);
+		error = do_truncate(idmap, path, length, 0, NULL);
 
 put_write_and_out:
 	put_write_access(inode);
@@ -191,8 +192,8 @@ int do_ftruncate(struct file *file, loff_t length, unsigned int flags)
 		return error;
 
 	scoped_guard(super_write, inode->i_sb)
-		return do_truncate(file_mnt_idmap(file), dentry, length,
-				   ATTR_MTIME | ATTR_CTIME, file);
+		return do_truncate(file_mnt_idmap(file), &file->f_path,
+				   length, ATTR_MTIME | ATTR_CTIME, file);
 }
 
 int ksys_ftruncate(unsigned int fd, loff_t length, unsigned int flags)
@@ -683,8 +684,8 @@ int chmod_common(const struct path *path, umode_t mode)
 		goto out_unlock;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	error = notify_change(mnt_idmap(path->mnt), path->dentry,
-			      &newattrs, &delegated_inode);
+	error = notify_change(mnt_idmap(path->mnt), path, &newattrs,
+			      &delegated_inode);
 out_unlock:
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
@@ -822,7 +823,7 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 		from_vfsuid(idmap, fs_userns, newattrs.ia_vfsuid),
 		from_vfsgid(idmap, fs_userns, newattrs.ia_vfsgid));
 	if (!error)
-		error = notify_change(idmap, path->dentry, &newattrs,
+		error = notify_change(idmap, path, &newattrs,
 				      &delegated_inode);
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 646f8ffc40ae..c6f67672460d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -214,7 +214,12 @@ static inline int ovl_do_notify_change(struct ovl_fs *ofs,
 				       struct dentry *upperdentry,
 				       struct iattr *attr)
 {
-	return notify_change(ovl_upper_mnt_idmap(ofs), upperdentry, attr, NULL);
+	struct path path = {
+		.mnt = ovl_upper_mnt(ofs),
+		.dentry = upperdentry,
+	};
+
+	return notify_change(ovl_upper_mnt_idmap(ofs), &path, attr, NULL);
 }
 
 static inline int ovl_do_rmdir(struct ovl_fs *ofs,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b74dafe6a307..4832decf6478 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9080,7 +9080,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		}
 
 		inode_lock(inode);
-		rc = notify_change(idmap, dentry, &attrs, NULL);
+		rc = notify_change(idmap, &filp->f_path, &attrs, NULL);
 		inode_unlock(inode);
 	}
 out:
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 9aac87ff3b4a..c2863b9f92ba 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1973,7 +1973,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	}
 
 	inode_lock(inode);
-	rc = notify_change(idmap, path->dentry, &newattrs, NULL);
+	rc = notify_change(idmap, path, &newattrs, NULL);
 	inode_unlock(inode);
 	if (get_write)
 		mnt_drop_write(path->mnt);
diff --git a/fs/utimes.c b/fs/utimes.c
index e22664e4115f..5193d504d289 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -64,7 +64,7 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 	}
 retry_deleg:
 	inode_lock(inode);
-	error = notify_change(mnt_idmap(path->mnt), path->dentry, &newattrs,
+	error = notify_change(mnt_idmap(path->mnt), path, &newattrs,
 			      &delegated_inode);
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 58d25fc23ec4..cd19aa264a98 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -289,6 +289,16 @@ struct iattr {
 	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
 	 */
 	struct file	*ia_file;
+
+	/*
+	 * Not an attribute, but the path on which the change was requested.
+	 * This is set by notify_change() so that filesystems which forward a
+	 * change to another inode (e.g. NTFS named streams) can pass the path
+	 * supplied by the caller back to notify_change_target().  The pointer
+	 * is valid only for the duration of the notify_change() call and must
+	 * not be stored.
+	 */
+	const struct path *ia_path;
 };
 
 /*
@@ -2495,8 +2505,8 @@ static inline bool is_idmapped_mnt(const struct vfsmount *mnt)
 }
 
 int vfs_truncate(const struct path *, loff_t);
-int do_truncate(const struct mnt_idmap *, struct dentry *, loff_t start,
-		unsigned int time_attrs, struct file *filp);
+int do_truncate(const struct mnt_idmap *idmap, const struct path *path,
+		loff_t length, unsigned int time_attrs, struct file *filp);
 extern int vfs_fallocate(struct file *file, int mode, loff_t offset,
 			loff_t len);
 int do_sys_open(int dfd, const char __user *filename, int flags,
@@ -2719,8 +2729,12 @@ static inline int bmap(struct inode *inode,  sector_t *block)
 }
 #endif
 
-int notify_change(const struct mnt_idmap *, struct dentry *,
+int notify_change(const struct mnt_idmap *, const struct path *,
 		  struct iattr *, struct delegated_inode *);
+int notify_change_target(const struct mnt_idmap *idmap,
+			 const struct path *path, struct dentry *target,
+			 struct iattr *attr,
+			 struct delegated_inode *delegated_inode);
 int inode_permission(const struct mnt_idmap *, struct inode *, int);
 int generic_permission(const struct mnt_idmap *, struct inode *, int);
 static inline int file_permission(struct file *file, int mask)
-- 
2.18.0.huawei.25

