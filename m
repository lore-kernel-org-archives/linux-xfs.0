Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335E3A1DF
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537457; cv=none; b=SM0Y5DUS9eK488SslJy42Y/pcps4QfhbDbLo1aGB1/lpKpQUDu07Ay/J+KxI+oIkUCT7opDySDgRnQnSjneNUt5sCz9oj8hy44xRug+K33rE8EQ2bzJsoHyr26IrswRyEyWo3xn6VMXkEwUMhUj+fW/ni04Mi72Utu86NeIyvGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537457; c=relaxed/simple;
	bh=LSRZ/sxUBQ6GwATMmPWw3eKFgbfFDJcFKnt6SijWYeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g5eEyvM6YBNIMfw41tVyU9E9tE1d+sEVb/2UOOHrztKgg3UW5MFkRP9Qcm5clXbnk3ElmvB4Hw1kDW/EenMATNNRlHLZW2xJwetgTElJb7uI/tBHsSojrm3jZyR5U94W2rKHNMcmqWP+Cq673CbnlUuqz+YcBIfZqj1EcrsUaGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xaHMGQdn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xaHMGQdn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tfSFNGNiakjxq3nZTw1O4JJXSwcAY+3XwaV7gPQy0Hg=; b=xaHMGQdnvwod85+tPwuZokbO7V
	NM2MObFi2i0U6HOANHawDNHEJPyWMgb96JOeFAvxK0MEc3gPgMm65UhoXjX2+UQUkaj/WMwNa+kA5
	L9b7whIGkfWM51Y3Sq48ENW2NXhb4Pb/J9UFP1oXjNF0hqcyV0mhoH8gQbm2i38IWZDpuML/Nx0xH
	Zlz+Ag28+U5jDYiUrj3V1jEvGJRZJr9PQg4nJppotRoFAKuWWzGuzv7Q4wUnks7cUEI3XLLQe8Diw
	0zAt1DPp2gER7qt3VZo0F9KgE95rheEKNf6s9gdo2t5+0fe6SBmxye4EC3Yxznbm/tWF0NxQONCJs
	LzKhUO3w==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4p-00000008WrW-0HbZ;
	Wed, 27 Mar 2024 11:04:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/13] xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)
Date: Wed, 27 Mar 2024 12:03:18 +0100
Message-Id: <20240327110318.2776850-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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

