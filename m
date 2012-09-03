Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8368ett154254 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 01:08:40 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eBE96ieFCEain5Si for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 23:09:36 -0700 (PDT)
Date: Mon, 3 Sep 2012 16:08:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/13] xfs: xfs_sync_data is redundant.
Message-ID: <20120903060857.GB15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-8-git-send-email-david@fromorbit.com>
	<20120901232456.GB31634@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901232456.GB31634@infradead.org>
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

On Sat, Sep 01, 2012 at 07:24:56PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 30, 2012 at 10:00:11PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We don't do any data writeback from XFS any more - the VFS is
> > completely responsible for that, including for freeze. We can
> > replace the remaining caller with the VFS level function that
> > achieves the same thing, but without conflicting with current
> > writeback work - writeback_inodes_sb_if_idle().
> > 
> > This means we can remove the flush_work and xfs_flush_inodes() - the
> > VFS functionality completely replaces the internal flush queue for
> > doing this writeback work in a separate context to avoid stack
> > overruns..
> 
> Are the lock ordering issues with writeback_inodes_sb_if_idle sorted out
> by now?  IIRC it still needs to be switch to a trylock.

It never gets called from unmount or freeze context, so I can't see
how it would deadlock in these use cases. It's only when we call
writeback_inodes_sb_if_idle() from a context that already holds
s_umount that the locking it has matters - that's where btrfs and
ext4 have been getting into trouble with this.

> > -			xfs_flush_inodes(ip);
> > +			writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb,
> > +						    WB_REASON_FS_FREE_SPACE);
> 
> I'd prefer to still keep a wrapper for an ugly call like this if we can.

OK, I'll add an inline function to do this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
