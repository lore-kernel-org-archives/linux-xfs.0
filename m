Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q920CtFp218120 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 19:12:55 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nWA1kkV3JxXG5jmn for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 17:14:17 -0700 (PDT)
Date: Tue, 2 Oct 2012 10:14:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121002001403.GK23520@dastard>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<20120928123443.GD14284@infradead.org>
	<20121001174410.GK13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121001174410.GK13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 01, 2012 at 12:44:10PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Fri, Sep 28, 2012 at 08:34:43AM -0400, Christoph Hellwig wrote:
> > >  /*
> > > + * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
> > 
> > slightly too long line.
> 
> It comes out at 78 columns when the patch is applied.  Not a problem.
> 
> > > + * or a page lock.
> > > + */
> > > +static inline void
> > > +xfs_flush_inodes(struct xfs_inode *ip)
> > > +{
> > > +	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
> > > +}
> > 
> > Passing an inode here seems very odd, an xfs_mount would be the proper
> > interface. 
> > 
> > Looks fine modulo these cosmetic changes, so:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I cleaned up these cosmetic changes on your behalf.  Here is the result:

Looks good. Thanks for doing this, Ben.

FWIW, The patch I just posted to change
writeback_inodes_sb_if_idle() to sync_inodes_sb() will need
massaging to apply to your tree now. I'll update it if you push your
tree out to oss.sgi.com before taking it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
