Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T7jBG2118139 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:45:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E79131C7B697
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:44:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DEMrT8Pa0x1Gww9x for
	<xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:44:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Lnpgw-0004N8-Dd
	for xfs@oss.sgi.com; Sun, 29 Mar 2009 07:44:26 +0000
Date: Sun, 29 Mar 2009 03:44:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: a couple getbmap cleanups
Message-ID: <20090329074426.GC16402@infradead.org>
References: <20090224133858.GB15820@infradead.org>
	<20090316063053.GB4957@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316063053.GB4957@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

ping^2?

On Mon, Mar 16, 2009 at 02:30:53AM -0400, Christoph Hellwig wrote:
> ping?
> 
> On Tue, Feb 24, 2009 at 08:38:58AM -0500, Christoph Hellwig wrote:
> >  - reshuffle various conditionals for data vs attr fork to make the code
> >    more readable
> >  - do fine-grainded goto-based error handling
> >  - exit early from conditionals instead of keeping a long else branch
> >    around
> >  - allow kmem_alloc to fail
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: xfs/fs/xfs/xfs_bmap.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-23 18:08:35.352924726 +0100
> > +++ xfs/fs/xfs/xfs_bmap.c	2009-02-23 18:23:49.527051836 +0100
> > @@ -5857,7 +5857,7 @@ xfs_getbmap(
> >  	void			*arg)		/* formatter arg */
> >  {
> >  	__int64_t		bmvend;		/* last block requested */
> > -	int			error;		/* return value */
> > +	int			error = 0;	/* return value */
> >  	__int64_t		fixlen;		/* length for -1 case */
> >  	int			i;		/* extent number */
> >  	int			lock;		/* lock state */
> > @@ -5876,30 +5876,8 @@ xfs_getbmap(
> >  
> >  	mp = ip->i_mount;
> >  	iflags = bmv->bmv_iflags;
> > -
> >  	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
> >  
> > -	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
> > -	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
> > -	 *	bit is set for the file, generate a read event in order
> > -	 *	that the DMAPI application may do its thing before we return
> > -	 *	the extents.  Usually this means restoring user file data to
> > -	 *	regions of the file that look like holes.
> > -	 *
> > -	 *	The "old behavior" (from XFS_IOC_GETBMAP) is to not specify
> > -	 *	BMV_IF_NO_DMAPI_READ so that read events are generated.
> > -	 *	If this were not true, callers of ioctl( XFS_IOC_GETBMAP )
> > -	 *	could misinterpret holes in a DMAPI file as true holes,
> > -	 *	when in fact they may represent offline user data.
> > -	 */
> > -	if ((iflags & BMV_IF_NO_DMAPI_READ) == 0 &&
> > -	    DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
> > -	    whichfork == XFS_DATA_FORK) {
> > -		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, 0, 0, 0, NULL);
> > -		if (error)
> > -			return XFS_ERROR(error);
> > -	}
> > -
> >  	if (whichfork == XFS_ATTR_FORK) {
> >  		if (XFS_IFORK_Q(ip)) {
> >  			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
> > @@ -5913,11 +5891,37 @@ xfs_getbmap(
> >  					 ip->i_mount);
> >  			return XFS_ERROR(EFSCORRUPTED);
> >  		}
> > -	} else if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > -		   ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
> > -		   ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > -		return XFS_ERROR(EINVAL);
> > -	if (whichfork == XFS_DATA_FORK) {
> > +
> > +		prealloced = 0;
> > +		fixlen = 1LL << 32;
> > +	} else {
> > +		/*
> > +		 * If the BMV_IF_NO_DMAPI_READ interface bit specified, do
> > +		 * not generate a DMAPI read event.  Otherwise, if the
> > +		 * DM_EVENT_READ bit is set for the file, generate a read
> > +		 * event in order that the DMAPI application may do its thing
> > +		 * before we return the extents.  Usually this means restoring
> > +		 * user file data to regions of the file that look like holes.
> > +		 *
> > +		 * The "old behavior" (from XFS_IOC_GETBMAP) is to not specify
> > +		 * BMV_IF_NO_DMAPI_READ so that read events are generated.
> > +		 * If this were not true, callers of ioctl(XFS_IOC_GETBMAP)
> > +		 * could misinterpret holes in a DMAPI file as true holes,
> > +		 * when in fact they may represent offline user data.
> > +		 */
> > +		if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
> > +		    !(iflags & BMV_IF_NO_DMAPI_READ)) {
> > +			error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip,
> > +					      0, 0, 0, NULL);
> > +			if (error)
> > +				return XFS_ERROR(error);
> > +		}
> > +
> > +		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > +		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
> > +		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > +			return XFS_ERROR(EINVAL);
> > +
> >  		if (xfs_get_extsz_hint(ip) ||
> >  		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
> >  			prealloced = 1;
> > @@ -5926,42 +5930,34 @@ xfs_getbmap(
> >  			prealloced = 0;
> >  			fixlen = ip->i_size;
> >  		}
> > -	} else {
> > -		prealloced = 0;
> > -		fixlen = 1LL << 32;
> >  	}
> >  
> >  	if (bmv->bmv_length == -1) {
> >  		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
> > -		bmv->bmv_length = MAX( (__int64_t)(fixlen - bmv->bmv_offset),
> > -					(__int64_t)0);
> > -	} else if (bmv->bmv_length < 0)
> > -		return XFS_ERROR(EINVAL);
> > -	if (bmv->bmv_length == 0) {
> > +		bmv->bmv_length =
> > +			max_t(__int64_t, fixlen - bmv->bmv_offset, 0);
> > +	} else if (bmv->bmv_length == 0) {
> >  		bmv->bmv_entries = 0;
> >  		return 0;
> > +	} else if (bmv->bmv_length < 0) {
> > +		return XFS_ERROR(EINVAL);
> >  	}
> > +
> >  	nex = bmv->bmv_count - 1;
> >  	if (nex <= 0)
> >  		return XFS_ERROR(EINVAL);
> >  	bmvend = bmv->bmv_offset + bmv->bmv_length;
> >  
> >  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > -
> > -	if (((iflags & BMV_IF_DELALLOC) == 0) &&
> > -	    (whichfork == XFS_DATA_FORK) &&
> > -	    (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
> > -		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
> > -		error = xfs_flush_pages(ip, (xfs_off_t)0,
> > -					       -1, 0, FI_REMAPF);
> > -		if (error) {
> > -			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> > -		return error;
> > +	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
> > +		if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
> > +			error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
> > +			if (error)
> > +				goto out_unlock_iolock;
> >  		}
> > -	}
> >  
> > -	ASSERT(whichfork == XFS_ATTR_FORK || (iflags & BMV_IF_DELALLOC) ||
> > -	       ip->i_delayed_blks == 0);
> > +		ASSERT(ip->i_delayed_blks == 0);
> > +	}
> >  
> >  	lock = xfs_ilock_map_shared(ip);
> >  
> > @@ -5972,23 +5968,24 @@ xfs_getbmap(
> >  	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
> >  		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
> >  
> > -	bmapi_flags = xfs_bmapi_aflag(whichfork) |
> > -			((iflags & BMV_IF_PREALLOC) ? 0 : XFS_BMAPI_IGSTATE);
> > +	bmapi_flags = xfs_bmapi_aflag(whichfork);
> > +	if (!(iflags & BMV_IF_PREALLOC))
> > +		bmapi_flags |= XFS_BMAPI_IGSTATE;
> >  
> >  	/*
> >  	 * Allocate enough space to handle "subnex" maps at a time.
> >  	 */
> >  	subnex = 16;
> > -	map = kmem_alloc(subnex * sizeof(*map), KM_SLEEP);
> > +	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL);
> > +	if (!map)
> > +		goto out_unlock_ilock;
> >  
> >  	bmv->bmv_entries = 0;
> >  
> > -	if ((XFS_IFORK_NEXTENTS(ip, whichfork) == 0)) {
> > -		if (((iflags & BMV_IF_DELALLOC) == 0) ||
> > -		    whichfork == XFS_ATTR_FORK) {
> > -			error = 0;
> > -			goto unlock_and_return;
> > -		}
> > +	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
> > +	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
> > +		error = 0;
> > +		goto out_free_map;
> >  	}
> >  
> >  	nexleft = nex;
> > @@ -6000,10 +5997,12 @@ xfs_getbmap(
> >  				  bmapi_flags, NULL, 0, map, &nmap,
> >  				  NULL, NULL);
> >  		if (error)
> > -			goto unlock_and_return;
> > +			goto out_free_map;
> >  		ASSERT(nmap <= subnex);
> >  
> >  		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
> > +			int full = 0;	/* user array is full */
> > +
> >  			out.bmv_oflags = 0;
> >  			if (map[i].br_state == XFS_EXT_UNWRITTEN)
> >  				out.bmv_oflags |= BMV_OF_PREALLOC;
> > @@ -6018,36 +6017,32 @@ xfs_getbmap(
> >  			    whichfork == XFS_ATTR_FORK) {
> >  				/* came to the end of attribute fork */
> >  				out.bmv_oflags |= BMV_OF_LAST;
> > -				goto unlock_and_return;
> > -			} else {
> > -				int full = 0;	/* user array is full */
> > -
> > -				if (!xfs_getbmapx_fix_eof_hole(ip, &out,
> > -							prealloced, bmvend,
> > -							map[i].br_startblock)) {
> > -					goto unlock_and_return;
> > -				}
> > -
> > -				/* format results & advance arg */
> > -				error = formatter(&arg, &out, &full);
> > -				if (error || full)
> > -					goto unlock_and_return;
> > -				nexleft--;
> > -				bmv->bmv_offset =
> > -					out.bmv_offset + out.bmv_length;
> > -				bmv->bmv_length = MAX((__int64_t)0,
> > -					(__int64_t)(bmvend - bmv->bmv_offset));
> > -				bmv->bmv_entries++;
> > +				goto out_free_map;
> >  			}
> > +
> > +			if (!xfs_getbmapx_fix_eof_hole(ip, &out, prealloced,
> > +					bmvend, map[i].br_startblock))
> > +				goto out_free_map;
> > +
> > +			/* format results & advance arg */
> > +			error = formatter(&arg, &out, &full);
> > +			if (error || full)
> > +				goto out_free_map;
> > +			nexleft--;
> > +			bmv->bmv_offset =
> > +				out.bmv_offset + out.bmv_length;
> > +			bmv->bmv_length =
> > +				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
> > +			bmv->bmv_entries++;
> >  		}
> >  	} while (nmap && nexleft && bmv->bmv_length);
> >  
> > -unlock_and_return:
> > + out_free_map:
> > +	kmem_free(map);
> > + out_unlock_ilock:
> >  	xfs_iunlock_map_shared(ip, lock);
> > + out_unlock_iolock:
> >  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> > -
> > -	kmem_free(map);
> > -
> >  	return error;
> >  }
> >  
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
