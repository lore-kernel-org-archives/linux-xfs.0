Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Apr 2007 01:04:32 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3D84RfB010574
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 01:04:29 -0700
Date: Fri, 13 Apr 2007 08:26:47 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair - move realtime extent processing to a separate function
Message-ID: <20070413072647.GC20326@infradead.org>
References: <200704130415.OAA16550@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704130415.OAA16550@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com, 'xfs-dev' <xfs-dev@sgi.com>

On Fri, Apr 13, 2007 at 02:22:10PM +1000, Barry Naujok wrote:
> While changing the process_bmbt_reclist_int() function, I observed a 
> realtime check inside the block map get/set state loop which is quite
> CPU intensive. Upon further investigation, this loop is not used at
> all for realtime extents and that the two types of extents are pretty
> much processed exclusively.
> 
> So, I simplified the functionality by moving the realtime extent
> processing into it's own function and fixing a bug at the same time
> when it comes to realtime inodes with attributes (it was comparing
> attr extents to the realtime volume bmap instead of the normal bmap).

Nice cleanup, looks good.
