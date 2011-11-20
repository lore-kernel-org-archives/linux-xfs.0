Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAK8Xojt139078 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 02:33:50 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2C482659C2
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 00:33:48 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aMcYLFQmHQwa9ZrH for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 00:33:48 -0800 (PST)
Date: Sun, 20 Nov 2011 19:33:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: force buffer writeback before blocking on the ilock
	in inode reclaim
Message-ID: <20111120083345.GO7046@dastard>
References: <20111120072334.GA27386@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111120072334.GA27386@infradead.org>
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

On Sun, Nov 20, 2011 at 02:23:34AM -0500, Christoph Hellwig wrote:
> If we are doing synchronous inode reclaim we block the VM from making
> progress in memory reclaim.  So if we encouter a flush locked inode
> make sure we force out all delayed buffers ASAP to speed up the wait
> for it to be unlocked.  Without this we can get hangs of up to 30
> seconds during workloads hitting synchronous inode reclaim.

I don't think we need to push out all delayed buffers - that's an
awfully big sledge hammer to get a single buffer moving. Indeed, we
already have a mechanism for dealing with this problem -
xfs_buf_delwri_promote() - when we hit it during AIL flushing.

IOWs, we only need to promote the buffer the inode sits in and kick
xfsbufd. that is, something like:

        bp = xfs_incore(ip->i_mount->m_ddev_targp, iip->ili_format.ilf_blkno,
                        iip->ili_format.ilf_len, XBF_TRYLOCK);
        if (bp && XFS_BUF_ISDELAYWRITE(bp)) {
                xfs_buf_delwri_promote(bp);
		wake_up_process(mp->m_ddev_targp->bt_task);
	}
	if (bp)
		xfs_buf_relse(bp);


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
