Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MMS4iB052856 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 17:28:10 -0500
Subject: Re: [PATCH 2/6] xfs: do not immediately reuse busy extent ranges
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200137.474878707@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.474878707@bombadil.infradead.org>
Date: Tue, 22 Mar 2011 17:30:59 -0500
Message-ID: <1300833059.2875.276.camel@doink>
Mime-Version: 1.0
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

On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-skip-busy-extents)
> Every time we reallocate a busy extent, we cause a synchronous log force
> to occur to ensure the freeing transaction is on disk before we continue
> and use the newly allocated extent.  This is extremely sub-optimal as we
> have to mark every transaction with blocks that get reused as synchronous.
> 
> Instead of searching the busy extent list after deciding on the extent to
> allocate, check each candidate extent during the allocation decisions as
> to whether they are in the busy list.  If they are in the busy list, we
> trim the busy range out of the extent we have found and determine if that
> trimmed range is still OK for allocation. In many cases, this check can
> be incorporated into the allocation extent alignment code which already
> does trimming of the found extent before determining if it is a valid
> candidate for allocation.
> 
> Based on two earlier patches from Dave Chinner.

Again, this looks nearly identical to your last version.
On that one, I suggested rewording a comment, and you
said "ok."  You did not do so in this version, which I
guess is fine.  I just want to know whether you intended
to.  If so I'll give you a chance to post an update; if
not I can take this one as-is.

(I think I'll have the rest of the series reviewed tomorrow.)

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
