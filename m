Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4045145FE9
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784872; cv=none; b=t2Y4dHzluE2IeeLhSAeudThKFj7YwsfNZ3amxWwAvLIStyEqj93wzAbb/x9N0UzB09YvampHYHDPvuasXGLWRfauuQeHxp6h6S+Rv7w+x0iOa1XhTSs6dKWVqHVDb7twQqJDwsEzwaFkXVjhgHSTbeDZWwTsnfLt51MJ7A7zahg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784872; c=relaxed/simple;
	bh=IQE2oP+ksiR93KtT9z8jelZOLHie9YqKPnXKJ4tRm/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sisJjJByJ2is76koMGJ/9H5AEs8fGb6yit2HXpuJHG6WYrsryjL43OBxzlhdgy4DDsZML01LqrN3LWnu4l1khxPG2h/NAuehVpfYyFET+i8RQPpo19b6PRzXhyP46VGu+Rf6ZCsAnaFLHZh4dePr3MSeQZ0o+Zx0wy+m69Sxbu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sQuPO5N+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sQuPO5N+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Xeuz6GTtKnueOqmpBz4bT2dNJo6qzX41cm1Bk+9Nimk=; b=sQuPO5N+IHaP91HlRzzsRmx/RV
	IGV2o18iAWrzWgv6kEvf0Q5rdmwbDrddqOsBGZUMd0Jo6gG8glKVGzVrwxKX6OYaKT59vSQlDfzp5
	eV9vHx7IWQxYRvQ2aK5g1h0d0CrDuYQM+uX0T5Fvj4wdWNC3Mwa5m6tgzhF0D70MWk1MzSCjjOW2Z
	IW5ib10iwvFGXQj1ieYoWJkz8JIC5w+JEwMSl21ch5jX4hcyayxC099ytiSOWdYL6oQEdGy+3uML0
	megopn3I2fx8cAh1Pmg4dBn5VD/HL9//I8P2vVMVw8CMa+/ogG2ejRqSH8mdzOgeKU/399Eu267lh
	xecdnhvg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrjR-0000000DLTm-20FV;
	Mon, 22 Apr 2024 11:21:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 13/13] xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)
Date: Mon, 22 Apr 2024 13:20:19 +0200
Message-Id: <20240422112019.212467-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   | 3 ++-
 fs/xfs/xfs_iomap.c   | 2 --
 fs/xfs/xfs_iops.c    | 2 +-
 fs/xfs/xfs_rtalloc.c | 2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2aec7ab59aeb7f..3c843223b4edd3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -58,7 +58,8 @@ xfs_get_extsz_hint(
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
index bba5a0d87d0386..9ce0f6b9df93e6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1001,8 +1001,6 @@ xfs_buffered_write_iomap_begin(
 		return xfs_direct_write_iomap_begin(inode, offset, count,
 				flags, iomap, srcmap);
 
-	ASSERT(!XFS_IS_REALTIME_INODE(ip));
-
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 7f0c840f0fd2fb..ad76704ab1332f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -525,7 +525,7 @@ xfs_stat_blksize(
 	 * always return the realtime extent size.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip));
+		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip) ? : 1);
 
 	/*
 	 * Allow large block sizes to be reported to userspace programs if the
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 86f928d30feda9..b476a876478d93 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1341,6 +1341,8 @@ xfs_bmap_rtalloc(
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
+	if (!align)
+		align = 1;
 retry:
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
-- 
2.39.2

