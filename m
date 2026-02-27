Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96990421F17
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772201338; cv=none; b=Fwfa+hEJB74wUfjLbMUkdLeDHMQRwBev7JR+2nFJVCF+WwBZAXOVZVNWb7Hk+SKonyi1yqH4/ZFvmKA8bNuNcyP21zH5HuyX2XIG48JSk0TkAHdz6d5QPnTNiCxj+YPRIBfinNV1osiDiXzQuDqVWs+mYZ3ocUjvLAgE7OipfYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772201338; c=relaxed/simple;
	bh=XoVHFhHxmzetszanQo7XJEJqnLK50u0yiMQahtNgmHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2wgXfgd2HFN6nCWx0ZbX8+m80cdEDn/ukZEnNKB0h7x1p0QDV8K1t7yMCN0ykRWXr4GCTgbLG/9a4bYbVoLO8Tvq+t/XMclrE8e+8lAmbuXKBZ4O+F49H+PwfhiXrAIm4ddh6+QLUgEZXkTIVh0y3l1fZF0NJyERqK7YUtTZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4fMqts3WC8z9tgg;
	Fri, 27 Feb 2026 15:08:53 +0100 (CET)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	dchinner@redhat.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	cem@kernel.org,
	hch@infradead.org,
	lucas@herbolt.com
Subject: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
Date: Fri, 27 Feb 2026 15:08:41 +0100
Message-ID: <20260227140842.1437710-2-p.raghav@samsung.com>
In-Reply-To: <20260227140842.1437710-1-p.raghav@samsung.com>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, xfs_alloc_file_space() hardcodes the XFS_BMAPI_PREALLOC flag
when calling xfs_bmapi_write(). This restricts its capability to only
allocating unwritten extents.

In preparation for adding FALLOC_FL_WRITE_ZEROES support, which needs to
allocate space and simultaneously convert it to written and zeroed
extents, introduce a 'flags' parameter to xfs_alloc_file_space(). This
allows callers to explicitly pass the required XFS_BMAPI_* allocation
flags.

Update all existing callers to pass XFS_BMAPI_PREALLOC to maintain the
current behavior. No functional changes intended.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_bmap_util.c | 5 +++--
 fs/xfs/xfs_bmap_util.h | 2 +-
 fs/xfs/xfs_file.c      | 6 +++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..532200959d8d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -646,7 +646,8 @@ int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	uint32_t flags)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -748,7 +749,7 @@ xfs_alloc_file_space(
 		 * will eventually reach the requested range.
 		 */
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				allocatesize_fsb, flags, 0, imapp,
 				&nimaps);
 		if (error) {
 			if (error != -ENOSR)
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..1fd4844d4ec6 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t len);
+		xfs_off_t len, uint32_t flags);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6246f34df9fd..3bd099534c68 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1346,7 +1346,7 @@ xfs_falloc_zero_range(
 		len = round_up(offset + len, blksize) -
 			round_down(offset, blksize);
 		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len);
+		error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
 	}
 	if (error)
 		return error;
@@ -1372,7 +1372,7 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len, XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1400,7 +1400,7 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len, XFS_BMAPI_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.50.1

