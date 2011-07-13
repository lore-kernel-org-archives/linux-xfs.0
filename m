Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6D6nf6B070880 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 01:49:42 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D659CEB1B23
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 23:49:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FPiQDmHQUBJGSxRy for <xfs@oss.sgi.com>;
	Tue, 12 Jul 2011 23:49:39 -0700 (PDT)
Date: Wed, 13 Jul 2011 16:49:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: factor out xfs_dir2_leaf_find_stale
Message-ID: <20110713064936.GP23038@dastard>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.293539533@bombadil.infradead.org>
	<1310423573.7019.55.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310423573.7019.55.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 05:32:53PM -0500, Alex Elder wrote:
> On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> OK, I guess this is fine.  I have a suggestion below
> but I see nothing truly wrong with what you have.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> > Index: xfs/fs/xfs/xfs_dir2_leaf.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-09 12:07:49.518499801 +0200
> > +++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-09 12:19:48.171796748 +0200
> > @@ -148,6 +148,36 @@ xfs_dir2_block_to_leaf(
> >  	return 0;
> >  }
> >  
> > +STATIC void
> > +xfs_dir2_leaf_find_stale(
> > +	struct xfs_dir2_leaf	*leaf,
> > +	int			index,
> > +	int			*lowstale,
> > +	int			*highstale)
> > +{
> > +	/*
> > +	 * Find the first stale entry before our index, if any.
> > +	 */
> > +	for (*lowstale = index - 1;
> > +	     *lowstale >= 0 &&
> > +		leaf->ents[*lowstale].address !=
> > +		cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> > +	     --*lowstale)
> > +		continue;

Only thing I was conerned about was the indenting on these loops.
Something like this:

	for (*lowstale = index - 1;
	     *lowstale >= 0 &&
			leaf->ents[*lowstale].address !=
			cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
	     --*lowstale)
		continue;

means that at a glance it is easy to separate the loop control
statements from the body of the loop just by indentation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
