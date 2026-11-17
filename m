Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926040;
	b=Wyfph6qRBjRzMjUfnmZf2j7SIyqwolyLEto5fyHopcZa7beL/eOhWgAraNjI0WvBrMnU
	 OYO/BuM0oQRJ39pGSzd8LLaMt2ia1KISG86uOk4lkfCvJvuTYe5SIYX2TaKBu2uR8XeTX
	 8Yy3PHDlGibFUOq1ipgtdukshmJwPTRCK5YGC0VAyPcRP0n9e76Rq4GXXrW7ykNlFjjGJ
	 MFurig/HRNP4NxWmvBZESwAesFTWAWRGRfMxLd7DO4LttyrGk/6AqyXBNndIoJGqo1C0e
	 Wl/nhZYyQgRod6NoIuBSXyKYI4AIRSgv3SKW/XILXMNTrnFwfv6dHSiesdP9qR+LdIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926040;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=SjN3A+AzGZP2XS88RUAAgqaq6jP5FTF9qM1D+CZmQfs=;
	b=WLpEItydOoh9VYXvhF4LpUdqS9MCsJLJguHNxPolMrjWNF4aLlfnKSn3ctQbXpenDaqy
	 IWt0oLS7aP9oNFJaY8e3Hooo9lLabIrpT56KrHrkIh2gHe/xaLrvdOg6qM+eWhoMopk6r
	 NwCwuyabjcrUssz9Lv16PpnH6HMkhVq9nDTIWa7SvxNKgDcV2yexjZwACP/n1tHhI6Pxz
	 E7brZHmKSHYmPxUHi3FlLtE7PGGnSNPXoQ8eYh0Y6Dlj0nWOfbQgff8fKPVrjPhWK2DlQ
	 H5IQlpfJub1FcENo3ZXZp7mNn4WI2r16J78a25dsr7ZUIQ5dyJGfjvKU1dgHnM1yGkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="a/rMiPge";
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF28B60A2619;
	Tue, 17 Nov 2026 14:33:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF28B60A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=a/rMiPge
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SjN3A+AzGZP2XS88RUAAgqaq6jP5FTF9qM1D+CZmQfs=;
	b=a/rMiPgew5aatKkfGvZjzMqMXkbJG/iVNd8JfIU34WI+CxgGUq3fTjA3n0v99y29lW4rFu0iC
	kZyWAzE/Vq7OrZ1ODxSWlnS6RjjqeSeiSCmPKbaqFqu2HGMilta9cCJ1KNYpf0aH4MiWC24wiwW
	0xxD1X5ZyOadlreLRk6EExA=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jTRzJ3GtMzcb3H;
	Tue, 17 Nov 2026 22:33:00 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E17240537;
	Tue, 17 Nov 2026 22:33:51 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:45 +0800
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
Subject: [PATCH -next -v4 05/17] LSM: pass struct path and struct file to the inode xattr hooks
Date: Tue, 17 Nov 2026 23:05:30 +0800
Message-ID: <20261117150542.1169451-6-caixinchen1@huawei.com>
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

Convert the inode_setxattr, inode_getxattr, inode_listxattr and
inode_removexattr hooks, along with their commoncap, SELinux, Smack, EVM
and IMA implementations, to take a const struct path instead of a dentry.
The idmap stays a separate argument for the two hooks that already take
one.

Also pass the struct file through which an xattr operation is requested,
when there is one, so that LSMs can later authorize file descriptor-based
operations with the rights available at open(2) time.  The file is
threaded through the xattr helpers and is NULL for path-based operations
and in-kernel users.

Add strong definitions of the four bpf_lsm_* stubs naming the file
argument file__nullable, and update the BPF selftests that attach to
these hooks.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/filesystems/porting.rst         | 13 ++++
 drivers/block/zloop.c                         |  5 +-
 fs/cachefiles/xattr.c                         | 14 ++--
 fs/ecryptfs/inode.c                           |  2 +-
 fs/nfsd/vfs.c                                 | 15 ++--
 fs/overlayfs/copy_up.c                        |  4 +-
 fs/overlayfs/overlayfs.h                      |  8 ++-
 fs/overlayfs/xattrs.c                         |  6 +-
 fs/smb/server/vfs.c                           | 12 ++--
 fs/xattr.c                                    | 70 +++++++++++--------
 include/linux/lsm_hook_defs.h                 | 12 ++--
 include/linux/security.h                      | 43 +++++++-----
 include/linux/xattr.h                         | 18 +++--
 kernel/bpf/bpf_lsm_proto.c                    | 33 +++++++++
 security/commoncap.c                          | 17 +++--
 security/integrity/evm/evm_main.c             | 20 ++++--
 security/integrity/ima/ima_appraise.c         | 16 +++--
 security/security.c                           | 55 ++++++++-------
 security/selinux/hooks.c                      | 23 +++---
 security/smack/smack_lsm.c                    | 25 ++++---
 .../selftests/bpf/progs/test_get_xattr.c      |  5 +-
 .../bpf/progs/test_set_remove_xattr.c         | 30 ++++----
 .../bpf/progs/verifier_lsm_init_xattr.c       |  6 +-
 23 files changed, 289 insertions(+), 163 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 034252f0da77..973f3650f8b5 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1452,6 +1452,19 @@ the caller-supplied path in ia_path.
 
 **mandatory**
 
+vfs_setxattr(), vfs_getxattr(), vfs_listxattr() and vfs_removexattr()
+along with their __vfs_setxattr_locked() and __vfs_removexattr_locked()
+counterparts now take a const struct path * instead of a struct dentry *.
+The ones that already had a mnt_idmap, i.e. all of them but
+vfs_listxattr(), keep it as a separate argument: like for the POSIX ACL
+helpers, the idmap is not derived from the path.  All six helpers also
+take a trailing struct file through which the operation is requested, or
+NULL for path-based callers.
+
+---
+
+**mandatory**
+
 vfs_set_acl(), vfs_get_acl() and vfs_remove_acl(), along with
 do_set_acl() and do_get_acl(), now take a const struct path * instead of a
 struct dentry *, keeping the mnt_idmap as a separate first argument.  The
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index cfde2e1f03cd..9d82850d3f44 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -719,7 +719,8 @@ static int zloop_record_safe_wps(struct zloop_device *zlo)
 		if (!zloop_zone_is_active(zone))
 			continue;
 		ret = vfs_setxattr(file_mnt_idmap(file), &file->f_path,
-				"user.zloop.wp", &zone->wp, sizeof(zone->wp), 0);
+				"user.zloop.wp", &zone->wp, sizeof(zone->wp),
+				0, NULL);
 		if (ret) {
 			pr_err("%pg: failed to record write pointer (%d)\n",
 				zlo->disk->part0, ret);
@@ -1420,7 +1421,7 @@ static void zloop_forget_cache(struct zloop_device *zlo)
 			continue;
 
 		ret = vfs_getxattr(file_mnt_idmap(file), &file->f_path,
-				"user.zloop.wp", &old_wp, sizeof(old_wp));
+				"user.zloop.wp", &old_wp, sizeof(old_wp), NULL);
 		if (ret == -ENODATA) {
 			old_wp = 0;
 		} else if (ret != sizeof(old_wp)) {
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index afdce5ce3b73..1e814183ade4 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -56,7 +56,8 @@ int cachefiles_preset_object_xattr(struct cachefiles_object *object, struct file
 		if (ret == 0) {
 			ret = vfs_setxattr(&nop_mnt_idmap, &file->f_path,
 					   cachefiles_xattr_cache, buf,
-					   sizeof(struct cachefiles_xattr) + len, 0);
+					   sizeof(struct cachefiles_xattr) + len,
+					   0, NULL);
 			mnt_drop_write_file(file);
 		}
 	}
