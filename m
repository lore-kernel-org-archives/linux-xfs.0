Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB145PVN169174 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:05:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E64911B7A38
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:07:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	nbzskQE8ZEp0Zwa2 for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:07:07 -0800 (PST)
Date: Wed, 1 Dec 2010 15:07:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/10] xfs: a few small tweaks for overwrites in
	xfs_vm_writepage
Message-ID: <20101201040704.GD16922@dastard>
References: <20101122130506.868076797@bombadil.infradead.org>
	<20101122130903.533699161@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122130903.533699161@bombadil.infradead.org>
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

On Mon, Nov 22, 2010 at 08:05:09AM -0500, Christoph Hellwig wrote:
> Don't trylock the buffer.  We are the only one ever locking it for
> a regular file address space, and trylock was only copied from the
> generic code which did it due to the old buffer based writeout in
> jbd.  Also make sure to only write out the buffer if the iomap
> actually is valid, because we wouldn't have a proper mapping
> otherwise.  In practice we will never get an invalid mapping here
> as the page lock guarantees truncate doesn't race with us, but
> better be safe than sorry.  Also make sure we allocate a new ioend
> when crossing boundaries between mappings, just like we do for
> delalloc and unwritten extents.  Again this currently doesn't
> matter as the I/O end handler only cares for the boundaries for
> unwritten extents, but this makes the code fully correct and the
> same as for delalloc/unwritten extents.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
