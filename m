Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F2A3CB571;
	Tue,  1 Sep 2026 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264896; cv=none; b=NxrkmrUV3W1cdAKfLiDMoUTKQbMDP5Tj8Pt4XQ+Yd+Wkzky9v62iwyTaGOcrj4S4XJJnhW54Rj0uiwpqPA+/UswD3ywSjBFixOflC5c5z2d5W16SRoq1vUP/LgqGm5EPUxJPpJNu9mKqGcMjWwpyPSK8ZkXjZTKjq28kpO/WwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264896; c=relaxed/simple;
	bh=08x7hroKIYBmObZ2Bf8EB5sIHd0iFi8poN0S2CBZXdU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W23zgEK9FBq9V+YlRiXaHcLkK/0R/AmexYo2fYA4+rMw0bRMXSyuzGDFG6HahCURrIgk26Rf8BcOGxzXXVhVANIlPQLywcnLx3+Z5gfHhUkNWtnCDiw/HeSOBnhCiCyUfG6t2Qt4PfdhVmmMf/CY0MnnJHLrus88MNl2+rqxWLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGGzIjYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGGzIjYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8251F00ADE;
	Tue,  1 Sep 2026 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264895;
	bh=h5HjOyk7VtVtqKkwccIr/x56ANjAfMMet1jYIbWNaxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DGGzIjYeSJiyg/5tQwmWHsHfwVzActJ19+009sfu0wiH+6auiGQ3plE3/Kf76Rmpj
	 zgmK4nBbu99EUhliBqDnHlpeVJwO2eXFpXXe4cxVJ+Y7fJn1LFDDuh03dnnAXoy1yc
	 xv7iAWt0wQKFyub3YAeWO/0vkpr7Usk+vlu8ccwpQsgrThotMwN2IRCjYM+sX7YIfD
	 NSNiB2eyQDkHYca3fMM5a9zYvv93MrXvaIBxN2iEGRifhWs/en8QT3pGx2pJQlEkLs
	 i2dhCHlNcDmghz+evolYdbpQFx4wEBSOSEqif8hnqD8v6DW0GeJ+tjrZTb10VdhPjP
	 Pv0+E9IW0bb7A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:27 +0200
Subject: [PATCH 02/27] fs: port mnt_idmap_{get,put}() to const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-2-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3586; i=brauner@kernel.org;
 h=from:subject:message-id; bh=08x7hroKIYBmObZ2Bf8EB5sIHd0iFi8poN0S2CBZXdU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7jm+qq7Apx1goYrbTYqLz8va6dek/n8ev7cs9rRn
 bPjX5+r7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI+yCG/74HH/9Q47xTelpx
 8+uiFzfefGjqfRfIqbCRTSFtxdxfKz4x/NOOYQ4zkO6Qcev6Lm8ed1FjP1v2pFmfDzv+ff2+aOq
 ddm4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

struct mnt_idmap is immutable once alloc_mnt_idmap() has set it up. The
only thing that changes afterwards is the reference count. Model
mnt_idmap_{get,put}() after struct cred's reference count handling and
take a const pointer.

This model is forced upon us because ceph stores the idmapping in mds
requests and need to be able to take and put references.

mnt_idmap_get() keeps returning a non-const pointer for now because
struct vfsmount still stores a non-const pointer. We can only change
that at the end of the series once every user of mnt_idmap() has been
ported.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/internal.h                 |  4 ++--
 fs/mnt_idmapping.c            | 16 ++++++++++------
 include/linux/mnt_idmapping.h |  4 ++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index c658c8a5ebd5..581aaa2d6510 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -327,8 +327,8 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
  * fs/attr.c
  */
 struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
-struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
-void mnt_idmap_put(struct mnt_idmap *idmap);
+struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
+void mnt_idmap_put(const struct mnt_idmap *idmap);
 struct stashed_operations {
 	struct dentry *(*stash_dentry)(struct dentry **stashed,
 				       struct dentry *dentry);
diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index cb61fbdb52e9..cc6c5f1cfba8 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -312,12 +312,14 @@ struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns)
  *
  * Return: @idmap with reference count bumped if @not_mnt_idmap isn't passed.
  */
-struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap)
+struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap)
 {
+	struct mnt_idmap *nonconst_idmap = (struct mnt_idmap *)idmap;
+
 	if (idmap != &nop_mnt_idmap && idmap != &invalid_mnt_idmap)
-		refcount_inc(&idmap->count);
+		refcount_inc(&nonconst_idmap->count);
 
-	return idmap;
+	return nonconst_idmap;
 }
 EXPORT_SYMBOL_GPL(mnt_idmap_get);
 
@@ -328,11 +330,13 @@ EXPORT_SYMBOL_GPL(mnt_idmap_get);
  * If this is a non-initial idmapping, put the reference count when a mount is
  * released and free it if we're the last user.
  */
-void mnt_idmap_put(struct mnt_idmap *idmap)
+void mnt_idmap_put(const struct mnt_idmap *idmap)
 {
+	struct mnt_idmap *nonconst_idmap = (struct mnt_idmap *)idmap;
+
 	if (idmap != &nop_mnt_idmap && idmap != &invalid_mnt_idmap &&
-	    refcount_dec_and_test(&idmap->count))
-		free_mnt_idmap(idmap);
+	    refcount_dec_and_test(&nonconst_idmap->count))
+		free_mnt_idmap(nonconst_idmap);
 }
 EXPORT_SYMBOL_GPL(mnt_idmap_put);
 
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index e71a6070a8f8..e5bee8b41094 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -121,8 +121,8 @@ static inline bool vfsgid_eq_kgid(vfsgid_t vfsgid, kgid_t kgid)
 
 int vfsgid_in_group_p(vfsgid_t vfsgid);
 
-struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
-void mnt_idmap_put(struct mnt_idmap *idmap);
+struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
+void mnt_idmap_put(const struct mnt_idmap *idmap);
 
 vfsuid_t make_vfsuid(struct mnt_idmap *idmap,
 		     struct user_namespace *fs_userns, kuid_t kuid);

-- 
2.53.0

