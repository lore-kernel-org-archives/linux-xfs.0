Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3TSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 15:18:41 -0400
Date: Tue, 30 Apr 2019 12:18:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430191825.GF5217@magnolia>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190430190525.GB2780@tuebingen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 30, 2019 at 09:05:25PM +0200, Andre Noll wrote:
> On Tue, Apr 30, 10:40, Darrick J. Wong wrote
> > > With CONFIG_XFS_DEBUG=n the mount succeeded, and xfs_info says
> > > 
> > > 	meta-data=/dev/mapper/zeal-tst   isize=512    agcount=101, agsize=268435392 blks
> > > 		 =                       sectsz=4096  attr=2, projid32bit=1
> > > 		 =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> > > 		 =                       reflink=0
> > > 	data     =                       bsize=4096   blocks=26843545600, imaxpct=1
> > 
> > Oh, wait, you have a 100T filesystem with a runt AG at the end due to
> > the raid striping...
> > 
> > 26843545600 % 268435392 == 6400 blocks (in AG 100)
> > 
> > And that's why there's 6,392 free blocks in an AG and an attempted
> > reservation of 267,367 blocks.
> 
> Jup, that nails it.
> 
> > In that case, the patch you want is c08768977b9 ("xfs: finobt AG
> > reserves don't consider last AG can be a runt") which has not been
> > backported to 4.9.  That patch relies on a function introduced in
> > 21ec54168b36 ("xfs: create block pointer check functions") and moved to
> > a different file in 86210fbebae6e ("xfs: move various type verifiers to
> > common file").
> > 
> > The c087 patch which will generate appropriately sized reservations for
> > the last AG if it is significantly smaller than the the other and should
> > fix the assertion failure.
> 
> Great. Thanks a lot for digging out these commits.
> 
> Would you be willing to support backporting this commit to
> 4.9.x? IOW, something like the below (against 4.9.171) which puts
> xfs_inobt_max_size() into libxfs/xfs_ialloc_btree.c. Seems to work
> fine.
> 
> Best
> Andre
> ---
> commit f847bda4d612744ff1812788417bd8df41a806d3
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Mon Nov 19 13:31:08 2018 -0800
> 
>     xfs: finobt AG reserves don't consider last AG can be a runt
>     
>     This is a backport of upstream commit c08768977b9 and the part of
>     21ec54168b36 which is needed by c08768977b9.

You could send this patch to the stable list, but my guess is that
they'd prefer a straight backport of all three commits...

>     
>     Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Tested-by: Andre Noll <maan@tuebingen.mpg.de>
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b9c351ff0422..33905989929e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -502,17 +502,33 @@ xfs_inobt_rec_check_count(
>  }
>  #endif	/* DEBUG */
>  
> +/* Find the size of the AG, in blocks. */
> +static xfs_agblock_t
> +xfs_ag_block_count(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +
> +	if (agno < mp->m_sb.sb_agcount - 1)
> +		return mp->m_sb.sb_agblocks;
> +	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
> +}

...because this piece ^^^ is going to cause gcc errors if anyone
(remember they have AI bots to do the mechanical parts now) backports
the original 21ec5 and 86210 commits and now there are two copies of
this function.

As for the general idea of supplying a xfs_ag_block_count function and
teaching xfs_inobt_max_size to use it, yes, I'd support that. :)

--D

> +
>  static xfs_extlen_t
>  xfs_inobt_max_size(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
>  {
> +	xfs_agblock_t		agblocks = xfs_ag_block_count(mp, agno);
> +
>  	/* Bail out if we're uninitialized, which can happen in mkfs. */
>  	if (mp->m_inobt_mxr[0] == 0)
>  		return 0;
>  
>  	return xfs_btree_calc_size(mp, mp->m_inobt_mnr,
> -		(uint64_t)mp->m_sb.sb_agblocks * mp->m_sb.sb_inopblock /
> -				XFS_INODES_PER_CHUNK);
> +				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
> +					XFS_INODES_PER_CHUNK);
>  }
>  
>  static int
> @@ -558,7 +574,7 @@ xfs_finobt_calc_reserves(
>  	if (error)
>  		return error;
>  
> -	*ask += xfs_inobt_max_size(mp);
> +	*ask += xfs_inobt_max_size(mp, agno);
>  	*used += tree_len;
>  	return 0;
>  }
> -- 
> Max Planck Institute for Developmental Biology
> Max-Planck-Ring 5, 72076 Tübingen, Germany. Phone: (+49) 7071 601 829
> http://people.tuebingen.mpg.de/maan/
