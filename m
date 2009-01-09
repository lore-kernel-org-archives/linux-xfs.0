Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n091gmmu031519 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 19:42:48 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44958120CD08
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 17:42:46 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	rG2DqNK6Oe2gTU9A for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 17:42:46 -0800 (PST)
Date: Fri, 9 Jan 2009 11:46:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109004609.GM9448@disturbed>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090108215602.GA24479@dth.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jan 08, 2009 at 10:56:02PM +0100, Danny ter Haar wrote:
> 
> I needed the parallel port driver so i compiled 2.6.28-git3 with debug info.
> It barfed: http://www.dth.net/kernel/c3/netconsole_2.6.28-git3-d.txt

Looking at this, I think there are two possibilities in terms of the
problem being detected. We are modifying the inode BMBT here,
so that means we have XFS_BTREE_ROOT_IN_INODE set. The corruption
trigger has occurred because a xfs_btree_increment() call has
returned a zero status. This means we failed here:

1324         /* Fail if we just went off the right edge of the tree. */
1325         xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
1326         if (xfs_btree_ptr_is_null(cur, &ptr))
1327                 goto out0;

or here:

1351         /*
1352          * If we went off the root then we are either seriously
1353          * confused or have the tree root in an inode.
1354          */
1355         if (lev == cur->bc_nlevels) {
1356                 if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
1357                         goto out0;
1358                 ASSERT(0);

i.e. we either fell off the right edge of the tree or went over the top
of it.

I can't really see how we've done either of those things unless the
tree has been corrupted by a prior operation.

Given that each time it is aptitude that is causing the problem, can you
prevent aptitude from running automatically on boot and run it manually?
If you can reporduce the problem manually then we can move on to the
next step....

> So (in my case) something while going from git2 -> git3 didn't go positive.

That would have been when Linus did the XFS pull...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
