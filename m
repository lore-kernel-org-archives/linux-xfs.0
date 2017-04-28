Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35544 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426567AbdD1SCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 14:02:06 -0400
Date: Fri, 28 Apr 2017 11:01:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170428180126.GB27447@birch.djwong.org>
References: <20170425020353.GT23371@birch.djwong.org>
 <20170427073228.GB29468@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427073228.GB29468@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cmaiolin@redhat.com>, billodo@redhat.com, Dave Chinner <david@fromorbit.com>

On Thu, Apr 27, 2017 at 12:32:28AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 24, 2017 at 07:03:53PM -0700, Darrick J. Wong wrote:
> > Currently, the dir2 leaf block getdents function uses a complex state
> > tracking mechanism to create a shadow copy of the block mappings and
> > then uses the shadow copy to schedule readahead.  Since the read and
> > readahead functions are perfectly capable of reading the mappings
> > themselves, we can tear all that out in favor of a simpler function that
> > simply keeps pushing the readahead window further out.
> 
> I like where this goes a lot.  A few more comments below:
> 
> > +	/* Flush old buf; remember its daddr for error detection. */
> > +	if (*bpp) {
> > +		old_daddr = (*bpp)->b_bn;
> > +		xfs_trans_brelse(args->trans, *bpp);
> 
> I don't really understand the whole old_daddr logic.  How could we
> go backwards in the logic block space?

I was being overly paranoid that we could somehow end up with the same
buffer, but I've convinced myself that this isn't actually possible.

> > +	 * Look for mapped directory blocks at or above the current
> > +	 * offset.  We must truncate down to the nearest directory
> > +	 * block to start the scanning operation.
> 
> Use all 80 chars available on the terminal for comments, please :)

Ok.

> > +	last_da = xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET);
> > +	map_off = xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, *cur_off));
> > +	do {
> > +		nmap = 1;
> > +		error = xfs_bmapi_read(dp, map_off, last_da - map_off,
> > +				&map, &nmap, 0);
> > +		if (error || !nmap)
> > +			goto out;
> > +		map_off = map.br_startoff + map.br_blockcount;
> > +	} while (map_off < last_da && map.br_startblock == HOLESTARTBLOCK);
> > +
> > +	if (map.br_startblock == HOLESTARTBLOCK)
> >  		goto out;
> 
> This shows that xfs_bmapi_read really is the wrong interface for the
> calles.  Raw calls to xfs_iext_lookup_extent / xfs_iext_get_extent would
> make this loop easier to understand, and also more efficient by not
> doing the full lookup.
> 
> > +	while (ra_want > 0 && next_ra < last_da) {
> > +		nmap = 1;
> > +		error = xfs_bmapi_read(dp, next_ra, last_da - next_ra,
> > +				&map, &nmap, 0);
> > +		if (error || !nmap)
> > +			break;
> > +		next_ra = roundup((xfs_dablk_t)map.br_startoff, geo->fsbcount);
> > +		while (ra_want > 0 &&
> > +		       map.br_startblock != HOLESTARTBLOCK &&
> > +		       next_ra < map.br_startoff + map.br_blockcount) {
> > +			xfs_dir3_data_readahead(dp, next_ra, -2);
> > +			*ra_blk = next_ra;
> > +			ra_want -= geo->fsbcount;
> > +			next_ra += geo->fsbcount;
> >  		}
> > +		next_ra = map.br_startoff + map.br_blockcount;
> 
> Same here..

<nod>

--D
