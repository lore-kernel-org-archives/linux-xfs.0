Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O0KUiA034601 for <xfs@oss.sgi.com>; Mon, 23 May 2011 19:20:31 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2934616566A7
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 17:20:28 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gvCDL8va5SloV0BD for <xfs@oss.sgi.com>;
	Mon, 23 May 2011 17:20:28 -0700 (PDT)
Date: Tue, 24 May 2011 10:20:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110524002026.GC32466@dastard>
References: <20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
	<20110522020024.GZ32466@dastard> <20110522075955.GA2341@citd.de>
	<20110523012034.GA32466@dastard>
	<20110523090144.GB15985@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110523090144.GB15985@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Marc Lehmann <schmorp@schmorp.de>, xfs@oss.sgi.com

On Mon, May 23, 2011 at 05:01:44AM -0400, Christoph Hellwig wrote:
> On Mon, May 23, 2011 at 11:20:34AM +1000, Dave Chinner wrote:
> > 
> > The state used to track dirty inode release calls is not reset when
> > an inode is reallocated and reused from the reclaimable state. This
> > leads to specualtive preallocation not being truncated away in the
> > expected manner for local files until the inode is subsequently
> > truncated, freed or cycles out of the cache.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_iget.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> > index cb9b6d1..e75e757 100644
> > --- a/fs/xfs/xfs_iget.c
> > +++ b/fs/xfs/xfs_iget.c
> > @@ -241,6 +241,13 @@ xfs_iget_cache_hit(
> >  		 */
> >  		ip->i_flags |= XFS_IRECLAIM;
> >  
> > +		/*
> > +		 * clear the dirty release state as we are now effectively a
> > +		 * new inode and so we need to treat speculative preallocation
> > +		 * accordingly.
> > +		 */
> > +		ip->i_flags &= ~XFS_IDIRTY_RELEASE;
> 
> Btw, don't we need to clear even more flags here?  To me it seems we
> need to clear XFS_ISTALE, XFS_IFILESTREAM and XFS_ITRUNCATED as well.

XFS_ISTALE is cleared unconditionally at the end of the function,
which means that any lookup on a stale inode will clear it. I'm not
absolutely sure this is right now that I think about it but that's a
different issue.

XFS_ITRUNCATED is mostly harmless, so it isn't a but issue, but we
probably should clear it. I'm not sure what the end result of not
clearing XFS_IFILESTREAM is, but you are right in that it should not
pass through here, either. I'll respin the patch to clear all the
state flags that hold sub-lifecycle state.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
