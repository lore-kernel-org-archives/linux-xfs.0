Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 925157CA4
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 09:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5741E304043
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 07:53:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QQC6MF51fwksdhhr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 07:53:52 -0700 (PDT)
Date: Tue, 6 Sep 2016 07:53:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/71] xfs: set up per-AG free space reservations
Message-ID: <20160906145349.GA24287@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216795753.867.766643420503917806.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216795753.867.766643420503917806.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

> v2: There's really only two kinds of per-AG reservation pools -- one
> to feed the AGFL (rmapbt), and one to feed everything else
> (refcountbt).  Bearing that in mind, we can embed the reservation
> controls in xfs_perag and greatly simplify the block accounting.
> Furthermore, fix some longstanding accounting bugs that were a direct
> result of the goofy "allocate a block and later fix up the accounting"
> strategy by integrating the reservation accounting code more tightly
> with the allocator.  This eliminates the ENOSPC complaints resulting
> from refcount btree splits during truncate operations.
> 
> v3: Since AGFL blocks are considered to be "free", we mustn't change
> fdblocks in response to any AGFL grow/shrink operation.  Therefore, we
> must give back to fdblocks at umount whatever we borrowed at mount.
> We have to let ag_reserved go down to zero because it's used to
> determine if we're critically low on reservation.

The v2/v3 would belong below the --- line.  But there's some pretty
useful information in here, so it might be worth incorporating some
of that into the main changelog.

> +bool
> +xfs_ag_resv_critical(
> +	struct xfs_perag		*pag,
> +	enum xfs_ag_resv_type		type)
> +{
> +	xfs_extlen_t			avail;
> +	xfs_extlen_t			orig;
> +
> +	switch (type) {
> +	case XFS_AG_RESV_METADATA:
> +		avail = pag->pagf_freeblks - pag->pag_agfl_resv.ar_reserved;
> +		orig = pag->pag_meta_resv.ar_asked;
> +		break;

This doesn't actually seem to be used in the whole series.  I can see
why you'd want it for completeness, but that also means the code here
is pretty much guaranteed to be unused..

> +	return avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS;

Where does this magic 10 come from?

> +	/*
> +	 * AGFL blocks are always considered "free", so whatever
> +	 * was reserved at mount time must be given back at umount.
> +	 */
> +	oldresv = (type == XFS_AG_RESV_AGFL ? resv->ar_orig_reserved :
> +					      resv->ar_reserved);

Nitpick: Using a plain old if/else here would be a fair bit more
readable.

> +int
> +xfs_ag_resv_free(
> +	struct xfs_perag		*pag)
> +{
> +	int				error = 0;
> +	int				err2;
> +
> +	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
> +	if (err2 && !error)
> +		error = err2;

error is always 0 here.  So a simple:

	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);

Also why not error and error2 or err and err2 to be consistent?

> +	xfs_extlen_t			ask;
> +	xfs_extlen_t			used;
> +	int				error = 0;
> +	int				err2;
> +
> +	if (pag->pag_meta_resv.ar_asked)
> +		goto init_agfl;
> +
> +	/* Create the metadata reservation. */
> +	ask = used = 0;
> +
> +	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA, ask, used);
> +	if (err2 && !error)
> +		error = err2;

Same error is always null case here.

> +
> +init_agfl:

Why not a simple if instead of the goto above?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
