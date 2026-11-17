Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926024;
	b=a58aY8lc+AL9KcdvHpxIHaswBeoZhRDvhDePx6ltnfSReImbtajrxKIedgVcUTKyRBqV
	 C7fK0LnieV4Gzsdee6qLHCxCq4PyIur2ixXYwW/AgU4joVkmH4vIn3yyV//HHReK9rLUw
	 Em8Z7jJgHsRdVC8RMIRVtJElvvYDL8EyYwfuaB8YzOIARRIs6fHDsoxDu2VnJHlogVwrc
	 DYGxZ6Rv854oZDJFQbcmtzAJa6N94ScxyPDH0NViAswGkoLC1+jL3TTf0UWxNsr2XmsdY
	 5gMWLZGvcni3daP++YbOVFzzdrCKNxkE4bYaiycex82KLpDmUQck6i78asOuV8P0W7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926024;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=+blmclYTHUIFVMxCJHl3f9J+YfDsKaUYylbH6PcF+3c=;
	b=bg0JhGH60cIoFCE8QlkLTwpNogQJbR0ou7WDauRfib/tMnPtSEUJufOZPenz2A9+LmGS
	 f6PQ0aWuxZSeEFAYrze/JAcKwfgrzsAzyKa/GYRDZo1O0pjXtvj5dcEhrgEbRDpAFXydK
	 BRBpHWbgvz47id4+deJ0P9XAGfQbV1uiRI9M+fjQfEBFLUHBN3zhLyDl1atkuA618ozC5
	 PAdbOn28Zffxng4INQaz3sTVOjH1RgAatMhVwGPDEiPMtzsvU8CONPVV9Vv6LapWQsqJp
	 GAOzVeqHDfs++r2UMzn9R5DOSAXZ+HYFIbMjruwB+dYr4rQ1ZVUK5MZo2Z1ylVkkXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=BDpSR8nF;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6F606A884;
	Tue, 17 Nov 2026 14:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FF6F606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=BDpSR8nF
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+blmclYTHUIFVMxCJHl3f9J+YfDsKaUYylbH6PcF+3c=;
	b=BDpSR8nFZ/CUgK/MGFT87v4f9yczPhwCoM8d6UhZQ6Nv4sWi4BfidSLwCUSx1TQQOqi3DwPiv
	X3fM8ZMMW2/Kvh2Iku0GMTOl/DfFQ5bzKNqR86jD2oCECrtjtVN56iL5DyPHU8SgKBrWI0xynPv
	FhWdxUfnlixUGXZ8mkgKs3w=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jTRyx1fXnznTZv;
	Tue, 17 Nov 2026 22:32:41 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id BB1B04057C;
	Tue, 17 Nov 2026 22:33:34 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:28 +0800
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
Subject: [PATCH -next -v4 02/17] LSM: pass struct path to the inode_setsecctx hook
Date: Tue, 17 Nov 2026 23:05:27 +0800
Message-ID: <20261117150542.1169451-3-caixinchen1@huawei.com>
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

The inode_setsecctx hook and its security_inode_setsecctx() caller in
fs/nfsd operate on a dentry even though both have a struct path
available.  Pass a const struct path so that the coming conversion of the
xattr helpers can be reflected in the implementations; for now SELinux
and Smack keep passing path->dentry and &nop_mnt_idmap to
__vfs_setxattr_locked().

Also document in lsm_hook_defs.h what a struct path argument may be used
for: it can be passed to VFS helpers taking a struct path, but nothing is
guaranteed about path->mnt.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/nfsd/vfs.c                 | 2 +-
 include/linux/lsm_hook_defs.h | 9 ++++++++-
 include/linux/security.h      | 5 +++--
 security/security.c           | 6 +++---
 security/selinux/hooks.c      | 7 ++++---
 security/smack/smack_lsm.c    | 6 +++---
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 359277716fe8..1c686b82e70a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -626,7 +626,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			break;
 	}
 	if (attr->na_seclabel && attr->na_seclabel->len)
-		attr->na_labelerr = security_inode_setsecctx(dentry,
+		attr->na_labelerr = security_inode_setsecctx(&path,
 			attr->na_seclabel->data, attr->na_seclabel->len);
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && attr->na_dpacl) {
 		if (!S_ISDIR(inode->i_mode))
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb..7d3cd5395365 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -25,6 +25,12 @@
  *   #include <linux/lsm_hook_defs.h>
  *   #undef LSM_HOOK
  * };
