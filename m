Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7T6Xk3n053436 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 01:33:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 432535434AB
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 23:33:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Pe3n3Vh2g1OrEZvL for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2011 23:33:44 -0700 (PDT)
Date: Mon, 29 Aug 2011 02:33:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS metadata flushing design - current and future
Message-ID: <20110829063342.GA26346@infradead.org>
References: <20110827080321.GA16661@infradead.org>
	<20110829010149.GE3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110829010149.GE3162@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 29, 2011 at 11:01:49AM +1000, Dave Chinner wrote:
> Right, that's how buffers are flushed, but for some metadata there
> is a layer above this - the in-memory object that needs to be
> flushed to the buffer before the buffer can be written. Inodes and
> dquots fall into this category, so describing how they are flushed
> would also be a good idea. something like:

Sounds fine.

> Delwri means the object is locked and written to the backing buffer,
> and the buffer is then written via it's delwri mechanism. The object
> remains locked (and so cannot be written to the buffer again) until
> the backing buffer is written to disk and marked clean. This allows
> multiple objects in the one buffer to be written at different times
> but be cleaned in a single buffer IO.

Locked is a bit to simple here - we keep the flush lock, but not the
main object lock.

> > inodes marked dirty directly using xfs_iflush.
> > 
> > The quotacheck code marks dquots dirty, just to flush them at the end of
> > the quotacheck operation.
> 
> This is safe because the filesystem isn't "open for business" until
> the quotacheck completes. The quotacheck needed flags aren't cleared
> until all the updates are on disk, so this doesn't need tobe done
> transactionally.

Yes, it's safe - but another different layer of dirty metadata to track.

> > 
> > We should get rid of both the reliance of the VFS writeback tracking, and
> > XFS-internal non-AIL metadata flushing.
> 
> I'm assuming you mean VFS level dirty inode writeback tracking, not
> dirty page cache tracking?

Yes, I'll clarify it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
