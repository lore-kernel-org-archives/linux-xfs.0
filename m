Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A97917F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:24:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4599FAC002
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:24:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bGQcIea9g4mao0sy for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:24:41 -0800 (PST)
Date: Fri, 13 Dec 2013 09:24:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20131212222438.GJ10988@dastard>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-2-git-send-email-david@fromorbit.com>
	<20131212163629.GA2894@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212163629.GA2894@infradead.org>
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

On Thu, Dec 12, 2013 at 08:36:29AM -0800, Christoph Hellwig wrote:
> I really don't like how this makes even more of a mess out of the
> already convoluted xfs_bioerror/xfs_bioerror_else maze.  Can we
> maybe first merge them and document the difference before adding
> even more special case branches?
> 
> Also most uses of uncached buffers use xfsbdstrat, where we can do
> error handling straight in the caller instead of playing with all
> the flags manipulation mess.  In all these cases no one but the
> caller can find these buffers anyway, so doing all this on an
> I/O error is pointless.
> 
> The only buffer where any of this matters is the superblock one,
> and given that we re-read it on mount anyway I wonder if we should
> just make it a regular buffer again and let all this mess just
> disappear.

Ok, I agree it is a bit messy, but that code is already pretty ugly.
I'd like to get this fix in first, because it's causing oopses in
roughly 30% of my local xfstests runs on a couple of VMs, so I'd
prefer to get the fix out there now and do the cleanup as a separate
patch series. Would that be an acceptible approach to take here from
your perspective?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
