Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50112 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729934AbfHGXR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 19:17:56 -0400
Date: Thu, 8 Aug 2019 09:16:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/24] xfs: reduce kswapd blocking on inode locking.
Message-ID: <20190807231647.GS7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-19-david@fromorbit.com>
 <20190806182213.GF2979@bfoster>
 <20190806213353.GJ7777@dread.disaster.area>
 <20190807113009.GC19707@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807113009.GC19707@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Wed, Aug 07, 2019 at 07:30:09AM -0400, Brian Foster wrote:
> Second (and not necessarily caused by this patch), the ireclaim flag
> semantics are kind of a mess. As you've already noted, we currently
> block on some locks even with SYNC_TRYLOCK, yet the cluster flushing
> code has no concept of these flags (so we always trylock, never wait on
> unpin, for some reason use the shared ilock vs. the exclusive ilock,
> etc.). Further, with this patch TRYLOCK|WAIT basically means that if we
> happen to get the lock, we flush and wait on I/O so we can free the
> inode(s), but if somebody else has flushed the inode (we don't get the
> flush lock) we decide not to wait on the I/O that might (or might not)
> already be in progress. I find that a bit inconsistent. It also makes me
> slightly concerned that we're (ab)using flag semantics for a bug fix
> (waiting on inodes we've just flushed from the same task), but it looks
> like this is all going to change quite a bit still so I'm not going to
> worry too much about this mostly existing mess until I grok the bigger
> picture changes... :P

Yes, SYNC_TRYLOCK/SYNC_WAIT semantics are a mess, but they all go
away later in the patchset.  Non-blocking reclaim makes SYNC_TRYLOCK
go away because everything becomes try-lock based, and SYNC_WAIT goes
away because only the xfs_reclaim_inodes() function needs to wait
for reclaim completion and so that gets it's own LRU walker
implementation and the mode parameter is removed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
