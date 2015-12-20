Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 892A17F4E
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 14:39:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 69D9D8F8033
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 12:39:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qLZmvCPRwHrawyaW for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 12:39:39 -0800 (PST)
Date: Mon, 21 Dec 2015 07:39:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/76] libxfs: refactor the btree size calculator code
Message-ID: <20151220203928.GS26718@dastard>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085642.12713.80467.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219085642.12713.80467.stgit@birch.djwong.org>
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

On Sat, Dec 19, 2015 at 12:56:42AM -0800, Darrick J. Wong wrote:
> Create a macro to generate btree height calculator functions.
> This will be used (much) later when we get to the refcount
> btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> +/* btree size calculator templates */
> +#define DECLARE_BTREE_SIZE_FN(btree) \
> +xfs_filblks_t xfs_##btree##_calc_btree_size(struct xfs_mount *mp, \
> +		unsigned long len);
> +
> +#define DEFINE_BTREE_SIZE_FN(btree, limitfield, maxlevels) \
> +xfs_filblks_t \
> +xfs_##btree##_calc_btree_size( \
> +	struct xfs_mount	*mp, \
> +	unsigned long		len) \
> +{ \
> +	int			level; \
> +	int			maxrecs; \
> +	xfs_filblks_t		rval; \
> +\
> +	maxrecs = mp->limitfield[0]; \
> +	for (level = 0, rval = 0; level < maxlevels; level++) { \
> +		len += maxrecs - 1; \
> +		do_div(len, maxrecs); \
> +		rval += len; \
> +		if (len == 1) \
> +			return rval + maxlevels - \
> +				level - 1; \
> +		if (level == 0) \
> +			maxrecs = mp->limitfield[1]; \
> +	} \
> +	return rval; \
> +}

I really don't like using macros like this. The code becomes hard to
debug, hard to edit, the functions don't show up in grep/cscope,
etc.

A helper function like this:

xfs_filblks_t
xfs_btree_calc_size(
	struct xfs_mount        *mp,
	int			*limits,
	int			maxlevels,
	unsigned long           len)
{
	int			level;
	int			maxrecs;
	xfs_filblks_t		rval;

	maxrecs = limits[0];
	for (level = 0, rval = 0; level < maxlevels; level++) {
		len += maxrecs - 1;
		do_div(len, maxrecs);
		rval += len;
		if (len == 1)
			return rval + maxlevels - level - 1;
		if (level == 0)
			maxrecs = limits[1];
	}
	return rval;
}

will work just as well when wrapped with the btree specific calling
function and that will have none of the problems using a macro to
build the functions has...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
