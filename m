Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU4apnB028761 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 22:36:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC5801C81491
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:38:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	zWImxhMgSb7Xr5AS for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 20:38:32 -0800 (PST)
Date: Tue, 30 Nov 2010 15:38:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: demultiplex xfs_icsb_modify_counters()
Message-ID: <20101130043817.GE3556@dastard>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	<1290991002-18680-4-git-send-email-david@fromorbit.com>
	<20101129091920.GB13902@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101129091920.GB13902@infradead.org>
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
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 04:19:20AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 11:36:41AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With the conversion to percpu counters, xfs_icsb_modify_counters() really does
> > not need to exist. Convert the inode counter modifications to use a common
> > helper function for the one place that calls them, and add another function for
> > the free block modification and convert all the callers to use that.
> 
> > +xfs_icsb_modify_inodes(
> > +	xfs_mount_t	*mp,
> 
> struct xfs_mount, please.
> 
> > +	int		cntr,
> > +	int64_t		delta,
> > +	int		rsvd)
> 
> the rsvd argument isn't used at all.
> 
> > +{
> > +	int		ret = 0;
> > +
> > +	ASSERT(cntr == XFS_ICSB_ICOUNT || cntr == XFS_ICSB_IFREE);
> > +
> > +	ret = xfs_icsb_add(mp, cntr, delta, 0);
> > +	if (ret < 0) {
> > +		ASSERT(0);
> > +		return XFS_ERROR(EINVAL);
> > +	}
> > +	return 0;
> 
> You could get rdif of the ret argument as we don't care about the
> value.  I also don't think we need the assert here - the caller already
> does one for us.
> 
> > +xfs_icsb_modify_free_blocks(
> > +	xfs_mount_t	*mp,
> 
> same here.

Ok, makes sense. I'll clean it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
