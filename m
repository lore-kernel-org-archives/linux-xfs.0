Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F401176056
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708445344; cv=none; b=tPkPl0buVjxevClkIYJbrNyvYKACO9HbPznF/d0ncrMrovRVO4beEliLf9UDCXbJtOZ0CpvIn65OEP5j8hZmawBXapN5mA6fiLWNCbg+B6EwJuk69QuJszxQqSY+ODB49yUYGUa1h6dMXBZQ5jh6lRkramxBbX91hYc1VzH9CBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708445344; c=relaxed/simple;
	bh=hF/OJDuodzYW0bK2ZNbMnqjJFFsXbozVi/UgCNaLMm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fh6nodZFkJwMKA5R5gAbeVWzcMCoyX5tuukyW+/+zF0Y+2bqAmqvrlvdwABTb+dnNsr0qOleIuTAF8t6Eqe4XjWP1XFVNsNSuF3qg2am/Rpg+nVbMlzVDEUhmpWl6jVCKphQCbFKCAfh8HmT0rE9erhbMpUVLFs19mz6dsPD1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD4A068D07; Tue, 20 Feb 2024 17:08:58 +0100 (CET)
Date: Tue, 20 Feb 2024 17:08:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: split xfs_mod_freecounter
Message-ID: <20240220160858.GA18908@lst.de>
References: <20240219063450.3032254-1-hch@lst.de> <20240219063450.3032254-4-hch@lst.de> <ZdPiaP+tApjr4K+M@dread.disaster.area> <20240220072821.GA10025@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220072821.GA10025@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 08:28:21AM +0100, Christoph Hellwig wrote:
> So we should be fine here, but the code could really use documentation,
> a few more asserts and a slightly different structure that makes this
> more obvious.  I'll throw in a patch for that.

This is what I ended up with:

---
From 22cba925f1f94b22cfa6143a814f1d14a3521621 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Feb 2024 08:35:27 +0100
Subject: xfs: block deltas in xfs_trans_unreserve_and_mod_sb must be positive

And to make that more clear, rearrange the code a bit and add asserts
and a comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 12d45e93f07d50..befb508638ca1f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -594,28 +594,38 @@ xfs_trans_unreserve_and_mod_sb(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
-	int64_t			blkdelta = 0;
-	int64_t			rtxdelta = 0;
+	int64_t			blkdelta = tp->t_blk_res;
+	int64_t			rtxdelta = tp->t_rtx_res;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
 	int			error;
 
-	/* calculate deltas */
-	if (tp->t_blk_res > 0)
-		blkdelta = tp->t_blk_res;
-	if ((tp->t_fdblocks_delta != 0) &&
-	    (xfs_has_lazysbcount(mp) ||
-	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
+	/*
+	 * Calculate the deltas.
+	 *
+	 * t_fdblocks_delta and t_frextents_delta can be positive or negative:
+	 *
+	 *  - positive values indicate blocks freed in the transaction.
+	 *  - negative values indicate blocks allocated in the transaction
+	 *
+	 * Negative values can only happen if the transaction has a block
+	 * reservation that covers the allocated block.  The end result is
+	 * that the calculated delta values must always be positive and we
+	 * can only put back previous allocated or reserved blocks here.
+	 */
+	ASSERT(tp->t_blk_res || tp->t_fdblocks_delta >= 0);
+	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 	        blkdelta += tp->t_fdblocks_delta;
+		ASSERT(blkdelta >= 0);
+	}
 
-	if (tp->t_rtx_res > 0)
-		rtxdelta = tp->t_rtx_res;
-	if ((tp->t_frextents_delta != 0) &&
-	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
+	ASSERT(tp->t_rtx_res || tp->t_frextents_delta >= 0);
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		rtxdelta += tp->t_frextents_delta;
+		ASSERT(rtxdelta >= 0);
+	}
 
-	if (xfs_has_lazysbcount(mp) ||
-	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
+	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		idelta = tp->t_icount_delta;
 		ifreedelta = tp->t_ifree_delta;
 	}
-- 
2.39.2

