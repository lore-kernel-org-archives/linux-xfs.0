Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24351 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751618AbcLGGix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2016 01:38:53 -0500
Date: Wed, 7 Dec 2016 17:32:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: use rhashtable to track buffer cache
Message-ID: <20161207063213.GI4326@dastard>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-3-david@fromorbit.com>
 <20161205170411.GA14091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205170411.GA14091@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 09:04:11AM -0800, Christoph Hellwig wrote:
> > +static int
> > +_xfs_buf_cmp(
> > +	struct rhashtable_compare_arg *arg,
> > +	const void *obj)
> > +{
> > +	const struct xfs_buf_map *map = arg->key;
> > +	const struct xfs_buf *bp = obj;
> 
> How about aligning the parameter / variable names here like we
> normally do in XFS?

Sorry, forgot to do that when I updated the patch.

> > +static const struct rhashtable_params xfs_buf_hash_params = {
> > +	.min_size = 32,		/* empty/unused AGs have minimal footprint */
> > +	.nelem_hint = 16,
> > +	.key_len = sizeof(xfs_daddr_t),
> > +	.key_offset = offsetof(struct xfs_buf, b_bn),
> > +	.head_offset = offsetof(struct xfs_buf, b_rhash_head),
> > +	.automatic_shrinking = true,
> > +	.obj_cmpfn = _xfs_buf_cmp,
> 
> Some tab alignments before the equal signs here?
> 
> Also please name the compare function so that it fits the field name,
> as that makes grepping so much easier..
> 
> 	.obj_cmpfn	= xfs_buf_obj_cmpfn,

Will do.

> Otherwise this looks fine to me and seems to survive testing so far:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
