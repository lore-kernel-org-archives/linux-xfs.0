Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46553 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbdEBTDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 15:03:01 -0400
Date: Tue, 2 May 2017 12:02:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170502190228.GB5973@birch.djwong.org>
References: <20170428194652.GG22884@birch.djwong.org>
 <20170502074400.GB19021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502074400.GB19021@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Tue, May 02, 2017 at 12:44:00AM -0700, Christoph Hellwig wrote:
> Hi Darrick,
> 
> a few comments below.  Most are cosmetic except for one which is
> a minor improvement.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> with the cosmetic bits fixed up.
> 
> > +	last_da = xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET);
> > +	map_off = xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, *cur_off));
> > +	found = xfs_iext_lookup_extent(dp, ifp, map_off, &idx, &map);
> > +	if (!found || map.br_startoff >= last_da)
> >  		goto out;
> 
> I don't think we need the found variable in this function, all the users
> only check for in the next line and then ignore it.  E.g. rewrite this
> into
> 
> 	if (!xfs_iext_lookup_extent(dp, ifp, map_off, &idx, &map))
> 		goto out;
> 	if (map.br_startoff >= last_da))
> 		goto out;

Ok.

> > +	ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
> > +	if (*ra_blk >= last_da)
> > +		goto out;
> > +	else if (*ra_blk == 0)
> > +		*ra_blk = map.br_startoff;
> 
> No need for the else here.

Ok.

> > +	next_ra = map.br_startoff + geo->fsbcount;
> > +	if (next_ra >= last_da)
> > +		goto out_no_ra;
> > +	found = xfs_iext_lookup_extent(dp, ifp, next_ra, &idx, &map);
> 
> Do we really need a new full lookup here?  This should be the same
> or the next map compared to the one the original xfs_iext_lookup_extent
> returned.  So just checking if it's in the original map that could
> be stashed away or otherwise calling xfs_iext_get_extent would more
> efficient.

Sure, that could be something like:

	next_ra = map.br_startoff + geo->fsbcount;
	if (next_ra >= last_da)
		goto out_no_ra;
	if (map.br_blockcount < geo->fsbcount &&
	    !xfs_iext_get_extent(ifp, ++idx, &map))
		goto out_no_ra;
	if (map.br_startoff >= last_da)
		goto out_no_ra;
	xfs_trim_extent(&map, next_ra, last_da - next_ra);

> > +	while (ra_want > 0) {
> > +		next_ra = roundup((xfs_dablk_t)map.br_startoff, geo->fsbcount);
> > +		while (ra_want > 0 &&
> > +		       next_ra < map.br_startoff + map.br_blockcount) {
> > +			if (next_ra >= last_da) {
> > +				*ra_blk = last_da;
> > +				break;
> > +			} else if (next_ra > *ra_blk) {
> 
> No need for the else.

Ok.

--D
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
