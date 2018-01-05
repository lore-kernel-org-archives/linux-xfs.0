Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42147 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751155AbeAEBlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:41:09 -0500
Date: Fri, 5 Jan 2018 12:40:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/21] xfs: add scrub cross-referencing helpers for the
 rmap btrees
Message-ID: <20180105014053.GV30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398982164.18741.14153975836991113575.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398982164.18741.14153975836991113575.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the rmap btrees that will be used
> to cross-reference metadata against the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_rmap.h |    5 ++++
>  2 files changed, 63 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 50db920..ea78ec3 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2387,3 +2387,61 @@ xfs_rmap_compare(
>  	else
>  		return 0;
>  }
> +
> +/* Is there a record covering a given extent? */
> +int
> +xfs_rmap_has_record(
> +	struct xfs_btree_cur	*cur,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	bool			*exists)
> +{
> +	union xfs_btree_irec	low;
> +	union xfs_btree_irec	high;
> +
> +	memset(&low, 0, sizeof(low));
> +	low.r.rm_startblock = bno;
> +	memset(&high, 0xFF, sizeof(high));
> +	high.r.rm_startblock = bno + len - 1;
> +
> +	return xfs_btree_has_record(cur, &low, &high, exists);
> +}
> +
> +/* Is there a record covering a given extent? */
> +int
> +xfs_rmap_record_exists(
> +	struct xfs_btree_cur	*cur,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	struct xfs_owner_info	*oinfo,
> +	bool			*has_rmap)
> +{
> +	uint64_t		owner;
> +	uint64_t		offset;
> +	unsigned int		flags;
> +	int			stat;

has_record to match the other code?

> +	struct xfs_rmap_irec	irec;
> +	int			error;
> +
> +	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
> +
> +	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &stat);
> +	if (error)
> +		return error;
> +	if (!stat) {
> +		*has_rmap = false;
> +		return 0;
> +	}
> +
> +	error = xfs_rmap_get_rec(cur, &irec, &stat);
> +	if (error)
> +		return error;
> +	if (!stat) {
> +		*has_rmap = false;
> +		return 0;
> +	}
> +
> +	*has_rmap = (irec.rm_owner == owner && irec.rm_startblock <= bno &&
> +		     irec.rm_startblock + irec.rm_blockcount >= bno + len);

Ok, so this returns true only if the rmap record spans the entire
range we pass in. What does it mean if the rmap record only
partially spans the range passed in?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
