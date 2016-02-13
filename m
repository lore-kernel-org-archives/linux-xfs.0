Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C0E6A7CA2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 22:44:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8AAAA8F8035
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 20:44:37 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KSNmA4zHqWBMYtyc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 20:44:35 -0800 (PST)
Date: Fri, 12 Feb 2016 20:44:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160213044400.GJ6350@birch.djwong.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160213023310.GC14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160213023310.GC14668@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Feb 13, 2016 at 01:33:10PM +1100, Dave Chinner wrote:
> On Fri, Feb 12, 2016 at 11:10:46AM -0800, Christoph Hellwig wrote:
> > On Thu, Feb 11, 2016 at 08:40:58AM +1100, Dave Chinner wrote:
> > > I run into that from time to time (maybe once a month) on a vanilla
> > > kernel.
> > > 
> > > IIRC, the problem is the delayed allocation extent split runs out of
> > > it's reserved block count if you split it enough times. The case
> > > I've seen is that  the indlen calculated in xfs_bmap_worst_indlen()
> > > ends up too small for a subsequent allocation after we've called
> > > xfs_bmap_del_extent() to delete the middle of a delalloc extent too
> > > many times.
> > > 
> > > Brian had some patches that attempted to solve it - we may have
> > > simply dropped the ball on this (again).
> > > 
> > > http://oss.sgi.com/archives/xfs/2014-09/msg00337.html
> > 
> > I'm pretty sure that is a separate issue.  With the refcount btree we may
> > allocate an extent (or rather just a single block) in xfs_alloc_ag_vextent
> > as called from xfs_refcountbt_alloc_block.  The reservation helps us to
> > ensure this block is always available, but we still need to account for
> > that in xfs_trans_reserve(), which we currently don't do for itruncate
> > transactions.  

Hmm.  The per-AG reservation clients also had some problems counting the number
of tree blocks in use as part of setting up the reservation; that might have
had something to do with it.  Dunno, I'll go look at that part of the code
again when I finish interval query support for rmap.

> Ok, so we may have two different issues with a similar failure
> symptom. As it is, I don't think this is a show stopper - we're
> expecting to find these sorts of issues as we go along (hence the
> experimental tag on the feature) and I think, at this point, getting
> review and an initial merge done is more important...

I've noticed that I can trigger that assert (the log reservation one) fairly
regularly when running xfs/140 on a 800MB disk.

Brain dead, going to bed.  Next on my list is to rebase the more stable
parts of the patchset against Dave's for-4.6 branch and do another mass
mailing.

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
