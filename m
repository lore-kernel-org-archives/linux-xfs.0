Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90EAD7CA1
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 17:54:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02B0AAC001
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 15:54:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WBUwrFxUbtRs7Els for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2016 15:53:59 -0700 (PDT)
Date: Tue, 12 Jul 2016 08:53:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
Message-ID: <20160711225357.GG1922@dastard>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
	<20160707222829.GG12670@dastard>
	<CAGeO4WN6iYLk7PjjrfU679wgF5NwFgE=1vkowEc_M8nF5W29HQ@mail.gmail.com>
	<20160710232217.GB1922@dastard>
	<CAGeO4WOuQwA7wm_S6352ovDdgiJixn_ztP5=HUVO1d=VmRxfbA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGeO4WOuQwA7wm_S6352ovDdgiJixn_ztP5=HUVO1d=VmRxfbA@mail.gmail.com>
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
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 11, 2016 at 03:06:03PM +0800, Kaho Ng wrote:
> Just wonders why we prefer failing the request of refilling freelist
> with XFS_WANT_CORRUPTED_RETURN(mp, i == 1) in some rare case, rather
> than returning NULLAGBLOCK and allowing the loop in
> xfs_alloc_ag_vextent_size() to try xfs_alloc_ag_vextent_small()...

Have a look at where xfs_alloc_ag_vextent_small() gets the blocks it
returns to the caller if the btree cursor doesn't point to a btree
record we can use. i.e. you can't refill the free list from
xfs_alloc_ag_vextent_small() because it allocates blocks from ...

> In
> such corner case there will always be a lot of small extents at the
> front of the by-count tree, and any truncation changes to the first
> entry in the tree will not result in tree splits and triggering
> assertion failure.

If there are records we can use, then we'll allocate them from the
btree. Failure to allocate from the btree indicates something is
inconsistent, there's a bug in the code or we've got corruption
occuring. A corruption shutdown is the only safe course of action
when we find something confusing like this - if we guess wrong them
we'll only make the bad state/corruption worse.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
