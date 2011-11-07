Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7KFBmt074789 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:15:11 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A10B22675C
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 12:15:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qUtqJWoC9rGPYxxy for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 12:15:08 -0800 (PST)
Date: Tue, 8 Nov 2011 07:15:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_getbmap assert
Message-ID: <20111107201505.GE5534@dastard>
References: <20111107103037.GA16213@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111107103037.GA16213@infradead.org>
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

On Mon, Nov 07, 2011 at 05:30:37AM -0500, Christoph Hellwig wrote:
> With Dmitris fsstress updates I can hit the following assert fairly
> regularly:
> 
> [11904.943956] XFS: Assertion failed: ((iflags & BMV_IF_DELALLOC) != 0) ||
> (map[i].br_startblock != DELAYSTARTBLOCK), file:
> /home/hch/work/linux-2.6/fs/xfs/xfs_bmap.c, line: 5604
> 
> which means we get an delalloc extent back from FIEMAP/GETBMAP despite
> asking for a flush beforehand.  While we hold the iolock over the call
> and thus exclude new buffered writers from appearing that doesn't
> prevent shared writeable mmaps from creating new delalloc extents.

Possibly. However, we might actually be tripping over speculative
delalloc regions beyond EOF - flushing will not convert those at
all. There's already a comment earlier on like this:

	/*
	 * even after flushing the inode, there can still be delalloc
	 * blocks on the inode beyond EOF due to speculative
	 * preallocation. These are not removed until the release
	 * function is called or the inode is inactivated. Hence we
	 * cannot assert here that ip->i_delayed_blks == 0.
	 */

Can you see if that is the case that is being triggered?

> I don't think this actually is a real issue, and a workaround would
> be extremly hard.  For now I've just remove the assert in my tree:

Probably the right thing to do, anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
