Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9093DD518;
	Wed, 20 May 2026 12:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280654; cv=none; b=Qn5kqNa1C4W1ytksNBgGqD5cYy6iSB5Q4tFkIZLMD6+hRi7bLa+DwKuoxIkQM9CuUulCk4yyBRwKVmx7j9dccPk8VrfeXnE98SoFAsKX35xqkoV/J5PZJvqrnvZfFgPJ0ZskSC5pmHD9bhLNoKlfhoGOga4LWZ7aUMJ4HKHBG6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280654; c=relaxed/simple;
	bh=WUbmJ09ApFlE5dv+q3/j1K9Rxwfb6sksHU6Kmj2I7n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WB6TJkBpwTHXGgLUD3oiSer+IwSioKViX0XwxmNmlNYCtVUAf4z15MY4RC7gwfDbSxvu7n03u/PRVfkgOMROsQ4K4bhj/9u02rCa5UyPJcTr/uS6WqPVOeuRFv0hNr3op+7YEo7ldPt5/eKVikbviWgzS9F/09vK9BvFKWPxiaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuTLUh8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuTLUh8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509381F000E9;
	Wed, 20 May 2026 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280653;
	bh=aPukUD+NtePBNeO+9pQXROMWpzJAwBfMA+GAmXDsmOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuTLUh8sfDD/phf8ZbFnKsnOI/dDSd7+fjq92/uCsC+kcCtyPN4tZLc2/9BVY6Kaz
	 qho6eKhVZExcvQd5I3/fDLEg1v6h0YWxj5s0h4MZVIlECyFcKesvfFC1wFRb2po3PQ
	 lvKDBu6xD84QDVS6kIpMVD3jt7NBB+/DrmXBq8V+7rmc5SV7pWP8rEVcZL1ISL/rxn
	 WPgn9JPu3e6a3lmHtpMPdKIkv1XPKJksf6wrEc0XqJXuianYWq3ukTr7qFZzmt2PQF
	 FWipOqDD1Ji/xxnqeBwbXFUaQuvPCgpmP8JOq8ppUR0ZcJIlBWEcvSVaibaip2NXlf
	 l1JCroTm2qvOg==
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
Subject: [PATCH v10 02/22] fsverity: expose ensure_fsverity_info()
Date: Wed, 20 May 2026 14:37:00 +0200
Message-ID: <20260520123722.405752-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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

