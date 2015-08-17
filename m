Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6955F29DF5
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:20:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 657888F8037
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:20:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EGGXk1w5va7E8FdB for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:20:33 -0700 (PDT)
Message-ID: <55D23400.7020106@sandeen.net>
Date: Mon, 17 Aug 2015 14:20:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 03/10] xfs_repair: ignore "repaired" flag after we decide
	to clear xattr block
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014357.1839.68720.stgit@birch.djwong.org>
In-Reply-To: <20150815014357.1839.68720.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <djwong@alder.djwong.org>, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

On 8/14/15 8:43 PM, Darrick J. Wong wrote:
> If in the course of examining extended attribute block contents we
> first decide to repair an entry (*repair = 1) but secondly decide to
> clear the whole block, set *repair = 0 because the clearing action
> only happens if *repair == 0.  Put another way, if we're nuking a
> block, don't pretend like we've fixed it too.

Hm, or what happens otherwise?

TBH this is making my brain hurt, chasing it all the way back up
the callchain.  It's *repair not *repaired; it's not saying we
fixed it, but that we should fix it, right?  It'll take me a while
to work out what all the callers do with the "clearit" return from
process_attr_leaf_block and with *repair.

Did you have a specific example of something going wrong?

thanks,
-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/attr_repair.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 62f80e7..2bd9334 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -1311,6 +1311,13 @@ process_leaf_attr_block(
>  		* we can add it then.
>  		*/
>  	}
> +	/*
> +	 * If we're just going to zap the block, don't pretend like we
> +	 * repaired it, because repairing the block stops the clear
> +	 * operation.
> +	 */
> +	if (clearit)
> +		*repair = 0;
>  	if (*repair)
>  		xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, leaf, &leafhdr);
>  
> @@ -1524,6 +1531,7 @@ process_longform_attr(
>  	xfs_dahash_t	next_hashval;
>  	int		repairlinks = 0;
>  	struct xfs_attr3_icleaf_hdr leafhdr;
> +	int		error;
>  
>  	*repair = 0;
>  
> @@ -1604,12 +1612,16 @@ process_longform_attr(
>  			libxfs_writebuf(bp, 0);
>  		} else
>  			libxfs_putbuf(bp);
> -		return (process_node_attr(mp, ino, dip, blkmap)); /* + repair */
> +		error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
> +		if (error)
> +			*repair = 0;
> +		return error;
>  	default:
>  		do_warn(
>  	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
>  			be16_to_cpu(leaf->hdr.info.magic), ino);
>  		libxfs_putbuf(bp);
> +		*repair = 0;
>  		return(1);
>  	}
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
