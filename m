Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BD046EC78;
	Tue, 21 Jul 2026 18:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659442; cv=none; b=ozyffC9OV4SC4AqvyLM8SFEBP0K5Mfor+M4g7ton76PbKCr2RUGrgdx7M0cnuWB5SjLSn08ayh26K4p1u1kwPNScjuPXmeWTycLw6YLP8r0oMtV37abJjeCdeguO0QCrpILab3us1hKyQ2DPWThR4EWvCiq+laA9IsOXEhW1mbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659442; c=relaxed/simple;
	bh=koL5JEzCiRkG/G3J5KeYw/fhC7PQNkfGJUXQmn9MaK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYXlsCVhSAvsCVHou3yol27f1jMxcRJwGHBFFDZc2yXRaYeq8VR0UmXbxWQ4vd9rWQC5tpBqTLVh4HXE5ffjVtb6U7H4Sqzm94KfDpzdLPZbgM4sb6cQfJ2/oB6I5tyt1EnQPrA2Eda8B9sP0GMCtJriYfRmIgOGMgzmfoESFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9PD9Gi5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9PD9Gi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B6C1F00A3A;
	Tue, 21 Jul 2026 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659440;
	bh=IA66KD2Om75bu0eBgUIzf65HS6s2gELQcRJU2+ySoSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9PD9Gi5vMT6p1hhlIj/h/itwE7/mT8ZOVX0NLfvqabqzhefeNTQgxihcd+drWpPw
	 g3ykeZ9fmuQXv3HzHRpCF31G2zyQEmbrzr+5HCL1jnXP0eyz4ynKhjt3dNY9ZmGwy9
	 JjzMlvFU3Cfut2m5oyd/UR0eTH6+oNJz1VQhd511VRAySM2aI9SH6aeSKu+dTqLWy6
	 z2p+JauZKZdv6XTW8UZJv5CEPhWvp0QXu1WdgvmACiEhaPcMST8Zb7GHK1r6Xvw448
	 K4iMbCwypr55YzjyOqYNvyMsbXcOrM9ZxVKnsOtRP5FkQSfVGKviaLLmEWbhw2ktqA
	 ZI87u6hb490xA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v13 02/23] fsverity: expose ensure_fsverity_info()
Date: Tue, 21 Jul 2026 20:40:39 +0200
Message-ID: <20260721184346.416657-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function will be used by XFS's scrub to force fsverity activation,
therefore, to read fsverity context.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/verity/open.c         | 22 ++++++++++++++++++++--
 include/linux/fsverity.h |  2 ++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index d0c56a7faa3b..875e8850ccba 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -347,7 +347,24 @@ int fsverity_get_descriptor(struct inode *inode,
 	return 0;
 }
 
-static int ensure_verity_info(struct inode *inode)
+/**
+ * fsverity_ensure_verity_info() - cache verity info if it's not already cached
+ * @inode: the inode for which verity info should be cached
+ *
+ * Ensure this inode has verity info attached to it, it's assumed the inode
+ * already has fsverity enabled. Read fsverity descriptor and creates verity
+ * based on that.
+ *
+ * This needs to be called at least once before any of the inode's data
+ * can be verified (and thus read at all) or the inode's fsverity digest
+ * retrieved.  fsverity_file_open() calls this already, which handles
+ * normal file accesses.  If a filesystem does any internal (i.e. not
+ * associated with a file descriptor) reads of the file's data or
+ * fsverity digest, it must call this explicitly before doing so.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_ensure_verity_info(struct inode *inode)
 {
 	struct fsverity_info *vi = fsverity_get_info(inode), *found;
 	struct fsverity_descriptor *desc;
@@ -383,12 +400,13 @@ static int ensure_verity_info(struct inode *inode)
 	kfree(desc);
 	return err;
 }
+EXPORT_SYMBOL_GPL(fsverity_ensure_verity_info);
 
 int __fsverity_file_open(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE)
 		return -EPERM;
-	return ensure_verity_info(inode);
+	return fsverity_ensure_verity_info(inode);
 }
 EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 6c467ded9751..3c3250f6f272 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -317,6 +317,8 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+int fsverity_ensure_verity_info(struct inode *inode);
+
 void fsverity_cleanup_inode(struct inode *inode);
 
 struct page *generic_read_merkle_tree_page(struct inode *inode, pgoff_t index);
-- 
2.54.0

