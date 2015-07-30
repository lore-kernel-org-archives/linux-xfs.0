Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 099E67F8C
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 19:52:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A2901AC005
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:51:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Jf1bRfW5vynYPFnN for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 17:51:55 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:51:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/24] xfs: add refcount btree operations
Message-ID: <20150730005154.GJ16638@dastard>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223343.17414.27263.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729223343.17414.27263.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 29, 2015 at 03:33:43PM -0700, Darrick J. Wong wrote:
> Implement the generic btree operations required to manipulate refcount
> btree blocks.  The implementation is similar to the bmapbt, though it
> will only allocate and free blocks from the AG.
....
> +
> +/*
> + * Remove the record referred to by cur, then set the pointer to the spot
> + * where the record could be re-inserted, in case we want to increment or
> + * decrement the cursor.
> + * This either works (return 0) or gets an EFSCORRUPTED error.
> + */
> +STATIC int
> +xfs_refcountbt_delete(
> +	struct xfs_btree_cur	*cur,
> +	int			*i)
> +{
> +	struct xfs_refcount_irec	irec;
> +	int			found_rec;
> +	int			error;
> +
> +	error = xfs_refcountbt_get_rec(cur, &irec, &found_rec);
> +	if (error)
> +		return error;
> +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
> +	trace_xfs_refcountbt_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
> +	error = xfs_btree_delete(cur, i);
> +	if (error)
> +		return error;

Need another XFS_WANT_CORRUPTED_GOTO() here, too.

> + */
> +#ifndef __XFS_REFCOUNT_H__
> +#define	__XFS_REFCOUNT_H__

whitespace.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
