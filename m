Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D191534F5
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 18:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712168612; cv=none; b=IDqYTF30jvSNYfRXaojiI+lc1o6cmJ5DOxe0BKRrwSewtHYmi7J8oQgMVA+v4hf4Kmu4nOjqhehnWZuXauWFeyIY2mCNOQOIeSwDNMWOwetKA7nBr24FG907dyGoPjDHe9wBeXu0wvX3q3PVic3XRMKbFc4F+c7MTSB8zSWPijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712168612; c=relaxed/simple;
	bh=pBgMOLCRxueTmidWkRqh9O1pX+ZXhSiA4GabTpxvpXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsD+OnfY6dUGR3yoETsEbO2Q+DK7McsezVXB3wyFKZYelsxikFhF/S2kpwKRDHN9qhREj8m+WbqucVSsVaJQF7pp68ZHkoWzPy2KPJDwPacjK9wA/ER15UtyqeOtbpq5TOXATvqQp9kFVKAY072mHV/arc3aSiHRY9p+i+ynK+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YFb1ozwS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YFb1ozwS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SFc51O8wxttq2O6E5PnfjjTgUXklYnsvh4anH1eV4EM=; b=YFb1ozwS8I55osvLjQZXJAbY7l
	nMe9mgB/7GglTq0zZVB69TQ5UNfR4q4YaIgEUSBR/VARtunMFdDcOjei1JzbUzSLQpnp28gntItg4
	JRcutJbyiC/LNxbtBL4+NP50L2VPAAmO/tuH1Yr6PkBo5T4w02VimM2A1+0RbRr1LT+yGpgk6sgkl
	5cySXsNeC6uMdrqR/ttMJs6MlJUJzlsqr70MYY9I4S56pMqHoijAG1i/zvCtl/1jxlAd1QRnKK2X2
	gRU2o3s/Il3SRDi+hiMxo72E8uFX0FRUNVjY8TzrYW/LFbejPOed9KFzKdlHYDmZSo0QJzDMJkCuP
	Uyd0nljA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rs5Gi-0000000HNEr-2oiU;
	Wed, 03 Apr 2024 18:23:28 +0000
Date: Wed, 3 Apr 2024 11:23:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH 2/4] xfs: xfs_alloc_file_space() fails to detect ENOSPC
Message-ID: <Zg2eoPeRuPOaeRAd@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-3-david@fromorbit.com>
 <ZgzdtYGyVN1-UQdM@infradead.org>
 <Zgz4YXUp+fFEN3qp@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zgz4YXUp+fFEN3qp@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 05:34:09PM +1100, Dave Chinner wrote:
> Given that the fix was for something that doesn't currently exist
> (RT delalloc) the only sane thing to do right now is revert the fix
> and push that revert back to the stable kernels that are susceptible
> to this livelock. 

That was how I originally found it.  I reproduced the problem with
the normal allocator and very small AGs since then.

Anyway, here is what I came up with today.  TL;DR: xfs_bmapi_write
calling conventions are complete fucked up and I'm amazed we've survived
this far.

---
From 80bb655563fad9757c141df4c47ce9701ed4926a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 3 Apr 2024 11:04:07 +0200
Subject: xfs: fix error returns from xfs_bmapi_write

xfs_bmapi_write can return 0 without actually returning a mapping in
mval in two different cases:

 1) when there is absolutely no space available to do an allocation
 2) when converting delalloc space, and the allocation is so small
    that it only covers parts of the delalloc extent before the
    range requested by the caller

Callers at best can handle one of these cases, but in many cases can't
cope with either one.  Switch xfs_bmapi_write to always return a
mapping or return an error code instead.  For case 1) above ENOSPC is
the obvious choice which is very much what the callers expect anyway.
For case 2) there is no really good error code, so pick a funky one
from the SysV streams portfolio.

This fixes the reproducer here:

    https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com0/

