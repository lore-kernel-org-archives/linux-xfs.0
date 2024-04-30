Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BD917592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481378; cv=none; b=eN2i4+ecXgeaTdhpE5lQKSNApzjNWy+SiOiBvyF4KBO6W6SZW8V4fOStKw+szhyS1uHz8OHINgRrjxk93m1UmvANKkPwzsW4bf0eZ9HrZk5N48JhMES77+piClAErQZlNEpNN8iystQ3YAGiQrdGAZRCWg2+cLciMcyqdoEcMYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481378; c=relaxed/simple;
	bh=Nj0KQSP2or/BYhco4R1AYYdKwLNT7oPK7WPasV/y3ss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V/s2w3UX53Mwpalz67IqXwQC4VpwomqNMJUcDzIb7OSS7Z5MUvpzQYIV9JhLs+QeWQekGOm4fEeVJ3xF4EIfFKkxcMZlo81INbRZ96lCFA5g7D5O1F5+CeznQ29alHVcLWKar6c1ZXI7g8SfPiIsQDI27+U2QdzTdgkn+PKZmTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hgp9uluT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hgp9uluT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5LQ2P1FJwur0I5RhelJJlGdQPcGdcQneF/YA8zVwlHI=; b=Hgp9uluTMTb8IbSUUo7gdwujqS
	AJbqDUjxei3bC48rn7ETWUaaJ5Tk6DzNEuQR5qzN1+XLykes46lZtkqrgR32HgX5gvH8SQDFxAhcv
	1i2dQhttxjNB+ETPiCuSwryle9HVnAgDZPEz9QsXTs761RERa9zuX4g8TG0XtnbEhrTMPYV7JUgRX
	MMaWcD5b/YYYSE1uB9jPR3oRNpiMjAVh83NP0t+oq35GM7N+tc9tg3VuLfVAPb4R8h5tvOY/JNQWK
	X9J/mM7UFcDOHDvobe6SIxc8985+XWPPs9ByUphRBHzZyorxCOcd0eok8p1QNB88ZiSb2G2mWRlKt
	vLksJ+VA==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvP-00000006Ngv-25t3;
	Tue, 30 Apr 2024 12:49:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/16] xfs: remove an extra buffer allocation in xfs_attr_shortform_to_leaf
Date: Tue, 30 Apr 2024 14:49:12 +0200
Message-Id: <20240430124926.1775355-3-hch@lst.de>
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
a non-empty local fork to reuse the old inode fork data to build the leaf
block to replace the local temporary buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b9e98950eb3d81..d9285614d7c21b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -942,24 +942,16 @@ xfs_attr_shortform_to_leaf(
 	struct xfs_da_args		*args)
 {
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_ifork		*ifp = &dp->i_af;
-	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
+	struct xfs_attr_sf_hdr		*sf;
 	struct xfs_attr_sf_entry	*sfe;
-	int				size = be16_to_cpu(sf->totsize);
 	struct xfs_da_args		nargs;
-	char				*tmpbuffer;
 	int				error, i;
 	xfs_dablk_t			blkno;
 	struct xfs_buf			*bp;
 
 	trace_xfs_attr_sf_to_leaf(args);
 
-	tmpbuffer = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(tmpbuffer, ifp->if_data, size);
-	sf = (struct xfs_attr_sf_hdr *)tmpbuffer;
-
-	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
-	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
+	sf = xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
 
 	bp = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
@@ -1003,7 +995,7 @@ xfs_attr_shortform_to_leaf(
 	}
 	error = 0;
 out:
-	kfree(tmpbuffer);
+	kfree(sf);
 	return error;
 }
 
-- 
2.39.2

