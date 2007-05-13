Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 May 2007 14:19:40 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4DLJafB015043
	for <xfs@oss.sgi.com>; Sun, 13 May 2007 14:19:37 -0700
Date: Sun, 13 May 2007 21:59:53 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Concurrent Multi-File Data Streams
Message-ID: <20070513205953.GA14030@infradead.org>
References: <20070511003606.GB85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070511003606.GB85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

I already had some comments on this when discussing it with Sam in person,
but it seems like they didn't make it to you.

First the mru cache while beeing quite nice code is heavily overengineered
for this case.  Unless there are a many hundred filestreams per filesystem
it will be a lot faster to just have a simple wrap-around array of
linked lists.  We don't want to feed the argument that xfs has lots of
useless bloated code, do we? :)

All the pip != NULL checks are superflous in Linux.  A regular
file can never have a non-null parent inode, and a directory can only
have a non-NULL parent inode in very odd corner cases involving NFS
exports, but it has to be connect again once you start doing
namespace modifying operations on it.

There some naming confusion: xfs_mount.h forward-declares struct
xfs_filestream but everything else uses struct fstrm_mnt_data.
The former is very non-descriptive and the latter but ugly, I'd
suggestjust putting the mru-cache replacement directly in there
as xfs_filestream_cache instead of the wrapping.

The xfs_zeroino changes looks good but should be a separate commit.

Some comments on the actual code in xfs_filestream.c

> +#ifdef DEBUG_FILESTREAMS
> +#define dprint(fmt, args...) do {                    \
> +        printk(KERN_DEBUG "%4d %s: " fmt "\n",       \
> +               current_pid(), __FUNCTION__, ##args); \
> +} while(0)
> +#else
> +#define dprint(args...) do {} while (0)
> +#endif

This should probably be killed entirely.

> +#define GET_AG_REF(mp, ag) atomic_read(&(mp)->m_perag[ag].pagf_fstrms)
> +#define INC_AG_REF(mp, ag) atomic_inc_return(&(mp)->m_perag[ag].pagf_fstrms)
> +#define DEC_AG_REF(mp, ag) atomic_dec_return(&(mp)->m_perag[ag].pagf_fstrms)

These should be inlines with more descriptive lower case names.

> +#define XFS_PICK_USERDATA 1
> +#define XFS_PICK_LOWSPACE 2

enum.

