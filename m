Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QC4Hjm157816 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 07:04:17 -0500
Subject: Re: [PATCH] xfs: XFS_TRANS_SWAPEXT is not a valid flag for
	xfs_trans_commit
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110926091434.GA6575@infradead.org>
References: <20110926091434.GA6575@infradead.org>
Date: Mon, 26 Sep 2011 07:04:12 -0500
Message-ID: <1317038652.3030.9.camel@doink>
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

On Mon, 2011-09-26 at 05:14 -0400, Christoph Hellwig wrote:
> XFS_TRANS_SWAPEXT is a transaction type, not a flag for xfs_trans_commit, so
> don't pass it in xfs_swap_extents.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
