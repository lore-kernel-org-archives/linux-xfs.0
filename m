Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926074;
	b=nEj1ikIKVxSEqLtsce9qbHaPJ8O67UkINZixczfGE6JBRu1jpr7xBygqJ45Zv0pFvk9u
	 r1oNWh4jJty+RmxqqprkuBhQuQ2td95dvm3P5XdMF70nMbQSuAWRCP+G3gqTKkzL55jnK
	 HNckgB1e88N7kX9Y7GYu/SCJTTwEajg+tpzsQqKyx+9vwQilLyi5FTDnGkjC5WupNI6Ja
	 VHDPZ7tJm+erk3KSn4EckU7YJJ4OHgLww/z5/sRMIeobleywCj9D/cqSjU4ZLJD74R936
	 8xWTnoeDGWzhnSXgp1jyvuuDQ8Jz8Pcz933/NuSjOy74XoZ9fBcjo3OFlWgEn/EGT7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926074;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=srZoMQfI3h/KCqPWrJLDpXUMdpkk1REo9nZW8J8+H2c=;
	b=OaicMYq7tvTbsdPxbrxxuTCE/gDwkIVqTb5ZxDKlD3HaK1SMiEMbrcuOMYbz3WDYRbnG
	 IeGS3CgLZijp/Stkkv2Etdlhj3dgu+uuw0pLpwd+lNMPcLX2rrYD8YoVuSJAzJk7cXLNn
	 VXw0dGycP0efkHaXSL9fFi/ltWAg0daWBOJGoZ1oVKIqA0f8WJDAinxrWgUWO8D+nEbQ3
	 /vBEj7jmDrTJndy606toz36GTZn2pohx+w3X9lZHwU8t97b6byQ9S3tr01PaEIj9MQWGQ
	 QWTWjI2pQgjFNkcirg1y90Cx3OK17JCE1JHn41WPAC/DqlLmzNRK2MejfDT5pweisdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=jiKEIZHE;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF1606ABAF;
	Tue, 17 Nov 2026 14:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57FF1606ABAF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=jiKEIZHE
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=srZoMQfI3h/KCqPWrJLDpXUMdpkk1REo9nZW8J8+H2c=;
	b=jiKEIZHEvuM8nNFQYe9BdSzUpPs4f1Hw7NyPE8egcz2H2TtMgQSHGLWJwEic6yJA5AweTAuFe
	9+9qDfOMp24asnvUeQqa1N3e1feK44e9KSSZu26zn1sUXY7Cl76nEULgNerD/feshbNnA2NZZLx
	433K2fRqsZgwjzuPsghMwAw=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jTS056TMKzpStX;
	Tue, 17 Nov 2026 22:33:41 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 615AF40686;
	Tue, 17 Nov 2026 22:34:30 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:24 +0800
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
Subject: [PATCH -next -v4 12/17] LSM: rename the inode fileattr hooks to path_file_* hooks
Date: Tue, 17 Nov 2026 23:05:37 +0800
Message-ID: <20261117150542.1169451-13-caixinchen1@huawei.com>
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

Rename the inode_file_getattr and inode_file_setattr hooks to
path_file_getattr and path_file_setattr, as they take a struct path, and
rename security_inode_file_*() and the SELinux implementations
accordingly.