@@ -120,7 +121,8 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 		if (ret == 0) {
 			ret = vfs_setxattr(&nop_mnt_idmap, &file->f_path,
 					   cachefiles_xattr_cache, buf,
-					   sizeof(struct cachefiles_xattr) + len, 0);
+					   sizeof(struct cachefiles_xattr) + len,
+					   0, NULL);
 			mnt_drop_write_file(file);
 		}
 	}
@@ -174,7 +176,7 @@ int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file
 	xlen = cachefiles_inject_read_error();
 	if (xlen == 0)
 		xlen = vfs_getxattr(&nop_mnt_idmap, &file->f_path,
-				    cachefiles_xattr_cache, buf, tlen);
+				    cachefiles_xattr_cache, buf, tlen, NULL);
 	if (xlen != tlen) {
 		if (xlen < 0) {
 			ret = xlen;
@@ -234,7 +236,7 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 		ret = mnt_want_write(cache->mnt);
 		if (ret == 0) {
 			ret = vfs_removexattr(&nop_mnt_idmap, &path,
-					      cachefiles_xattr_cache);
+					      cachefiles_xattr_cache, NULL);
 			mnt_drop_write(cache->mnt);
 		}
 	}
@@ -299,7 +301,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 		if (ret == 0) {
 			ret = vfs_setxattr(&nop_mnt_idmap, &path,
 					   cachefiles_xattr_cache,
-					   buf, len, 0);
+					   buf, len, 0, NULL);
 			mnt_drop_write(volume->cache->mnt);
 		}
 	}
@@ -345,7 +347,7 @@ int cachefiles_check_volume_xattr(struct cachefiles_volume *volume)
 	xlen = cachefiles_inject_read_error();
 	if (xlen == 0)
 		xlen = vfs_getxattr(&nop_mnt_idmap, &path,
-				    cachefiles_xattr_cache, buf, len);
+				    cachefiles_xattr_cache, buf, len, NULL);
 	if (xlen != len) {
 		if (xlen < 0) {
 			ret = xlen;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 7db6fa6e5274..76abf142ab59 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1003,7 +1003,7 @@ ecryptfs_setxattr(struct dentry *dentry, struct inode *inode,
 	}
 	inode_lock(lower_inode);
 	rc = __vfs_setxattr_locked(&nop_mnt_idmap, &lower_path, name, value,
-				   size, flags, NULL);
+				   size, flags, NULL, NULL);
 	inode_unlock(lower_inode);
 	if (!rc && inode)
 		fsstack_copy_attr_all(inode, lower_inode);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index aef4097e9ef3..382bb24ddc9e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -703,7 +703,7 @@ int nfsd4_is_junction(const struct path *path)
 	if (!(inode->i_mode & S_ISVTX))
 		return 0;
 	if (vfs_getxattr(&nop_mnt_idmap, path, NFSD_JUNCTION_XATTR_NAME,
-			 NULL, 0) <= 0)
+			 NULL, 0, NULL) <= 0)
 		return 0;
 	return 1;
 }
@@ -2695,7 +2695,7 @@ nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 
 	inode_lock_shared(inode);
 
-	len = vfs_getxattr(&nop_mnt_idmap, &path, name, NULL, 0);
+	len = vfs_getxattr(&nop_mnt_idmap, &path, name, NULL, 0, NULL);
 
 	/*
 	 * Zero-length attribute, just return.
@@ -2722,7 +2722,7 @@ nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 		goto out;
 	}
 
-	len = vfs_getxattr(&nop_mnt_idmap, &path, name, buf, len);
+	len = vfs_getxattr(&nop_mnt_idmap, &path, name, buf, len, NULL);
 	if (len <= 0) {
 		kvfree(buf);
 		buf = NULL;
@@ -2769,7 +2769,7 @@ nfsd_listxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char **bufp,
 
 	inode_lock_shared(inode);
 
-	len = vfs_listxattr(&path, NULL, 0);
+	len = vfs_listxattr(&path, NULL, 0, NULL);
 	if (len <= 0) {
 		err = nfsd_xattr_errno(len);
 		goto out;
@@ -2786,7 +2786,7 @@ nfsd_listxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char **bufp,
 		goto out;
 	}
 
-	len = vfs_listxattr(&path, buf, len);
+	len = vfs_listxattr(&path, buf, len, NULL);
 	if (len <= 0) {
 		kvfree(buf);
 		err = nfsd_xattr_errno(len);
@@ -2835,7 +2835,8 @@ nfsd_removexattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name)
 	err = fh_fill_pre_attrs(fhp);
 	if (err != nfs_ok)
 		goto out_unlock;
-	ret = __vfs_removexattr_locked(&nop_mnt_idmap, &path, name, NULL);
+	ret = __vfs_removexattr_locked(&nop_mnt_idmap, &path, name,
+				       NULL, NULL);
 	err = nfsd_xattr_errno(ret);
 	fh_fill_post_attrs(fhp);
 out_unlock:
@@ -2867,7 +2868,7 @@ nfsd_setxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 	if (err != nfs_ok)
 		goto out_unlock;
 	ret = __vfs_setxattr_locked(&nop_mnt_idmap, &path, name, buf, len,
-				    flags, NULL);
+				    flags, NULL, NULL);
 	fh_fill_post_attrs(fhp);
 	err = nfsd_xattr_errno(ret);
 out_unlock:
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ac7718aa1388..dc87657733bf 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -95,7 +95,7 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct de
 	if (!old->d_inode->i_op->listxattr || !new->d_inode->i_op->listxattr)
 		return 0;
 
-	list_size = vfs_listxattr(oldpath, NULL, 0);
+	list_size = vfs_listxattr(oldpath, NULL, 0, NULL);
 	if (list_size <= 0) {
 		if (list_size == -EOPNOTSUPP)
 			return 0;
@@ -106,7 +106,7 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct de
 	if (!buf)
 		return -ENOMEM;
 
-	list_size = vfs_listxattr(oldpath, buf, list_size);
+	list_size = vfs_listxattr(oldpath, buf, list_size, NULL);
 	if (list_size <= 0) {
 		error = list_size;
 		goto out;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 413f1214b1bb..fb603044b59f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -301,7 +301,8 @@ static inline ssize_t ovl_do_getxattr(const struct path *path, const char *name,
 
 	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 
-	err = vfs_getxattr(mnt_idmap(path->mnt), path, name, value, size);
+	err = vfs_getxattr(mnt_idmap(path->mnt), path, name, value, size,
+			   NULL);
 	len = (value && err > 0) ? err : 0;
 
 	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
@@ -341,7 +342,7 @@ static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 
 	/* Use vfs_setxattr(), not __vfs_setxattr(): it idmaps the security.capability rootid. */
 	int err = vfs_setxattr(ovl_upper_mnt_idmap(ofs), &path, name,
-			       value, size, flags);
+			       value, size, flags, NULL);
 
 	pr_debug("setxattr(%pd2, \"%s\", \"%*pE\", %zu, %d) = %i\n",
 		 dentry, name, min((int)size, 48), value, size, flags, err);
@@ -363,7 +364,8 @@ static inline int ovl_do_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 		.dentry = dentry,
 	};
 
