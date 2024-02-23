Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1CD12E43
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672584; cv=none; b=TcZSDzeNVxomNltEbjf6/ZE6foWAADUVx63i7sOaldFU3F6SIYVEnuTQa/WCvkKWyamTSEApIaCkdUxe9NSZ2IZyXDYP7QPgH/sJiWAbUYSznVHqcfcfY6SBJXhHOEWHvPHQVw5xFOaJaHSlCD6v9pH8TEkVMUkQxAj4Sbw3OFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672584; c=relaxed/simple;
	bh=KCZa70DYZvvRNsV/omFQWfO6XgUPikdfetTKG+bLS44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=scMYWRvte5i+nH9XPkWu22wEAhbvmiVNl8XAA+EldBvLoi0o+SquaoxHnh157lzqzfXVrQ4oclAMGD2iz+hoyWVHudGRTaQ+PY/NeNttuagTcdEJNayu2X6Vdndyp+dAO7FgWbrQPdrzmIlIMjdTd3jiRZtHP95zTd2YJYlF7ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1/ckVG9B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1/ckVG9B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=04TZ01Gj8drCZSyJ50ldpq0Z70UH8OVMU/rEnQBJfOA=; b=1/ckVG9Bd5FLgyXCaUMvV+56Wl
	zsDM5BakFFtpVp04jnyNt2o0zCi+IDVCXoihYpxFOscRUFAJnV9U9hnvACYuArKT024j3Vsmw1vJx
	2c2ank03h8wvNT1rpZ4R9xaf/bRhCsbJ4U0cFdJIsCt6e3pH8/HtJwYJDqRavBNhyCRYtlN58kbXf
	ZAmrk8EMa6dlrWfOaGIlsc5Vm1ENcpQZsUWP/Bl0ZFtWH+bqnFG3PJAFroeTPXZSggyJto5HriFzg
	0raAwpNd75NzdwV/gStbFYR2ofjDnWzTODMCJJrec4B+syCmLxUoVON5yxnAHXjq96CZ9/0kybpD+
	9W94zyjg==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPnC-00000008GzR-2ase;
	Fri, 23 Feb 2024 07:16:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)
Date: Fri, 23 Feb 2024 08:15:06 +0100
Message-Id: <20240223071506.3968029-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
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
---
 fs/xfs/xfs_inode.c   | 3 ++-
 fs/xfs/xfs_iomap.c   | 2 --
 fs/xfs/xfs_iops.c    | 2 +-
 fs/xfs/xfs_rtalloc.c | 2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 37ec247edc1332..9e12278d1b62cd 100644
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
index e6abe56d1f1f23..aea4e29ebd6785 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -992,8 +992,6 @@ xfs_buffered_write_iomap_begin(
 		return xfs_direct_write_iomap_begin(inode, offset, count,
 				flags, iomap, srcmap);
 
-	ASSERT(!XFS_IS_REALTIME_INODE(ip));
-
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index be102fd49560dc..ca60ba060fd5c9 100644
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
index 2f85567f3d756b..9c7fba175b9025 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1340,6 +1340,8 @@ xfs_bmap_rtalloc(
 	int			error;
 
 	align = xfs_get_extsz_hint(ap->ip);
+	if (!align)
+		align = 1;
 retry:
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
-- 
2.39.2

