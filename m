Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4AE3D410D;
	Tue, 28 Apr 2026 08:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365241; cv=none; b=RgRkf1XMSMdbAE80vyr0E28k5Dr5Kn6o963ewZgfsLwxveWvLGUJD9SzGPz8T8Bu9Nk458yyIpl4WqKgXfyEx8Y25X7ye8g+26Q9G/p1lsTEOtyhqZcEyMrZ60IN3Z8FTVcu2saVtNtVf+lKir9MhSL4s0VdjkeygEJUe2C19Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365241; c=relaxed/simple;
	bh=WUbmJ09ApFlE5dv+q3/j1K9Rxwfb6sksHU6Kmj2I7n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVXt6VCqgn/UESpdDgSXWiH/voQQ9tG6+buz5miDtvYhx/AUjMGb5y5yiXbZnI/8wuWqFCTihNUqADoegTHNzv4lCPvkqAmGT1nZZiUE6zHJ/7AZLt+F+yKJsHOuZj4V0ldWx6k8cH/j4zL6dTEZyIN4sYOMLUQ50Vpfnlu3atY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlj0IaQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlj0IaQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A73CC2BCAF;
	Tue, 28 Apr 2026 08:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365240;
	bh=WUbmJ09ApFlE5dv+q3/j1K9Rxwfb6sksHU6Kmj2I7n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlj0IaQiSzjthKKKlbEtaE1S3v7Ew98o27NYKf7Xo3gJRAimS4Nw7HENpyhxCfsLH
	 Cc3w8PGmM/JF96Z2brLIQfYfiIei0mHnAhUx/FPrBsf4hdRI1B+QN83nx4tsBdjcqN
	 909m3ryjjO2DiXdlAiVnKR52bS3IElBWJVapLKzMSkAD0zlPwHGTJCO+iryKjb6GKa
	 iBzv6TOXXA0NIWfF5zY0jz7OHb4597n+XB0D9J7Ci7zVM9j5ITdZsjzMvU4Y7CtbNR
	 LgKPIls36JJouOFtLEl//81YjSyCogTx8GQeYlBZeSzHKNSwATr+GwcHV4T7CQ/s3h
	 npcpXsZoEiGmg==
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
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v9 02/22] fsverity: expose ensure_fsverity_info()
Date: Tue, 28 Apr 2026 10:33:08 +0200
Message-ID: <20260428083332.768693-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
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
index dfa0d1afe0fe..d32d0899df25 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -344,7 +344,24 @@ int fsverity_get_descriptor(struct inode *inode,
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
@@ -380,12 +397,13 @@ static int ensure_verity_info(struct inode *inode)
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
index a8f9aa75b792..5562271bd628 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -309,6 +309,8 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+int fsverity_ensure_verity_info(struct inode *inode);
+
 void fsverity_cleanup_inode(struct inode *inode);
 
 struct page *generic_read_merkle_tree_page(struct inode *inode, pgoff_t index);
-- 
2.51.2

