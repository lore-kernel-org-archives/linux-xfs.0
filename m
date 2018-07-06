Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:32121 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753439AbeGFBD2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 21:03:28 -0400
Date: Fri, 6 Jul 2018 11:03:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/21] xfs: repair extended attributes
Message-ID: <20180706010324.GR2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986832301.3155.2967196267590663478.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986832301.3155.2967196267590663478.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:25:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the extended attributes look bad, try to sift through the rubble to
> find whatever keys/values we can, zap the attr tree, and re-add the
> values.
.....
> 
> +/*
> + * Extended Attribute Repair
> + * =========================
> + *
> + * We repair extended attributes by reading the attribute fork blocks looking
> + * for keys and values, then truncate the entire attr fork and reinsert all
> + * the attributes.  Unfortunately, there's no secondary copy of most extended
> + * attribute data, which means that if we blow up midway through there's
> + * little we can do.
> + */
> +
> +struct xfs_attr_key {
> +	struct list_head		list;
> +	unsigned char			*value;
> +	int				valuelen;
> +	int				flags;
> +	int				namelen;
> +	unsigned char			name[0];
> +};
> +
> +#define XFS_ATTR_KEY_LEN(namelen) (sizeof(struct xfs_attr_key) + (namelen) + 1)
> +
> +struct xfs_repair_xattr {
> +	struct list_head		*attrlist;
> +	struct xfs_scrub_context	*sc;
> +};
> +
> +/* Iterate each block in an attr fork extent */
> +#define for_each_xfs_attr_block(mp, irec, dabno) \
> +	for ((dabno) = roundup((xfs_dablk_t)(irec)->br_startoff, \
> +			(mp)->m_attr_geo->fsbcount); \
> +	     (dabno) < (irec)->br_startoff + (irec)->br_blockcount; \
> +	     (dabno) += (mp)->m_attr_geo->fsbcount)

What's the roundup() for? The attribute fsbcount is only ever going
to be 1 (single block), so it's not obvious what this is doing...

> +/*
> + * Record an extended attribute key & value for later reinsertion into the
> + * inode.  Use the helpers below, don't call this directly.
> + */
> +STATIC int
> +__xfs_repair_xattr_salvage_attr(
> +	struct xfs_repair_xattr		*rx,
> +	struct xfs_buf			*bp,
> +	int				flags,
> +	int				idx,
> +	unsigned char			*name,
> +	int				namelen,
> +	unsigned char			*value,
> +	int				valuelen)
> +{
> +	struct xfs_attr_key		*key;
> +	struct xfs_da_args		args;
> +	int				error = -ENOMEM;
> +
> +	/* Ignore incomplete or oversized attributes. */
> +	if ((flags & XFS_ATTR_INCOMPLETE) ||
> +	    namelen > XATTR_NAME_MAX || namelen < 0 ||
> +	    valuelen > XATTR_SIZE_MAX || valuelen < 0)
> +		return 0;
> +
> +	/* Store attr key. */
> +	key = kmem_alloc(XFS_ATTR_KEY_LEN(namelen), KM_MAYFAIL);
> +	if (!key)
> +		goto err;
> +	INIT_LIST_HEAD(&key->list);
> +	key->value = kmem_zalloc_large(valuelen, KM_MAYFAIL);

Why zero this? Also, it looks like valuelen can be zero? Should be
we be allocating a buffer in that case?

> +	if (!key->value)
> +		goto err_key;
> +	key->valuelen = valuelen;
> +	key->flags = flags & (ATTR_ROOT | ATTR_SECURE);
> +	key->namelen = namelen;
> +	key->name[namelen] = 0;
> +	memcpy(key->name, name, namelen);
> +
> +	/* Caller already had the value, so copy it and exit. */
> +	if (value) {
> +		memcpy(key->value, value, valuelen);
> +		goto out_ok;

memcpy of a zero length buffer into a zero length pointer does what?

> +	}
> +
> +	/* Otherwise look up the remote value directly. */

It's not at all obvious why we are looking up a remote xattr at this
point in the function.

> +	memset(&args, 0, sizeof(args));
> +	args.geo = rx->sc->mp->m_attr_geo;
> +	args.index = idx;
> +	args.namelen = namelen;
> +	args.name = key->name;
> +	args.valuelen = valuelen;
> +	args.value = key->value;
> +	args.dp = rx->sc->ip;
> +	args.trans = rx->sc->tp;
> +	error = xfs_attr3_leaf_getvalue(bp, &args);
> +	if (error || args.rmtblkno == 0)
> +		goto err_value;
> +
> +	error = xfs_attr_rmtval_get(&args);
> +	switch (error) {
> +	case 0:
> +		break;
> +	case -EFSBADCRC:
> +	case -EFSCORRUPTED:
> +		error = 0;
> +		/* fall through */
> +	default:
> +		goto err_value;

So here we can return with error = 0, but no actual extended
attribute. Isn't this a silent failure?

> +	}
> +
> +out_ok:
> +	list_add_tail(&key->list, rx->attrlist);
> +	return 0;
> +
> +err_value:
> +	kmem_free(key->value);
> +err_key:
> +	kmem_free(key);
> +err:
> +	return error;
> +}
> +
> +/*
> + * Record a local format extended attribute key & value for later reinsertion
> + * into the inode.
> + */
> +static inline int
> +xfs_repair_xattr_salvage_local_attr(
> +	struct xfs_repair_xattr		*rx,
> +	int				flags,
> +	unsigned char			*name,
> +	int				namelen,
> +	unsigned char			*value,
> +	int				valuelen)
> +{
> +	return __xfs_repair_xattr_salvage_attr(rx, NULL, flags, 0, name,
> +			namelen, value, valuelen);
> +}
> +
> +/*
> + * Record a remote format extended attribute key & value for later reinsertion
> + * into the inode.
> + */
> +static inline int
> +xfs_repair_xattr_salvage_remote_attr(
> +	struct xfs_repair_xattr		*rx,
> +	int				flags,
> +	unsigned char			*name,
> +	int				namelen,
> +	struct xfs_buf			*leaf_bp,
> +	int				idx,
> +	int				valuelen)
> +{
> +	return __xfs_repair_xattr_salvage_attr(rx, leaf_bp, flags, idx,
> +			name, namelen, NULL, valuelen);
> +}

