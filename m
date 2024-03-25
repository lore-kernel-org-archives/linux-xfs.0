Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13396130AFA
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333496; cv=none; b=IcpAQreWCbvSuggxGImHZWizIHJiUL8Y1TEyLvFhx7qRY0i4idl0W07Tc8omBqilcECRy9DcJSdWXiztTLiZijP84WmnNH5P1PoH/ee1ZPeWwTeW2lAi6ju38axPZkDLKTFJt4a79UZN5lGl2ZIUoz905dXX4P5IuW2b2ItZWms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333496; c=relaxed/simple;
	bh=dLODdrzqFCgVmA30oUoncqFdRgGcL+XWunrHbnrHPu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TKVqTELo3VspFUTmmgn32zATboqD6c2byCBkTcOzbpFK1VJU7l76OrnbzeRb0UFS+CyewBA7q2Vq7W4Z0Xb4oR49WQPWV30WTDaBGU6VQ734l3s4Q289OyEq9OvLG89ktRNcE18rCuxUppSElTVitF9UXdRtQbJn/hEr4C3sMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SLJ9CiLA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SLJ9CiLA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wSsmyD6q6gfMLf/9uyscXJ2Z9vHk88A+JMVXu7cX+JA=; b=SLJ9CiLAIk5Y4Mdyjp581oNusw
	kLQCa55WgywhBPSJ2pIrPzVYccJIOmF6MUXfKHmYIRDy87ZxPz99xjP4eivnDzM/5MBpKJM+Vu0g0
	v8lCDoOyVdBm2htyyhY0TrUwimnVVGCxo95PUwCuCdW+KNUUHAM0UjiVCh9YRHWZBoqWwzSiwv5eL
	qdzmsq4sPHCV+eEEspG5sd/vnT4FagsQeZemB1J027keCVRX3F1vhmkMnBoCc0xpnLbbUynuwUuts
	uMsHsZSZlUnObUHmUUd5F8xk1kE4ABPYXglMvvM5CoHYqaA3Idz2Gwdx+bvbqceki0WuDy+WpGUMR
	mHLTsVLw==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa18-0000000EeaB-0l4d;
	Mon, 25 Mar 2024 02:24:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/11] xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)
Date: Mon, 25 Mar 2024 10:24:11 +0800
Message-Id: <20240325022411.2045794-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit aff3a9edb708 ("xfs: Use preallocation for inodes with extsz
hints") disabled delayed allocation for all inodes with extent size
hints due a data exposure problem.  It turns out we fixed this data
exposure problem since by always creating unwritten extents for
delalloc conversions due to more data exposure problems, but the
writeback path doesn't actually support extent size hints when
converting delalloc these days, which probably isn't a problem given
that people using the hints know what they get.

However due to the way how xfs_get_extsz_hint is implemented, it
always claims an extent size hint for RT inodes even if the RT
extent size is a single FSB.  Due to that the above commit effectively
disabled delalloc support for RT inodes.

Switch xfs_get_extsz_hint to return 0 for this case and work around
that in a few places to reinstate delalloc support for RT inodes on
file systems with an sb_rextsize of 1.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   | 3 ++-
 fs/xfs/xfs_iomap.c   | 2 --
 fs/xfs/xfs_iops.c    | 2 +-
 fs/xfs/xfs_rtalloc.c | 2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ea48774f6b76d3..aa62fe2ed76834 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -60,7 +60,8 @@ xfs_get_extsz_hint(
 		return 0;
 	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
-	if (XFS_IS_REALTIME_INODE(ip))
+	if (XFS_IS_REALTIME_INODE(ip) &&
+	    ip->i_mount->m_sb.sb_rextsize > 1)
 		return ip->i_mount->m_sb.sb_rextsize;
 	return 0;
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e0c205bcf03404..f6fd9aed3a7f4b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1000,8 +1000,6 @@ xfs_buffered_write_iomap_begin(
 		return xfs_direct_write_iomap_begin(inode, offset, count,
 				flags, iomap, srcmap);
 
-	ASSERT(!XFS_IS_REALTIME_INODE(ip));
-
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 66f8c47642e884..62f91392b281dc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -521,7 +521,7 @@ xfs_stat_blksize(
 	 * always return the realtime extent size.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip));
+		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip) ? : 1);
 
 	/*
 	 * Allow large block sizes to be reported to userspace programs if the
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e66f9bd5de5cff..7eb30ecf96718c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1346,6 +1346,8 @@ xfs_bmap_rtalloc(
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
+	if (!align)
+		align = 1;
 retry:
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
-- 
2.39.2

