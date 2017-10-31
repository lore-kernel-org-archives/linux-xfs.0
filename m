Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55360 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751347AbdJaXx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 19:53:28 -0400
Date: Wed, 1 Nov 2017 10:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: scrub extended attribute leaf space
Message-ID: <20171031235325.GJ5858@dastard>
References: <20171031225532.GD4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031225532.GD4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 31, 2017 at 03:55:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> As we walk the attribute btree, explicitly check the structure of the
> attribute leaves to make sure the pointers make sense and the freemap is
> sensible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/attr.c    |  233 ++++++++++++++++++++++++++++++++++++++++++++----
>  fs/xfs/scrub/dabtree.c |    4 +
>  fs/xfs/scrub/dabtree.h |    3 -
>  fs/xfs/scrub/dir.c     |    2 
>  4 files changed, 218 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index a70cd9b..5d624ca 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -50,8 +50,17 @@ xfs_scrub_setup_xattr(
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_inode		*ip)
>  {
> -	/* Allocate the buffer without the inode lock held. */
> -	sc->buf = kmem_zalloc_large(XATTR_SIZE_MAX, KM_SLEEP);
> +	size_t				sz;
> +
> +	/*
> +	 * Allocate the buffer without the inode lock held.  We need enough
> +	 * space to read every xattr value in the file and enough space to
						       ^^^
nit:							or

> +	 * hold three copies of the xattr free space bitmap.  (Not both at
> +	 * the same time.)
> +	 */
> +	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
> +			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
> +	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> @@ -122,6 +131,197 @@ xfs_scrub_xattr_listent(
>  	return;
>  }
>  
> +/*
> + * Mark a range [start, start+len) in this map.  Returns true if the
> + * region was free, and false if there's a conflict or a problem.
> + *
> + * Within a char, the lowest bit of the char represents the byte with
> + * the smallest address
> + */
> +STATIC bool
> +xfs_scrub_xattr_set_map(
> +	struct xfs_scrub_context	*sc,
> +	unsigned long			*map,
> +	unsigned int			start,
> +	unsigned int			len)
> +{
> +	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
> +	bool				ret = true;
> +
> +	if (start >= mapsize)
> +		return false;
> +	if (start + len > mapsize) {
> +		len = mapsize - start;
> +		ret = false;
> +	}
> +
> +	ret &= find_next_bit(map, mapsize, start) >= (start + len);

That's a bit convoluted. It's a conditional boolean bit masking
operation. AFAICT it clears ret if the next bit is < (start
+ len), but if ret is already false it can never be set. I think.

Much simpler to write:

	if (find_next_bit(map, mapsize, start) < start + len)
		ret = false;

> +/* Scrub an attribute leaf. */
> +STATIC int
> +xfs_scrub_xattr_block(
> +	struct xfs_scrub_da_btree	*ds,
> +	int				level)
> +{
> +	struct xfs_attr3_icleaf_hdr	leafhdr;
> +	struct xfs_mount		*mp = ds->state->mp;
> +	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
> +	struct xfs_buf			*bp = blk->bp;
> +	xfs_dablk_t			*last_checked = ds->private;
> +	struct xfs_attr_leafblock	*leaf = bp->b_addr;
> +	struct xfs_attr_leaf_entry	*ent;
> +	struct xfs_attr_leaf_entry	*entries;
> +	struct xfs_attr_leaf_name_local	*lentry;
> +	struct xfs_attr_leaf_name_remote	*rentry;
> +	unsigned long			*usedmap = ds->sc->buf;
> +	char				*name_end;
> +	char				*buf_end;
> +	__u32				last_hashval = 0;
> +	unsigned int			usedbytes = 0;
> +	unsigned int			nameidx;
> +	unsigned int			hdrsize;
> +	unsigned int			namesize;
> +	int				i;
> +
> +	if (*last_checked == blk->blkno)
> +		return 0;
> +	*last_checked = blk->blkno;
> +	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
> +
> +	/* Check all the padding. */
> +	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb)) {
> +		struct xfs_attr3_leafblock	*leaf = bp->b_addr;
> +
> +		if (leaf->hdr.pad1 != 0 ||
> +		    leaf->hdr.pad2 != cpu_to_be32(0) ||

cpu_to_be32(0) = 0.

So there's no need for endian conversion of 0.

> +		    leaf->hdr.info.hdr.pad != cpu_to_be16(0))
> +			xfs_scrub_da_set_corrupt(ds, level);
> +	} else {
> +		if (leaf->hdr.pad1 != 0 ||
> +		    leaf->hdr.info.pad != cpu_to_be16(0))
> +			xfs_scrub_da_set_corrupt(ds, level);
> +	}
> +
> +	/* Check the leaf header */
> +	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
> +
> +	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
> +		xfs_scrub_da_set_corrupt(ds, level);
> +	if (leafhdr.firstused > mp->m_attr_geo->blksize)
> +		xfs_scrub_da_set_corrupt(ds, level);
> +	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
> +	if (leafhdr.firstused < hdrsize)
> +		xfs_scrub_da_set_corrupt(ds, level);
> +
> +	if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, 0, hdrsize)) {
> +		xfs_scrub_da_set_corrupt(ds, level);
> +		goto out;
> +	}
> +
> +	entries = xfs_attr3_leaf_entryp(leaf);
> +	if ((char *)&entries[leafhdr.count] > (char *)leaf + leafhdr.firstused)
> +		xfs_scrub_da_set_corrupt(ds, level);

