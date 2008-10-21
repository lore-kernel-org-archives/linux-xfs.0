Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 14:04:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LL4rmR014141
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 14:04:53 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDE5214554AA
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 14:06:37 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id aLQ5KGhv0HxRyavw for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 14:06:37 -0700 (PDT)
Date: Wed, 22 Oct 2008 08:06:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] free inodes using destroy_inode
Message-ID: <20081021210633.GM25906@disturbed>
References: <20081020222044.GC23662@lst.de> <20081021030726.GD18495@disturbed> <20081021090708.GA30463@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021090708.GA30463@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 05:07:08AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 21, 2008 at 02:07:26PM +1100, Dave Chinner wrote:
> >    ^
> > Extra whitespace.
> > 
> >    ^
> > Ditto.
> 
> Fixed.
> 
> > Yes, makes sense to mark it bad first to avoid most of the
> > reclaim code.
> 
> > Can that happen? I thought xfs_iput_new() took care of clearing the
> > I_NEW flag via unlock_new_inode() and so there is no way that flag
> > can leak through to here. perhaps a comment explaining what the
> > error path is that leads to needing this check is in order....
> 
> The make_inode_bad isn't actually nessecary anymore - this was my first
> attempt at skipping the flushing in xfs_reclaim, but it was still too
> much as the radix tree removal for and inode that's not in the tree
> tripped up quite badly.  So I use I_NEW here to detect these half setup
> inodes.  Real I_NEW indoes still go through xfs_iput_new.

Hmmmm - I still don't see that as possible. We don't set I_NEW until
we are inside xfs_setup_inode(), which occurs after we insert
the inode into the radix tree. xfs_setup_inode() also calls
unlock_new_inode(), so the I_NEW flag is cleared before it returns,
too. So I can't really see how this check in reclaim does anything....

AFAICT, once we've inserted the new inode into the radix tree,
we can't get an error before xfs_setup_inode() is called - even
in the allocation case. Hence once we're in the radix tree,
xfs_iput_new() should be called to cleanup.

All the cases that xfs_destroy_inode() handles are before the inode
is inserted into the radix tree, so marking the XFS inode XFS_IBAD
in xfs_destroy_inode() is probably a much more reliable way to
detect immediate destroy cases in the reclaim code than relying
on I_NEW......

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
