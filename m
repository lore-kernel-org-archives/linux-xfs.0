Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 18:32:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m721WQEG024896
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 18:32:26 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B481EF0CAF
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 18:33:39 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id L2kMhz3OCbU2m57g for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 18:33:39 -0700 (PDT)
Date: Sat, 2 Aug 2008 11:33:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/21] implement generic xfs_btree_split
Message-ID: <20080802013301.GP6201@disturbed>
References: <20080729192113.493074843@verein.lst.de> <20080729193137.GR19104@lst.de> <20080730065349.GR13395@disturbed> <20080801195507.GK1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801195507.GK1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:55:07PM +0200, Christoph Hellwig wrote:
> > This is where I begin to question this approach (i.e. using
> > helpers like this rather than specific ops like I did). It's
> > taken me 4 ??r 5 patches to put my finger on it.
> > 
> > The intent of this factorisation is to make implementing new btree
> > structures easy, not making the current code better or more
> > managable. The first thing we need is is btrees with different
> > header blocks (self describing information, CRCs, etc). This above
> > function will suddenly have four combinations to deal with - long and
> > short, version 1 and version 2 header formats. The more we change,
> > the more this complicates these helpers. That is why I pushed
> > seemingly trivial stuff out to operations vectors - because of the
> > future flexibility it allowed in implementation of new btrees.....
> > 
> > I don't see this a problem for this patch series, but I can see that
> > some of this work will end up being converted back to ops vectors
> > as soon as we start modifying between structures....
> 
> Maybe.  But even when we convert it to ops vectors it should not
> be the btree implementation vector, but a btree_block_ops that's
> implemented once instead of duplicated for the alloc vs ialloc
> btree.

Yes, that makes sense - I had sort of headed that way, but it
was not fully though out...

> And for now having all this in xfs_btree.c makes reading
> and working on the patch series easier, so..

Fair enough - do the work when we implement a new btree ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
