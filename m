Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 657A77F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 16:06:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5522230405F
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 14:06:21 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zL0wQfbw5k3ObEpe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 14:06:16 -0800 (PST)
Date: Mon, 4 Jan 2016 14:06:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/76] libxfs: refactor the btree size calculator code
Message-ID: <20160104220613.GA28330@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085642.12713.80467.stgit@birch.djwong.org>
	<20151220203928.GS26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151220203928.GS26718@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 21, 2015 at 07:39:28AM +1100, Dave Chinner wrote:
> On Sat, Dec 19, 2015 at 12:56:42AM -0800, Darrick J. Wong wrote:
> > Create a macro to generate btree height calculator functions.
> > This will be used (much) later when we get to the refcount
> > btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > +/* btree size calculator templates */
> > +#define DECLARE_BTREE_SIZE_FN(btree) \
> > +xfs_filblks_t xfs_##btree##_calc_btree_size(struct xfs_mount *mp, \
> > +		unsigned long len);
> > +
> > +#define DEFINE_BTREE_SIZE_FN(btree, limitfield, maxlevels) \
> > +xfs_filblks_t \
> > +xfs_##btree##_calc_btree_size( \
> > +	struct xfs_mount	*mp, \
> > +	unsigned long		len) \
> > +{ \
> > +	int			level; \
> > +	int			maxrecs; \
> > +	xfs_filblks_t		rval; \
> > +\
> > +	maxrecs = mp->limitfield[0]; \
> > +	for (level = 0, rval = 0; level < maxlevels; level++) { \
> > +		len += maxrecs - 1; \
> > +		do_div(len, maxrecs); \
> > +		rval += len; \
> > +		if (len == 1) \
> > +			return rval + maxlevels - \
> > +				level - 1; \
> > +		if (level == 0) \
> > +			maxrecs = mp->limitfield[1]; \
> > +	} \
> > +	return rval; \
> > +}
> 
> I really don't like using macros like this. The code becomes hard to
> debug, hard to edit, the functions don't show up in grep/cscope,
> etc.
> 
> A helper function like this:
> 
> xfs_filblks_t
> xfs_btree_calc_size(
> 	struct xfs_mount        *mp,
> 	int			*limits,
> 	int			maxlevels,
> 	unsigned long           len)
> {
> 	int			level;
> 	int			maxrecs;
> 	xfs_filblks_t		rval;
> 
> 	maxrecs = limits[0];
> 	for (level = 0, rval = 0; level < maxlevels; level++) {
> 		len += maxrecs - 1;
> 		do_div(len, maxrecs);
> 		rval += len;
> 		if (len == 1)
> 			return rval + maxlevels - level - 1;
> 		if (level == 0)
> 			maxrecs = limits[1];
> 	}
> 	return rval;
> }
> 
> will work just as well when wrapped with the btree specific calling
> function and that will have none of the problems using a macro to
> build the functions has...

Will change to use a helper function.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
