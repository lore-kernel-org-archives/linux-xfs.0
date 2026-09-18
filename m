Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD2741A4E7;
	Fri, 18 Sep 2026 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730159; cv=none; b=XGYFYy9CMyVOltSWSZNQyutvJC/9p5y/Km4sq5rI2v2oqI9fGswdWBePP6dyxQNUEyuzhD+D2QFAeCYlLyzfYTCTbA2hYwgnq8gcrktbfBjXNcDIZXvZyWmLtGlNm9L0NM2K0TQ8rt5xU6RR86bvDYuCkAs8LbFxGNXfbDaI3cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730159; c=relaxed/simple;
	bh=t9D5Xw8hj+Uk1PVc2axoFXJ85aUK4MBkI/u0Mp4xXAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpL3nCoBjDqx0LjXkvxO2TCqYcaT8KMrLQPMyXx609bLs/PAYPhezqZRW6nPGXN22/kKik9+bk4BwN7M2uFIq1MRxmOQG0jRab3LLtG7GYIe8HgSwzY9Ajlt+/uIcZKqZkm4glZaEjlxE2U2BZLWoUE7lA2R5wfPk3GNSLqMLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnE329Qu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnE329Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568961F00898;
	Fri, 18 Sep 2026 11:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730154;
	bh=Go/Ag71QhxLYREjmSa7sE9PXLYovh2VY8xtfSqyB6bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnE329QuODUou0VFC0bXMpY2+kcfhrVxGk6Af2XeXccDG/LPEU030VcufHmnWekfI
	 /dNYzNE4CUxVJrYU1v96zz7nTSaeB3BmK6w6vtKsSvQhXHQo4/1KuQl6vuB1DXZCOA
	 tBoQUopHuHfOFd5pQh2+rRQVxC9MJdS+zkMaFNSfiv66FQKvXSvijjEZl8zRi8oHmz
	 JtLA8ZyhLr7/Lsy/0+KNWpIr+FavCClQO+wWsMvG/m9aJKuooi938AFbdJxcp4fLYP
	 qxWb8XWTFO7s5RcZIS1uIEgpgl+rXx16IczHujJo1TDD82J1xfajrjxfabAhZN9nKd
	 rqkn1RWYDDuWQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v16 02/21] fsverity: expose ensure_fsverity_info()
Date: Fri, 18 Sep 2026 13:15:14 +0200
Message-ID: <20260918111539.1003439-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
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
 fs/verity/open.c         | 26 ++++++++++++++++++++++++--
 include/linux/fsverity.h |  2 ++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index d0c56a7faa3b..4f06697f5bf4 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -347,7 +347,28 @@ int fsverity_get_descriptor(struct inode *inode,
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
+ * In case filesystem supports both fscrypt and fsverity, this should be called
+ * after fscrypt's encryption key is set up. Otherwise, the fsverity metadata is
+ * still encrypted. See fscrypt_file_open().
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_ensure_verity_info(struct inode *inode)
 {
 	struct fsverity_info *vi = fsverity_get_info(inode), *found;
 	struct fsverity_descriptor *desc;
@@ -383,12 +404,13 @@ static int ensure_verity_info(struct inode *inode)
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

