Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 02:53:02 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08Aquqw008011
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 02:52:57 -0800
Date: Mon, 8 Jan 2007 10:52:03 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: fix block reservation to work with per-cpu counters
Message-ID: <20070108105203.GA31252@infradead.org>
References: <20070108061040.GD44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108061040.GD44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 05:10:40PM +1100, David Chinner wrote:
> Currently, XFS_IOC_SET_RESBLKS will not work properly when
> per-cpu superblock counters are enabled. Reservations can be lost
> silently as they are applied to the incore superblock instead of
> the currently active counters.
> 
> Rather than try to shoe-horn the current reservation code into
> the per-cpu counters or vice-versa, we lock the superblock
> and snap the current counter state and work on that number.
> Once we work out exactly how much we need to "allocate" to
> the reserved area, we drop the lock and call xfs_mod_incore_sb()
> which will do all the right things w.r.t to the counter state.
> 
> If we fail to get as much as we want (i.e. ENOSPC is returned)
> we go back to the start and try to allocate as much of what is
> left.
> 
> Comments?

Sounds okay.  Reservations shouldn't be frequent enough for this
to have a performance impact.
