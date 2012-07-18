Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HMhjmq118698 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 17:43:45 -0500
Date: Tue, 17 Jul 2012 22:40:21 -0300 (BRT)
Message-Id: <20120717.224021.707783566146599004.pcacjr@zytor.com>
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
From: Paulo Alcantara <pcacjr@zytor.com>
In-Reply-To: <20120717070643.GA4958@infradead.org>
References: <20120716151038.GI29979@sgi.com>
	<5292013E-6FF3-47F6-BE9F-FD7BA2BB2AA9@gmail.com>
	<20120717070643.GA4958@infradead.org>
Mime-Version: 1.0
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
To: hch@infradead.org
Cc: baozich@gmail.com, xfs@oss.sgi.com, bpm@sgi.com, linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 17 Jul 2012 03:06:43 -0400

> Btw, if you need more reviers for the syslinus support feel free to pass
> it by me (or the list).

This is the branch I'm maintaing for the XFS readonly driver:

git://zytor.com/users/pcacjr/syslinux.git (branch: xfs)

The current status is:

    - We are able to find the root inode by reading rootino field from
      superblock (xfs_iget_root() function).
    - We are able to find inodes that have core's format set to "local" only at
      the moment, which is by reading leaf entries from inode btrees. The
      function that looks up for an inode is the xfs_iget() one. We're looking
      forward to implement the handling of keys in inode btrees (extents) also.

Baoszi is currently working on the inode btree's key part (extents), and I'm
working on the data part of the file inode, which is the xfs_next_extent()
function.

The xfs_next_extent() function must be able to read the inode (cast to the data
fork) and populate a structure that stores physical starting number sector and
number of consecutive sectors that contain the inode's data so that Syslinux
will know where to read from.

Thanks for the interest in helping us!


		Paulo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
