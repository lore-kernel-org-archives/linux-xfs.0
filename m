Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 20F9B7CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 03:30:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0115F304032
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:30:45 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	I5wQilMc71n3YGp9 for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2016 01:30:43 -0800 (PST)
Date: Wed, 17 Feb 2016 20:30:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/15] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160217093041.GH19486@dastard>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-12-git-send-email-david@fromorbit.com>
	<20160217073204.GB16363@infradead.org>
	<20160217074821.GD19486@dastard> <20160217083000.GG19486@dastard>
	<20160217083308.GA11766@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217083308.GA11766@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 17, 2016 at 12:33:08AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 17, 2016 at 07:30:00PM +1100, Dave Chinner wrote:
> > > Yeah, probably. I'll have to look at this a bit closer - I think I
> > > assumed that we're always going to have v2 inode format here (like
> > > we do in the kernel), but that may not be true. I'll have a closer
> > > look.
> > 
> > having a closer look, the XFS_SB_VERSION_NLINKBIT that is set here
> > in sbversion is never used, so I just removed it. I also changed it
> > back to using the converted in-memory link count so it's always
> > going to be correct now. Now it is just:
> > 
> > +       setlink_inode(id, xino.i_d.di_nlink, type == DBM_DIR, security);
> 
> Great.  With that and the other nitpicks address:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> for the whole series.

Thanks for the fast turnaround, Christoph! I'll get this
pushed out in the morning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
