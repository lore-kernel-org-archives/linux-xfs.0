Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8322449EB6
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853090; cv=none; b=LLjnfmF17VeiLgijEVH3kMJ4HN40axIhoftJUqaw4fdZUlSA04n+3RBeGJbVsPafd5dNKeTBVTQXcaMIZLMlM6cff9qc0f5Dpb7iwof1/5+iSGrAsal2B1INq1JiAl3Xy7SSY1qeSd2v0zxG2BPyDHUT1AmhXqZ+j37V60Ba+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853090; c=relaxed/simple;
	bh=YYfIpIdy4nL3R6dT1EVJYZLSlTBgpDZICFJMAbadYwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQRCApUNV7HIimqcEr6UFQqjzfPOQY3KirAwK9eUj+HGkvWkA/MlwoohO6oiDlhydNQ9jFLO2La3s3eZw0FKGepBqUIioCE86T6MNnlRXnXi0oSqlouuOtHy2ZwRGikKvvzpC6XOLWE2YX32/W7wmPK6dQ4OuqLFrdq23inOq7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oihDxrh6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oihDxrh6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bFpKDxfgjaidNG5wh66NU0FdW1EA790zF2GhUYOB/9k=; b=oihDxrh6eJ0+FmqQlDKqCyr9IS
	YXpUGVsEZN4UpPqo1R8JLCgn+rBvP5iwBMhjKs1dwgOdfSLRX8RD7BqU/ylsZYRmwMVEpOlKk0CVL
	MD89p4/byZZ1GHzV9aHRRNWHVjpotoBp6uG0S1fNAcCICyRoRojpecJ5zAY4oSl6BuXgd7CdH929+
	YioAZ11wt3BNlEtCXOEA+2unNd8RpGgYS1CP93PosZgdKF7qNwXZ53jqZYPzn9+avTPe/3jTG5Xzh
	BTbuxaSEDIqBCknsy6M9PCW9hR4W3GRjSc+fpiis+77+RzNb830wX2wlpQ0vhtndOKHO0qIXRItUD
	Odxcc2Cw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswl-00000008UYy-2JB7;
	Fri, 15 May 2026 13:51:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Date: Fri, 15 May 2026 15:50:26 +0200
Message-ID: <20260515135103.4042407-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a small wrapper for initializing the rmap owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/libxfs/xfs_rmap.h | 2 ++
 fs/xfs/scrub/bmap.c      | 6 +++---
 fs/xfs/scrub/reap.c      | 3 +--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 066d13e97ec9..9920e2df62b0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -819,7 +819,7 @@ xfs_bmap_local_to_extents(
 	args.mp = ip->i_mount;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+	xfs_rmap_inode_owner(&args.oinfo, ip, whichfork, 0);
 
 	/*
 	 * Allocate a block.  We know we need only one, since the
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 7188459f61cf..6016fd5fcad9 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -37,6 +37,8 @@ xfs_rmap_ino_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
+	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 2ad223f0bc8a..67861102cdb9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -352,7 +352,7 @@ xchk_bmap_rt_iextent_xref(
 	case XFS_DATA_FORK:
 		xchk_bmap_xref_rmap(info, irec, rgbno);
 		if (!xfs_is_reflink_inode(info->sc->ip)) {
-			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+			xfs_rmap_inode_owner(&oinfo, info->sc->ip,
 					info->whichfork, irec->br_startoff);
 			xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
 					irec->br_blockcount, &oinfo);
@@ -407,7 +407,7 @@ xchk_bmap_iextent_xref(
 	case XFS_DATA_FORK:
 		xchk_bmap_xref_rmap(info, irec, agbno);
 		if (!xfs_is_reflink_inode(info->sc->ip)) {
-			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+			xfs_rmap_inode_owner(&oinfo, info->sc->ip,
 					info->whichfork, irec->br_startoff);
 			xchk_xref_is_only_owned_by(info->sc, agbno,
 					irec->br_blockcount, &oinfo);
@@ -419,7 +419,7 @@ xchk_bmap_iextent_xref(
 		break;
 	case XFS_ATTR_FORK:
 		xchk_bmap_xref_rmap(info, irec, agbno);
-		xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+		xfs_rmap_inode_owner(&oinfo, info->sc->ip,
 				info->whichfork, irec->br_startoff);
 		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
 				&oinfo);
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index cd90ecae3ffb..fcd14c1703ea 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1249,8 +1249,7 @@ xreap_bmapi_select(
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
 			sc->sa.pag);
 
-	xfs_rmap_ino_owner(&oinfo, rs->ip->i_ino, rs->whichfork,
-			imap->br_startoff);
+	xfs_rmap_inode_owner(&oinfo, rs->ip, rs->whichfork, imap->br_startoff);
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, &oinfo, crosslinked);
 	if (error)
 		goto out_cur;
-- 
2.53.0

