Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A341CD28
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941927; cv=none; b=C0iVK7RVjQjX1tnEaNVpOI3GcnDmeCjc9/Z/Bz6quQAJCisTzTXNIsSB34axEjXgsSFeD1rd/AES5IjBro6Z7qc3oimkTHVrSvcaqGz72/Qv26VsWMH7x5bd9oxvSrgJQlDMjieD6PAg2dVuKbcbLijgEqmrvjK3gOoADnDHoAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941927; c=relaxed/simple;
	bh=PC5Wjmj71TGAEY62qcJaM2t8k+L27kuMpLReJU3swlA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I0EtdNdT38IhZimI/E4J5rQKlN2bV5J4P1tbkfiKGBtvtPxnYZtvr5G+I3QBIsk0z7twYnrU8pGG0ddrR8Ybkoh4956WbROB3MFR6vg12O3o/W5FSXC6Df+c29lGgeLusjoVuvmll7A/gBk27ur2M2ydZ4PycYqCSVwN0gIHckI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=elMDGbhp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="elMDGbhp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8qNfOcXwWGc+0qXKJVYMWUGedgqcO9S8W3oMqodC6G0=; b=elMDGbhpJKgYTBPXE0KtfFdJDI
	vuQW+fiNfc4tt59xPxaBwNK44yiZvdUzoSUfQuR8cICUTn2pWNyPzH0llQtK1BpcP6+8a9nLdFLeg
	3mrbgQoWLuhHRhmV+4TgGcYxJAUK/+CRE8daKIHloMQMw4Am03InSv/nnmIkBoSPUXuChcB4BdZiW
	eglCF7XMvCMbQPSuzAg0HeNRZDb8Tb8yhsbBhtQYTmQK+a4d72PEOlTp7Zmssdm3bzT8FrA0jiPRe
	falSNOrzfHBLGhlKurr6GPZytcBTamDJBnZm7KLwQ0nakPjzIzK3MuV/wBOYip1AhT+JmoytxHMUa
	uXHHl0bA==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXrG-0000000HX6d-1gEs;
	Mon, 26 Feb 2024 10:05:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)
Date: Mon, 26 Feb 2024 11:04:20 +0100
Message-Id: <20240226100420.280408-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100420.280408-1-hch@lst.de>
References: <20240226100420.280408-1-hch@lst.de>
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
index 110077ca3d2a9b..acd4a722e8f7d3 100644
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
index a8267d8ef1c0ed..1bf727a1af3b09 100644
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
index b62b5c34413e7a..87d33bdd25eda3 100644
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

