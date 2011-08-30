Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U7KHVx120173 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 02:20:18 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B87A3100A6F
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 00:20:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3C2zEAmaZ4T3rQvA for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 00:20:15 -0700 (PDT)
Date: Tue, 30 Aug 2011 17:20:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: fix xfs_mark_inode_dirty during umount
Message-ID: <20110830072013.GS3162@dastard>
References: <20110827055731.GA24159@infradead.org>
	<20110827055744.GA28351@infradead.org>
	<20110830062416.GN3162@dastard>
	<20110830063949.GA19262@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830063949.GA19262@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Aug 30, 2011 at 02:39:49AM -0400, Christoph Hellwig wrote:
> On Tue, Aug 30, 2011 at 04:24:16PM +1000, Dave Chinner wrote:
> > >  xfs_mark_inode_dirty_sync(
> > > @@ -82,6 +81,10 @@ xfs_mark_inode_dirty_sync(
> > >  
> > >  	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
> > >  		mark_inode_dirty_sync(inode);
> > > +	else {
> > > +		barrier();
> > > +		ip->i_update_core = 1;
> > > +	}
> > >  }
> > 
> > Why the barrier()? Isn't that just a compiler barrier? If you are
> > worried about catching the update vs clearing it in transaction
> > commit, shouldn't that use smp_mb() instead (in both places)?
> 
> It's a blind copy & past from xfs_fs_dirty_inode.  The comments
> there suggests it is for update ordering.

Right, I've always wondered about that, because the corresponding
code talks about requiring strongly ordered memory semantics and
that the compiler does this via SYNCHRONIZE() (barrier).

>From xfs_inode_item_format:

         * We clear i_update_core before copying out the data.
         * This is for coordination with our timestamp updates
         * that don't hold the inode lock. They will always
         * update the timestamps BEFORE setting i_update_core,
         * so if we clear i_update_core after they set it we
         * are guaranteed to see their updates to the timestamps
         * either here.  Likewise, if they set it after we clear it
         * here, we'll see it either on the next commit of this
         * inode or the next time the inode gets flushed via
         * xfs_iflush().  This depends on strongly ordered memory
         * semantics, but we have that.  We use the SYNCHRONIZE
         * macro to make sure that the compiler does not reorder
         * the i_update_core access below the data copy below.
         */
        if (ip->i_update_core)  {
                ip->i_update_core = 0;
                SYNCHRONIZE();
        }

Now that may have been true on Irix/MIPS which had strong memory
ordering so only compiler barriers were necessary.

However, normally when we talk about ordered memory semantics in
Linux, we cannot assume strong ordering - if we have ordering
requirements, we have to guarantee ordering by explicit use of
memory barriers, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
