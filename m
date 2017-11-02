Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934065AbdKBTgZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 15:36:25 -0400
Date: Thu, 2 Nov 2017 15:36:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171102193623.GJ16645@bfoster.bfoster>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-13-hch@lst.de>
 <20171102171437.GH16645@bfoster.bfoster>
 <20171102185138.GC4244@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102185138.GC4244@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 07:51:38PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 02, 2017 at 01:14:37PM -0400, Brian Foster wrote:
> > Can we just open code ext->idx here rather than maintain two counters,
> > or will that go away later?
> 
> This area will change quite a bit.  Please take a look at the end result.
> 

Ok.. after a quick look at the final xfs_iread_extents(), it appears
that concern is no longer relevant.

> > > -	ASSERT(bma->idx >= 0);
> > > -	ASSERT(bma->idx <= xfs_iext_count(ifp));
> > 
> > I think it might be useful to encapsulate this check (which is also part
> > of xfs_iext_get_extent()) into a cursor validation helper so we can
> > preserve these asserts (here and in the other bmap functions). E.g.,
> > something like:
> > 
> > 	ASSERT(xfs_iext_valid(&bma->ext));
> 
> I'll take a look at that.
> 
> > 1.) Why do we place these new cursors directly on the stack as opposed
> > to dynamic allocation?
> 
> Why would be do a dynamic allocation?
> 

I just noticed it as a divergence from our other cursor implementations.
This is of course a different implementation, however. I guess it more
depends on what ends up in the cursor. It looks like the cursor ends up
with an integer index and leaf pointer, the latter of which appears to
be memory owned by the inode..? If that's the case, then perhaps there
is really no point to dynamic allocation of the cursor itself.

> > 2.) Why not encode the fork/inode in the cursor rather than passing them
> > around throughout the helper functions?
> 
> We could do that, but I'm not sure it's really worth the effort.

I'm not against cleaning it up after the fact. The broader question was
whether there was any reason we'd need to pass the fork to every call.
If not, I think combining it with the cursor may provide a cleaner
interface.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
