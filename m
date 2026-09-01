Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E6625B0B8;
	Tue,  1 Sep 2026 12:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264922; cv=none; b=fm3CiyE4bOzuKiTLpCKaUc26UWl+8gjF7CkRrpOgTgKXC1MPxHTO+YyhHte3EZP9lcYUW0Y1IcAdMGLHc7bGCQ61Jf/S9UAssQ/fLzy7hJ01/pRmDAZ8HKF/nk4oQcllfz4qTRCE50gTCC9mrmlKuWN7VXvSNGCX2eLHsQV8kyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264922; c=relaxed/simple;
	bh=22ciGGmTh79ZV30X/Yq3u1EuO7i/5hSceijsCMPBET4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p70I+PQb8/htagpS1m79WUuI+DrUH0Q1i1+m0OIJ/RjjwjhwTNDF2RRAOFxkTg+/eCAICXaFkLtWy2Vtf7ritBrBRG3mA2zV/bBfDZdf217K6c8K9t5lM/QYLuJtnsOwV5v1Ll8Erog7n08oRwEYOMGq9wF2Jx7ENUN7mmzMA6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWb9zn9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWb9zn9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62D21F00A3D;
	Tue,  1 Sep 2026 12:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264920;
	bh=XZdL1l9Pcs+qzg7Hh3q+ysubBIhRHRCR1THAMONxOKM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TWb9zn9VXTc46zCwqJkqvbYwf90DqlkfPlZyqhgIVEgMX/LZmwQgG7MXJFA1U3OC9
	 pzT++b2TlOxdEoO5aE0iCHP89nx8yqdq2j/waEuTh6/r6YlAgrdAi89MKJR8gUDgYR
	 QB3rzu9Io9YtdNlhxJSOiu4kXY2DPK0aN8czmV5HCKcdHnwwd8QOsHd8M2GIlnyeKB
	 4cap+x43Sek7h72PVrVK4TrY9O9FwoeAOimNV5DA6PKng+AVXt578ImSSsAjgtRIkB
	 UQUA+U+/gK3sZusnaaQTozoY0/IkhjxzBLu7D9purDSji0JLA1jucQQlt0f7/1de8T
	 gEQKApiYIDfyw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:32 +0200
Subject: [PATCH 07/27] quota: port to const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-7-54ccd48e100b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2569; i=brauner@kernel.org;
 h=from:subject:message-id; bh=22ciGGmTh79ZV30X/Yq3u1EuO7i/5hSceijsCMPBET4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7g2xH1D48HeE8f8mw1NkpyFJsUrOe5cu8k58FyG3
 b4CjgkVHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMx1Gf4Zzsv3Izb6MPZpd0z
 umROGek+ED51P7z8aWkGl0F0XkfKJYb/ebV3FUr3dZ+oYrX8qO6SOv9g/vzo2RrSry9K/2SXVZz
 CBgA=
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
 fs/quota/dquot.c         | 2 +-
 include/linux/quotaops.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 204afc5e984b..c5e9c4e24d68 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2079,7 +2079,7 @@ EXPORT_SYMBOL(__dquot_transfer);
 /* Wrapper for transferring ownership of an inode for uid/gid only
  * Called from FSXXX_setattr()
  */
-int dquot_transfer(struct mnt_idmap *idmap, struct inode *inode,
+int dquot_transfer(const struct mnt_idmap *idmap, struct inode *inode,
 		   struct iattr *iattr)
 {
 	struct dquot *transfer_to[MAXQUOTAS] = {};
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f9c0f9d7c9d9..0c64ca674e77 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -20,7 +20,7 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
 }
 
 /* i_rwsem must being held */
-static inline bool is_quota_modification(struct mnt_idmap *idmap,
+static inline bool is_quota_modification(const struct mnt_idmap *idmap,
 					 struct inode *inode, struct iattr *ia)
 {
 	return ((ia->ia_valid & ATTR_SIZE) ||
@@ -109,7 +109,7 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid id,
 		struct qc_dqblk *di);
 
 int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
-int dquot_transfer(struct mnt_idmap *idmap, struct inode *inode,
+int dquot_transfer(const struct mnt_idmap *idmap, struct inode *inode,
 		   struct iattr *iattr);
 
 static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
@@ -229,7 +229,7 @@ static inline void dquot_free_inode(struct inode *inode)
 {
 }
 
-static inline int dquot_transfer(struct mnt_idmap *idmap,
+static inline int dquot_transfer(const struct mnt_idmap *idmap,
 				 struct inode *inode, struct iattr *iattr)
 {
 	return 0;

-- 
2.53.0

