Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3AD3A9623;
	Tue, 29 Sep 2026 03:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653356; cv=none; b=CeNsGFhdMHS+cS5VA8YRfA6u31hvAuLXr+y8ndvE8PJnvJGM0y+mDRFY5qNbhE29714g8rXFOSdyUug7Ihv17E/qvWy1w8QsBCvAqrh5dYjxlvwk3ZxdXr7jzzLD9FIZmjaSrD5Swipw/PgGeEMK2wLT+44W7+2tQL/StlMuFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653356; c=relaxed/simple;
	bh=VL1mZGItNTQFYzurZBNU8TOJl53lt8Q+X4IW7EDHrW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k143dvY/J7fuSD55NkLRwiqyagPktmqMTqd604fx5dERUXMWF7raG2hO7KK0U87CNxxI/shTazPZbKqSPR11U7NZrZAOX0iijTb6pjcJzFDj3F+bkRQiw4q1iQHS0sjz7RN/sH2ADWIYyVpEunYhLY7kMrNYgHIlRG4gPR9d2ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=HjgS3nrM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eymtJ0Uo; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="HjgS3nrM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eymtJ0Uo"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 9BF541301926;
	Mon, 28 Sep 2026 23:42:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 28 Sep 2026 23:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653353;
	 x=1790660553; bh=Ko7smLl38TalV0JxBFSwlCxeGfsIoFjf2IsmcaWJJwg=; b=
	HjgS3nrMiXsrvSMsF2TZ3jufSGtO//oHA7IJGSy7o0nYFaiS/iJpEjWh85X/tD4r
	G1VjEce8L+wxkboqcvNZCQUnxTcTACJioSFtqjt4i07agBKQxRIuUdptA5rvlhgw
	59v5NdZQUuwjAqacXANguXNOH8dOgfWKw5CSkpDOs2htIXwBYdiFMcD8nK8JNHh9
	n//rB9oPJ/npAGaUsSnKGe1K70EFsu1s/FeN3XWGLUW5Sd57WGqpfUnq1vjlh8vz
	FDf6fGOmnioXK2YX/0BtLW0LLAZTj4VB4ocqQAin+eBdrruG4N9TSWfptp6MkCHz
	mHrE8H0Fbp2QC6YAsTH6Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653353; x=1790660553; bh=K
	o7smLl38TalV0JxBFSwlCxeGfsIoFjf2IsmcaWJJwg=; b=eymtJ0UofPj03sS8M
	auZDGVsk1peTaPNc9x9QkIa/rGudgsBAH2A4xvqefI73ZeE7yGz5fLubZCxvAUjD
	/3KHx+P727yBaVGM/wKmrZukauqzN/jwV7KY18abYjWigDCbl5PCCtzHLFVY303g
	lHj5XWkE7tfhVkk+QObmEfmXDIMpoWxBK9b+FeZhJbtAus0yJ2xCGmci/GWo52+R
	lAYfkyEYuk6asX+2gU9N5PZv5AV3ESLaky6q2Iictcl67PHvED7Bze0F8EZoCjM8
	M8c+je84DJjkolHMNFeffFz8he/osovS6D4b17AyHnQotuJCZAtV2MFNe4YNxYPm
	PGYzg==
X-ME-Sender: <xms:qDO7alDd4Z9_HZBY-RFwhwTzSkgjcVd45AMSPer-MLEOHsr3GbiW9g>
    <xme:qDO7amc5wnVKkX4K-VT41G-3CKfVVcq4vbsM6Lh8tBiJWcxl9OpsZsM5cKE_wtYyM
    yBYFCJl9E7PVpI9tf8eRgx8RZ-kE3T4o7v8ZT6tFn6jmDd9YQ>