Update the BPF selftests and the strong definitions in
kernel/bpf/bpf_lsm_proto.c.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/file_attr.c                |  4 ++--
 include/linux/lsm_hook_defs.h |  4 ++--
 include/linux/security.h      | 20 ++++++++++----------
 kernel/bpf/bpf_lsm_proto.c    | 16 ++++++++--------
 security/security.c           | 16 ++++++++--------
 security/selinux/hooks.c      | 16 ++++++++--------
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 846847e64ad3..3b8eb92feade 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -129,7 +129,7 @@ int vfs_fileattr_get(const struct path *path, struct file_kattr *fa,
 	if (!inode->i_op->fileattr_get)
 		return -ENOIOCTLCMD;
 
-	error = security_inode_file_getattr(path, fa, file);
+	error = security_path_file_getattr(path, fa, file);
 	if (error)
 		return error;
 
@@ -325,7 +325,7 @@ static int do_vfs_fileattr_set(const struct path *const path,
 		err = fileattr_set_prepare(inode, &old_ma, fa);
 		if (err)
 			goto out;
-		err = security_inode_file_setattr(path, fa, file);
+		err = security_path_file_setattr(path, fa, file);
 		if (err)
 			goto out;
 		err = inode->i_op->fileattr_set(idmap, dentry, fa);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 0db95ec9d1d1..2680972b2c50 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -180,9 +180,9 @@ LSM_HOOK(int, 0, path_removexattr, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *name, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
 	 const char *name)
-LSM_HOOK(int, 0, inode_file_setattr, const struct path *path,
+LSM_HOOK(int, 0, path_file_setattr, const struct path *path,
 	 struct file_kattr *fa, struct file *file)
-LSM_HOOK(int, 0, inode_file_getattr, const struct path *path,
+LSM_HOOK(int, 0, path_file_getattr, const struct path *path,
 	 struct file_kattr *fa, struct file *file)
 LSM_HOOK(int, 0, path_set_acl, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *acl_name,
diff --git a/include/linux/security.h b/include/linux/security.h
index 3dbdfe77d9c3..e625564ada1f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -464,10 +464,10 @@ int security_path_removexattr(const struct mnt_idmap *idmap,
 			      const struct path *path, const char *name,
 			      struct file *file);
 void security_inode_post_removexattr(struct dentry *dentry, const char *name);
-int security_inode_file_setattr(const struct path *path,
-				struct file_kattr *fa, struct file *file);
-int security_inode_file_getattr(const struct path *path,
-				struct file_kattr *fa, struct file *file);
+int security_path_file_setattr(const struct path *path,
+			       struct file_kattr *fa, struct file *file);
+int security_path_file_getattr(const struct path *path,
+			       struct file_kattr *fa, struct file *file);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(const struct mnt_idmap *idmap, struct dentry *dentry);
 int security_inode_getsecurity(const struct mnt_idmap *idmap,
@@ -1094,16 +1094,16 @@ static inline void security_inode_post_removexattr(struct dentry *dentry,
 						   const char *name)
 { }
 
-static inline int security_inode_file_setattr(const struct path *path,
-					      struct file_kattr *fa,
-					      struct file *file)
+static inline int security_path_file_setattr(const struct path *path,
+					     struct file_kattr *fa,
+					     struct file *file)
 {
 	return 0;
 }
 
-static inline int security_inode_file_getattr(const struct path *path,
-					      struct file_kattr *fa,
-					      struct file *file)
+static inline int security_path_file_getattr(const struct path *path,
+					     struct file_kattr *fa,
+					     struct file *file)
 {
 	return 0;
 }
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index 1bc90fd53388..d359ca8ab3cd 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -94,20 +94,20 @@ noinline int bpf_lsm_path_removexattr(const struct mnt_idmap *idmap,
 }
 
 /*
- * Strong definitions of the inode fileattr BPF LSM hooks.  The file argument
- * is only set for file descriptor-based operations and is NULL for path-based
+ * Strong definitions of the path fileattr BPF LSM hooks.  The file argument is
+ * only set for file descriptor-based operations and is NULL for path-based
  * and in-kernel callers, so mark it as PTR_MAYBE_NULL.
  */
-noinline int bpf_lsm_inode_file_setattr(const struct path *path,
-					struct file_kattr *fa,
-					struct file *file__nullable)
+noinline int bpf_lsm_path_file_setattr(const struct path *path,
+				       struct file_kattr *fa,
+				       struct file *file__nullable)
 {
 	return 0;
 }
 
-noinline int bpf_lsm_inode_file_getattr(const struct path *path,
-					struct file_kattr *fa,
-					struct file *file__nullable)
+noinline int bpf_lsm_path_file_getattr(const struct path *path,
+				       struct file_kattr *fa,
+				       struct file *file__nullable)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 95d3e890e841..314c7736f0dd 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2189,7 +2189,7 @@ void security_inode_post_removexattr(struct dentry *dentry, const char *name)
 }
 
 /**
- * security_inode_file_setattr() - check if setting fsxattr is allowed
+ * security_path_file_setattr() - check if setting fsxattr is allowed
  * @path: file to set filesystem extended attributes on (the VFS makes no
  *        guarantees with regard to @path->mnt)
  * @fa: extended attributes to set on the inode
@@ -2200,14 +2200,14 @@ void security_inode_post_removexattr(struct dentry *dentry, const char *name)
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_file_setattr(const struct path *path,
-				struct file_kattr *fa, struct file *file)
+int security_path_file_setattr(const struct path *path,
+			       struct file_kattr *fa, struct file *file)
 {
-	return call_int_hook(inode_file_setattr, path, fa, file);
+	return call_int_hook(path_file_setattr, path, fa, file);
 }
 
 /**
- * security_inode_file_getattr() - check if retrieving fsxattr is allowed
+ * security_path_file_getattr() - check if retrieving fsxattr is allowed
  * @path: file to retrieve filesystem extended attributes from (the VFS makes no
  *        guarantees with regard to @path->mnt)
  * @fa: extended attributes to get
@@ -2218,10 +2218,10 @@ int security_inode_file_setattr(const struct path *path,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_file_getattr(const struct path *path,
-				struct file_kattr *fa, struct file *file)
+int security_path_file_getattr(const struct path *path,
+			       struct file_kattr *fa, struct file *file)
 {
-	return call_int_hook(inode_file_getattr, path, fa, file);
+	return call_int_hook(path_file_getattr, path, fa, file);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e0f384bb7ca6..02fa9bbf7ea3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3573,16 +3573,16 @@ static int selinux_path_removexattr(const struct mnt_idmap *idmap,
 	return -EACCES;
 }
 
-static int selinux_inode_file_setattr(const struct path *path,
-				      struct file_kattr *fa,
-				      struct file *file)
+static int selinux_path_file_setattr(const struct path *path,
+				     struct file_kattr *fa,
+				     struct file *file)
 {
 	return dentry_has_perm(current_cred(), path->dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_file_getattr(const struct path *path,
-				      struct file_kattr *fa,
-				      struct file *file)
+static int selinux_path_file_getattr(const struct path *path,
+				     struct file_kattr *fa,
+				     struct file *file)
 {
 	return dentry_has_perm(current_cred(), path->dentry, FILE__GETATTR);
 }
@@ -7749,8 +7749,8 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(path_getxattr, selinux_path_getxattr),
 	LSM_HOOK_INIT(path_listxattr, selinux_path_listxattr),
 	LSM_HOOK_INIT(path_removexattr, selinux_path_removexattr),
-	LSM_HOOK_INIT(inode_file_getattr, selinux_inode_file_getattr),
-	LSM_HOOK_INIT(inode_file_setattr, selinux_inode_file_setattr),
+	LSM_HOOK_INIT(path_file_getattr, selinux_path_file_getattr),
+	LSM_HOOK_INIT(path_file_setattr, selinux_path_file_setattr),
 	LSM_HOOK_INIT(path_set_acl, selinux_path_set_acl),
 	LSM_HOOK_INIT(path_get_acl, selinux_path_get_acl),
 	LSM_HOOK_INIT(path_remove_acl, selinux_path_remove_acl),
-- 
2.18.0.huawei.25

