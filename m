Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702B6150982
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711577732; cv=none; b=qHtkobguov8SXE4Zd6ij8J0nmbJDbw9kOA7ox7fhqmFKEkkwxrMPcXCKdkSoJAxaaZEh0A4rE2zKk0uCHoYGOT6qAz+Ag9Ip9RbOP10Q/p5LshYY9hDkRpuboyhoixd5jRhzST83ik9b5HgJk7mNQElaK7SpQjpjQGsWn4x1lDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711577732; c=relaxed/simple;
	bh=Kn3cusYVDZHZUNa3LXvOiVuGdbyazVo4kKa3YOpfwzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0qXCm5SWFBpGuqsF5IzA4trXrZYGyWhSG9Gvs7VV3dK/mJyoHYWSUS26IsqS1XftNFq5Xw+zCinub80fX6rrt5/4Lfa8oqgGj3I6+L24Kf2EPfml9rx6O/Pj8mm8YKbxEchVtRoVIRjcAj7Zm2bYlcrYhnQ0cu+6l1lULmel1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pszwNe3M; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pszwNe3M"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1def2a1aafaso2921465ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 15:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711577729; x=1712182529; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TXYmQcbiiIFQLPnU5gtnqYPo7nznLApAsppwsSMyGpI=;
        b=pszwNe3MNe5vGLmwpJtw/eCq7W1g0KmB/gwG7oXhYfOvPVdcVej/gnKjV9TjAHNNYn
         JyuvrJtSEg+Eo7MpxuRyjigoyaZEjAd6zSQLbP1DkoXu5VCtBZhWXhiWhUE4SLnd/HCF
         qqnCgblfxhk0t2/9uRnORv1KZ5NbEyl+40BMEOHFAIuv/n8UZv3+al2cztFzhHaa+jwA
         qNR0dxVXr/9e2p8JFgPi+So0cNET/oUrgk5giGcL3mFXERtoICAiyeMlTfuK9fyQuz/o
         7wERGY95ljNWQxxDmPwytGF6EthR4cOnxG86V4ovvIAVOpJ/kfP8W3oOH45U0wzAWazn
         wfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711577729; x=1712182529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXYmQcbiiIFQLPnU5gtnqYPo7nznLApAsppwsSMyGpI=;
        b=b8uCMYg4Q91PIPupvr+BeRQqBxpFmWqcmkD9zyxnRV/xs2pkEIeBJJUNQHrSfxm+lw
         rgTG4Qe9rqD8Ujf1M2C8RMXucJCtWt7EEfOKZK4frF319+vTicoV3AE3vP4vikoa4+rz
         Zpdc7mbKYWSSy9bVVp+K3PSi6X2i3snwr25qYciaMRss8K38jC06UhdNgzs/djDsflYO
         ogk2r17VNCXarS6OFL1L48yBDiCGXsJPeYcC7caOjvjpiuf6cvbSgAD/L/2ZkKxH4p8l
         Ih3s3PjM1c8SCmpypZqVIddg7rzVWRe+tFb5x9AdoxP+xe3HEovkLNI/3vwdOXeXoODk
         5HEQ==
X-Gm-Message-State: AOJu0Yx2qoNyoxS43J55p+iBDdCzaJdU5lSxoX2jjznaK0mLSrrfT/m0
	9JjAbmawpsTwads1NJfgdMWJ0E9y7hBM2G0or2nh53qakIkq0492kuzlMKMT1L9L1NyyKZgeleS
	V
X-Google-Smtp-Source: AGHT+IGF9+BFDrEQXjk1fKfZR79HVdnp/+f+oVO+JRuw11RLdRCUT25jnctHJ2pxQS9UNlQoFYedqw==
X-Received: by 2002:a17:902:6aca:b0:1df:f8a4:5485 with SMTP id i10-20020a1709026aca00b001dff8a45485mr788150plt.57.1711577729290;
        Wed, 27 Mar 2024 15:15:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902d34900b001e0b461d104sm26430plk.67.2024.03.27.15.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 15:15:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpbYL-00CO0k-2K;
	Thu, 28 Mar 2024 09:15:25 +1100