-	int err = vfs_removexattr(ovl_upper_mnt_idmap(ofs), &path, name);
+	int err = vfs_removexattr(ovl_upper_mnt_idmap(ofs), &path, name,
+				  NULL);
 	pr_debug("removexattr(%pd2, \"%s\") = %i\n", dentry, name, err);
 	return err;
 }
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index 2a97a9ec642a..7bd12daba28a 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -46,7 +46,7 @@ static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char
 		ovl_path_lower(dentry, &realpath);
 		with_ovl_creds(dentry->d_sb)
 			err = vfs_getxattr(mnt_idmap(realpath.mnt), &realpath,
-					   name, NULL, 0);
+					   name, NULL, 0, NULL);
 		if (err < 0)
 			goto out;
 	}
@@ -88,7 +88,7 @@ static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char
 	/* Use vfs_getxattr(), not __vfs_getxattr(): it idmaps the security.capability rootid. */
 	with_ovl_creds(dentry->d_sb)
 		return vfs_getxattr(mnt_idmap(realpath.mnt), &realpath,
-				    name, value, size);
+				    name, value, size, NULL);
 }
 
 static bool ovl_can_list(struct super_block *sb, const char *s)
@@ -117,7 +117,7 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	ovl_path_real(dentry, &realpath);
 
 	with_ovl_creds(dentry->d_sb)
-		res = vfs_listxattr(&realpath, list, size);
+		res = vfs_listxattr(&realpath, list, size, NULL);
 	if (res <= 0 || size == 0)
 		return res;
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 016510069b45..af7aef0c89fc 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -885,7 +885,7 @@ ssize_t ksmbd_vfs_listxattr(const struct path *path, char **list)
 	ssize_t size;
 	char *vlist = NULL;
 
-	size = vfs_listxattr(path, NULL, 0);
+	size = vfs_listxattr(path, NULL, 0, NULL);
 	if (size <= 0)
 		return size;
 
@@ -894,7 +894,7 @@ ssize_t ksmbd_vfs_listxattr(const struct path *path, char **list)
 		return -ENOMEM;
 
 	*list = vlist;