All the casts are a bit ugly, but I guess we've got to check
offsets somehow. 

> +	/* Check the entries' relations to each other */
> +	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
> +	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
> +		if (!xfs_scrub_xattr_set_map(ds->sc, usedmap,
> +				(char *)ent - (char *)leaf,
> +				sizeof(xfs_attr_leaf_entry_t))) {
> +			xfs_scrub_da_set_corrupt(ds, level);
> +			goto out;
> +		}

The amount of indentation and broken lines inside this loop makes it
reall hard to read. Can you factor it at all? ...

> +
> +		if (ent->pad2 != cpu_to_be32(0))
> +			xfs_scrub_da_set_corrupt(ds, level);

compare against 0

> +
> +		if (be32_to_cpu(ent->hashval) < last_hashval)
> +			xfs_scrub_da_set_corrupt(ds, level);
> +		last_hashval = be32_to_cpu(ent->hashval);
> +
> +		nameidx = be16_to_cpu(ent->nameidx);
> +		if (nameidx < hdrsize ||
> +		    nameidx < leafhdr.firstused ||
> +		    nameidx >= mp->m_attr_geo->blksize) {
> +			xfs_scrub_da_set_corrupt(ds, level);
> +			goto out;
> +		}
> +
> +		if (ent->flags & XFS_ATTR_LOCAL) {
> +			lentry = xfs_attr3_leaf_name_local(leaf, i);
> +			if (lentry->namelen <= 0)
> +				xfs_scrub_da_set_corrupt(ds, level);
> +			name_end = (char *)lentry->nameval + lentry->namelen +
> +					be16_to_cpu(lentry->valuelen);

Isn't there padding that has to be taken into account here?


> +			if (name_end > buf_end)
> +				xfs_scrub_da_set_corrupt(ds, level);
> +			namesize = xfs_attr_leaf_entsize_local(
> +					lentry->namelen,
> +					be16_to_cpu(lentry->valuelen));

Because this pads the size of the entry...

> +		} else {
> +			rentry = xfs_attr3_leaf_name_remote(leaf, i);
> +			if (rentry->namelen <= 0)
> +				xfs_scrub_da_set_corrupt(ds, level);
> +			name_end = (char *)rentry->name + rentry->namelen;

Same here.

> +			if (name_end > buf_end)
> +				xfs_scrub_da_set_corrupt(ds, level);
> +			namesize = xfs_attr_leaf_entsize_remote(
> +						rentry->namelen);
> +			if (rentry->valueblk == cpu_to_be32(0))
> +				xfs_scrub_da_set_corrupt(ds, level);
> +		}

Maybe just factoring the local/remote attr name checks will clean
this all up - this is the part that's really hard to read.


> +		usedbytes += namesize;
> +		if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, nameidx,
> +				namesize)) {
> +			xfs_scrub_da_set_corrupt(ds, level);
> +			goto out;
> +		}
> +	}
> +
> +	if (!xfs_scrub_xattr_check_freemap(ds->sc, usedmap, &leafhdr))
> +		xfs_scrub_da_set_corrupt(ds, level);
> +
> +	if (leafhdr.usedbytes != usedbytes)
> +		xfs_scrub_da_set_corrupt(ds, level);

And so this validates all the padded entries....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
