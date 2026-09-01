Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7A25B0B8;
	Tue,  1 Sep 2026 12:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264917; cv=none; b=t8xgXv7MJ5EmB5cO2xeUfNhlOqr3aGb01OtEwSKC3H3JOoIErDcQy7zaMFbnTXbEN5HpUc7HVR9cZiEk+CjlkiCq5l9zmHbZJZ8bbFkNqXucd5U9G5LRLm3JplJO8/lvKUzPzpisYqtQsQ2XwkP8W0pQvGkXNkXyuOUlJVySqx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264917; c=relaxed/simple;
	bh=ekRUNz6fUssQKy34PLN/6ADQNhaJiQQyWBgUfeA4rdU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SMb6RPJRtX2TrWZJxHwsawdM4y4yUZErvn3STrWhHl4SzBZlHIONq6pTVwkMDE82AEUu9GhU595ONRE4Ue4eqGzOTvMeXo87t8SvEfWnvxoM6c8W06OFNgV7/3TOOYAj29yyCAuGhAzr7IL34HcKJG5taAmeLCuWefMEKZUqpxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buxKS7jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buxKS7jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051731F000E9;
	Tue,  1 Sep 2026 12:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264915;
	bh=KiPUtC1W5NfCMZbR2J78bKyG9dSiT7BiTaI90d/HO3Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=buxKS7jcuOsxj/b71NknCPUNR/ikfU01YSlDdruFpQmyO3y/SWhe58i7PnWg2GS0u
	 kc8VjtHp9eWI5Pl/CCAinl1Js5/+Tdbd3YDp89Jwi+nQdhI5qPmKv9HXqgRraPzZWM
	 cGSiCS7f62wiYc22HGxhO2IN0YIjMiyDzp0FTCdbqzAoN8Liprx8ow7d9rVkvESYvn
	 3fxHs+YK8PYcEtlPqpNBjTHH2n9M79Fft9B0A9eEe3bm8rVgZJSez2adA7wxiugU9M
	 qtMORep/6LEOT+Iah9+2lST5k6L9PZiWM3kTeV6n371h4HVOO1XiFpakxlDf7v5Ble
	 LcA4pDvEz6DVw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:31 +0200
Subject: [PATCH 06/27] fs: port i_{g,u}id_{needs_}update() to const
 mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-6-54ccd48e100b@kernel.org>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org, 
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3134; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ekRUNz6fUssQKy34PLN/6ADQNhaJiQQyWBgUfeA4rdU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7hm/QkVBuEXvkvOpRkWfNRZqGKaxbqZ/Uejkfkk3
 iCe7y4ZHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5eJ7hn7IhW73lKw+vAlPl
 ui3/fF0Fdyk3z/6gVigUGVL7erPWT4Z/1lJ/OuaKf3j2adJGQ+byhDVrFT7uazv/+da5xb7Xd5p
 l8gMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Convert to const struct mnt_idmap.

A mount's idmapping is immutable. The only thing that is allowed to be
modified afterwards is the reference count and that is hidden behind
mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
from the idmapping. This is the same model that struct cred uses and the
idmapping is also rather sensitive.

So make the idmap argument const wherever we can. The conversion is done
from the bottom up so callers can continue to pass a non-const pointer
to a const parameter until the conversion is finished.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/fs.h                | 8 ++++----
 security/integrity/evm/evm_main.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cec5de83d882..154f2c976a0a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1456,7 +1456,7 @@ static inline vfsuid_t i_uid_into_vfsuid(const struct mnt_idmap *idmap,
  *
  * Return: true if @inode's i_uid field needs to be updated, false if not.
  */
-static inline bool i_uid_needs_update(struct mnt_idmap *idmap,
+static inline bool i_uid_needs_update(const struct mnt_idmap *idmap,
 				      const struct iattr *attr,
 				      const struct inode *inode)
 {
@@ -1474,7 +1474,7 @@ static inline bool i_uid_needs_update(struct mnt_idmap *idmap,
  * Safely update @inode's i_uid field translating the vfsuid of any idmapped
  * mount into the filesystem kuid.
  */
-static inline void i_uid_update(struct mnt_idmap *idmap,
+static inline void i_uid_update(const struct mnt_idmap *idmap,
 				const struct iattr *attr,
 				struct inode *inode)
 {
@@ -1508,7 +1508,7 @@ static inline vfsgid_t i_gid_into_vfsgid(const struct mnt_idmap *idmap,
  *
  * Return: true if @inode's i_gid field needs to be updated, false if not.
  */
-static inline bool i_gid_needs_update(struct mnt_idmap *idmap,
+static inline bool i_gid_needs_update(const struct mnt_idmap *idmap,
 				      const struct iattr *attr,
 				      const struct inode *inode)
 {
@@ -1526,7 +1526,7 @@ static inline bool i_gid_needs_update(struct mnt_idmap *idmap,
  * Safely update @inode's i_gid field translating the vfsgid of any idmapped
  * mount into the filesystem kgid.
  */
-static inline void i_gid_update(struct mnt_idmap *idmap,
+static inline void i_gid_update(const struct mnt_idmap *idmap,
 				const struct iattr *attr,
 				struct inode *inode)
 {
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 66f27653cdac..06e187c9912d 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -933,7 +933,7 @@ static inline void evm_inode_post_remove_acl(struct mnt_idmap *idmap,
 	evm_inode_post_removexattr(dentry, acl_name);
 }
 
-static int evm_attr_change(struct mnt_idmap *idmap,
+static int evm_attr_change(const struct mnt_idmap *idmap,
 			   struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = d_backing_inode(dentry);

-- 
2.53.0

