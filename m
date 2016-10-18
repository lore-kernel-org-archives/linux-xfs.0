Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49925 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbcJRGuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 02:50:15 -0400
Date: Mon, 17 Oct 2016 23:50:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: unset MS_ACTIVE if mount fails
Message-ID: <20161018065014.GA10999@infradead.org>
References: <20161018011051.GB20337@birch.djwong.org>
 <20161018052413.GA32065@infradead.org>
 <20161018053849.GG26485@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161018053849.GG26485@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 10:38:49PM -0700, Darrick J. Wong wrote:
> In a way, yes.  We don't need to keep it on the LRU necessarily, we
> just need it not to think "Oh, this inode has i_nlink == 0 so we can
> truncate all the blocks and free the inode" prior to the end of bmap
> intent processing.
> 
> > I'd really prefer if we could just do it in our own ->drop_inode call
> > then instead of messing with MS_ACTIVE.
> 
> The difficulty here is that without MS_ACTIVE, the vfs will always
> evict the inode when i_count == 0.  I suppose bmap intent processing
> could bump up i_count and stash the inode somewhere to prevent the
> i_count from hitting zero until after we're done recovering the log...
> ...but otherwise I'm sorta stumped about how to do that.

Let me try to understand the issue here.

We get a final iput for an inode that recover once i_count hits zero.
We then want to hit the "if (!drop && (sb->s_flags & MS_ACTIVE)) {"
conditional there to add it to the lru, or at least not truncate it.
I guess for now we'll need MS_ACTIVE early here, yes.

So reluctantly:

Reviewed-by: Christoph Hellwig <hch@lst.de>
