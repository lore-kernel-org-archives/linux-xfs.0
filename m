Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926069;
	b=pfXdYfzPA82auAGyJtzNovuS1g3fG4GUQxdcA23TmSQg6KOK+CSYtYzFiRRjmhA4jsdE
	 IM9WqAwuXWcCE/2Mon4fLXLUeuiiqs39grNHrs2f04r+hlUoEB5kuT7olmfBqhCId4sPC
	 uiUs6w5yzJPV6+H12vOk7FM8Y+LIQxy3CMU/LmhYQownT2AxfiZegvomyGtiZDI8klIH8
	 HxuqiRJZh9QYlt5IDPFkcbaROmBNnCXObqVasuPfLr1X1ObSvNtIckdCKNxLKiyme/5S9
	 tTH6rDakUl1Qrm+TSLtxrAXa34AZmxpbYFN6UHX6fNsdtZztjogVhk6ocx5wQhHf9yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926069;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=NixolmqIXPUgS3sKynKiEvNsspQJAgk07vf7IP8ILa8=;
	b=MoHl40UtnXnP6DKY3ZcOO2hmBjm0Aj8wOwLDtcbaGeYTZKds+VsVkFRX8Q0ICG0K3OIt
	 JZbmKffyuek36V1Ir/ZbT0/NKsf125dyV+RD2Y1jn+/Tfvwk1i5vPYT8L84BP/VT/EORG
	 VwSqP6CMPxpUcoX4kEG2XfekBl3bscXCCYB5nomdQH+JWjzcy3gK1UPL2wnMVD1yGeQgs
	 NX+gEFC/uXzVSwPXAO2imofumwxQisQs0Ul0zGKyK7VYpNRJXpIRTLlmTP0zQ0cG1QbJs
	 u8w3HDADbwA8ZbRjYbNb7yLctPGNdTxOBXYinCqryVuvQ95uUINYcKWZd2lwaZ5hbsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=4wHC4MMu;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB5F6071889;
	Tue, 17 Nov 2026 14:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DB5F6071889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=4wHC4MMu
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NixolmqIXPUgS3sKynKiEvNsspQJAgk07vf7IP8ILa8=;
	b=4wHC4MMuctmN/UtRZOII8rXyfUlyBO4oQWghGN84lzNQuhg8DeBsklA3AbdNBDMfsKn4x0pKh
	YEkLeS2RaFDGL+yHOMi1e3gZcb2UmpIN3GW2w7yPXUf7PD5Gdi1qBm3By0Vr0o6zuGnOBswSTSk
	8K7kTh4cehEzoFfvt2tNoK0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jTS0Y6rMDzmV6X;
	Tue, 17 Nov 2026 22:34:05 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id D002E40586;
	Tue, 17 Nov 2026 22:34:24 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:19 +0800
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
Subject: [PATCH -next -v4 11/17] LSM: rename the inode posix acl hooks to path_*_acl hooks
Date: Tue, 17 Nov 2026 23:05:36 +0800
Message-ID: <20261117150542.1169451-12-caixinchen1@huawei.com>
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

Rename the inode_{set,get,remove}_acl hooks to path_{set,get,remove}_acl,
as they take a struct path, and rename security_inode_*_acl() and the
SELinux, Smack, EVM and IMA implementations accordingly.  The
inode_post_set_acl and inode_post_remove_acl notification hooks still
take a dentry and keep their names.

