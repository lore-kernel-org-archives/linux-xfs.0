Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD4E17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481395; cv=none; b=qG+nS4EnIl0hTaTdB+GkjcJcSH8+FjTIHNhHB5r7yF934vHlpam+mYNP3o6gGNXYhQT/r9u6+gjgU9V+ot0Y04CoGnkr8/knDs+qDLBKnvES8ohH9UCyPTisd/GJNdgATiEO272YbWGXLsRgLZcrwIVXBhLTHgAOa4ERhkHZWg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481395; c=relaxed/simple;
	bh=KsVmBDpk8WE90z/wLz9LIoytIBOPszCnUVulQOeZKh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJdxRxgrcOYYNV514nVMWU0rkXcSXL4p7qnsm+UzeVwXGezC1p4R1NZmyBXYvomE8ZC+qp5swJctI7eWTqwXUEQoxtMMdFZSFN463pugei8fvbniyxWn2Kx2SDYHSmwedK7zwQdNFUbeg7ipXC/SyVWJNfDxcmUOqxiU059NCdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LLAKE2zp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LLAKE2zp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K02Q8RNmVx6CULPgX5Hpgse4SZ9DfpqYV4NAYsFaQQI=; b=LLAKE2zpsQdAHus1KNRipnUCwX
	crI/zx1ztWR2Pev4rnh58Ap3Ei7VoJNyWhyriJCJNDpzYv62QG35FTwY8QaWNz7hmmOQFJj4IVFtY
	2Kz4tIF+kxfzEqHexq4zwxjdWsYlD6urYELvDZUMpO66eeYEIteMTJ/GLvTEUIbMFlXjaLfQhnRut
	NgXMT19tEuoaLKbX45LmQpLRLQ+K05TUZnzqH9VhYlKd4TtUob4jJlhXfV+8Pt3OsnwA+f3xLz8Q0
	6XxiOWa2iEVvO7pEh9Fe4Rj3bKOM2zPWi5sRd//nXPuUwzZuyW4JdxA0jv8QfpFl8we09nCatxzi7
	fyM5zutQ==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvh-00000006Nl1-1E1k;
	Tue, 30 Apr 2024 12:49:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/16] xfs: remove a superfluous memory allocation in xfs_dir2_sf_toino8
Date: Tue, 30 Apr 2024 14:49:18 +0200
Message-Id: <20240430124926.1775355-9-hch@lst.de>
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

Transfer the temporary buffer allocation to the inode fork instead of
copying to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 164ae1684816b6..87552c01260a1c 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1205,36 +1205,25 @@ xfs_dir2_sf_toino8(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
-	char			*buf;		/* old dir's buffer */
+	int			oldsize = dp->i_df.if_bytes;
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
-	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
 
 	trace_xfs_dir2_sf_toino8(args);
 
-	/*
-	 * Copy the old directory to the buffer.
-	 * Then nuke it from the inode, and add the new buffer to the inode.
-	 * Don't want xfs_idata_realloc copying the data here.
-	 */
-	oldsize = dp->i_df.if_bytes;
-	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
 	ASSERT(oldsfp->i8count == 0);
-	memcpy(buf, oldsfp, oldsize);
+
 	/*
 	 * Compute the new inode size (nb: entry count + 1 for parent)
 	 */
 	newsize = oldsize + (oldsfp->count + 1) * XFS_INO64_DIFF;
-	xfs_idata_realloc(dp, -oldsize, XFS_DATA_FORK);
-	xfs_idata_realloc(dp, newsize, XFS_DATA_FORK);
-	/*
-	 * Reset our pointers, the data has moved.
-	 */
-	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
-	sfp = dp->i_df.if_data;
+
+	dp->i_df.if_data = sfp = kmalloc(newsize, GFP_KERNEL | __GFP_NOFAIL);
+	dp->i_df.if_bytes = newsize;
+
 	/*
 	 * Fill in the new header.
 	 */
@@ -1257,10 +1246,8 @@ xfs_dir2_sf_toino8(
 		xfs_dir2_sf_put_ftype(mp, sfep,
 				xfs_dir2_sf_get_ftype(mp, oldsfep));
 	}
-	/*
-	 * Clean up the inode.
-	 */
-	kfree(buf);
+
+	kfree(oldsfp);
 	dp->i_disk_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
-- 
2.39.2