-	size = vfs_listxattr(path, vlist, size);
+	size = vfs_listxattr(path, vlist, size, NULL);
 	if (size < 0) {
 		ksmbd_debug(VFS, "listxattr failed\n");
 		kvfree(vlist);
@@ -907,7 +907,7 @@ ssize_t ksmbd_vfs_listxattr(const struct path *path, char **list)
 ssize_t ksmbd_vfs_xattr_len(const struct mnt_idmap *idmap,
 			    const struct path *path, char *xattr_name)
 {
-	return vfs_getxattr(idmap, path, xattr_name, NULL, 0);
+	return vfs_getxattr(idmap, path, xattr_name, NULL, 0, NULL);
 }
 
 /**
@@ -936,7 +936,7 @@ ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
 		return -ENOMEM;
 
 	xattr_len = vfs_getxattr(idmap, path, xattr_name,
-				 (void *)buf, xattr_len);
+				 (void *)buf, xattr_len, NULL);
 	if (xattr_len > 0)
 		*xattr_buf = buf;
 	else
@@ -973,7 +973,7 @@ int ksmbd_vfs_setxattr(const struct mnt_idmap *idmap,
 			   attr_name,
 			   attr_value,
 			   attr_size,
-			   flags);
+			   flags, NULL);
 	if (err)
 		ksmbd_debug(VFS, "setxattr failed, err %d\n", err);
 	if (get_write == true)
@@ -1260,7 +1260,7 @@ int ksmbd_vfs_remove_xattr(const struct mnt_idmap *idmap,
 			return err;
 	}
 
-	err = vfs_removexattr(idmap, path, attr_name);
+	err = vfs_removexattr(idmap, path, attr_name, NULL);
 
 	if (get_write == true)
 		mnt_drop_write(path->mnt);
diff --git a/fs/xattr.c b/fs/xattr.c
index f5b13a6402d3..5256372e0fe9 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -293,11 +293,13 @@ int __vfs_setxattr_noperm(const struct mnt_idmap *idmap,
  *  @flags: flags to pass into filesystem operations
  *  @delegated_inode: on return, will contain an inode pointer that
  *  a delegation was broken on, NULL if none.
+ *  @file: file to perform setxattr on, or NULL
  */
 int
 __vfs_setxattr_locked(const struct mnt_idmap *idmap, const struct path *path,
 		      const char *name, const void *value, size_t size,
-		      int flags, struct delegated_inode *delegated_inode)
+		      int flags, struct delegated_inode *delegated_inode,
+		      struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -307,8 +309,8 @@ __vfs_setxattr_locked(const struct mnt_idmap *idmap, const struct path *path,
 	if (error)
 		return error;
 
-	error = security_inode_setxattr(idmap, dentry, name, value, size,
-					flags);
+	error = security_inode_setxattr(idmap, path, name, value, size,
+					flags, file);
 	if (error)
 		goto out;
 
@@ -326,7 +328,8 @@ EXPORT_SYMBOL_GPL(__vfs_setxattr_locked);
 
 int
 vfs_setxattr(const struct mnt_idmap *idmap, const struct path *path,
-	     const char *name, const void *value, size_t size, int flags)
+	     const char *name, const void *value, size_t size, int flags,
+	     struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -344,7 +347,7 @@ vfs_setxattr(const struct mnt_idmap *idmap, const struct path *path,
 retry_deleg:
 	inode_lock(inode);
 	error = __vfs_setxattr_locked(idmap, path, name, value, size,
-				      flags, &delegated_inode);
+				      flags, &delegated_inode, file);
 	inode_unlock(inode);
 
 	if (is_delegated(&delegated_inode)) {
@@ -451,7 +454,7 @@ EXPORT_SYMBOL(__vfs_getxattr);
 
 ssize_t
 vfs_getxattr(const struct mnt_idmap *idmap, const struct path *path,
-	     const char *name, void *value, size_t size)
+	     const char *name, void *value, size_t size, struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -461,7 +464,7 @@ vfs_getxattr(const struct mnt_idmap *idmap, const struct path *path,
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, name);
+	error = security_inode_getxattr(path, name, file);
 	if (error)
 		return error;
 
@@ -488,6 +491,7 @@ EXPORT_SYMBOL_GPL(vfs_getxattr);
  * @path: the path from whose inode the xattr names are retrieved
  * @list: buffer to store xattr names into
  * @size: size of the buffer
+ * @file: file through which the xattr names are retrieved, if any
  *
  * This function returns the names of all xattrs associated with the
  * inode of @path->dentry.
@@ -506,13 +510,14 @@ EXPORT_SYMBOL_GPL(vfs_getxattr);
  *         negative error code.
  */
 ssize_t
-vfs_listxattr(const struct path *path, char *list, size_t size)
+vfs_listxattr(const struct path *path, char *list, size_t size,
+	      struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	ssize_t error;
 
-	error = security_inode_listxattr(dentry);
+	error = security_inode_listxattr(path, file);
 	if (error)
 		return error;
 
@@ -559,11 +564,13 @@ EXPORT_SYMBOL(__vfs_removexattr);
  *  @name: name of xattr to remove
  *  @delegated_inode: on return, will contain an inode pointer that
  *  a delegation was broken on, NULL if none.
+ *  @file: file to perform removexattr on, or NULL
  */
 int
 __vfs_removexattr_locked(const struct mnt_idmap *idmap,
 			 const struct path *path, const char *name,
-			 struct delegated_inode *delegated_inode)
+			 struct delegated_inode *delegated_inode,
+			 struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -573,7 +580,7 @@ __vfs_removexattr_locked(const struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
-	error = security_inode_removexattr(idmap, dentry, name);
+	error = security_inode_removexattr(idmap, path, name, file);
 	if (error)
 		goto out;
 
@@ -595,7 +602,7 @@ EXPORT_SYMBOL_GPL(__vfs_removexattr_locked);
 
 int
 vfs_removexattr(const struct mnt_idmap *idmap, const struct path *path,
-		const char *name)
+		const char *name, struct file *file)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -604,7 +611,8 @@ vfs_removexattr(const struct mnt_idmap *idmap, const struct path *path,
 
 retry_deleg:
 	inode_lock(inode);
-	error = __vfs_removexattr_locked(idmap, path, name, &delegated_inode);
+	error = __vfs_removexattr_locked(idmap, path, name, &delegated_inode,
+					  file);
 	inode_unlock(inode);
 
 	if (is_delegated(&delegated_inode)) {
@@ -658,14 +666,14 @@ int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
 }
 
 static int do_setxattr(const struct mnt_idmap *idmap, const struct path *path,
-		       struct kernel_xattr_ctx *ctx)
+		       struct kernel_xattr_ctx *ctx, struct file *file)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
 		return do_set_acl(idmap, path, ctx->kname->name,
 				  ctx->kvalue, ctx->size);
 
 	return vfs_setxattr(idmap, path, ctx->kname->name,
-			ctx->kvalue, ctx->size, ctx->flags);
+			ctx->kvalue, ctx->size, ctx->flags, file);
 }
 
 int file_setxattr(struct file *f, struct kernel_xattr_ctx *ctx)
@@ -674,7 +682,7 @@ int file_setxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 
 	if (!error) {
 		audit_file(f);
-		error = do_setxattr(file_mnt_idmap(f), &f->f_path, ctx);
+		error = do_setxattr(file_mnt_idmap(f), &f->f_path, ctx, f);
 		mnt_drop_write_file(f);
 	}
 	return error;
@@ -692,7 +700,7 @@ int filename_setxattr(int dfd, struct filename *filename,
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = do_setxattr(mnt_idmap(path.mnt), &path, ctx);
+		error = do_setxattr(mnt_idmap(path.mnt), &path, ctx, NULL);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -793,7 +801,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
  */
 static ssize_t
 do_getxattr(const struct mnt_idmap *idmap, const struct path *path,
-	    struct kernel_xattr_ctx *ctx)
+	    struct kernel_xattr_ctx *ctx, struct file *file)
 {
 	ssize_t error;
 	char *kname = ctx->kname->name;
@@ -810,7 +818,8 @@ do_getxattr(const struct mnt_idmap *idmap, const struct path *path,
 	if (is_posix_acl_xattr(kname))
 		error = do_get_acl(idmap, path, kname, kvalue, ctx->size);
 	else
-		error = vfs_getxattr(idmap, path, kname, kvalue, ctx->size);
+		error = vfs_getxattr(idmap, path, kname, kvalue,
+				     ctx->size, file);
 	if (error > 0) {
 		if (ctx->size && copy_to_user(ctx->value, kvalue, error))
 			error = -EFAULT;
@@ -827,7 +836,7 @@ do_getxattr(const struct mnt_idmap *idmap, const struct path *path,
 ssize_t file_getxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 {
 	audit_file(f);
-	return do_getxattr(file_mnt_idmap(f), &f->f_path, ctx);
+	return do_getxattr(file_mnt_idmap(f), &f->f_path, ctx, f);
 }
 
 ssize_t filename_getxattr(int dfd, struct filename *filename,
@@ -839,7 +848,7 @@ ssize_t filename_getxattr(int dfd, struct filename *filename,
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = do_getxattr(mnt_idmap(path.mnt), &path, ctx);
+	error = do_getxattr(mnt_idmap(path.mnt), &path, ctx, NULL);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -930,7 +939,8 @@ SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
  * Extended attribute LIST operations
  */
 static ssize_t
-listxattr(const struct path *path, char __user *list, size_t size)
+listxattr(const struct path *path, char __user *list, size_t size,
+	   struct file *file)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -943,7 +953,7 @@ listxattr(const struct path *path, char __user *list, size_t size)
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(path, klist, size);
+	error = vfs_listxattr(path, klist, size, file);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -962,7 +972,7 @@ static
 ssize_t file_listxattr(struct file *f, char __user *list, size_t size)
 {
 	audit_file(f);
-	return listxattr(&f->f_path, list, size);
+	return listxattr(&f->f_path, list, size, f);
 }
 
 static
@@ -976,7 +986,7 @@ ssize_t filename_listxattr(int dfd, struct filename *filename,
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = listxattr(&path, list, size);
+	error = listxattr(&path, list, size, NULL);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -1035,11 +1045,11 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
  */
 static long
 removexattr(const struct mnt_idmap *idmap, const struct path *path,
-	    const char *name)
+	    const char *name, struct file *file)
 {
 	if (is_posix_acl_xattr(name))
 		return vfs_remove_acl(idmap, path, name);
-	return vfs_removexattr(idmap, path, name);
+	return vfs_removexattr(idmap, path, name, file);
 }
 
 static int file_removexattr(struct file *f, struct xattr_name *kname)
@@ -1048,7 +1058,8 @@ static int file_removexattr(struct file *f, struct xattr_name *kname)
 
 	if (!error) {
 		audit_file(f);
-		error = removexattr(file_mnt_idmap(f), &f->f_path, kname->name);
+		error = removexattr(file_mnt_idmap(f), &f->f_path,
+				    kname->name, f);
 		mnt_drop_write_file(f);
 	}
 	return error;
@@ -1066,7 +1077,8 @@ static int filename_removexattr(int dfd, struct filename *filename,
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = removexattr(mnt_idmap(path.mnt), &path, kname->name);
+		error = removexattr(mnt_idmap(path.mnt), &path,
+				    kname->name, NULL);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 7d3cd5395365..b1fffff5b3e0 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -154,14 +154,16 @@ LSM_HOOK(void, LSM_RET_VOID, inode_post_setattr, const struct mnt_idmap *idmap,
 LSM_HOOK(int, 0, inode_getattr, const struct path *path)
 LSM_HOOK(int, 0, inode_xattr_skipcap, const char *name)
 LSM_HOOK(int, 0, inode_setxattr, const struct mnt_idmap *idmap,
-	 struct dentry *dentry, const char *name, const void *value,
-	 size_t size, int flags)
+	 const struct path *path, const char *name, const void *value,
+	 size_t size, int flags, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_setxattr, struct dentry *dentry,
 	 const char *name, const void *value, size_t size, int flags)
-LSM_HOOK(int, 0, inode_getxattr, struct dentry *dentry, const char *name)
-LSM_HOOK(int, 0, inode_listxattr, struct dentry *dentry)
+LSM_HOOK(int, 0, inode_getxattr, const struct path *path, const char *name,
+	 struct file *file)
+LSM_HOOK(int, 0, inode_listxattr, const struct path *path,
+	 struct file *file)
 LSM_HOOK(int, 0, inode_removexattr, const struct mnt_idmap *idmap,
-	 struct dentry *dentry, const char *name)
+	 const struct path *path, const char *name, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
 	 const char *name)
 LSM_HOOK(int, 0, inode_file_setattr, struct dentry *dentry, struct file_kattr *fa)
diff --git a/include/linux/security.h b/include/linux/security.h
index b9cae538b6fc..d93492054c8d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -185,10 +185,12 @@ extern int cap_capset(struct cred *new, const struct cred *old,
 		      const kernel_cap_t *inheritable,
 		      const kernel_cap_t *permitted);
 extern int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file);
-int cap_inode_setxattr(struct dentry *dentry, const char *name,
-		       const void *value, size_t size, int flags);
+int cap_inode_setxattr(const struct path *path, const char *name,
+		       const void *value, size_t size, int flags,
+		       struct file *file);
 int cap_inode_removexattr(const struct mnt_idmap *idmap,
-			  struct dentry *dentry, const char *name);
+			  const struct path *path, const char *name,
+			  struct file *file);
 int cap_inode_need_killpriv(struct dentry *dentry);
 int cap_inode_killpriv(const struct mnt_idmap *idmap, struct dentry *dentry);
 int cap_inode_getsecurity(const struct mnt_idmap *idmap,
@@ -434,8 +436,9 @@ void security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *d
 				 int ia_valid);
 int security_inode_getattr(const struct path *path);
 int security_inode_setxattr(const struct mnt_idmap *idmap,
-			    struct dentry *dentry, const char *name,
-			    const void *value, size_t size, int flags);
+			    const struct path *path, const char *name,
+			    const void *value, size_t size, int flags,
+			    struct file *file);
 int security_inode_set_acl(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, const char *acl_name,
 			   struct posix_acl *kacl);
@@ -450,10 +453,13 @@ void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
 				    const char *acl_name);
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags);
-int security_inode_getxattr(struct dentry *dentry, const char *name);
-int security_inode_listxattr(struct dentry *dentry);
+int security_inode_getxattr(const struct path *path,
+			    const char *name, struct file *file);
+int security_inode_listxattr(const struct path *path,
+			      struct file *file);
 int security_inode_removexattr(const struct mnt_idmap *idmap,
-			       struct dentry *dentry, const char *name);
+			       const struct path *path, const char *name,
+			       struct file *file);
 void security_inode_post_removexattr(struct dentry *dentry, const char *name);
 int security_inode_file_setattr(struct dentry *dentry,
 			      struct file_kattr *fa);
@@ -1012,10 +1018,11 @@ static inline int security_inode_getattr(const struct path *path)
 }
 
 static inline int security_inode_setxattr(const struct mnt_idmap *idmap,
-		struct dentry *dentry, const char *name, const void *value,
-		size_t size, int flags)
+		const struct path *path, const char *name,
+		const void *value, size_t size, int flags,
+		struct file *file)
 {
-	return cap_inode_setxattr(dentry, name, value, size, flags);
+	return cap_inode_setxattr(path, name, value, size, flags, file);
 }
 
 static inline int security_inode_set_acl(const struct mnt_idmap *idmap,
@@ -1054,22 +1061,24 @@ static inline void security_inode_post_setxattr(struct dentry *dentry,
 		const char *name, const void *value, size_t size, int flags)
 { }
 
-static inline int security_inode_getxattr(struct dentry *dentry,
-			const char *name)
+static inline int security_inode_getxattr(const struct path *path,
+			const char *name, struct file *file)
 {
 	return 0;
 }
 
-static inline int security_inode_listxattr(struct dentry *dentry)
+static inline int security_inode_listxattr(const struct path *path,
+					   struct file *file)
 {
 	return 0;
 }
 
 static inline int security_inode_removexattr(const struct mnt_idmap *idmap,
-					     struct dentry *dentry,
-					     const char *name)
+					     const struct path *path,
+					     const char *name,
+					     struct file *file)
 {
-	return cap_inode_removexattr(idmap, dentry, name);
+	return cap_inode_removexattr(idmap, path, name, file);
 }
 
 static inline void security_inode_post_removexattr(struct dentry *dentry,
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index c39f6495fb78..c82c40cd1494 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -26,6 +26,7 @@
 
 struct inode;
 struct dentry;
+struct file;
 struct path;
 
 static inline bool is_posix_acl_xattr(const char *name)
@@ -79,8 +80,10 @@ struct xattr {
 
 ssize_t __vfs_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(const struct mnt_idmap *idmap, const struct path *path,
-		     const char *name, void *value, size_t size);
-ssize_t vfs_listxattr(const struct path *path, char *list, size_t size);
+		     const char *name, void *value, size_t size,
+		     struct file *file);
+ssize_t vfs_listxattr(const struct path *path, char *list, size_t size,
+		      struct file *file);
 int __vfs_setxattr(const struct mnt_idmap *, struct dentry *, struct inode *,
 		   const char *, const void *, size_t, int);
 int __vfs_setxattr_noperm(const struct mnt_idmap *, struct dentry *,
@@ -88,15 +91,18 @@ int __vfs_setxattr_noperm(const struct mnt_idmap *, struct dentry *,
 int __vfs_setxattr_locked(const struct mnt_idmap *idmap,
 			  const struct path *path, const char *name,
 			  const void *value, size_t size, int flags,
-			  struct delegated_inode *delegated_inode);
+			  struct delegated_inode *delegated_inode,
+			  struct file *file);
 int vfs_setxattr(const struct mnt_idmap *idmap, const struct path *path,
-		 const char *name, const void *value, size_t size, int flags);
+		 const char *name, const void *value, size_t size, int flags,
+		 struct file *file);
 int __vfs_removexattr(const struct mnt_idmap *, struct dentry *, const char *);
 int __vfs_removexattr_locked(const struct mnt_idmap *idmap,
 			     const struct path *path, const char *name,
-			     struct delegated_inode *delegated_inode);
+			     struct delegated_inode *delegated_inode,
+			     struct file *file);
 int vfs_removexattr(const struct mnt_idmap *idmap, const struct path *path,
-		    const char *name);
+		    const char *name, struct file *file);
 
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
 int vfs_getxattr_alloc(const struct mnt_idmap *idmap,
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index b81179ae2e08..921910e2a1c5 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -32,3 +32,36 @@ noinline int bpf_lsm_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	return -EOPNOTSUPP;
 }
