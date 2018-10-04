Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbeJEFSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 01:18:44 -0400
Date: Thu, 4 Oct 2018 15:23:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Message-ID: <20181004222309.GL19324@magnolia>
References: <20181004205749.2042-1-stefanrin@gmail.com>
 <20181004205749.2042-2-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004205749.2042-2-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 10:57:49PM +0200, Stefan Ring wrote:
> I have empirically found and tried to fix some places where stale data was not properly zeroed out.
> 
> In the order of the code changes:
> 
> The "freeindex" blocks in inode directories, from last entry to end of block.
> 
> XFS_DIR2_LEAF1_MAGIC, from last entry to end of block.
> 
> In btree format inodes before as well as after the btree pointers.
> 
> In dev inodes, everything after the header.

Mostly looks ok, but with some style issues:

> ---
>  db/metadump.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 69 insertions(+), 5 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index cc2ae9af..e7159cd1 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1421,12 +1421,42 @@ process_sf_attr(
>  		memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
>  }
>  
> +static void
> +process_dir_free_block(
> +	char				*block)
> +{
> +	struct xfs_dir2_free		*free;
> +	struct xfs_dir3_icfree_hdr	freehdr;
> +
> +	if (!zero_stale_data)
> +		return;
> +
> +	free = (struct xfs_dir2_free *)block;
> +	M_DIROPS(mp)->free_hdr_from_disk(&freehdr, free);
> +
> +	/* Zero out space from end of bests[] to end of block */
> +	if (freehdr.magic == XFS_DIR2_FREE_MAGIC) {

How about XFS_DIR3_FREE_MAGIC ?

> +		__be16			*bests;
> +		char			*high;
> +		int			used;
> +
> +		bests = M_DIROPS(mp)->free_bests_p(free);
> +		high = (char *)&bests[freehdr.nvalid];
> +		used = high - (char*)free;
> +		memset(high, 0, mp->m_sb.sb_blocksize - used);
> +		iocur_top->need_crc = 1;
> +	}
> +	else if (show_warnings)

Though perhaps this should be structured as:

switch (freehdr.magic) {
case XFS_DIR3_FREE_MAGIC:
case XFS_DIR2_FREE_MAGIC:
	/* clear stuff */
	break;
default:
	if (show_warnings)
		print_warning(...);
	break;
}

> +		print_warning("invalid magic in dir inode %llu free block",
> +				(unsigned long long)cur_ino);
> +}
> +
>  static void
>  process_dir_leaf_block(
>  	char				*block)
>  {
>  	struct xfs_dir2_leaf		*leaf;
> -	struct xfs_dir3_icleaf_hdr 	leafhdr;
> +	struct xfs_dir3_icleaf_hdr	leafhdr;
>  
>  	if (!zero_stale_data)
>  		return;
> @@ -1449,6 +1479,18 @@ process_dir_leaf_block(
>  		lbp = xfs_dir2_leaf_bests_p(ltp);
>  		memset(free, 0, (char *)lbp - free);
>  		iocur_top->need_crc = 1;
> +	} else
> +	if (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> +	    leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {


Convert this whole thing to a switch?

> +		struct xfs_dir2_leaf_entry	*ents;
> +		char				*free;
> +		int				used;
> +
> +		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
> +		free = (char *)&ents[leafhdr.count];
> +		used = free - (char*)leaf;
> +		memset(free, 0, mp->m_sb.sb_blocksize - used);
> +		iocur_top->need_crc = 1;
>  	}
>  }
>  
> @@ -1499,7 +1541,7 @@ process_dir_data_block(
>  		if (show_warnings)
>  			print_warning(
>  		"invalid magic in dir inode %llu block %ld",
> -					(long long)cur_ino, (long)offset);
> +					(unsigned long long)cur_ino, (long)offset);

Unrelated (but still good) change.

>  		return;
>  	}
>  
> @@ -1813,8 +1855,7 @@ process_single_fsb_objects(
>  		switch (btype) {
>  		case TYP_DIR2:
>  			if (o >= mp->m_dir_geo->freeblk) {
> -				/* TODO, zap any stale data */
> -				break;
> +				process_dir_free_block(dp);
>  			} else if (o >= mp->m_dir_geo->leafblk) {
>  				process_dir_leaf_block(dp);
>  			} else {
> @@ -2115,6 +2156,20 @@ process_btinode(
>  	}
>  
>  	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
> +
> +	if (zero_stale_data) {
> +		/* Space before btree pointers */
> +		char	*top;
> +		int	used;
> +		top = (char*)XFS_BMDR_PTR_ADDR(dib, 1, nrecs);

Blank line between "int used;" and "top =...", please.

> +		memset(top, 0, (char*)pp - top);
> +
> +		/* Space after btree pointers */
> +		top = (char*)&pp[nrecs];
> +		used = top - (char*)dip;
> +		memset(top, 0, mp->m_sb.sb_inodesize - used);
> +	}
> +
>  	for (i = 0; i < nrecs; i++) {
>  		xfs_agnumber_t	ag;
>  		xfs_agblock_t	bno;
> @@ -2250,7 +2305,16 @@ process_inode(
>  		case S_IFREG:
>  			success = process_inode_data(dip, TYP_DATA);
>  			break;
> -		default: ;
> +		default:
> +			if (XFS_DFORK_NEXTENTS(dip, XFS_ATTR_FORK) ||
> +					XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {

Please line up the XFS_DFORK_NEXTENTS(...) calls.

> +				if (show_warnings)
> +					print_warning("inode %llu has unexpected extents",
> +							(unsigned long long)cur_ino);
> +				success = 0;
> +			}
> +			else

} else
	memset(...)


> +				memset(XFS_DFORK_DPTR(dip), 0, mp->m_sb.sb_inodesize - (XFS_DFORK_DPTR(dip) - (char*)dip));

Please put this in a separate helper that isn't triple-indented and
overflows 80 columns.

--D

>  	}
>  	nametable_clear();
>  
> -- 
> 2.14.4
> 
