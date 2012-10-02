Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92Jcc2u081348 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 14:38:38 -0500
Date: Tue, 2 Oct 2012 14:39:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121002193959.GM13214@sgi.com>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<20120928123443.GD14284@infradead.org>
	<20121001174410.GK13214@sgi.com> <20121002001403.GK23520@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121002001403.GK23520@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Dave,

On Tue, Oct 02, 2012 at 10:14:03AM +1000, Dave Chinner wrote:
> On Mon, Oct 01, 2012 at 12:44:10PM -0500, Ben Myers wrote:
> > Hi Dave,
> > 
> > On Fri, Sep 28, 2012 at 08:34:43AM -0400, Christoph Hellwig wrote:
> > > >  /*
> > > > + * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
> > > 
> > > slightly too long line.
> > 
> > It comes out at 78 columns when the patch is applied.  Not a problem.
> > 
> > > > + * or a page lock.
> > > > + */
> > > > +static inline void
> > > > +xfs_flush_inodes(struct xfs_inode *ip)
> > > > +{
> > > > +	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
> > > > +}
> > > 
> > > Passing an inode here seems very odd, an xfs_mount would be the proper
> > > interface. 
> > > 
> > > Looks fine modulo these cosmetic changes, so:
> > >
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > I cleaned up these cosmetic changes on your behalf.  Here is the result:
> 
> Looks good. Thanks for doing this, Ben.

No problem.  I wanted to pull this in before the merge window opened.
Otherwise I'd have let you go after it.

> FWIW, The patch I just posted to change
> writeback_inodes_sb_if_idle() to sync_inodes_sb() will need
> massaging to apply to your tree now. I'll update it if you push your
> tree out to oss.sgi.com before taking it...

Sure.  You can find it here:

git://oss.sgi.com/xfs/xfs.git, tmp-for-dave-worker-changes branch

Can you repost the full patch rather than a delta?  That would be cleaner.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
