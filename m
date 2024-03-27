Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAF852F7F
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537417; cv=none; b=V/w3/R90X6645t1VPdjfFbP4d7bUcwI8mygOdNQPEa9gcfbwmaf4pNUHP2EJ541e8ki++Egp2oNKwzutiY0/Jv7DDJ5tXSjeFNhZzRB8rvbFwyv8zxM6B8JTca0WzekqvKOibwWsZe10OlYw8fctAvmaSdD9uCdwE2Mm3X+5fZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537417; c=relaxed/simple;
	bh=9YL5qVdYU5OIRUzs+jRrSQVXudlaiID/GNwzujVNnBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SoHKs7rIR3UQfjEES9J9jlUv/2s3c+aF2OAHB99FSdGEsvMNATBhHyK+FGsVgTO7T7bd5U2fcV/NNTQZW4k6WO5yEQBkA9MUesC4JfykjP04bnAARwrGCNIF5jE4lXEdokQE6iRpebJyqXOLS8mRBJhJA3TNXKupECRh1adOEjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZR8Awnk4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZR8Awnk4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SEr42SdM2jstg+7odbfp3hSICz4yQeOBrqnXwmvkkTc=; b=ZR8Awnk4ykoy80iqqfWyjYVmC4
	9MypvAK1hZMGZQ/q3V5QO82lTI67ozS6SuDkwUblm5HyA9Oo9jCn0gQWF76bKNCwqa+GZchJtQn8v
	y6uhcnRwnqBhvFMJpxMH2k21vs2Gnnrd82tsHeh0pgQmB3NTaJyTFrJGbAyK7f7B6UEENPT3Mfug3
	ZXo1V3PoRI3Xwl1JEmj9k9Hhfg5HXf+XbRSS4UUJr1MJtEcwK+y+7lzKULnAseVNlfCExzYNk6Myh
	VQhALmw9ArYCPzu9IERNeZpldTQMMgevoVmCeIAHZtZv95fPa+IhZX7s4pQgd8MeN2b+3C8EmaRhV
	M04HtIUA==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR49-00000008WYS-0ZT8;
	Wed, 27 Mar 2024 11:03:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] xfs: free RT extents after updating the bmap btree
Date: Wed, 27 Mar 2024 12:03:08 +0100
Message-Id: <20240327110318.2776850-4-hch@lst.de>
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

Currently xfs_bmap_del_extent_real frees RT extents before updating
the bmap btree, while it frees regular blocks after performing the bmap
btree update.  While this behavior goes back to the original commit,
I can't find any good reason for handling RT extent vs regular block
freeing differently.  We use the same transaction, and unless rmaps
or reflink are enabled (which currently aren't support for RT inodes)
there are no transactions rolls or deferred ops that can rely on this
ordering.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 09d4b730ee9709..282b44deb9f864 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5107,8 +5107,7 @@ xfs_bmap_del_extent_real(
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			do_fx;	/* free extent at end of routine */
-	int			error;	/* error return value */
+	int			error = 0;	/* error return value */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5151,20 +5150,10 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (xfs_ifork_is_realtime(ip, whichfork)) {
-		if (!(bflags & XFS_BMAPI_REMAP)) {
-			error = xfs_rtfree_blocks(tp, del->br_startblock,
-					del->br_blockcount);
-			if (error)
-				return error;
-		}
-
-		do_fx = 0;
+	if (xfs_ifork_is_realtime(ip, whichfork))
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
-	} else {
-		do_fx = 1;
+	else
 		qfield = XFS_TRANS_DQ_BCOUNT;
-	}
 	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
@@ -5312,18 +5301,21 @@ xfs_bmap_del_extent_real(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
+	if (!(bflags & XFS_BMAPI_REMAP)) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
+		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 		} else {
 			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					XFS_AG_RESV_NONE,
 					((bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN));
-			if (error)
-				return error;
 		}
+		if (error)
+			return error;
 	}
 
 	/*
-- 
2.39.2

