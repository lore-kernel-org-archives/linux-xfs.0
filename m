Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16923 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935605AbdADGcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 01:32:50 -0500
Date: Tue, 3 Jan 2017 22:32:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20170104063239.GF14031@birch.djwong.org>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-2-git-send-email-hch@lst.de>
 <20161215220938.GV4219@dastard>
 <20161216082044.GB32288@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216082044.GB32288@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, eguan@redhat.com

On Fri, Dec 16, 2016 at 09:20:44AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 16, 2016 at 09:09:38AM +1100, Dave Chinner wrote:
> > > @@ -3812,7 +3812,6 @@ xfs_bmap_btalloc(
> > >  		args.fsbno = 0;
> > >  		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > >  		args.total = ap->minlen;
> > > -		args.minleft = 0;
> > >  		if ((error = xfs_alloc_vextent(&args)))
> > >  			return error;
> > >  		ap->dfops->dop_low = true;
> > 
> > But this looks wrong. when combined with the next patch that sets:
> > 
> > 	args.minleft = xfs_bmap_worst_indlen(ap->ip, args.maxlen);
> > 
> > we've got a minleft value that might be for multigigabyte
> > allocation, but now we are only asking for a total allocation
> > of minlen, and that might be 1 block. IOWs, shouldn't this "last,
> > final attempt" code actually do something like this:
> > 
> > 		args.maxlen = ap->minlen;
> > 		args.total = ap->minlen;
> > 		args.minleft = xfs_bmap_worst_indlen(ap->ip, args.maxlen);
> 
> Yes.  And I actually had that in a previous iteration, and it got
> dropped at some point.

I see the diff hunk in question hasn't changed in the v2 patchset...
Did Dave's suggestion not work?

--D