Oh, this is why __xfs_repair_xattr_salvage_attr() has two completely
separate sets of code in it. Can we factor this differently? i.e a
helper function to do all the validity checking and key allocation,
and then leave the local versus remote attr handling in these
functions?

> +
> +/* Extract every xattr key that we can from this attr fork block. */
> +STATIC int
> +xfs_repair_xattr_recover_leaf(
> +	struct xfs_repair_xattr		*rx,
> +	struct xfs_buf			*bp)
> +{
> +	struct xfs_attr3_icleaf_hdr	leafhdr;
> +	struct xfs_scrub_context	*sc = rx->sc;
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_attr_leafblock	*leaf;
> +	unsigned long			*usedmap = sc->buf;
> +	struct xfs_attr_leaf_name_local	*lentry;
> +	struct xfs_attr_leaf_name_remote *rentry;
> +	struct xfs_attr_leaf_entry	*ent;
> +	struct xfs_attr_leaf_entry	*entries;
> +	char				*buf_end;
> +	char				*name;
> +	char				*name_end;
> +	char				*value;
> +	size_t				off;
> +	unsigned int			nameidx;
> +	unsigned int			namesize;
> +	unsigned int			hdrsize;
> +	unsigned int			namelen;
> +	unsigned int			valuelen;
> +	int				i;
> +	int				error;

Can we scope all these variables inside the blocks that use them?

> +
> +	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
> +
> +	/* Check the leaf header */
> +	leaf = bp->b_addr;
> +	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
> +	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
> +	xfs_scrub_xattr_set_map(sc, usedmap, 0, hdrsize);
> +	entries = xfs_attr3_leaf_entryp(leaf);
> +
> +	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
> +	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
> +		/* Skip key if it conflicts with something else? */
> +		off = (char *)ent - (char *)leaf;
> +		if (!xfs_scrub_xattr_set_map(sc, usedmap, off,
> +				sizeof(xfs_attr_leaf_entry_t)))
> +			continue;
> +
> +		/* Check the name information. */
> +		nameidx = be16_to_cpu(ent->nameidx);
> +		if (nameidx < leafhdr.firstused ||
> +		    nameidx >= mp->m_attr_geo->blksize)
> +			continue;
> +
> +		if (ent->flags & XFS_ATTR_LOCAL) {
> +			lentry = xfs_attr3_leaf_name_local(leaf, i);
> +			namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
> +					be16_to_cpu(lentry->valuelen));
> +			name_end = (char *)lentry + namesize;
> +			if (lentry->namelen == 0)
> +				continue;
> +			name = lentry->nameval;
> +			namelen = lentry->namelen;
> +			valuelen = be16_to_cpu(lentry->valuelen);
> +			value = &name[namelen];

It seems cumbersome to do a bunch of special local/remote attr
decoding into a set of semi-common variables, only to then pass the
specific local/remote variables back to specific local/remote
processing functions.

i.e. I'd prefer to see the attr decoding done inside the salvage
function so this looks something like:

	if (ent->flags & XFS_ATTR_LOCAL) {
		lentry = xfs_attr3_leaf_name_local(leaf, i);
		error = xfs_repair_xattr_salvage_local_attr(rx,
					lentry, ...);
	} else {
		rentry = xfs_attr3_leaf_name_remote(leaf, i);
		error = xfs_repair_xattr_salvage_local_attr(rx,
					rentry, ....);
	}

......

> +
> +/* Try to recover shortform attrs. */
> +STATIC int
> +xfs_repair_xattr_recover_sf(
> +	struct xfs_repair_xattr		*rx)
> +{
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	struct xfs_attr_sf_entry	*next;
> +	struct xfs_ifork		*ifp;
> +	unsigned char			*end;
> +	int				i;
> +	int				error;
> +
> +	ifp = XFS_IFORK_PTR(rx->sc->ip, XFS_ATTR_FORK);
> +	sf = (struct xfs_attr_shortform *)rx->sc->ip->i_afp->if_u1.if_data;

	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;

....
> +/*
> + * Repair the extended attribute metadata.
> + *
> + * XXX: Remote attribute value buffers encompass the entire (up to 64k) buffer
> + * and we can't handle those 100% until the buffer cache learns how to deal
> + * with that.

I'm not sure what this comment means/implies.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