Update the BPF selftests, the strong definitions in
kernel/bpf/bpf_lsm_proto.c and the Smack audit function names.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/posix_acl.c                        |  6 ++--
 include/linux/lsm_hook_defs.h         |  6 ++--
 include/linux/security.h              | 44 ++++++++++++------------
 kernel/bpf/bpf_lsm_proto.c            | 48 +++++++++++++--------------
 security/integrity/evm/evm_main.c     | 26 +++++++--------
 security/integrity/ima/ima_appraise.c | 20 +++++------
 security/security.c                   | 32 +++++++++---------
 security/selinux/hooks.c              | 26 +++++++--------
 security/smack/smack_lsm.c            | 32 +++++++++---------
 9 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 4de0ad023df8..39a1153eecae 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -1133,7 +1133,7 @@ int vfs_set_acl(const struct mnt_idmap *idmap, const struct path *path,
 	if (error)
 		goto out_inode_unlock;
 
-	error = security_inode_set_acl(idmap, path, acl_name, kacl, file);
+	error = security_path_set_acl(idmap, path, acl_name, kacl, file);
 	if (error)
 		goto out_inode_unlock;
 
@@ -1195,7 +1195,7 @@ struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
 	 * The VFS has no restrictions on reading POSIX ACLs so calling
 	 * something like xattr_permission() isn't needed. Only LSMs get a say.
 	 */
-	error = security_inode_get_acl(idmap, path, acl_name, file);
+	error = security_path_get_acl(idmap, path, acl_name, file);
 	if (error)
 		return ERR_PTR(error);
 
@@ -1252,7 +1252,7 @@ int vfs_remove_acl(const struct mnt_idmap *idmap, const struct path *path,
 	if (error)
 		goto out_inode_unlock;
 
-	error = security_inode_remove_acl(idmap, path, acl_name, file);
+	error = security_path_remove_acl(idmap, path, acl_name, file);
 	if (error)
 		goto out_inode_unlock;
 
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 3c43ec49bee8..0db95ec9d1d1 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -184,15 +184,15 @@ LSM_HOOK(int, 0, inode_file_setattr, const struct path *path,
 	 struct file_kattr *fa, struct file *file)
 LSM_HOOK(int, 0, inode_file_getattr, const struct path *path,
 	 struct file_kattr *fa, struct file *file)
-LSM_HOOK(int, 0, inode_set_acl, const struct mnt_idmap *idmap,
+LSM_HOOK(int, 0, path_set_acl, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *acl_name,
 	 struct posix_acl *kacl, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_set_acl, struct dentry *dentry,
 	 const char *acl_name, struct posix_acl *kacl)
-LSM_HOOK(int, 0, inode_get_acl, const struct mnt_idmap *idmap,
+LSM_HOOK(int, 0, path_get_acl, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *acl_name,
 	 struct file *file)
-LSM_HOOK(int, 0, inode_remove_acl, const struct mnt_idmap *idmap,
+LSM_HOOK(int, 0, path_remove_acl, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *acl_name,
 	 struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, const struct mnt_idmap *idmap,
diff --git a/include/linux/security.h b/include/linux/security.h
index 2784420d6c3d..3dbdfe77d9c3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -440,17 +440,17 @@ int security_path_setxattr(const struct mnt_idmap *idmap,
 			   const struct path *path, const char *name,
 			   const void *value, size_t size, int flags,
 			   struct file *file);
-int security_inode_set_acl(const struct mnt_idmap *idmap,
-			   const struct path *path, const char *acl_name,
-			   struct posix_acl *kacl, struct file *file);
+int security_path_set_acl(const struct mnt_idmap *idmap,
+			  const struct path *path, const char *acl_name,
+			  struct posix_acl *kacl, struct file *file);
 void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
 				 struct posix_acl *kacl);
-int security_inode_get_acl(const struct mnt_idmap *idmap,
-			   const struct path *path, const char *acl_name,
-			   struct file *file);
-int security_inode_remove_acl(const struct mnt_idmap *idmap,
-			      const struct path *path, const char *acl_name,
-			      struct file *file);
+int security_path_get_acl(const struct mnt_idmap *idmap,
+			  const struct path *path, const char *acl_name,
+			  struct file *file);
+int security_path_remove_acl(const struct mnt_idmap *idmap,
+			     const struct path *path, const char *acl_name,
+			     struct file *file);
 void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
 				    struct dentry *dentry,
 				    const char *acl_name);
@@ -1031,11 +1031,11 @@ static inline int security_path_setxattr(const struct mnt_idmap *idmap,
 	return cap_inode_setxattr(path, name, value, size, flags, file);
 }
 
-static inline int security_inode_set_acl(const struct mnt_idmap *idmap,
-					 const struct path *path,
-					 const char *acl_name,
-					 struct posix_acl *kacl,
-					 struct file *file)
+static inline int security_path_set_acl(const struct mnt_idmap *idmap,
+					const struct path *path,
+					const char *acl_name,
+					struct posix_acl *kacl,
+					struct file *file)
 {
 	return 0;
 }
@@ -1045,18 +1045,18 @@ static inline void security_inode_post_set_acl(struct dentry *dentry,
 					       struct posix_acl *kacl)
 { }
 
-static inline int security_inode_get_acl(const struct mnt_idmap *idmap,
-					 const struct path *path,
-					 const char *acl_name,
-					 struct file *file)
+static inline int security_path_get_acl(const struct mnt_idmap *idmap,
+					const struct path *path,
+					const char *acl_name,
+					struct file *file)
 {
 	return 0;
 }
 
-static inline int security_inode_remove_acl(const struct mnt_idmap *idmap,
-					    const struct path *path,
-					    const char *acl_name,
-					    struct file *file)
+static inline int security_path_remove_acl(const struct mnt_idmap *idmap,
+					   const struct path *path,
+					   const char *acl_name,
+					   struct file *file)
 {
 	return 0;
 }
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index c2d51e05a1db..1bc90fd53388 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -94,49 +94,49 @@ noinline int bpf_lsm_path_removexattr(const struct mnt_idmap *idmap,
 }
 
 /*
- * Strong definitions of the inode POSIX ACL BPF LSM hooks.  The file argument
+ * Strong definitions of the inode fileattr BPF LSM hooks.  The file argument
  * is only set for file descriptor-based operations and is NULL for path-based
  * and in-kernel callers, so mark it as PTR_MAYBE_NULL.
  */
-noinline int bpf_lsm_inode_set_acl(const struct mnt_idmap *idmap,
-				   const struct path *path,
-				   const char *acl_name, struct posix_acl *kacl,
-				   struct file *file__nullable)
-{
-	return 0;
-}
-
-noinline int bpf_lsm_inode_get_acl(const struct mnt_idmap *idmap,
-				   const struct path *path,
-				   const char *acl_name,
-				   struct file *file__nullable)
+noinline int bpf_lsm_inode_file_setattr(const struct path *path,
+					struct file_kattr *fa,
+					struct file *file__nullable)
 {
 	return 0;
 }
 
-noinline int bpf_lsm_inode_remove_acl(const struct mnt_idmap *idmap,
-				      const struct path *path,
-				      const char *acl_name,
-				      struct file *file__nullable)
+noinline int bpf_lsm_inode_file_getattr(const struct path *path,
+					struct file_kattr *fa,
+					struct file *file__nullable)
 {
 	return 0;
 }
 
 /*
- * Strong definitions of the inode fileattr BPF LSM hooks.  The file argument
+ * Strong definitions of the path POSIX ACL BPF LSM hooks.  The file argument
  * is only set for file descriptor-based operations and is NULL for path-based
  * and in-kernel callers, so mark it as PTR_MAYBE_NULL.
  */
-noinline int bpf_lsm_inode_file_setattr(const struct path *path,
-					struct file_kattr *fa,
-					struct file *file__nullable)
+noinline int bpf_lsm_path_set_acl(const struct mnt_idmap *idmap,
+				  const struct path *path,
+				  const char *acl_name, struct posix_acl *kacl,
+				  struct file *file__nullable)
 {
 	return 0;
 }
 
-noinline int bpf_lsm_inode_file_getattr(const struct path *path,
-					struct file_kattr *fa,
-					struct file *file__nullable)
+noinline int bpf_lsm_path_get_acl(const struct mnt_idmap *idmap,
+				  const struct path *path,
+				  const char *acl_name,
+				  struct file *file__nullable)
+{
+	return 0;
+}
+
+noinline int bpf_lsm_path_remove_acl(const struct mnt_idmap *idmap,
+				     const struct path *path,
+				     const char *acl_name,
+				     struct file *file__nullable)
 {
 	return 0;
 }
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 64119591c900..2cdf765d51dd 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -8,7 +8,7 @@
  *
  * File: evm_main.c
  *	implements evm_path_setxattr, evm_inode_post_setxattr,
- *	evm_path_removexattr, evm_verifyxattr, and evm_inode_set_acl.
+ *	evm_path_removexattr, evm_verifyxattr, and evm_path_set_acl.
  */
 
 #define pr_fmt(fmt) "EVM: "fmt
@@ -709,7 +709,7 @@ static inline int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
 #endif
 
 /**
- * evm_inode_set_acl - protect the EVM extended attribute from posix acls
+ * evm_path_set_acl - protect the EVM extended attribute from posix acls
  * @idmap: idmap of the mount
  * @path: pointer to the affected object
  * @acl_name: name of the posix acl
@@ -722,10 +722,10 @@ static inline int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
  *
  * Return: zero on success, -EPERM on failure.
  */
-static int evm_inode_set_acl(const struct mnt_idmap *idmap,
-			     const struct path *path,
-			     const char *acl_name, struct posix_acl *kacl,
-			     struct file *file)
+static int evm_path_set_acl(const struct mnt_idmap *idmap,
+			    const struct path *path,
+			    const char *acl_name, struct posix_acl *kacl,
+			    struct file *file)
 {
 	enum integrity_status evm_status;
 	struct dentry *dentry = path->dentry;
@@ -766,7 +766,7 @@ static int evm_inode_set_acl(const struct mnt_idmap *idmap,
 }
 
 /**
- * evm_inode_remove_acl - Protect the EVM extended attribute from posix acls
+ * evm_path_remove_acl - Protect the EVM extended attribute from posix acls
  * @idmap: idmap of the mount
  * @path: pointer to the affected object
  * @acl_name: name of the posix acl
@@ -778,11 +778,11 @@ static int evm_inode_set_acl(const struct mnt_idmap *idmap,
  *
  * Return: zero on success, -EPERM on failure.
  */
-static int evm_inode_remove_acl(const struct mnt_idmap *idmap,
-				const struct path *path,
-				const char *acl_name, struct file *file)
+static int evm_path_remove_acl(const struct mnt_idmap *idmap,
+			       const struct path *path,
+			       const char *acl_name, struct file *file)
 {
-	return evm_inode_set_acl(idmap, path, acl_name, NULL, file);
+	return evm_path_set_acl(idmap, path, acl_name, NULL, file);
 }
 
 static void evm_reset_status(struct inode *inode)
@@ -1237,9 +1237,9 @@ static struct security_hook_list evm_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_copy_up_xattr, evm_inode_copy_up_xattr),
 	LSM_HOOK_INIT(path_setxattr, evm_path_setxattr),
 	LSM_HOOK_INIT(inode_post_setxattr, evm_inode_post_setxattr),
-	LSM_HOOK_INIT(inode_set_acl, evm_inode_set_acl),
+	LSM_HOOK_INIT(path_set_acl, evm_path_set_acl),
 	LSM_HOOK_INIT(inode_post_set_acl, evm_inode_post_set_acl),
-	LSM_HOOK_INIT(inode_remove_acl, evm_inode_remove_acl),
+	LSM_HOOK_INIT(path_remove_acl, evm_path_remove_acl),
 	LSM_HOOK_INIT(inode_post_remove_acl, evm_inode_post_remove_acl),
 	LSM_HOOK_INIT(path_removexattr, evm_path_removexattr),
 	LSM_HOOK_INIT(inode_post_removexattr, evm_inode_post_removexattr),
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 991982c97726..bad0a597cc29 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -795,10 +795,10 @@ static int ima_path_setxattr(const struct mnt_idmap *idmap,
 	return result;
 }
 
-static int ima_inode_set_acl(const struct mnt_idmap *idmap,
-			     const struct path *path,
-			     const char *acl_name, struct posix_acl *kacl,
-			     struct file *file)
+static int ima_path_set_acl(const struct mnt_idmap *idmap,
+			    const struct path *path,
+			    const char *acl_name, struct posix_acl *kacl,
+			    struct file *file)
 {
 	if (evm_revalidate_status(acl_name))
 		ima_reset_appraise_flags(d_backing_inode(path->dentry), -1);
@@ -823,19 +823,19 @@ static int ima_path_removexattr(const struct mnt_idmap *idmap,
 	return result;
 }
 
-static int ima_inode_remove_acl(const struct mnt_idmap *idmap,
-				 const struct path *path,
-				 const char *acl_name, struct file *file)
+static int ima_path_remove_acl(const struct mnt_idmap *idmap,
+			       const struct path *path,
+			       const char *acl_name, struct file *file)
 {
-	return ima_inode_set_acl(idmap, path, acl_name, NULL, file);
+	return ima_path_set_acl(idmap, path, acl_name, NULL, file);
 }
 
 static struct security_hook_list ima_appraise_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_post_setattr, ima_inode_post_setattr),
 	LSM_HOOK_INIT(path_setxattr, ima_path_setxattr),
-	LSM_HOOK_INIT(inode_set_acl, ima_inode_set_acl),
+	LSM_HOOK_INIT(path_set_acl, ima_path_set_acl),
 	LSM_HOOK_INIT(path_removexattr, ima_path_removexattr),
-	LSM_HOOK_INIT(inode_remove_acl, ima_inode_remove_acl),
+	LSM_HOOK_INIT(path_remove_acl, ima_path_remove_acl),
 };
 
 void __init init_ima_appraise_lsm(const struct lsm_id *lsmid)
diff --git a/security/security.c b/security/security.c
index 470cff4ac24d..95d3e890e841 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1972,7 +1972,7 @@ int security_path_setxattr(const struct mnt_idmap *idmap,
 }
 
 /**
- * security_inode_set_acl() - Check if setting posix acls is allowed
+ * security_path_set_acl() - Check if setting posix acls is allowed
  * @idmap: idmap of the mount
  * @path: the object the posix acls are set on (the VFS makes no guarantees
  *        with regard to @path->mnt)
@@ -1986,14 +1986,14 @@ int security_path_setxattr(const struct mnt_idmap *idmap,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_set_acl(const struct mnt_idmap *idmap,
-			   const struct path *path, const char *acl_name,
-			   struct posix_acl *kacl, struct file *file)
+int security_path_set_acl(const struct mnt_idmap *idmap,
+			  const struct path *path, const char *acl_name,
+			  struct posix_acl *kacl, struct file *file)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_set_acl, idmap, path, acl_name, kacl,
-			       file);
+	return call_int_hook(path_set_acl, idmap, path, acl_name, kacl,
+			     file);
 }
 
 /**
@@ -2014,7 +2014,7 @@ void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
 }
 
 /**
- * security_inode_get_acl() - Check if reading posix acls is allowed
+ * security_path_get_acl() - Check if reading posix acls is allowed
  * @idmap: idmap of the mount
  * @path: the object the posix acls are retrieved from (the VFS makes no
  *        guarantees with regard to @path->mnt)
@@ -2027,17 +2027,17 @@ void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_get_acl(const struct mnt_idmap *idmap,
-			   const struct path *path, const char *acl_name,
-			   struct file *file)
+int security_path_get_acl(const struct mnt_idmap *idmap,
+			  const struct path *path, const char *acl_name,
+			  struct file *file)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_get_acl, idmap, path, acl_name, file);
+	return call_int_hook(path_get_acl, idmap, path, acl_name, file);
 }
 
 /**
- * security_inode_remove_acl() - Check if removing a posix acl is allowed
+ * security_path_remove_acl() - Check if removing a posix acl is allowed
  * @idmap: idmap of the mount
  * @path: the object the posix acl is removed from (the VFS makes no
  *        guarantees with regard to @path->mnt)
@@ -2050,13 +2050,13 @@ int security_inode_get_acl(const struct mnt_idmap *idmap,
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_remove_acl(const struct mnt_idmap *idmap,
-			      const struct path *path, const char *acl_name,
-			      struct file *file)
+int security_path_remove_acl(const struct mnt_idmap *idmap,
+			     const struct path *path, const char *acl_name,
+			     struct file *file)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_remove_acl, idmap, path, acl_name, file);
+	return call_int_hook(path_remove_acl, idmap, path, acl_name, file);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a49c97498619..e0f384bb7ca6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3478,24 +3478,24 @@ static int selinux_path_setxattr(const struct mnt_idmap *idmap,
 			    &ad);
 }
 
-static int selinux_inode_set_acl(const struct mnt_idmap *idmap,
-				 const struct path *path,
-				 const char *acl_name, struct posix_acl *kacl,
-				 struct file *file)
+static int selinux_path_set_acl(const struct mnt_idmap *idmap,
+				const struct path *path,
+				const char *acl_name, struct posix_acl *kacl,
+				struct file *file)
 {
 	return dentry_has_perm(current_cred(), path->dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_get_acl(const struct mnt_idmap *idmap,
-				 const struct path *path,
-				 const char *acl_name, struct file *file)
+static int selinux_path_get_acl(const struct mnt_idmap *idmap,
+				const struct path *path,
+				const char *acl_name, struct file *file)
 {
 	return dentry_has_perm(current_cred(), path->dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_remove_acl(const struct mnt_idmap *idmap,
-				    const struct path *path,
-				    const char *acl_name, struct file *file)
+static int selinux_path_remove_acl(const struct mnt_idmap *idmap,
+				   const struct path *path,
+				   const char *acl_name, struct file *file)
 {
 	return dentry_has_perm(current_cred(), path->dentry, FILE__SETATTR);
 }
@@ -7751,9 +7751,9 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(path_removexattr, selinux_path_removexattr),
 	LSM_HOOK_INIT(inode_file_getattr, selinux_inode_file_getattr),
 	LSM_HOOK_INIT(inode_file_setattr, selinux_inode_file_setattr),
-	LSM_HOOK_INIT(inode_set_acl, selinux_inode_set_acl),
-	LSM_HOOK_INIT(inode_get_acl, selinux_inode_get_acl),
-	LSM_HOOK_INIT(inode_remove_acl, selinux_inode_remove_acl),
+	LSM_HOOK_INIT(path_set_acl, selinux_path_set_acl),
+	LSM_HOOK_INIT(path_get_acl, selinux_path_get_acl),
+	LSM_HOOK_INIT(path_remove_acl, selinux_path_remove_acl),
 	LSM_HOOK_INIT(inode_getsecurity, selinux_inode_getsecurity),
 	LSM_HOOK_INIT(inode_setsecurity, selinux_inode_setsecurity),
 	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2e4250cc31a2..f301757ab2b7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1552,7 +1552,7 @@ static int smack_path_removexattr(const struct mnt_idmap *idmap,
 }
 
 /**
- * smack_inode_set_acl - Smack check for setting posix acls
+ * smack_path_set_acl - Smack check for setting posix acls
  * @idmap: idmap of the mnt this request came from
  * @path: the object
  * @acl_name: name of the posix acl
@@ -1561,10 +1561,10 @@ static int smack_path_removexattr(const struct mnt_idmap *idmap,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_set_acl(const struct mnt_idmap *idmap,
-			       const struct path *path,
-			       const char *acl_name, struct posix_acl *kacl,
-			       struct file *file)
+static int smack_path_set_acl(const struct mnt_idmap *idmap,
+			      const struct path *path,
+			      const char *acl_name, struct posix_acl *kacl,
+			      struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
@@ -1579,7 +1579,7 @@ static int smack_inode_set_acl(const struct mnt_idmap *idmap,
 }
 
 /**
- * smack_inode_get_acl - Smack check for getting posix acls
+ * smack_path_get_acl - Smack check for getting posix acls
  * @idmap: idmap of the mnt this request came from
  * @path: the object
  * @acl_name: name of the posix acl
@@ -1587,9 +1587,9 @@ static int smack_inode_set_acl(const struct mnt_idmap *idmap,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_get_acl(const struct mnt_idmap *idmap,
-			       const struct path *path,
-			       const char *acl_name, struct file *file)
+static int smack_path_get_acl(const struct mnt_idmap *idmap,
+			      const struct path *path,
+			      const char *acl_name, struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
@@ -1604,7 +1604,7 @@ static int smack_inode_get_acl(const struct mnt_idmap *idmap,
 }
 
 /**
- * smack_inode_remove_acl - Smack check for getting posix acls
+ * smack_path_remove_acl - Smack check for removing posix acls
  * @idmap: idmap of the mnt this request came from
  * @path: the object
  * @acl_name: name of the posix acl
@@ -1612,9 +1612,9 @@ static int smack_inode_get_acl(const struct mnt_idmap *idmap,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_remove_acl(const struct mnt_idmap *idmap,
-				  const struct path *path,
-				  const char *acl_name, struct file *file)
+static int smack_path_remove_acl(const struct mnt_idmap *idmap,
+				 const struct path *path,
+				 const char *acl_name, struct file *file)
 {
 	struct smk_audit_info ad;
 	int rc;
@@ -5213,9 +5213,9 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_post_setxattr, smack_inode_post_setxattr),
 	LSM_HOOK_INIT(path_getxattr, smack_path_getxattr),
 	LSM_HOOK_INIT(path_removexattr, smack_path_removexattr),
-	LSM_HOOK_INIT(inode_set_acl, smack_inode_set_acl),
-	LSM_HOOK_INIT(inode_get_acl, smack_inode_get_acl),
-	LSM_HOOK_INIT(inode_remove_acl, smack_inode_remove_acl),
+	LSM_HOOK_INIT(path_set_acl, smack_path_set_acl),
+	LSM_HOOK_INIT(path_get_acl, smack_path_get_acl),
+	LSM_HOOK_INIT(path_remove_acl, smack_path_remove_acl),
 	LSM_HOOK_INIT(inode_getsecurity, smack_inode_getsecurity),
 	LSM_HOOK_INIT(inode_setsecurity, smack_inode_setsecurity),
 	LSM_HOOK_INIT(inode_listsecurity, smack_inode_listsecurity),
-- 
2.18.0.huawei.25

