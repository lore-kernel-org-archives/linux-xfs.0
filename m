Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926078;
	b=Ib/sRm0u3k5sjmbrpG44WF94K+2y49KeWcx2Res8G2RDMd+87vrpD+CQtgpig1GEcYmX
	 II8nUb1LFzZSrF+rVJpuvX/nb9OLeJD87GO6JdqYEbp7jU2X9ApQz0T/1G/C+mutUbaNe
	 99HIOGzdqNEuaaUfslaJPPOfhFzMPoDFN1bO1ZTDFQBfnyaN7GdME7xYMkarmN3Y/kxMO
	 6Bwu5QTDdOQvx6/G9wnRYE2p7WapwXphzGUVpEWamyE4lCoH1KEpgCYfFOHTq9vKt23pT
	 /mvny6wrI6ZvPAxf1ndlJOYQlA36Ix8vGA+idEcQxxza8HIS9PISu0P2yX6EmdRhteA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926078;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=w86cV2bb3MyKXzy+SNkdTfjimVqq9a/C4MF1gm/02i0=;
	b=F1ZQBmchxvNWBtGOdyQ4Xu+Btq0Y4JE320OqGhMQJE/o/5s4XbHHCFAfBErQL5/NT/qp
	 uLydKa7xcusirIFoaoyR9fyNj6RtJ5ULTpMEUowlm7ybsCdNHzj4vwWg/s+UZ/QFongXT
	 SLDRrjkbWQ3k92EErWwn39brebNR7P8Nc/EDwyOUF7I3IZKBxKZa1x6GSoMfstTXJOu0l
	 N/t+5+muVMFjDm1SLq+DgkmArssNAzMx3Rf2/HOWMfdb9K/7gr6PRe3ZdCYi+IfiC27es
	 cjKnfKJOHwKidLHEnuxbnAIB8KdWBoI3SWfK1kWJvsb0bzoduONRyJeGV7kHZdKNPqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=j4sfMkzr;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8B6072D9E;
	Tue, 17 Nov 2026 14:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDC8B6072D9E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=j4sfMkzr
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=w86cV2bb3MyKXzy+SNkdTfjimVqq9a/C4MF1gm/02i0=;
	b=j4sfMkzrx0u+HCLQoLmIN3C70STbKLUiECaxltG793CBV22VLVRWn7VTN2mHPKJxij6G9+mC8
	VSgHzHBmuq+Ye3rPwS1NKHqI/TzeGD7EuEBTyNjJPM8bDiUND0DsrUchiymyRUcGHgE6bilK8Pq
	WsCCSa8UM53zv+UWn42fy3o=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jTS062h7yznTV6;
	Tue, 17 Nov 2026 22:33:42 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id DF6834055B;
	Tue, 17 Nov 2026 22:34:35 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:30 +0800
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
Subject: [PATCH -next -v4 13/17] LSM: rename inode_setsecctx to path_setsecctx
Date: Tue, 17 Nov 2026 23:05:38 +0800
Message-ID: <20261117150542.1169451-14-caixinchen1@huawei.com>
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

The inode_setsecctx hook receives a struct path, so rename it to
path_setsecctx and rename security_inode_setsecctx() and the SELinux and
Smack implementations accordingly.  The exported symbol is renamed as
well, so out-of-tree modules calling security_inode_setsecctx() have to
be updated.  Nothing under tools/ attaches to this hook.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/nfsd/vfs.c                 | 2 +-
 include/linux/lsm_hook_defs.h | 2 +-
 include/linux/security.h      | 6 +++---
 security/security.c           | 8 ++++----
 security/selinux/hooks.c      | 6 +++---
 security/smack/smack_lsm.c    | 4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 9eae731ecb26..aa75d2a60d60 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -628,7 +628,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			break;
 	}
 	if (attr->na_seclabel && attr->na_seclabel->len)