+ *
+ * Hooks that take a struct path argument: the VFS only sanctions passing
+ * the path to VFS helpers that take a struct path (e.g. notify_change());
+ * it makes no guarantees with regard to path->mnt, whose layout and
+ * implementation details are subject to change.  Implementations must
+ * not rely on its properties.
  */
 LSM_HOOK(int, 0, binder_set_context_mgr, const struct cred *mgr)
 LSM_HOOK(int, 0, binder_transaction, const struct cred *from,
@@ -313,7 +319,8 @@ LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
 LSM_HOOK(void, LSM_RET_VOID, release_secctx, struct lsm_context *cp)
 LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
 LSM_HOOK(int, 0, inode_notifysecctx, struct inode *inode, void *ctx, u32 ctxlen)
-LSM_HOOK(int, 0, inode_setsecctx, struct dentry *dentry, void *ctx, u32 ctxlen)
+LSM_HOOK(int, 0, inode_setsecctx, const struct path *path, void *ctx,
+	 u32 ctxlen)
 LSM_HOOK(int, -EOPNOTSUPP, inode_getsecctx, struct inode *inode,
 	 struct lsm_context *cp)
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab5470..b9cae538b6fc 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -588,7 +588,7 @@ int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(struct lsm_context *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
-int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
+int security_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, struct lsm_context *cp);
 int security_locked_down(enum lockdown_reason what);
 int lsm_fill_user_ctx(struct lsm_ctx __user *uctx, u32 *uctx_len,
@@ -1630,7 +1630,8 @@ static inline int security_inode_notifysecctx(struct inode *inode, void *ctx, u3
 {
 	return -EOPNOTSUPP;
 }
-static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+static inline int security_inode_setsecctx(const struct path *path, void *ctx,
+					   u32 ctxlen)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/security/security.c b/security/security.c
index 4727b8347fc4..7e6a8a2a2ee5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4110,7 +4110,7 @@ EXPORT_SYMBOL(security_inode_notifysecctx);
 
 /**
  * security_inode_setsecctx() - Change the security label of an inode
- * @dentry: inode
+ * @path: inode (the VFS makes no guarantees with regard to @path->mnt)
  * @ctx: secctx
  * @ctxlen: length of secctx
  *
@@ -4124,9 +4124,9 @@ EXPORT_SYMBOL(security_inode_notifysecctx);
  *
  * Return: Returns 0 on success, error on failure.
  */
-int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+int security_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
 {
-	return call_int_hook(inode_setsecctx, dentry, ctx, ctxlen);
+	return call_int_hook(inode_setsecctx, path, ctx, ctxlen);
 }
 EXPORT_SYMBOL(security_inode_setsecctx);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index da83f4111bdf..6ecb5f9657e6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7148,10 +7148,11 @@ static int selinux_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen
 /*
  *	called with inode->i_mutex locked
  */
-static int selinux_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+static int selinux_inode_setsecctx(const struct path *path, void *ctx,
+				   u32 ctxlen)
 {
-	return __vfs_setxattr_locked(&nop_mnt_idmap, dentry, XATTR_NAME_SELINUX,
-				     ctx, ctxlen, 0, NULL);
+	return __vfs_setxattr_locked(&nop_mnt_idmap, path->dentry,
+				     XATTR_NAME_SELINUX, ctx, ctxlen, 0, NULL);
 }
 
 static int selinux_inode_getsecctx(struct inode *inode, struct lsm_context *cp)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2192cdcabfe2..f2c34e9ea4f8 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4982,10 +4982,10 @@ static int smack_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 				       ctxlen, 0);
 }
 
-static int smack_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+static int smack_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
 {
-	return __vfs_setxattr_locked(&nop_mnt_idmap, dentry, XATTR_NAME_SMACK,
-				     ctx, ctxlen, 0, NULL);
+	return __vfs_setxattr_locked(&nop_mnt_idmap, path->dentry,
+				     XATTR_NAME_SMACK, ctx, ctxlen, 0, NULL);
 }
 
 static int smack_inode_getsecctx(struct inode *inode, struct lsm_context *cp)
-- 
2.18.0.huawei.25

