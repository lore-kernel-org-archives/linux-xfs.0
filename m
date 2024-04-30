Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1764917592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481375; cv=none; b=Cl+ql4BWzLrTTvUZPVsl28xvoP+KWjQa0wIIMUH6qDOdXDKubKvwbXZdz69sTJx8uzZZcRwW+qM/He990I9kl0Bnh39Ch/n0GN3Ac5gFSUxJ6yAopQbpPgDqmVpN+VINqnofLO90K+qpG4veys+ssgkKHCkLzn5pj5q9uLW8Kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481375; c=relaxed/simple;
	bh=eoQ5gqVXvqU3uu7dDEab9mQ9Q0+tYZ6YiC/VLv94c0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NBhQTxj4kdSEnA8QTcGCsm7tDF7ttsu45JHV0JQDBdBMJXbqypXK6e/bp3sYmtHAdlUX7DLeWMXAxh/Z6XHSP5F/WqM6l4YKFZinvzsxudTUlehFtUMmjLAoi6J5DeSCHAUXbuIrJVQFY8lRp77Hg2mF2q67Tr4hRtWU5CgQpIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fq2NdotW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fq2NdotW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nq/mQZNeKj6QPJVC9FZM3pY1xkMO08H4j7VRRXBq5tc=; b=Fq2NdotWl0EAgNiPyRWex8WwFu
	BWlWDZAkV2HYpPtwhx6FXfQQkWA83lGSfCEIlJv8VUVKw9Uui8knhcg4gVrAQUy5FgtZAETWfoYJ4
	ZNW7Dg7cIseUb92Ltp9YZQ2p7eHSnp/6gc5ra31QkdvaaEmubxC6Sdt2Z/um5g7ZKYs4lpoDacbkv
	TkE7rMfIf9IpkRGTz+gCrAqYgmGqHnjzTQfgJCJ2FdhOYRlbCdgt7mryUQT9qXDZWexqBmEjgXvU7
	881/JXEAHG7y3UtVpT7rd4m2AyWZ2ogk6ZSIg5ku4LHZuRouegTkDcFARqQuA+a1U6SJ8J3ITj9PU
	aqqRQeww==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvM-00000006Ngf-2aD8;
	Tue, 30 Apr 2024 12:49:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] xfs: allow non-empty forks in xfs_bmap_local_to_extents_empty
Date: Tue, 30 Apr 2024 14:49:11 +0200
Message-Id: <20240430124926.1775355-2-hch@lst.de>
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

Currently xfs_bmap_local_to_extents_empty expects the caller to set the
for size to 0, which implies freeing if_data.  That is highly suboptimal
because the callers need the data in the local fork so that they can
copy it to the newly allocated extent.

Change xfs_bmap_local_to_extents_empty to return the old fork data and
clear if_bytes to zero instead and let the callers free the memory for
the local fork, which allows them to access the data directly while
formatting the extent format data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++------
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6053f5e5c71eec..eb826fae8fd878 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -754,31 +754,32 @@ xfs_bmap_extents_to_btree(
 
 /*
  * Convert a local file to an extents file.
- * This code is out of bounds for data forks of regular files,
- * since the file data needs to get logged so things will stay consistent.
- * (The bmap-level manipulations are ok, though).
+ *
+ * Returns the content of the old data fork, which needs to be freed by the
+ * caller.
  */
-void
+void *
 xfs_bmap_local_to_extents_empty(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	void			*old_data = ifp->if_data;
 
 	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	ASSERT(ifp->if_bytes == 0);
 	ASSERT(ifp->if_nextents == 0);
 
 	xfs_bmap_forkoff_reset(ip, whichfork);
 	ifp->if_data = NULL;
+	ifp->if_bytes = 0;
 	ifp->if_height = 0;
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return old_data;
 }
 
-
 int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e98849eb9bbae3..6e0b6081bf3aa5 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -178,7 +178,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
 		int size, int rsvd);
-void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
+void	*xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t total, int *logflagsp, int whichfork,
-- 
2.39.2

