Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DASVlM079250 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 05:28:31 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B38B17BD76D
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 03:28:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OAcWmPzUeyASdmtW for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 03:28:28 -0700 (PDT)
Date: Wed, 13 Jul 2011 20:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: factor out xfs_dir2_leaf_find_stale
Message-ID: <20110713102825.GR23038@dastard>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.293539533@bombadil.infradead.org>
	<1310423573.7019.55.camel@doink> <20110713064936.GP23038@dastard>
	<20110713071654.GA21252@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110713071654.GA21252@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 13, 2011 at 03:16:54AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 13, 2011 at 04:49:36PM +1000, Dave Chinner wrote:
> > > > +	     --*lowstale)
> > > > +		continue;
> > 
> > Only thing I was conerned about was the indenting on these loops.
> > Something like this:
> > 
> > 	for (*lowstale = index - 1;
> > 	     *lowstale >= 0 &&
> > 			leaf->ents[*lowstale].address !=
> > 			cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> > 	     --*lowstale)
> > 		continue;
> > 
> > means that at a glance it is easy to separate the loop control
> > statements from the body of the loop just by indentation.
> 
> I tried to avoid changing anything here, but now that other people
> like me hate these uglies I think I have to ite the bullet and
> actually untangle those loops.  The version below is what I'm submitting
> to testing now:

The new logic looks OK to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
