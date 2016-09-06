Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A8667CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 12:31:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 596638F8040
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:31:44 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LcdgxFhUlipr5Stv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 10:31:41 -0700 (PDT)
Date: Tue, 6 Sep 2016 10:31:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/71] xfs: set up per-AG free space reservations
Message-ID: <20160906173104.GF16696@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216795753.867.766643420503917806.stgit@birch.djwong.org>
	<20160906145349.GA24287@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906145349.GA24287@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 07:53:49AM -0700, Christoph Hellwig wrote:
> > v2: There's really only two kinds of per-AG reservation pools -- one
> > to feed the AGFL (rmapbt), and one to feed everything else
> > (refcountbt).  Bearing that in mind, we can embed the reservation
> > controls in xfs_perag and greatly simplify the block accounting.
> > Furthermore, fix some longstanding accounting bugs that were a direct
> > result of the goofy "allocate a block and later fix up the accounting"
> > strategy by integrating the reservation accounting code more tightly
> > with the allocator.  This eliminates the ENOSPC complaints resulting
> > from refcount btree splits during truncate operations.
> > 
> > v3: Since AGFL blocks are considered to be "free", we mustn't change
> > fdblocks in response to any AGFL grow/shrink operation.  Therefore, we
> > must give back to fdblocks at umount whatever we borrowed at mount.
> > We have to let ag_reserved go down to zero because it's used to
> > determine if we're critically low on reservation.
> 
> The v2/v3 would belong below the --- line.  But there's some pretty
> useful information in here, so it might be worth incorporating some
> of that into the main changelog.
> 
> > +bool
> > +xfs_ag_resv_critical(
> > +	struct xfs_perag		*pag,
> > +	enum xfs_ag_resv_type		type)
> > +{
> > +	xfs_extlen_t			avail;
> > +	xfs_extlen_t			orig;
> > +
> > +	switch (type) {
> > +	case XFS_AG_RESV_METADATA:
> > +		avail = pag->pagf_freeblks - pag->pag_agfl_resv.ar_reserved;
> > +		orig = pag->pag_meta_resv.ar_asked;
> > +		break;
> 
> This doesn't actually seem to be used in the whole series.  I can see
> why you'd want it for completeness, but that also means the code here
> is pretty much guaranteed to be unused..
> 
> > +	return avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS;
> 
> Where does this magic 10 come from?
> 
> > +	/*
> > +	 * AGFL blocks are always considered "free", so whatever
> > +	 * was reserved at mount time must be given back at umount.
> > +	 */
> > +	oldresv = (type == XFS_AG_RESV_AGFL ? resv->ar_orig_reserved :
> > +					      resv->ar_reserved);
> 
> Nitpick: Using a plain old if/else here would be a fair bit more
> readable.

Ok.

> > +int
> > +xfs_ag_resv_free(
> > +	struct xfs_perag		*pag)
> > +{
> > +	int				error = 0;
> > +	int				err2;
> > +
> > +	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
> > +	if (err2 && !error)
> > +		error = err2;
> 
> error is always 0 here.  So a simple:
> 
> 	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
> 
> Also why not error and error2 or err and err2 to be consistent?
>
> > +	xfs_extlen_t			ask;
> > +	xfs_extlen_t			used;
> > +	int				error = 0;
> > +	int				err2;
> > +
> > +	if (pag->pag_meta_resv.ar_asked)
> > +		goto init_agfl;
> > +
> > +	/* Create the metadata reservation. */
> > +	ask = used = 0;
> > +
> > +	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA, ask, used);
> > +	if (err2 && !error)
> > +		error = err2;
> 
> Same error is always null case here.

A few revisions ago I would still allow XFS to limp along if any part of this
AG reservation calculation or initialization failed, but nowadays it's been
changed to take the FS offline at the first sign of trouble, so both can turn
into the usual if (error) return error; paradigm.

> > +
> > +init_agfl:
> 
> Why not a simple if instead of the goto above?

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