-		attr->na_labelerr = security_inode_setsecctx(&path,
+		attr->na_labelerr = security_path_setsecctx(&path,
 			attr->na_seclabel->data, attr->na_seclabel->len);
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && attr->na_dpacl) {
 		if (!S_ISDIR(inode->i_mode))
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2680972b2c50..eefe68db5b45 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -340,7 +340,7 @@ LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
 LSM_HOOK(void, LSM_RET_VOID, release_secctx, struct lsm_context *cp)
 LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
 LSM_HOOK(int, 0, inode_notifysecctx, struct inode *inode, void *ctx, u32 ctxlen)
-LSM_HOOK(int, 0, inode_setsecctx, const struct path *path, void *ctx,
+LSM_HOOK(int, 0, path_setsecctx, const struct path *path, void *ctx,
 	 u32 ctxlen)
 LSM_HOOK(int, -EOPNOTSUPP, inode_getsecctx, struct inode *inode,
 	 struct lsm_context *cp)
diff --git a/include/linux/security.h b/include/linux/security.h
index e625564ada1f..ddd9e1561084 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -597,7 +597,7 @@ int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(struct lsm_context *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
-int security_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen);
+int security_path_setsecctx(const struct path *path, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, struct lsm_context *cp);
 int security_locked_down(enum lockdown_reason what);
 int lsm_fill_user_ctx(struct lsm_ctx __user *uctx, u32 *uctx_len,
@@ -1650,8 +1650,8 @@ static inline int security_inode_notifysecctx(struct inode *inode, void *ctx, u3
 {
 	return -EOPNOTSUPP;
 }
-static inline int security_inode_setsecctx(const struct path *path, void *ctx,
-					   u32 ctxlen)
+static inline int security_path_setsecctx(const struct path *path, void *ctx,
+					  u32 ctxlen)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/security/security.c b/security/security.c
index 314c7736f0dd..d892a26f382f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4140,7 +4140,7 @@ int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 EXPORT_SYMBOL(security_inode_notifysecctx);
 
 /**
- * security_inode_setsecctx() - Change the security label of an inode
+ * security_path_setsecctx() - Change the security label of an inode
  * @path: inode (the VFS makes no guarantees with regard to @path->mnt)
  * @ctx: secctx
  * @ctxlen: length of secctx
@@ -4155,11 +4155,11 @@ EXPORT_SYMBOL(security_inode_notifysecctx);
  *
  * Return: Returns 0 on success, error on failure.
  */
-int security_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
+int security_path_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
 {
-	return call_int_hook(inode_setsecctx, path, ctx, ctxlen);
+	return call_int_hook(path_setsecctx, path, ctx, ctxlen);
 }
-EXPORT_SYMBOL(security_inode_setsecctx);
+EXPORT_SYMBOL(security_path_setsecctx);
 
 /**
  * security_inode_getsecctx() - Get the security label of an inode
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 02fa9bbf7ea3..b7d90a78c686 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7162,8 +7162,8 @@ static int selinux_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen
 /*
  *	called with inode->i_mutex locked
  */
-static int selinux_inode_setsecctx(const struct path *path, void *ctx,
-				   u32 ctxlen)
+static int selinux_path_setsecctx(const struct path *path, void *ctx,
+				  u32 ctxlen)
 {
 	return __vfs_setxattr_locked(&nop_mnt_idmap, path, XATTR_NAME_SELINUX,
 				     ctx, ctxlen, 0, NULL, NULL);
@@ -7837,7 +7837,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(release_secctx, selinux_release_secctx),
 	LSM_HOOK_INIT(inode_invalidate_secctx, selinux_inode_invalidate_secctx),
 	LSM_HOOK_INIT(inode_notifysecctx, selinux_inode_notifysecctx),
-	LSM_HOOK_INIT(inode_setsecctx, selinux_inode_setsecctx),
+	LSM_HOOK_INIT(path_setsecctx, selinux_path_setsecctx),
 
 	LSM_HOOK_INIT(unix_stream_connect, selinux_socket_unix_stream_connect),
 	LSM_HOOK_INIT(unix_may_send, selinux_socket_unix_may_send),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index f301757ab2b7..d4364e9eb1f1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -5006,7 +5006,7 @@ static int smack_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 				       ctxlen, 0);
 }
 
-static int smack_inode_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
+static int smack_path_setsecctx(const struct path *path, void *ctx, u32 ctxlen)
 {
 	return __vfs_setxattr_locked(&nop_mnt_idmap, path, XATTR_NAME_SMACK,
 				     ctx, ctxlen, 0, NULL, NULL);
@@ -5331,7 +5331,7 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(lsmprop_to_secctx, smack_lsmprop_to_secctx),
 	LSM_HOOK_INIT(secctx_to_secid, smack_secctx_to_secid),
 	LSM_HOOK_INIT(inode_notifysecctx, smack_inode_notifysecctx),
-	LSM_HOOK_INIT(inode_setsecctx, smack_inode_setsecctx),
+	LSM_HOOK_INIT(path_setsecctx, smack_path_setsecctx),
 	LSM_HOOK_INIT(inode_getsecctx, smack_inode_getsecctx),
 	LSM_HOOK_INIT(inode_copy_up, smack_inode_copy_up),
 	LSM_HOOK_INIT(inode_copy_up_xattr, smack_inode_copy_up_xattr),
-- 
2.18.0.huawei.25