> +
> +/*
> + * Scan the AGs starting at startag looking for an AG that isn't in use and has
> + * at least minlen blocks free.
> + */
> +static int
> +_xfs_filestream_pick_ag(
> +	xfs_mount_t	*mp,
> +	xfs_agnumber_t	startag,
> +	xfs_agnumber_t	*agp,
> +	int		flags,
> +	xfs_extlen_t	minlen)
> +{
> +	int		err, trylock, nscan;
> +	xfs_extlen_t	delta, longest, need, free, minfree, maxfree = 0;
> +	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
> +	struct xfs_perag *pag;
> +
> +	/* 2% of an AG's blocks must be free for it to be chosen. */
> +	minfree = mp->m_sb.sb_agblocks / 50;
> +
> +	ag = startag;
> +	*agp = NULLAGNUMBER;
> +
> +	/* For the first pass, don't sleep trying to init the per-AG. */
> +	trylock = XFS_ALLOC_FLAG_TRYLOCK;
> +
> +	for (nscan = 0; 1; nscan++) {
> +
> +		//dprint("scanning AG %d[%d]", ag, GET_AG_REF(mp, ag));

please don't leave commented out debug code in.

> +		pag = mp->m_perag + ag;
> +
> +		if (!pag->pagf_init &&
> +		    (err = xfs_alloc_pagf_init(mp, NULL, ag, trylock)) &&
> +		    !trylock) {
> +			dprint("xfs_alloc_pagf_init returned %d", err);
> +			return err;
> +		}

		if (!pag->pagf_init) {
			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
			if (err && !trylock)
				return err;
		}

> +static int
> +_xfs_filestream_set_ag(
> +	xfs_inode_t	*ip,
> +	xfs_inode_t	*pip,
> +	xfs_agnumber_t	ag)
> +{
> +	int		err = 0;
> +	xfs_mount_t	*mp;
> +	xfs_mru_cache_t	*cache;
> +	fstrm_item_t	*item;
> +	xfs_agnumber_t	old_ag;
> +	xfs_inode_t	*old_pip;
> +
> +	/*
> +	 * Either ip is a regular file and pip is a directory, or ip is a
> +	 * directory and pip is NULL.
> +	 */

We have parent information for parents aswell so this should probably
be made more regular.

> +	ASSERT(ip && (((ip->i_d.di_mode & S_IFREG) && pip &&
> +	               (pip->i_d.di_mode & S_IFDIR)) ||
> +	              ((ip->i_d.di_mode & S_IFDIR) && !pip)));


> +	mp = ip->i_mount;
> +	cache = mp->m_filestream->fstrm_items;
> +
> +	if ((item = (fstrm_item_t*)xfs_mru_cache_lookup(cache, ip->i_ino))) {

assignment and conditional on separate lines please (also alsewhere in the
code), and no needless casts from void * either (also various places

> +void
> +xfs_filestream_init(void)
> +{
> +	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
> +	ASSERT(item_zone);

Please check for errors instead and propagate them.

> +/*
> + * xfs_filestream_uninit() is called at xfs termination time to destroy the
> + * memory zone that was used for filestream data structure allocation.
> + */
> +void
> +xfs_filestream_uninit(void)
> +{
> +	if (item_zone) {
> +		kmem_zone_destroy(item_zone);
> +		item_zone = NULL;
> +	}
> +}

no need for the NULL check or setting it to NULL.

> +	if (!(md = (fstrm_mnt_data_t*)kmem_zalloc(sizeof(*md), KM_SLEEP)))

Please use KM_MAYFAIL for all new code otside of transactions.

> +	ASSERT(ip->i_d.di_mode & (S_IFREG | S_IFDIR));
> +	if (!(ip->i_d.di_mode & (S_IFREG | S_IFDIR)))
> +		return NULLAGNUMBER;

either the assert or the if clause checking gor it, please.

Now comes the worst part the new allocator function
i
IF we look at a diff between xfs_bmap_filestreams and xfs_bmap_btalloc
we see that it's a pretty bad cut & paste job:


--- btalloc	2007-05-12 12:43:03.000000000 +0200
+++ fsalloc	2007-05-12 12:42:28.000000000 +0200
@@ -1,44 +1,54 @@
 
> +	rt = (ap->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) && ap->userdata;

xfs_bmap_alloc() never calls xfs_bmap_filestreams if this is
true so all code guarded by if (rt) is dead.

> -	if (unlikely(align)) {
> +	if (align) {

Âlign should have the same likelyhood for oth

> -	if (nullfb)
> -		ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
> -	else
> +	if (nullfb) {
> +		ag = xfs_filestream_get_ag(ap->ip);
> +		ag = (ag != NULLAGNUMBER) ? ag : 0;
> +		ap->rval = (ap->userdata) ? XFS_AGB_TO_FSB(mp, ag, 0) :
> +		                            XFS_INO_TO_FSB(mp, ap->ip->i_ino);
> +	} else {
> 		ap->rval = ap->firstblock;
> +	}

Some rreal changes :)  But this could be just a third if case
for the filesystream case.
 
> -	args.firstblock = ap->firstblock;

	Backout of parts of rev1.349


 	blen = 0;
 	if (nullfb) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
+		/* _vextent doesn't pick an AG */
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;

 		/*
> @@ -117,18 +167,19 @@
> 		 */
> 		else
>  			args.minlen = ap->alen;
> +		ap->rval = args.fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
>  	} else if (ap->low) {
> -		args.type = XFS_ALLOCTYPE_START_BNO;
> +		args.type = XFS_ALLOCTYPE_FIRST_AG;
> 		args.total = args.minlen = ap->minlen;

Why is this different?

 	}
> -	if (unlikely(ap->userdata && ap->ip->i_d.di_extsize &&
> -		    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE))) {
> +	if (ap->userdata && ap->ip->i_d.di_extsize &&
> +	    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) {
 		args.prod = ap->ip->i_d.di_extsize;
> -		if ((args.mod = (xfs_extlen_t)do_mod(ap->off, args.prod)))
> +		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))

Gratious difference.

 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
> +	atype = args.type;

I don't quite undersatnd why we'd nee this in one, but not the other.

 	if (!ap->low && ap->aeof) {
 		if (!ap->off) {
 			args.alignment = mp->m_dalign;

> -			 * First try an exact bno allocation.
> +		 	 * First try an exact bno allocation.
> 			 * If it fails then do a near or start bno
> 			 * allocation with alignment turned on.
> -			 */
> +		 	 */

	Backout of whitespace adjustments.

> -		XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
> -			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
> +		if (XFS_IS_QUOTA_ON(mp) &&
> +		    ap->ip->i_ino != mp->m_sb.sb_uquotino &&
> +		    ap->ip->i_ino != mp->m_sb.sb_gquotino) {
> +		    XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
> +				ap->wasdel ?
> +					XFS_TRANS_DQ_DELBCOUNT :
> 					XFS_TRANS_DQ_BCOUNT,
> -			(long) args.len);
> +				(long)args.len);
> +		}

	Gratious differenes but okay because there won't be
	file streams for quota inodes.

Based onthat my conclusion is that xfs_bmap_filestreams and xfs_bmap_btalloc
should be merged to avoid further maintaince overhead.
