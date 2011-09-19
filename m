Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JHXOrq003740 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 12:33:24 -0500
Subject: Re: [PATCH] xfs: fix buffer flushing during unmount
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110914140826.GA25729@infradead.org>
References: <20110914140826.GA25729@infradead.org>
Date: Mon, 19 Sep 2011 12:33:20 -0500
Message-ID: <1316453600.2941.37.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-09-14 at 10:08 -0400, Christoph Hellwig wrote:
> The code to flush buffers in the umount code is a bit iffy: we first flush
> all delwri buffers out, but then might be able to queue up a new one when
> logging the sb counts.  On a normal shutdown that one would get flushed
> out when doing the synchronous superblock write in xfs_unmountfs_writesb,
> but we skip that one if the filesystem has been shut down.
> 
> Fix this by moving the delwri list flushing until just before unmounting
> the log, and while we're at it also remove the superflous delwri list
> and buffer lru flusing for the rt and log device that can never have
> cached or delwri buffers.

What prevents blocks on a realtime device from being cached?

I haven't looked exhaustively, but it looks like the summary
and bitmap data are operated on without caching, but the
realtime data itself is treated no different from "normal"
data blocks.

Please correct me if I'm wrong about that.

I do agree about the log device not having delwri cached
buffers.  Still, it might be good to have this change
done in a different commit from the one that changes
the order of things in xfs_unmountfs().

					-Alex


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Tested-by: Amit Sahrawat <amit.sahrawat83@gmail.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
