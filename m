Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42458 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdEBHoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 03:44:01 -0400
Date: Tue, 2 May 2017 00:44:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170502074400.GB19021@infradead.org>
References: <20170428194652.GG22884@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428194652.GG22884@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>

Hi Darrick,

a few comments below.  Most are cosmetic except for one which is
a minor improvement.

Reviewed-by: Christoph Hellwig <hch@lst.de>

with the cosmetic bits fixed up.

> +	last_da = xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET);
> +	map_off = xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, *cur_off));
> +	found = xfs_iext_lookup_extent(dp, ifp, map_off, &idx, &map);
> +	if (!found || map.br_startoff >= last_da)
>  		goto out;

I don't think we need the found variable in this function, all the users
only check for in the next line and then ignore it.  E.g. rewrite this
into

	if (!xfs_iext_lookup_extent(dp, ifp, map_off, &idx, &map))
		goto out;
	if (map.br_startoff >= last_da))
		goto out;

> +	ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
> +	if (*ra_blk >= last_da)
> +		goto out;
> +	else if (*ra_blk == 0)
> +		*ra_blk = map.br_startoff;

No need for the else here.

> +	next_ra = map.br_startoff + geo->fsbcount;
> +	if (next_ra >= last_da)
> +		goto out_no_ra;
> +	found = xfs_iext_lookup_extent(dp, ifp, next_ra, &idx, &map);

Do we really need a new full lookup here?  This should be the same
or the next map compared to the one the original xfs_iext_lookup_extent
returned.  So just checking if it's in the original map that could
be stashed away or otherwise calling xfs_iext_get_extent would more
efficient.

> +	while (ra_want > 0) {
> +		next_ra = roundup((xfs_dablk_t)map.br_startoff, geo->fsbcount);
> +		while (ra_want > 0 &&
> +		       next_ra < map.br_startoff + map.br_blockcount) {
> +			if (next_ra >= last_da) {
> +				*ra_blk = last_da;
> +				break;
> +			} else if (next_ra > *ra_blk) {

No need for the else.

