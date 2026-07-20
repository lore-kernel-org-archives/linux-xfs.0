Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D813D25A6;
	Mon, 20 Jul 2026 09:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538302; cv=none; b=mriGHj7kchl/rKYwCKAPCiCwJ7pGThMciSMyWcsBwSNcPYahKm6/EMShpiOionBWtM2aRYZRsMyfaKW4OXrsZDzF1fNQfXpWKgTZELNE+91WYMKal/IyY1+j9dkH0kPdmmWGYvTv/16dMukJhX7UFfq/rqDUmDW2c3pixTpX/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538302; c=relaxed/simple;
	bh=koL5JEzCiRkG/G3J5KeYw/fhC7PQNkfGJUXQmn9MaK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujAB5m8OSHw01xDbphj3hZGOjNRD7cRET1vrmVOPr+xRDabHn5qVkYZzAmuzkO+2jMH4CT6y+0jWiSCgjX+bC6e+VXeABKNH30mk6w8dYZSA4ybCsRyDFyeCBht+Q9qKa4ZYOFuj6VqidxZWO/fF7dColuDrXv6ImW3djRS7ci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4gDrnaJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4gDrnaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDB21F000E9;
	Mon, 20 Jul 2026 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538300;
	bh=IA66KD2Om75bu0eBgUIzf65HS6s2gELQcRJU2+ySoSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4gDrnaJTvhIcsRteJZxPDhqWUyFPvyvFzymL+Vs2stNPbVksiLip16x9YqT0mbNy
	 hflyOG/BkJaUzObv8EEzt5F19MJWPjWbgvUKMvq0DECtwAhH5PhHSGHqhiE+ePQDdS
	 gfFAU0qk/7Jl/jM7DjGplRQKj11Oo08QtV/H8e+YEBkavefMiwVGoctCW9dOWNm8G4
	 AJhVMgw+yTh0ugNeiEZOlVFPTSsMR1sPX8up8XC8fW7LN3OCGoOsTIFUlW0W1kILca
	 ksfhA3MNoArtdA0XephBSDwYNYqGZqc0Fl12168qmcVMJxysjV1ARmZkeEg5CLNS9a
	 XCJDZ5jG53C0g==
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
Subject: [PATCH v12 02/21] fsverity: expose ensure_fsverity_info()
Date: Mon, 20 Jul 2026 11:03:30 +0200
Message-ID: <20260720090410.3487990-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
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

