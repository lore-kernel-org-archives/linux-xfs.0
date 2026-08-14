Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66922370AE3;
	Fri, 14 Aug 2026 09:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699545; cv=none; b=QKIGCggXpndU/x2U2+qZ3ewSjIQphYiCBu+rx5H9n6FxNZtANCMwOchPVc32DQnuhuzWPYZBnChcl3jSYEuoLGpk2Ej10OX3fpRXAyaxYiEKTebz8usJrV570IkYYcQFpv/FQ9/rYJbJXP8DiVxx2hQsu4Id/wqeglHp3LycO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699545; c=relaxed/simple;
	bh=t9D5Xw8hj+Uk1PVc2axoFXJ85aUK4MBkI/u0Mp4xXAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqjoBKmbnh1bpSznfwFyHZfVXQr4noJW5hGlR24upX5WXexjmuxhxO7fiWBQZM78p4y9n48DL/YV9NhvwwpzNYJQ7mZgKoMiLuprYWlBo193tWQeyLkFnbk+dp+rRnzP11WeyRrUoNZ4kVkRPAqJw5y0Txg05Geu+sjXZ3Vi6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlnF7zR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlnF7zR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3437F1F000E9;
	Fri, 14 Aug 2026 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699544;
	bh=Go/Ag71QhxLYREjmSa7sE9PXLYovh2VY8xtfSqyB6bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlnF7zR8EsMwD/3KHvv4N6VzEZxW12k4IIALRSl3FlO86xDaPlz0okGyAJzCD0N10
	 bQY0z72hbe+W/t/fL6jWXx/IWqxbFtnJDBU7BvxcO+MR6AR8yRMaMiqWvi6lPcdi6D
	 v0Wmjhv/PAyAHbsTIoJpwmg/LjkKZPTjdbKhRT0aLyXJzXLo40iTC8GVGpVPgezlvP
	 Foeub/2Yg0shuBFin/o3awyr3K3hiTrrhGPf2BJvFQghJ9o0nDR/pmFCi1Up7GZ9cI
	 o7MCTYa/ddR2mnlNoUiju0HjTpuhWxLkkDzVRVnDYvavqgwGC8Uz/c0bpLdwTcNkz2
	 fISjKXw31AONg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 02/25] fsverity: expose ensure_fsverity_info()
Date: Fri, 14 Aug 2026 11:24:19 +0200
Message-ID: <20260814092448.1818082-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
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

