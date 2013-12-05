Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94A127F6F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:37:40 -0600 (CST)
Date: Thu, 5 Dec 2013 14:37:37 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/5] xfs: take the ilock around xfs_bmapi_read in
	xfs_zero_remaining_bytes
Message-ID: <20131205203737.GM1935@sgi.com>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.199565525@bombadil.infradead.org>
	<20131205203115.GA29897@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205203115.GA29897@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 07:31:15AM +1100, Dave Chinner wrote:
> On Thu, Dec 05, 2013 at 07:58:31AM -0800, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: xfs/fs/xfs/xfs_bmap_util.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-05 11:37:57.791685284 +0100
> > +++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-05 11:39:43.599683113 +0100
> > @@ -1147,6 +1147,7 @@ xfs_zero_remaining_bytes(
> >  	xfs_mount_t		*mp = ip->i_mount;
> >  	int			nimap;
> >  	int			error = 0;
> > +	uint			lock_mode;
> >  
> >  	/*
> >  	 * Avoid doing I/O beyond eof - it's not necessary
> > @@ -1159,11 +1160,15 @@ xfs_zero_remaining_bytes(
> >  	if (endoff > XFS_ISIZE(ip))
> >  		endoff = XFS_ISIZE(ip);
> >  
> > +	lock_mode = xfs_ilock_map_shared(ip);
> > +
> >  	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
> >  					mp->m_rtdev_targp : mp->m_ddev_targp,
> >  				  BTOBB(mp->m_sb.sb_blocksize), 0);
> 
> This now holds the ilock over data IO, which is not allowed to be
> done as data IO completion can require the ilock to be taken. Yes,
> the code specifically avoids all these problems, but the general
> rule is that ilock is only held over metadata IO operations, not
> data IO. If we need data IO serialisation, then we use the iolock.
> 
> So, while this protects the extent tree, it also violates other
> long-standing conventions for locking. Given that the code is
> special, I'mnot opposed to making a special rule for this one
> function, but it needs to be commented as to why this is a valid
> thing to do in this function....

Maybe it would be better if the ilock could be taken and dropped within the
loop.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
