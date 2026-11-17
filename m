Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926025;
	b=Z+RVl9gWu5znFnYb1IGVwxg2ppsYDB9VVb94/krSxMUAG9cD8BJUsrCSTb2ptqsnzz33
	 RsOE2jcwteMOaxAF4Hl+rtPuZMqFH5O9W+U9JgnrYZTxGVL3UsYoRIjCKT3Lprg4P5xqK
	 KCULKeZG7Chylw6SldFsQ5f4M3Hr15JPzZsPdG6LcXphyHOKbKrZDMfaSp+v7HE0x6gIW
	 /ivjGwhTbqznqvuH23Xs6/yiUUwxrcj8wld/yghHR+OvRchazhDWG7D1FB2Y13SW2L/uf
	 Qh+5VMZCOV1zcti/H/5VkyXaDLGhGqqVbmEIpnT6zt9vKr5Qb9WW/RIuck8SgUhcpCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926025;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=V/xSyjD7IatTJnFa9OQhwXq77xmaBwUfJra6chOkSB8=;
	b=sKQvRgCN/UAIeoMOX9JG/iNsbEjkDTRnZUtEnCKNNXxP9E+Ti9lL7Nsf2M7wFoyt51Uc
	 Ce4EtREgc4D+KgIlY39j28a6Tn4goEkIAa0KkPG8QNSeIpgdW7b3/ogcH8jNl0mB6OsXi
	 xQHB1t2HvGWnwhmseC9zU3zYxcs6iO0jXMgCMlZ7+swQPj+bbMz7ELTbVkX2YkOyxqwUo
	 wgSNoisWoVVC8OiyjUY+hb1Bjy2r0QaNz8gFUjt3QEOYo1DDQwSS9y6V+LAcPxCWSkDsk
	 r5rgxE1FNbWRsMDYcZjeI0Y4dvp1BlvdOwYTwfdeNhpUwp/xfDTVTncYo5JLil2zPig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=TIHYbDg9;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF5B60A3817;
	Tue, 17 Nov 2026 14:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EF5B60A3817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=TIHYbDg9
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=V/xSyjD7IatTJnFa9OQhwXq77xmaBwUfJra6chOkSB8=;
	b=TIHYbDg99u1o06uBR9ZsSrSkJSlGG2PiScA5zae7T/R2hFytBGXVgqw+3kE/79EUSfJO3Kb5y
	4txkKGOcWL1cr5ylf8vXyli7i8+/yAgWg6MCYCdeShCug0ZLSj8PDlCZh5fQCRucu1aiha6Tx/n
	bWUX2tVWCuY5LA5QXIggIFA=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jTRz52Z54zcb3H;
	Tue, 17 Nov 2026 22:32:49 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 616414057F;
	Tue, 17 Nov 2026 22:33:40 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:34 +0800
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
Subject: [PATCH -next -v4 03/17] fs: pass struct path to xattr helpers
Date: Tue, 17 Nov 2026 23:05:28 +0800
Message-ID: <20261117150542.1169451-4-caixinchen1@huawei.com>
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

vfs_setxattr(), vfs_getxattr(), vfs_listxattr() and vfs_removexattr(),
together with the __vfs_*_locked() variants, take a struct dentry even
though their callers either hold a struct path (or a struct file).  Pass
a struct path instead; the idmap stays a separate argument so that the
VFS and the filesystem see the same idmap, including for filesystems that
forward a change with &nop_mnt_idmap.

__vfs_setxattr_noperm(), __vfs_getxattr(), __vfs_setxattr(),
__vfs_removexattr() and vfs_getxattr_alloc() keep taking a dentry, as
they are only called from LSM internals and other dentry-only contexts.

The ksmbd helpers now take a proper struct path from their callers
instead of wrapping the dentry in a synthetic path built from the share
root's mount.  For the '..' entry of a mount root, follow the mount stack
up with follow_up(), and report the share root if the mount has been
detached, so that the path stays valid.

evm_calc_hmac_or_hash() calls vfs_getxattr() only to print a debug
message when the kernel-side and user-space-side xattr sizes differ.
That call cannot be migrated, so drop the check and the now unused
user_space_size variable.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 drivers/block/zloop.c               |  4 +-
 fs/cachefiles/xattr.c               | 35 +++++++------
 fs/ecryptfs/inode.c                 |  9 ++--
 fs/nfsd/nfs4ctl.h                   |  5 +-
 fs/nfsd/vfs.c                       | 65 +++++++++++++----------
 fs/overlayfs/copy_up.c              |  4 +-
 fs/overlayfs/overlayfs.h            | 17 ++++--
 fs/overlayfs/xattrs.c               | 12 +++--
 fs/smb/server/smb2pdu.c             | 51 +++++++++---------
 fs/smb/server/smb_common.c          | 59 ++++++++++++++++++---
 fs/smb/server/smbacl.c              | 10 ++--
 fs/smb/server/vfs.c                 | 80 +++++++++++++----------------
 fs/smb/server/vfs.h                 | 16 +++---
 fs/xattr.c                          | 78 +++++++++++++++-------------
 include/linux/xattr.h               | 26 ++++++----
 security/integrity/evm/evm_crypto.c |  8 +--
 security/selinux/hooks.c            |  4 +-
 security/smack/smack_lsm.c          |  4 +-
 18 files changed, 277 insertions(+), 210 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 96666742523b..cfde2e1f03cd 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -718,7 +718,7 @@ static int zloop_record_safe_wps(struct zloop_device *zlo)
 
 		if (!zloop_zone_is_active(zone))
 			continue;
