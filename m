Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97JdChw258893 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 14:39:12 -0500
Subject: Re: [PATCH 5/9] xfs: remove buffers from the delwri list in
	xfs_buf_stale
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006210639.352441913@bombadil.infradead.org>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.352441913@bombadil.infradead.org>
Date: Fri, 7 Oct 2011 14:36:59 -0500
Message-ID: <1318016219.2810.43.camel@doink>
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
> For each call to xfs_buf_stale we call xfs_buf_delwri_dequeue either
> directly before or after it, or are guaranteed by the surrounding
> conditionals that we are never called on delwri buffers.  Simply
> this situation by moving the call to xfs_buf_delwri_dequeue into
> xfs_buf_stale.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I see 6 or so spots where xfs_buf_stale() is (was) called with no call
to xfs_buf_delwri_dequeue().  This adds such a call, but it looks to me
like that's OK.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