which uses reserved blocks to create file systems that are gravely
out of space and thus cause at least xfs_file_alloc_space to hang
and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/libxfs/xfs_bmap.c        | 43 ++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++-----------
 fs/xfs/scrub/quota_repair.c     |  6 -----
 fs/xfs/scrub/rtbitmap_repair.c  |  2 --
 fs/xfs/xfs_bmap_util.c          | 31 ++++++++++++------------
 fs/xfs/xfs_dquot.c              |  1 -
 fs/xfs/xfs_iomap.c              |  8 ------
 fs/xfs/xfs_reflink.c            | 14 -----------
 fs/xfs/xfs_rtalloc.c            |  2 --
 10 files changed, 57 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index ff04128287720a..41a02dcc2541b0 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -626,7 +626,6 @@ xfs_attr_rmtval_set_blk(
 	if (error)
 		return error;
 
-	ASSERT(nmap == 1);
 	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
 	       (map->br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e6d..631fd454a832cd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4226,8 +4226,10 @@ xfs_bmapi_allocate(
 	} else {
 		error = xfs_bmap_alloc_userdata(bma);
 	}
-	if (error || bma->blkno == NULLFSBLOCK)
+	if (error)
 		return error;
+	if (bma->blkno == NULLFSBLOCK)
+		return -ENOSPC;
 
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
@@ -4406,6 +4408,15 @@ xfs_bmapi_finish(
  * extent state if necessary.  Details behaviour is controlled by the flags
  * parameter.  Only allocates blocks from a single allocation group, to avoid
  * locking problems.
+ *
+ * Returns 0 on success and places the extent mapings in mval.  nmaps is used as
+ * an input/output parameter where the caller specifies the maximum number
+ * before calling xfs_bmapi_write, and xfs_bmapi_write passes the  number of
+ * mappings (including existing mappings) it found.
+ *
+ * Returns a negative error code on failure, including -ENOSPC when it could not
+ * allocate any blocks and -ENOSR when it did allocated blocks to convert a
+ * delalloc range, but those blocks were before the passed in range.
  */
 int
 xfs_bmapi_write(
@@ -4534,10 +4545,16 @@ xfs_bmapi_write(
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
-			if (error)
+			if (error) {
+				/*
+				 * If we already allocated space in a previous
+				 * iteration return what we go so far when
+				 * running out of space.
+				 */
+				if (error == -ENOSPC && bma.nallocs)
+					break;
 				goto error0;
-			if (bma.blkno == NULLFSBLOCK)
-				break;
+			}
 
 			/*
 			 * If this is a CoW allocation, record the data in
@@ -4575,7 +4592,6 @@ xfs_bmapi_write(
 		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
 			eof = true;
 	}
-	*nmap = n;
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -4586,7 +4602,22 @@ xfs_bmapi_write(
 	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
-		orig_nmap, *nmap);
+		orig_nmap, n);
+
+	/*
+	 * When converting delayed allocations, xfs_bmapi_allocate ignores
+	 * the passed in bno and always converts from the start of the found
+	 * delalloc extent.
+	 *
+	 * To avoid a successful return with *nmap set to 0, return the magic
+	 * -ENOSR error code for this particular case so that the caller can
+	 * handle it.
+	 */
+	if (!n) {
+		ASSERT(bma.nallocs >= *nmap);
+		return -ENOSR;
+	}
+	*nmap = n;
 	return 0;
 error0:
 	xfs_bmapi_finish(&bma, whichfork, error);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 718d071bb21ae3..276c710548b5a7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2167,8 +2167,8 @@ xfs_da_grow_inode_int(
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
 	xfs_rfsblock_t		nblks = dp->i_nblocks;
-	struct xfs_bmbt_irec	map, *mapp;
-	int			nmap, error, got, i, mapi;
+	struct xfs_bmbt_irec	map, *mapp = &map;
+	int			nmap, error, got, i, mapi = 1;
 
 	/*
 	 * Find a spot in the file space to put the new block.
@@ -2184,14 +2184,7 @@ xfs_da_grow_inode_int(
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->total, &map, &nmap);
-	if (error)
-		return error;
-
-	ASSERT(nmap <= 1);
-	if (nmap == 1) {
-		mapp = &map;
-		mapi = 1;
-	} else if (nmap == 0 && count > 1) {
+	if (error == -ENOSPC && count > 1) {
 		xfs_fileoff_t		b;
 		int			c;
 
@@ -2209,16 +2202,13 @@ xfs_da_grow_inode_int(
 					args->total, &mapp[mapi], &nmap);
 			if (error)
 				goto out_free_map;
-			if (nmap < 1)
-				break;
 			mapi += nmap;
 			b = mapp[mapi - 1].br_startoff +
 			    mapp[mapi - 1].br_blockcount;
 		}
-	} else {
-		mapi = 0;
-		mapp = NULL;
 	}
+	if (error)
+		goto out_free_map;
 
 	/*
 	 * Count the blocks we got, make sure it matches the total.
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 0bab4c30cb85ab..90cd1512bba961 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -77,8 +77,6 @@ xrep_quota_item_fill_bmap_hole(
 			irec, &nmaps);
 	if (error)
 		return error;
-	if (nmaps != 1)
-		return -ENOSPC;
 
 	dq->q_blkno = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
 
@@ -444,10 +442,6 @@ xrep_quota_data_fork(
 					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
 			if (error)
 				goto out;
-			if (nmap != 1) {
-				error = -ENOSPC;
-				goto out;
-			}
 			ASSERT(nrec.br_startoff == irec.br_startoff);
 			ASSERT(nrec.br_blockcount == irec.br_blockcount);
 
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 46f5d5f605c915..0fef98e9f83409 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -108,8 +108,6 @@ xrep_rtbitmap_data_mappings(
 				0, &map, &nmaps);
 		if (error)
 			return error;
-		if (nmaps != 1)
-			return -EFSCORRUPTED;
 
 		/* Commit new extent and all deferred work. */
 		error = xrep_defer_finish(sc);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 19e11d1da66074..fbca94170cd386 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -721,33 +721,32 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
-		if (error)
-			goto error;
-
-		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			break;
-
 		/*
 		 * If the allocator cannot find a single free extent large
 		 * enough to cover the start block of the requested range,
-		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 * xfs_bmapi_write will return -ENOSR.
 		 *
 		 * In that case we simply need to keep looping with the same
 		 * startoffset_fsb so that one of the following allocations
 		 * will eventually reach the requested range.
 		 */
-		if (nimaps) {
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				&nimaps);
+		if (error) {
+			if (error != -ENOSR)
+				goto error;
+			error = 0;
+		} else {
 			startoffset_fsb += imapp->br_blockcount;
 			allocatesize_fsb -= imapp->br_blockcount;
 		}
+
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c98cb468c35780..0c9eb8fdeec082 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -357,7 +357,6 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
-	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 	       (map.br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4087af7f3c9f3f..42155cedefb77d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -321,14 +321,6 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_unlock;
 
-	/*
-	 * Copy any maps to caller's array and return any error.
-	 */
-	if (nimaps == 0) {
-		error = -ENOSPC;
-		goto out_unlock;
-	}
-
 	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
 		error = xfs_alert_fsblock_zero(ip, imap);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7da0e8f961d351..5ecb52a234becc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -430,13 +430,6 @@ xfs_reflink_fill_cow_hole(
 	if (error)
 		return error;
 
-	/*
-	 * Allocation succeeded but the requested range was not even partially
-	 * satisfied?  Bail out!
-	 */
-	if (nimaps == 0)
-		return -ENOSPC;
-
 convert:
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
@@ -499,13 +492,6 @@ xfs_reflink_fill_delalloc(
 		error = xfs_trans_commit(tp);
 		if (error)
 			return error;
-
-		/*
-		 * Allocation succeeded but the requested range was not even
-		 * partially satisfied?  Bail out!
-		 */
-		if (nimaps == 0)
-			return -ENOSPC;
 	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
 
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e66f9bd5de5cff..46ee8093f797a6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -709,8 +709,6 @@ xfs_growfs_rt_alloc(
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
 					XFS_BMAPI_METADATA, 0, &map, &nmap);
-		if (!error && nmap < 1)
-			error = -ENOSPC;
 		if (error)
 			goto out_trans_cancel;
 		/*
-- 
2.39.2

