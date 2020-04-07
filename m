Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F03C2BA1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 00:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B369B20787
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 00:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDGAuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:50:00 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37693 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbgDGAt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 20:49:59 -0400
Received: from dread.disaster.area (pa49-180-164-3.pa.nsw.optusnet.com.au [49.180.164.3])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 42EF43A406B;
        Tue,  7 Apr 2020 10:49:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jLcR9-0005v9-RQ; Tue, 07 Apr 2020 10:49:55 +1000
Date:   Tue, 7 Apr 2020 10:49:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200407004955.GE21885@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404085203.1908-2-chandanrlinux@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=K0+o7W9luyMo1Ua2eXjR1w==:117 a=K0+o7W9luyMo1Ua2eXjR1w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=7-415B0cAAAA:8 a=zo71jTmGGFItFPG-EtgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[chopped bits out of the diff to get the whole reservation in one
 obvious piece of code.]

On Sat, Apr 04, 2020 at 02:22:02PM +0530, Chandan Rajendra wrote:
> @@ -698,42 +699,36 @@ xfs_calc_attrinval_reservation(
>  }
>  
>  /*
> + * Setting an attribute.
>   *	the inode getting the attribute
>   *	the superblock for allocations
> + *	the agf extents are allocated from
>   *	the attribute btree * max depth
> + *	the bmbt entries for da btree blocks
> + *	the bmbt entries for remote blocks (if any)
> + *	the allocation btrees.
>   */
>  STATIC uint
> -xfs_calc_attrsetm_reservation(
> +xfs_calc_attrset_reservation(
>  	struct xfs_mount	*mp)
>  {
> +	int			max_rmt_blks;
> +	int			da_blks;
> +	int			bmbt_blks;
> +
> +	da_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);

#define XFS_DAENTER_BLOCKS(mp,w)        \
        (XFS_DAENTER_1B(mp,w) * XFS_DAENTER_DBS(mp,w))
#define XFS_DAENTER_1B(mp,w)    \
        ((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
#define XFS_DAENTER_DBS(mp,w)   \
	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))

So, da_blks contains the full da btree split depth * 1 block. i.e.

	da_blks = XFS_DA_NODE_MAXDEPTH;

> +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);

#define XFS_DAENTER_BMAPS(mp,w)         \
        (XFS_DAENTER_DBS(mp,w) * XFS_DAENTER_BMAP1B(mp,w))

#define XFS_DAENTER_BMAP1B(mp,w)        \
        XFS_NEXTENTADD_SPACE_RES(mp, XFS_DAENTER_1B(mp, w), w)

So, bmbt_blks contains the full da btree split depth * the BMBT
overhead for a single block allocation:

#define XFS_EXTENTADD_SPACE_RES(mp,w)   (XFS_BM_MAXLEVELS(mp,w) - 1)
#define XFS_NEXTENTADD_SPACE_RES(mp,b,w)\
        (((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
	          XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
		            XFS_EXTENTADD_SPACE_RES(mp,w))

XFS_NEXTENTADD_SPACE_RES(1) = ((1 + N - 1) / N) * (XFS_BM_MAXLEVELS - 1)
		= (XFS_BM_MAXLEVELS - 1)

So, bmbt_blks = XFS_DA_NODE_MAXDEPTH * (XFS_BM_MAXLEVELS - 1)

IOWs, this bmbt reservation is assuming a full height BMBT
modification on *every* dabtree node allocation. IOWs, we're
reserving multiple times the log space for potential bmbt
modifications than we are for the entire dabtree modification.
That's why the individual dabtree reservations are so big....

> +	max_rmt_blks = xfs_attr3_rmt_blocks(mp, XATTR_SIZE_MAX);
> +	bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, max_rmt_blks, XFS_ATTR_FORK);

And this assumes we are going to log at least another full bmbt
modification.

IT seems to me that the worst case here is one full split and then
every other allocation inserts at the start of an existing block and
so updates pointers all the way up to the root. The impact is
limited, though, because XFS_DA_NODE_MAXDEPTH = 5 and so the attr
fork BMBT tree is not likely to reach anywhere near it's max depth
on large filesystems.....

>  	return XFS_DQUOT_LOGRES(mp) +
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		xfs_calc_buf_res(da_blks, XFS_FSB_TO_B(mp, 1)) +
> +		xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1)) +
> +		xfs_calc_buf_res(xfs_allocfree_log_count(mp, da_blks),
>  				 XFS_FSB_TO_B(mp, 1));

Given the above, this looks OK. Worst case BMBT usage looks
excessive, but there is a chance it could be required...

> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index 88221c7a04ccf..6a22ad11b3825 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -38,8 +38,14 @@
>  
>  #define	XFS_DAENTER_1B(mp,w)	\
>  	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
> +/*
> + * xattr set operation can cause the da btree to split twice in the
> + * worst case. The double split is actually an extra leaf node rather
> + * than a complete split of blocks in the path from root to a
> + * leaf. The '1' in the macro below accounts for the extra leaf node.

It's not a double tree split, so don't describe it that way and then
have to explain that it's not a double tree split!

/*
 * When inserting a large local record into the dabtree leaf, we may
 * need to split the leaf twice to make room to fit the new record
 * into the new leaf. This double leaf split still only requires a
 * single datree path update as the inserted leaves are at adjacent
 * indexes. Hence we only need to account for an the extra leaf
 * block in the attribute fork here.
 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
