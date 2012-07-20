Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K1qdFs066167 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 20:52:39 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9y2er21GhGtKLEVz for <xfs@oss.sgi.com>;
	Thu, 19 Jul 2012 18:52:38 -0700 (PDT)
Date: Fri, 20 Jul 2012 11:52:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Message-ID: <20120720015226.GJ23387@dastard>
References: <20120716151038.GI29979@sgi.com>
	<5292013E-6FF3-47F6-BE9F-FD7BA2BB2AA9@gmail.com>
	<20120717070643.GA4958@infradead.org>
	<20120717.224021.707783566146599004.pcacjr@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120717.224021.707783566146599004.pcacjr@zytor.com>
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
To: Paulo Alcantara <pcacjr@zytor.com>
Cc: hch@infradead.org, baozich@gmail.com, xfs@oss.sgi.com, bpm@sgi.com, linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 10:40:21PM -0300, Paulo Alcantara wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Tue, 17 Jul 2012 03:06:43 -0400
> 
> > Btw, if you need more reviers for the syslinus support feel free to pass
> > it by me (or the list).
> 
> This is the branch I'm maintaing for the XFS readonly driver:
> 
> git://zytor.com/users/pcacjr/syslinux.git (branch: xfs)
> 
> The current status is:
> 
>     - We are able to find the root inode by reading rootino field from
>       superblock (xfs_iget_root() function).
>     - We are able to find inodes that have core's format set to "local" only at
>       the moment, which is by reading leaf entries from inode btrees. The
>       function that looks up for an inode is the xfs_iget() one. We're looking
>       forward to implement the handling of keys in inode btrees (extents) also.
> 
> Baoszi is currently working on the inode btree's key part (extents), and I'm
> working on the data part of the file inode, which is the xfs_next_extent()
> function.
> 
> The xfs_next_extent() function must be able to read the inode (cast to the data
> fork) and populate a structure that stores physical starting number sector and
> number of consecutive sectors that contain the inode's data so that Syslinux
> will know where to read from.

As we discussed on #xfs, I'm still not convinced that parsing the
filesystem metadata in the bootloader is the way to go. Far better,
IMO, is simply to supply the bootloader with a list of extents for
the blocks it needs to read to get the files it needs. You can get
them via fiemap(), and it'll work for XFS, btrfs, ext3, ext4, etc
without needing to write code to parse the on-disk format of every
filesystem.

Especially as we are in the process of making major changes to the
XFS on-disk format, which means you'll have to make significant
changes to support a second XFS disk format in the not-to-distant
future...

> Thanks for the interest in helping us!

We want it to work! ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
