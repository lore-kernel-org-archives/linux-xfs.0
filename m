Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8TGxpN3204183 for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 11:59:51 -0500
Subject: Re: [PATCH 1/3] xfs: unlock the inode before log force in xfs_fsync
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110918204909.860669185@bombadil.infradead.org>
References: <20110918204748.547510183@bombadil.infradead.org>
	<20110918204909.860669185@bombadil.infradead.org>
Date: Thu, 29 Sep 2011 11:59:45 -0500
Message-ID: <1317315585.3049.30.camel@doink>
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

On Sun, 2011-09-18 at 16:47 -0400, Christoph Hellwig wrote:
> Only read the LSN we need to push to with the ilock held, and then release
> it before we do the log force to improve concurrency.
> 
> This also removes the only direct caller of _xfs_trans_commit, thus
> allowing it to be merged into the plain xfs_trans_commit again.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

The idea here is that once the transaction is committed
(which also sets the LSN to use), everything we need to
know about any changes are in the log so there's no need
to prevent others from moving on from that point--allowing
the inode to (transactionally) change to a new state--while
the log gets forced out.  Right?

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