X-ME-Received: <xmr:qDO7aoxPAT3Tea6sjs9NKd4Zk9j1tbC6oYwVi_vp4YwBITffD7OJ3-_HXpPlg453ae9h6t9xAY8taQXQNWo5RfosqN6QJ68>
X-ME-Proxy-Cause: dmFkZTGoJB+17Zq7ThrEPjmxn4ZGYu519RzWwVi/88aejzKjstMboztaed73ef7D6avpE+
    +4ud1a3y7i3orjwLfnXoctNyz4isc8MlqqkCj9w/LgYTxltRiENCW6GCIqrBIGfd6BoOtn
    3U4T9DnMQq0t334tHmkLT0tBGbfhvTaaBwaOBKtxwtl6WpY46qwankbHLMumQlIvXZxJZX
    MK4M+NdZABlSsm1lFGpu8Zoavf0+po6/QQ3FmqOSdXOPNwreWLw4U6EONlQdAFPuoTNGlS
    rFYPmLdcGE1rV4M0fAMpJKofG+st3+8PfQ+b7I9sMwGW86B3jq8HWH1QNmIbUmtd6GqsW0
    GrpwERPZoLtr60nxhqf8AT2qnOvpyBy9oK2fpCvpB0loJqnKocn/foO7O0jbwhULrHY1vk
    Mmc0aWViTPsBWvo7uxuf3qD5O+F9V8VLR9r4BHRyLXb4Iors87d7BzIRDyc33ICHXSyrUP
    fn4t7y/xx0L9PUn4ktZKheR1rZyYB5z8kO0g2a49xRK/K8lM5pAaV3RBIJ19tQaNCH85vK
    KU9e1lMF5weAsTSY5thxFUqoT/Gmutqe+7cQBMSuDLkcNATTrouyh7EUha7ei3KS5tHpxt
    DLgCMNmkUI5xMEZuEL96pqSzqUMMQzeEMc94Cz7/bjLDl9qncDDWqCFU+oiw
X-ME-Proxy: <xmx:qDO7aulKEIGdUR6cFV-gn0FwsCBCQ02veR3Db8LT0X7DXV2WYRG9-Q>
    <xmx:qDO7apCY3NCxwKUFRIzWJldo3xTBfZorkLK-wWt9bNfGlyGtPHVkHg>
    <xmx:qDO7ajdr6xzTG-yLC3tx6m0umyKZMRW1rjRG4xtin1Jf5lpq7rFiog>
    <xmx:qDO7anot1fgsGNLophvSAwAV3d6rjF08uDQjzSa566-yAon3cxxzAA>
    <xmx:qTO7an7Ncp35JQjRUz4e3vf4R2oQKzNA9KMKz1vUhcgj_KHLk4d10cFs>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:25 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel() in d_add_ci()
Date: Tue, 29 Sep 2026 13:36:01 +1000
Message-ID: <20260929034158.1455429-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

A proposed change will invert the lock ordering between
d_alloc_parallel() and inode_lock() on the parent.
When that happens it will not be safe to call d_alloc_parallel() while
holding the parent lock - even shared.

We don't need to keep the parent lock held when d_add_ci() is run - the
VFS doesn't need it as dentry is exclusively held due to
DCACHE_PAR_LOOKUP and the filesystem has finished its work.

So drop and reclaim the lock (shared or exclusive as determined by
LOOKUP_SHARED) to avoid future deadlock.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/porting.rst |  7 ++++++
 fs/dcache.c                           | 32 +++++++++++++++++++++++----
 fs/ntfs/namei.c                       |  2 +-
 fs/xfs/xfs_iops.c                     |  2 +-
 include/linux/dcache.h                |  3 ++-
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 4e015f1bf1f8..f6a38bd9c68e 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1409,3 +1409,10 @@ use only if you have no alternative.
 The .create inode_operation no longer receives the 'excl' arg.  It must
 always assume the file does not already exist.  If the filesystem needs
 to be involved in non-exclusive create, it should provide atomic_open.
+
+---
+
+**mandatory**
+
+d_add_ci() must now be passed the flags arguemnt that was given to ->lookup
+
diff --git a/fs/dcache.c b/fs/dcache.c
index 83790c7a4dee..61e0896dc077 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2383,6 +2383,7 @@ EXPORT_SYMBOL(d_obtain_root);
  * @dentry: the negative dentry that was passed to the parent's lookup func
  * @inode:  the inode case-insensitive lookup has found
  * @name:   the case-exact name to be associated with the returned dentry
