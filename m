Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C11A42AA5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481404; cv=none; b=EkyUS6IPn3ECL8wfzEPnk1Eo21LHEkabRlBkELaFhGbS9JuspR1Z/yQVR455XlvyQnOcD2E5gGCey53fgqbpvHnVenGKZjYHcyt7VNLp6pceB2Q6A0LsAdAm1QS/7SQmFyoVVpKiqxsIFnhtJ3s9aZYnN4gDxdTEpmJ74xvd5TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481404; c=relaxed/simple;
	bh=FzY/3Qr09bgxYTuyh+tM22eVA4qyLDsTZuKT1bUYjeg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gjkpRWEJKVXqSg1g/5SJl4DKa3lRNh1eOPrRbe4ey/M6vMWojaW7DjNnLFGynGhQ68wFBEzDhbCnXpFaJYX7aXwnwq0oBnCphL88triiO7Dq7OAf412PC73gvCX0jyt4j5GfT6k3arDiZDhFlTiM4Van2sMQ00A3Ni0CeZF/X7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wiXmTltI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wiXmTltI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tUZhw11I4Qd5Ll72R+8T1RodFkECbuidGFWdPFV4hH8=; b=wiXmTltID89v3jIIZP+jV4Jd8V
	VCzoXMNevtbPwinaYPD1dBUmDJSiUnDJgaklZDpoYvH5Ee3xVbiKM91FtRm3pjvblxLI3y6+hynyQ
	fK0736tRaxQfV0/DNlZiJKBsmdgBT6CnqleNKYZK7TgtP86x55k4nKQ0W72Xurwhha/8J8ztUXZVe
	7VEw0iOhNxGkU3NZ6+RSZRDt92rtlyjPrZzZaviWlJq1jSrAYsW1Oq8galRnlPvQYIbhTk1ZA+dkq
	OK1Whag6sao4LM+XaIBFKEhzJkqkPSy+1HqOSOOMkjjBcrxuyMFuywHtR8K1M17xvxr7s141XASHM
	pewWRkTQ==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvq-00000006Nmu-1KBl;
	Tue, 30 Apr 2024 12:50:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/16] xfs: add xfs_dir2_block_overhead helper
Date: Tue, 30 Apr 2024 14:49:21 +0200
Message-Id: <20240430124926.1775355-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a common helper for the calculation of the overhead when converting
a shortform to block format directory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_priv.h  | 12 ++++++++++++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 12 ++++--------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 378d3aefdd9ced..a19744cb43ca0c 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1109,8 +1109,8 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Compute size of block "tail" area.
 	 */
-	i = (uint)sizeof(*btp) +
-	    (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t);
+	i = xfs_dir2_block_overhead(sfp->count);
+
 	/*
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 1e4401f9ec936e..bfbc73251f275a 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -205,4 +205,16 @@ xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp,
 enum xfs_dacmp xfs_dir2_compname(struct xfs_da_args *args,
 		const unsigned char *name, int len);
 
+/*
+ * Overhead if we converted a shortform directory to block format.
+ *
+ * The extra two entries are because "." and ".." don't have real entries in
+ * the shortform format.
+ */
+static inline unsigned int xfs_dir2_block_overhead(unsigned int count)
+{
+	return (count + 2) * sizeof(struct xfs_dir2_leaf_entry) +
+		sizeof(struct xfs_dir2_block_tail);
+}
+
 #endif /* __XFS_DIR2_PRIV_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 21e04594606b89..1e1dcdf83b8f95 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -629,9 +629,7 @@ xfs_dir2_sf_addname_pick(
 	 * Calculate data bytes used excluding the new entry, if this
 	 * was a data block (block form directory).
 	 */
-	used = offset +
-	       (sfp->count + 3) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
-	       (uint)sizeof(xfs_dir2_block_tail_t);
+	used = offset + xfs_dir2_block_overhead(sfp->count + 1);
 	/*
 	 * If it won't fit in a block form then we can't insert it,
 	 * we'll go back, convert to block, then try the insert and convert
@@ -691,9 +689,7 @@ xfs_dir2_sf_check(
 	}
 	ASSERT(i8count == sfp->i8count);
 	ASSERT((char *)sfep - (char *)sfp == dp->i_disk_size);
-	ASSERT(offset +
-	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
-	       (uint)sizeof(xfs_dir2_block_tail_t) <= args->geo->blksize);
+	ASSERT(offset + xfs_dir2_block_overhead(sfp->count));
 }
 #endif	/* DEBUG */
 
@@ -782,8 +778,8 @@ xfs_dir2_sf_verify(
 		return __this_address;
 
 	/* Make sure this whole thing ought to be in local format. */
-	if (offset + (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
-	    (uint)sizeof(xfs_dir2_block_tail_t) > mp->m_dir_geo->blksize)
+	if (offset + xfs_dir2_block_overhead(sfp->count) >
+	    mp->m_dir_geo->blksize)
 		return __this_address;
 
 	return NULL;
-- 
2.39.2