+
+/*
+ * Strong definitions of the inode xattr BPF LSM hooks.  The file argument is
+ * only set for file descriptor-based operations and is NULL for path-based
+ * and in-kernel callers, so mark it as PTR_MAYBE_NULL.
+ */
+noinline int bpf_lsm_inode_setxattr(const struct mnt_idmap *idmap,
+				    const struct path *path, const char *name,
+				    const void *value, size_t size, int flags,
+				    struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_inode_getxattr(const struct path *path, const char *name,
+				    struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_inode_listxattr(const struct path *path,
+				     struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_inode_removexattr(const struct mnt_idmap *idmap,
+				       const struct path *path,
+				       const char *name,
+				       struct file *file__nullable)
+{
+	return 0;
+}
diff --git a/security/commoncap.c b/security/commoncap.c
index d0ba7049f579..1bf535a9ddd9 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -14,6 +14,7 @@
 #include <linux/netlink.h>
 #include <linux/ptrace.h>
 #include <linux/xattr.h>
+#include <linux/path.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/prctl.h>
@@ -1007,11 +1008,12 @@ int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file)
 
 /**
  * cap_inode_setxattr - Determine whether an xattr may be altered
- * @dentry: The inode/dentry being altered
+ * @path: The inode/path being altered
  * @name: The name of the xattr to be changed
  * @value: The value that the xattr will be changed to
  * @size: The size of value
  * @flags: The replacement flag
+ * @file: the file through which the xattr change is requested, if any
  *
  * Determine whether an xattr may be altered or set on an inode, returning 0 if
  * permission is granted, -ve if denied.
@@ -1019,9 +1021,11 @@ int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file)
  * This is used to make sure security xattrs don't get updated or set by those
  * who aren't privileged to do so.
  */
-int cap_inode_setxattr(struct dentry *dentry, const char *name,
-		       const void *value, size_t size, int flags)
+int cap_inode_setxattr(const struct path *path, const char *name,
+		       const void *value, size_t size, int flags,
+		       struct file *file)
 {
+	struct dentry *dentry = path->dentry;
 	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
 
 	/* Ignore non-security xattrs */
@@ -1045,8 +1049,9 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  * cap_inode_removexattr - Determine whether an xattr may be removed
  *
  * @idmap:	idmap of the mount the inode was found from
- * @dentry:	The inode/dentry being altered
+ * @path:	The inode/path being altered
  * @name:	The name of the xattr to be changed
+ * @file:	the file through which the xattr removal is requested, if any
  *
  * Determine whether an xattr may be removed from an inode, returning 0 if
  * permission is granted, -ve if denied.
@@ -1061,8 +1066,10 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  * aren't privileged to remove them.
  */
 int cap_inode_removexattr(const struct mnt_idmap *idmap,
-			  struct dentry *dentry, const char *name)
+			  const struct path *path, const char *name,
+			  struct file *file)
 {
+	struct dentry *dentry = path->dentry;
 	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
 
 	/* Ignore non-security xattrs */
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 7167d854688a..d5407ed88fdc 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -615,11 +615,12 @@ static int evm_protect_xattr(const struct mnt_idmap *idmap,
 /**
  * evm_inode_setxattr - protect the EVM extended attribute
  * @idmap: idmap of the mount
- * @dentry: pointer to the affected dentry
+ * @path: pointer to the affected object
  * @xattr_name: pointer to the affected extended attribute name
  * @xattr_value: pointer to the new extended attribute value
  * @xattr_value_len: pointer to the new extended attribute value length
  * @flags: flags to pass into filesystem operations
+ * @file: file through which the xattr change is requested, if any
  *
  * Before allowing the 'security.evm' protected xattr to be updated,
  * verify the existing value is valid.  As only the kernel should have
@@ -627,11 +628,14 @@ static int evm_protect_xattr(const struct mnt_idmap *idmap,
  * userspace from writing HMAC value.  Writing 'security.evm' requires
  * requires CAP_SYS_ADMIN privileges.
  */
-static int evm_inode_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
+static int evm_inode_setxattr(const struct mnt_idmap *idmap,
+			      const struct path *path,
 			      const char *xattr_name, const void *xattr_value,
-			      size_t xattr_value_len, int flags)
+			      size_t xattr_value_len, int flags,
+			      struct file *file)
 {
 	const struct evm_ima_xattr_data *xattr_data = xattr_value;
+	struct dentry *dentry = path->dentry;
 
 	/* Policy permits modification of the protected xattrs even though
 	 * there's no HMAC key loaded
@@ -653,15 +657,19 @@ static int evm_inode_setxattr(const struct mnt_idmap *idmap, struct dentry *dent
 /**
  * evm_inode_removexattr - protect the EVM extended attribute
  * @idmap: idmap of the mount
- * @dentry: pointer to the affected dentry
+ * @path: pointer to the affected object
  * @xattr_name: pointer to the affected extended attribute name
+ * @file: file through which the xattr removal is requested, if any
  *
  * Removing 'security.evm' requires CAP_SYS_ADMIN privileges and that
  * the current value is valid.
  */
-static int evm_inode_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
-				 const char *xattr_name)
+static int evm_inode_removexattr(const struct mnt_idmap *idmap,
+				 const struct path *path,
+				 const char *xattr_name, struct file *file)
 {
+	struct dentry *dentry = path->dentry;
+
 	/* Policy permits modification of the protected xattrs even though
 	 * there's no HMAC key loaded
 	 */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 134174d2e3f0..ebf050195cf0 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -759,11 +759,14 @@ static int validate_hash_algo(struct dentry *dentry,
 	return -EACCES;
 }
 
-static int ima_inode_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
+static int ima_inode_setxattr(const struct mnt_idmap *idmap,
+			      const struct path *path,
 			      const char *xattr_name, const void *xattr_value,
-			      size_t xattr_value_len, int flags)
+			      size_t xattr_value_len, int flags,
+			      struct file *file)
 {
 	const struct evm_ima_xattr_data *xvalue = xattr_value;
+	struct dentry *dentry = path->dentry;
 	int digsig = 0;
 	int result;
 	int err;
@@ -801,16 +804,17 @@ static int ima_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentr
 	return 0;
 }
 
-static int ima_inode_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
-				 const char *xattr_name)
+static int ima_inode_removexattr(const struct mnt_idmap *idmap,
+				 const struct path *path,
+				 const char *xattr_name, struct file *file)
 {
 	int result, digsig = -1;
 
-	result = ima_protect_xattr(dentry, xattr_name, NULL, 0);
+	result = ima_protect_xattr(path->dentry, xattr_name, NULL, 0);
 	if (result == 1 || evm_revalidate_status(xattr_name)) {
 		if (!strcmp(xattr_name, XATTR_NAME_IMA))
 			digsig = 0;
-		ima_reset_appraise_flags(d_backing_inode(dentry), digsig);
+		ima_reset_appraise_flags(d_backing_inode(path->dentry), digsig);
 		if (result == 1)
 			result = 0;
 	}
diff --git a/security/security.c b/security/security.c
index 7e6a8a2a2ee5..e01969809ac5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1921,14 +1921,15 @@ int security_inode_getattr(const struct path *path)
 /**
  * security_inode_setxattr() - Check if setting file xattrs is allowed
  * @idmap: idmap of the mount
- * @dentry: file
+ * @path: file (the VFS makes no guarantees with regard to @path->mnt)
  * @name: xattr name
  * @value: xattr value
  * @size: size of xattr value
  * @flags: flags
+ * @file: file through which the xattr change is requested, if any
  *
  * This hook performs the desired permission checks before setting the extended
- * attributes (xattrs) on @dentry.  It is important to note that we have some
+ * attributes (xattrs) on @path.  It is important to note that we have some
  * additional logic before the main LSM implementation calls to detect if we
  * need to perform an additional capability check at the LSM layer.
  *
@@ -1945,23 +1946,24 @@ int security_inode_getattr(const struct path *path)
  * Return: Returns 0 if permission is granted.
  */
 int security_inode_setxattr(const struct mnt_idmap *idmap,
-			    struct dentry *dentry, const char *name,
-			    const void *value, size_t size, int flags)
+			    const struct path *path, const char *name,
+			    const void *value, size_t size, int flags,
+			    struct file *file)
 {
 	int rc;
 
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
 
 	/* enforce the capability checks at the lsm layer, if needed */
 	if (!call_int_hook(inode_xattr_skipcap, name)) {
-		rc = cap_inode_setxattr(dentry, name, value, size, flags);
+		rc = cap_inode_setxattr(path, name, value, size, flags, file);
 		if (rc)
 			return rc;
 	}
 
-	return call_int_hook(inode_setxattr, idmap, dentry, name, value, size,
-			     flags);
+	return call_int_hook(inode_setxattr, idmap, path, name, value,
+			     size, flags, file);
 }
 
 /**
@@ -2077,45 +2079,49 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 
 /**
  * security_inode_getxattr() - Check if xattr access is allowed
- * @dentry: file
+ * @path: file (the VFS makes no guarantees with regard to @path->mnt)
  * @name: xattr name
+ * @file: file through which the xattr access is requested, if any
  *
  * Check permission before obtaining the extended attributes identified by
- * @name for @dentry.
+ * @name for @path.
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_getxattr(struct dentry *dentry, const char *name)
+int security_inode_getxattr(const struct path *path,
+			    const char *name, struct file *file)
 {
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_getxattr, dentry, name);
+	return call_int_hook(inode_getxattr, path, name, file);
 }
 
 /**
  * security_inode_listxattr() - Check if listing xattrs is allowed
- * @dentry: file
+ * @path: file (the VFS makes no guarantees with regard to @path->mnt)
+ * @file: file through which the xattr names are listed, if any
  *
  * Check permission before obtaining the list of extended attribute names for
- * @dentry.
+ * @path.
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_listxattr(struct dentry *dentry)
+int security_inode_listxattr(const struct path *path, struct file *file)
 {
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_listxattr, dentry);
+	return call_int_hook(inode_listxattr, path, file);
 }
 
 /**
  * security_inode_removexattr() - Check if removing an xattr is allowed
  * @idmap: idmap of the mount
- * @dentry: file
+ * @path: file (the VFS makes no guarantees with regard to @path->mnt)
  * @name: xattr name
+ * @file: file through which the xattr removal is requested, if any
  *
  * This hook performs the desired permission checks before setting the extended
- * attributes (xattrs) on @dentry.  It is important to note that we have some
+ * attributes (xattrs) on @path.  It is important to note that we have some
  * additional logic before the main LSM implementation calls to detect if we
  * need to perform an additional capability check at the LSM layer.
  *
@@ -2132,21 +2138,22 @@ int security_inode_listxattr(struct dentry *dentry)
  * Return: Returns 0 if permission is granted.
  */
 int security_inode_removexattr(const struct mnt_idmap *idmap,
-			       struct dentry *dentry, const char *name)
+			       const struct path *path, const char *name,
+			       struct file *file)
 {
 	int rc;
 
-	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
+	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
 
 	/* enforce the capability checks at the lsm layer, if needed */
 	if (!call_int_hook(inode_xattr_skipcap, name)) {
-		rc = cap_inode_removexattr(idmap, dentry, name);
+		rc = cap_inode_removexattr(idmap, path, name, file);
 		if (rc)
 			return rc;
 	}
 
-	return call_int_hook(inode_removexattr, idmap, dentry, name);
+	return call_int_hook(inode_removexattr, idmap, path, name, file);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d022dbffa484..f38105ccc1fb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3388,9 +3388,11 @@ static int selinux_inode_xattr_skipcap(const char *name)
 }
 
 static int selinux_inode_setxattr(const struct mnt_idmap *idmap,
-				  struct dentry *dentry, const char *name,
-				  const void *value, size_t size, int flags)
+				  const struct path *path,
+				  const char *name, const void *value,
+				  size_t size, int flags, struct file *file)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_backing_inode(dentry);
 	struct inode_security_struct *isec;
 	struct superblock_security_struct *sbsec;
