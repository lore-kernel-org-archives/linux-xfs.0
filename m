Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97JdFxB258910 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 14:39:15 -0500
Subject: Re: [PATCH 6/9] xfs: clean up buffer allocation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006210639.521140680@bombadil.infradead.org>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.521140680@bombadil.infradead.org>
Date: Fri, 7 Oct 2011 14:37:04 -0500
Message-ID: <1318016224.2810.44.camel@doink>
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

On Thu, 2011-10-06 at 17:06 -0400, Christoph Hellwig wrote:
> Change _xfs_buf_initialize to allocate the buffer directly and rename it to
> xfs_buf_alloc now that is the only buffer allocation routine.  Also remove
> the xfs_buf_deallocate wrapper around the kmem_zone_free calls for buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