-		ret = vfs_setxattr(file_mnt_idmap(file), file_dentry(file),
+		ret = vfs_setxattr(file_mnt_idmap(file), &file->f_path,
 				"user.zloop.wp", &zone->wp, sizeof(zone->wp), 0);
 		if (ret) {
 			pr_err("%pg: failed to record write pointer (%d)\n",
@@ -1419,7 +1419,7 @@ static void zloop_forget_cache(struct zloop_device *zlo)
 		if (!zloop_zone_is_active(zone))
 			continue;
 
-		ret = vfs_getxattr(file_mnt_idmap(file), file_dentry(file),
+		ret = vfs_getxattr(file_mnt_idmap(file), &file->f_path,
 				"user.zloop.wp", &old_wp, sizeof(old_wp));
 		if (ret == -ENODATA) {
 			old_wp = 0;
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 8ebb713482e3..afdce5ce3b73 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -40,7 +40,6 @@ struct cachefiles_vol_xattr {
 int cachefiles_preset_object_xattr(struct cachefiles_object *object, struct file *file)
 {
 	struct cachefiles_xattr *buf;
-	struct dentry *dentry = file->f_path.dentry;
 	unsigned int len = object->cookie->aux_len;
 	int ret;
 
@@ -55,7 +54,7 @@ int cachefiles_preset_object_xattr(struct cachefiles_object *object, struct file
 	if (ret == 0) {
 		ret = mnt_want_write_file(file);
 		if (ret == 0) {
-			ret = vfs_setxattr(&nop_mnt_idmap, dentry,
+			ret = vfs_setxattr(&nop_mnt_idmap, &file->f_path,
 					   cachefiles_xattr_cache, buf,
 					   sizeof(struct cachefiles_xattr) + len, 0);
 			mnt_drop_write_file(file);
@@ -91,7 +90,6 @@ int cachefiles_preset_object_xattr(struct cachefiles_object *object, struct file
 int cachefiles_set_object_xattr(struct cachefiles_object *object)
 {
 	struct cachefiles_xattr *buf;
-	struct dentry *dentry;
 	struct file *file = object->file;
 	unsigned int len = object->cookie->aux_len;
 	uoff_t object_size = object->cookie->object_size;
@@ -99,7 +97,6 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 
 	if (!file)
 		return -ESTALE;
-	dentry = file->f_path.dentry;
 
 	_enter("%x,#%d", object->debug_id, len);
 
@@ -121,7 +118,7 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 	if (ret == 0) {
 		ret = mnt_want_write_file(file);
 		if (ret == 0) {
-			ret = vfs_setxattr(&nop_mnt_idmap, dentry,
+			ret = vfs_setxattr(&nop_mnt_idmap, &file->f_path,
 					   cachefiles_xattr_cache, buf,
 					   sizeof(struct cachefiles_xattr) + len, 0);
 			mnt_drop_write_file(file);
@@ -160,7 +157,6 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file)
 {
 	struct cachefiles_xattr *buf;
-	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = file_inode(file);
 	unsigned int len = object->cookie->aux_len, tlen;
 	const void *p = fscache_get_aux(object->cookie);
@@ -177,7 +173,8 @@ int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file
 
 	xlen = cachefiles_inject_read_error();
 	if (xlen == 0)
-		xlen = vfs_getxattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache, buf, tlen);
+		xlen = vfs_getxattr(&nop_mnt_idmap, &file->f_path,
+				    cachefiles_xattr_cache, buf, tlen);
 	if (xlen != tlen) {
 		if (xlen < 0) {
 			ret = xlen;
@@ -226,6 +223,7 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 				   struct cachefiles_object *object,
 				   struct dentry *dentry)
 {
+	struct path path = { .mnt = cache->mnt, .dentry = dentry };
 	int ret;
 
 	trace_cachefiles_coherency(object, d_inode(dentry)->i_ino, 0, NULL, 0,
@@ -235,7 +233,7 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 	if (ret == 0) {
 		ret = mnt_want_write(cache->mnt);
 		if (ret == 0) {
-			ret = vfs_removexattr(&nop_mnt_idmap, dentry,
+			ret = vfs_removexattr(&nop_mnt_idmap, &path,
 					      cachefiles_xattr_cache);
 			mnt_drop_write(cache->mnt);
 		}
@@ -282,7 +280,8 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 	struct cachefiles_vol_xattr *buf;
 	unsigned int len = volume->vcookie->coherency_len;
 	const void *p = volume->vcookie->coherency;
-	struct dentry *dentry = volume->dentry;
+	struct path path = { .mnt = volume->cache->mnt,
+			     .dentry = volume->dentry };
 	int ret;
 
 	_enter("%x,#%d", volume->vcookie->debug_id, len);
@@ -298,22 +297,22 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 	if (ret == 0) {
 		ret = mnt_want_write(volume->cache->mnt);
 		if (ret == 0) {
-			ret = vfs_setxattr(&nop_mnt_idmap, dentry,
+			ret = vfs_setxattr(&nop_mnt_idmap, &path,
 					   cachefiles_xattr_cache,
 					   buf, len, 0);
 			mnt_drop_write(volume->cache->mnt);
 		}
 	}
 	if (ret < 0) {
-		trace_cachefiles_vfs_error(NULL, d_inode(dentry), ret,
+		trace_cachefiles_vfs_error(NULL, d_inode(path.dentry), ret,
 					   cachefiles_trace_setxattr_error);
-		trace_cachefiles_vol_coherency(volume, d_inode(dentry)->i_ino,
+		trace_cachefiles_vol_coherency(volume, d_inode(path.dentry)->i_ino,
 					       cachefiles_coherency_vol_set_fail);
 		if (ret != -ENOMEM)
 			cachefiles_io_error(
 				volume->cache, "Failed to set xattr with error %d", ret);
 	} else {
-		trace_cachefiles_vol_coherency(volume, d_inode(dentry)->i_ino,
+		trace_cachefiles_vol_coherency(volume, d_inode(path.dentry)->i_ino,
 					       cachefiles_coherency_vol_set_ok);
 	}
 
@@ -328,9 +327,10 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 int cachefiles_check_volume_xattr(struct cachefiles_volume *volume)
 {
 	struct cachefiles_vol_xattr *buf;
-	struct dentry *dentry = volume->dentry;
 	unsigned int len = volume->vcookie->coherency_len;
 	const void *p = volume->vcookie->coherency;
+	struct path path = { .mnt = volume->cache->mnt,
+			     .dentry = volume->dentry };
 	enum cachefiles_coherency_trace why;
 	ssize_t xlen;
 	int ret = -ESTALE;
@@ -344,11 +344,12 @@ int cachefiles_check_volume_xattr(struct cachefiles_volume *volume)
 
 	xlen = cachefiles_inject_read_error();
 	if (xlen == 0)
-		xlen = vfs_getxattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache, buf, len);
+		xlen = vfs_getxattr(&nop_mnt_idmap, &path,
+				    cachefiles_xattr_cache, buf, len);
 	if (xlen != len) {
 		if (xlen < 0) {
 			ret = xlen;
-			trace_cachefiles_vfs_error(NULL, d_inode(dentry), xlen,
+			trace_cachefiles_vfs_error(NULL, d_inode(path.dentry), xlen,
 						   cachefiles_trace_getxattr_error);
 			if (xlen == -EIO)
 				cachefiles_io_error(
@@ -365,7 +366,7 @@ int cachefiles_check_volume_xattr(struct cachefiles_volume *volume)
 		ret = 0;
 	}
 
-	trace_cachefiles_vol_coherency(volume, d_inode(dentry)->i_ino, why);
+	trace_cachefiles_vol_coherency(volume, d_inode(path.dentry)->i_ino, why);
 	kfree(buf);
 	_leave(" = %d", ret);
 	return ret;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 26967e4e4660..c1be27e1f7eb 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -992,17 +992,18 @@ ecryptfs_setxattr(struct dentry *dentry, struct inode *inode,
 		  size_t size, int flags)
 {
 	int rc;
-	struct dentry *lower_dentry;
+	struct path lower_path;
 	struct inode *lower_inode;
 
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	lower_inode = d_inode(lower_dentry);
+	lower_path = ecryptfs_lower_path(dentry);
+	lower_inode = d_inode(lower_path.dentry);
 	if (!(lower_inode->i_opflags & IOP_XATTR)) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	inode_lock(lower_inode);
-	rc = __vfs_setxattr_locked(&nop_mnt_idmap, lower_dentry, name, value, size, flags, NULL);
+	rc = __vfs_setxattr_locked(&nop_mnt_idmap, &lower_path, name, value,
+				   size, flags, NULL);
 	inode_unlock(lower_inode);
 	if (!rc && inode)
 		fsstack_copy_attr_all(inode, lower_inode);
diff --git a/fs/nfsd/nfs4ctl.h b/fs/nfsd/nfs4ctl.h
index e0d1246ca337..fad496c07bae 100644
--- a/fs/nfsd/nfs4ctl.h
+++ b/fs/nfsd/nfs4ctl.h
@@ -20,6 +20,7 @@
 struct net;
 struct inode;
 struct dentry;
+struct path;
 struct svc_rqst;
 struct nfsd_net;
 
@@ -36,7 +37,7 @@ int nfsd4_create_laundry_wq(void);
 void nfsd4_destroy_laundry_wq(void);
 bool nfsd_wait_for_delegreturn(struct svc_rqst *rqstp, struct inode *inode);
 
-extern int nfsd4_is_junction(struct dentry *dentry);
+extern int nfsd4_is_junction(const struct path *path);
 extern int register_cld_notifier(void);
 extern void unregister_cld_notifier(void);
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
@@ -64,7 +65,7 @@ static inline bool nfsd_wait_for_delegreturn(struct svc_rqst *rqstp,
 	return false;
 }
 
-static inline int nfsd4_is_junction(struct dentry *dentry)
+static inline int nfsd4_is_junction(const struct path *path)
 {
 	return 0;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 1c686b82e70a..aef4097e9ef3 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -233,11 +233,13 @@ static int nfsd_lookup_parent(struct svc_rqst *rqstp, struct dentry *dparent, st
  */
 int nfsd_mountpoint(struct dentry *dentry, struct svc_export *exp)
 {
+	struct path path = { .mnt = exp->ex_path.mnt, .dentry = dentry };
+
 	if (!d_inode(dentry))
 		return 0;
 	if (exp->ex_flags & NFSEXP_V4ROOT)
 		return 1;
-	if (nfsd4_is_junction(dentry))
+	if (nfsd4_is_junction(&path))
 		return 1;
 	if (d_managed(dentry))
 		/*
@@ -685,14 +687,14 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 /**
  * nfsd4_is_junction - Test if an object could be an NFS junction
  *
- * @dentry: object to test
+ * @path: object to test
  *
- * Returns 1 if "dentry" appears to contain NFS junction information.
+ * Returns 1 if "path" appears to contain NFS junction information.
  * Otherwise 0 is returned.
  */
-int nfsd4_is_junction(struct dentry *dentry)
+int nfsd4_is_junction(const struct path *path)
 {
-	struct inode *inode = d_inode(dentry);
+	struct inode *inode = d_inode(path->dentry);
 
 	if (inode == NULL)
 		return 0;
@@ -700,7 +702,7 @@ int nfsd4_is_junction(struct dentry *dentry)
 		return 0;
 	if (!(inode->i_mode & S_ISVTX))
 		return 0;
-	if (vfs_getxattr(&nop_mnt_idmap, dentry, NFSD_JUNCTION_XATTR_NAME,
+	if (vfs_getxattr(&nop_mnt_idmap, path, NFSD_JUNCTION_XATTR_NAME,
 			 NULL, 0) <= 0)
 		return 0;
 	return 1;
@@ -2676,23 +2678,24 @@ __be32
 nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 	      void **bufp, int *lenp)
 {
+	struct path path;
+	struct inode *inode;
+	char *buf;
 	ssize_t len;
 	__be32 err;
-	char *buf;
-	struct inode *inode;
-	struct dentry *dentry;
 
 	err = fh_verify(rqstp, fhp, 0, NFSD_MAY_READ);
 	if (err)
 		return err;
 
 	err = nfs_ok;
-	dentry = fhp->fh_dentry;
-	inode = d_inode(dentry);
+	path.mnt = fhp->fh_export->ex_path.mnt;
+	path.dentry = fhp->fh_dentry;
+	inode = d_inode(path.dentry);
 
 	inode_lock_shared(inode);
 
-	len = vfs_getxattr(&nop_mnt_idmap, dentry, name, NULL, 0);
+	len = vfs_getxattr(&nop_mnt_idmap, &path, name, NULL, 0);
 
 	/*
 	 * Zero-length attribute, just return.
@@ -2719,7 +2722,7 @@ nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 		goto out;
 	}
 
-	len = vfs_getxattr(&nop_mnt_idmap, dentry, name, buf, len);
+	len = vfs_getxattr(&nop_mnt_idmap, &path, name, buf, len);
 	if (len <= 0) {
 		kvfree(buf);
 		buf = NULL;
@@ -2749,23 +2752,24 @@ __be32
 nfsd_listxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char **bufp,
 	       int *lenp)
 {
+	struct path path;
+	struct inode *inode;
+	char *buf;
 	ssize_t len;
 	__be32 err;
-	char *buf;
-	struct inode *inode;
-	struct dentry *dentry;
 
 	err = fh_verify(rqstp, fhp, 0, NFSD_MAY_READ);
 	if (err)
 		return err;
 
-	dentry = fhp->fh_dentry;
-	inode = d_inode(dentry);
+	path.mnt = fhp->fh_export->ex_path.mnt;
+	path.dentry = fhp->fh_dentry;
+	inode = d_inode(path.dentry);
 	*lenp = 0;
 
 	inode_lock_shared(inode);
 
-	len = vfs_listxattr(dentry, NULL, 0);
+	len = vfs_listxattr(&path, NULL, 0);
 	if (len <= 0) {
 		err = nfsd_xattr_errno(len);
 		goto out;
@@ -2782,7 +2786,7 @@ nfsd_listxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char **bufp,
 		goto out;
 	}
 
-	len = vfs_listxattr(dentry, buf, len);
+	len = vfs_listxattr(&path, buf, len);
 	if (len <= 0) {
 		kvfree(buf);
 		err = nfsd_xattr_errno(len);
@@ -2813,6 +2817,7 @@ nfsd_listxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char **bufp,
 __be32
 nfsd_removexattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name)
 {
+	struct path path;
 	__be32 err;
 	int ret;
 
@@ -2824,16 +2829,17 @@ nfsd_removexattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name)
 	if (ret)
 		return nfserrno(ret);
 
-	inode_lock(fhp->fh_dentry->d_inode);
+	path.mnt = fhp->fh_export->ex_path.mnt;
+	path.dentry = fhp->fh_dentry;
+	inode_lock(d_inode(path.dentry));
 	err = fh_fill_pre_attrs(fhp);
 	if (err != nfs_ok)
 		goto out_unlock;
-	ret = __vfs_removexattr_locked(&nop_mnt_idmap, fhp->fh_dentry,
-				       name, NULL);
+	ret = __vfs_removexattr_locked(&nop_mnt_idmap, &path, name, NULL);
 	err = nfsd_xattr_errno(ret);
 	fh_fill_post_attrs(fhp);
 out_unlock:
-	inode_unlock(fhp->fh_dentry->d_inode);
+	inode_unlock(d_inode(path.dentry));
 	fh_drop_write(fhp);
 
 	return err;
@@ -2843,6 +2849,7 @@ __be32
 nfsd_setxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 	      void *buf, u32 len, u32 flags)
 {
+	struct path path;
 	__be32 err;
 	int ret;
 
@@ -2853,16 +2860,18 @@ nfsd_setxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 	ret = fh_want_write(fhp);
 	if (ret)
 		return nfserrno(ret);
-	inode_lock(fhp->fh_dentry->d_inode);
+	path.mnt = fhp->fh_export->ex_path.mnt;
+	path.dentry = fhp->fh_dentry;
+	inode_lock(d_inode(path.dentry));
 	err = fh_fill_pre_attrs(fhp);
 	if (err != nfs_ok)
 		goto out_unlock;
-	ret = __vfs_setxattr_locked(&nop_mnt_idmap, fhp->fh_dentry,
-				    name, buf, len, flags, NULL);
+	ret = __vfs_setxattr_locked(&nop_mnt_idmap, &path, name, buf, len,
+				    flags, NULL);
 	fh_fill_post_attrs(fhp);
 	err = nfsd_xattr_errno(ret);
 out_unlock:
-	inode_unlock(fhp->fh_dentry->d_inode);
+	inode_unlock(d_inode(path.dentry));
 	fh_drop_write(fhp);
 	return err;
 }
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c147ad155b79..ac7718aa1388 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -95,7 +95,7 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct de
 	if (!old->d_inode->i_op->listxattr || !new->d_inode->i_op->listxattr)
 		return 0;
 
-	list_size = vfs_listxattr(old, NULL, 0);
+	list_size = vfs_listxattr(oldpath, NULL, 0);
 	if (list_size <= 0) {
 		if (list_size == -EOPNOTSUPP)
 			return 0;
@@ -106,7 +106,7 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct de
 	if (!buf)
 		return -ENOMEM;
 
-	list_size = vfs_listxattr(old, buf, list_size);
+	list_size = vfs_listxattr(oldpath, buf, list_size);
 	if (list_size <= 0) {
 		error = list_size;
 		goto out;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c6f67672460d..2c7beb041ef0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -301,8 +301,7 @@ static inline ssize_t ovl_do_getxattr(const struct path *path, const char *name,
 
 	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 
-	err = vfs_getxattr(mnt_idmap(path->mnt), path->dentry,
-			       name, value, size);
+	err = vfs_getxattr(mnt_idmap(path->mnt), path, name, value, size);
 	len = (value && err > 0) ? err : 0;
 
 	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
@@ -335,8 +334,13 @@ static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				  const char *name, const void *value,
 				  size_t size, int flags)
 {
+	struct path path = {
+		.mnt = ovl_upper_mnt(ofs),
+		.dentry = dentry,
+	};
+
 	/* Use vfs_setxattr(), not __vfs_setxattr(): it idmaps the security.capability rootid. */
-	int err = vfs_setxattr(ovl_upper_mnt_idmap(ofs), dentry, name,
+	int err = vfs_setxattr(ovl_upper_mnt_idmap(ofs), &path, name,
 			       value, size, flags);
 
 	pr_debug("setxattr(%pd2, \"%s\", \"%*pE\", %zu, %d) = %i\n",
@@ -354,7 +358,12 @@ static inline int ovl_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 static inline int ovl_do_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 				     const char *name)
 {
-	int err = vfs_removexattr(ovl_upper_mnt_idmap(ofs), dentry, name);
+	struct path path = {
+		.mnt = ovl_upper_mnt(ofs),
+		.dentry = dentry,
+	};
+
+	int err = vfs_removexattr(ovl_upper_mnt_idmap(ofs), &path, name);
 	pr_debug("removexattr(%pd2, \"%s\") = %i\n", dentry, name, err);
 	return err;
 }
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index acc54f6138ef..2a97a9ec642a 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -45,7 +45,8 @@ static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char
 	if (!value && !upperdentry) {
 		ovl_path_lower(dentry, &realpath);
 		with_ovl_creds(dentry->d_sb)
-			err = vfs_getxattr(mnt_idmap(realpath.mnt), realdentry, name, NULL, 0);
+			err = vfs_getxattr(mnt_idmap(realpath.mnt), &realpath,
+					   name, NULL, 0);
 		if (err < 0)
 			goto out;
 	}
@@ -86,7 +87,8 @@ static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char
 	ovl_i_path_real(inode, &realpath);
 	/* Use vfs_getxattr(), not __vfs_getxattr(): it idmaps the security.capability rootid. */
 	with_ovl_creds(dentry->d_sb)
-		return vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, name, value, size);
+		return vfs_getxattr(mnt_idmap(realpath.mnt), &realpath,
+				    name, value, size);
 }
 
 static bool ovl_can_list(struct super_block *sb, const char *s)
@@ -105,15 +107,17 @@ static bool ovl_can_list(struct super_block *sb, const char *s)
 
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	struct dentry *realdentry = ovl_dentry_real(dentry);
+	struct path realpath;
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	ssize_t res;
 	size_t len;
 	char *s;
 	size_t prefix_len, name_len;
 
+	ovl_path_real(dentry, &realpath);
+
 	with_ovl_creds(dentry->d_sb)
-		res = vfs_listxattr(realdentry, list, size);
+		res = vfs_listxattr(&realpath, list, size);
 	if (res <= 0 || size == 0)
 		return res;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4832decf6478..a36ad354b37b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3615,16 +3615,14 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 		value = (char *)&eabuf->name + eabuf->EaNameLength + 1;
 
 		if (!eabuf->EaValueLength) {
-			rc = ksmbd_vfs_casexattr_len(idmap,
-						     path->dentry,
+			rc = ksmbd_vfs_casexattr_len(idmap, path,
 						     attr_name,
 						     XATTR_USER_PREFIX_LEN +
 						     eabuf->EaNameLength, NULL);
 
 			/* delete the EA only when it exits */
 			if (rc > 0) {
-				rc = ksmbd_vfs_remove_xattr(idmap,
-							    path,
+				rc = ksmbd_vfs_remove_xattr(idmap, path,
 							    attr_name,
 							    get_write);
 
@@ -3693,8 +3691,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	fp->stream.size = xattr_stream_size;
 
 	/* Keep the existing xattr's case for subsequent writes and removal. */
-	rc = ksmbd_vfs_casexattr_len(idmap,
-				     path->dentry,
+	rc = ksmbd_vfs_casexattr_len(idmap, path,
 				     xattr_stream_name,
 				     xattr_stream_size, xattr_stream_name);
 	if (rc >= 0)
@@ -3754,7 +3751,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 static loff_t ksmbd_stream_eof(struct ksmbd_file *fp)
 {
 	ssize_t slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
-					       fp->filp->f_path.dentry,
+					       &fp->filp->f_path,
 					       fp->stream.name,
 					       fp->stream.size, NULL);
 	return slen < 0 ? 0 : (loff_t)slen;
@@ -3767,7 +3764,7 @@ static int smb2_remove_smb_xattrs(const struct path *path)
 	ssize_t xattr_list_len;
 	int err = 0;
 
-	xattr_list_len = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
+	xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (xattr_list_len < 0) {
 		goto out;
 	} else if (!xattr_list_len) {
@@ -3782,8 +3779,7 @@ static int smb2_remove_smb_xattrs(const struct path *path)
 		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
 		    !strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
 			     STREAM_PREFIX_LEN)) {
-			err = ksmbd_vfs_remove_xattr(idmap, path,
-						     name, true);
+			err = ksmbd_vfs_remove_xattr(idmap, path, name, true);
 			if (err)
 				ksmbd_debug(SMB, "remove xattr failed : %s\n",
 					    name);
@@ -3838,6 +3834,7 @@ static bool smb2_parent_compressed(struct ksmbd_tree_connect *tcon,
 				   const struct path *path)
 {
 	struct dentry *parent = dget_parent(path->dentry);
+	struct path parent_path = { .mnt = path->mnt, .dentry = parent };
 	struct file_kattr fa = { .flags_valid = true };
 	struct xattr_dos_attrib da;
 	bool compressed = false;
@@ -3849,7 +3846,8 @@ static bool smb2_parent_compressed(struct ksmbd_tree_connect *tcon,
 		goto out;
 	}
 
-	rc = ksmbd_vfs_get_dos_attrib_xattr(mnt_idmap(path->mnt), parent, &da);
+	rc = ksmbd_vfs_get_dos_attrib_xattr(mnt_idmap(path->mnt),
+					    &parent_path, &da);
 	if (rc > 0 && da.attr & FILE_ATTRIBUTE_COMPRESSED)
 		compressed = true;
 
@@ -3870,7 +3868,7 @@ static void smb2_update_xattrs(struct ksmbd_tree_connect *tcon,
 
 	/* get FileAttributes from XATTR_NAME_DOS_ATTRIBUTE */
 	rc = ksmbd_vfs_get_dos_attrib_xattr(mnt_idmap(path->mnt),
-					    path->dentry, &da);
+					    path, &da);
 	if (rc > 0) {
 		if (store_dos_attrs) {
 			fp->f_ci->m_fattr = cpu_to_le32(da.attr);
@@ -4903,7 +4901,7 @@ int smb2_open(struct ksmbd_work *work)
 			if (test_share_config_flag(tcon->share_conf,
 						   KSMBD_SHARE_FLAG_STORE_DOS_ATTRS) &&
 			    ksmbd_vfs_get_dos_attrib_xattr(mnt_idmap(path.mnt),
-							 path.dentry, &da) > 0 &&
+							   &path, &da) > 0 &&
 			    da.attr & FILE_ATTRIBUTE_READONLY) {
 				rsp->hdr.Status = STATUS_CANNOT_DELETE;
 				rc = -EACCES;
@@ -6486,13 +6484,14 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 			continue;
 		}
 
+		path.mnt = priv->dir_fp->filp->f_path.mnt;
+		path.dentry = dent;
+
 		if (test_share_config_flag(priv->work->tcon->share_conf,
 					   KSMBD_SHARE_FLAG_HIDE_UNREADABLE)) {
 			__le32 daccess = FILE_READ_DATA_LE | FILE_READ_EA_LE |
 				FILE_READ_ATTRIBUTES_LE;
 
-			path.mnt = priv->dir_fp->filp->f_path.mnt;
-			path.dentry = dent;
 			rc = smb_check_perm_dacl(priv->work->conn, &path,
 						 &daccess, daccess,
 						 priv->work->sess->user->uid,
@@ -6508,7 +6507,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 		if (priv->info_level != FILE_NAMES_INFORMATION) {
 			rc = ksmbd_vfs_fill_dentry_attrs(priv->work,
 							 idmap,
-							 dent,
+							 &path,
 							 &ksmbd_kstat);
 			if (rc) {
 				dput(dent);
@@ -7152,7 +7151,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	if (buf_free_len < 0)
 		return -EINVAL;
 
-	rc = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
+	rc = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (rc < 0) {
 		rsp->hdr.Status = STATUS_INVALID_HANDLE;
 		goto out;
@@ -7198,8 +7197,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
 				name_len + 1);
 		/* bailout if xattr can't fit in buf_free_len */
-		value_len = ksmbd_vfs_getxattr(idmap, path->dentry,
-					       name, &buf);
+		value_len = ksmbd_vfs_getxattr(idmap, path, name, &buf);
 		if (value_len <= 0) {
 			rc = -ENOENT;
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
@@ -7489,7 +7487,7 @@ static char *smb2_get_normalized_stream_name(struct ksmbd_file *fp)
 	if (!ksmbd_stream_fd(fp))
 		return NULL;
 
-	xattr_list_len = ksmbd_vfs_listxattr(fp->filp->f_path.dentry,
+	xattr_list_len = ksmbd_vfs_listxattr(&fp->filp->f_path,
 					     &xattr_list);
 	if (xattr_list_len <= 0)
 		goto out;
@@ -7657,7 +7655,7 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	if (ret)
 		return ret;
 
-	xattr_list_len = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
+	xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (xattr_list_len < 0) {
 		goto default_stream;
 	} else if (!xattr_list_len) {
@@ -7683,7 +7681,7 @@ static int get_file_stream_info(struct ksmbd_work *work,
 			goto out;
 		}
 		slen = ksmbd_vfs_xattr_len(file_mnt_idmap(fp->filp),
-					   path->dentry, stream_name);
+					   path, stream_name);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		ret = smb2_add_stream_info(&buf, stream_buf, ssize, ssize);
 		kfree(stream_buf);
@@ -8493,7 +8491,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		ppntsd_size = ksmbd_vfs_get_sd_xattr(work->conn, idmap,
-						     fp->filp->f_path.dentry,
+						     &fp->filp->f_path,
 						     &ppntsd);
 		if (ppntsd_size < 0 && !smb_no_stored_sd(ppntsd_size)) {
 			rc = ppntsd_size == -ENOMEM ? -ENOMEM : -EIO;
@@ -8860,7 +8858,7 @@ static int smb2_rename(struct ksmbd_work *work,
 			}
 
 			stream_buf_len = ksmbd_vfs_getcasexattr(file_mnt_idmap(fp->filp),
-								fp->filp->f_path.dentry,
+								&fp->filp->f_path,
 								fp->stream.name,
 								fp->stream.size,
 								&stream_buf);
@@ -9043,7 +9041,8 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	    (crtime > 0 || file_info->Attributes)) {
 		struct xattr_dos_attrib da = {0};
 
-		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, fp->filp->f_path.dentry, &da);
+		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, &fp->filp->f_path,
+						   &da);
 		if (rc <= 0) {
 			da.version = 4;
 			da.flags = 0;
@@ -11894,7 +11893,7 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
 		struct xattr_dos_attrib da = {0};
 
 		ret = ksmbd_vfs_get_dos_attrib_xattr(idmap,
-						     fp->filp->f_path.dentry, &da);
+						     &fp->filp->f_path, &da);
 		if (ret <= 0) {
 			da.version = 4;
 			da.flags = 0;
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index e7a987af64ba..a6da27a7d7cb 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -467,37 +467,82 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 {
 	int i, rc = 0;
 	struct ksmbd_conn *conn = work->conn;
-	const struct mnt_idmap *idmap = file_mnt_idmap(dir->filp);
+	const struct path *const share_root = &work->tcon->share_conf->vfs_path;
 
 	for (i = 0; i < 2; i++) {
 		struct kstat kstat;
 		struct ksmbd_kstat ksmbd_kstat;
-		struct dentry *dentry;
+		struct path path = dir->filp->f_path;
+		const struct mnt_idmap *idmap;
+		struct dentry *parent;
 
 		if (!dir->dot_dotdot[i]) { /* fill dot entry info */
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
-				dentry = dget(dir->filp->f_path.dentry);
+				path_get(&path);
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
-				dentry = dget_parent(dir->filp->f_path.dentry);
+				path_get(&path);
+				/*
+				 * A ".." entry must not walk above the
+				 * share root, so it designates the share
+				 * root itself in that case.
+				 */
+				if (!path_equal(&path, share_root)) {
+					/*
+					 * The parent of a mount root dentry
+					 * is not covered by the same mount,
+					 * so follow the mount stack up like
+					 * a ".." path walk would, to keep
+					 * the path valid.
+					 */
+					while (path.dentry == path.mnt->mnt_root &&
+					       follow_up(&path))
+						;
+					if (path.dentry == path.mnt->mnt_root) {
+						/*
+						 * The mount is detached, for
+						 * example after a lazy umount
+						 * which the open file pins
+						 * down, so the parent would
+						 * not be covered by path.mnt:
+						 * report the share root
+						 * instead, as for any other
+						 * ".." above the share root.
+						 */
+						path_put(&path);
+						path_get(share_root);
+						path = *share_root;
+					} else {
+						parent = dget_parent(path.dentry);
+						dput(path.dentry);
+						path.dentry = parent;
+					}
+				}
 			}
 
+			/*
+			 * The path may now live in an ancestor mount, so
+			 * derive the idmap from it instead of reusing the
+			 * one of the enumerated directory.
+			 */
+			idmap = mnt_idmap(path.mnt);
+
 			if (!match_pattern(d_info->name, d_info->name_len,
 					   search_pattern)) {
 				dir->dot_dotdot[i] = 1;
-				dput(dentry);
+				path_put(&path);
 				continue;
 			}
 
 			ksmbd_kstat.kstat = &kstat;
 			rc = ksmbd_vfs_fill_dentry_attrs(work,
 							 idmap,
-							 dentry,
+							 &path,
 							 &ksmbd_kstat);
-			dput(dentry);
+			path_put(&path);
 			if (rc)
 				break;
 
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c2863b9f92ba..9fcc7f412e45 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1210,6 +1210,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct smb_ntsd *parent_pntsd = NULL;
 	struct smb_sid owner_sid, group_sid;
 	struct dentry *parent;
+	struct path parent_path;
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	int inherited_flags = 0, flags = 0, i, nt_size = 0, pdacl_size;
 	int rc = 0, pntsd_type, ppntsd_size, acl_len, aces_size;
@@ -1224,8 +1225,10 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		dput(parent);
 		return -ENOENT;
 	}
-	ppntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
-					    parent, &parent_pntsd);
+	parent_path.mnt = path->mnt;
+	parent_path.dentry = parent;
+	ppntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap, &parent_path,
+					    &parent_pntsd);
 	dput(parent);
 	if (ppntsd_size <= 0)
 		return -ENOENT;
@@ -1543,8 +1546,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
-	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
-					    path->dentry, &pntsd);
+	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap, path, &pntsd);
 	if (pntsd_size <= 0 || !pntsd) {
 		if (pntsd_size < 0 && !smb_no_stored_sd(pntsd_size))
 			rc = pntsd_size == -ENOMEM ? -ENOMEM : -EACCES;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7c3edbe6cb77..445fadd66f21 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -224,13 +224,13 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 }
 
 ssize_t ksmbd_vfs_getcasexattr(const struct mnt_idmap *idmap,
-			       struct dentry *dentry, char *attr_name,
+			       const struct path *path, char *attr_name,
 			       int attr_name_len, char **attr_value)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
 
-	xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
+	xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (xattr_list_len <= 0)
 		goto out;
 
@@ -240,8 +240,7 @@ ssize_t ksmbd_vfs_getcasexattr(const struct mnt_idmap *idmap,
 		if (strncasecmp(attr_name, name, attr_name_len))
 			continue;
 
-		value_len = ksmbd_vfs_getxattr(idmap,
-					       dentry,
+		value_len = ksmbd_vfs_getxattr(idmap, path,
 					       name,
 					       attr_value);
 		if (value_len < 0)
@@ -266,7 +265,7 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 
 	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(file_mnt_idmap(fp->filp),
-				       fp->filp->f_path.dentry,
+				       &fp->filp->f_path,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
@@ -415,8 +414,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	write_end = *pos + count;
 
 	saved_cred = override_creds(fp->filp->f_cred);
-	v_len = ksmbd_vfs_getcasexattr(idmap,
-				       fp->filp->f_path.dentry,
+	v_len = ksmbd_vfs_getcasexattr(idmap, &fp->filp->f_path,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
@@ -443,8 +441,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 
 	memcpy(&stream_buf[*pos], buf, count);
 
-	err = ksmbd_vfs_setxattr(idmap,
-				 &fp->filp->f_path,
+	err = ksmbd_vfs_setxattr(idmap, &fp->filp->f_path,
 				 fp->stream.name,
 				 (void *)stream_buf,
 				 size,
@@ -485,7 +482,7 @@ int ksmbd_vfs_stream_truncate(struct ksmbd_file *fp, loff_t newsize)
 		return -EFBIG;
 
 	saved_cred = override_creds(fp->filp->f_cred);
-	v_len = ksmbd_vfs_getcasexattr(idmap, fp->filp->f_path.dentry,
+	v_len = ksmbd_vfs_getcasexattr(idmap, &fp->filp->f_path,
 				       fp->stream.name, fp->stream.size,
 				       &stream_buf);
 	if (v_len < 0) {
@@ -878,17 +875,17 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
 
 /**
  * ksmbd_vfs_listxattr() - vfs helper for smb list extended attributes
- * @dentry:	dentry of file for listing xattrs
+ * @path:	path of file for listing xattrs
  * @list:	destination buffer
  *
  * Return:	xattr list length on success, otherwise error
  */
-ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
+ssize_t ksmbd_vfs_listxattr(const struct path *path, char **list)
 {
 	ssize_t size;
 	char *vlist = NULL;
 
-	size = vfs_listxattr(dentry, NULL, 0);
+	size = vfs_listxattr(path, NULL, 0);
 	if (size <= 0)
 		return size;
 
@@ -897,7 +894,7 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
 		return -ENOMEM;
 
 	*list = vlist;
-	size = vfs_listxattr(dentry, vlist, size);
+	size = vfs_listxattr(path, vlist, size);
 	if (size < 0) {
 		ksmbd_debug(VFS, "listxattr failed\n");
 		kvfree(vlist);
@@ -908,29 +905,29 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
 }
 
 ssize_t ksmbd_vfs_xattr_len(const struct mnt_idmap *idmap,
-			    struct dentry *dentry, char *xattr_name)
+			    const struct path *path, char *xattr_name)
 {
-	return vfs_getxattr(idmap, dentry, xattr_name, NULL, 0);
+	return vfs_getxattr(idmap, path, xattr_name, NULL, 0);
 }
 
 /**
  * ksmbd_vfs_getxattr() - vfs helper for smb get extended attributes value
  * @idmap:	idmap
- * @dentry:	dentry of file for getting xattrs
+ * @path:	path of file for getting xattrs
  * @xattr_name:	name of xattr name to query
  * @xattr_buf:	destination buffer xattr value
  *
  * Return:	read xattr value length on success, otherwise error
  */
 ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
-			   struct dentry *dentry,
+			   const struct path *path,
 			   char *xattr_name, char **xattr_buf)
 {
 	ssize_t xattr_len;
 	char *buf;
 
 	*xattr_buf = NULL;
-	xattr_len = ksmbd_vfs_xattr_len(idmap, dentry, xattr_name);
+	xattr_len = ksmbd_vfs_xattr_len(idmap, path, xattr_name);
 	if (xattr_len < 0)
 		return xattr_len;
 
@@ -938,7 +935,7 @@ ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
 	if (!buf)
 		return -ENOMEM;
 
-	xattr_len = vfs_getxattr(idmap, dentry, xattr_name,
+	xattr_len = vfs_getxattr(idmap, path, xattr_name,
 				 (void *)buf, xattr_len);
 	if (xattr_len > 0)
 		*xattr_buf = buf;
@@ -972,8 +969,7 @@ int ksmbd_vfs_setxattr(const struct mnt_idmap *idmap,
 			return err;
 	}
 
-	err = vfs_setxattr(idmap,
-			   path->dentry,
+	err = vfs_setxattr(idmap, path,
 			   attr_name,
 			   attr_value,
 			   attr_size,
@@ -1264,7 +1260,7 @@ int ksmbd_vfs_remove_xattr(const struct mnt_idmap *idmap,
 			return err;
 	}
 
-	err = vfs_removexattr(idmap, path->dentry, attr_name);
+	err = vfs_removexattr(idmap, path, attr_name);
 
 	if (get_write == true)
 		mnt_drop_write(path->mnt);
@@ -1553,7 +1549,7 @@ int ksmbd_vfs_remove_acl_xattrs(const struct mnt_idmap *idmap,
 	ssize_t xattr_list_len;
 	int err = 0;
 
-	xattr_list_len = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
+	xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (xattr_list_len < 0) {
 		goto out;
 	} else if (!xattr_list_len) {
@@ -1592,7 +1588,7 @@ int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path
 	ssize_t xattr_list_len;
 	int err = 0;
 
-	xattr_list_len = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
+	xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (xattr_list_len < 0) {
 		goto out;
 	} else if (!xattr_list_len) {
@@ -1758,18 +1754,18 @@ EXPORT_SYMBOL_IF_KUNIT(ksmbd_vfs_set_sd_xattr);
 
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
-			   struct dentry *dentry,
+			   const struct path *path,
 			   struct smb_ntsd **pntsd)
 {
 	int rc;
 	struct ndr n;
-	struct inode *inode = d_inode(dentry);
+	struct inode *inode = d_inode(path->dentry);
 	struct ndr acl_ndr = {0};
 	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
-	rc = ksmbd_vfs_getxattr(idmap, dentry, XATTR_NAME_SD, &n.data);
+	rc = ksmbd_vfs_getxattr(idmap, path, XATTR_NAME_SD, &n.data);
 	if (rc <= 0)
 		return rc;
 
@@ -1861,13 +1857,13 @@ int ksmbd_vfs_set_dos_attrib_xattr(const struct mnt_idmap *idmap,
 }
 
 int ksmbd_vfs_get_dos_attrib_xattr(const struct mnt_idmap *idmap,
-				   struct dentry *dentry,
+				   const struct path *path,
 				   struct xattr_dos_attrib *da)
 {
 	struct ndr n;
 	int err;
 
-	err = ksmbd_vfs_getxattr(idmap, dentry, XATTR_NAME_DOS_ATTRIBUTE,
+	err = ksmbd_vfs_getxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (char **)&n.data);
 	if (err > 0) {
 		n.length = err;
@@ -1917,18 +1913,13 @@ void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat)
 
 int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 				const struct mnt_idmap *idmap,
-				struct dentry *dentry,
+				const struct path *path,
 				struct ksmbd_kstat *ksmbd_kstat)
 {
-	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	u64 time;
 	int rc;
-	struct path path = {
-		.mnt = share_conf->vfs_path.mnt,
-		.dentry = dentry,
-	};
 
-	rc = vfs_getattr(&path, ksmbd_kstat->kstat,
+	rc = vfs_getattr(path, ksmbd_kstat->kstat,
 			 STATX_BASIC_STATS | STATX_BTIME,
 			 AT_STATX_SYNC_AS_STAT);
 	if (rc)
@@ -1953,7 +1944,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 				   KSMBD_SHARE_FLAG_STORE_DOS_ATTRS)) {
 		struct xattr_dos_attrib da;
 
-		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
+		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, path, &da);
 		if (rc > 0) {
 			ksmbd_kstat->file_attributes = cpu_to_le32(da.attr);
 			/*
@@ -1982,7 +1973,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 		char *xattr_list = NULL, *name;
 		ssize_t xattr_list_len;
 
-		xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
+		xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 		if (xattr_list_len > 0) {
 			for (name = xattr_list;
 			     name - xattr_list < xattr_list_len;
@@ -2001,13 +1992,13 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 }
 
 ssize_t ksmbd_vfs_casexattr_len(const struct mnt_idmap *idmap,
-				struct dentry *dentry, char *attr_name,
+				const struct path *path, char *attr_name,
 				int attr_name_len, char *actual_name)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
 
-	xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
+	xattr_list_len = ksmbd_vfs_listxattr(path, &xattr_list);
 	if (xattr_list_len < 0) {
 		value_len = xattr_list_len;
 		goto out;
@@ -2023,7 +2014,7 @@ ssize_t ksmbd_vfs_casexattr_len(const struct mnt_idmap *idmap,
 		if (actual_name && strlen(name) + 1 != attr_name_len)
 			continue;
 
-		value_len = ksmbd_vfs_xattr_len(idmap, dentry, name);
+		value_len = ksmbd_vfs_xattr_len(idmap, path, name);
 		/* The caller provides attr_name_len bytes for the actual name. */
 		if (value_len >= 0 && actual_name)
 			memcpy(actual_name, name, attr_name_len);
@@ -2180,7 +2171,7 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 		saved_cred = override_creds(src_fp->filp->f_cred);
 		src_file_size = ksmbd_vfs_casexattr_len(
 				file_mnt_idmap(src_fp->filp),
-				src_fp->filp->f_path.dentry,
+				&src_fp->filp->f_path,
 				src_fp->stream.name, src_fp->stream.size, NULL);
 		revert_creds(saved_cred);
 		if (src_file_size < 0)
@@ -2504,7 +2495,8 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
 	if (fp->f_ci->m_fattr != old_fattr) {
 		struct xattr_dos_attrib da = {0};
 
-		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
+		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, &fp->filp->f_path,
+						    &da);
 		if (rc <= 0) {
 			da.version = 4;
 			da.flags = 0;
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 21b0d29a3db0..c1ea94cf153f 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -104,18 +104,18 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 			       unsigned int *chunk_count_written,
 			       unsigned int *chunk_size_written,
 			       loff_t  *total_size_written);
-ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list);
+ssize_t ksmbd_vfs_listxattr(const struct path *path, char **list);
 ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
-			   struct dentry *dentry,
+			   const struct path *path,
 			   char *xattr_name,
 			   char **xattr_buf);
 ssize_t ksmbd_vfs_xattr_len(const struct mnt_idmap *idmap,
-			    struct dentry *dentry, char *xattr_name);
+			    const struct path *path, char *xattr_name);
 ssize_t ksmbd_vfs_getcasexattr(const struct mnt_idmap *idmap,
-			       struct dentry *dentry, char *attr_name,
+			       const struct path *path, char *attr_name,
 			       int attr_name_len, char **attr_value);
 ssize_t ksmbd_vfs_casexattr_len(const struct mnt_idmap *idmap,
-				struct dentry *dentry, char *attr_name,
+				const struct path *path, char *attr_name,
 				int attr_name_len, char *actual_name);
 int ksmbd_vfs_setxattr(const struct mnt_idmap *idmap,
 		       const struct path *path, const char *attr_name,
@@ -154,7 +154,7 @@ int ksmbd_vfs_unlink(struct file *filp);
 void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat);
 int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 				const struct mnt_idmap *idmap,
-				struct dentry *dentry,
+				const struct path *path,
 				struct ksmbd_kstat *ksmbd_kstat);
 void ksmbd_vfs_posix_lock_wait(struct file_lock *flock);
 void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock);
@@ -168,14 +168,14 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   bool get_write);
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   const struct mnt_idmap *idmap,
-			   struct dentry *dentry,
+			   const struct path *path,
 			   struct smb_ntsd **pntsd);
 int ksmbd_vfs_set_dos_attrib_xattr(const struct mnt_idmap *idmap,
 				   const struct path *path,
 				   struct xattr_dos_attrib *da,
 				   bool get_write);
 int ksmbd_vfs_get_dos_attrib_xattr(const struct mnt_idmap *idmap,
-				   struct dentry *dentry,
+				   const struct path *path,
 				   struct xattr_dos_attrib *da);
 int ksmbd_vfs_set_init_posix_acl(const struct mnt_idmap *idmap,
 				 const struct path *path);
diff --git a/fs/xattr.c b/fs/xattr.c
index 0705801a62cc..33bf97c3ac7f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -286,7 +286,7 @@ int __vfs_setxattr_noperm(const struct mnt_idmap *idmap,
  * lock
  *
  *  @idmap: idmap of the mount of the target inode
- *  @dentry: object to perform setxattr on
+ *  @path: object to perform setxattr on
  *  @name: xattr name to set
  *  @value: value to set @name to
  *  @size: size of @value
@@ -295,10 +295,11 @@ int __vfs_setxattr_noperm(const struct mnt_idmap *idmap,
  *  a delegation was broken on, NULL if none.
  */
 int
-__vfs_setxattr_locked(const struct mnt_idmap *idmap, struct dentry *dentry,
+__vfs_setxattr_locked(const struct mnt_idmap *idmap, const struct path *path,
 		      const char *name, const void *value, size_t size,
 		      int flags, struct delegated_inode *delegated_inode)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -324,9 +325,10 @@ __vfs_setxattr_locked(const struct mnt_idmap *idmap, struct dentry *dentry,
 EXPORT_SYMBOL_GPL(__vfs_setxattr_locked);
 
 int
-vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
+vfs_setxattr(const struct mnt_idmap *idmap, const struct path *path,
 	     const char *name, const void *value, size_t size, int flags)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	struct delegated_inode delegated_inode = { };
 	const void  *orig_value = value;
@@ -341,7 +343,7 @@ vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 retry_deleg:
 	inode_lock(inode);
-	error = __vfs_setxattr_locked(idmap, dentry, name, value, size,
+	error = __vfs_setxattr_locked(idmap, path, name, value, size,
 				      flags, &delegated_inode);
 	inode_unlock(inode);
 
@@ -448,9 +450,10 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 EXPORT_SYMBOL(__vfs_getxattr);
 
 ssize_t
-vfs_getxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
+vfs_getxattr(const struct mnt_idmap *idmap, const struct path *path,
 	     const char *name, void *value, size_t size)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -482,12 +485,12 @@ EXPORT_SYMBOL_GPL(vfs_getxattr);
 
 /**
  * vfs_listxattr - retrieve \0 separated list of xattr names
- * @dentry: the dentry from whose inode the xattr names are retrieved
+ * @path: the path from whose inode the xattr names are retrieved
  * @list: buffer to store xattr names into
  * @size: size of the buffer
  *
  * This function returns the names of all xattrs associated with the
- * inode of @dentry.
+ * inode of @path->dentry.
  *
  * Note, for legacy reasons the vfs_listxattr() function lists POSIX
  * ACLs as well. Since POSIX ACLs are decoupled from IOP_XATTR the
@@ -503,8 +506,9 @@ EXPORT_SYMBOL_GPL(vfs_getxattr);
  *         negative error code.
  */
 ssize_t
-vfs_listxattr(struct dentry *dentry, char *list, size_t size)
+vfs_listxattr(const struct path *path, char *list, size_t size)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	ssize_t error;
 
@@ -551,16 +555,17 @@ EXPORT_SYMBOL(__vfs_removexattr);
  * lock
  *
  *  @idmap: idmap of the mount of the target inode
- *  @dentry: object to perform setxattr on
+ *  @path: object to perform removexattr on
  *  @name: name of xattr to remove
  *  @delegated_inode: on return, will contain an inode pointer that
  *  a delegation was broken on, NULL if none.
  */
 int
 __vfs_removexattr_locked(const struct mnt_idmap *idmap,
-			 struct dentry *dentry, const char *name,
+			 const struct path *path, const char *name,
 			 struct delegated_inode *delegated_inode)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -589,17 +594,17 @@ __vfs_removexattr_locked(const struct mnt_idmap *idmap,
 EXPORT_SYMBOL_GPL(__vfs_removexattr_locked);
 
 int
-vfs_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
+vfs_removexattr(const struct mnt_idmap *idmap, const struct path *path,
 		const char *name)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	struct delegated_inode delegated_inode = { };
 	int error;
 
 retry_deleg:
 	inode_lock(inode);
-	error = __vfs_removexattr_locked(idmap, dentry,
-					 name, &delegated_inode);
+	error = __vfs_removexattr_locked(idmap, path, name, &delegated_inode);
 	inode_unlock(inode);
 
 	if (is_delegated(&delegated_inode)) {
@@ -652,14 +657,14 @@ int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
 	return error;
 }
 
-static int do_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
-		struct kernel_xattr_ctx *ctx)
+static int do_setxattr(const struct mnt_idmap *idmap, const struct path *path,
+		       struct kernel_xattr_ctx *ctx)
 {
 	if (is_posix_acl_xattr(ctx->kname->name))
-		return do_set_acl(idmap, dentry, ctx->kname->name,
-				  ctx->kvalue, ctx->size);
+		return do_set_acl(idmap, path->dentry,
+				  ctx->kname->name, ctx->kvalue, ctx->size);
 
-	return vfs_setxattr(idmap, dentry, ctx->kname->name,
+	return vfs_setxattr(idmap, path, ctx->kname->name,
 			ctx->kvalue, ctx->size, ctx->flags);
 }
 
@@ -669,7 +674,7 @@ int file_setxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 
 	if (!error) {
 		audit_file(f);
-		error = do_setxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
+		error = do_setxattr(file_mnt_idmap(f), &f->f_path, ctx);
 		mnt_drop_write_file(f);
 	}
 	return error;
@@ -687,7 +692,7 @@ int filename_setxattr(int dfd, struct filename *filename,
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = do_setxattr(mnt_idmap(path.mnt), path.dentry, ctx);
+		error = do_setxattr(mnt_idmap(path.mnt), &path, ctx);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -787,8 +792,8 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
  * Extended attribute GET operations
  */
 static ssize_t
-do_getxattr(const struct mnt_idmap *idmap, struct dentry *d,
-	struct kernel_xattr_ctx *ctx)
+do_getxattr(const struct mnt_idmap *idmap, const struct path *path,
+	    struct kernel_xattr_ctx *ctx)
 {
 	ssize_t error;
 	char *kname = ctx->kname->name;
@@ -803,9 +808,10 @@ do_getxattr(const struct mnt_idmap *idmap, struct dentry *d,
 	}
 
 	if (is_posix_acl_xattr(kname))
-		error = do_get_acl(idmap, d, kname, kvalue, ctx->size);
+		error = do_get_acl(idmap, path->dentry,
+				   kname, kvalue, ctx->size);
 	else
-		error = vfs_getxattr(idmap, d, kname, kvalue, ctx->size);
+		error = vfs_getxattr(idmap, path, kname, kvalue, ctx->size);
 	if (error > 0) {
 		if (ctx->size && copy_to_user(ctx->value, kvalue, error))
 			error = -EFAULT;
@@ -822,7 +828,7 @@ do_getxattr(const struct mnt_idmap *idmap, struct dentry *d,
 ssize_t file_getxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 {
 	audit_file(f);
-	return do_getxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
+	return do_getxattr(file_mnt_idmap(f), &f->f_path, ctx);
 }
 
 ssize_t filename_getxattr(int dfd, struct filename *filename,
@@ -834,7 +840,7 @@ ssize_t filename_getxattr(int dfd, struct filename *filename,
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = do_getxattr(mnt_idmap(path.mnt), path.dentry, ctx);
+	error = do_getxattr(mnt_idmap(path.mnt), &path, ctx);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -925,7 +931,7 @@ SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
  * Extended attribute LIST operations
  */
 static ssize_t
-listxattr(struct dentry *d, char __user *list, size_t size)
+listxattr(const struct path *path, char __user *list, size_t size)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -938,7 +944,7 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(d, klist, size);
+	error = vfs_listxattr(path, klist, size);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -957,7 +963,7 @@ static
 ssize_t file_listxattr(struct file *f, char __user *list, size_t size)
 {
 	audit_file(f);
-	return listxattr(f->f_path.dentry, list, size);
+	return listxattr(&f->f_path, list, size);
 }
 
 static
@@ -971,7 +977,7 @@ ssize_t filename_listxattr(int dfd, struct filename *filename,
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = listxattr(path.dentry, list, size);
+	error = listxattr(&path, list, size);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -1029,11 +1035,12 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(const struct mnt_idmap *idmap, struct dentry *d, const char *name)
+removexattr(const struct mnt_idmap *idmap, const struct path *path,
+	    const char *name)
 {
 	if (is_posix_acl_xattr(name))
-		return vfs_remove_acl(idmap, d, name);
-	return vfs_removexattr(idmap, d, name);
+		return vfs_remove_acl(idmap, path->dentry, name);
+	return vfs_removexattr(idmap, path, name);
 }
 
 static int file_removexattr(struct file *f, struct xattr_name *kname)
@@ -1042,8 +1049,7 @@ static int file_removexattr(struct file *f, struct xattr_name *kname)
 
 	if (!error) {
 		audit_file(f);
-		error = removexattr(file_mnt_idmap(f),
-				    f->f_path.dentry, kname->name);
+		error = removexattr(file_mnt_idmap(f), &f->f_path, kname->name);
 		mnt_drop_write_file(f);
 	}
 	return error;
@@ -1061,7 +1067,7 @@ static int filename_removexattr(int dfd, struct filename *filename,
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
-		error = removexattr(mnt_idmap(path.mnt), path.dentry, kname->name);
+		error = removexattr(mnt_idmap(path.mnt), &path, kname->name);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 4cc4257de084..c39f6495fb78 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -26,6 +26,7 @@
 
 struct inode;
 struct dentry;
+struct path;
 
 static inline bool is_posix_acl_xattr(const char *name)
 {
@@ -77,22 +78,25 @@ struct xattr {
 };
 
 ssize_t __vfs_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
-ssize_t vfs_getxattr(const struct mnt_idmap *, struct dentry *, const char *,
-		     void *, size_t);
-ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
+ssize_t vfs_getxattr(const struct mnt_idmap *idmap, const struct path *path,
+		     const char *name, void *value, size_t size);
+ssize_t vfs_listxattr(const struct path *path, char *list, size_t size);
 int __vfs_setxattr(const struct mnt_idmap *, struct dentry *, struct inode *,
 		   const char *, const void *, size_t, int);
 int __vfs_setxattr_noperm(const struct mnt_idmap *, struct dentry *,
 			  const char *, const void *, size_t, int);
-int __vfs_setxattr_locked(const struct mnt_idmap *, struct dentry *,
-			  const char *, const void *, size_t, int,
-			  struct delegated_inode *);
-int vfs_setxattr(const struct mnt_idmap *, struct dentry *, const char *,
-		 const void *, size_t, int);
+int __vfs_setxattr_locked(const struct mnt_idmap *idmap,
+			  const struct path *path, const char *name,
+			  const void *value, size_t size, int flags,
+			  struct delegated_inode *delegated_inode);
+int vfs_setxattr(const struct mnt_idmap *idmap, const struct path *path,
+		 const char *name, const void *value, size_t size, int flags);
 int __vfs_removexattr(const struct mnt_idmap *, struct dentry *, const char *);
-int __vfs_removexattr_locked(const struct mnt_idmap *, struct dentry *,
-			     const char *, struct delegated_inode *);
-int vfs_removexattr(const struct mnt_idmap *, struct dentry *, const char *);
+int __vfs_removexattr_locked(const struct mnt_idmap *idmap,
+			     const struct path *path, const char *name,
+			     struct delegated_inode *delegated_inode);
+int vfs_removexattr(const struct mnt_idmap *idmap, const struct path *path,
+		    const char *name);
 
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
 int vfs_getxattr_alloc(const struct mnt_idmap *idmap,
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 5eae8723f5f9..bf2b2ca90f36 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -254,7 +254,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	size_t xattr_size = 0;
 	char *xattr_value = NULL;
 	int error;
-	int size, user_space_size;
+	int size;
 	bool ima_present = false;
 	u64 i_version = 0;
 
@@ -309,12 +309,6 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 		if (size < 0)
 			continue;
 
-		user_space_size = vfs_getxattr(&nop_mnt_idmap, dentry,
-					       xattr->name, NULL, 0);
-		if (user_space_size != size)
-			pr_debug("file %s: xattr %s size mismatch (kernel: %d, user: %d)\n",
-				 dentry->d_name.name, xattr->name, size,
-				 user_space_size);
 		xattr_size = size;
 		error = crypto_shash_update(desc, (const u8 *)xattr_value,
 					    xattr_size);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6ecb5f9657e6..d022dbffa484 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7151,8 +7151,8 @@ static int selinux_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen
 static int selinux_inode_setsecctx(const struct path *path, void *ctx,
 				   u32 ctxlen)
 {
-	return __vfs_setxattr_locked(&nop_mnt_idmap, path->dentry,
-				     XATTR_NAME_SELINUX, ctx, ctxlen, 0, NULL);
+	return __vfs_setxattr_locked(&nop_mnt_idmap, path, XATTR_NAME_SELINUX,
+				     ctx, ctxlen, 0, NULL);
 }
 
 static int selinux_inode_getsecctx(struct inode *inode, struct lsm_context *cp)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index f2c34e9ea4f8..8f3276746bfd 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4984,8 +4984,8 @@ static int smack_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 
 static int smack_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
 {
-	return __vfs_setxattr_locked(&nop_mnt_idmap, path->dentry,
-				     XATTR_NAME_SMACK, ctx, ctxlen, 0, NULL);
+	return __vfs_setxattr_locked(&nop_mnt_idmap, path, XATTR_NAME_SMACK,
+				     ctx, ctxlen, 0, NULL);
 }
 
 static int smack_inode_getsecctx(struct inode *inode, struct lsm_context *cp)
-- 
2.18.0.huawei.25

