Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P2J37q109500 for <xfs@oss.sgi.com>; Tue, 24 May 2011 21:19:03 -0500
Subject: Re: [PATCH 2/4] xfs: remove the unused ilock_nowait codepath in
	writepage
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110428130514.335250421@bombadil.infradead.org>
References: <20110428125546.696493391@bombadil.infradead.org>
	<20110428130514.335250421@bombadil.infradead.org>
Date: Tue, 24 May 2011 21:18:57 -0500
Message-ID: <1306289937.2823.121.camel@doink>
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

On Thu, 2011-04-28 at 08:55 -0400, Christoph Hellwig wrote:
> wbc->nonblocking is never set, so this whole code has been unreachable
> for a long time.  I'm also not sure it would make a lot of sense -
> we'd rather finish our writeout after a short wait for the ilock
> instead of cancelling the whole ioend.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

I'll continue tomorrow on the next one; it'll take a
bit more time to review.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
