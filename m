Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U2WQmR188112 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 21:32:27 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GROlHG7m4cf09kL5 for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 19:32:25 -0700 (PDT)
Date: Mon, 30 Apr 2012 12:31:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 31/37] xfs: move xfs_fsb_to_db to xfs_bmap.h
Message-ID: <20120430023132.GB7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-32-git-send-email-david@fromorbit.com>
	<20120429215300.GJ19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429215300.GJ19889@infradead.org>
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

On Sun, Apr 29, 2012 at 05:53:00PM -0400, Christoph Hellwig wrote:
> On Mon, Apr 23, 2012 at 03:59:01PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This is the only remaining useful function in xfs_rw.h, so move it
> 
> Well, xfs_get_extsz_hint also still is useful, and you only move it in
> the next patch.

Ok, the only remaining useful -inline- function. :)

> > +/*
> > + * Convert the given file system block to a disk block.  We have to treat it
> > + * differently based on whether the file is a real time file or not, because the
> > + * bmap code does.
> > + */
> 
> Might be worth alaborating why exactly.  When I last looked over it I
> couldn't make much sense of it.

realtime device is a flat filesysetm block address space - it has to
be for a bitmap allocator to work - but the data device is a sparse
address space. I'll add that to the comment.

> 
> > +xfs_daddr_t
> > +xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
> > +{
> > +	return (XFS_IS_REALTIME_INODE(ip) ? \
> > +		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
> > +		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
> > +}
> 
> Might be worth to "demacrofy" it while you're at it, e.g. rewrite it as:

*nod*. Will do.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
