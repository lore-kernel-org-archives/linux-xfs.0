Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE48146A67
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784836; cv=none; b=saNR63vfwfI5X4zY3ga86ZUbsVt6E1PZ7VDDVlG9CHz4GhEoowNO6fW99EY8FsTuJB+egIffcdOylpeAQ8aqfz4DUR0ywrx7UaPTQN3shSQYwcMG6pXf4/PWkpSp6xObPf/x9gLyoT3ASY9wWe8IKq1AT+FVQeFkuqVDXWxA1ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784836; c=relaxed/simple;
	bh=xmYQX0cFxn0YVRbcrVaKaIO/EIdYEkQNLpn41pdzLXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YNuN27pSfCJthOoRSlGlFWKonVYV8bM5qin9k4S84NN6iQpD8LSrzAydIX27ZDavo9WmaLL8NLx8w7VyHMzsIDTBvWt0PyE/nNG+PZfAx+FI0bQYQ2TM33H877VmOnSPIyzwqngmZNv6hlDQO/OCHIt/EtQR0cG6EGP63IWJf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zvUQ5IWJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zvUQ5IWJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tBIuhGsbLN9YvNUGQvk4w83s1IwVxLQ7NnmNDAJSOtI=; b=zvUQ5IWJU8sRTR4WGgYnsH7i8W
	aDf+RRjvidADgzrMAsH/ZgyxyffU2Hkg3PdITuKg4YY5So8GLeEMUlQeqVxqi1d8UOHLetU4jpPOa
	y2W9Us9MYcFblG851nWuT6nOWS6Beruzs7e4ar0qi7gYrG8T0b5UPK3HFJRUtArvUNtL4dvA15+Qa
	yWFpDJ73sBqSrbRI6/qocAHjzIFj7EgOW5fasDqL9uGMkTzSg+JcvNlq2mUgWMiXWPpAmLzIjl3bb
	hauuiHGIC0IIzkJeTGfpNc4OoFwGsbtkrWmRg/Cdtm1jM9NdS2ct+ePDweCJM6N+E6bCSgtq2BgG0
	Te52fIaA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrir-0000000DL2R-1vdu;
	Mon, 22 Apr 2024 11:20:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 03/13] xfs: free RT extents after updating the bmap btree
Date: Mon, 22 Apr 2024 13:20:09 +0200
Message-Id: <20240422112019.212467-4-hch@lst.de>
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

Currently xfs_bmap_del_extent_real frees RT extents before updating
the bmap btree, while it frees regular blocks after performing the bmap
btree update for convoluted historic reasons.  Switch to free the RT
blocks in the same place as the regular data blocks instead to simply
the code and fix a very theoretical bug.

A short history of this code researched by Dave Chiner below:

The truncate for data device extents was originally a two-phase
operation. First it removed the bmapbt record, but because this can
free BMBT extents, it can use up all the free space tree reservation
space. So the transaction gets rolled to commit the BMBT change and
the xfs_bmap_finish() call that frees the data extent runs with a
new transaction reservation that allows different free space btrees
to be logged without overrun.

However, on crash, this could lose the free space because there was
nothing to tell recovery about the extents removed from the BMBT,
hence EFIs were introduced. They tie the extent free operation to the
bmapbt record removal commit for recovery of the second phase of the
extent removal process.

Then RT extents came along. RT extent freeing does not require a
free space btree reservation because the free space metadata is
static and transaction size is bound. Hence we don't need to care if
the BMBT record removal modifies the per-ag free space trees and we
don't need a two-phase extent remove transaction. The only thing we
have to care about is not losing space on crash.

Hence instead of recording the extent for freeing in the bmap list
for xfs_bmap_finish() to process in a new transaction, it simply
freed the rtextent directly. So the original code (from 1994) simply
replaced the "free AG extent later" queueing with a direct free.

This code was originally at the start of xfs_dmap_del_extent(), but
the xfs_bmap_add_free() got moved to the end of the function via the
"do_fx" flag (the current code logic) in 1997 (commit c4fac74eaa58
in the historic xfs-import tree) because there was a shutdown occurring
because of a case where splitting the extent record failed because the
BMBT split and the filesystem didn't have enough space for the split to
be done. (FWIW, I'm not sure this can happen anymore.)

The commit backed out the BMBT change on ENOSPC error, and in doing
so I think this actually breaks RT free space tracking. However, it
then returns an ENOSPC error, and we have a dirty transaction in the
RT case so this will shut down the filesysetm when the transaction
is cancelled. Hence the corrupted "bmbt now points at freed rt dev
space" condition never make it to disk, but it's still the wrong way
to handle the issue.

IOWs, this proposed change fixes that "shutdown at ENOSPC on rt
devices" situation that was introduced by the above commit back in
1997.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3e56173a8fe4db..f529aa40710924 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5109,8 +5109,7 @@ xfs_bmap_del_extent_real(
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			do_fx;	/* free extent at end of routine */
-	int			error;	/* error return value */
+	int			error = 0;	/* error return value */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5153,20 +5152,10 @@ xfs_bmap_del_extent_real(
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
@@ -5314,18 +5303,21 @@ xfs_bmap_del_extent_real(
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