Date: Thu, 28 Mar 2024 09:15:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <ZgSaffJmGXBiXwKZ@dread.disaster.area>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS issues discard IOs while holding the free space btree and the AGF
> buffers locked.  If the discard IOs are slow, this can lead to long
> stalls for every other thread trying to access that AG.  On a 10TB high
> performance flash storage device with a severely fragmented free space
> btree in every AG, this results in many threads tripping the hangcheck
> warnings while waiting for the AGF.  This happens even after we've run
> fstrim a few times and waited for the nvme namespace utilization
> counters to stabilize.
> 
> Strace for the entire 100TB looks like:
> ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>
> 
> Reducing the size of the FITRIM requests to a single AG at a time
> produces lower times for each individual call, but even this isn't quite
> acceptable, because the lock hold times are still high enough to cause
> stall warnings:
> 
> Strace for the first 4x 1TB AGs looks like (2):
> ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
> ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
> ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
> ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

Large FITRIM runtime is not actually an AGF locking latency problem
anymore....

> The fstrim code has to synchronize discards with block allocations, so
> we must hold the AGF lock while issuing discard IOs.

... because I fixed this problem in commit 89cfa899608f ("xfs:
reduce AGF hold times during fstrim operations").

> Breaking up the
> calls into smaller start/len segments ought to reduce the lock hold time
> and allow other threads a chance to make progress.  Unfortunately, the
> current fstrim implementation handles this poorly because it walks the
> entire free space by length index (cntbt) and it's not clear if we can
> cycle the AGF periodically to reduce latency because there's no
> less-than btree lookup.

That commit also fixed this problem.

> The first solution I thought of was to limit latency by scanning parts
> of an AG at a time,

It already does this.

> but this doesn't solve the stalling problem when the
> free space is heavily fragmented because each sub-AG scan has to walk
> the entire cntbt to find free space that fits within the given range.
> In fact, this dramatically increases the runtime!  This itself is a
> problem, because sub-AG fstrim runtime is unnecessarily high.

Ah, so this is a completely different problem to what you describe
above.  i.e. The problem with "sub-ag" fstrim is simply that finding
block range limited free extents is costly in terms of overall time
and CPU usage when you do it via the by-count btree instead of the
by-bno btree...


> For sub-AG scans, create a second implementation that will walk the
> bnobt and perform the trims in block number order.  Since the cursor has
> an obviously monotonically increasing value, it is easy to cycle the AGF
> periodically to allow other threads to do work.  This implementation
> avoids the worst problems of the original code, though it lacks the
> desirable attribute of freeing the biggest chunks first.

Ok, it's fine to do a by-bno search in this case...

> On the other hand, this second implementation will be much easier to
> constrain the locking latency, and makes it much easier to report fstrim
> progress to anyone who's running xfs_scrub.

... but It doesn't change the locking latency of fstrim at all.
Locks are still only held for batches of 100 free extent lookups...

I think a commit message update is necessary. :)

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_discard.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 169 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 268bb734dc0a8..ee7a8759091eb 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -157,9 +157,9 @@ xfs_trim_gather_extents(
>  	uint64_t		*blocks_trimmed)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
> -	struct xfs_trans	*tp;
>  	struct xfs_btree_cur	*cur;
>  	struct xfs_buf		*agbp;
> +	struct xfs_trans	*tp;
>  	int			error;
>  	int			i;
>  	int			batch = 100;
> @@ -292,6 +292,160 @@ xfs_trim_gather_extents(
>  	return error;
>  }
>  
> +/* Trim the free space in this AG by block number. */
> +static inline int
> +xfs_trim_gather_bybno(
> +	struct xfs_perag	*pag,
> +	xfs_daddr_t		start,
> +	xfs_daddr_t		end,
> +	xfs_daddr_t		minlen,
> +	struct xfs_alloc_rec_incore *tcur,
> +	struct xfs_busy_extents	*extents,
> +	uint64_t		*blocks_trimmed)
> +{

I'd prefer that we don't copy-n-paste-n-subtly-modify code like
this.  There's very little different between the two gather cases -
the initial cursor setup and the loop exit criteria - so they should
be easy to use a common core loop.

> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_trans	*tp;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_buf		*agbp;
> +	xfs_daddr_t		end_daddr;
> +	xfs_agnumber_t		agno = pag->pag_agno;
> +	xfs_agblock_t		start_agbno;
> +	xfs_agblock_t		end_agbno;
> +	xfs_extlen_t		minlen_fsb = XFS_BB_TO_FSB(mp, minlen);
> +	int			i;
> +	int			batch = 100;
> +	int			error;
> +
> +	start = max(start, XFS_AGB_TO_DADDR(mp, agno, 0));
> +	start_agbno = xfs_daddr_to_agbno(mp, start);
> +
> +	end_daddr = XFS_AGB_TO_DADDR(mp, agno, pag->block_count);
> +	end = min(end, end_daddr - 1);
> +	end_agbno = xfs_daddr_to_agbno(mp, end);

I think this is the wrong place to do this.  I agree that it is
sensible to use ag-constrained agbnos here, but we should do it
properly and not make the code unnecessarily difficult to maintain
by using unconstrained daddrs in one gather function and constrained
agbnos in another. 

Here's a completely untested, uncompiled version of this by-bno
search I just wrote up to demonstrate that if we pass ag-confined
agbnos from the top level, we don't need to duplicate this gather
code at all or do trim range constraining inside the gather
functions...

-Dave.

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 268bb734dc0a..0c949dfc097a 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -145,14 +145,18 @@ xfs_discard_extents(
 	return error;
 }
 
+struct xfs_trim_cur {
+	xfs_agblock_t	start;
+	xfs_extlen_t	count;
+	xfs_agblock_t	end;
+	xfs_extlen_t	minlen;
+	bool		by_len;
+};
 
 static int
 xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
-	struct xfs_alloc_rec_incore *tcur,
+	struct xfs_trim_cur	*tcur,
 	struct xfs_busy_extents	*extents,
 	uint64_t		*blocks_trimmed)
 {
@@ -179,21 +183,21 @@ xfs_trim_gather_extents(
 	if (error)
 		goto out_trans_cancel;
 
-	cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 
-	/*
-	 * Look up the extent length requested in the AGF and start with it.
-	 */
-	if (tcur->ar_startblock == NULLAGBLOCK)
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
-	else
+	if (tcur->by_len) {
+		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_ge(cur, tcur->ar_startblock,
+				0, &i);
+	} else {
+		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
 				tcur->ar_blockcount, &i);
+	}
 	if (error)
 		goto out_del_cursor;
 	if (i == 0) {
 		/* nothing of that length left in the AG, we are done */
-		tcur->ar_blockcount = 0;
+		tcur->count = 0;
 		goto out_del_cursor;
 	}
 
@@ -221,25 +225,8 @@ xfs_trim_gather_extents(
 			 * Update the cursor to point at this extent so we
 			 * restart the next batch from this extent.
 			 */
-			tcur->ar_startblock = fbno;
-			tcur->ar_blockcount = flen;
-			break;
-		}
-
-		/*
-		 * use daddr format for all range/len calculations as that is
-		 * the format the range/len variables are supplied in by
-		 * userspace.
-		 */
-		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
-		dlen = XFS_FSB_TO_BB(mp, flen);
-
-		/*
-		 * Too small?  Give up.
-		 */
-		if (dlen < minlen) {
-			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
-			tcur->ar_blockcount = 0;
+			tcur->start = fbno;
+			tcur->count = flen;
 			break;
 		}
 
@@ -248,10 +235,35 @@ xfs_trim_gather_extents(
 		 * supposed to discard skip it.  Do not bother to trim
 		 * down partially overlapping ranges for now.
 		 */
-		if (dbno + dlen < start || dbno > end) {
+		if (fbno + flen < tcur->start) {
 			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
+		if (fbno > tcur->end) {
+			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
+			if (tcur->by_len) {
+				tcur->count = 0;
+				break;
+			}
+			goto next_extent;
+		}
+
+		/* Trim the extent returned to the range we want. */
+		if (fbno < tcur->start) {
+			flen -= tcur->start - fbno;
+			fbno = tcur->start;
+		}
+		if (fbno + flen > tcur->end + 1)
+			flen = tcur->end - fbno + 1;
+
+		/*
+		 * Too small?  Give up.
+		 */
+		if (flen < minlen) {
+			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			tcur->count = 0;
+			break;
+		}
 
 		/*
 		 * If any blocks in the range are still busy, skip the
@@ -266,7 +278,10 @@ xfs_trim_gather_extents(
 				&extents->extent_list);
 		*blocks_trimmed += flen;
 next_extent:
-		error = xfs_btree_decrement(cur, 0, &i);
+		if (tcur->by_len)
+			error = xfs_btree_increment(cur, 0, &i);
+		else
+			error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			break;
 
@@ -276,7 +291,7 @@ xfs_trim_gather_extents(
 		 * is no more extents to search.
 		 */
 		if (i == 0)
-			tcur->ar_blockcount = 0;
+			tcur->count = 0;
 	}
 
 	/*
@@ -306,17 +321,22 @@ xfs_trim_should_stop(void)
 static int
 xfs_trim_extents(
 	struct xfs_perag	*pag,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
+	xfs_agblock_t		start,
+	xfs_agblock_t		end,
+	xfs_extlen_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
-	struct xfs_alloc_rec_incore tcur = {
-		.ar_blockcount = pag->pagf_longest,
-		.ar_startblock = NULLAGBLOCK,
+	struct xfs_trim_cur	tcur = {
+		.start		= start,
+		.count		= pag->pagf_longest,
+		.end		= end,
+		.minlen		= minlen,
 	};
 	int			error = 0;
 
+	if (start != 0 || end != pag->block_count)
+		tcur.by_len = true;
+
 	do {
 		struct xfs_busy_extents	*extents;
 
@@ -330,8 +350,8 @@ xfs_trim_extents(
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
-		error = xfs_trim_gather_extents(pag, start, end, minlen,
-				&tcur, extents, blocks_trimmed);
+		error = xfs_trim_gather_extents(pag, &tcur, extents,
+					blocks_trimmed);
 		if (error) {
 			kfree(extents);
 			break;
@@ -354,7 +374,7 @@ xfs_trim_extents(
 		if (xfs_trim_should_stop())
 			break;
 
-	} while (tcur.ar_blockcount != 0);
+	} while (tcur.count != 0);
 
 	return error;
 
@@ -378,8 +398,10 @@ xfs_ioc_trim(
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
 	struct fstrim_range	range;
-	xfs_daddr_t		start, end, minlen;
+	xfs_daddr_t		start, end;
+	xfs_extlen_t		minlen;
 	xfs_agnumber_t		agno;
+	xfs_agblock_t		start_agbno, end_agbno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -399,7 +421,8 @@ xfs_ioc_trim(
 		return -EFAULT;
 
 	range.minlen = max_t(u64, granularity, range.minlen);
-	minlen = BTOBB(range.minlen);
+	minlen = XFS_B_TO_FSB(mp, range.minlen);
+
 	/*
 	 * Truncating down the len isn't actually quite correct, but using
 	 * BBTOB would mean we trivially get overflows for values
@@ -415,12 +438,23 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
+	start_agno = xfs_daddr_to_agno(mp, start);
+	start_agbno = xfs_daddr_to_agbno(mp, start);
+	end_agno = xfs_daddr_to_agno(mp, end);
+	end_agbno = xfs_daddr_to_agbno(mp, end);
 
-	agno = xfs_daddr_to_agno(mp, start);
-	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
-		error = xfs_trim_extents(pag, start, end, minlen,
+	if (end_agno >= mp->m_sb.sb_agcount ||
+	    !xfs_verify_agno_agbno(mp, end_agno, end_agbno)) {
+		end_agno = mp->m_sb.sb_agcount - 1;
+		end_agbno = xfs_ag_block_count(mp, end_agno);
+	}
+
+	for_each_perag_range(mp, start_agno, end_agno, pag) {
+		xfs_agblock_t end = mp->m_sb.sb_agblocks;
+
+		if (start_agno == end_agno)
+			end = end_agbno;
+		error = xfs_trim_extents(pag, start_agbno, end, minlen,
 					  &blocks_trimmed);
 		if (error)
 			last_error = error;
@@ -429,6 +463,7 @@ xfs_ioc_trim(
 			xfs_perag_rele(pag);
 			break;
 		}
+		start_agbno = 0;
 	}
 
 	if (last_error)
-- 
Dave Chinner
david@fromorbit.com
