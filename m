Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB14dsEr172146 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:39:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DD8C1402E22
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:41:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	QKh2RIV9vfDjTWMn for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:41:36 -0800 (PST)
Date: Wed, 1 Dec 2010 15:41:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfs: simplify xfs_map_blocks
Message-ID: <20101201044131.GG16922@dastard>
References: <20101122130506.868076797@bombadil.infradead.org>
	<20101122130904.122411257@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122130904.122411257@bombadil.infradead.org>
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

On Mon, Nov 22, 2010 at 08:05:12AM -0500, Christoph Hellwig wrote:
> No need to lock the extent map exclusive when performing an overwrite,
> we know the extent map must already have been loaded by get_blocks.
> Apply the non-blocking inode semantics to all mapping types instead of
> just delayed allocations.  Remove the handling of not yet allocated
> blocks for the IO_UNWRITTEN case - if an extent is marked as delayed
> allocated in the buffer it must already have an extent on disk.

I think your meant "marked as unwritten in the buffer" there.

> Add asserts to verify all the assumptions above in debug builds.

Nice - I would have asked that to be added ;)

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. It is much simpler now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
