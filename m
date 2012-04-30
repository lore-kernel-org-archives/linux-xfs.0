Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U2cOTa189010 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 21:38:24 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2YH5wc5tj4FJXYdp for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 19:38:23 -0700 (PDT)
Date: Mon, 30 Apr 2012 12:38:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 33/37] xfs: move xfs_do_force_shutdown() and kill xfs_rw.c
Message-ID: <20120430023821.GC7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-34-git-send-email-david@fromorbit.com>
	<20120429215420.GL19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429215420.GL19889@infradead.org>
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

On Sun, Apr 29, 2012 at 05:54:20PM -0400, Christoph Hellwig wrote:
> On Mon, Apr 23, 2012 at 03:59:03PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs-do-force_shutdown now is the only thing in xfs_rw.c. There is no
> > need to keep it in it's own file anymore, so move it to xfs_fsops.c
> > next to xfs_fs_goingdown() and kill xfs_rw.c.
> 
> To me xfs_mount.c seems like the more reasonable place.

It is not used in userspace, so rather than place it in a file that
userspace shares (xfs_mount.c) and have to deal with that every
merge, I moved it to a file that is not shared with userspace.
Placing it with other shutdown code (xfs_fs_goingdown()) seemed like
a reasonable thing to do...

> Either way killing xfs_rw.c is a good thing.

*nod*

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
