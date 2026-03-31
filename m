Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802BE453486;
	Tue, 31 Mar 2026 21:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992521; cv=none; b=tqbJrtUXbOO/GsnjtrrIwBwlnDA6BfYkMeuGhQhvK2s7h6mjavt06vcZY5vnG2wewQ7rzfysYE4s2+qUweVHyadNpDurDB4kNh9z0wnjXQ0hqYd+uOcqgcvdla+4hPNfwkLKJXrxhL5w33Yjh5cFeFYKlyNmwwIJ2wQIOPvuqq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992521; c=relaxed/simple;
	bh=DWFGNbys8DFPXMuK9ukIc5QmySSoURrtpsw9XO+xryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTiYiTqWnMNoGRARqnzBqahEFIOb0RVZGHtiPSaaHSwvfk2VoOcPtT7WS5a2/v8QTAp2mnsHGF3FEvzpS41IkxhlKXGFBTPlXoAeJPN93XLOyhLHbffH8lYz/R4SG+phhoZr4klKTDmizSbyOEZJLCXJGVxKvae/b1B+wXkQI1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCaKVOP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCaKVOP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93F9C2BC9E;
	Tue, 31 Mar 2026 21:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992521;
	bh=DWFGNbys8DFPXMuK9ukIc5QmySSoURrtpsw9XO+xryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCaKVOP6Ndjpfrf7u13jiPs8DEpIER63CwhOxd7N+Q0VipDtqk+iXQXxyxaVZdBOZ
	 SXbyjC3XXIoLyhm1wz3paM4sHPx36ryRDMiUktQ1eyntHCsikVOX5gFzYOg6DSM1P4
	 0yQzO6K4OM8CPCDt6jP/OQsdllaEgOHeGy1yhHTSxoHZJK0Y7qxpN+lY+5WN9HRSho
	 GUcJPKU/5tzjHLbpE5s0ezLGEpTzJfh3dbgpnhmYkGDDLEvZ4RIHG0JyNP7WMS1K+o
	 n5Cw6WO6xoVk01+FhGifUOyafexIoh6lLzH8+PLyfz5M3pyUzJVUo/GmQIwF5MTdpI
	 2dVira0fksuxA==
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
Subject: [PATCH v6 02/22] fsverity: expose ensure_fsverity_info()
Date: Tue, 31 Mar 2026 23:28:03 +0200
Message-ID: <20260331212827.2631020-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function will be used by XFS's scrub to force fsverity activation,
therefore, to read fsverity context.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/verity/open.c         |  5 +++--
 include/linux/fsverity.h | 13 +++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index dfa0d1afe0fe..0483db672526 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -344,7 +344,7 @@ int fsverity_get_descriptor(struct inode *inode,
 	return 0;
 }
 
-static int ensure_verity_info(struct inode *inode)
+int fsverity_ensure_verity_info(struct inode *inode)
 {
 	struct fsverity_info *vi = fsverity_get_info(inode), *found;
 	struct fsverity_descriptor *desc;
@@ -380,12 +380,13 @@ static int ensure_verity_info(struct inode *inode)
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
index a8f9aa75b792..2e3a90aff11e 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -309,6 +309,19 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/**
+ * fsverity_ensure_verity_info() - create verity info if it's not in memory yet
+ * @inode: the inode for which verity info should be created
+ *
+ * Ensure this inode has verity info attached to it. Read fsverity descriptor
+ * and creates verity based on that. Inodes opened outside of
+ * file_operations->open will not have any verity info attached. This
+ * info is required for any fsverity related operations.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_ensure_verity_info(struct inode *inode);
+
 void fsverity_cleanup_inode(struct inode *inode);
 
 struct page *generic_read_merkle_tree_page(struct inode *inode, pgoff_t index);
-- 
2.51.2

