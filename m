Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02CDxrI105153 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 06:13:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 423961DAB7C4
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 04:14:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	dZCLDBgszggFFOVK for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 04:14:47 -0800 (PST)
Date: Sat, 2 Jan 2010 23:14:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Don't flush stale inodes
Message-ID: <20100102121444.GH13802@discord.disaster>
References: <1262399980-19277-1-git-send-email-david@fromorbit.com>
	<20100102120053.GB18502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102120053.GB18502@infradead.org>
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

On Sat, Jan 02, 2010 at 07:00:53AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 02, 2010 at 01:39:40PM +1100, Dave Chinner wrote:
> > Because inodes remain in cache much longer than inode buffers do
> > under memory pressure, we can get the situation where we have stale,
> > dirty inodes being reclaimed but the backing storage has been freed.
> > Hence we should never, ever flush XFS_ISTALE inodes to disk as
> > there is no guarantee that the backing buffer is in cache and
> > still marked stale when the flush occurs.
> 
> We should not flush stale inodes.  But how do we even end up calling
> xfs_iflush with a stale inode?

xfs_reclaim_inode() -> xfs_iflush() according to the stack traces
that found bad inode magic numbers in xfs_itobp().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
