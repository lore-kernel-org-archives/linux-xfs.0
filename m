Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:4526 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbeAEB3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:29:47 -0500
Date: Fri, 5 Jan 2018 12:29:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/21] xfs: add scrub cross-referencing helpers for the
 free space btrees
Message-ID: <20180105012943.GT30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398980952.18741.2406350344342839518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398980952.18741.2406350344342839518.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the free space btrees that will be used
> to cross-reference metadata against the bnobt/cntbt, and a generic
> btree function that provides the real implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

minor nit:
> +/* Is there a record covering a given range of keys? */
> +int
> +xfs_btree_has_record(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_irec	*low,
> +	union xfs_btree_irec	*high,
> +	bool			*exists)
> +{
> +	int			error;
> +
> +	error = xfs_btree_query_range(cur, low, high,
> +			&xfs_btree_has_record_helper, NULL);
> +	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
> +		return error;
> +	*exists = error == XFS_BTREE_QUERY_RANGE_ABORT;
> +
> +	return 0;

Error handling logic is a bit tortured. This seems a bit clearer
to me:

	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
		*exists = true;
		return 0;
	}
	*exists = false;
	return error;

Otherwise it looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
