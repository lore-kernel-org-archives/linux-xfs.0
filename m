Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753D73CD8C7;
	Thu,  9 Apr 2026 13:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740457; cv=none; b=dd5Vd9RiYI8LYvM0mWf/ktMHmt4p5VXVVFIq1crl7ctNSgyrAntzh24RXG6zzLcAdGLfWlgIRzlF4waStFU63YwfTayQF1Zj+le+9jVSWf7UXUgtV8nzWVgSbPLw88RQBWlJ/mum2WvJSmKFnj0Z7W2x9CYv1fuBExMOWaHKQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740457; c=relaxed/simple;
	bh=5N+dWqoeOYxeisPRy5znoys7rfHJB7cC5xNXENMMBQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnimwVsxCAMEMBTu79CqYWT7Me5vjF6upU177bq1ia7MF5XAuz6mPZC+yT8zfgjUGHd9+XslxwEFwtvqnKUPfF+dWfXK5AWdgQyMY24jVXfrgtJus1DUk4wRzlpFj1wzvku/I7+wa47OpoRZxDjyFezlStP514FAKiqeMZu8ONo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwUQZlNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwUQZlNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF0CC4CEF7;
	Thu,  9 Apr 2026 13:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740457;
	bh=5N+dWqoeOYxeisPRy5znoys7rfHJB7cC5xNXENMMBQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwUQZlNxl+io2MdTLLrkilUN3sJss98rjzTKiKrEDrYawljjKTeUFoiLLbOuW2+BV
	 xh3VXcYfS0MvNhMWNtMy1CmqTY4J1uDB6t4XigmmL1rIlJOSxIInDMH0SrYm489sDf
	 nDEw3JIiGR9gxNdMCVBWITM6DZqtHQy4yKl9EoKJFFhFyzGqEzHuC1E7t3akL6dC1a
	 n5hGssVv3PFnAvp9TNtkQl7VsDnOrgz7k6jqYbw5aUve0rhoJaMhggdkWMJVdoevDy
	 yBV/hU0XM8MPU7kWwvpS8Gwcgk0PGvYotKw1eJd3b75SOVbmIoWlybUQPz8RRPQqKJ
	 w1C5okfgbjcJg==
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
Subject: [PATCH v7 02/22] fsverity: expose ensure_fsverity_info()
Date: Thu,  9 Apr 2026 15:13:34 +0200
Message-ID: <20260409131404.1545834-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

