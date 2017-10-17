Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:8464 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932080AbdJQWIj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2017 18:08:39 -0400
Date: Wed, 18 Oct 2017 09:08:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 25/30] xfs: scrub directory freespace
Message-ID: <20171017220835.GU15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777260602.1724.16339769636569418352.stgit@magnolia>
 <20171017011045.GZ4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017011045.GZ4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 06:10:45PM -0700, Darrick J. Wong wrote:
> Check the free space information in a directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: make the freespace and leaf checks more complete
> ---
.....
> +	/* Make sure the bestfrees are actually the best free spaces. */
> +	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
> +	if (is_block) {
> +		struct xfs_dir2_block_tail	*btp;
> +
> +		btp = xfs_dir2_block_tail_p(mp->m_dir_geo, bp->b_addr);
> +		endptr = (char *)xfs_dir2_block_leaf_p(btp);
> +	} else
> +		endptr = (char *)bp->b_addr + BBTOB(bp->b_length);
> +	while (ptr < endptr) {
> +		dup = (struct xfs_dir2_data_unused *)ptr;
> +		/* Skip real entries */
> +		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
> +			struct xfs_dir2_data_entry	*dep;
> +
> +			dep = (struct xfs_dir2_data_entry *)ptr;
> +			newlen = d_ops->data_entsize(dep->namelen);
> +			if (newlen <= 0) {
> +				xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
> +						lblk);
> +				goto out_buf;
> +			}
> +			ptr += newlen;
> +			continue;
> +		}
> +
> +		/* Spot check this free entry */
> +		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> +		if (tag != ((char *)dup - (char *)bp->b_addr))
> +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> +
> +		/*
> +		 * Either this entry is a bestfree or it's smaller than
> +		 * any of the bestfrees.
> +		 */
> +		xfs_scrub_directory_check_free_entry(sc, lblk, bf, dup);
> +
> +		/* Move on. */
> +		newlen = be16_to_cpu(dup->length);
> +		if (newlen <= 0) {
> +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> +			goto out_buf;
> +		}
> +		ptr += newlen;
> +		if (ptr <= endptr)
> +			nr_frees++;
> +	}
> +
> +	/* Did we go off the end? */
> +	if (ptr > endptr)
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);

ptr >= endptr?

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
