Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5A2C7F69
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 17:38:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82827AC00A
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 15:38:13 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kS29KowdRRirGWv2 for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 15:38:11 -0800 (PST)
Date: Wed, 13 Nov 2013 10:38:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 36/37] repair: Increase default repair parallelism on
	large filesystems
Message-ID: <20131112233807.GD6188@dastard>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-37-git-send-email-david@fromorbit.com>
	<20131106104111.GB21067@infradead.org>
	<20131106191345.GD6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106191345.GD6188@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 06:13:45AM +1100, Dave Chinner wrote:
> On Wed, Nov 06, 2013 at 02:41:11AM -0800, Christoph Hellwig wrote:
> > On Wed, Nov 06, 2013 at 12:07:22PM +1100, Dave Chinner wrote:
> > > +	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
> > > +		ag_stride = 15;
> > 
> > Shouldn't we have a define for the agcount shared by mkfs and repair, and
> > derive the stride from it?
> > 
> > Otherwise looks fine.
> 
> Yes, we could.

More complex than it looks - the mkfs calculation in
calc_default_ag_geometry() is based on byte counts and a sliding
scale of shifts and hence the resultant multidisk AG counts are
implicit side effects of the those AG size calculations. Hence to
make use of a common #define for this sort of striding, we'd need to
rewrite calc_default_ag_geometry().

I'll do that in a separate patch series, as it's not directly
related to this initial introduction of the feature to repair.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
