Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13BS8cS225113 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 05:28:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D77501C9C7BE
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 03:29:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gH8pBKwlpsyEgUpg for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 03:29:17 -0800 (PST)
Date: Wed, 3 Feb 2010 06:29:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] xfs: move the inode locking outside xfs_fsync()
Message-ID: <20100203112917.GB19996@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265153104-29680-9-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 10:25:02AM +1100, Dave Chinner wrote:
> We have a need for a delayed write inode flush operation
> to be made atomically with an fsync to avoid physically
> writing inodes but still keeping inode buffer information
> up to date for bulkstat.
> 
> Move the inode locking outside xfs_fsync() to allow this to
> be done.

What's the point of the lock_flags argument?  It should always
be IOLOCK_SHARED, so instead of passing it in as an argument
I'd rather add an assert to enforce it.

For more comments on if this is the right functionality to use
in write_inode see my comment to the next patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
