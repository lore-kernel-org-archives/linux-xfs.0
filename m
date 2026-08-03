Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51753AEF49;
	Mon,  3 Aug 2026 20:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787751; cv=none; b=kXsITWbgGT6exnRwqy09mO3Q8LOqhCStircqhhvbF5CMlJZ+AEUm8IWvbHKgOzOBoYePaIFKS8Nx2BQzyx8ULEpDDwqEjc/37LCipags5kcrZ6Sct4W4vl0uqxvypMy8PbS8FU9JWIpDDP0zqvsXJNA42lIIlI/+yb0N0kd+OHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787751; c=relaxed/simple;
	bh=t9D5Xw8hj+Uk1PVc2axoFXJ85aUK4MBkI/u0Mp4xXAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zfwg9pfmE04hY7M2KsWsnpnotZOh7GoqauwtUJayKE/WKP2mPJ25az9GTL4HBDCH9n7UtxCi7MpZm88x8ph9MZ5HNX8hSyY+1Qw1txEp8yPZ723W6/5UuybLmB9l98QNTfvZcVZsC/Ix8w4EmS244zXLAT/+LSkFds2KHV3Pzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EV8LJBUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EV8LJBUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CAC1F000E9;
	Mon,  3 Aug 2026 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787750;
	bh=Go/Ag71QhxLYREjmSa7sE9PXLYovh2VY8xtfSqyB6bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EV8LJBUDYpl6tlTimrwKFGS9aTCdNeA90WiRENe+sF6EWl78XLJtfYgQQF1P6WXSa
	 YZSSK3DCOOXVTZtnzgbRCgGRr3UcRIJoByumAIUw8k/sMMuEuiggGGN2s6QcL5zeh5
	 //Gb4Gk0uRVeqVVGi699wB3AVqUeRMMXpgc5gO0shYqOJWQtcP/kByWE0YKwBj1y8W
	 GlnQyU2nrihvjSEBJzdjgVr4R+z8zuOE6ZmA95lX2ekAsjkGU/AnXoLvv1xK8eIYNq
	 ZSHGfprx9PZBwqmYpfIUzNwrHoJI4b4EV9WYaaXnLUZrDXMDGq6DtNMZc0RuhtmKJq
	 YtsRI8vUuSoig==
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
Subject: [PATCH v14 02/21] fsverity: expose ensure_fsverity_info()
Date: Mon,  3 Aug 2026 22:07:52 +0200
Message-ID: <20260803200820.393203-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
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

