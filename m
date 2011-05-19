Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JLsUo4055980 for <xfs@oss.sgi.com>; Thu, 19 May 2011 16:54:30 -0500
Subject: Re: [PATCH 2/4] xfs: do not discard alloc btree blocks
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110504190011.319521066@bombadil.infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.319521066@bombadil.infradead.org>
Date: Thu, 19 May 2011 16:54:29 -0500
Message-ID: <1305842069.2825.88.camel@doink>
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

On Wed, 2011-05-04 at 14:55 -0400, Christoph Hellwig wrote:
> Blocks for the allocation btree are allocated from and release to
> the AGFL, and thus frequently reused.  Even worse we do not have
> an easy way to avoid using an AGFL block when it is discarded due
> to the simple FILO list of free blocks, and thus can frequently
> stall on blocks that are currently undergoing a discard.
> 
> Add a flag to the busy extent tracking structure to skip the discard for
> allocation btree blocks.  In normal operation these blocks are reused
> frequently enough that there is no need to discard them anyway, but
> if they spill over to the allocation btree as part of a balance we
> "leak" blocks that we would otherwise discard.  We could fix this
> by adding another flag and keeping these block in the rbtree even
> after they aren't busy any more so that we could discard them when
> they migrate out of the AGFL.  Given that this would cause significant
> overhead I don't think it's worthwile for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This one looks good.  (If you add support for discard
with nodelaylog it will need to be updated.)

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
