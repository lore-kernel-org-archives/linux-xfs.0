Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n36Numse222785 for <xfs@oss.sgi.com>; Mon, 6 Apr 2009 18:56:58 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 795E51F3408
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2009 16:56:27 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 3Fb6byx39tqeyA6e for
	<xfs@oss.sgi.com>; Mon, 06 Apr 2009 16:56:27 -0700 (PDT)
Message-ID: <49DA96A6.2010201@sandeen.net>
Date: Mon, 06 Apr 2009 16:56:22 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: fix getbmap vs mmap deadlock
References: <20090224133902.GC15820@infradead.org>
In-Reply-To: <20090224133902.GC15820@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> xfs_getbmap (or rather the formatters called by it) copy out the getbmap
> structures under the ilock, which can deadlock against mmap.  This has
> been reported via bugzilla a while ago (#717) and has recently also
> shown up via lockdep.
> 
> So allocate a temporary buffer to format the kernel getbmap structures
> into and then copy them out after dropping the locks.
> 
> A little problem with this is that we limit the number of extents we
> can copy out by the maximum allocation size, but I see no real way
> around that.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-23 20:38:27.512925014 +0100
> +++ xfs/fs/xfs/xfs_bmap.c	2009-02-23 20:40:46.720926193 +0100
> @@ -5867,12 +5867,13 @@ xfs_getbmap(
>  	int			nexleft;	/* # of user extents left */
>  	int			subnex;		/* # of bmapi's can do */
>  	int			nmap;		/* number of map entries */
> -	struct getbmapx		out;		/* output structure */
> +	struct getbmapx		*out;		/* output structure */
>  	int			whichfork;	/* data or attr fork */
>  	int			prealloced;	/* this is a file with
>  						 * preallocated data space */
>  	int			iflags;		/* interface flags */
>  	int			bmapi_flags;	/* flags for xfs_bmapi */
> +	int			cur_ext = 0;
>  
>  	mp = ip->i_mount;
>  	iflags = bmv->bmv_iflags;
> @@ -5948,6 +5949,13 @@ xfs_getbmap(
>  		return XFS_ERROR(EINVAL);
>  	bmvend = bmv->bmv_offset + bmv->bmv_length;
>  
> +
> +	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
> +		return XFS_ERROR(ENOMEM);
> +	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
> +	if (!out)
> +		return XFS_ERROR(ENOMEM);
> +
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
>  		if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
> @@ -6001,39 +6009,39 @@ xfs_getbmap(
>  		ASSERT(nmap <= subnex);
>  
>  		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
> -			int full = 0;	/* user array is full */
> -
> -			out.bmv_oflags = 0;
> +			out[cur_ext].bmv_oflags = 0;
>  			if (map[i].br_state == XFS_EXT_UNWRITTEN)
> -				out.bmv_oflags |= BMV_OF_PREALLOC;
> +				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
>  			else if (map[i].br_startblock == DELAYSTARTBLOCK)
> -				out.bmv_oflags |= BMV_OF_DELALLOC;
> -			out.bmv_offset = XFS_FSB_TO_BB(mp, map[i].br_startoff);
> -			out.bmv_length = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
> -			out.bmv_unused1 = out.bmv_unused2 = 0;
> +				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
> +			out[cur_ext].bmv_offset =
> +				XFS_FSB_TO_BB(mp, map[i].br_startoff);
> +			out[cur_ext].bmv_length =
> +				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
> +			out[cur_ext].bmv_unused1 = 0;
> +			out[cur_ext].bmv_unused2 = 0;
>  			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
>  			      (map[i].br_startblock != DELAYSTARTBLOCK));
>                          if (map[i].br_startblock == HOLESTARTBLOCK &&
>  			    whichfork == XFS_ATTR_FORK) {
>  				/* came to the end of attribute fork */
> -				out.bmv_oflags |= BMV_OF_LAST;
> +				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
>  				goto out_free_map;
>  			}
>  
> -			if (!xfs_getbmapx_fix_eof_hole(ip, &out, prealloced,
> -					bmvend, map[i].br_startblock))
> +			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
> +					prealloced, bmvend,
> +					map[i].br_startblock))
>  				goto out_free_map;
>  
> -			/* format results & advance arg */
> -			error = formatter(&arg, &out, &full);
> -			if (error || full)
> -				goto out_free_map;
>  			nexleft--;
>  			bmv->bmv_offset =
> -				out.bmv_offset + out.bmv_length;
> +				out[cur_ext].bmv_offset +
> +				out[cur_ext].bmv_length;
>  			bmv->bmv_length =
>  				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
>  			bmv->bmv_entries++;
> +			cur_ext++;
>  		}
>  	} while (nmap && nexleft && bmv->bmv_length);
>  
> @@ -6043,6 +6051,16 @@ xfs_getbmap(
>  	xfs_iunlock_map_shared(ip, lock);
>   out_unlock_iolock:
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +
> +	for (i = 0; i < cur_ext; i++) {
> +		int full = 0;	/* user array is full */
> +
> +		/* format results & advance arg */
> +		error = formatter(&arg, &out[i], &full);
> +		if (error || full)
> +			break;
> +	}
> +
>  	return error;
>  }
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
