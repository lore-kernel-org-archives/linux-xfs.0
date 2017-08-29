Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44843 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932074AbdH2Oih (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:38:37 -0400
Date: Tue, 29 Aug 2017 16:38:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170829143835.GA32169@lst.de>
References: <20170828150612.16437-1-hch@lst.de> <20170828212024.GI4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828212024.GI4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 02:20:24PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 28, 2017 at 05:06:12PM +0200, Christoph Hellwig wrote:
> > Currently getbmap uses xfs_bmapi_read to query the extent map, and then
> > fixes up various bits that are eventually reported to userspace.
> > 
> > This patch instead rewrites it to use xfs_iext_lookup_extent and
> > xfs_iext_get_extent to iteratively process the extent map.  This not
> > only avoids the need to allocate a map for the returned xfs_bmbt_irec
> > structures but also greatly simplified the code.
> > 
> > There are two intentional behavior changes compared to the old code:
> > 
> >  - the current code reports unwritten extents that don't directly border
> >    a written one as unwritten even when not passing the BMV_IF_PREALLOC
> >    option, contrary to the documentation.  The new code requires the
> >    BMV_IF_PREALLOC flag to report the unwrittent extent bit.
> >  - The new code does never merges consecutive extents, unlike the old
> >    code that sometimes does it based on the boundaries of the
> >    xfs_bmapi_read calls.  Note that the extent merging behavior was
> >    entirely undocumented.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 499 ++++++++++++++++++-------------------------------
> >  1 file changed, 185 insertions(+), 314 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 93e955262d07..5962f119d4ff 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -404,125 +404,69 @@ xfs_bmap_count_blocks(
> >  	return 0;
> >  }
> >  
> > -/*
> > - * returns 1 for success, 0 if we failed to map the extent.
> > - */
> > -STATIC int
> > -xfs_getbmapx_fix_eof_hole(
> > -	xfs_inode_t		*ip,		/* xfs incore inode pointer */
> > -	int			whichfork,
> > -	struct getbmapx		*out,		/* output structure */
> > -	int			prealloced,	/* this is a file with
> > -						 * preallocated data space */
> > -	int64_t			end,		/* last block requested */
> > -	xfs_fsblock_t		startblock,
> > -	bool			moretocome)
> > +static void
> > +xfs_getbmap_report_one(
> > +	struct xfs_inode		*ip,
> > +	struct getbmapx			*bmv,
> > +	int64_t				bmv_end,
> > +	struct xfs_bmbt_irec		*got,
> > +	struct getbmapx			*p)
> >  {
> > -	int64_t			fixlen;
> > -	xfs_mount_t		*mp;		/* file system mount point */
> > -	xfs_ifork_t		*ifp;		/* inode fork pointer */
> > -	xfs_extnum_t		lastx;		/* last extent pointer */
> > -	xfs_fileoff_t		fileblock;
> > -
> > -	if (startblock == HOLESTARTBLOCK) {
> > -		mp = ip->i_mount;
> > -		out->bmv_block = -1;
> > -		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
> > -		fixlen -= out->bmv_offset;
> > -		if (prealloced && out->bmv_offset + out->bmv_length == end) {
> > -			/* Came to hole at EOF. Trim it. */
> > -			if (fixlen <= 0)
> > -				return 0;
> > -			out->bmv_length = fixlen;
> > -		}
> > +	if (isnullstartblock(got->br_startblock) ||
> > +	    got->br_startblock == DELAYSTARTBLOCK) {
> > +		/*
> > +		 * Delalloc extents that start beyond EOF can occur due to
> > +		 * speculative EOF allocation when the delalloc extent is larger
> > +		 * than the largest freespace extent at conversion time.  These
> > +		 * extents cannot be converted by data writeback, so can exist
> > +		 * here even if we are not supposed to be finding delalloc
> > +		 * extents.
> > +		 */
> > +		if (got->br_startoff < XFS_B_TO_FSB(ip->i_mount, XFS_ISIZE(ip)))
> > +			ASSERT((bmv->bmv_iflags & BMV_IF_DELALLOC) != 0);
> > +
> > +		p->bmv_oflags |= BMV_OF_DELALLOC;
> > +		p->bmv_block = -2;
> >  	} else {
> > -		if (startblock == DELAYSTARTBLOCK)
> > -			out->bmv_block = -2;
> > -		else
> > -			out->bmv_block = xfs_fsb_to_db(ip, startblock);
> > -		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
> > -		ifp = XFS_IFORK_PTR(ip, whichfork);
> > -		if (!moretocome &&
> > -		    xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
> > -		   (lastx == xfs_iext_count(ifp) - 1))
> > -			out->bmv_oflags |= BMV_OF_LAST;
> > +		p->bmv_block = xfs_fsb_to_db(ip, got->br_startblock);
> >  	}
> >  
> > -	return 1;
> > +	if (got->br_state == XFS_EXT_UNWRITTEN &&
> > +	    (bmv->bmv_iflags & BMV_IF_PREALLOC))
> > +		p->bmv_oflags |= BMV_OF_PREALLOC;
> > +
> > +	p->bmv_offset = XFS_FSB_TO_BB(ip->i_mount, got->br_startoff);
> > +	p->bmv_length = XFS_FSB_TO_BB(ip->i_mount, got->br_blockcount);
> > +
> > +	bmv->bmv_offset = p->bmv_offset + p->bmv_length;
> > +	bmv->bmv_length = max(0LL, bmv_end - bmv->bmv_offset);
> > +	bmv->bmv_entries++;
> >  }
> >  
> > -/* Adjust the reported bmap around shared/unshared extent transitions. */
> > -STATIC int
> > -xfs_getbmap_adjust_shared(
> > +static void
> > +xfs_getbmap_report_hole(
> >  	struct xfs_inode		*ip,
> > -	int				whichfork,
> > -	struct xfs_bmbt_irec		*map,
> > -	struct getbmapx			*out,
> > -	struct xfs_bmbt_irec		*next_map)
> > +	struct getbmapx			*bmv,
> > +	int64_t				bmv_end,
> > +	xfs_fileoff_t			bno,
> > +	xfs_fileoff_t			end,
> > +	struct getbmapx			*p)
> >  {
> > -	struct xfs_mount		*mp = ip->i_mount;
> > -	xfs_agnumber_t			agno;
> > -	xfs_agblock_t			agbno;
> > -	xfs_agblock_t			ebno;
> > -	xfs_extlen_t			elen;
> > -	xfs_extlen_t			nlen;
> > -	int				error;
> > +	if (bmv->bmv_iflags & BMV_IF_NO_HOLES)
> > +		return;
> >  
> > -	next_map->br_startblock = NULLFSBLOCK;
> > -	next_map->br_startoff = NULLFILEOFF;
> > -	next_map->br_blockcount = 0;
> > +	p->bmv_block = -1;
> > +	p->bmv_offset = XFS_FSB_TO_BB(ip->i_mount, bno);
> > +	p->bmv_length = XFS_FSB_TO_BB(ip->i_mount, end - bno);
> >  
> > -	/* Only written data blocks can be shared. */
> > -	if (!xfs_is_reflink_inode(ip) ||
> > -	    whichfork != XFS_DATA_FORK ||
> > -	    !xfs_bmap_is_real_extent(map))
> > -		return 0;
> > -
> > -	agno = XFS_FSB_TO_AGNO(mp, map->br_startblock);
> > -	agbno = XFS_FSB_TO_AGBNO(mp, map->br_startblock);
> > -	error = xfs_reflink_find_shared(mp, NULL, agno, agbno,
> > -			map->br_blockcount, &ebno, &elen, true);
> > -	if (error)
> > -		return error;
> > -
> > -	if (ebno == NULLAGBLOCK) {
> > -		/* No shared blocks at all. */
> > -		return 0;
> > -	} else if (agbno == ebno) {
> > -		/*
> > -		 * Shared extent at (agbno, elen).  Shrink the reported
> > -		 * extent length and prepare to move the start of map[i]
> > -		 * to agbno+elen, with the aim of (re)formatting the new
> > -		 * map[i] the next time through the inner loop.
> > -		 */
> > -		out->bmv_length = XFS_FSB_TO_BB(mp, elen);
> > -		out->bmv_oflags |= BMV_OF_SHARED;
> > -		if (elen != map->br_blockcount) {
> > -			*next_map = *map;
> > -			next_map->br_startblock += elen;
> > -			next_map->br_startoff += elen;
> > -			next_map->br_blockcount -= elen;
> > -		}
> > -		map->br_blockcount -= elen;
> > -	} else {
> > -		/*
> > -		 * There's an unshared extent (agbno, ebno - agbno)
> > -		 * followed by shared extent at (ebno, elen).  Shrink
> > -		 * the reported extent length to cover only the unshared
> > -		 * extent and prepare to move up the start of map[i] to
> > -		 * ebno, with the aim of (re)formatting the new map[i]
> > -		 * the next time through the inner loop.
> > -		 */
> > -		*next_map = *map;
> > -		nlen = ebno - agbno;
> > -		out->bmv_length = XFS_FSB_TO_BB(mp, nlen);
> > -		next_map->br_startblock += nlen;
> > -		next_map->br_startoff += nlen;
> > -		next_map->br_blockcount -= nlen;
> > -		map->br_blockcount -= nlen;
> > -	}
> > +	bmv->bmv_offset = p->bmv_offset + p->bmv_length;
> > +	bmv->bmv_length = max(0LL, bmv_end - bmv->bmv_offset);
> > +	bmv->bmv_entries++;
> > +}
> >  
> > -	return 0;
> > +static inline bool xfs_getbmap_full(struct getbmapx *bmv, int nr_entries)
> > +{
> > +	return bmv->bmv_length == 0 || nr_entries >= bmv->bmv_count - 1;
> >  }
> >  
> >  /*
> > @@ -539,119 +483,72 @@ xfs_getbmap(
> >  	xfs_bmap_format_t	formatter,	/* format to user */
> >  	void			*arg)		/* formatter arg */
> >  {
> > -	int64_t			bmvend;		/* last block requested */
> > -	int			error = 0;	/* return value */
> > -	int64_t			fixlen;		/* length for -1 case */
> > -	int			i;		/* extent number */
> > -	int			lock;		/* lock state */
> > -	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
> > -	xfs_mount_t		*mp;		/* file system mount point */
> > -	int			nex;		/* # of user extents can do */
> > -	int			subnex;		/* # of bmapi's can do */
> > -	int			nmap;		/* number of map entries */
> > -	struct getbmapx		*out;		/* output structure */
> > -	int			whichfork;	/* data or attr fork */
> > -	int			prealloced;	/* this is a file with
> > -						 * preallocated data space */
> > -	int			iflags;		/* interface flags */
> > -	int			bmapi_flags;	/* flags for xfs_bmapi */
> > -	int			cur_ext = 0;
> > -	struct xfs_bmbt_irec	inject_map;
> > -
> > -	mp = ip->i_mount;
> > -	iflags = bmv->bmv_iflags;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	int			iflags = bmv->bmv_iflags;
> > +	int			whichfork, lock, i, nr_entries = 0, error = 0;
> > +	int64_t			bmv_end, max_len;
> > +	xfs_fileoff_t		bno, first_bno;
> > +	struct xfs_ifork	*ifp;
> > +	struct getbmapx		*out;
> > +	struct xfs_bmbt_irec	got, rec;
> > +	xfs_filblks_t		len;
> > +	xfs_extnum_t		idx;
> >  
> >  #ifndef DEBUG
> >  	/* Only allow CoW fork queries if we're debugging. */
> >  	if (iflags & BMV_IF_COWFORK)
> >  		return -EINVAL;
> >  #endif
> > +
> >  	if ((iflags & BMV_IF_ATTRFORK) && (iflags & BMV_IF_COWFORK))
> >  		return -EINVAL;
> >  
> > +	if (bmv->bmv_count <= 1)
> > +		return -EINVAL;
> > +	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
> > +		return -ENOMEM;
> > +
> > +	if (bmv->bmv_length < -1)
> > +		return -EINVAL;
> > +
> > +	bmv->bmv_entries = 0;
> > +	if (bmv->bmv_length == 0)
> > +		return 0;
> > +
> > +	out = kmem_zalloc_large(bmv->bmv_count * sizeof(struct getbmapx), 0);
> > +	if (!out)
> > +		return -ENOMEM;
> > +
> >  	if (iflags & BMV_IF_ATTRFORK)
> >  		whichfork = XFS_ATTR_FORK;
> >  	else if (iflags & BMV_IF_COWFORK)
> >  		whichfork = XFS_COW_FORK;
> >  	else
> >  		whichfork = XFS_DATA_FORK;
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> >  
> > +	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> >  	switch (whichfork) {
> >  	case XFS_ATTR_FORK:
> > -		if (XFS_IFORK_Q(ip)) {
> > -			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
> > -			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
> > -			    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
> > -				return -EINVAL;
> > -		} else if (unlikely(
> > -			   ip->i_d.di_aformat != 0 &&
> > -			   ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS)) {
> > -			XFS_ERROR_REPORT("xfs_getbmap", XFS_ERRLEVEL_LOW,
> > -					 ip->i_mount);
> > -			return -EFSCORRUPTED;
> > -		}
> > +		if (!XFS_IFORK_Q(ip))
> > +			goto out_unlock_iolock;
> >  
> > -		prealloced = 0;
> > -		fixlen = 1LL << 32;
> > +		max_len = 1LL << 32;
> > +		lock = xfs_ilock_attr_map_shared(ip);
> >  		break;
> >  	case XFS_COW_FORK:
> > -		if (ip->i_cformat != XFS_DINODE_FMT_EXTENTS)
> > -			return -EINVAL;
> > +		/* No CoW fork? Just return */
> > +		if (!ifp)
> > +			goto out_unlock_iolock;
> >  
> > -		if (xfs_get_cowextsz_hint(ip)) {
> > -			prealloced = 1;
> > -			fixlen = mp->m_super->s_maxbytes;
> > -		} else {
> > -			prealloced = 0;
> > -			fixlen = XFS_ISIZE(ip);
> > -		}
> > -		break;
> > -	default:
> > -		/* Local format data forks report no extents. */
> > -		if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> > -			bmv->bmv_entries = 0;
> > -			return 0;
> > -		}
> > -		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > -		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
> > -			return -EINVAL;
> > +		if (xfs_get_cowextsz_hint(ip))
> > +			max_len = mp->m_super->s_maxbytes;
> > +		else
> > +			max_len = XFS_ISIZE(ip);
> >  
> > -		if (xfs_get_extsz_hint(ip) ||
> > -		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
> > -			prealloced = 1;
> > -			fixlen = mp->m_super->s_maxbytes;
> > -		} else {
> > -			prealloced = 0;
> > -			fixlen = XFS_ISIZE(ip);
> > -		}
> > +		lock = XFS_ILOCK_SHARED;
> > +		xfs_ilock(ip, lock);
> >  		break;
> > -	}
> > -
> > -	if (bmv->bmv_length == -1) {
> > -		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
> > -		bmv->bmv_length =
> > -			max_t(int64_t, fixlen - bmv->bmv_offset, 0);
> > -	} else if (bmv->bmv_length == 0) {
> > -		bmv->bmv_entries = 0;
> > -		return 0;
> > -	} else if (bmv->bmv_length < 0) {
> > -		return -EINVAL;
> > -	}
> > -
> > -	nex = bmv->bmv_count - 1;
> > -	if (nex <= 0)
> > -		return -EINVAL;
> > -	bmvend = bmv->bmv_offset + bmv->bmv_length;
> > -
> > -
> > -	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
> > -		return -ENOMEM;
> > -	out = kmem_zalloc_large(bmv->bmv_count * sizeof(struct getbmapx), 0);
> > -	if (!out)
> > -		return -ENOMEM;
> > -
> > -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > -	switch (whichfork) {
> >  	case XFS_DATA_FORK:
> >  		if (!(iflags & BMV_IF_DELALLOC) &&
> >  		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
> > @@ -669,147 +566,121 @@ xfs_getbmap(
> >  			 */
> >  		}
> >  
> > +		if (xfs_get_extsz_hint(ip) ||
> > +		    (ip->i_d.di_flags &
> > +		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
> > +			max_len = mp->m_super->s_maxbytes;
> > +		else
> > +			max_len = XFS_ISIZE(ip);
> > +
> >  		lock = xfs_ilock_data_map_shared(ip);
> >  		break;
> > -	case XFS_COW_FORK:
> > -		lock = XFS_ILOCK_SHARED;
> > -		xfs_ilock(ip, lock);
> > -		break;
> > -	case XFS_ATTR_FORK:
> > -		lock = xfs_ilock_attr_map_shared(ip);
> > +	}
> > +
> > +	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
> > +	case XFS_DINODE_FMT_EXTENTS:
> > +	case XFS_DINODE_FMT_BTREE:
> >  		break;
> > +	case XFS_DINODE_FMT_LOCAL:
> > +		/* Local format inode forks report no extents. */
> > +		goto out_unlock_ilock;
> > +	default:
> > +		error = -EINVAL;
> > +		goto out_unlock_ilock;
> >  	}
> >  
> > -	/*
> > -	 * Don't let nex be bigger than the number of extents
> > -	 * we can have assuming alternating holes and real extents.
> > -	 */
> > -	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
> > -		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
> > +	if (bmv->bmv_length == -1) {
> > +		max_len = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, max_len));
> > +		bmv->bmv_length = max(0LL, max_len - bmv->bmv_offset);
> > +	}
> >  
> > -	bmapi_flags = xfs_bmapi_aflag(whichfork);
> > -	if (!(iflags & BMV_IF_PREALLOC))
> > -		bmapi_flags |= XFS_BMAPI_IGSTATE;
> > +	bmv_end = bmv->bmv_offset + bmv->bmv_length;
> >  
> > -	/*
> > -	 * Allocate enough space to handle "subnex" maps at a time.
> > -	 */
> > -	error = -ENOMEM;
> > -	subnex = 16;
> > -	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL | KM_NOFS);
> > -	if (!map)
> > +	first_bno = bno = XFS_BB_TO_FSBT(mp, bmv->bmv_offset);
> > +	len = XFS_BB_TO_FSB(mp, bmv->bmv_length);
> > +
> > +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +		error = xfs_iread_extents(NULL, ip, whichfork);
> > +		if (error)
> > +			goto out_unlock_ilock;
> > +	}
> > +
> > +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got))
> >  		goto out_unlock_ilock;
> >  
> > -	bmv->bmv_entries = 0;
> > +	while (!xfs_getbmap_full(bmv, nr_entries)) {
> > +		struct getbmapx		*p = &out[nr_entries];
> >  
> > -	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
> > -	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
> > -		error = 0;
> > -		goto out_free_map;
> > -	}
> > +		xfs_trim_extent(&got, first_bno, len);
> >  
> > -	do {
> > -		nmap = (nex> subnex) ? subnex : nex;
> > -		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
> > -				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
> > -				       map, &nmap, bmapi_flags);
> > -		if (error)
> > -			goto out_free_map;
> > -		ASSERT(nmap <= subnex);
> > -
> > -		for (i = 0; i < nmap && bmv->bmv_length &&
> > -				cur_ext < bmv->bmv_count - 1; i++) {
> > -			out[cur_ext].bmv_oflags = 0;
> > -			if (map[i].br_state == XFS_EXT_UNWRITTEN)
> > -				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
> > -			else if (map[i].br_startblock == DELAYSTARTBLOCK)
> > -				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
> > -			out[cur_ext].bmv_offset =
> > -				XFS_FSB_TO_BB(mp, map[i].br_startoff);
> > -			out[cur_ext].bmv_length =
> > -				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
> > -			out[cur_ext].bmv_unused1 = 0;
> > -			out[cur_ext].bmv_unused2 = 0;
> > +		/*
> > +		 * Report an entry for a hole if this extent doesn't directly
> > +		 * follow the previous one.
> > +		 */
> > +		if (got.br_startoff > bno) {
> > +			xfs_getbmap_report_hole(ip, bmv, bmv_end, bno,
> > +					got.br_startoff, p++);
> > +			if (xfs_getbmap_full(bmv, ++nr_entries))
> > +				break;
> > +		}
> >  
> > -			/*
> > -			 * delayed allocation extents that start beyond EOF can
> > -			 * occur due to speculative EOF allocation when the
> > -			 * delalloc extent is larger than the largest freespace
> > -			 * extent at conversion time. These extents cannot be
> > -			 * converted by data writeback, so can exist here even
> > -			 * if we are not supposed to be finding delalloc
> > -			 * extents.
> > -			 */
> > -			if (map[i].br_startblock == DELAYSTARTBLOCK &&
> > -			    map[i].br_startoff < XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
> > -				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
> > -
> > -                        if (map[i].br_startblock == HOLESTARTBLOCK &&
> > -			    whichfork == XFS_ATTR_FORK) {
> > -				/* came to the end of attribute fork */
> > -				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
> > -				goto out_free_map;
> > -			}
> > +		/*
> > +		 * In order to report shared extents accurately, we report each
> > +		 * distinct shared / unshared part of a single bmbt record with
> > +		 * an individual getbmapx record.
> > +		 */
> > +		rec = got;
> > +		for (;;) {
> 
> while (!xfs_getbmap_full()) ?

Yeah.

> > -			if (!xfs_getbmapx_fix_eof_hole(ip, whichfork,
> > -					&out[cur_ext], prealloced, bmvend,
> > -					map[i].br_startblock,
> > -					inject_map.br_startblock != NULLFSBLOCK))
> > -				goto out_free_map;
> > +			xfs_getbmap_report_one(ip, bmv, bmv_end, &rec, p);
> > +			if (shared)
> > +				p->bmv_oflags |= BMV_OF_SHARED;
> 
> Shouldn't we advance p/nr_entries?  What if we have a single partially
> shared extent?  Also, what's the difference between nr_entries and
> bmv->bmv_entries?  They both track the number of bmv entries we've
> filled out, right?

We should, but I messed it up.  And no test caught it..

> > +		if (!xfs_iext_get_extent(ifp, ++idx, &got)) {
> > +			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> > +
> > +			p->bmv_oflags |= BMV_OF_LAST;
> 
> Isn't BMV_OF_LAST supposed to be set only on the last extent of the
> dataset returned?  If I ask for the mappings for blocks 100-200 and
> there's a hole from 190-200, shouldn't OF_LAST be set on the 190-200
> extent?

BMV_OF_LAST doesn't seem to be document, and isn't checked by any
any userspace I could find.  But my interpretation was that it's
supposed to be set on the last extent of a file, based on:

#define BMV_OF_LAST             0x4     /* segment is the last in the file */

now of course we could argue of a hole is an extent in a file; 
by any normal defintion it isn't, but in terms of getbmap it
could be considered one.

The old code did this to set it:

	if (startblock == HOLESTARTBLOCK) {
		...
	} else {
		....
		if (!moretocome &&
		    xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
		   (lastx == xfs_iext_count(ifp) - 1))
			out->bmv_oflags |= BMV_OF_LAST;
	}

which means it sets it on the last actually allocated extent in a file
for the general ase.

But it also does a weird thing for holes in attr forks where it sets
BMV_OF_LAST on an entry that is beyond bmv_entries and this should
not even be considered valid by the caller.

