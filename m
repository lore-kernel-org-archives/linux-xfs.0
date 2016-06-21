Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC7CD7CA4
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 19:48:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48697AC001
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 17:48:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QXwm5r1n2cuEgvuD for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 17:48:32 -0700 (PDT)
Date: Tue, 21 Jun 2016 10:48:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 008/119] xfs: separate freelist fixing into a separate
	helper
Message-ID: <20160621004830.GM26977@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632363.12839.15504324533944246285.stgit@birch.djwong.org>
	<20160617115204.GG19042@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617115204.GG19042@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jun 17, 2016 at 04:52:04AM -0700, Christoph Hellwig wrote:
> > +/* Ensure that the freelist is at full capacity. */
> > +int
> > +xfs_free_extent_fix_freelist(
> > +	struct xfs_trans	*tp,
> > +	xfs_agnumber_t		agno,
> > +	struct xfs_buf		**agbp)
> >  {
> > -	xfs_alloc_arg_t	args;
> > -	int		error;
> > +	xfs_alloc_arg_t		args;
> 
> Use struct xfs_alloc_arg if you change this anyway.
> 
> > +	int			error;
> >  
> > -	ASSERT(len != 0);
> >  	memset(&args, 0, sizeof(xfs_alloc_arg_t));
> 
> Same here.
> 
> > -	if (args.agbno + len >
> > -			be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length)) {
> > -		error = -EFSCORRUPTED;
> > -		goto error0;
> > -	}
> > +	XFS_WANT_CORRUPTED_GOTO(mp,
> > +			agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
> > +			err);
> 
> This introduces an overly long line.
> 
> But except for these nitpicks this looks fine:

I'll clean them up on commit.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
