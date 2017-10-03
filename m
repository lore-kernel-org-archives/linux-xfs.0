Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6219 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750865AbdJCXtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 19:49:31 -0400
Date: Wed, 4 Oct 2017 10:49:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/25] xfs: create helpers to scrub a metadata btree
Message-ID: <20171003234913.GS3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706328091.19351.8950704471769189971.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706328091.19351.8950704471769189971.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:41:20PM -0700, Darrick J. Wong wrote:
> +/* btree scrubbing */
> +
> +/*
> + * Check for btree operation errors.  See the section about handling
> + * operational errors in common.c.
> + */
> +bool
> +xfs_scrub_btree_op_ok(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	int				*error)
> +{
......
> +
> +/*
> + * Visit all nodes and leaves of a btree.  Check that all pointers and
> + * records are in order, that the keys reflect the records, and use a callback
> + * so that the caller can verify individual records.  The callback is the same
> + * as the one for xfs_btree_query_range, so therefore this function also
> + * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
> + */
> +int
> +xfs_scrub_btree(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	xfs_scrub_btree_rec_fn		scrub_fn,
> +	struct xfs_owner_info		*oinfo,
> +	void				*private)
> +{
> +	xfs_scrub_btree_op_ok(sc, cur, 0, false);

Looks like this patch won't compile - it's passing a bool to an int
*. I know it's just a stub and probably gets fixed later, but
better not to leave a bisect landmine...

-Dave
-- 
Dave Chinner
david@fromorbit.com
