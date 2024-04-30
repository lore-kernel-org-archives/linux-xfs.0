Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FC617592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481384; cv=none; b=jrnEiX4gFvHTFENlV0CTw7qT9XZKMx+gVygqVyM51T7g7A5NcxGpFG2tzx0ArNbX1mMt8vARKy7mPhzSYX7w8duLyKnH8gXnsTVJ/Fy4/OBJb8XYUMIvzrMHlomDl40Zk15WRewq6OPwXvG5Ce79INAnN/FmOUkHJA/KVN8VZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481384; c=relaxed/simple;
	bh=m6TfcAivtkNsXb5m3ky1zNIqFo4rSu+Df/iGS05CrzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ppbYc48Dv7GbNOgj4nESkvvarmak6qVMu8SmU6VN3qMfW2TUetn4OT8M7kk7GLQSsfNINEO9SwFEvLLN/5EnefAq7JhJfNt5x1x9EBf5nIMV3p3dP8AYj0qvcDV4Rderni5PmC+uiLDNb0RIg2NjTmuYTBQN6Uv7QWYx53V1OMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ygaUgecu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ygaUgecu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ssTVYyVxAIprN1PwSjqvWdkwMf8c4cTYqGlxowoPPgs=; b=ygaUgecurr5HET5YHzuuNfoCz5
	2WM5uOaOXGU1mxk+gKavX5yNg1qLEPLoI1EBkZhaIHUsCL7jbzsg4d4+tPw4dg+VmY6wuZ3642NTB
	WPCSCXqL436+ZDx19O762IiayEcnxbrX9gr5qWWEb2uu1OMg+4OcmNU82EDcgTIoJ+4nIYWWLwNKN
	JaJ/fdqsxftRUVGdXGZnEOmTgwyJNImDbrM3ncLrXMpZ7iwx/ZQzuJ1amjasrdn3jgrXs6eXgz97+
	xt6eWRYygjLhMwyac+0XJBRSUzlJ3IYnk0bsVlzjDYKAO4IuliMxYXZRuUMH6DgVZZ1nFYWzClkPM
	UVxAoz5g==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvV-00000006NiA-2VEB;
	Tue, 30 Apr 2024 12:49:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/16] xfs: remove an extra buffer allocation in xfs_dir2_sf_to_block
Date: Tue, 30 Apr 2024 14:49:14 +0200
Message-Id: <20240430124926.1775355-5-hch@lst.de>
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

Make use of the new ability to call xfs_bmap_local_to_extents_empty on
a non-empty local fork to reuse the old inode fork data to build the
directory block to replace the local temporary buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 035a54dbdd7586..20d4e86e14ab08 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1097,8 +1097,7 @@ xfs_dir2_sf_to_block(
 	int			newoffset;	/* offset from current entry */
 	unsigned int		offset = geo->data_entry_offset;
 	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
-	struct xfs_dir2_sf_hdr	*oldsfp = ifp->if_data;
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
+	struct xfs_dir2_sf_hdr	*sfp = ifp->if_data;
 	__be16			*tagp;		/* end of data entry */
 	struct xfs_name		name;
 
@@ -1106,17 +1105,10 @@ xfs_dir2_sf_to_block(
 
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(ifp->if_bytes == dp->i_disk_size);
-	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
+	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 
-	/*
-	 * Copy the directory into a temporary buffer.
-	 * Then pitch the incore inode data so we can make extents.
-	 */
-	sfp = kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(sfp, oldsfp, ifp->if_bytes);
+	sfp = xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
 
-	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
-	xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
 	dp->i_disk_size = 0;
 
 	/*
-- 
2.39.2

