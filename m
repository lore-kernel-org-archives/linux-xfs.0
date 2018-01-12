Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60240 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754006AbeALAYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 19:24:54 -0500
Date: Thu, 11 Jan 2018 16:24:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/27] xfs_scrub: add file space map iteration functions
Message-ID: <20180112002435.GL5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520354940.2027.10483445005054005807.stgit@magnolia>
 <149cf293-b65f-f013-50d8-964f072b8ae2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149cf293-b65f-f013-50d8-964f072b8ae2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 05:19:22PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:52 PM, Darrick J. Wong wrote:
> 
> 
> > + * These routines provide a simple interface to query the block
> > + * mappings of the fork of a given inode via GETBMAPX and call a
> > + * function to iterate each mapping result.
> > + */
> > +
> > +#define BMAP_NR		2048
> > +
> > +/* Iterate all the extent block mappings between the key and fork end. */
> > +bool
> > +xfs_iterate_filemaps(
> > +	struct scrub_ctx	*ctx,
> > +	const char		*descr,
> > +	int			fd,
> > +	int			whichfork,
> > +	struct xfs_bmap		*key,
> 
> <coverity pass>
> 
> Ok key is an xfs_bmap:
> 
> /* inode fork block mapping */
> struct xfs_bmap {
>         uint64_t        bm_offset;      /* file offset of segment in bytes */
>         uint64_t        bm_physical;    /* physical starting byte  */
>         uint64_t        bm_length;      /* length of segment, bytes */
>         uint32_t        bm_flags;       /* output flags */
> };
> 
> > +	xfs_bmap_iter_fn	fn,
> > +	void			*arg)
> > +{
> > +	struct fsxattr		fsx;
> > +	struct getbmapx		*map
> map is a getbmapx ...
> 
> struct getbmapx {
>         __s64           bmv_offset;     /* file offset of segment in blocks */
>         __s64           bmv_block;      /* starting block (64-bit daddr_t)  */
>         __s64           bmv_length;     /* length of segment, blocks        */
>         __s32           bmv_count;      /* # of entries in array incl. 1st  */
>         __s32           bmv_entries;    /* # of entries filled in (output). */
>         __s32           bmv_iflags;     /* input flags (1st structure)      */
>         __s32           bmv_oflags;     /* output flags (after 1st structure)*/
>         __s32           bmv_unused1;    /* future use                       */
>         __s32           bmv_unused2;    /* future use                       */
> };
> 
> ...
> 
> > +out:
> > +	memcpy(key, map, sizeof(struct getbmapx));
> 
> so I don't think that fits, right?

I can't remember why this line is even needed, so away it goes.

--D

> 
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
