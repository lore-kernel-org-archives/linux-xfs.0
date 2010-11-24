Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO2P5tj046075 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:25:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81FBE1A05B2
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 18:26:42 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	attfqAFif2aEMR0Y for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 18:26:42 -0800 (PST)
Date: Wed, 24 Nov 2010 13:26:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS reclaim lock order bug
Message-ID: <20101124022639.GB22876@dastard>
References: <20101123121802.GA4785@amd> <20101123211258.GY22876@dastard>
	<20101124005811.GC3168@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101124005811.GC3168@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 11:58:11AM +1100, Nick Piggin wrote:
> On Wed, Nov 24, 2010 at 08:12:58AM +1100, Dave Chinner wrote:
> > On Tue, Nov 23, 2010 at 11:18:02PM +1100, Nick Piggin wrote:
> > > Hi,
> > > 
> > > IIRC I've reported this before. Perhaps it is a false positive, but even
> > > so it is still annoying that it triggers and turns off lockdep for
> > > subsequent debugging.
> > > 
> > > Any chance it can get fixed or properly annotated?
> > 
> > It is supposed to be handled by the re-initialisation of the
> > ip->i_iolock in ->evict_inode (xfs_fs_evict_inode). An inode found
> > in the reclaim state must have passed through this reinitialisation,
> > so from a lockdep perspective the iolock in the vfs path is a
> > different context to the iolock in the reclaim path. That fixed all
> > the non-reclaim state related lockdep false positives, so Perhaps
> > there is an issue with the lockdep reclaim state checking that does
> > not interact well with re-initialised lock contexts?
> 
> Hmm. I suppose that should work.
> 
> So xfs_reclaim_inode can only call xfs_ilock _after_ the Linux inode
> has gone through ->evict_inode call?

I think so - it's only found by xfs_reclaim_inode() if the radix
tree reclaim tag is set for the inode, which is only set in two
places: ->destroy_inode(), and in a failed lookup (which doesn't
touch the iolock). I can't see any other way we can get to an inode
in reclaim...

> If so, then let's ask the lockdep people.

Sure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
