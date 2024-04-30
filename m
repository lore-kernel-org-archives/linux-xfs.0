Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199BD17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481398; cv=none; b=SehPOzXu9fYoLyZ+EyHIT5z6XorMYU12pC2Lpi0Uk3hp2wQuPpZ+wUuA4vhC8+vtSuVuXZ0Ng/ZRyWOrEe958djE7eRd1ZvpHt0ZBMa4Qct8HwaNJTFffPJr7qU5OQRuQio35wh4mQhVXEBqofVnRJS4raSqN8kvAQWw9yc8uNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481398; c=relaxed/simple;
	bh=pJZkmzBr6ISQVwMBPLCNPrm6haWfEf4TKJ79y0a21HQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tGbKkWpvesK1vSs+tmDiXVXq0apsoLh/Um7yQMhH41eO67pgxAXBz1UvByU57JaaYRz9YeDUdK5RrbwPFJ1A20cQZcoa6zSAIk8d4xOS7zvut47beOq2uqKPR1o6NKU7hsNoEo9QpPLqoWWdH33H0NprdCxqZQsPalFNJ5C3D9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vFwDRFBP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vFwDRFBP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J91CyDJKyKV4tKglaK1Z1i9F/2QJIGaKXeKDn5QuaVM=; b=vFwDRFBPowmT7TYgBs1MUKOjXb
	O6/HVlUMglDLnIscjB5Rq4haJoSldFFkAWa0ADpvjCy4tZwA6SzDCGlwo/sN8dP+UlVgx9rfkTqo6
	RDvooCwwexxnLPJBbXN5a25blKtTBGB03MosBAjgA8v51PAWVFSbeWMES8pu53+3JEowEQjk2XDky
	+vtJxWVRXf2dC3D22gIFnCfS/BlOSvl3EvGnZZ/Y7eeKr8rERgvqFvzv/YGwTqQj4UITvRftRuxDZ
	5MEWRAz5OcFD9OSYXRdPJOrzQsNHd+VDb+2o6y75fO/AMhuQrOu8D6A28f8orVVVNl2h6OQd2ls6X
	24JHHUFg==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvk-00000006NlK-1X8u;
	Tue, 30 Apr 2024 12:49:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/16] xfs: remove a superfluous memory allocation in xfs_dir2_sf_toino4
Date: Tue, 30 Apr 2024 14:49:19 +0200
Message-Id: <20240430124926.1775355-10-hch@lst.de>
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
index 87552c01260a1c..3b6d6dda92f29f 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1133,36 +1133,25 @@ xfs_dir2_sf_toino4(
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
 
 	trace_xfs_dir2_sf_toino4(args);
 
-	/*
-	 * Copy the old directory to the buffer.
-	 * Then nuke it from the inode, and add the new buffer to the inode.
-	 * Don't want xfs_idata_realloc copying the data here.
-	 */
-	oldsize = dp->i_df.if_bytes;
-	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
 	ASSERT(oldsfp->i8count == 1);
-	memcpy(buf, oldsfp, oldsize);
+
 	/*
 	 * Compute the new inode size.
 	 */
 	newsize = oldsize - (oldsfp->count + 1) * XFS_INO64_DIFF;
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
@@ -1185,10 +1174,8 @@ xfs_dir2_sf_toino4(
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

