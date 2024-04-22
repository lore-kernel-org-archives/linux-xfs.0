Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0411146597
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784851; cv=none; b=E761OGb421omwCEvU1YQ5sfH4T/O8PUGvPuuX0NqDCbtUJJ1MhUYkffbo2w4YLf5xtGHUWqI63GNXAr3ycS2dppVDFBRIiRRQ8zMCwt4WVCiPG/47GirnKtbVSQCdhrax9E0ZIgZXLwwadUi3yGv6tpz3O6oOLkdbAcXIfk1nnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784851; c=relaxed/simple;
	bh=x0ptzFspxX2J468gdqtqdsMFU1PZvuG652BW0xej7fY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FyFIJLp6UTxojEmVB+z5+YnDqI6E9+rTRZMZMPPNyuliSd+5XQkl4/+v5eFac9mlZ/+eW8ZrHkxLt53/Vol9XIO80I1Saw4DYEqy4NTW7zpisgVTClOm4+0aAAVntFWieRu9SfTADKLO3bypkxV1kjeT8NlHYZSt4y42gHJx4h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nxemmGpr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nxemmGpr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zkvDpa9VzNIfcNARyAIX6ldSJrRXoDcKl/OcacO+clg=; b=nxemmGprq20gYr+7rg0MyO+QPL
	qgISqOUOxdKMH2mX2OLV2/KufRvvbx0GQJ5Gzef3lbuopd43+8PK7/qYNucT1qLEwlhKcDiXXcbxZ
	gRnQkuWirACYX+3g0a5JM4xGltcEnmkHJGzfJGzywtGY3sKeXZe/ir2yuRe1ZV9Gtj60pwj1viEgC
	OwT+rGCkkx9RmwnEkinFhm2MOf82YlzSG6vJFc6DWI3VRR2v/WlyJ5ySoqAdOAIeCUKDGwEBNmyxS
	MeumL7xKxPU1ncXQMYpfQCOkZ5PqTk/rHTrOcaqnt6YP4Qi1cJyktVK+XWWsjz/Ut/awA42JKLza0
	7mJhq0fA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrj5-0000000DLEZ-42U1;
	Mon, 22 Apr 2024 11:20:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 07/13] xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
Date: Mon, 22 Apr 2024 13:20:13 +0200
Message-Id: <20240422112019.212467-8-hch@lst.de>
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

Allocate data blocks for RT inodes using xfs_dec_frextents.  While at
it optimize the data device case by doing only a single xfs_dec_fdblocks
call for the extent itself and the indirect blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0311a98df1c59d..f14224ff4d561d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4069,6 +4069,7 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
+	uint64_t		fdblocks;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
@@ -4111,14 +4112,18 @@ xfs_bmapi_reserve_delalloc(
 	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
 	ASSERT(indlen > 0);
 
-	error = xfs_dec_fdblocks(mp, alen, false);
-	if (error)
-		goto out_unreserve_quota;
+	fdblocks = indlen;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = xfs_dec_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		if (error)
+			goto out_unreserve_quota;
+	} else {
+		fdblocks += alen;
+	}
 
-	error = xfs_dec_fdblocks(mp, indlen, false);
+	error = xfs_dec_fdblocks(mp, fdblocks, false);
 	if (error)
-		goto out_unreserve_blocks;
-
+		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
 	xfs_mod_delalloc(ip->i_mount, alen + indlen);
@@ -4142,8 +4147,9 @@ xfs_bmapi_reserve_delalloc(
 
 	return 0;
 
-out_unreserve_blocks:
-	xfs_add_fdblocks(mp, alen);
+out_unreserve_frextents:
+	if (XFS_IS_REALTIME_INODE(ip))
+		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, alen));
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
-- 
2.39.2

