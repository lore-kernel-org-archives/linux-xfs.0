Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B0A47F9D
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 11:13:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59C2D8F8066
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 09:13:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id zx41Laxz9AUqy4mk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 09:13:57 -0800 (PST)
Date: Fri, 15 Nov 2013 09:13:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/4] xfs: introduce a new helper
	xfs_inobt_lookup_grab_ichunk()
Message-ID: <20131115171356.GB16942@infradead.org>
References: <5281F518.3080106@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5281F518.3080106@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> Refactor xfs_bulkstat() to make use of the founction.

                                         ... function.

> +int
> +xfs_inobt_lookup_grab_ichunk(
> +	struct xfs_btree_cur		*cur,	/* btree cursor */
> +	xfs_agino_t			agino,	/* starting inode of chunk */
> +	struct xfs_inobt_rec_incore	*irec,	/* btree record */
> +	int				*stat)	/* success/failure */
> +{
> +	int				idx;	/* Index into inode chunk */
> +	int				error;
> +
> +	/* Lookup the inode chunk that this inode lives in */
> +	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, stat);
> +	if (error || !*stat)
> +		return error;
> +
> +	/* Get the record, should always work */
> +	error = xfs_inobt_get_rec(cur, irec, stat);
> +	ASSERT(!error && *stat);

If it wails it's a corruption error, so this shouldn't be an assert,
but rather an XFS_WANT_CORRUPTED_GOTO/RETURN

> +	if (error || !*stat)
> +		return error;
> +
> +	*stat = 0;

Btw, I don't think we need to pass around the status pointer here,
the caller doesn't care about the internal lookup status, just if
we succeeded or failed.

> +	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
> +		return error;

error will usually be zero here, shouldn't we return a real error?

> +	idx = agino - irec->ir_startino + 1;
> +	/*
> +	 * We got a right chunk and there are some left inodes allocated at it.
> +	 */
> +	if (idx < XFS_INODES_PER_CHUNK &&
> +	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
> +		int	i;
> +
> +		/*
> +		 * Grab the chunk record.  Mark all the uninteresting inodes free
> +		 * (because they're before our start point).
> +		 */
> +		for (i = 0; i < idx; i++) {
> +			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
> +				irec->ir_freecount++;
> +		}
> +
> +		irec->ir_free |= xfs_inobt_maskn(0, idx);
> +		*stat = 1;
> +	}


At this point the function is so bulkstate specific that it should stay
in xfs_itable.c and have a name more like xfs_bulkstate_grab_ichunk.

I still like factoring it out though, thanks for the work!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