@@ -3532,26 +3534,29 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 	spin_unlock(&isec->lock);
 }
 
-static int selinux_inode_getxattr(struct dentry *dentry, const char *name)
+static int selinux_inode_getxattr(const struct path *path,
+				  const char *name, struct file *file)
 {
 	const struct cred *cred = current_cred();
 
-	return dentry_has_perm(cred, dentry, FILE__GETATTR);
+	return dentry_has_perm(cred, path->dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr(struct dentry *dentry)
+static int selinux_inode_listxattr(const struct path *path, struct file *file)
 {
 	const struct cred *cred = current_cred();
 
-	return dentry_has_perm(cred, dentry, FILE__GETATTR);
+	return dentry_has_perm(cred, path->dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_removexattr(const struct mnt_idmap *idmap,
-				     struct dentry *dentry, const char *name)
+				     const struct path *path,
+				     const char *name, struct file *file)
 {
 	/* if not a selinux xattr, only check the ordinary setattr perm */
 	if (strcmp(name, XATTR_NAME_SELINUX))
-		return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
+		return dentry_has_perm(current_cred(), path->dentry,
+				       FILE__SETATTR);
 
 	if (!selinux_initialized())
 		return 0;
@@ -7152,7 +7157,7 @@ static int selinux_inode_setsecctx(const struct path *path, void *ctx,
 				   u32 ctxlen)
 {
 	return __vfs_setxattr_locked(&nop_mnt_idmap, path, XATTR_NAME_SELINUX,
-				     ctx, ctxlen, 0, NULL);
+				     ctx, ctxlen, 0, NULL, NULL);
 }
 
 static int selinux_inode_getsecctx(struct inode *inode, struct lsm_context *cp)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8f3276746bfd..be522c236dbf 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1340,21 +1340,24 @@ static int smack_inode_xattr_skipcap(const char *name)
 /**
  * smack_inode_setxattr - Smack check for setting xattrs
  * @idmap: idmap of the mount
- * @dentry: the object
+ * @path: the object
  * @name: name of the attribute
  * @value: value of the attribute
  * @size: size of the value
  * @flags: unused
+ * @file: file through which the xattr change is requested, if any
  *
  * This protects the Smack attribute explicitly.
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
 static int smack_inode_setxattr(const struct mnt_idmap *idmap,
-				struct dentry *dentry, const char *name,
-				const void *value, size_t size, int flags)
+				const struct path *path,
+				const char *name, const void *value,
+				size_t size, int flags, struct file *file)
 {
 	struct smk_audit_info ad;
+	struct dentry *dentry = path->dentry;
 	struct smack_known *skp;
 	int check_priv = 0;
 	int check_import = 0;
@@ -1456,14 +1459,17 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 
 /**
  * smack_inode_getxattr - Smack check on getxattr
- * @dentry: the object
+ * @path: the object
  * @name: unused
+ * @file: file through which the xattr access is requested, if any
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_getxattr(struct dentry *dentry, const char *name)
+static int smack_inode_getxattr(const struct path *path,
+			const char *name, struct file *file)
 {
 	struct smk_audit_info ad;
+	struct dentry *dentry = path->dentry;
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
@@ -1477,18 +1483,21 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 /**
  * smack_inode_removexattr - Smack check on removexattr
  * @idmap: idmap of the mount
- * @dentry: the object
+ * @path: the object
  * @name: name of the attribute
+ * @file: file through which the xattr removal is requested, if any
  *
  * Removing the Smack attribute requires CAP_MAC_ADMIN
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
 static int smack_inode_removexattr(const struct mnt_idmap *idmap,
-				   struct dentry *dentry, const char *name)
+				   const struct path *path,
+				   const char *name, struct file *file)
 {
 	struct inode_smack *isp;
 	struct smk_audit_info ad;
+	struct dentry *dentry = path->dentry;
 	int rc = 0;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
@@ -4985,7 +4994,7 @@ static int smack_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 static int smack_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
 {
 	return __vfs_setxattr_locked(&nop_mnt_idmap, path, XATTR_NAME_SMACK,
-				     ctx, ctxlen, 0, NULL);
+				     ctx, ctxlen, 0, NULL, NULL);
 }
 
 static int smack_inode_getsecctx(struct inode *inode, struct lsm_context *cp)
diff --git a/tools/testing/selftests/bpf/progs/test_get_xattr.c b/tools/testing/selftests/bpf/progs/test_get_xattr.c
index 54305f4c9f2d..97361ff10e9f 100644
--- a/tools/testing/selftests/bpf/progs/test_get_xattr.c
+++ b/tools/testing/selftests/bpf/progs/test_get_xattr.c
@@ -56,7 +56,8 @@ int BPF_PROG(test_file_open, struct file *f)
 }
 
 SEC("lsm.s/inode_getxattr")
-int BPF_PROG(test_inode_getxattr, struct dentry *dentry, char *name)
+int BPF_PROG(test_inode_getxattr, const struct path *path, char *name,
+	     struct file *file)
 {
 	struct bpf_dynptr value_ptr;
 	__u32 pid;
@@ -69,7 +70,7 @@ int BPF_PROG(test_inode_getxattr, struct dentry *dentry, char *name)
 	bpf_dynptr_from_mem(value2, sizeof(value2), 0, &value_ptr);
 
 	for (i = 0; i < ARRAY_SIZE(xattr_names); i++) {
-		ret = bpf_get_dentry_xattr(dentry, xattr_names[i], &value_ptr);
+		ret = bpf_get_dentry_xattr(path->dentry, xattr_names[i], &value_ptr);
 		if (ret == sizeof(expected_value))
 			break;
 	}
diff --git a/tools/testing/selftests/bpf/progs/test_set_remove_xattr.c b/tools/testing/selftests/bpf/progs/test_set_remove_xattr.c
index 6a612cf168d3..06656ac9a777 100644
--- a/tools/testing/selftests/bpf/progs/test_set_remove_xattr.c
+++ b/tools/testing/selftests/bpf/progs/test_set_remove_xattr.c
@@ -33,7 +33,8 @@ static inline bool name_match_foo(const char *name)
 
 /* Test bpf_set_dentry_xattr and bpf_remove_dentry_xattr */
 SEC("lsm.s/inode_getxattr")
-int BPF_PROG(test_inode_getxattr, struct dentry *dentry, char *name)
+int BPF_PROG(test_inode_getxattr, const struct path *path, char *name,
+	     struct file *file)
 {
 	struct bpf_dynptr value_ptr;
 	__u32 pid;
@@ -50,25 +51,25 @@ int BPF_PROG(test_inode_getxattr, struct dentry *dentry, char *name)
 	bpf_dynptr_from_mem(read_value, sizeof(read_value), 0, &value_ptr);
 
 	/* read security.bpf.bar */
-	ret = bpf_get_dentry_xattr(dentry, xattr_bar, &value_ptr);
+	ret = bpf_get_dentry_xattr(path->dentry, xattr_bar, &value_ptr);
 
 	if (ret < 0) {
 		/* If security.bpf.bar doesn't exist, set it */
 		bpf_dynptr_from_mem(value_bar, sizeof(value_bar), 0, &value_ptr);
 
-		ret = bpf_set_dentry_xattr(dentry, xattr_bar, &value_ptr, 0);
+		ret = bpf_set_dentry_xattr(path->dentry, xattr_bar, &value_ptr, 0);
 		if (!ret)
 			set_security_bpf_bar_success = true;
-		ret = bpf_set_dentry_xattr(dentry, xattr_selinux, &value_ptr, 0);
+		ret = bpf_set_dentry_xattr(path->dentry, xattr_selinux, &value_ptr, 0);
 		if (ret)
 			set_security_selinux_fail = true;
 	} else {
 		/* If security.bpf.bar exists, remove it */
-		ret = bpf_remove_dentry_xattr(dentry, xattr_bar);
+		ret = bpf_remove_dentry_xattr(path->dentry, xattr_bar);
 		if (!ret)
 			remove_security_bpf_bar_success = true;
 
-		ret = bpf_remove_dentry_xattr(dentry, xattr_selinux);
+		ret = bpf_remove_dentry_xattr(path->dentry, xattr_selinux);
 		if (ret)
 			remove_security_selinux_fail = true;
 	}
@@ -87,9 +88,10 @@ bool locked_remove_security_selinux_fail;
  * properly.
  */
 SEC("lsm.s/inode_setxattr")
-int BPF_PROG(test_inode_setxattr, struct mnt_idmap *idmap,
-	     struct dentry *dentry, const char *name,
-	     const void *value, size_t size, int flags)
+int BPF_PROG(test_inode_setxattr, const struct mnt_idmap *idmap,
+	     const struct path *path,
+	     const char *name, const void *value, size_t size, int flags,
+	     struct file *file)
 {
 	struct bpf_dynptr value_ptr;
 	__u32 pid;
@@ -106,25 +108,25 @@ int BPF_PROG(test_inode_setxattr, struct mnt_idmap *idmap,
 	bpf_dynptr_from_mem(read_value, sizeof(read_value), 0, &value_ptr);
 
 	/* read security.bpf.bar */
-	ret = bpf_get_dentry_xattr(dentry, xattr_bar, &value_ptr);
+	ret = bpf_get_dentry_xattr(path->dentry, xattr_bar, &value_ptr);
 
 	if (ret < 0) {
 		/* If security.bpf.bar doesn't exist, set it */
 		bpf_dynptr_from_mem(value_bar, sizeof(value_bar), 0, &value_ptr);
 
-		ret = bpf_set_dentry_xattr(dentry, xattr_bar, &value_ptr, 0);
+		ret = bpf_set_dentry_xattr(path->dentry, xattr_bar, &value_ptr, 0);
 		if (!ret)
 			locked_set_security_bpf_bar_success = true;
-		ret = bpf_set_dentry_xattr(dentry, xattr_selinux, &value_ptr, 0);
+		ret = bpf_set_dentry_xattr(path->dentry, xattr_selinux, &value_ptr, 0);
 		if (ret)
 			locked_set_security_selinux_fail = true;
 	} else {
 		/* If security.bpf.bar exists, remove it */
-		ret = bpf_remove_dentry_xattr(dentry, xattr_bar);
+		ret = bpf_remove_dentry_xattr(path->dentry, xattr_bar);
 		if (!ret)
 			locked_remove_security_bpf_bar_success = true;
 
-		ret = bpf_remove_dentry_xattr(dentry, xattr_selinux);
+		ret = bpf_remove_dentry_xattr(path->dentry, xattr_selinux);
 		if (ret)
 			locked_remove_security_selinux_fail = true;
 	}
diff --git a/tools/testing/selftests/bpf/progs/verifier_lsm_init_xattr.c b/tools/testing/selftests/bpf/progs/verifier_lsm_init_xattr.c
index b706bf17b556..9b7a15c1862f 100644
--- a/tools/testing/selftests/bpf/progs/verifier_lsm_init_xattr.c
+++ b/tools/testing/selftests/bpf/progs/verifier_lsm_init_xattr.c
@@ -234,8 +234,10 @@ int BPF_PROG(reject_lsm_cgroup, struct inode *inode, struct inode *dir,
 
 SEC("lsm/inode_setxattr")
 __failure __msg("calling kernel function bpf_inode_init_xattr is not allowed")
-int BPF_PROG(reject_wrong_hook, struct mnt_idmap *idmap, struct dentry *dentry,
-	     const char *name, const void *value, size_t size, int flags)
+int BPF_PROG(reject_wrong_hook, const struct mnt_idmap *idmap,
+	     const struct path *path,
+	     const char *name, const void *value, size_t size, int flags,
+	     struct file *file)
 {
 	struct bpf_dynptr val;
 
-- 
2.18.0.huawei.25

