Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o593GGop038777 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 22:16:17 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EE09166D7EC
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:54:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	WmhOH4CtLflCoDVj for <xfs@oss.sgi.com>;
	Fri, 30 Jul 2010 03:54:08 -0700 (PDT)
Date: Fri, 30 Jul 2010 20:54:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: ensure we mark all inodes in a freed cluster
	XFS_ISTALE
Message-ID: <20100730105404.GB2126@dastard>
References: <1280444146-14540-1-git-send-email-david@fromorbit.com>
	<1280444146-14540-3-git-send-email-david@fromorbit.com>
	<20100730102746.GA10367@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100730102746.GA10367@infradead.org>
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
Cc: npiggin@kernel.de, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 06:27:46AM -0400, Christoph Hellwig wrote:
> On Fri, Jul 30, 2010 at 08:55:46AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Under heavy load parallel metadata loads (e.g. dbench), we can fail
> > to mark all the inodes in a cluster being freed as XFS_ISTALE as we
> > skip inodes we cannot get the XFS_ILOCK_EXCL or the flush lock on.
> > When this happens and the inode cluster buffer has already been
> > marked stale and freed, inode reclaim can try to write the inode out
> > as it is dirty and not marked stale. This can result in writing th
> > metadata to an freed extent, or in the case it has already
> > been overwritten trigger a magic number check failure and return an
> > EUCLEAN error such as:
> > 
> > Filesystem "ram0": inode 0x442ba1 background reclaim flush failed with 117
> > 
> > Fix this by ensuring that we hoover up all in memory inodes in the
> > cluster and mark them XFS_ISTALE when freeing the cluster.
> 
> Why do you move the loop over the log items around?  From all that
> I can see the original place is much better as we just have to loop
> over the items once.  Then once we look up the inodes in memory
> we skip over the inodes that already are stale, so the behaviour
> should be the same. 

You are right - it is doing the same as the old code where it is
marking them stale first. I rearranged some code when trying
a couple of crazy ideas, but forgot to move it back when I
had somethign that fixed the bug. I'll move it back - that shoul
dmake the diff lots smaller.

> Also instead of the i-- and continue for the
> lock failure an explicit goto retry would make it a lot more obvious.

Good point. I fix it up and test it again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
