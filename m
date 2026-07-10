Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5AF823DE;
	Fri, 10 Jul 2026 08:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673612; cv=none; b=Vyn2zSpmV2cVujNBtozTwzOiaa7s0lRR+cuKZSIojtLpxmy+w+iRlOBfP4xPD/O7g5xfjEXSl+x63epS4KYRB/GVOlMqq7dRHtUrdExLrw5FeOLzU/HTVnH/+1y4vKTf6Pe8rUKEat+rrdNmJebSa1obvWkzfjxFRDcZYVQhlnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673612; c=relaxed/simple;
	bh=koL5JEzCiRkG/G3J5KeYw/fhC7PQNkfGJUXQmn9MaK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK8p2yLm2NtsN+ml8YX4epMuSp+jJ73r61wjB/OxRif4Va2O4aLIWgZMK9ttvItlwHIE4oakFEVQbKPkdHIR7Qd4JGSEWvFY8sh7SGND1yYw7R7HT9ASC9qwpawnnoyp0Q3+SSoUx6dwHk8287JEtQ5T2Om6uHlEcXiCfQ/H++I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNC3rkF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNC3rkF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553911F00A3E;
	Fri, 10 Jul 2026 08:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673610;
	bh=IA66KD2Om75bu0eBgUIzf65HS6s2gELQcRJU2+ySoSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNC3rkF8UG7ABgkdWzv8/LtMKC4JTUExVsuNpNG/Hbfltr8EnUovjtc5gBXr0ReRU
	 Y8S4VAZcv+fS4FD2COYtTrMuWsR7CdB73+RYBUBhp3VDzl059aq4cqHf7ME4kIbwFx
	 b0EvVZzm1pr+nzQvqQAoryl8HVL806xHrvacypKFXQfvUt5kcgXcC6GrYvZ2ovIhEm
	 BMmCffnXUYVu+cUFrH9dLdadlKSixDa5ca1q9T/qSgIK94CLXAyuQPKKo4s/9Rc9pJ
	 zop8z29sQ9Ii3L5ESbfz825gP+oARsEy/tLn/KlH8EJQqHLGcMq90uwCyMRUkSAvWC
	 zgy9Ba1BpfiLA==
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
Subject: [PATCH v11 02/20] fsverity: expose ensure_fsverity_info()
Date: Fri, 10 Jul 2026 10:52:30 +0200
Message-ID: <20260710085256.3464201-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