+ * @lookup_flags: flags passed to ->lookup
  *
  * This is to avoid filling the dcache with case-insensitive names to the
  * same inode, only the actual correct case is stored in the dcache for
@@ -2395,9 +2396,10 @@ EXPORT_SYMBOL(d_obtain_root);
  * the exact case, and return the spliced entry.
  */
 struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
-			struct qstr *name)
+			struct qstr *name, unsigned int lookup_flags)
 {
 	struct dentry *found, *res;
+	bool must_unlock = false;
 
 	/*
 	 * First check if a dentry matching the name already exists,
@@ -2409,24 +2411,46 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 		return found;
 	}
 	if (d_in_lookup(dentry)) {
+		/*
+		 * We are holding parent lock and so don't want to wait
+		 * for a d_in_lookup() dentry.  We can safely drop the
+		 * parent lock and reclaim it as we have exclusive
+		 * access to dentry as it is d_in_lookup() (so
+		 * ->d_parent is stable) and we are near the end
+		 * ->lookup() and will shortly drop the lock anyway.
+		 * We cannot retake the lock while the new dentry is in-lookup
+		 */
+		if (lookup_flags & LOOKUP_SHARED)
+			inode_unlock_shared(d_inode(dentry->d_parent));
+		else
+			inode_unlock(d_inode(dentry->d_parent));
+		must_unlock = true;
 		found = d_alloc_parallel(dentry->d_parent, name);
 		if (IS_ERR(found) || !d_in_lookup(found)) {
 			iput(inode);
-			return found;
+			goto out_unlock;
 		}
 	} else {
 		found = d_alloc(dentry->d_parent, name);
 		if (!found) {
 			iput(inode);
 			return ERR_PTR(-ENOMEM);
-		} 
+		}
 	}
 	res = d_splice_alias(inode, found);
 	if (res) {
 		d_lookup_done(found);
 		dput(found);
-		return res;
+		found = res;
 	}
+	if (!must_unlock)
+		return found;
+out_unlock:
+	d_lookup_done(dentry);
+	if (lookup_flags & LOOKUP_SHARED)
+		inode_lock_shared(d_inode(dentry->d_parent));
+	else
+		inode_lock_nested(d_inode(dentry->d_parent), I_MUTEX_PARENT);
 	return found;
 }
 EXPORT_SYMBOL(d_add_ci);
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 7091b2496fac..61cfa4e16586 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -309,7 +309,7 @@ static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent,
 		}
 		nls_name.hash = full_name_hash(dent, nls_name.name, nls_name.len);
 
-		dent = d_add_ci(dent, dent_inode, &nls_name);
+		dent = d_add_ci(dent, dent_inode, &nls_name, flags);
 		kfree(nls_name.name);
 		return dent;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4a3299abf774..fd480c0e4147 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -368,7 +368,7 @@ xfs_vn_ci_lookup(
 	/* else case-insensitive match... */
 	dname.name = ci_name.name;
 	dname.len = ci_name.len;
-	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
+	dentry = d_add_ci(dentry, VFS_I(ip), &dname, flags);
 	kfree(ci_name.name);
 	return dentry;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index adf239f8205f..97d11f5e6a7b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -267,7 +267,8 @@ struct dentry *d_duplicate(struct dentry *dentry);
 /* weird procfs mess; *NOT* exported */
 extern struct dentry * d_splice_alias_ops(struct inode *, struct dentry *,
 					  const struct dentry_operations *);
-extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
+extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *,
+				unsigned int);
 extern bool d_same_name(const struct dentry *dentry, const struct dentry *parent,
 			const struct qstr *name);
 extern struct dentry *d_find_any_alias(struct inode *inode);

base-commit: 3879f51857325da9bf3cfb073280257cd16ae067
-- 
2.50.0.107.gf914562f5916.dirty

