Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o592nsNW037874 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 21:49:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82191481D7B
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:27:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id n3FjA2jUdFQCMn3v for
	<xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:27:48 -0700 (PDT)
Date: Fri, 30 Jul 2010 06:27:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: ensure we mark all inodes in a freed cluster
	XFS_ISTALE
Message-ID: <20100730102746.GA10367@infradead.org>
References: <1280444146-14540-1-git-send-email-david@fromorbit.com>
	<1280444146-14540-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280444146-14540-3-git-send-email-david@fromorbit.com>
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
Cc: npiggin@kernel.de, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 08:55:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Under heavy load parallel metadata loads (e.g. dbench), we can fail
> to mark all the inodes in a cluster being freed as XFS_ISTALE as we
> skip inodes we cannot get the XFS_ILOCK_EXCL or the flush lock on.
> When this happens and the inode cluster buffer has already been
> marked stale and freed, inode reclaim can try to write the inode out
> as it is dirty and not marked stale. This can result in writing th
> metadata to an freed extent, or in the case it has already
> been overwritten trigger a magic number check failure and return an
> EUCLEAN error such as:
> 
> Filesystem "ram0": inode 0x442ba1 background reclaim flush failed with 117
> 
> Fix this by ensuring that we hoover up all in memory inodes in the
> cluster and mark them XFS_ISTALE when freeing the cluster.

Why do you move the loop over the log items around?  From all that
I can see the original place is much better as we just have to loop
over the items once.  Then once we look up the inodes in memory
we skip over the inodes that already are stale, so the behaviour
should be the same.  Also instead of the i-- and continue for the
lock failure an explicit goto retry would make it a lot more obvious.

The actual change of not skipping inodes looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
