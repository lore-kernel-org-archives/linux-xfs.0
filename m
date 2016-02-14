Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A17F7CA6
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 18:21:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47B8C304039
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 16:21:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	p61PSXmxyhP0imyU for <xfs@oss.sgi.com>;
	Sat, 13 Feb 2016 16:21:37 -0800 (PST)
Date: Sun, 14 Feb 2016 11:21:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160214002135.GG14668@dastard>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160213023310.GC14668@dastard>
	<20160213074827.GA11543@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160213074827.GA11543@infradead.org>
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
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Feb 12, 2016 at 11:48:27PM -0800, Christoph Hellwig wrote:
> On Sat, Feb 13, 2016 at 01:33:10PM +1100, Dave Chinner wrote:
> > > allocate an extent (or rather just a single block) in xfs_alloc_ag_vextent
> > > as called from xfs_refcountbt_alloc_block.  The reservation helps us to
> > > ensure this block is always available, but we still need to account for
> > > that in xfs_trans_reserve(), which we currently don't do for itruncate
> > > transactions.  
> > 
> > Ok, so we may have two different issues with a similar failure
> > symptom. As it is, I don't think this is a show stopper - we're
> > expecting to find these sorts of issues as we go along (hence the
> > experimental tag on the feature) and I think, at this point, getting
> > review and an initial merge done is more important...
> 
> This triggers 100% reproducible over NFS, and as outlined I'm
> also pretty sure about the root cause.  I don't think this is something
> to be ignored.

I didn't say we should to ignore it - I simply stated my priority
was getting the code reviewed and merged.  That doesn't stop you or
Darrick from working on a fix - if that happens after the initial
merge, we've still got the whole -rc cycle to find and fix issues
like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
